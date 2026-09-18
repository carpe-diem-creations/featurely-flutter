import 'dart:async';
import 'dart:convert';

import 'package:featurely/src/chat_actions.dart';
import 'package:featurely/src/chat_diagnostics.dart';
import 'package:flutter_test/flutter_test.dart';

/// A map nested [levels] deep, counting the top-level map as level 1.
Map<String, Object?> _nested(int levels) {
  Object? value = 'leaf';
  for (var i = 1; i < levels; i++) {
    value = {'k': value};
  }
  return {'k': value};
}

void main() {
  group('validChatDiagnostics', () {
    test('accepts JSON values and returns a detached copy', () {
      final input = <String, Object?>{
        'bluetooth': 'on',
        'bonded': false,
        'minutes': 42,
        'ratio': 0.5,
        'missing': null,
        'watch': {
          'model': 'Galaxy Watch7',
          'codes': [1, 2]
        },
      };
      final result = validChatDiagnostics(input);
      expect(result, input);
      (input['watch']! as Map)['model'] = 'changed later';
      expect((result!['watch']! as Map)['model'], 'Galaxy Watch7');
    });

    test('null and empty send none', () {
      expect(validChatDiagnostics(null), isNull);
      expect(validChatDiagnostics(const {}), isNull);
    });

    test('nesting: 3 levels (top-level included) pass, 4 are dropped', () {
      expect(validChatDiagnostics(_nested(3)), isNotNull);
      expect(validChatDiagnostics(_nested(4)), isNull);
      expect(
          validChatDiagnostics({
            'a': [
              [1]
            ]
          }),
          isNotNull);
      expect(
          validChatDiagnostics({
            'a': [
              [
                [1]
              ]
            ]
          }),
          isNull);
    });

    test('strings: 200 characters pass, 201 are dropped', () {
      expect(validChatDiagnostics({'s': 'x' * 200}), isNotNull);
      expect(validChatDiagnostics({'s': 'x' * 201}), isNull);
      expect(
          validChatDiagnostics({
            'list': ['x' * 201]
          }),
          isNull);
    });

    test('arrays: 30 items pass, 31 are dropped', () {
      expect(validChatDiagnostics({'a': List.filled(30, 1)}), isNotNull);
      expect(validChatDiagnostics({'a': List.filled(31, 1)}), isNull);
    });

    test('size: 4096 bytes of JSON pass, 4097 are dropped', () {
      Map<String, Object?> sized(int bytes) {
        // {"k0":"…",…}: fill with 200-char strings, then pad the last one.
        final map = <String, Object?>{};
        var i = 0;
        while (utf8.encode(jsonEncode(map)).length + 220 < bytes) {
          map['k${i++}'] = 'x' * 200;
        }
        map['pad'] = '';
        final missing = bytes - utf8.encode(jsonEncode(map)).length;
        map['pad'] = 'x' * missing;
        expect(utf8.encode(jsonEncode(map)).length, bytes);
        return map;
      }

      expect(validChatDiagnostics(sized(4096)), isNotNull);
      expect(validChatDiagnostics(sized(4097)), isNull);
    });

    test('bytes are counted in UTF-8', () {
      // 200 characters but 600 bytes each.
      final map = {for (var i = 0; i < 7; i++) 'k$i': '€' * 200};
      expect(utf8.encode(jsonEncode(map)).length, greaterThan(4096));
      expect(validChatDiagnostics(map), isNull);
    });

    test('non-JSON values drop the whole snapshot', () {
      expect(validChatDiagnostics({'when': DateTime(2026)}), isNull);
      expect(validChatDiagnostics({'n': double.nan}), isNull);
      expect(validChatDiagnostics({'n': double.infinity}), isNull);
      expect(
          validChatDiagnostics({
            'm': {1: 'int key'}
          }),
          isNull);
      expect(
          validChatDiagnostics({
            'ok': 1,
            'set': <int>{1}
          }),
          isNull);
    });
  });

  group('collectChatDiagnostics', () {
    test('no provider sends none', () async {
      expect(await collectChatDiagnostics(null), isNull);
    });

    test('a valid result is returned', () async {
      expect(await collectChatDiagnostics(() async => {'a': 1}), {'a': 1});
    });

    test('a null result sends none', () async {
      expect(await collectChatDiagnostics(() async => null), isNull);
    });

    test('a throwing provider (sync or async) sends none', () async {
      expect(await collectChatDiagnostics(() => throw StateError('x')), isNull);
      expect(await collectChatDiagnostics(() async => throw StateError('x')),
          isNull);
    });

    test('an invalid result sends none', () async {
      expect(
          await collectChatDiagnostics(() async => {'s': 'x' * 201}), isNull);
    });

    testWidgets('a provider slower than 1 s sends none', (tester) async {
      final never = Completer<Map<String, Object?>?>();
      Map<String, Object?>? result = {'sentinel': true};
      var done = false;
      unawaited(collectChatDiagnostics(() => never.future).then((value) {
        result = value;
        done = true;
      }));
      await tester.pump(const Duration(milliseconds: 999));
      expect(done, isFalse);
      await tester.pump(const Duration(milliseconds: 1));
      expect(done, isTrue);
      expect(result, isNull);
    });
  });

  group('cleanChatActions', () {
    test('keeps valid actions, trimming titles', () {
      expect(
        cleanChatActions(const [
          FeaturelyChatAction(id: 'open_settings', title: ' Open Settings '),
          FeaturelyChatAction(id: 'r2', title: 'Retry'),
        ]),
        const [
          FeaturelyChatAction(id: 'open_settings', title: 'Open Settings'),
          FeaturelyChatAction(id: 'r2', title: 'Retry'),
        ],
      );
    });

    test('drops invalid ids, blank titles and duplicates (first wins)', () {
      final cleaned = cleanChatActions([
        const FeaturelyChatAction(id: 'Open', title: 'Upper case'),
        const FeaturelyChatAction(id: '1st', title: 'Leading digit'),
        const FeaturelyChatAction(id: 'with-dash', title: 'Dash'),
        FeaturelyChatAction(id: 'a${'b' * 40}', title: '41 chars'),
        FeaturelyChatAction(id: 'a${'b' * 39}', title: '40 chars'),
        const FeaturelyChatAction(id: 'blank', title: '   '),
        const FeaturelyChatAction(id: 'dup', title: 'First'),
        const FeaturelyChatAction(id: 'dup', title: 'Second'),
      ]);
      expect(cleaned.map((a) => a.id), ['a${'b' * 39}', 'dup']);
      expect(cleaned.last.title, 'First');
    });

    test('caps the list at 12', () {
      final cleaned = cleanChatActions([
        for (var i = 0; i < 15; i++)
          FeaturelyChatAction(id: 'action_$i', title: 'Action $i'),
      ]);
      expect(cleaned, hasLength(12));
      expect(cleaned.last.id, 'action_11');
      expect(
          () => (cleaned as List).add(cleaned.first), throwsUnsupportedError);
    });
  });
}
