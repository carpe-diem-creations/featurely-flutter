import 'package:featurely/src/api/models.dart';
import 'package:featurely/src/chat_actions.dart';
import 'package:featurely/src/core.dart';
import 'package:featurely/src/ui/screens/chat_screen.dart';
import 'package:featurely/src/ui/sheet.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'harness.dart';

const _steps = 'Your iPhone never showed the pairing prompt. Let\'s retry:\n'
    '1. Keep the watch on the "Pair with iPhone" screen.\n'
    '2. Tap "Try again" below.\n'
    'Did the prompt appear?';

/// Serves [messages] as the newest page and [pending] as the assistant flag
/// on every page.
void _serve(FakeApi api, List<ChatMessage> messages,
    {bool Function()? pending}) {
  api.onGetChatMessages = (before, after) async => ChatMessagesPage(
        messages: after == null ? messages : const [],
        olderCursor: null,
        newerCursor: 'c1',
        assistantPending: pending?.call() ?? false,
      );
}

Future<void> _pumpChat(WidgetTester tester, FeaturelyCore core) async {
  await pumpSheet(tester, core, root: FeaturelySheetRoot.chat);
  await tester.pump();
  await tester.pump();
}

/// Replaces the tree so the chat screen (and its poll timer) is disposed.
Future<void> _unmount(WidgetTester tester) =>
    tester.pumpWidget(const SizedBox.shrink());

Finder _action(String messageId, String actionId) =>
    find.byKey(ValueKey('featurely-chat-action-$messageId-$actionId'));

