import 'dart:ui';

/// The 25 locales the SDK ships, as canonical tags (matching the upstream
/// `packages/locales/src/locales.ts`).
const List<String> supportedLocaleTags = [
  'en', 'es', 'tr', 'ja', 'de', 'fr', 'it', 'ar', 'he', 'fil', 'pt', 'pt-BR',
  'hi', 'ru', 'sv', 'nl', 'zh', 'hu', 'vi', 'th', 'pl', 'nb', 'da', 'ko',
  'uk', //
];

/// Locales rendered right-to-left.
const List<String> rtlLocaleTags = ['ar', 'he'];

final Set<String> _supported = supportedLocaleTags.toSet();

/// Whether [tag] (a resolved tag from [resolveLocaleTag]) renders RTL.
bool isRtlLocale(String tag) => rtlLocaleTags.contains(tag);

/// Resolves a requested locale to a supported tag, mirroring the upstream
/// `resolveLocale` in `locales.ts` exactly: exact match → language match
/// (`pt-BR` → `pt`; unsupported regionals collapse to their base language)
/// → `en`. Case-insensitive; accepts `_` separators.
String resolveLocaleTag(String? requested) {
  if (requested == null || requested.isEmpty) return 'en';

  final parts = requested.trim().replaceAll('_', '-').split('-');
  final language = parts.isNotEmpty ? parts[0].toLowerCase() : '';
  if (language.isEmpty) return 'en';

  if (parts.length > 1) {
    final region = parts[1].toUpperCase();
    final exact = '$language-$region';
    if (_supported.contains(exact)) return exact;
  }
  if (_supported.contains(language)) return language;
  return 'en';
}

/// Converts a resolved tag to a Flutter [Locale] (`pt-BR` → `Locale('pt',
/// 'BR')`).
Locale localeForTag(String tag) {
  final parts = tag.split('-');
  return parts.length > 1 ? Locale(parts[0], parts[1]) : Locale(parts[0]);
}
