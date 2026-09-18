import 'package:featurely/src/api/api_exception.dart';
import 'package:featurely/src/api/models.dart';
import 'package:featurely/src/core.dart';
import 'package:featurely/src/options.dart';
import 'package:featurely/src/ui/sandbox_strip.dart';
import 'package:featurely/src/ui/screens/chat_screen.dart';
import 'package:featurely/src/ui/sheet.dart';
import 'package:featurely/src/ui/widgets/chat_bubble.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:shared_preferences/shared_preferences.dart';

import 'harness.dart';

const _chatConfig = SdkConfig(
  projectName: 'Pocket Bartender',
  commentingEnabled: true,
  titleMax: 60,
  descriptionMax: 10000,
  commentMax: 5000,
  attachmentMaxBytes: 5242880,
  chatEnabled: true,
);

Future<void> _pumpChat(WidgetTester tester, FakeApi api,
    {FeaturelyEnvironment environment = FeaturelyEnvironment.sandbox,
    Locale? locale,
    FeaturelyCore? core,
    Map<String, String>? chatMetadata,
    String? initialMessage}) async {
  api.config = _chatConfig;
  await pumpSheet(
    tester,
    core ?? makeCore(api, environment: environment, locale: locale),
    root: FeaturelySheetRoot.chat,
    chatMetadata: chatMetadata,
    chatInitialMessage: initialMessage,
  );
  await tester.pump();
  await tester.pump();
}

/// Replaces the tree so the chat screen (and its poll timer) is disposed
/// before the framework's pending-timer check.
Future<void> _unmount(WidgetTester tester) =>
    tester.pumpWidget(const SizedBox.shrink());

Finder get _sendButton => find.byKey(const ValueKey('featurely-chat-send'));

