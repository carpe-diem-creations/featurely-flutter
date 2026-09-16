import 'dart:async';

import 'package:featurely/src/api/api_exception.dart';
import 'package:featurely/src/api/models.dart';
import 'package:featurely/src/ui/controllers/chat_controller.dart';
import 'package:flutter_test/flutter_test.dart';

import 'widgets/harness.dart';

// testWidgets supplies a fake clock, so poll/pause timers are driven by
// `tester.pump(duration)`.

const _poll = Duration(seconds: 5);
const _pause = Duration(seconds: 30);

final List<ChatController> _live = [];

/// A widget test (for the fake clock) that disposes every controller it
/// created before the framework's pending-timer check.
void chatTest(String description, Future<void> Function(WidgetTester) body) {
  testWidgets(description, (tester) async {
    try {
      await body(tester);
    } finally {
      for (final controller in _live) {
        controller.dispose();
      }
      _live.clear();
    }
  });
}

ChatController _controller(FakeApi api, {List<String>? ids}) {
  var n = 0;
  final controller = ChatController(
    api: api,
    resolvedLocale: 'en',
    idGenerator: ids == null ? null : () => ids[n++],
  );
  _live.add(controller);
  return controller;
}

/// Lets pending microtasks (fake API futures) settle.
Future<void> _settle(WidgetTester tester) => tester.pump(Duration.zero);

