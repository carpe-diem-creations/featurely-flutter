import 'package:flutter/material.dart';

import '../../l10n/generated/featurely_localizations.dart';
import '../scope.dart';

/// "{name} is typing…" on the leading side, below the newest message, while
/// the AI assistant is writing a reply. Announced politely to screen readers.
class ChatTypingRow extends StatelessWidget {
  /// Creates the row for the assistant [name].
  const ChatTypingRow({required this.name, super.key});

  /// The assistant's display name.
  final String name;

  @override
  Widget build(BuildContext context) {
    final theme = FeaturelyScope.of(context).theme;
    final strings = FeaturelyLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Semantics(
          liveRegion: true,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: theme.field,
              borderRadius: const BorderRadiusDirectional.only(
                topStart: Radius.circular(18),
                topEnd: Radius.circular(18),
                bottomStart: Radius.circular(6),
                bottomEnd: Radius.circular(18),
              ),
            ),
            child: Text(
              strings.sdkChatAssistantTyping(name),
              style: TextStyle(
                fontSize: 13.5,
                fontStyle: FontStyle.italic,
                color: theme.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
