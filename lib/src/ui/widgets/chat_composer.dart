import 'package:flutter/material.dart';

import '../../api/models.dart';
import '../../l10n/generated/featurely_localizations.dart';
import '../scope.dart';

/// The multi-line chat composer. The send button is disabled while the
/// trimmed text is empty or longer than [maxLength]; over the limit an
/// inline "too long" error shows instead of silently truncating.
class ChatComposer extends StatefulWidget {
  /// Creates the composer.
  const ChatComposer({
    required this.onSend,
    this.maxLength = chatMessageMax,
    this.initialText,
    super.key,
  });

  /// Read once when the composer is created: text to prefill (cursor at the
  /// end, field focused) while the field is empty. Never sent by itself.
  final String? Function()? initialText;

  /// Called with the raw text; the composer clears itself afterwards.
  final ValueChanged<String> onSend;

  /// Maximum trimmed length.
  final int maxLength;

  @override
  State<ChatComposer> createState() => _ChatComposerState();
}

class _ChatComposerState extends State<ChatComposer> {
  final TextEditingController _text = TextEditingController();
  bool _prefilled = false;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialText?.call();
    if (initial != null && initial.isNotEmpty && _text.text.isEmpty) {
      _text.value = TextEditingValue(
        text: initial,
        selection: TextSelection.collapsed(offset: initial.length),
      );
      _prefilled = true;
    }
    _text.addListener(_onChanged);
  }

  @override
  void dispose() {
    _text
      ..removeListener(_onChanged)
      ..dispose();
    super.dispose();
  }

  void _onChanged() => setState(() {});

  int get _length => _text.text.trim().length;
  bool get _tooLong => _length > widget.maxLength;
  bool get _canSend => _length > 0 && !_tooLong;

  void _send() {
    if (!_canSend) return;
    final text = _text.text;
    _text.clear();
    widget.onSend(text);
  }

  @override
  Widget build(BuildContext context) {
    final theme = FeaturelyScope.of(context).theme;
    final strings = FeaturelyLocalizations.of(context);
    final canSend = _canSend;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      decoration: BoxDecoration(
        color: theme.background,
        border: Border(top: BorderSide(color: theme.hairline, width: 0.5)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_tooLong)
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 6, bottom: 6),
              child: Text(
                strings.sdkChatTooLong(widget.maxLength),
                style: TextStyle(fontSize: 12, color: theme.errorForeground),
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: _text,
                  autofocus: _prefilled,
                  minLines: 1,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: strings.sdkChatComposerPlaceholder,
                    hintStyle: TextStyle(
                      fontSize: 15,
                      height: 1.35,
                      color: theme.textTertiary,
                    ),
                    filled: true,
                    fillColor: theme.field,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 11),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.35,
                    color: theme.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Nudged up so it sits centered on a single-line field.
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Semantics(
                  button: true,
                  enabled: canSend,
                  label: strings.sdkChatSend,
                  excludeSemantics: true,
                  child: Tooltip(
                    message: strings.sdkChatSend,
                    child: Material(
                      key: const ValueKey('featurely-chat-send'),
                      color: canSend ? theme.accent : theme.disabledBackground,
                      shape: const CircleBorder(),
                      child: InkWell(
                        onTap: canSend ? _send : null,
                        customBorder: const CircleBorder(),
                        child: SizedBox(
                          width: 38,
                          height: 38,
                          child: Icon(
                            Icons.arrow_upward_rounded,
                            size: 20,
                            color: canSend
                                ? theme.onAccent
                                : theme.disabledForeground,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