void main() {
  chatTest('a never-seen device loads empty and makes no read call',
      (tester) async {
    final api = FakeApi();
    final controller = _controller(api)..setVisible(true);
    await controller.load();
    expect(controller.phase, ChatPhase.loaded);
    expect(controller.entries, isEmpty);
    expect(controller.canLoadEarlier, isFalse);
    expect(api.readCalls, 0);
  });

  chatTest(
      'optimistic send shows sending, then reconciles by '
      'clientMessageId and polls once', (tester) async {
    final api = FakeApi();
    api.onGetChatMessages = (before, after) async => ChatMessagesPage(
          messages: const [],
          olderCursor: null,
          newerCursor: after ?? 'c0',
        );
    final reply = Completer<ChatMessage>();
    api.onSendChatMessage = (body, cid) => reply.future;
    final controller =
        _controller(api, ids: ['11111111-1111-4111-8111-111111111111'])
          ..setVisible(true);
    await controller.load();
    final callsBefore = api.chatMessageCalls.length;

    unawaited(controller.send('  Hi team  '));
    await _settle(tester);
    expect(controller.entries.single.delivery, ChatDelivery.sending);
    expect(controller.entries.single.message.body, 'Hi team');
    expect(api.sendCalls.single,
        ('Hi team', '11111111-1111-4111-8111-111111111111'));

    reply.complete(makeChatMessage(
      id: 'm1',
      body: 'Hi team',
      clientMessageId: '11111111-1111-4111-8111-111111111111',
    ));
    await _settle(tester);
    expect(controller.entries.single.delivery, ChatDelivery.sent);
    expect(controller.entries.single.message.id, 'm1');
    // One immediate poll after the successful send, with the cursor.
    expect(api.chatMessageCalls.length, callsBefore + 1);
    expect(api.chatMessageCalls.last, (null, 'c0'));
  });

  chatTest('a poll returning our own message does not duplicate it',
      (tester) async {
    final api = FakeApi();
    const cid = '22222222-2222-4222-8222-222222222222';
    final stored = makeChatMessage(id: 'm1', clientMessageId: cid);
    api.onSendChatMessage = (body, clientMessageId) async => stored;
    api.onGetChatMessages = (before, after) async => ChatMessagesPage(
          messages: after == 'c0' ? [stored] : const [],
          olderCursor: null,
          newerCursor: after == 'c0' ? 'c1' : (after ?? 'c0'),
        );
    final controller = _controller(api, ids: [cid])..setVisible(true);
    await controller.load();
    await controller.send('Hello');
    await _settle(tester);
    expect(controller.entries, hasLength(1));
    expect(controller.newerCursor, 'c1');
  });

  chatTest('a failed send shows failed; retry reuses the clientMessageId',
      (tester) async {
    final api = FakeApi();
    var fail = true;
    api.onSendChatMessage = (body, cid) async {
      if (fail) throw FeaturelyNetworkException();
      return makeChatMessage(id: 'm1', body: body, clientMessageId: cid);
    };
    const cid = '33333333-3333-4333-8333-333333333333';
    final controller = _controller(api, ids: [cid])..setVisible(true);
    await controller.load();

    await controller.send('Hello');
    expect(controller.entries.single.delivery, ChatDelivery.failed);

    fail = false;
    await controller.retry(cid);
    await _settle(tester);
    expect(api.sendCalls.map((c) => c.$2), [cid, cid]);
    expect(controller.entries.single.delivery, ChatDelivery.sent);
    expect(controller.entries.single.message.id, 'm1');
  });

  chatTest('empty and over-long messages are not sent', (tester) async {
    final api = FakeApi();
    final controller = _controller(api)..setVisible(true);
    await controller.load();
    await controller.send('   ');
    await controller.send('x' * (chatMessageMax + 1));
    expect(api.sendCalls, isEmpty);
    expect(controller.entries, isEmpty);
  });

  chatTest('polls every 5 s only while visible and foregrounded',
      (tester) async {
    final api = FakeApi();
    final controller = _controller(api);
    await controller.load();
    final afterLoad = api.chatMessageCalls.length;

    // Not visible: nothing scheduled.
    await tester.pump(_poll * 3);
    expect(api.chatMessageCalls.length, afterLoad);

    // Becoming visible polls right away, then every interval.
    controller.setVisible(true);
    await _settle(tester);
    expect(api.chatMessageCalls.length, afterLoad + 1);
    await tester.pump(_poll);
    expect(api.chatMessageCalls.length, afterLoad + 2);
    await tester.pump(_poll);
    expect(api.chatMessageCalls.length, afterLoad + 3);

    // Background: stops.
    controller.setForeground(false);
    expect(controller.isPollScheduled, isFalse);
    await tester.pump(_poll * 3);
    expect(api.chatMessageCalls.length, afterLoad + 3);

    // Resumed: catches up immediately and continues.
    controller.setForeground(true);
    await _settle(tester);
    expect(api.chatMessageCalls.length, afterLoad + 4);

    // Hidden: stops again.
    controller.setVisible(false);
    await tester.pump(_poll * 3);
    expect(api.chatMessageCalls.length, afterLoad + 4);
  });

  chatTest('a 429 pauses polling for 30 s', (tester) async {
    final api = FakeApi();
    var limited = false;
    api.onGetChatMessages = (before, after) async {
      if (limited) {
        throw FeaturelyApiException(FeaturelyErrorCode.rateLimited, 429);
      }
      return const ChatMessagesPage(
          messages: [], olderCursor: null, newerCursor: 'c0');
    };
    final controller = _controller(api)..setVisible(true);
    await controller.load();

    limited = true;
    await tester.pump(_poll); // This poll is rate-limited.
    final afterLimit = api.chatMessageCalls.length;
    expect(controller.isRateLimitPaused, isTrue);

    limited = false;
    await tester.pump(_pause - const Duration(seconds: 1));
    expect(api.chatMessageCalls.length, afterLimit);
    // Toggling visibility during the pause doesn't bypass it.
    controller
      ..setVisible(false)
      ..setVisible(true);
    await _settle(tester);
    expect(api.chatMessageCalls.length, afterLimit);

    await tester.pump(const Duration(seconds: 1));
    expect(api.chatMessageCalls.length, afterLimit + 1);
    expect(controller.isRateLimitPaused, isFalse);
    await tester.pump(_poll);
    expect(api.chatMessageCalls.length, afterLimit + 2);
  });

  chatTest('a 429 on send marks it failed and pauses polling', (tester) async {
    final api = FakeApi();
    api.onSendChatMessage = (body, cid) async =>
        throw FeaturelyApiException(FeaturelyErrorCode.rateLimited, 429);
    final controller = _controller(api)..setVisible(true);
    await controller.load();
    await controller.send('Hello');
    expect(controller.entries.single.delivery, ChatDelivery.failed);
    expect(controller.rateLimitedNotice, isTrue);
    expect(controller.isRateLimitPaused, isTrue);
    expect(controller.isPollScheduled, isFalse);
  });

  chatTest('marks read once per new team message while visible',
      (tester) async {
    final api = FakeApi();
    api.onGetConversation = () async => makeConversation(unread: 1);
    final team1 = makeChatMessage(
      id: 't1',
      author: ChatAuthor.team,
      createdAt: DateTime.utc(2026, 9, 1, 10),
    );
    final team2 = makeChatMessage(
      id: 't2',
      author: ChatAuthor.team,
      createdAt: DateTime.utc(2026, 9, 1, 11),
    );
    var deliverSecond = false;
    api.onGetChatMessages = (before, after) async {
      if (after == null) {
        return ChatMessagesPage(
            messages: [team1], olderCursor: null, newerCursor: 'c1');
      }
      if (deliverSecond && after == 'c1') {
        return ChatMessagesPage(
            messages: [team2], olderCursor: null, newerCursor: 'c2');
      }
      return ChatMessagesPage(
          messages: const [], olderCursor: null, newerCursor: after);
    };
    final controller = _controller(api)..setVisible(true);
    await controller.load();
    await _settle(tester);
    expect(api.readCalls, 1);

    // Empty polls: no further read calls.
    await tester.pump(_poll);
    await tester.pump(_poll);
    expect(api.readCalls, 1);

    // A new team message: exactly one more.
    deliverSecond = true;
    await tester.pump(_poll);
    expect(api.readCalls, 2);
    await tester.pump(_poll);
    expect(api.readCalls, 2);
  });

  chatTest('no read call when nothing is unread, or while hidden',
      (tester) async {
    final api = FakeApi();
    api.onGetChatMessages = (before, after) async => ChatMessagesPage(
          messages: [makeChatMessage(id: 't1', author: ChatAuthor.team)],
          olderCursor: null,
          newerCursor: 'c1',
        );
    // unreadCount 0: already read.
    api.onGetConversation = () async => makeConversation();
    final read = _controller(api)..setVisible(true);
    await read.load();
    await _settle(tester);
    expect(api.readCalls, 0);
    read.setVisible(false);

    // Unread, but hidden: deferred until visible.
    api.onGetConversation = () async => makeConversation(unread: 1);
    final hidden = _controller(api);
    await hidden.load();
    await _settle(tester);
    expect(api.readCalls, 0);
    hidden.setVisible(true);
    await _settle(tester);
    expect(api.readCalls, 1);
  });

  chatTest('load earlier pages with before=olderCursor and prepends',
      (tester) async {
    final api = FakeApi();
    api.onGetChatMessages = (before, after) async {
      if (before == 'old-1') {
        return ChatMessagesPage(
          messages: [
            makeChatMessage(id: 'a', createdAt: DateTime.utc(2026, 8, 1)),
          ],
          olderCursor: null,
          newerCursor: 'x',
        );
      }
      return ChatMessagesPage(
        messages: [
          makeChatMessage(id: 'b', createdAt: DateTime.utc(2026, 9, 1)),
        ],
        olderCursor: 'old-1',
        newerCursor: after ?? 'new-1',
      );
    };
    final controller = _controller(api);
    await controller.load();
    expect(controller.canLoadEarlier, isTrue);
    expect(controller.newerCursor, 'new-1');

    await controller.loadEarlier();
    expect(api.chatMessageCalls.last, ('old-1', null));
    expect(controller.entries.map((e) => e.message.id), ['a', 'b']);
    expect(controller.canLoadEarlier, isFalse);
    // Paging back never moves the polling cursor.
    expect(controller.newerCursor, 'new-1');
  });

  chatTest('an empty poll keeps the echoed cursor', (tester) async {
    final api = FakeApi(); // Default handler echoes `after`.
    api.onGetChatMessages = (before, after) async => ChatMessagesPage(
          messages: const [],
          olderCursor: null,
          newerCursor: after ?? 'c0',
        );
    final controller = _controller(api)..setVisible(true);
    await controller.load();
    await tester.pump(_poll);
    await tester.pump(_poll);
    expect(api.chatMessageCalls.skip(1).map((c) => c.$2), everyElement('c0'));
  });

  chatTest(
      'load failure (401 included) shows the error state and Retry '
      'recovers', (tester) async {
    final api = FakeApi();
    var fail = true;
    api.onGetConversation = () async {
      if (fail) {
        throw FeaturelyApiException(FeaturelyErrorCode.invalidApiKey, 401);
      }
      return null;
    };
    final controller = _controller(api)..setVisible(true);
    await controller.load();
    expect(controller.phase, ChatPhase.error);
    expect(controller.isPollScheduled, isFalse);

    fail = false;
    await controller.load();
    expect(controller.phase, ChatPhase.loaded);
    expect(controller.isPollScheduled, isTrue);
  });

  chatTest('a 401 while polling switches to the error state', (tester) async {
    final api = FakeApi();
    var unauthorized = false;
    api.onGetChatMessages = (before, after) async {
      if (unauthorized) {
        throw FeaturelyApiException(FeaturelyErrorCode.invalidApiKey, 401);
      }
      return const ChatMessagesPage(
          messages: [], olderCursor: null, newerCursor: 'c0');
    };
    final controller = _controller(api)..setVisible(true);
    await controller.load();
    unauthorized = true;
    await tester.pump(_poll);
    expect(controller.phase, ChatPhase.error);
    expect(controller.isPollScheduled, isFalse);
  });

  chatTest('email: client-side and server-side validation, then save',
      (tester) async {
    final api = FakeApi();
    api.onSetChatEmail = (email) async {
      if (email == 'bad@example') {
        throw FeaturelyApiException(FeaturelyErrorCode.invalidEmail, 400);
      }
    };
    final controller = _controller(api);
    await controller.load();

    expect(await controller.saveEmail('not-an-email'), isFalse);
    expect(controller.emailError, ChatEmailError.invalid);
    expect(api.emailCalls, isEmpty);

    // The server has the final word.
    expect(ChatController.looksLikeEmail('bad@example.c'), isTrue);
    api.onSetChatEmail = (email) async =>
        throw FeaturelyApiException(FeaturelyErrorCode.invalidEmail, 400);
    expect(await controller.saveEmail('bad@example.c'), isFalse);
    expect(controller.emailError, ChatEmailError.invalid);

    api.onSetChatEmail = null;
    expect(await controller.saveEmail(' me@example.com '), isTrue);
    expect(api.emailCalls.last, 'me@example.com');
    expect(controller.contactEmail, 'me@example.com');
    expect(controller.emailError, ChatEmailError.none);

    // Blank clears.
    expect(await controller.saveEmail(''), isTrue);
    expect(api.emailCalls.last, isNull);
    expect(controller.contactEmail, isNull);
  });
}
