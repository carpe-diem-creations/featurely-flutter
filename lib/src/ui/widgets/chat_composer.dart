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
    super.key,
  });

  /// Called with the raw text; the composer clears itself afterwards.
  final ValueChanged<String> onSend;

  /// Maximum trimmed length.
  final int maxLength;

  @override
  State<ChatComposer> createState() => _ChatComposerState();
}

class _ChatComposerState extends State<ChatComposer> {
  final TextEditingController _text = TextEditingController();

  @override
  void initState() {
    super.initState();
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
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
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
                  minLines: 1,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: strings.sdkChatComposerPlaceholder,
                    hintStyle:
                        TextStyle(fontSize: 14.5, color: theme.textTertiary),
                    filled: true,
                    fillColor: theme.field,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 11),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: TextStyle(fontSize: 14.5, color: theme.textPrimary),
                ),
              ),
              const SizedBox(width: 8),
              Semantics(
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
                        width: 40,
                        height: 40,
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
            ],
          ),
        ],
      ),
    );
  }
}
