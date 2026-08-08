import 'package:flutter/material.dart';

import '../../api/models.dart';
import '../../l10n/generated/featurely_localizations.dart';
import '../controllers/list_controller.dart';
import '../scope.dart';
import '../widgets/primary_button.dart';
import '../widgets/skeleton.dart';
import '../widgets/state_views.dart';
import '../widgets/status_pill.dart';
import '../widgets/vote_box.dart';
import 'detail_screen.dart';
import 'filter_sheet.dart';
import 'form_screen.dart';

/// The sheet's root screen: header, feedback list with infinite scroll and
/// pull-to-refresh, and the sticky New feedback CTA above the safe area.
class ListScreen extends StatefulWidget {
  /// Creates the list screen.
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final ScrollController _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scroll.position.extentAfter < 400) {
      FeaturelyScope.read(context).listController.loadMore();
    }
  }

  Future<void> _openFilter() async {
    final controller = FeaturelyScope.read(context).listController;
    await showFilterSheet(context, controller);
  }

  void _openForm() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const FormScreen()),
    );
  }

  void _openDetail(FeedbackItem item) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => DetailScreen(item: item)),
    );
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
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 10, 16, 6),
                  child: Row(
                    children: [
                      CircleIconButton(
                        icon: Icons.close_rounded,
                        semanticLabel: strings.sdkCommonClose,
                        onTap: () =>
                            Navigator.of(context, rootNavigator: true).pop(),
                      ),
                      Expanded(
                        child: Text(
                          strings.sdkListTitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: theme.textPrimary,
                          ),
                        ),
                      ),
                      ListenableBuilder(
                        listenable: scope.listController,
                        builder: (context, _) => CircleIconButton(
                          icon: Icons.filter_alt_outlined,
                          semanticLabel: strings.sdkFilterTitle,
                          filled: scope.listController.hasActiveFilter,
                          onTap: _openFilter,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListenableBuilder(
                    listenable: scope.listController,
                    builder: (context, _) => _buildBody(scope.listController),
                  ),
                ),
              ],
            ),
            // Sticky full-width accent CTA above the safe area.
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
                    label: strings.sdkListNewFeedback,
                    onPressed: _openForm,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(FeedbackListController controller) {
    switch (controller.phase) {
      case ListPhase.loading:
        return const SkeletonRows();
      case ListPhase.error:
        return ErrorStateView(onRetry: controller.loadFirst);
      case ListPhase.empty:
        return RefreshIndicator.adaptive(
          onRefresh: controller.loadFirst,
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: constraints.maxHeight,
                child: const EmptyStateView(),
              ),
            ),
          ),
        );
      case ListPhase.loaded:
        final items = controller.items;
        final hasFooter = controller.loadingMore || controller.loadMoreFailed;
        return RefreshIndicator.adaptive(
          onRefresh: controller.loadFirst,
          child: ListView.builder(
            controller: _scroll,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 2, bottom: 96),
            itemCount: items.length + (hasFooter ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= items.length) {
                if (controller.loadMoreFailed) {
                  return _LoadMoreRetryFooter(onRetry: controller.loadMore);
                }
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2.2),
                    ),
                  ),
                );
              }
              final item = items[index];
              return _FeedbackRow(
                item: item,
                onTap: () => _openDetail(item),
                onVote: () => controller.toggleVote(item),
              );
            },
          ),
        );
    }
  }
}

class _LoadMoreRetryFooter extends StatelessWidget {
  const _LoadMoreRetryFooter({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = FeaturelyScope.of(context).theme;
    final strings = FeaturelyLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              strings.sdkListLoadError,
              style: TextStyle(fontSize: 13, color: theme.textTertiary),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: Text(
              strings.sdkCommonRetry,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: theme.accent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeedbackRow extends StatelessWidget {
  const _FeedbackRow({
    required this.item,
    required this.onTap,
    required this.onVote,
  });

  final FeedbackItem item;
  final VoidCallback onTap;
  final VoidCallback onVote;

  @override
  Widget build(BuildContext context) {
    final theme = FeaturelyScope.of(context).theme;
    final strings = FeaturelyLocalizations.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: theme.hairline, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            VoteBox(
              votes: item.votes,
              voted: item.viewerHasVoted,
              onTap: onVote,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                      color: theme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  // 1-line excerpt per the spec; newlines collapse so the
                  // first line of a multi-paragraph description still shows.
                  Text(
                    item.description.replaceAll(RegExp(r'\s+'), ' ').trim(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.5,
                      height: 1.3,
                      color: theme.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      StatusPill(status: item.status),
                      const SizedBox(width: 8),
                      Semantics(
                        label: strings.sdkListComments(item.commentCount),
                        excludeSemantics: true,
                        child: Row(
                          children: [
                            Icon(
                              Icons.chat_bubble_outline_rounded,
                              size: 12,
                              color: theme.textTertiary,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              '${item.commentCount}',
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // arrow_forward_ios carries matchTextDirection, so the chevron
            // mirrors automatically under RTL.
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 13,
              color: theme.hairline,
            ),
          ],
        ),
      ),
    );
  }
}
