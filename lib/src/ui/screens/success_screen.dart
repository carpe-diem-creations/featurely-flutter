import 'package:flutter/material.dart';

import '../../l10n/generated/featurely_localizations.dart';
import '../scope.dart';
import '../widgets/primary_button.dart';

/// The full-screen submit confirmation: check mark, localized copy, and a
/// button back to the list (never a silent dismiss). The list refreshes on
/// return so the new item appears.
class SuccessScreen extends StatefulWidget {
  /// Creates the confirmation screen.
  const SuccessScreen({super.key});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  void initState() {
    super.initState();
    // Refresh so the new item is in the list however the user returns
    // (button or system back). Deferred: the list controller notifies
    // synchronously and this route is still building.
    final controller = FeaturelyScope.read(context).listController;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadFirst();
    });
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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: theme.accent,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: theme.accent.withValues(alpha: 0.4),
                        blurRadius: 28,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child:
                      Icon(Icons.check_rounded, size: 34, color: theme.onAccent),
                ),
                const SizedBox(height: 20),
                Text(
                  strings.sdkSuccessTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: theme.textPrimary,
                  ),
                ),
                const SizedBox(height: 7),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 280),
                  child: Text(
                    strings.sdkSuccessBody(scope.appName).replaceAll('  ', ' '),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: theme.textTertiary,
                    ),
                  ),
                ),
                const SizedBox(height: 26),
                OutlinedAccentButton(
                  label: strings.sdkSuccessBack,
                  onPressed: () =>
                      Navigator.of(context).popUntil((route) => route.isFirst),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
