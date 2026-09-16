import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../api/models.dart';
import '../../l10n/generated/featurely_localizations.dart';
import '../controllers/chat_controller.dart';
import '../scope.dart';

/// One chat message: user messages sit on the trailing side in an accent
/// bubble, team messages on the leading side with a "Team" label. Uses
/// directional alignment, so the sides mirror under RTL.
class ChatBubble extends StatelessWidget {
  /// Creates a bubble.
  const ChatBubble({required this.entry, this.onRetry, super.key});

  /// The row to render.
  final ChatEntry entry;

  /// Called when a failed message is tapped.
  final VoidCallback? onRetry;

  String _time(BuildContext context, DateTime date) {
    final locale = FeaturelyScope.of(context).localeTag;
    final local = date.toLocal();
    final now = DateTime.now();
    final sameDay = local.year == now.year &&
        local.month == now.month &&
        local.day == now.day;
    if (sameDay) return DateFormat.jm(locale).format(local);
    final day = local.year == now.year
        ? DateFormat.MMMd(locale)
        : DateFormat.yMMMd(locale);
    return '${day.format(local)}, ${DateFormat.jm(locale).format(local)}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = FeaturelyScope.of(context).theme;
    final strings = FeaturelyLocalizations.of(context);
    final message = entry.message;
    final mine = message.author == ChatAuthor.user;
    final failed = entry.delivery == ChatDelivery.failed;

    final String caption;
    Color captionColor = theme.textTertiary;
    switch (entry.delivery) {
      case ChatDelivery.sending:
        caption = strings.sdkChatSending;
      case ChatDelivery.failed:
        caption = strings.sdkChatNotSentRetry;
        captionColor = theme.errorForeground;
      case ChatDelivery.sent:
        caption = _time(context, message.createdAt);
    }

    final bubble = Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
      decoration: BoxDecoration(
        color: mine ? theme.accent : theme.field,
        borderRadius: BorderRadiusDirectional.only(
          topStart: const Radius.circular(16),
          topEnd: const Radius.circular(16),
          bottomStart: Radius.circular(mine ? 16 : 4),
          bottomEnd: Radius.circular(mine ? 4 : 16),
        ),
        border: failed ? Border.all(color: theme.errorBorder, width: 1) : null,
      ),
      child: Text(
        message.body,
        style: TextStyle(
          fontSize: 14.5,
          height: 1.4,
          color: mine ? theme.onAccent : theme.textPrimary,
        ),
      ),
    );

    final column = Column(
      crossAxisAlignment:
          mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!mine)
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 4, bottom: 3),
            child: Text(
              strings.sdkChatTeamLabel,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
                color: theme.accent,
              ),
            ),
          ),
        Opacity(
          opacity: entry.delivery == ChatDelivery.sending ? 0.6 : 1,
          child: bubble,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 3, left: 4, right: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (failed) ...[
                Icon(Icons.error_outline_rounded,
                    size: 13, color: captionColor),
                const SizedBox(width: 3),
              ],
              Flexible(
                child: Text(
                  caption,
                  style: TextStyle(fontSize: 11.5, color: captionColor),
                ),
              ),
            ],
          ),
        ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Align(
        alignment: mine
            ? AlignmentDirectional.centerEnd
            : AlignmentDirectional.centerStart,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width * 0.78,
          ),
          child: failed
              ? Semantics(
                  button: true,
                  child: InkWell(
                    onTap: onRetry,
                    borderRadius: BorderRadius.circular(16),
                    child: column,
                  ),
                )
              : column,
        ),
      ),
    );
  }
}
