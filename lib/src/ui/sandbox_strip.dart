import 'package:flutter/widgets.dart';

import '../l10n/generated/featurely_localizations.dart';
import '../theme.dart';

/// The thin solid amber strip across the top of the sheet for `fk_test_…`
/// keys. Fixed amber — the one element deliberately exempt from host
/// theming, so QA can never mistake the environment.
class SandboxStrip extends StatelessWidget {
  /// Creates the strip.
  const SandboxStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      color: FeaturelySandboxColors.background,
      alignment: Alignment.center,
      child: Text(
        FeaturelyLocalizations.of(context).sdkSandboxBadge,
        style: const TextStyle(
          color: FeaturelySandboxColors.foreground,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.88,
        ),
      ),
    );
  }
}
