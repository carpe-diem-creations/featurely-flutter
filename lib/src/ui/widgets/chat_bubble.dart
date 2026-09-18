import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../api/models.dart';
import '../../chat_actions.dart';
import '../../l10n/generated/featurely_localizations.dart';
import '../controllers/chat_controller.dart';
import '../scope.dart';

/// One chat message: user messages sit on the trailing side in an accent
/// bubble, team messages on the leading side in a neutral one. The sender's
/// bottom corner is tightened, and alignment and radii are directional, so
/// both mirror under RTL. Below the bubble a meta row shows the time (the
/// day lives in the list's day separators), "Sending…", or the retry hint.
///
/// AI assistant messages also sit on the leading side, under the
/// assistant's name. Their text is plain (no markdown);
/// numbered lines (`1. …`) get a hanging indent. Suggested [actions] render
/// as buttons below the bubble.
class ChatBubble extends StatelessWidget {
  /// Creates a bubble.
  const ChatBubble({
    required this.entry,
    this.onRetry,
    this.actions = const [],
    this.usedActionIds = const {},
    this.onAction,
    super.key,
  });

  /// The row to render.
  final ChatEntry entry;

  /// Called when a failed message is tapped.
  final VoidCallback? onRetry;

  /// The registered actions this assistant message suggests, in its order
  /// (unregistered ids already removed).
  final List<FeaturelyChatAction> actions;

  /// Ids of [actions] already tapped this session (shown as used).
  final Set<String> usedActionIds;

  /// Called when an unused action is tapped; null hides the actions.
  final ValueChanged<FeaturelyChatAction>? onAction;

  static const _radius = Radius.circular(18);
  static const _tailRadius = Radius.circular(6);

  @override
  Widget build(BuildContext context) {
    final scope = FeaturelyScope.of(context);
    final theme = scope.theme;
    final strings = FeaturelyLocalizations.of(context);
    final message = entry.message;
    final mine = message.author == ChatAuthor.user;
    final assistant = !mine && message.isAssistant;
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
      child: assistant
          ? ChatAssistantText(
              text: message.body,
              style: TextStyle(fontSize: 15, height: 1.45, color: foreground),
            )
          : Text(
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

    final metaRow = Padding(
      padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
      child: meta,
    );

    Widget column;
    if (assistant) {
      final name = message.authorName?.trim();
      final visibleActions =
          onAction == null ? const <FeaturelyChatAction>[] : actions;
      column = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Name and text read as one node; buttons stay separate.
          MergeSemantics(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding:
                      const EdgeInsetsDirectional.only(start: 4, bottom: 4),
                  child: ChatAssistantLabel(
                    name: name == null || name.isEmpty
                        ? strings.sdkChatAssistantName
                        : name,
                  ),
                ),
                bubble,
                metaRow,
              ],
            ),
          ),
          if (visibleActions.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final action in visibleActions)
                    _ActionButton(
                      key: ValueKey(
                          'featurely-chat-action-${message.id}-${action.id}'),
                      title: action.title,
                      used: usedActionIds.contains(action.id),
                      onTap: () => onAction!(action),
                    ),
                ],
              ),
            ),
        ],
      );
    } else {
      column = Column(
        crossAxisAlignment:
            mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [bubble, metaRow],
      );
    }

    if (failed) {
      column = Semantics(
        button: true,
        child: InkWell(
          onTap: onRetry,
          borderRadius: BorderRadius.circular(18),
          child: column,
        ),
      );
    } else if (!mine && !assistant) {
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

/// The assistant's name, above its messages.
class ChatAssistantLabel extends StatelessWidget {
  /// Creates the label for [name].
  const ChatAssistantLabel({required this.name, super.key});

  /// The assistant's display name.
  final String name;

  @override
  Widget build(BuildContext context) {
    final theme = FeaturelyScope.of(context).theme;
    return Text(
      name,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: theme.textSecondary,
      ),
    );
  }
}

/// An assistant message body: plain text, where numbered lines (`1. …`,
/// `2) …`) get a hanging indent so wrapped steps stay aligned. Nothing else
/// is interpreted — markdown shows as typed.
class ChatAssistantText extends StatelessWidget {
  /// Creates the text for [text] in [style].
  const ChatAssistantText({required this.text, required this.style, super.key});

  /// The message body.
  final String text;

  /// The body style.
  final TextStyle style;

  static final RegExp _numbered = RegExp(r'^\s*(\d{1,2}[.)])\s+(.*)$');

  @override
  Widget build(BuildContext context) {
    final lines = text.split('\n');
    if (!lines.any(_numbered.hasMatch)) return Text(text, style: style);
    // Consecutive plain lines stay one Text; each numbered line is a row.
    final children = <Widget>[];
    final plain = <String>[];
    void flushPlain() {
      if (plain.isEmpty) return;
      children.add(Text(plain.join('\n'), style: style));
      plain.clear();
    }

    for (final line in lines) {
      final match = _numbered.firstMatch(line);
      if (match == null) {
        plain.add(line);
        continue;
      }
      flushPlain();
      children.add(Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 20),
            child: Text(match.group(1)!, style: style),
          ),
          const SizedBox(width: 4),
          Expanded(child: Text(match.group(2)!, style: style)),
        ],
      ));
    }
    flushPlain();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}

/// A suggested-action button under an assistant message; a [used] one is
/// disabled and shows a check.
class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.title,
    required this.used,
    required this.onTap,
    super.key,
  });

  final String title;
  final bool used;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = FeaturelyScope.of(context).theme;
    final color = used ? theme.textTertiary : theme.accent;
    return Semantics(
      button: true,
      enabled: !used,
      child: Material(
        color: used ? theme.field : theme.tint(theme.accent, 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: used ? theme.hairline : theme.tint(theme.accent, 0.45),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: used ? null : onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 36),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (used) ...[
                    Icon(Icons.check_rounded, size: 15, color: color),
                    const SizedBox(width: 5),
                  ],
                  Flexible(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
