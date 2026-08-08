import 'package:featurely/src/l10n/locale_resolution.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('resolveLocaleTag mirrors locales.ts', () {
    test('exact language match', () {
      expect(resolveLocaleTag('de'), 'de');
      expect(resolveLocaleTag('en'), 'en');
      expect(resolveLocaleTag('fil'), 'fil');
    });

    test('exact regional match', () {
      expect(resolveLocaleTag('pt-BR'), 'pt-BR');
    });

    test('region collapse to base language', () {
      expect(resolveLocaleTag('pt-PT'), 'pt');
      expect(resolveLocaleTag('de-CH'), 'de');
      expect(resolveLocaleTag('en-GB'), 'en');
      expect(resolveLocaleTag('zh-CN'), 'zh');
    });

    test('underscore separators accepted', () {
      expect(resolveLocaleTag('pt_BR'), 'pt-BR');
      expect(resolveLocaleTag('de_CH'), 'de');
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
  });
}
