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
    Map<String, String>? chatMetadata}) async {
  api.config = _chatConfig;
  await pumpSheet(
    tester,
    core ?? makeCore(api, environment: environment, locale: locale),
    root: FeaturelySheetRoot.chat,
    chatMetadata: chatMetadata,
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
    expect(find.text('Get replies by email'), findsOneWidget);
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

  testWidgets('team messages carry the Team label on the leading side',
      (tester) async {
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
    expect(find.text('Team'), findsOneWidget);
    expect(find.text('Load earlier messages'), findsOneWidget);

    final user = tester.getCenter(find.text('Hi'));
    final team = tester.getCenter(find.text('Hello from the team'));
    // LTR: user trailing (right), team leading (left).
    expect(user.dx, greaterThan(team.dx));
    await _unmount(tester);
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

  testWidgets('email row validates, saves, and shows the address with Edit',
      (tester) async {
    final api = FakeApi();
    await _pumpChat(tester, api);

    await tester.tap(find.text('Get replies by email'));
    await tester.pump();
    final field = find.byKey(const ValueKey('featurely-chat-email-field'));
    expect(field, findsOneWidget);

    await tester.enterText(field, 'nope');
    await tester.tap(find.text('Save'));
    await tester.pump();
    expect(find.text('Enter a valid email address.'), findsOneWidget);
    expect(api.emailCalls, isEmpty);

    // Server-side rejection surfaces the same message.
    api.onSetChatEmail = (email) async =>
        throw FeaturelyApiException(FeaturelyErrorCode.invalidEmail, 400);
    await tester.enterText(field, 'me@bad.example');
    await tester.tap(find.text('Save'));
    await tester.pump();
    await tester.pump();
    expect(find.text('Enter a valid email address.'), findsOneWidget);

    api.onSetChatEmail = null;
    await tester.enterText(field, 'me@example.com');
    await tester.tap(find.text('Save'));
    await tester.pump();
    await tester.pump();
    expect(api.emailCalls.last, 'me@example.com');
    expect(find.text('Email for replies'), findsOneWidget);
    expect(find.text('me@example.com'), findsOneWidget);
    expect(find.text('Edit'), findsOneWidget);

    await tester.tap(find.text('Edit'));
    await tester.pump();
    expect(field, findsOneWidget);
    await _unmount(tester);
  });

  testWidgets('a saved contact email is shown on open', (tester) async {
    final api = FakeApi();
    api.onGetConversation =
        () async => makeConversation(email: 'saved@example.com');
    await _pumpChat(tester, api);
    expect(find.text('saved@example.com'), findsOneWidget);
    expect(find.text('Get replies by email'), findsNothing);
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
    expect(find.text('Get replies by email'), findsOneWidget);
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
