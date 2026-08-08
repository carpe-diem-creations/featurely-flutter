import 'package:flutter/material.dart';

/// Theming knobs a host app can pass to `Featurely.init`.
///
/// Everything is optional; unset knobs inherit from the host:
/// accent from `Theme.of(context).colorScheme.primary`, corner radius 12,
/// brightness from the host theme, font from the host's default text style.
class FeaturelyTheme {
  /// Creates a theme override; all parameters are optional.
  const FeaturelyTheme({
    this.accentColor,
    this.cornerRadius,
    this.brightness,
    this.fontFamily,
  });

  /// Accent used for CTAs, vote states, chips, and the Team badge.
  final Color? accentColor;

  /// Corner radius for buttons, fields, and the vote box. Defaults to 12.
  final double? cornerRadius;

  /// Forces light or dark; defaults to the host theme's brightness.
  final Brightness? brightness;

  /// Font family; defaults to the host's font.
  final String? fontFamily;
}

/// Fixed status colors — identical in every host and both brightnesses,
/// never themed (there is deliberately no Declined color).
class FeaturelyStatusColors {
  FeaturelyStatusColors._();

  /// `open` status pill color.
  static const Color open = Color(0xFF4B7BE5);

  /// `planned` status pill color.
  static const Color planned = Color(0xFF8B5CF6);

  /// `in_progress` status pill color.
  static const Color inProgress = Color(0xFF0E9888);

  /// `done` status pill color.
  static const Color done = Color(0xFF23A55A);
}

/// Fixed sandbox-strip colors (amber `#F59E0B` family, matching the
/// dashboard's sandbox treatment). Never themed by the host.
class FeaturelySandboxColors {
  FeaturelySandboxColors._();

  /// Strip background.
  static const Color background = Color(0xFFE8A13C);

  /// Dark-on-amber label color.
  static const Color foreground = Color(0xFF3A2A05);
}

/// The internal, fully-resolved theme the sheet renders with.
///
/// Saturated color is reserved for status pills and the sandbox strip;
/// everything else derives from neutral surfaces plus the single [accent].
class FeaturelyThemeData {
  /// Creates a resolved theme; prefer [FeaturelyThemeData.resolve].
  const FeaturelyThemeData({
    required this.accent,
    required this.onAccent,
    required this.radius,
    required this.brightness,
    required this.fontFamily,
    required this.background,
    required this.field,
    required this.hairline,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.disabledBackground,
    required this.disabledForeground,
    required this.errorBackground,
    required this.errorBorder,
    required this.errorForeground,
  });

  /// Resolves the host-provided [theme] against the host [context]'s
  /// `Theme` at present time.
  factory FeaturelyThemeData.resolve(
    BuildContext context,
    FeaturelyTheme? theme,
  ) {
    final host = Theme.of(context);
    final brightness = theme?.brightness ?? host.brightness;
    final accent = theme?.accentColor ?? host.colorScheme.primary;
    // Legible on-accent foreground for any accent hue.
    final onAccent =
        ThemeData.estimateBrightnessForColor(accent) == Brightness.dark
            ? Colors.white
            : const Color(0xFF1B1C1F);
    final dark = brightness == Brightness.dark;
    return FeaturelyThemeData(
      accent: accent,
      onAccent: onAccent,
      radius: theme?.cornerRadius ?? 12,
      brightness: brightness,
      fontFamily: theme?.fontFamily,
      background: dark ? const Color(0xFF121316) : Colors.white,
      field: dark ? const Color(0xFF24262B) : const Color(0xFFF2F2F7),
      hairline: dark ? const Color(0xFF2A2D32) : const Color(0xFFE5E5EA),
      border: dark ? const Color(0xFF41454C) : const Color(0xFFE0E0E4),
      textPrimary: dark ? const Color(0xFFE9EAEC) : const Color(0xFF111111),
      textSecondary: dark ? const Color(0xFFA3A6AD) : const Color(0xFF3A3A3C),
      textTertiary: dark ? const Color(0xFF6C7079) : const Color(0xFF8A8A8F),
      disabledBackground:
          dark ? const Color(0xFF2C2F35) : const Color(0xFFE5E5EA),
      disabledForeground:
          dark ? const Color(0xFF6C7079) : const Color(0xFFAEAEB2),
      errorBackground: dark ? const Color(0xFF2E1B19) : const Color(0xFFFCEBEA),
      errorBorder: dark ? const Color(0xFF5C2E2A) : const Color(0xFFF0C2BE),
      errorForeground: dark ? const Color(0xFFE2726A) : const Color(0xFFB03A31),
    );
  }

  /// Accent color (host primary unless overridden).
  final Color accent;

  /// Contrast-computed foreground rendered on top of [accent].
  final Color onAccent;

  /// Corner radius for buttons, fields, chips, and the vote box.
  final double radius;

  /// Resolved brightness of the sheet.
  final Brightness brightness;

  /// Font family override, or null to inherit the host font.
  final String? fontFamily;

  /// Sheet background.
  final Color background;

  /// Input-field / segmented-control background.
  final Color field;

  /// Row-divider hairline.
  final Color hairline;

  /// Stronger border (unvoted vote box, screenshot slot).
  final Color border;

  /// Primary text color.
  final Color textPrimary;

  /// Secondary text color.
  final Color textSecondary;

  /// Tertiary text (placeholders, captions, counters).
  final Color textTertiary;

  /// Disabled button background.
  final Color disabledBackground;

  /// Disabled button foreground.
  final Color disabledForeground;

  /// Inline-error banner background.
  final Color errorBackground;

  /// Inline-error banner border.
  final Color errorBorder;

  /// Inline-error banner text.
  final Color errorForeground;

  /// Border radius helper for [radius].
  BorderRadius get borderRadius => BorderRadius.circular(radius);

  /// 12%-tint of [color] over the sheet background, used by status pills.
  Color tint(Color color) =>
      Color.alphaBlend(color.withValues(alpha: 0.12), background);

  /// A minimal Material [ThemeData] for the sheet subtree, so Material
  /// widgets inside the sheet (ripples, fields, progress indicators) match.
  ThemeData toMaterialTheme(TargetPlatform platform) {
    final scheme = ColorScheme.fromSeed(
      seedColor: accent,
      brightness: brightness,
    ).copyWith(primary: accent, onPrimary: onAccent, surface: background);
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      fontFamily: fontFamily,
      platform: platform,
      scaffoldBackgroundColor: background,
      splashFactory: platform == TargetPlatform.iOS
          ? NoSplash.splashFactory
          : InkRipple.splashFactory,
    );
  }
}
