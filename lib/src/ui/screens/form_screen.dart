import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../api/api_exception.dart';
import '../../api/models.dart';
import '../../image/screenshot.dart';
import '../../l10n/generated/featurely_localizations.dart';
import '../../metadata.dart';
import '../../theme.dart';
import '../scope.dart';
import '../widgets/primary_button.dart';
import '../widgets/state_views.dart';
import 'success_screen.dart';

/// How many characters may remain before the live title counter shows.
const int _counterThreshold = 10;

/// Remaining title characters, counted in Unicode grapheme clusters (via
/// `String.characters`) to match the server's character-not-byte rule.
int remainingTitleCharacters(String text, int max) =>
    max - text.characters.length;

/// The submit form: Feature/Issue segmented control, title with live
/// counter, description, optional email, one screenshot slot, and a pinned
/// Submit button. The draft lives in memory only — closing the sheet
/// discards it, but failures preserve it.
class FormScreen extends StatefulWidget {
  /// Creates the form.
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

enum _SubmitPhase { idle, sending, failed, rateLimited }

class _FormScreenState extends State<FormScreen> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _email = TextEditingController();

  FeedbackType _type = FeedbackType.feature;
  Uint8List? _screenshotBytes;
  String? _screenshotContentType;
  bool _attachFailed = false;
  bool _emailInvalid = false;
  _SubmitPhase _phase = _SubmitPhase.idle;
  Timer? _rateLimitTimer;

  @override
  void initState() {
    super.initState();
    _title.addListener(_onChanged);
    _description.addListener(_onChanged);
  }

  @override
  void dispose() {
    _rateLimitTimer?.cancel();
    _title.dispose();
    _description.dispose();
    _email.dispose();
    super.dispose();
  }

  void _onChanged() => setState(() {});

  bool get _valid =>
      _title.text.trim().isNotEmpty && _description.text.trim().isNotEmpty;

  Future<void> _pickScreenshot() async {
    final scope = FeaturelyScope.read(context);
    final maxBytes =
        scope.config.value?.attachmentMaxBytes ?? const SdkConfig.defaults().attachmentMaxBytes;
    // Photo library only — no camera.
    final XFile? picked;
    try {
      picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    } catch (_) {
      setState(() => _attachFailed = true);
      return;
    }
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    // Magic-byte validation; HEIC and friends are re-encoded to PNG.
    final prepared = await prepareScreenshot(bytes);
    if (!mounted) return;
    if (prepared == null || prepared.bytes.length > maxBytes) {
      // Rejected client-side before upload (undecodable or over the
      // instance's attachmentMaxBytes limit).
      setState(() => _attachFailed = true);
      return;
    }
    setState(() {
      _screenshotBytes = prepared.bytes;
      _screenshotContentType = prepared.contentType;
      _attachFailed = false;
    });
  }

  void _removeScreenshot() => setState(() {
        _screenshotBytes = null;
        _screenshotContentType = null;
        _attachFailed = false;
      });

