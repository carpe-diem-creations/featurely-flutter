import 'dart:ui';

/// The 34 locales the SDK ships, as canonical tags (matching the upstream
/// `packages/locales/src/locales.ts`).
const List<String> supportedLocaleTags = [
  'en', 'es', 'tr', 'ja', 'de', 'fr', 'it', 'ar', 'he', 'fil', 'pt', 'pt-BR',
  'hi', 'ru', 'sv', 'nl', 'zh', 'hu', 'vi', 'th', 'pl', 'nb', 'da', 'ko',
  'uk', 'bg', 'el', 'fi', 'id', 'lt', 'ro', 'sk', 'sq', 'zh-Hant', //
];

/// Locales rendered right-to-left.
const List<String> rtlLocaleTags = ['ar', 'he'];

final Set<String> _supported = supportedLocaleTags.toSet();

/// Whether [tag] (a resolved tag from [resolveLocaleTag]) renders RTL.
bool isRtlLocale(String tag) => rtlLocaleTags.contains(tag);

/// Regions whose script-less `zh` tags mean Traditional Chinese.
const Set<String> _traditionalChineseRegions = {'TW', 'HK', 'MO'};

final RegExp _scriptSubtag = RegExp(r'^[A-Za-z]{4}$');
final RegExp _regionSubtag = RegExp(r'^([A-Za-z]{2}|\d{3})$');

/// Resolves a requested locale to a supported tag, mirroring the upstream
/// `resolveLocale` in `locales.ts` exactly. Candidates, in order:
/// `language-Script` (the first 4-letter subtag before any region,
/// title-cased), `language-REGION` (2 letters or 3 digits), then `language`;
/// otherwise `en`. A script-less `zh` with region `TW`, `HK` or `MO` implies
/// `Hant`. Unsupported scripts and regions are ignored (`pt-Latn-BR` →
/// `pt-BR`, `zh-CN` → `zh`). Case-insensitive; accepts `_` separators.
String resolveLocaleTag(String? requested) {
  if (requested == null || requested.isEmpty) return 'en';

  final parts = requested.trim().replaceAll('_', '-').split('-');
  final language = parts[0].toLowerCase();
  if (language.isEmpty) return 'en';

  String? script;
  String? region;
  for (final part in parts.skip(1)) {
    if (script == null && region == null && _scriptSubtag.hasMatch(part)) {
      script = part[0].toUpperCase() + part.substring(1).toLowerCase();
    } else if (region == null && _regionSubtag.hasMatch(part)) {
      region = part.toUpperCase();
    }
  }

  if (language == 'zh' &&
      script == null &&
      region != null &&
      _traditionalChineseRegions.contains(region)) {
    script = 'Hant';
  }

  final candidates = [
    if (script != null) '$language-$script',
    if (region != null) '$language-$region',
    language,
  ];
  for (final candidate in candidates) {
    if (_supported.contains(candidate)) return candidate;
  }
  return 'en';
}

/// Converts a resolved tag to a Flutter [Locale]: a 4-letter second subtag
/// is a script (`zh-Hant` → `Locale.fromSubtags(languageCode: 'zh',
/// scriptCode: 'Hant')`), anything else a country (`pt-BR` →
/// `Locale('pt', 'BR')`).
Locale localeForTag(String tag) {
  final parts = tag.split('-');
  if (parts.length < 2) return Locale(parts[0]);
  if (_scriptSubtag.hasMatch(parts[1])) {
    return Locale.fromSubtags(languageCode: parts[0], scriptCode: parts[1]);
  }
  return Locale(parts[0], parts[1]);
}
