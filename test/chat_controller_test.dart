import 'dart:async';

import 'package:featurely/src/api/api_exception.dart';
import 'package:featurely/src/api/models.dart';
import 'package:featurely/src/chat_metadata.dart';
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

ChatController _controller(
  FakeApi api, {
  List<String>? ids,
  Map<String, String>? Function()? metadata,
  Future<Map<String, Object?>?> Function()? diagnostics,
  List<String> Function()? availableActions,
}) {
  var n = 0;
  final controller = ChatController(
    api: api,
    resolvedLocale: 'en',
    metadata: metadata,
    diagnostics: diagnostics,
    availableActions: availableActions,
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

  group('initial message', () {
    ChatController make(String? initial) {
      final controller =
          ChatController(api: FakeApi(), initialMessage: initial);
      _live.add(controller);
      return controller;
    }

    chatTest('is trimmed and taken once', (tester) async {
      final controller = make('  Hi there  ');
      expect(controller.takeInitialMessage(), 'Hi there');
      expect(controller.takeInitialMessage(), isNull);
    });

    chatTest('blank or absent yields null', (tester) async {
      expect(make(null).takeInitialMessage(), isNull);
      expect(make('').takeInitialMessage(), isNull);
      expect(make(' \n\t ').takeInitialMessage(), isNull);
    });

    chatTest('is capped to chatMessageMax without splitting emoji',
        (tester) async {
      expect(make('y' * (chatMessageMax + 50)).takeInitialMessage(),
          'y' * chatMessageMax);
      final emoji = '${'a' * (chatMessageMax - 1)}😀';
      expect(make(emoji).takeInitialMessage(), 'a' * (chatMessageMax - 1));
    });

    chatTest('is never sent by itself', (tester) async {
      final api = FakeApi();
      final controller = ChatController(api: api, initialMessage: 'Hi');
      _live.add(controller);
      controller.setVisible(true);
      await controller.load();
      await tester.pump(const Duration(seconds: 6));
      expect(api.sendCalls, isEmpty);
    });
  });

  group('metadata', () {
    chatTest('the provider result is sent with the message', (tester) async {
      final api = FakeApi();
      final controller = _controller(api,
          metadata: () => effectiveChatMetadata(
                const {'plan': 'pro', 'screen': 'Home'},
                const {'screen': 'Checkout'},
              ))
        ..setVisible(true);
      await controller.load();
      await controller.send('Hello');
      expect(api.sendMetadata.single, {'plan': 'pro', 'screen': 'Checkout'});
    });

    chatTest('empty metadata is sent as none', (tester) async {
      final api = FakeApi();
      final controller = _controller(api,
          metadata: () => effectiveChatMetadata(const {'k': '  '}, const {}))
        ..setVisible(true);
      await controller.load();
      await controller.send('Hello');
      expect(api.sendMetadata.single, isNull);
    });

    chatTest('a retry re-sends the metadata snapshotted at compose time',
        (tester) async {
      final api = FakeApi();
      var fail = true;
      api.onSendChatMessage = (body, cid) async {
        if (fail) throw FeaturelyNetworkException();
        return makeChatMessage(id: 'm1', body: body, clientMessageId: cid);
      };
      Map<String, String>? global = const {'plan': 'free'};
      const cid = '44444444-4444-4444-8444-444444444444';
      const cid2 = '55555555-5555-4555-8555-555555555555';
      final controller = _controller(api,
          ids: [cid, cid2],
          metadata: () =>
              effectiveChatMetadata(global, const {'screen': 'Checkout'}))
        ..setVisible(true);
      await controller.load();

      await controller.send('Hello');
      expect(controller.entries.single.delivery, ChatDelivery.failed);

      global = const {'plan': 'pro'};
      fail = false;
      await controller.retry(cid);
      await _settle(tester);
      expect(api.sendMetadata, [
        {'plan': 'free', 'screen': 'Checkout'},
        {'plan': 'free', 'screen': 'Checkout'},
      ]);

      // A new message picks up the changed global map.
      await controller.send('Next');
      expect(api.sendMetadata.last, {'plan': 'pro', 'screen': 'Checkout'});
    });

    chatTest('a throwing provider never blocks the send', (tester) async {
      final api = FakeApi();
      final controller =
          _controller(api, metadata: () => throw StateError('boom'))
            ..setVisible(true);
      await controller.load();
      await controller.send('Hello');
      expect(api.sendCalls, hasLength(1));
      expect(api.sendMetadata.single, isNull);
    });
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

  group('AI assistant', () {
    const cid = '44444444-4444-4444-8444-444444444444';
    FeaturelyApiException badRequest(String code) =>
        FeaturelyApiException(FeaturelyErrorCode.decode(code), 400);

    chatTest('diagnostics and actions are read per send and sent with it',
        (tester) async {
      final api = FakeApi();
      var calls = 0;
      final controller = _controller(
        api,
        ids: [cid, '55555555-5555-4555-8555-555555555555'],
        diagnostics: () async => {'attempt': ++calls},
        availableActions: () => ['open_settings'],
      )..setVisible(true);
      await controller.load();
      await controller.send('One');
      await controller.send('Two');
      expect(api.sendDiagnostics, [
        {'attempt': 1},
        {'attempt': 2},
      ]);
      expect(api.sendActions, [
        ['open_settings'],
        ['open_settings'],
      ]);
    });

    chatTest('the optimistic row shows while diagnostics are collected',
        (tester) async {
      final api = FakeApi();
      final snapshot = Completer<Map<String, Object?>?>();
      final controller = _controller(api,
          ids: [cid], diagnostics: () => snapshot.future)
        ..setVisible(true);
      await controller.load();
      unawaited(controller.send('Hi'));
      await _settle(tester);
      expect(controller.entries.single.delivery, ChatDelivery.sending);
      expect(api.sendCalls, isEmpty);
      snapshot.complete({'a': 1});
      await _settle(tester);
      expect(api.sendDiagnostics.single, {'a': 1});
      expect(controller.entries.single.delivery, ChatDelivery.sent);
    });

    chatTest('a throwing diagnostics or actions hook never blocks the send',
        (tester) async {
      final api = FakeApi();
      final controller = _controller(
        api,
        ids: [cid],
        diagnostics: () => throw StateError('host bug'),
        availableActions: () => throw StateError('host bug'),
      )..setVisible(true);
      await controller.load();
      await controller.send('Hi');
      expect(api.sendDiagnostics.single, isNull);
      expect(api.sendActions.single, isNull);
      expect(controller.entries.single.delivery, ChatDelivery.sent);
    });

    for (final code in ['validation_error', 'invalid_message']) {
      chatTest('a 400 $code with diagnostics re-sends once without them',
          (tester) async {
        final api = FakeApi();
        api.onSendChatMessage = (body, clientMessageId) async {
          if (api.sendDiagnostics.last != null) throw badRequest(code);
          return makeChatMessage(
              id: 'm1', body: body, clientMessageId: clientMessageId);
        };
        final controller = _controller(api,
            ids: [cid],
            diagnostics: () async => {'a': 1},
            availableActions: () => ['open_settings'])
          ..setVisible(true);
        await controller.load();
        await controller.send('Hi');
        expect(api.sendCalls, [('Hi', cid), ('Hi', cid)]);
        expect(api.sendDiagnostics, [
          {'a': 1},
          null,
        ]);
        // Everything else is unchanged on the re-send.
        expect(api.sendActions, [
          ['open_settings'],
          ['open_settings'],
        ]);
        expect(controller.entries.single.delivery, ChatDelivery.sent);
      });
    }

    chatTest('a 400 without diagnostics fails without a re-send',
        (tester) async {
      final api = FakeApi();
      api.onSendChatMessage =
          (body, clientMessageId) async => throw badRequest('invalid_message');
      final controller = _controller(api, ids: [cid])..setVisible(true);
      await controller.load();
      await controller.send('Hi');
      expect(api.sendCalls, hasLength(1));
      expect(controller.entries.single.delivery, ChatDelivery.failed);
    });

    chatTest('a re-send that fails too marks the message failed',
        (tester) async {
      final api = FakeApi();
      api.onSendChatMessage =
          (body, clientMessageId) async => throw badRequest('validation_error');
      final controller = _controller(api,
          ids: [cid], diagnostics: () async => {'a': 1})
        ..setVisible(true);
      await controller.load();
      await controller.send('Hi');
      expect(api.sendCalls, hasLength(2));
      expect(controller.entries.single.delivery, ChatDelivery.failed);
    });

    chatTest('non-400 failures never trigger the diagnostics re-send',
        (tester) async {
      final api = FakeApi();
      api.onSendChatMessage =
          (body, clientMessageId) async => throw FeaturelyNetworkException();
      final controller = _controller(api,
          ids: [cid], diagnostics: () async => {'a': 1})
        ..setVisible(true);
      await controller.load();
      await controller.send('Hi');
      expect(api.sendCalls, hasLength(1));
      expect(controller.entries.single.delivery, ChatDelivery.failed);
    });

    chatTest(
        'polls every 1.5 s while the assistant is pending, then 5 s once '
        'the flag clears', (tester) async {
      final api = FakeApi();
      var pending = true;
      api.onGetChatMessages = (before, after) async => ChatMessagesPage(
            messages: const [],
            olderCursor: null,
            newerCursor: 'c0',
            assistantPending: pending,
          );
      final controller = _controller(api)..setVisible(true);
      await controller.load();
      await _settle(tester);
      expect(controller.assistantPending, isTrue);
      expect(controller.currentPollInterval, const Duration(milliseconds: 1500));
      final start = api.chatMessageCalls.length;

      await tester.pump(const Duration(milliseconds: 1500));
      expect(api.chatMessageCalls.length, start + 1);
      await tester.pump(const Duration(milliseconds: 1500));
      expect(api.chatMessageCalls.length, start + 2);

      pending = false;
      await tester.pump(const Duration(milliseconds: 1500));
      expect(api.chatMessageCalls.length, start + 3);
      expect(controller.assistantPending, isFalse);
      expect(controller.currentPollInterval, _poll);
      await tester.pump(const Duration(milliseconds: 4999));
      expect(api.chatMessageCalls.length, start + 3);
      await tester.pump(const Duration(milliseconds: 1));
      expect(api.chatMessageCalls.length, start + 4);
    });

    chatTest('fast polling stops after 60 s even while still pending',
        (tester) async {
      final api = FakeApi();
      api.onGetChatMessages = (before, after) async => const ChatMessagesPage(
            messages: [],
            olderCursor: null,
            newerCursor: 'c0',
            assistantPending: true,
          );
      final controller = _controller(api)..setVisible(true);
      await controller.load();
      await _settle(tester);
      final start = api.chatMessageCalls.length;
      await tester.pump(const Duration(seconds: 59));
      // Fast polls at 1.5 s … 58.5 s.
      expect(api.chatMessageCalls.length, start + 39);
      expect(controller.currentPollInterval,
          const Duration(milliseconds: 1500));
      // The window closes at 60 s: the poll due then moves to 5 s later.
      await tester.pump(const Duration(seconds: 1));
      expect(controller.currentPollInterval, _poll);
      expect(api.chatMessageCalls.length, start + 39);
      // The typing row still follows the server's flag.
      expect(controller.assistantPending, isTrue);
      await tester.pump(const Duration(milliseconds: 4999));
      expect(api.chatMessageCalls.length, start + 39);
      await tester.pump(const Duration(milliseconds: 1));
      expect(api.chatMessageCalls.length, start + 40);
      await tester.pump(_poll);
      expect(api.chatMessageCalls.length, start + 41);
    });

    chatTest('a send followed by a pending poll switches to fast polling',
        (tester) async {
      final api = FakeApi();
      var pending = false;
      api.onGetChatMessages = (before, after) async => ChatMessagesPage(
            messages: const [],
            olderCursor: null,
            newerCursor: 'c0',
            assistantPending: pending,
          );
      api.onSendChatMessage = (body, clientMessageId) async {
        pending = true; // The server queued a run with the insert.
        return makeChatMessage(
            id: 'm1', body: body, clientMessageId: clientMessageId);
      };
      final controller = _controller(api, ids: [cid])..setVisible(true);
      await controller.load();
      expect(controller.currentPollInterval, _poll);
      await controller.send('Help');
      await _settle(tester);
      expect(controller.assistantPending, isTrue);
      expect(controller.currentPollInterval, const Duration(milliseconds: 1500));
      expect(controller.isPollScheduled, isTrue);
    });

    chatTest('assistantName comes from the newest named assistant message',
        (tester) async {
      final api = FakeApi();
      api.onGetChatMessages = (before, after) async => ChatMessagesPage(
            messages: after != null
                ? const []
                : [
                    makeAssistantMessage(
                        id: 'a1',
                        authorName: 'Old',
                        createdAt: DateTime.utc(2026, 9, 1, 9)),
                    makeAssistantMessage(
                        id: 'a2',
                        authorName: 'Lyn',
                        createdAt: DateTime.utc(2026, 9, 1, 10)),
                    makeAssistantMessage(
                        id: 'a3',
                        authorName: '  ',
                        createdAt: DateTime.utc(2026, 9, 1, 11)),
                    makeChatMessage(
                        id: 't1',
                        author: ChatAuthor.team,
                        createdAt: DateTime.utc(2026, 9, 1, 12)),
                  ],
            olderCursor: null,
            newerCursor: 'c0',
          );
      final controller = _controller(api);
      expect(controller.assistantName, isNull);
      await controller.load();
      expect(controller.assistantName, 'Lyn');
    });
  });
}
