import 'dart:async';

import 'package:flutter/material.dart' hide Page;

import '../../api/models.dart';
import '../../l10n/generated/featurely_localizations.dart';
import '../controllers/list_controller.dart';
import '../scope.dart';
import '../widgets/primary_button.dart';

/// Opens the filter & sort bottom sheet over the feedback list.
Future<void> showFilterSheet(
  BuildContext context,
  FeedbackListController controller,
) {
  final scope = FeaturelyScope.of(context);
  // Pushed onto the sheet's internal navigator, so the scope, theme, and
  // localizations above it are inherited.
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: scope.theme.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (sheetContext) => _FilterSheet(controller: controller),
  );
}

/// The filter & sort sheet: Sort rows, Status chips, Reset, and a primary
/// "Show N requests" button with a live result count.
class _FilterSheet extends StatefulWidget {
  const _FilterSheet({required this.controller});

  final FeedbackListController controller;

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late FeedbackSort _sort = widget.controller.sort;
  late FeedbackStatus? _status = widget.controller.statusFilter;
  Page<FeedbackItem>? _preview;
  int? _count;
  bool _overflow = false;
  int _requestId = 0;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _fetchCount(immediate: true);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  /// Fetches a preview first page (max limit) for the live count; the page
  /// is reused as the list's first page on apply, so no request is wasted.
  void _fetchCount({bool immediate = false}) {
    final id = ++_requestId;
    final api = FeaturelyScope.read(context).core.api;
    setState(() {
      _preview = null;
      _count = null;
    });
    _debounce?.cancel();
    _debounce = Timer(
      immediate ? Duration.zero : const Duration(milliseconds: 250),
      () async {
        try {
          final page =
              await api.listFeedback(sort: _sort, status: _status, limit: 100);
          if (!mounted || id != _requestId) return;
          setState(() {
            _preview = page;
            _count = page.items.length;
            // A full page with a cursor means the true count exceeds the
            // preview cap; the label switches to "Show N+ requests".
            _overflow = page.nextCursor != null;
          });
        } catch (_) {
          // Count fetch failed (offline, rate-limited): fall back to the
          // already-loaded count so Apply never gets stuck.
          if (!mounted || id != _requestId) return;
          setState(() {
            _count = widget.controller.items.length;
            _overflow = widget.controller.canLoadMore;
          });
        }
      },
    );
  }

  void _select(FeedbackSort sort, FeedbackStatus? status) {
    setState(() {
      _sort = sort;
      _status = status;
    });
    _fetchCount();
  }

  Future<void> _apply() async {
    final navigator = Navigator.of(context);
    unawaited(
      widget.controller.applyFilter(_sort, _status, preload: _preview),
    );
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FeaturelyScope.of(context).theme;
    final strings = FeaturelyLocalizations.of(context);
    final count = _count;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 5,
                decoration: BoxDecoration(
                  color: theme.border,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  strings.sdkFilterTitle,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: theme.textPrimary,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => _select(FeedbackSort.votes, null),
                  child: Text(
                    strings.sdkFilterReset,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: theme.accent,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _SectionLabel(strings.sdkFilterSortBy),
            _SortRow(
              label: strings.sdkFilterSortMostVoted,
              selected: _sort == FeedbackSort.votes,
              onTap: () => _select(FeedbackSort.votes, _status),
            ),
            _SortRow(
              label: strings.sdkFilterSortNewest,
              selected: _sort == FeedbackSort.newest,
              onTap: () => _select(FeedbackSort.newest, _status),
            ),
            _SortRow(
              label: strings.sdkFilterSortOldest,
              selected: _sort == FeedbackSort.oldest,
              onTap: () => _select(FeedbackSort.oldest, _status),
              divider: false,
            ),
            const SizedBox(height: 14),
            _SectionLabel(strings.sdkFilterStatus),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _StatusChip(
                  label: strings.sdkFilterStatusAll,
                  selected: _status == null,
                  onTap: () => _select(_sort, null),
                ),
                for (final status in FeedbackStatus.values)
                  _StatusChip(
                    label: _statusLabel(strings, status),
                    selected: _status == status,
                    onTap: () => _select(_sort, status),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: count == null
                  ? '…'
                  : _overflow
                      ? strings.sdkFilterShowResultsOverflow(count)
                      : strings.sdkFilterShowResults(count),
              busy: count == null,
              onPressed: _apply,
            ),
          ],
        ),
      ),
    );
  }

  static String _statusLabel(
    FeaturelyLocalizations strings,
    FeedbackStatus status,
  ) =>
      switch (status) {
        FeedbackStatus.open => strings.sdkStatusOpen,
        FeedbackStatus.planned => strings.sdkStatusPlanned,
        FeedbackStatus.inProgress => strings.sdkStatusInProgress,
        FeedbackStatus.done => strings.sdkStatusDone,
      };
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = FeaturelyScope.of(context).theme;
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.6,
        color: theme.textTertiary,
      ),
    );
  }
}

class _SortRow extends StatelessWidget {
  const _SortRow({
    required this.label,
    required this.selected,
    required this.onTap,
    this.divider = true,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool divider;

  @override
  Widget build(BuildContext context) {
    final theme = FeaturelyScope.of(context).theme;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: divider
            ? BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: theme.hairline, width: 0.5),
                ),
              )
            : null,
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  color: theme.textPrimary,
                ),
              ),
            ),
            if (selected)
              Icon(Icons.check_rounded, size: 18, color: theme.accent),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = FeaturelyScope.of(context).theme;
    return Material(
      color: selected ? theme.accent : theme.field,
      borderRadius: BorderRadius.circular(99),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(99),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selected ? theme.onAccent : theme.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
