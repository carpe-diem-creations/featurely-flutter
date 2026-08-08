import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/material.dart';

import '../api/models.dart';
import '../core.dart';
import '../l10n/generated/featurely_localizations.dart';
import '../l10n/locale_resolution.dart';
import '../theme.dart';
import 'controllers/list_controller.dart';
import 'sandbox_strip.dart';
import 'scope.dart';
import 'screens/list_screen.dart';

/// Presents the full-height feedback sheet and completes when dismissed.
///
/// The theme is resolved against the host theme and the locale against the
/// device (or the init override) at present time; both are fixed for the
/// lifetime of this presentation.
Future<void> showFeaturelySheet(BuildContext context, FeaturelyCore core) {
  final theme = FeaturelyThemeData.resolve(context, core.options.theme);
  final platform = Theme.of(context).platform;
  final localeTag = resolveLocaleTag(
    core.options.locale?.toLanguageTag() ??
        PlatformDispatcher.instance.locale.toLanguageTag(),
  );
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    // iOS gets swipe-to-dismiss; Android dismisses via system back, routed
    // through the sheet's internal navigation stack first.
    enableDrag: platform == TargetPlatform.iOS,
    backgroundColor: Colors.transparent,
    builder: (_) => FractionallySizedBox(
      heightFactor: 1,
      child: FeaturelySheet(
        core: core,
        theme: theme,
        localeTag: localeTag,
        platform: platform,
      ),
    ),
  );
}

/// The sheet root: localization + directionality override, theme, sandbox
/// strip, and the internal navigator (list → form/detail → success).
class FeaturelySheet extends StatefulWidget {
  /// Creates the sheet.
  const FeaturelySheet({
    required this.core,
    required this.theme,
    required this.localeTag,
    required this.platform,
    super.key,
  });

  /// The runtime.
  final FeaturelyCore core;

  /// The resolved theme.
  final FeaturelyThemeData theme;

  /// The resolved locale tag, fixed for this presentation.
  final String localeTag;

  /// Host platform, for adaptive details.
  final TargetPlatform platform;

  @override
  State<FeaturelySheet> createState() => _FeaturelySheetState();
}

class _FeaturelySheetState extends State<FeaturelySheet> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  late final FeedbackListController _listController;
  late final ValueNotifier<SdkConfig?> _config;

  @override
  void initState() {
    super.initState();
    _listController = FeedbackListController(api: widget.core.api);
    _config = ValueNotifier<SdkConfig?>(widget.core.cachedConfig);
    // Config is fetched when the sheet opens and cached for the session;
    // the sheet opens (with cached or default limits) even when this fails.
    widget.core.config().then((config) {
      if (mounted) _config.value = config;
    });
    _listController.loadFirst();
  }

  @override
  void dispose() {
    _listController.dispose();
    _config.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = localeForTag(widget.localeTag);
    final direction =
        isRtlLocale(widget.localeTag) ? TextDirection.rtl : TextDirection.ltr;
    return Localizations(
      locale: locale,
      delegates: FeaturelyLocalizations.localizationsDelegates,
      child: Directionality(
        textDirection: direction,
        child: Theme(
          data: widget.theme.toMaterialTheme(widget.platform),
          child: ValueListenableBuilder<SdkConfig?>(
            valueListenable: _config,
            builder: (context, configValue, child) => FeaturelyScope(
              core: widget.core,
              theme: widget.theme,
              localeTag: widget.localeTag,
              config: _config,
              configSnapshot: configValue,
              listController: _listController,
              child: child!,
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: ColoredBox(
                color: widget.theme.background,
                child: Column(
                  children: [
                    if (widget.core.isSandbox) const SandboxStrip(),
                    Expanded(
                      child: PopScope(
                        // System back (and predictive back) pops the sheet's
                        // internal stack before dismissing the sheet.
                        canPop: false,
                        onPopInvokedWithResult: (didPop, _) {
                          if (didPop) return;
                          final navigator = _navigatorKey.currentState;
                          if (navigator != null && navigator.canPop()) {
                            navigator.pop();
                          } else {
                            Navigator.of(context).pop();
                          }
                        },
                        child: Navigator(
                          key: _navigatorKey,
                          onGenerateInitialRoutes: (navigator, initialRoute) => [
                            MaterialPageRoute<void>(
                              builder: (_) => const ListScreen(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
