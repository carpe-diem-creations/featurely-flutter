import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../api/models.dart';
import '../../l10n/generated/featurely_localizations.dart';
import '../controllers/detail_controller.dart';
import '../scope.dart';
import '../widgets/state_views.dart';
import '../widgets/status_pill.dart';

/// The detail screen: title, status, submitted date, description,
/// attachment, the large vote button, and the public comment thread with
/// composer.
class DetailScreen extends StatefulWidget {
  /// Creates the detail screen seeded with the tapped list row.
  const DetailScreen({required this.item, super.key});

  /// The item as known by the list.
  final FeedbackItem item;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late FeedbackDetailController _controller;
  final TextEditingController _composer = TextEditingController();
  bool _popped = false;

  @override
  void initState() {
    super.initState();
    final scope = FeaturelyScope.read(context);
    _controller = FeedbackDetailController(
      api: scope.core.api,
      item: widget.item,
      commentingEnabled: scope.config.value?.commentingEnabled ?? false,
      onVoteChanged: scope.listController.syncVote,
      onItemGone: scope.listController.removeItem,
    );
    _controller.addListener(_onControllerChanged);
    _controller.load();
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    _composer.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    // A 404 on any detail action pops back to the list (the controller
    // already removed the item there).
    if (_controller.gone && !_popped && mounted) {
      _popped = true;
      Navigator.of(context).pop();
      return;
    }
    final draft = _controller.takeRestoredDraft();
    if (draft.isNotEmpty && _composer.text.isEmpty) _composer.text = draft;
  }

  String _formatDate(BuildContext context, DateTime date) {
    final locale = FeaturelyScope.of(context).localeTag;
    final local = date.toLocal();
    final format = local.year == DateTime.now().year
        ? DateFormat.MMMd(locale)
        : DateFormat.yMMMd(locale);
    return format.format(local);
  }

