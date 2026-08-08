import 'package:flutter/widgets.dart';

import '../../api/models.dart';
import '../../l10n/generated/featurely_localizations.dart';
import '../../theme.dart';
import '../scope.dart';

/// A status pill with the fixed (never host-themed) status color on a 12%
/// tint. There is no Declined pill.
class StatusPill extends StatelessWidget {
  /// Creates a pill for [status].
  const StatusPill({required this.status, this.large = false, super.key});

  /// The status to render.
  final FeedbackStatus status;

  /// Slightly larger variant for the detail screen.
  final bool large;

  /// The fixed color for [status].
  static Color colorOf(FeedbackStatus status) => switch (status) {
        FeedbackStatus.open => FeaturelyStatusColors.open,
        FeedbackStatus.planned => FeaturelyStatusColors.planned,
        FeedbackStatus.inProgress => FeaturelyStatusColors.inProgress,
        FeedbackStatus.done => FeaturelyStatusColors.done,
      };

  /// The localized label for [status].
  static String labelOf(BuildContext context, FeedbackStatus status) {
    final strings = FeaturelyLocalizations.of(context);
    return switch (status) {
      FeedbackStatus.open => strings.sdkStatusOpen,
      FeedbackStatus.planned => strings.sdkStatusPlanned,
      FeedbackStatus.inProgress => strings.sdkStatusInProgress,
      FeedbackStatus.done => strings.sdkStatusDone,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = FeaturelyScope.of(context).theme;
    final color = colorOf(status);
    return Container(
      padding: large
          ? const EdgeInsets.symmetric(horizontal: 11, vertical: 3)
          : const EdgeInsets.symmetric(horizontal: 9, vertical: 2),
      decoration: BoxDecoration(
        color: theme.tint(color),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        labelOf(context, status),
        style: TextStyle(
          color: color,
          fontSize: large ? 12 : 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
