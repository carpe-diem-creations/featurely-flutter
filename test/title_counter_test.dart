import 'package:featurely/src/ui/screens/form_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('title counting at the 60 limit is in Unicode characters', () {
    test('plain ASCII', () {
      expect(remainingTitleCharacters('', 60), 60);
      expect(remainingTitleCharacters('a' * 60, 60), 0);
      expect(remainingTitleCharacters('a' * 55, 60), 5);
    });

    test('emoji count as one character, not their UTF-16 units', () {
      final emoji = '😀' * 55; // 2 UTF-16 code units each.
      expect(emoji.length, 110);
      expect(remainingTitleCharacters(emoji, 60), 5);
    });

    test('combined grapheme clusters count as one', () {
      // Family emoji: 7 code points joined by ZWJ — one visible character.
      const family = '👨‍👩‍👧‍👦';
      expect(remainingTitleCharacters(family, 60), 59);
    });

    test('multibyte CJK counts per character', () {
      expect(remainingTitleCharacters('日本語のタイトル', 60), 52);
    });
  });
}
