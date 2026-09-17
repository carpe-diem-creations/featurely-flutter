import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../api/models.dart';
import '../../l10n/generated/featurely_localizations.dart';
import '../controllers/chat_controller.dart';
import '../scope.dart';

/// One chat message: user messages sit on the trailing side in an accent
/// bubble, team messages on the leading side in a neutral one. The sender's
/// bottom corner is tightened, and alignment and radii are directional, so
/// both mirror under RTL. Below the bubble a meta row shows the time (the
/// day lives in the list's day separators), "Sending…", or the retry hint.
class ChatBubble extends StatelessWidget {
  /// Creates a bubble.
  const ChatBubble({required this.entry, this.onRetry, super.key});

  /// The row to render.
  final ChatEntry entry;

  /// Called when a failed message is tapped.
  final VoidCallback? onRetry;

  static const _radius = Radius.circular(18);
  static const _tailRadius = Radius.circular(6);

  @override
  Widget build(BuildContext context) {
    final scope = FeaturelyScope.of(context);
    final theme = scope.theme;
    final strings = FeaturelyLocalizations.of(context);
    final message = entry.message;
    final mine = message.author == ChatAuthor.user;
    final failed = entry.delivery == ChatDelivery.failed;

    final Color fill;
    final Color foreground;
    if (failed) {
      fill = theme.tint(theme.accent, 0.18);
      foreground = theme.textSecondary;
    } else if (mine) {
      fill = theme.accent;
      foreground = theme.onAccent;
    } else {
      fill = theme.field;
      foreground = theme.textPrimary;
    }

    final bubble = Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadiusDirectional.only(
          topStart: _radius,
          topEnd: _radius,
          bottomStart: mine ? _radius : _tailRadius,
          bottomEnd: mine ? _tailRadius : _radius,
        ),
        border: failed
            ? Border.all(color: theme.tint(theme.accent, 0.35), width: 1)
            : null,
      ),
      child: Text(
        message.body,
        style: TextStyle(fontSize: 15, height: 1.45, color: foreground),
      ),
    );

    final metaStyle = TextStyle(fontSize: 11.5, color: theme.textTertiary);
    final Widget meta;
    switch (entry.delivery) {
      case ChatDelivery.sending:
        meta = Text(strings.sdkChatSending, style: metaStyle);
      case ChatDelivery.failed:
        meta = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded,
                size: 13, color: theme.errorForeground),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                strings.sdkChatNotSentRetry,
                style: metaStyle.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.errorForeground,
                ),
              ),
            ),
          ],
        );
      case ChatDelivery.sent:
        meta = Text(
          DateFormat.jm(scope.localeTag).format(message.createdAt.toLocal()),
          style: metaStyle,
        );
    }

    Widget column = Column(
      crossAxisAlignment:
          mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        bubble,
        Padding(
          padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
          child: meta,
        ),
      ],
    );

    if (failed) {
      column = Semantics(
        button: true,
        child: InkWell(
          onTap: onRetry,
          borderRadius: BorderRadius.circular(18),
          child: column,
        ),
      );
    } else if (!mine) {
      // No visible sender badge; screen readers still announce the team.
      column = MergeSemantics(
        child: Semantics(label: strings.sdkChatTeamLabel, child: column),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: LayoutBuilder(
        builder: (context, constraints) => Align(
          alignment: mine
              ? AlignmentDirectional.centerEnd
              : AlignmentDirectional.centerStart,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: constraints.maxWidth * 0.78),
            child: column,
          ),
        ),
      ),
    );
  }
}