  Future<void> _submit() async {
    final scope = FeaturelyScope.read(context);
    final navigator = Navigator.of(context);
    setState(() {
      _phase = _SubmitPhase.sending;
      _emailInvalid = false;
    });
    try {
      final metadata = await scope.core.metadata.capture();
      final plan = scope.core.plan;
      await scope.core.api.submitFeedback(
        title: _title.text.trim(),
        description: _description.text.trim(),
        type: _type,
        email: _email.text.trim(),
        metadata: {
          ...metadata,
          if (plan != null && plan.isNotEmpty)
            'plan': DeviceMetadata.truncate(plan),
          'resolvedLocale': scope.localeTag,
        },
        screenshotBytes: _screenshotBytes,
        screenshotContentType: _screenshotContentType,
      );
      // A 201 is never retried — even `hasAttachment: false` after an
      // uploaded file is success (the contract's partial-failure note).
      if (!mounted) return;
      unawaited(
        navigator.pushReplacement(
          MaterialPageRoute<void>(builder: (_) => const SuccessScreen()),
        ),
      );
    } on FeaturelyApiException catch (error) {
      if (!mounted) return;
      switch (error.code) {
        case FeaturelyErrorCode.invalidEmail:
          // Validation 4xx is a field error, not a retry.
          setState(() {
            _phase = _SubmitPhase.idle;
            _emailInvalid = true;
          });
        case FeaturelyErrorCode.attachmentNotImage:
        case FeaturelyErrorCode.attachmentTooLarge:
          setState(() {
            _phase = _SubmitPhase.idle;
            _attachFailed = true;
          });
        case FeaturelyErrorCode.rateLimited:
          // Honor retry-after: never auto-retry, re-enable when it elapses.
          setState(() => _phase = _SubmitPhase.rateLimited);
          _rateLimitTimer?.cancel();
          _rateLimitTimer = Timer(
            error.retryAfter ?? const Duration(seconds: 30),
            () {
              if (mounted) setState(() => _phase = _SubmitPhase.failed);
            },
          );
        case FeaturelyErrorCode.internalError:
        case FeaturelyErrorCode.unknown:
          setState(() => _phase = _SubmitPhase.failed);
        default:
          // Other validation 4xx (invalid_title/description/type) should be
          // impossible given client-side validation; surface as retryable
          // is wrong, so treat as a generic non-retry failure state.
          setState(() => _phase = _SubmitPhase.failed);
      }
    } catch (_) {
      // Transport failure: draft is preserved, button relabels "Try again".
      if (!mounted) return;
      setState(() => _phase = _SubmitPhase.failed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scope = FeaturelyScope.of(context);
    final strings = FeaturelyLocalizations.of(context);
    final theme = scope.theme;
    final config = scope.config.value ?? const SdkConfig.defaults();
    final appName = scope.appName;

    final remaining = remainingTitleCharacters(_title.text, config.titleMax);
    final showCounter =
        remaining <= _counterThreshold && _title.text.isNotEmpty;

    final String submitLabel;
    switch (_phase) {
      case _SubmitPhase.idle:
        submitLabel = strings.sdkFormSubmit;
      case _SubmitPhase.sending:
        submitLabel = strings.sdkFormSending;
      case _SubmitPhase.failed:
      case _SubmitPhase.rateLimited:
        submitLabel = strings.sdkFormTryAgain;
    }

    return Material(
      color: theme.background,
      child: SafeArea(
        top: false,
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(8, 12, 8, 8),
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          strings.sdkCommonCancel,
                          style: TextStyle(fontSize: 15, color: theme.accent),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          strings.sdkListNewFeedback,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: theme.textPrimary,
                          ),
                        ),
                      ),
                      // Balances the leading Cancel button.
                      const SizedBox(width: 64),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
                    children: [
                      _FieldLabel(strings.sdkFormTypeLabel),
                      _TypeControl(
                        type: _type,
                        onChanged: (type) => setState(() => _type = type),
                      ),
                      const SizedBox(height: 14),
                      _FieldLabel(strings.sdkFormTitleLabel),
                      TextField(
                        controller: _title,
                        inputFormatters: [
                          // Grapheme-aware: counts characters, not UTF-16
                          // units, matching the server's rule.
                          LengthLimitingTextInputFormatter(
                            config.titleMax,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          ),
                        ],
                        decoration: _fieldDecoration(
                          theme,
                          hint: strings.sdkFormTitlePlaceholder,
                        ),
                        style:
                            TextStyle(fontSize: 15, color: theme.textPrimary),
                      ),
                      if (showCounter)
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            strings.sdkFormTitleCounter(
                              remaining < 0 ? 0 : remaining,
                            ),
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.textTertiary,
                            ),
                          ),
                        ),
                      const SizedBox(height: 14),
                      _FieldLabel(strings.sdkFormDescriptionLabel),
                      TextField(
                        controller: _description,
                        minLines: 5,
                        maxLines: 10,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(
                            config.descriptionMax,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          ),
                        ],
                        decoration: _fieldDecoration(
                          theme,
                          hint: _type == FeedbackType.feature
                              ? strings
                                  .sdkFormDescriptionPlaceholderFeature(appName)
                                  .replaceAll('  ', ' ')
                              : strings
                                  .sdkFormDescriptionPlaceholderIssue(appName)
                                  .replaceAll('  ', ' '),
                        ),
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.5,
                          color: theme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 14),
                      _FieldLabel(strings.sdkFormEmailLabel),
                      TextField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        decoration: _fieldDecoration(theme, hint: null),
                        style:
                            TextStyle(fontSize: 15, color: theme.textPrimary),
                        onChanged: (_) {
                          if (_emailInvalid) {
                            setState(() => _emailInvalid = false);
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          _emailInvalid
                              ? strings.sdkFormEmailError
                              : strings.sdkFormEmailHelper,
                          style: TextStyle(
                            fontSize: 12,
                            color: _emailInvalid
                                ? theme.errorForeground
                                : theme.textTertiary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      _FieldLabel(strings.sdkFormAddScreenshot),
                      _ScreenshotSlot(
                        bytes: _screenshotBytes,
                        onAdd: _pickScreenshot,
                        onRemove: _removeScreenshot,
                      ),
                      if (_attachFailed)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            strings.sdkFormAttachError,
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.errorForeground,
                            ),
                          ),
                        ),
                      if (_phase == _SubmitPhase.failed ||
                          _phase == _SubmitPhase.rateLimited) ...[
                        const SizedBox(height: 14),
                        InlineErrorBanner(
                          message: _phase == _SubmitPhase.rateLimited
                              ? strings.sdkCommonRateLimited
                              : strings.sdkFormSubmitError,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      theme.background.withValues(alpha: 0),
                      theme.background,
                    ],
                    stops: const [0, 0.38],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                  child: PrimaryButton(
                    label: submitLabel,
                    busy: _phase == _SubmitPhase.sending,
                    onPressed:
                        _valid && _phase != _SubmitPhase.rateLimited
                            ? _submit
                            : null,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static InputDecoration _fieldDecoration(
    FeaturelyThemeData theme, {
    required String? hint,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(fontSize: 15, color: theme.textTertiary),
      filled: true,
      fillColor: theme.field,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      border: OutlineInputBorder(
        borderRadius: theme.borderRadius,
        borderSide: BorderSide.none,
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = FeaturelyScope.of(context).theme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: theme.textPrimary,
        ),
      ),
    );
  }
}

