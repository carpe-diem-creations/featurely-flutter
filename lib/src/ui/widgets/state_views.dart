import 'package:flutter/material.dart';

import '../../l10n/generated/featurely_localizations.dart';
import '../scope.dart';
import 'primary_button.dart';

/// The failed-load state: localized error copy and a Retry button.
class ErrorStateView extends StatelessWidget {
  /// Creates the error state.
  const ErrorStateView({required this.onRetry, super.key});

  /// Retry callback.
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final scope = FeaturelyScope.of(context);
    final strings = FeaturelyLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off_rounded,
                size: 34, color: scope.theme.textTertiary),
            const SizedBox(height: 14),
            Text(
              strings.sdkListLoadError,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.5,
                height: 1.45,
                color: scope.theme.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            OutlinedAccentButton(
              label: strings.sdkCommonRetry,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}

/// The empty state: localized "Nothing here yet…" copy (the New feedback
/// CTA stays pinned below, rendered by the list screen).
class EmptyStateView extends StatelessWidget {
  /// Creates the empty state.
  const EmptyStateView({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = FeaturelyScope.of(context);
    final strings = FeaturelyLocalizations.of(context);
    final theme = scope.theme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: theme.tint(theme.accent),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(Icons.chat_bubble_outline_rounded,
                  size: 22, color: theme.accent),
            ),
            const SizedBox(height: 14),
            Text(
              strings.sdkListEmpty(scope.appName).replaceAll('  ', ' '),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.5,
                height: 1.45,
                color: theme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The inline error banner (submit failures, notices).
class InlineErrorBanner extends StatelessWidget {
  /// Creates the banner.
  const InlineErrorBanner({required this.message, super.key});

  /// Localized message.
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = FeaturelyScope.of(context).theme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
      decoration: BoxDecoration(
        color: theme.errorBackground,
        border: Border.all(color: theme.errorBorder),
        borderRadius: theme.borderRadius,
      ),
      child: Text(
        message,
        style: TextStyle(
          fontSize: 13,
          height: 1.45,
          color: theme.errorForeground,
        ),
      ),
    );
  }
}