const _actions = [
  FeaturelyChatAction(id: 'open_settings', title: 'Open Settings'),
  FeaturelyChatAction(id: 'retry_pairing', title: 'Try again'),
];

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets(
      'assistant messages show the name (no AI tag), with numbered lines as '
      'plain text', (tester) async {
    final api = FakeApi();
    _serve(api, [makeAssistantMessage(id: 'a1', body: _steps)]);
    await _pumpChat(tester, makeCore(api));

    expect(find.text('Lyn'), findsOneWidget);
    expect(find.text('AI'), findsNothing);
    expect(
        find.text("Your iPhone never showed the pairing prompt. Let's "
            'retry:'),
        findsOneWidget);
    expect(find.text('1.'), findsOneWidget);
    expect(find.text('Keep the watch on the "Pair with iPhone" screen.'),
        findsOneWidget);
    expect(find.text('2.'), findsOneWidget);
    expect(find.text('Did the prompt appear?'), findsOneWidget);
    // The number column hangs: step text starts after it.
    expect(
      tester.getTopLeft(find.text('Tap "Try again" below.')).dx,
      greaterThan(tester.getTopLeft(find.text('2.')).dx),
    );
    await _unmount(tester);
  });

  testWidgets('markdown is shown as typed; a missing name uses the default',
      (tester) async {
    final api = FakeApi();
    _serve(api, [
      makeAssistantMessage(
          id: 'a1', authorName: null, body: '**Bold** and # heading'),
    ]);
    await _pumpChat(tester, makeCore(api));
    expect(find.text('**Bold** and # heading'), findsOneWidget);
    expect(find.text('Assistant'), findsOneWidget);
    expect(find.text('AI'), findsNothing);
    await _unmount(tester);
  });

  testWidgets('team messages from people carry no AI tag', (tester) async {
    final api = FakeApi();
    _serve(api, [
      makeChatMessage(id: 't1', author: ChatAuthor.team, body: 'Hi from Vin'),
    ]);
    await _pumpChat(tester, makeCore(api));
    expect(find.text('Hi from Vin'), findsOneWidget);
    expect(find.text('AI'), findsNothing);
    await _unmount(tester);
  });

  testWidgets('the typing row follows assistantPending', (tester) async {
    final api = FakeApi();
    var pending = true;
    _serve(api, [makeAssistantMessage(id: 'a1')], pending: () => pending);
    await _pumpChat(tester, makeCore(api));
    expect(find.text('Lyn is typing…'), findsOneWidget);

    pending = false;
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pump();
    expect(find.text('Lyn is typing…'), findsNothing);
    await _unmount(tester);
  });

  testWidgets('before any assistant reply the typing row uses the default name',
      (tester) async {
    final api = FakeApi();
    _serve(api, [makeChatMessage(id: 'u1', body: 'Help')], pending: () => true);
    await _pumpChat(tester, makeCore(api));
    expect(find.text('Assistant is typing…'), findsOneWidget);
    await _unmount(tester);
  });

  testWidgets('German renders the typing row from its catalog, with no tag',
      (tester) async {
    final api = FakeApi();
    _serve(api, [makeAssistantMessage(id: 'a1')], pending: () => true);
    await _pumpChat(tester, makeCore(api, locale: const Locale('de')));
    expect(find.text('KI'), findsNothing);
    expect(find.text('Lyn schreibt…'), findsOneWidget);
    await _unmount(tester);
  });

  testWidgets('only registered actions render, and only with a handler',
      (tester) async {
    final api = FakeApi();
    _serve(api, [
      makeAssistantMessage(
          id: 'a1', actions: ['retry_pairing', 'unknown_action']),
    ]);
    final core = makeCore(api)..chatActions = _actions;
    await _pumpChat(tester, core);
    // No handler yet: nothing to act with.
    expect(find.text('Try again'), findsNothing);
    await _unmount(tester);

    core.chatActionHandler = (id) => FeaturelyChatActionResult.stay;
    await _pumpChat(tester, core);
    expect(_action('a1', 'retry_pairing'), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
    expect(find.text('Open Settings'), findsNothing);
    expect(find.textContaining('unknown_action'), findsNothing);
    await _unmount(tester);
  });

  testWidgets(
      'a tap calls the handler once; stay keeps the chat open and the '
      'action shows as used for the session', (tester) async {
    final api = FakeApi();
    _serve(api, [
      makeAssistantMessage(id: 'a1', actions: ['open_settings']),
    ]);
    final taps = <String>[];
    final core = makeCore(api)
      ..chatActions = _actions
      ..chatActionHandler = (id) {
        taps.add(id);
        return FeaturelyChatActionResult.stay;
      };
    await _pumpChat(tester, core);

    await tester.tap(find.text('Open Settings'));
    await tester.pump();
    expect(taps, ['open_settings']);
    expect(find.byType(ChatScreen), findsOneWidget);
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);

    await tester.tap(find.text('Open Settings'));
    await tester.pump();
    expect(taps, ['open_settings']);
    await _unmount(tester);

    // A later presentation in the same session keeps it used.
    await _pumpChat(tester, core);
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);
    await _unmount(tester);
  });

  testWidgets('a throwing handler keeps the chat open', (tester) async {
    final api = FakeApi();
    _serve(api, [
      makeAssistantMessage(id: 'a1', actions: ['open_settings']),
    ]);
    final core = makeCore(api)
      ..chatActions = _actions
      ..chatActionHandler = (id) => throw StateError('host bug');
    await _pumpChat(tester, core);
    await tester.tap(find.text('Open Settings'));
    await tester.pump();
    expect(find.byType(ChatScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
    await _unmount(tester);
  });

  group('dismiss', () {
    Future<void> openSheet(WidgetTester tester, FeaturelyCore core,
        {GlobalKey<NavigatorState>? navigatorKey}) async {
      await tester.pumpWidget(MaterialApp(
        navigatorKey: navigatorKey,
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => showFeaturelySheet(context, core,
                  root: FeaturelySheetRoot.chat),
              child: const Text('Open chat'),
            ),
          ),
        ),
      ));
      await tester.tap(find.text('Open chat'));
      await tester.pumpAndSettle();
      expect(find.byType(ChatScreen), findsOneWidget);
    }

    testWidgets('closes the sheet the chat was presented in', (tester) async {
      final api = FakeApi();
      _serve(api, [
        makeAssistantMessage(id: 'a1', actions: ['open_settings']),
      ]);
      final taps = <String>[];
      final core = makeCore(api)
        ..chatActions = _actions
        ..chatActionHandler = (id) {
          taps.add(id);
          return FeaturelyChatActionResult.dismiss;
        };
      await openSheet(tester, core);

      await tester.tap(find.text('Open Settings'));
      await tester.pumpAndSettle();
      expect(taps, ['open_settings']);
      expect(find.byType(ChatScreen), findsNothing);
      expect(find.text('Open chat'), findsOneWidget);
    });

    testWidgets('keeps a route the handler pushed, removing only the sheet',
        (tester) async {
      final api = FakeApi();
      _serve(api, [
        makeAssistantMessage(id: 'a1', actions: ['open_settings']),
      ]);
      final navigatorKey = GlobalKey<NavigatorState>();
      final core = makeCore(api)
        ..chatActions = _actions
        ..chatActionHandler = (id) {
          navigatorKey.currentState!.push(MaterialPageRoute<void>(
            builder: (_) => const Scaffold(body: Text('Host settings')),
          ));
          return FeaturelyChatActionResult.dismiss;
        };
      await openSheet(tester, core, navigatorKey: navigatorKey);

      await tester.tap(find.text('Open Settings'));
      await tester.pumpAndSettle();
      expect(find.text('Host settings'), findsOneWidget);
      expect(find.byType(ChatScreen), findsNothing);
      navigatorKey.currentState!.pop();
      await tester.pumpAndSettle();
      expect(find.text('Open chat'), findsOneWidget);
    });
  });
}