class _TypeControl extends StatelessWidget {
  const _TypeControl({required this.type, required this.onChanged});

  final FeedbackType type;
  final ValueChanged<FeedbackType> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = FeaturelyScope.of(context).theme;
    final strings = FeaturelyLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: theme.field,
        borderRadius: theme.borderRadius,
      ),
      child: Row(
        children: [
          _segment(
            context,
            label: strings.sdkFormTypeFeature,
            selected: type == FeedbackType.feature,
            onTap: () => onChanged(FeedbackType.feature),
          ),
          _segment(
            context,
            label: strings.sdkFormTypeIssue,
            selected: type == FeedbackType.bug,
            onTap: () => onChanged(FeedbackType.bug),
          ),
        ],
      ),
    );
  }

  Widget _segment(
    BuildContext context, {
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final theme = FeaturelyScope.of(context).theme;
    final innerRadius =
        BorderRadius.circular(theme.radius > 7 ? theme.radius - 3 : 4);
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: selected
              ? BoxDecoration(
                  color: theme.background,
                  borderRadius: innerRadius,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                )
              : null,
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: selected ? theme.textPrimary : theme.textTertiary,
            ),
          ),
        ),
      ),
    );
  }
}

class _ScreenshotSlot extends StatelessWidget {
  const _ScreenshotSlot({
    required this.bytes,
    required this.onAdd,
    required this.onRemove,
  });

  final Uint8List? bytes;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = FeaturelyScope.of(context).theme;
    final strings = FeaturelyLocalizations.of(context);
    final image = bytes;
    if (image == null) {
      return Align(
        alignment: AlignmentDirectional.centerStart,
        child: Semantics(
          button: true,
          label: strings.sdkFormAddScreenshot,
          child: InkWell(
            onTap: onAdd,
            borderRadius: theme.borderRadius,
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                border: Border.all(color: theme.border, width: 1.5),
                borderRadius: theme.borderRadius,
              ),
              child: Icon(Icons.add_rounded,
                  size: 22, color: theme.textTertiary),
            ),
          ),
        ),
      );
    }
    // Max one screenshot: the slot becomes the removable thumbnail.
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: theme.borderRadius,
            child: Image.memory(
              image,
              width: 72,
              height: 72,
              fit: BoxFit.cover,
              gaplessPlayback: true,
            ),
          ),
          PositionedDirectional(
            top: -7,
            end: -7,
            child: Semantics(
              button: true,
              label: strings.sdkFormRemoveScreenshot,
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: theme.textSecondary,
                    shape: BoxShape.circle,
                    border: Border.all(color: theme.background, width: 2),
                  ),
                  child: Icon(Icons.close_rounded,
                      size: 12, color: theme.background),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
