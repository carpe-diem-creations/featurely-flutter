import 'package:flutter/widgets.dart';

import '../api/models.dart';
import '../core.dart';
import '../theme.dart';
import 'controllers/list_controller.dart';

/// Inherited access to the sheet's per-presentation dependencies: the core,
/// the resolved theme, the resolved locale, the session config, and the
/// list controller.
class FeaturelyScope extends InheritedWidget {
  /// Creates the scope.
  const FeaturelyScope({
    required this.core,
    required this.theme,
    required this.localeTag,
    required this.config,
    required this.configSnapshot,
    required this.listController,
    required super.child,
    super.key,
  });

  /// The runtime this sheet operates on.
  final FeaturelyCore core;

  /// The resolved theme (host theme + `FeaturelyTheme` knobs).
  final FeaturelyThemeData theme;

  /// The resolved locale tag (e.g. `pt-BR`), fixed per presentation, sent
  /// as `resolvedLocale` on submissions.
  final String localeTag;

  /// The session config; null until the first fetch resolves (the sheet
  /// opens regardless).
  final ValueNotifier<SdkConfig?> config;

  /// The config value at build time, so scope dependents rebuild when the
  /// fetch lands.
  final SdkConfig? configSnapshot;

  /// The list controller, shared by the list, filter, form, and detail
  /// screens of this presentation.
  final FeedbackListController listController;

  /// `{appName}` for strings, from config (empty-string-safe fallback).
  String get appName => config.value?.projectName ?? '';

  /// The nearest scope, registering a build dependency.
  static FeaturelyScope of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<FeaturelyScope>()!;

  /// The nearest scope without registering a dependency — safe from
  /// `initState` and event listeners.
  static FeaturelyScope read(BuildContext context) =>
      context.getInheritedWidgetOfExactType<FeaturelyScope>()!;

  @override
  bool updateShouldNotify(FeaturelyScope oldWidget) =>
      core != oldWidget.core ||
      theme != oldWidget.theme ||
      localeTag != oldWidget.localeTag ||
      configSnapshot != oldWidget.configSnapshot;
}