bool _sendEnabled(WidgetTester tester) {
  final inkWell = tester.widget<InkWell>(
      find.descendant(of: _sendButton, matching: find.byType(InkWell)));
  return inkWell.onTap != null;
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('shows the localized greeting when there are no messages',
      (tester) async {
    final api = FakeApi();
    await _pumpChat(tester, api);
    expect(find.text('Messages'), findsOneWidget);
    expect(
      find.text('Hi there! Send us a message and our team will get back to '
          'you here.'),
      findsOneWidget,
    );
    await _unmount(tester);
  });

  testWidgets('composer: disabled when empty or over 4000 characters',
      (tester) async {
    final api = FakeApi();
    await _pumpChat(tester, api);
    expect(_sendEnabled(tester), isFalse);

    await tester.enterText(find.byType(TextField), '   ');
    await tester.pump();
    expect(_sendEnabled(tester), isFalse);

    await tester.enterText(find.byType(TextField), 'x' * 4000);
    await tester.pump();
    expect(_sendEnabled(tester), isTrue);
    expect(find.textContaining('too long'), findsNothing);

    await tester.enterText(find.byType(TextField), 'x' * 4001);
    await tester.pump();
    expect(_sendEnabled(tester), isFalse);
    expect(
      find.text('This message is too long. The limit is 4000 characters.'),
      findsOneWidget,
    );
    await _unmount(tester);
  });

  testWidgets(
      'sending shows the message, then its timestamp; failure offers '
      'tap-to-retry', (tester) async {
    final api = FakeApi();
    var fail = true;
    api.onSendChatMessage = (body, cid) async {
      if (fail) throw FeaturelyNetworkException();
      return makeChatMessage(id: 'm1', body: body, clientMessageId: cid);
    };
    await _pumpChat(tester, api);

    await tester.enterText(find.byType(TextField), 'Where is my order?');
    await tester.pump();
    await tester.tap(_sendButton);
    await tester.pump();
    await tester.pump();
    expect(find.text('Where is my order?'), findsOneWidget);
    expect(find.text('Not sent — Tap to retry'), findsOneWidget);

    fail = false;
    await tester.tap(find.text('Not sent — Tap to retry'));
    await tester.pump();
    await tester.pump();
    expect(find.text('Not sent — Tap to retry'), findsNothing);
    expect(api.sendCalls, hasLength(2));
    expect(api.sendCalls[0].$2, api.sendCalls[1].$2);
    expect(find.text('Where is my order?'), findsOneWidget);
    await _unmount(tester);
  });

  testWidgets(
      'team messages sit on the leading side, announced (not shown) as Team',
      (tester) async {
    final semantics = tester.ensureSemantics();
    final api = FakeApi();
    api.onGetChatMessages = (before, after) async => ChatMessagesPage(
          messages: after != null
              ? const []
              : [
                  makeChatMessage(id: 'u1', body: 'Hi'),
                  makeChatMessage(
                    id: 't1',
                    body: 'Hello from the team',
                    author: ChatAuthor.team,
                    createdAt: DateTime.utc(2026, 9, 1, 11),
                  ),
                ],
          olderCursor: after != null ? null : 'older',
          newerCursor: after ?? 'c1',
        );
    await _pumpChat(tester, api, locale: const Locale('en'));
    // No visible badge, but screen readers hear the sender with the body.
    expect(find.text('Team'), findsNothing);
    expect(
      find.bySemanticsLabel(RegExp(r'^Team\nHello from the team\n')),
      findsOneWidget,
    );
    expect(find.bySemanticsLabel(RegExp(r'Team\nHi\n')), findsNothing);
    expect(find.text('Load earlier messages'), findsOneWidget);

    final user = tester.getCenter(find.text('Hi'));
    final team = tester.getCenter(find.text('Hello from the team'));
    // LTR: user trailing (right), team leading (left).
    expect(user.dx, greaterThan(team.dx));
    await _unmount(tester);
    semantics.dispose();
  });

  group('day separators', () {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    DateTime daysAgo(int days, [int hour = 12]) =>
        DateTime(today.year, today.month, today.day - days, hour);

    double top(WidgetTester tester, String text) =>
        tester.getTopLeft(find.text(text)).dy;

    testWidgets('label each day above its first message, time-only meta',
        (tester) async {
      final api = FakeApi();
      final older = daysAgo(3, 9);
      api.onGetChatMessages = (before, after) async => ChatMessagesPage(
            messages: after != null
                ? const []
                : [
                    makeChatMessage(
                        id: 'a', body: 'Three days', createdAt: older),
                    makeChatMessage(
                        id: 'b', body: 'Yesterday 1', createdAt: daysAgo(1, 8)),
                    makeChatMessage(
                      id: 'c',
                      body: 'Yesterday 2',
                      author: ChatAuthor.team,
                      createdAt: daysAgo(1, 10),
                    ),
                    makeChatMessage(id: 'd', body: 'Today 1', createdAt: today),
                  ],
            olderCursor: null,
            newerCursor: after ?? 'c1',
          );
      await _pumpChat(tester, api, locale: const Locale('en'));

      final weekday = DateFormat.EEEE('en').format(older);
      expect(find.text(weekday), findsOneWidget);
      expect(find.text('Yesterday'), findsOneWidget);
      expect(find.text('Today'), findsOneWidget);
      // Each separator sits between the previous day and its own first row.
      expect(top(tester, weekday), lessThan(top(tester, 'Three days')));
      expect(top(tester, 'Three days'), lessThan(top(tester, 'Yesterday')));
      expect(top(tester, 'Yesterday'), lessThan(top(tester, 'Yesterday 1')));
      expect(top(tester, 'Yesterday 2'), lessThan(top(tester, 'Today')));
      expect(top(tester, 'Today'), lessThan(top(tester, 'Today 1')));
      // The meta row carries only the time.
      expect(find.text(DateFormat.jm('en').format(older)), findsOneWidget);
      await _unmount(tester);
    });

    testWidgets('a failed send joins today without a second separator',
        (tester) async {
      final api = FakeApi();
      api.onGetChatMessages = (before, after) async => ChatMessagesPage(
            messages: after != null
                ? const []
                : [
                    makeChatMessage(id: 'a', body: 'Old', createdAt: daysAgo(1))
                  ],
            olderCursor: null,
            newerCursor: after ?? 'c1',
          );
      api.onSendChatMessage =
          (body, cid) async => throw FeaturelyNetworkException();
      await _pumpChat(tester, api, locale: const Locale('en'));
      expect(find.text('Today'), findsNothing);

      for (final body in ['First', 'Second']) {
        await tester.enterText(find.byType(TextField).last, body);
        await tester.pump();
        await tester.tap(_sendButton);
        await tester.pump();
        await tester.pump();
      }
      expect(find.text('Not sent — Tap to retry'), findsNWidgets(2));
      expect(find.text('Today'), findsOneWidget);
      expect(top(tester, 'Old'), lessThan(top(tester, 'Today')));
      expect(top(tester, 'Today'), lessThan(top(tester, 'First')));
      await _unmount(tester);
    });

    testWidgets('"Load earlier" re-groups prepended messages', (tester) async {
      final api = FakeApi();
      final lastYear = DateTime(now.year - 1, 3, 4, 12);
      api.onGetChatMessages = (before, after) async {
        if (after != null) {
          return ChatMessagesPage(
              messages: const [], olderCursor: null, newerCursor: after);
        }
        if (before == null) {
          return ChatMessagesPage(
            messages: [
              makeChatMessage(id: 'b', body: 'Newer', createdAt: lastYear),
            ],
            olderCursor: 'older',
            newerCursor: 'c1',
          );
        }
        return ChatMessagesPage(
          messages: [
            makeChatMessage(
              id: 'a',
              body: 'Older same day',
              createdAt: lastYear.subtract(const Duration(hours: 1)),
            ),
          ],
          olderCursor: null,
          newerCursor: null,
        );
      };
      await _pumpChat(tester, api, locale: const Locale('en'));
      final label = DateFormat.yMMMd('en').format(lastYear);
      expect(find.text(label), findsOneWidget);
      expect(
          top(tester, 'Load earlier messages'), lessThan(top(tester, label)));

      await tester.tap(find.text('Load earlier messages'));
      await tester.pump();
      await tester.pump();
      expect(find.text('Older same day'), findsOneWidget);
      // Still one separator, now above the older message.
      expect(find.text(label), findsOneWidget);
      expect(top(tester, label), lessThan(top(tester, 'Older same day')));
      await _unmount(tester);
    });
  });

  testWidgets('RTL (ar) mirrors bubble sides', (tester) async {
    final api = FakeApi();
    api.onGetChatMessages = (before, after) async => ChatMessagesPage(
          messages: after != null
              ? const []
              : [
                  makeChatMessage(id: 'u1', body: 'Hi'),
                  makeChatMessage(
                    id: 't1',
                    body: 'Hello from the team',
                    author: ChatAuthor.team,
                    createdAt: DateTime.utc(2026, 9, 1, 11),
                  ),
                ],
          olderCursor: null,
          newerCursor: after ?? 'c1',
        );
    await _pumpChat(tester, api, locale: const Locale('ar'));
    final chat = tester.element(find.byType(ChatScreen));
    expect(Directionality.of(chat), TextDirection.rtl);
    final user = tester.getCenter(find.text('Hi'));
    final team = tester.getCenter(find.text('Hello from the team'));
    expect(user.dx, lessThan(team.dx));
    expect(find.byType(ChatBubble), findsNWidgets(2));
    await _unmount(tester);
  });

  testWidgets('failed initial load shows the shared error state with Retry',
      (tester) async {
    final api = FakeApi();
    var fail = true;
    api.onGetConversation = () async {
      if (fail) {
        throw FeaturelyApiException(FeaturelyErrorCode.invalidApiKey, 401);
      }
      return null;
    };
    await _pumpChat(tester, api);
    expect(find.text('Retry'), findsOneWidget);

    fail = false;
    await tester.tap(find.text('Retry'));
    await tester.pump();
    await tester.pump();
    expect(find.text('Retry'), findsNothing);
    expect(find.text('Messages'), findsOneWidget);
    await _unmount(tester);
  });

  testWidgets('polls while visible and stops once the chat is popped',
      (tester) async {
    final api = FakeApi();
    api.onList = (sort, status, cursor, limit) async =>
        const Page(items: [], nextCursor: null);
    api.config = _chatConfig;
    await pumpSheet(tester, makeCore(api));
    await tester.pump();

    await tester.tap(find.byKey(const ValueKey('featurely-message-us')));
    await tester.pumpAndSettle();
    expect(find.byType(ChatScreen), findsOneWidget);
    final afterOpen = api.chatMessageCalls.length;
    await tester.pump(const Duration(seconds: 5));
    expect(api.chatMessageCalls.length, afterOpen + 1);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.byType(ChatScreen), findsNothing);
    final afterClose = api.chatMessageCalls.length;
    await tester.pump(const Duration(seconds: 20));
    expect(api.chatMessageCalls.length, afterClose);
  });

  testWidgets('polling pauses while the app is in the background',
      (tester) async {
    final api = FakeApi();
    await _pumpChat(tester, api);
    final start = api.chatMessageCalls.length;
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await tester.pump(const Duration(seconds: 20));
    expect(api.chatMessageCalls.length, start);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    expect(api.chatMessageCalls.length, start + 1);
    await _unmount(tester);
  });

  testWidgets('chat shows the SANDBOX strip only in sandbox', (tester) async {
    final api = FakeApi();
    await _pumpChat(tester, api);
    expect(find.byType(SandboxStrip), findsOneWidget);
    await _unmount(tester);

    await _pumpChat(tester, FakeApi(), environment: FeaturelyEnvironment.live);
    expect(find.byType(ChatScreen), findsOneWidget);
    expect(find.byType(SandboxStrip), findsNothing);
    await _unmount(tester);
  });

  testWidgets('zh-TW renders Traditional and sends resolvedLocale zh-Hant',
      (tester) async {
    final api = FakeApi();
    await _pumpChat(tester, api, locale: const Locale('zh', 'TW'));
    expect(find.text('訊息'), findsOneWidget);
    await tester.enterText(find.byType(TextField), '你好');
    await tester.pump();
    await tester.tap(_sendButton);
    await tester.pump();
    expect(api.lastChatResolvedLocale, 'zh-Hant');
    await _unmount(tester);
  });

  group('initial message', () {
    TextField field(WidgetTester tester) =>
        tester.widget<TextField>(find.byType(TextField));

    testWidgets('prefills the composer, cursor at the end, without sending',
        (tester) async {
      final api = FakeApi();
      await _pumpChat(tester, api, initialMessage: '  About order #42  ');
      final controller = field(tester).controller!;
      expect(controller.text, 'About order #42');
      expect(controller.selection,
          const TextSelection.collapsed(offset: 'About order #42'.length));
      expect(
        tester
            .widget<EditableText>(find.byType(EditableText))
            .focusNode
            .hasFocus,
        isTrue,
      );
      expect(_sendEnabled(tester), isTrue);
      expect(api.sendCalls, isEmpty);

      // Editable before sending.
      await tester.enterText(find.byType(TextField), 'About order #43');
      await tester.pump();
      await tester.tap(_sendButton);
      await tester.pump();
      expect(api.sendCalls.single.$1, 'About order #43');
      // Applied once: not restored after the send.
      await tester.pump(const Duration(seconds: 1));
      expect(field(tester).controller!.text, isEmpty);
      await _unmount(tester);
    });

    testWidgets('a blank initial message leaves the composer empty',
        (tester) async {
      final api = FakeApi();
      await _pumpChat(tester, api, initialMessage: '   ');
      expect(field(tester).controller!.text, isEmpty);
      expect(
        tester
            .widget<EditableText>(find.byType(EditableText))
            .focusNode
            .hasFocus,
        isFalse,
      );
      expect(_sendEnabled(tester), isFalse);
      await _unmount(tester);
    });

    testWidgets('is not re-applied when the chat reloads after an error',
        (tester) async {
      final api = FakeApi();
      await _pumpChat(tester, api, initialMessage: 'Hello');
      await tester.enterText(find.byType(TextField), '');
      await tester.pump();

      // A 401 on the next poll drops the chat to its failed-load state.
      var fail = true;
      api.onGetChatMessages = (before, after) async {
        if (fail) {
          throw FeaturelyApiException(FeaturelyErrorCode.invalidApiKey, 401);
        }
        return const ChatMessagesPage(
            messages: [], olderCursor: null, newerCursor: null);
      };
      await tester.pump(const Duration(seconds: 5));
      await tester.pump();
      expect(find.text('Retry'), findsOneWidget);
      fail = false;
      await tester.tap(find.text('Retry'));
      await tester.pump();
      await tester.pump();
      expect(field(tester).controller!.text, isEmpty);
      await _unmount(tester);
    });

    testWidgets('is capped to the message limit', (tester) async {
      final api = FakeApi();
      await _pumpChat(tester, api, initialMessage: 'x' * 4100);
      expect(field(tester).controller!.text, 'x' * chatMessageMax);
      expect(_sendEnabled(tester), isTrue);
      expect(find.textContaining('too long'), findsNothing);
      await _unmount(tester);
    });

    testWidgets('"Message us" opens an empty composer', (tester) async {
      final api = FakeApi()..config = _chatConfig;
      await pumpSheet(tester, makeCore(api),
          chatInitialMessage: 'ignored for a list root');
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('featurely-message-us')));
      await tester.pumpAndSettle();
      expect(field(tester).controller!.text, isEmpty);
      await _unmount(tester);
    });
  });

  group('chat metadata', () {
    testWidgets('a standalone chat merges its metadata over the global map',
        (tester) async {
      final api = FakeApi();
      final core = makeCore(api)
        ..chatMetadata = const {'plan': 'free', 'screen': 'Home'};
      await _pumpChat(tester, api,
          core: core, chatMetadata: const {'screen': 'Checkout'});

      await tester.enterText(find.byType(TextField), 'Help');
      await tester.pump();
      await tester.tap(_sendButton);
      await tester.pump();
      expect(api.sendMetadata.single, {'plan': 'free', 'screen': 'Checkout'});

      // A later global change applies to the next message.
      core.chatMetadata = const {'plan': 'pro'};
      await tester.enterText(find.byType(TextField), 'Again');
      await tester.pump();
      await tester.tap(_sendButton);
      await tester.pump();
      expect(api.sendMetadata.last, {'plan': 'pro', 'screen': 'Checkout'});
      await _unmount(tester);
    });

    testWidgets('"Message us" sends only the global metadata', (tester) async {
      final api = FakeApi()..config = _chatConfig;
      final core = makeCore(api)..chatMetadata = const {'plan': 'pro'};
      await pumpSheet(tester, core,
          chatMetadata: const {'screen': 'ignored for a list root'});
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('featurely-message-us')));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Hi');
      await tester.pump();
      await tester.tap(_sendButton);
      await tester.pump();
      expect(api.sendMetadata.single, {'plan': 'pro'});
      await _unmount(tester);
    });

    testWidgets('no metadata sends none', (tester) async {
      final api = FakeApi();
      await _pumpChat(tester, api);
      await tester.enterText(find.byType(TextField), 'Hi');
      await tester.pump();
      await tester.tap(_sendButton);
      await tester.pump();
      expect(api.sendMetadata.single, isNull);
      await _unmount(tester);
    });
  });

  group('"Message us" on the list', () {
    testWidgets('hidden when chatEnabled is false', (tester) async {
      final api = FakeApi(); // Default config: chatEnabled false.
      await pumpSheet(tester, makeCore(api));
      await tester.pump();
      expect(find.byKey(const ValueKey('featurely-message-us')), findsNothing);
      expect(find.bySemanticsLabel('Message us'), findsNothing);
    });

    test('older servers without chatEnabled decode to disabled', () {
      expect(SdkConfig.fromJson(const {}).chatEnabled, isFalse);
      expect(const SdkConfig.defaults().chatEnabled, isFalse);
      expect(
        SdkConfig.fromJson(const {'chatEnabled': true}).chatEnabled,
        isTrue,
      );
    });

    testWidgets('shown when chatEnabled is true and pushes the chat route',
        (tester) async {
      final api = FakeApi()..config = _chatConfig;
      await pumpSheet(tester, makeCore(api));
      await tester.pump();
      final action = find.byKey(const ValueKey('featurely-message-us'));
      expect(action, findsOneWidget);
      expect(find.bySemanticsLabel('Message us'), findsOneWidget);

      await tester.tap(action);
      await tester.pumpAndSettle();
      expect(find.text('Messages'), findsOneWidget);
      final route = ModalRoute.of(tester.element(find.byType(ChatScreen)));
      expect(route?.settings.name, 'chat');
      // Pushed inside the sheet's own stack: Back, not Close.
      expect(find.byTooltip('Back'), findsOneWidget);
      await _unmount(tester);
    });
  });
}