  @override
  Widget build(BuildContext context) {
    final scope = FeaturelyScope.of(context);
    final strings = FeaturelyLocalizations.of(context);
    final theme = scope.theme;
    return Material(
      color: theme.background,
      child: SafeArea(
        top: false,
        child: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            final item = _controller.item;
            final showComposer = _controller.commentingEnabled;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(8, 12, 8, 8),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        // Localized "Back" from the Material delegates; the
                        // chevron carries matchTextDirection for RTL.
                        tooltip:
                            MaterialLocalizations.of(context).backButtonTooltip,
                        icon: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 18,
                          color: theme.accent,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          height: 1.28,
                          color: theme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 9),
                      Row(
                        children: [
                          StatusPill(status: item.status, large: true),
                          const SizedBox(width: 9),
                          Expanded(
                            child: Text(
                              strings.sdkDetailSubmitted(
                                _formatDate(context, item.createdAt),
                              ),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12.5,
                                color: theme.textTertiary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _VoteButton(
                        voted: item.viewerHasVoted,
                        votes: item.votes,
                        onTap: _controller.toggleVote,
                      ),
                      const SizedBox(height: 18),
                      // User-generated content renders in whatever script /
                      // direction it was written.
                      Text(
                        item.description,
                        style: TextStyle(
                          fontSize: 14.5,
                          height: 1.55,
                          color: theme.textSecondary,
                        ),
                      ),
                      if (item.hasAttachment) ...[
                        const SizedBox(height: 18),
                        _Attachment(id: item.id),
                      ],
                      const SizedBox(height: 20),
                      Text(
                        strings.sdkDetailCommentsTitle.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.6,
                          color: theme.textTertiary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      for (final comment in _controller.comments)
                        _CommentTile(
                          comment: comment,
                          formatDate: _formatDate,
                        ),
                      if (_controller.notice != DetailNotice.none)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: InlineErrorBanner(
                            message: switch (_controller.notice) {
                              DetailNotice.commentsDisabled =>
                                strings.sdkDetailCommentsDisabled,
                              DetailNotice.rateLimited =>
                                strings.sdkCommonRateLimited,
                              _ => strings.sdkFormSubmitError,
                            },
                          ),
                        ),
                    ],
                  ),
                ),
                // The composer renders only when cached config allows it; an
                // authoritative 403 hides it (config was stale).
                if (showComposer)
                  _Composer(
                    controller: _composer,
                    maxLength: (scope.config.value ?? const SdkConfig.defaults())
                        .commentMax,
                    sending: _controller.sendingComment,
                    onSend: () {
                      final text = _composer.text;
                      _composer.clear();
                      _controller.addComment(text);
                    },
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _VoteButton extends StatelessWidget {
  const _VoteButton({
    required this.voted,
    required this.votes,
    required this.onTap,
  });

  final bool voted;
  final int votes;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = FeaturelyScope.of(context).theme;
    final strings = FeaturelyLocalizations.of(context);
    return Semantics(
      button: true,
      selected: voted,
      child: Material(
        color: voted ? theme.accent : Colors.transparent,
        borderRadius: theme.borderRadius,
        elevation: voted ? 3 : 0,
        shadowColor: theme.accent.withValues(alpha: 0.3),
        child: InkWell(
          onTap: onTap,
          borderRadius: theme.borderRadius,
          child: Container(
            height: 54,
            decoration: BoxDecoration(
              border: Border.all(color: theme.accent, width: 1.5),
              borderRadius: theme.borderRadius,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.keyboard_arrow_up_rounded,
                  size: 20,
                  color: voted ? theme.onAccent : theme.accent,
                ),
                const SizedBox(width: 6),
                Text(
                  voted ? strings.sdkDetailVoted(votes) : strings.sdkDetailVote,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: voted ? theme.onAccent : theme.accent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Attachment extends StatelessWidget {
  const _Attachment({required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    final scope = FeaturelyScope.of(context);
    final theme = scope.theme;
    return ClipRRect(
      borderRadius: theme.borderRadius,
      child: FutureBuilder<Map<String, String>>(
        future: scope.core.api.authHeaders(),
        builder: (context, snapshot) {
          final headers = snapshot.data;
          if (headers == null) return const SizedBox(height: 120);
          return Image.network(
            scope.core.api.attachmentUrl(id),
            headers: headers,
            fit: BoxFit.cover,
            // 404 (attachment vanished) or transport failure: hide quietly.
            errorBuilder: (context, error, stack) => const SizedBox.shrink(),
            loadingBuilder: (context, child, progress) => progress == null
                ? child
                : Container(height: 120, color: theme.field),
          );
        },
      ),
    );
  }
}

class _CommentTile extends StatelessWidget {
  const _CommentTile({required this.comment, required this.formatDate});

  final FeedbackComment comment;
  final String Function(BuildContext, DateTime) formatDate;

  @override
  Widget build(BuildContext context) {
    final theme = FeaturelyScope.of(context).theme;
    final strings = FeaturelyLocalizations.of(context);
    final team = comment.author == CommentAuthor.team;
    return Opacity(
      opacity: comment.pending ? 0.55 : 1,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: theme.hairline, width: 0.5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (team)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 1.5),
                    decoration: BoxDecoration(
                      color: theme.accent,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      strings.sdkDetailTeamBadge,
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                        color: theme.onAccent,
                      ),
                    ),
                  )
                else
                  Text(
                    strings.sdkDetailAnonymous,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: theme.textPrimary,
                    ),
                  ),
                const SizedBox(width: 7),
                Text(
                  comment.pending ? '' : formatDate(context, comment.createdAt),
                  style: TextStyle(fontSize: 12, color: theme.textTertiary),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              comment.body,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: theme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({
    required this.controller,
    required this.maxLength,
    required this.sending,
    required this.onSend,
  });

  final TextEditingController controller;
  final int maxLength;
  final bool sending;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final theme = FeaturelyScope.of(context).theme;
    final strings = FeaturelyLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      color: theme.background,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.send,
              inputFormatters: [
                // Grapheme-aware cap at the server's commentMax, matching
                // the title/description fields (over-long text otherwise
                // only fails server-side as a generic send error).
                LengthLimitingTextInputFormatter(
                  maxLength,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                ),
              ],
              onSubmitted: (_) => onSend(),
              decoration: InputDecoration(
                hintText: strings.sdkDetailCommentPlaceholder,
                hintStyle: TextStyle(fontSize: 14, color: theme.textTertiary),
                filled: true,
                fillColor: theme.field,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 11),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(99),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(fontSize: 14, color: theme.textPrimary),
            ),
          ),
          const SizedBox(width: 8),
          Semantics(
            button: true,
            label: strings.sdkDetailCommentSend,
            child: Material(
              color: theme.accent,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: sending ? null : onSend,
                customBorder: const CircleBorder(),
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: sending
                      ? Padding(
                          padding: const EdgeInsets.all(11),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation(theme.onAccent),
                          ),
                        )
                      : Icon(Icons.arrow_upward_rounded,
                          size: 20, color: theme.onAccent),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
