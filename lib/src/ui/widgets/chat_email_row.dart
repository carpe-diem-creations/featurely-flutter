import 'package:flutter/material.dart';

import '../../l10n/generated/featurely_localizations.dart';
import '../controllers/chat_controller.dart';
import '../scope.dart';

/// The optional "Get replies by email" card above the composer. Collapsed
/// it is a single tappable prompt; tapped it opens an email field with
/// Save; once saved it shows the address with an Edit action.
class ChatEmailRow extends StatefulWidget {
  /// Creates the row bound to [controller].
  const ChatEmailRow({required this.controller, super.key});

  /// The chat controller (source of the saved address and save state).
  final ChatController controller;

  @override
  State<ChatEmailRow> createState() => _ChatEmailRowState();
}

class _ChatEmailRowState extends State<ChatEmailRow> {
  final TextEditingController _field = TextEditingController();
  bool _editing = false;

  @override
  void dispose() {
    _field.dispose();
    super.dispose();
  }

  void _startEditing() {
    _field.text = widget.controller.contactEmail ?? '';
    widget.controller.clearEmailError();
    setState(() => _editing = true);
  }

  Future<void> _save() async {
    final saved = await widget.controller.saveEmail(_field.text);
    if (saved && mounted) setState(() => _editing = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = FeaturelyScope.of(context).theme;
    final strings = FeaturelyLocalizations.of(context);
    final controller = widget.controller;
    final saved = controller.contactEmail;
    final mailIcon =
        Icon(Icons.mail_outline_rounded, size: 17, color: theme.textTertiary);
    // Compact, so the action doesn't stretch the card.
    final actionStyle = TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      minimumSize: const Size(44, 32),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );

    final Widget child;
    VoidCallback? onTap;
    if (_editing) {
      final error = switch (controller.emailError) {
        ChatEmailError.invalid => strings.sdkChatEmailInvalid,
        ChatEmailError.failed => strings.sdkFormSubmitError,
        ChatEmailError.none => null,
      };
      final fieldBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: error != null ? theme.errorBorder : theme.hairline,
        ),
      );
      child = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  key: const ValueKey('featurely-chat-email-field'),
                  controller: _field,
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  textInputAction: TextInputAction.done,
                  onChanged: (_) => controller.clearEmailError(),
                  onSubmitted: (_) => _save(),
                  decoration: InputDecoration(
                    hintText: strings.sdkChatEmailPlaceholder,
                    hintStyle:
                        TextStyle(fontSize: 14, color: theme.textTertiary),
                    filled: true,
                    fillColor: theme.background,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    border: fieldBorder,
                    enabledBorder: fieldBorder,
                  ),
                  style: TextStyle(fontSize: 14, color: theme.textPrimary),
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                style: actionStyle,
                onPressed: controller.savingEmail ? null : _save,
                child: controller.savingEmail
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        strings.sdkChatEmailSave,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: theme.accent,
                        ),
                      ),
              ),
            ],
          ),
          if (error != null)
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 4, top: 6),
              child: Text(
                error,
                style: TextStyle(fontSize: 12, color: theme.errorForeground),
              ),
            ),
        ],
      );
    } else if (saved != null) {
      child = Row(
        children: [
          mailIcon,
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  strings.sdkChatEmailSaved,
                  style: TextStyle(fontSize: 11.5, color: theme.textTertiary),
                ),
                Text(
                  saved,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textDirection: TextDirection.ltr,
                  style: TextStyle(fontSize: 14, color: theme.textPrimary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            style: actionStyle,
            onPressed: _startEditing,
            child: Text(
              strings.sdkChatEmailEdit,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: theme.accent,
              ),
            ),
          ),
        ],
      );
    } else {
      onTap = _startEditing;
      child = Semantics(
        button: true,
        child: Row(
          children: [
            mailIcon,
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                strings.sdkChatEmailPrompt,
                style: TextStyle(fontSize: 13.5, color: theme.textSecondary),
              ),
            ),
            const SizedBox(width: 8),
            // arrow_forward_ios carries matchTextDirection (RTL-safe).
            Icon(Icons.arrow_forward_ios_rounded,
                size: 12, color: theme.disabledForeground),
          ],
        ),
      );
    }

    return Material(
      color: theme.field,
      borderRadius: theme.borderRadius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          // The editing field carries its own vertical room.
          padding: EdgeInsets.symmetric(
            horizontal: 13,
            vertical: _editing ? 8 : 11,
          ),
          child: child,
        ),
      ),
    );
  }
}
