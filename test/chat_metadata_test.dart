import 'package:featurely/src/chat_metadata.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('effectiveChatMetadata', () {
    test('null or empty inputs yield null', () {
      expect(effectiveChatMetadata(null, null), isNull);
      expect(effectiveChatMetadata(const {}, const {}), isNull);
      expect(effectiveChatMetadata(const {' ': 'x', 'k': '  '}, null), isNull);
    });

    test('local wins over global on a key collision', () {
      expect(
        effectiveChatMetadata(
          const {'plan': 'pro', 'screen': 'Home'},
          const {'screen': 'Checkout', 'orderId': '42'},
        ),
        {'orderId': '42', 'plan': 'pro', 'screen': 'Checkout'},
      );
    });

    test('keys are trimmed before merging', () {
      expect(
        effectiveChatMetadata(
            const {'screen': 'Home'}, const {' screen ': 'A'}),
        {'screen': 'A'},
      );
    });

    test('a blank local value does not erase the global one', () {
      expect(
        effectiveChatMetadata(const {'screen': 'Home'}, const {'screen': ' '}),
        {'screen': 'Home'},
      );
    });

    test(
        'values are trimmed; blank keys, blank values and long keys are '
        'dropped', () {
      final longKey = 'k' * (chatMetadataKeyMax + 1);
      final maxKey = 'k' * chatMetadataKeyMax;
      expect(
        effectiveChatMetadata({
          '': 'x',
          '   ': 'x',
          'empty': '',
          'spaces': '   ',
          longKey: 'dropped',
          ' $maxKey ': 'kept',
          'value': '  padded  ',
        }, null),
        {maxKey: 'kept', 'value': 'padded'},
      );
    });

    test('values are truncated to 500 UTF-16 code units', () {
      final result = effectiveChatMetadata({'k': 'a' * 600}, null)!;
      expect(result['k'], 'a' * chatMetadataValueMax);

      // Trimming happens before truncation.
      final padded = effectiveChatMetadata({'k': '   ${'b' * 500}'}, null)!;
      expect(padded['k'], 'b' * 500);
    });

    test('truncation never splits a surrogate pair', () {
      // 499 ASCII chars then an emoji (2 code units) straddling the limit.
      final value = '${'a' * 499}😀tail';
      final result = effectiveChatMetadata({'k': value}, null)!;
      expect(result['k'], 'a' * 499);
    });

    test('keeps the first 20 entries by sorted key', () {
      final input = {
        for (var i = 24; i >= 0; i--)
          'key${i.toString().padLeft(2, '0')}': '$i',
      };
      final result = effectiveChatMetadata(input, null)!;
      expect(result, hasLength(chatMetadataMaxEntries));
      expect(result.keys.first, 'key00');
      expect(result.keys.last, 'key19');
      expect(result.containsKey('key20'), isFalse);
    });

    test('the cap applies after merging', () {
      final global = {for (var i = 0; i < 15; i++) 'g$i': 'x'};
      final local = {for (var i = 0; i < 15; i++) 'l$i': 'y'};
      expect(effectiveChatMetadata(global, local), hasLength(20));
    });

    test('the result is unmodifiable', () {
      final result = effectiveChatMetadata(const {'a': 'b'}, null)!;
      expect(() => result['c'] = 'd', throwsUnsupportedError);
    });
  });
}
