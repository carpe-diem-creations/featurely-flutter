import 'package:featurely/src/l10n/generated/featurely_localizations.dart';
import 'package:featurely/src/l10n/locale_resolution.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('resolveLocaleTag mirrors locales.ts', () {
    test('exact language match', () {
      expect(resolveLocaleTag('de'), 'de');
      expect(resolveLocaleTag('en'), 'en');
      expect(resolveLocaleTag('fil'), 'fil');
      for (final tag in ['bg', 'el', 'fi', 'id', 'lt', 'ro', 'sk', 'sq']) {
        expect(resolveLocaleTag(tag), tag);
      }
    });

    test('exact regional match', () {
      expect(resolveLocaleTag('pt-BR'), 'pt-BR');
    });

    test('region collapse to base language', () {
      expect(resolveLocaleTag('pt-PT'), 'pt');
      expect(resolveLocaleTag('de-CH'), 'de');
      expect(resolveLocaleTag('en-GB'), 'en');
      expect(resolveLocaleTag('zh-CN'), 'zh');
      expect(resolveLocaleTag('id-ID'), 'id');
      expect(resolveLocaleTag('ro-MD'), 'ro');
      expect(resolveLocaleTag('sq-XK'), 'sq');
    });

    test('underscore separators accepted', () {
      expect(resolveLocaleTag('pt_BR'), 'pt-BR');
      expect(resolveLocaleTag('de_CH'), 'de');
      expect(resolveLocaleTag('el_GR'), 'el');
      expect(resolveLocaleTag('fi_FI'), 'fi');
    });

    test('case-insensitive', () {
      expect(resolveLocaleTag('PT-br'), 'pt-BR');
      expect(resolveLocaleTag('DE'), 'de');
      expect(resolveLocaleTag('pt_br'), 'pt-BR');
    });

    test('unknown falls back to en', () {
      expect(resolveLocaleTag('xx'), 'en');
      expect(resolveLocaleTag('xx-YY'), 'en');
    });

    test('null and empty fall back to en', () {
      expect(resolveLocaleTag(null), 'en');
      expect(resolveLocaleTag(''), 'en');
      expect(resolveLocaleTag('   '), 'en');
      expect(resolveLocaleTag('-CH'), 'en');
    });

    test('extra subtags ignored beyond region', () {
      expect(resolveLocaleTag('zh-Hans-CN'), 'zh');
    });

    test('mirrors resolve.test.ts: exact, case and separator cases', () {
      expect(resolveLocaleTag('ar'), 'ar');
      expect(resolveLocaleTag('JA'), 'ja');
      expect(resolveLocaleTag('es-419'), 'es');
      expect(resolveLocaleTag('de-AT'), 'de');
      expect(resolveLocaleTag('not a locale'), 'en');
    });

    test('resolves Chinese by script, then by Traditional-writing region', () {
      expect(resolveLocaleTag('zh-Hant'), 'zh-Hant');
      expect(resolveLocaleTag('zh_hant_HK'), 'zh-Hant');
      expect(resolveLocaleTag('zh-Hant-TW'), 'zh-Hant');
      expect(resolveLocaleTag('zh-TW'), 'zh-Hant');
      expect(resolveLocaleTag('zh-HK'), 'zh-Hant');
      expect(resolveLocaleTag('zh-MO'), 'zh-Hant');
      expect(resolveLocaleTag('zh-Hans'), 'zh');
      expect(resolveLocaleTag('zh-Hans-TW'), 'zh');
      expect(resolveLocaleTag('zh-Hans-CN'), 'zh');
      expect(resolveLocaleTag('zh-SG'), 'zh');
      expect(resolveLocaleTag('zh'), 'zh');
      expect(resolveLocaleTag('ZH-HANT'), 'zh-Hant');
    });

    test('ignores scripts it has no catalog for', () {
      expect(resolveLocaleTag('sr-Latn-RS'), 'en');
      expect(resolveLocaleTag('pt-Latn-BR'), 'pt-BR');
      expect(resolveLocaleTag('uz-Cyrl'), 'en');
    });

    test('a script after the region is not a script', () {
      expect(resolveLocaleTag('zh-CN-Hant'), 'zh');
    });

    test('Flutter Locale objects resolve via toLanguageTag', () {
      String resolve(Locale locale) => resolveLocaleTag(locale.toLanguageTag());
      expect(
        resolve(const Locale.fromSubtags(
            languageCode: 'zh', scriptCode: 'Hant', countryCode: 'TW')),
        'zh-Hant',
      );
      expect(
        resolve(const Locale.fromSubtags(
            languageCode: 'zh', scriptCode: 'Hans', countryCode: 'HK')),
        'zh',
      );
      expect(resolve(const Locale('zh', 'TW')), 'zh-Hant');
      expect(resolve(const Locale('zh', 'HK')), 'zh-Hant');
      expect(resolve(const Locale('zh', 'CN')), 'zh');
      expect(resolve(const Locale('pt', 'BR')), 'pt-BR');
    });
  });

  test('ships the 34 upstream locales in upstream order', () {
    expect(supportedLocaleTags, hasLength(34));
    expect(supportedLocaleTags.toSet(), hasLength(34));
    expect(supportedLocaleTags.sublist(25),
        ['bg', 'el', 'fi', 'id', 'lt', 'ro', 'sk', 'sq', 'zh-Hant']);
  });

  test('zh-Hant loads the Traditional catalog, zh the Simplified one',
      () async {
    final hant = localeForTag('zh-Hant');
    expect(hant.languageCode, 'zh');
    expect(hant.scriptCode, 'Hant');
    expect(hant.countryCode, isNull);
    expect(hant.toLanguageTag(), 'zh-Hant');
    final traditional = await FeaturelyLocalizations.delegate.load(hant);
    expect(traditional.sdkListNewFeedback, '新增回饋');
    expect(traditional.sdkListComments(2), '2 則留言');
    final simplified =
        await FeaturelyLocalizations.delegate.load(localeForTag('zh'));
    expect(simplified.sdkListNewFeedback, isNot('新增回饋'));
  });

  test('every supported tag has a generated catalog', () async {
    for (final tag in supportedLocaleTags) {
      final locale = localeForTag(tag);
      expect(FeaturelyLocalizations.delegate.isSupported(locale), isTrue,
          reason: tag);
      final l10n = await FeaturelyLocalizations.delegate.load(locale);
      expect(l10n.sdkListTitle, isNotEmpty, reason: tag);
    }
  });

  test('new locales render their plural categories', () async {
    final lt = await FeaturelyLocalizations.delegate.load(const Locale('lt'));
    expect(lt.sdkListVotes(1), '1 balsas');
    expect(lt.sdkListVotes(3), '3 balsai');
    expect(lt.sdkListVotes(12), '12 balsų');

    final sk = await FeaturelyLocalizations.delegate.load(const Locale('sk'));
    expect(sk.sdkListComments(1), '1 komentár');
    expect(sk.sdkListComments(3), '3 komentáre');
    expect(sk.sdkListComments(7), '7 komentárov');

    final ro = await FeaturelyLocalizations.delegate.load(const Locale('ro'));
    expect(ro.sdkListVotes(2), '2 voturi');
    expect(ro.sdkListVotes(25), '25 de voturi');

    final id = await FeaturelyLocalizations.delegate.load(const Locale('id'));
    expect(id.sdkListVotes(1), '1 suara');
  });

  test('RTL locales are exactly ar and he', () {
    expect(isRtlLocale('ar'), isTrue);
    expect(isRtlLocale('he'), isTrue);
    expect(isRtlLocale('en'), isFalse);
    expect(isRtlLocale('fil'), isFalse);
  });

  test('localeForTag splits region', () {
    expect(localeForTag('pt-BR').languageCode, 'pt');
    expect(localeForTag('pt-BR').countryCode, 'BR');
    expect(localeForTag('ja').countryCode, isNull);
    expect(localeForTag('pt-BR').scriptCode, isNull);
  });
}
