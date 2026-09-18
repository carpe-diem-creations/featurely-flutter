import 'dart:convert';

import 'package:featurely/featurely.dart';
import 'package:featurely/src/api/api_client.dart';
import 'package:featurely/src/util/uuid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _config = {
  'project': {'name': 'App'},
  'commentingEnabled': true,
  'visibleStatuses': ['open'],
  'limits': {
    'titleMax': 60,
    'descriptionMax': 10000,
    'commentMax': 5000,
    'attachmentMaxBytes': 5242880,
    'attachmentTypes': ['image/png'],
  },
};

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));
  tearDown(Featurely.debugReset);

  Future<void> init(
      Future<http.Response> Function(http.Request request) handler) async {
    Featurely.debugHttpClient = MockClient(handler);
    await Featurely.init(
      baseUrl: 'https://feedback.example.com',
      apiKey: 'fk_key',
      environment: FeaturelyEnvironment.live,
    );
  }

  group('Featurely.hasUnreadMessages', () {
    Future<http.Response> withUnread(http.Request request, int unread) async {
      if (request.url.path.endsWith('/config')) {
        return http.Response(
            jsonEncode({..._config, 'chatEnabled': true}), 200);
      }
      return http.Response(
          jsonEncode({
            'conversation': {
              'id': '6f1c1f5e-0000-4000-8000-000000000000',
              'status': 'open',
              'contactEmail': null,
              'unreadCount': unread,
              'lastMessageAt': '2026-09-01T10:00:00.000Z',
            }
          }),
          200);
    }

    test('is false before init', () async {
      expect(await Featurely.hasUnreadMessages(), isFalse);
    });

    test('is true when team messages are unread', () async {
      await init((request) => withUnread(request, 2));
      expect(await Featurely.hasUnreadMessages(), isTrue);
    });

    test('is false when everything is read', () async {
      await init((request) => withUnread(request, 0));
      expect(await Featurely.hasUnreadMessages(), isFalse);
    });

    test('is false when the server does not support chat', () async {
      await init((request) async {
        if (request.url.path.endsWith('/config')) {
          return http.Response(jsonEncode(_config), 200);
        }
        return withUnread(request, 5);
      });
      expect(await Featurely.hasUnreadMessages(), isFalse);
    });

    test('is false when the device has no conversation', () async {
      await init((request) async {
        if (request.url.path.endsWith('/config')) {
          return withUnread(request, 0);
        }
        return http.Response(jsonEncode({'conversation': null}), 200);
      });
      expect(await Featurely.hasUnreadMessages(), isFalse);
    });

    test('never throws: errors yield false', () async {
      await init((request) async {
        if (request.url.path.endsWith('/config')) {
          return withUnread(request, 0);
        }
        throw http.ClientException('offline');
      });
      expect(await Featurely.hasUnreadMessages(), isFalse);
    });
  });

  group('Featurely.unreadMessageCount', () {
    test('is 0 before init', () async {
      expect(await Featurely.unreadMessageCount(), 0);
    });

    test('is 0 when the server does not report chatEnabled', () async {
      var conversationCalls = 0;
      await init((request) async {
        if (request.url.path.endsWith('/config')) {
          return http.Response(jsonEncode(_config), 200);
        }
        conversationCalls++;
        return http.Response(
            jsonEncode({
              'conversation': {'id': 'c', 'status': 'open', 'unreadCount': 4}
            }),
            200);
      });
      expect(await Featurely.unreadMessageCount(), 0);
      expect(conversationCalls, 0);
    });

    test('is 0 when the device has no conversation', () async {
      await init((request) async {
        if (request.url.path.endsWith('/config')) {
          return http.Response(
              jsonEncode({..._config, 'chatEnabled': true}), 200);
        }
        return http.Response(jsonEncode({'conversation': null}), 200);
      });
      expect(await Featurely.unreadMessageCount(), 0);
    });

    test('returns unreadCount from GET /conversation', () async {
      final paths = <String>[];
      await init((request) async {
        paths.add(request.url.path);
        if (request.url.path.endsWith('/config')) {
          return http.Response(
              jsonEncode({..._config, 'chatEnabled': true}), 200);
        }
        return http.Response(
            jsonEncode({
              'conversation': {
                'id': '6f1c1f5e-0000-4000-8000-000000000000',
                'status': 'closed',
                'contactEmail': null,
                'unreadCount': 3,
                'lastMessageAt': '2026-09-01T10:00:00.000Z',
              }
            }),
            200);
      });
      expect(await Featurely.unreadMessageCount(), 3);
      expect(paths, contains('/api/v1/conversation'));
    });

    test('never throws: errors yield 0', () async {
      await init((request) async {
        if (request.url.path.endsWith('/config')) {
          return http.Response(
              jsonEncode({..._config, 'chatEnabled': true}), 200);
        }
        return http.Response(
            jsonEncode({
              'error': {'code': 'invalid_api_key', 'message': 'x'}
            }),
            401);
      });
      expect(await Featurely.unreadMessageCount(), 0);
    });
  });

  group('setChatMetadata', () {
    test('throws a StateError before init', () {
      expect(
          () => Featurely.setChatMetadata(const {'a': 'b'}), throwsStateError);
    });

    testWidgets('is merged with showChat metadata and survives re-init',
        (tester) async {
      final sent = <Map<String, dynamic>>[];
      Future<http.Response> handler(http.Request request) async {
        final path = request.url.path;
        if (path.endsWith('/config')) {
          return http.Response(
              jsonEncode({..._config, 'chatEnabled': true}), 200);
        }
        if (path.endsWith('/conversation')) {
          return http.Response(jsonEncode({'conversation': null}), 200);
        }
        if (path.endsWith('/conversation/messages') &&
            request.method == 'GET') {
          return http.Response(
              jsonEncode({
                'messages': <Object>[],
                'olderCursor': null,
                'newerCursor': null,
              }),
              200);
        }
        if (path.endsWith('/conversation/messages')) {
          final body = jsonDecode(request.body) as Map<String, dynamic>;
          sent.add(body);
          return http.Response(
              jsonEncode({
                'id': 'm${sent.length}',
                'author': 'user',
                'body': body['body'],
                'createdAt': '2026-09-01T10:00:00.000Z',
                'clientMessageId': body['clientMessageId'],
              }),
              201);
        }
        return http.Response('', 204);
      }

      await tester.runAsync(() => init(handler));
      final input = {'plan': 'free', 'screen': 'Home'};
      Featurely.setChatMetadata(input);
      input['plan'] = 'mutated after the call'; // Copied, so no effect.
      // Re-configuring keeps the app-wide metadata.
      await tester.runAsync(() => init(handler));

      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () => Featurely.showChat(
              context,
              metadata: const {'screen': 'Checkout', 'orderId': '42'},
              initialMessage: 'Where is my order?',
            ),
            child: const Text('Open chat'),
          ),
        ),
      ));
      await tester.tap(find.text('Open chat'));
      await tester.pumpAndSettle();

      // The prefill is in the composer but is sent only on tap.
      expect(sent, isEmpty);
      await tester.tap(find.byKey(const ValueKey('featurely-chat-send')));
      await tester.pumpAndSettle();

      expect(sent.single['body'], 'Where is my order?');
      expect(sent.single['metadata'], {
        'orderId': '42',
        'plan': 'free',
        'screen': 'Checkout',
      });

      // null clears the app-wide map; the presentation's own map remains.
      Featurely.setChatMetadata(null);
      await tester.enterText(find.byType(TextField), 'Any news?');
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('featurely-chat-send')));
      await tester.pumpAndSettle();
      expect(sent.last['metadata'], {'orderId': '42', 'screen': 'Checkout'});

      await tester.pumpWidget(const SizedBox.shrink());
    });
  });

  group('AI assistant hooks', () {
    test('throw a StateError before init', () {
      expect(() => Featurely.setChatDiagnosticsProvider(() async => null),
          throwsStateError);
      expect(() => Featurely.registerChatActions(const []), throwsStateError);
      expect(
          () => Featurely.setChatActionHandler(
              (id) => FeaturelyChatActionResult.stay),
          throwsStateError);
    });

    testWidgets(
        'sends diagnostics and actions, survive re-init, and re-send once '
        'without diagnostics the server rejects', (tester) async {
      final sent = <Map<String, dynamic>>[];
      var rejectDiagnostics = false;
      Future<http.Response> handler(http.Request request) async {
        final path = request.url.path;
        if (path.endsWith('/config')) {
          return http.Response(
              jsonEncode({..._config, 'chatEnabled': true}), 200);
        }
        if (path.endsWith('/conversation')) {
          return http.Response(jsonEncode({'conversation': null}), 200);
        }
        if (path.endsWith('/conversation/messages') &&
            request.method == 'GET') {
          return http.Response(
              jsonEncode({
                'messages': <Object>[],
                'olderCursor': null,
                'newerCursor': null,
                'assistantPending': false,
              }),
              200);
        }
        if (path.endsWith('/conversation/messages')) {
          final body = jsonDecode(request.body) as Map<String, dynamic>;
          sent.add(body);
          if (rejectDiagnostics && body.containsKey('diagnostics')) {
            return http.Response(
                jsonEncode({
                  'error': {'code': 'validation_error', 'message': 'x'}
                }),
                400);
          }
          return http.Response(
              jsonEncode({
                'id': 'm${sent.length}',
                'author': 'user',
                'authorKind': 'end_user',
                'body': body['body'],
                'createdAt': '2026-09-01T10:00:00.000Z',
                'clientMessageId': body['clientMessageId'],
              }),
              201);
        }
        return http.Response('', 204);
      }

      await tester.runAsync(() => init(handler));
      Featurely.setChatDiagnosticsProvider(
          () async => {'bluetooth': 'off', 'attempts': 2});
      Featurely.registerChatActions(const [
        FeaturelyChatAction(id: 'open_settings', title: 'Open Settings'),
        FeaturelyChatAction(id: 'Not-Valid', title: 'Dropped'),
      ]);
      Featurely.setChatActionHandler((id) => FeaturelyChatActionResult.stay);
      // Re-configuring keeps all three.
      await tester.runAsync(() => init(handler));

      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () => Featurely.showChat(context),
            child: const Text('Open chat'),
          ),
        ),
      ));
      await tester.tap(find.text('Open chat'));
      await tester.pumpAndSettle();

      Future<void> send(String text) async {
        await tester.enterText(find.byType(TextField), text);
        await tester.pump();
        await tester.tap(find.byKey(const ValueKey('featurely-chat-send')));
        await tester.pumpAndSettle();
      }

      await send('Pairing fails');
      expect(sent.single, {
        'body': 'Pairing fails',
        'clientMessageId': sent.single['clientMessageId'],
        'resolvedLocale': sent.single['resolvedLocale'],
        'deviceLocale': sent.single['deviceLocale'],
        'diagnostics': {'bluetooth': 'off', 'attempts': 2},
        'availableActions': ['open_settings'],
        'assistantCapable': true,
      });

      // The server rejects the snapshot: one re-send without it, same id.
      rejectDiagnostics = true;
      await send('Still failing');
      expect(sent, hasLength(3));
      expect(sent[1].containsKey('diagnostics'), isTrue);
      expect(sent[2].containsKey('diagnostics'), isFalse);
      expect(sent[2]['clientMessageId'], sent[1]['clientMessageId']);
      expect(sent[2]['assistantCapable'], isTrue);
      expect(find.text('Not sent — Tap to retry'), findsNothing);

      // Removing the handler stops advertising actions; removing the
      // provider stops diagnostics.
      Featurely.setChatActionHandler(null);
      Featurely.setChatDiagnosticsProvider(null);
      await send('Third');
      expect(sent.last.containsKey('availableActions'), isFalse);
      expect(sent.last.containsKey('diagnostics'), isFalse);
      expect(sent.last['assistantCapable'], isTrue);

      await tester.pumpWidget(const SizedBox.shrink());
    });
  });

  test('showChat before init throws a StateError', () {
    expect(
      () => Featurely.showChat(_FakeContext()),
      throwsStateError,
    );
  });

  group('chat API request shapes', () {
    late List<http.Request> requests;
    late FeaturelyApiClient client;

    setUp(() {
      requests = [];
      client = FeaturelyApiClient(
        baseUrl: 'https://feedback.example.com',
        apiKey: 'fk_key',
        environment: 'sandbox',
        deviceIdProvider: () async => 'u_device_abcdefgh',
        readRetryDelay: (_) => Duration.zero,
        httpClient: MockClient((request) async {
          requests.add(request);
          final path = request.url.path;
          if (path.endsWith('/conversation/messages') &&
              request.method == 'GET') {
            return http.Response(
                jsonEncode({
                  'messages': [
                    {
                      'id': 'm1',
                      'author': 'team',
                      'body': 'Hi',
                      'createdAt': '2026-09-01T10:00:00.000Z',
                      'clientMessageId': null,
                    }
                  ],
                  'olderCursor': null,
                  'newerCursor': 'n1',
                }),
                200);
          }
          if (path.endsWith('/conversation/messages')) {
            final body = jsonDecode(request.body) as Map<String, dynamic>;
            // Idempotent replay answers 200.
            return http.Response(
                jsonEncode({
                  'id': 'm2',
                  'author': 'user',
                  'body': body['body'],
                  'createdAt': '2026-09-01T10:00:00.000Z',
                  'clientMessageId': body['clientMessageId'],
                }),
                200);
          }
          return http.Response('', 204);
        }),
      );
    });

    test('getChatMessages sends cursors verbatim and decodes the page',
        () async {
      final page = await client.getChatMessages(after: 'abc+/=');
      expect(requests.single.url.queryParameters, {'after': 'abc+/='});
      expect(requests.single.headers['X-Featurely-Environment'], 'sandbox');
      expect(page.messages.single.author.wire, 'team');
      expect(page.newerCursor, 'n1');
      expect(page.olderCursor, isNull);
    });

    test('sendChatMessage posts the JSON body and accepts a 200 replay',
        () async {
      final message = await client.sendChatMessage(
        body: 'Hello',
        clientMessageId: '0d6c1b2a-1111-4111-8111-111111111111',
        resolvedLocale: 'de',
        deviceLocale: 'de-CH',
      );
      final request = requests.single;
      expect(request.method, 'POST');
      expect(request.url.path, '/api/v1/conversation/messages');
      expect(jsonDecode(request.body), {
        'body': 'Hello',
        'clientMessageId': '0d6c1b2a-1111-4111-8111-111111111111',
        'deviceLocale': 'de-CH',
        'resolvedLocale': 'de',
        'assistantCapable': true,
      });
      expect(message.clientMessageId, '0d6c1b2a-1111-4111-8111-111111111111');
    });

    test('sendChatMessage encodes metadata as a flat string map', () async {
      await client.sendChatMessage(
        body: 'Hello',
        clientMessageId: '0d6c1b2a-1111-4111-8111-111111111111',
        metadata: const {'screen': 'Checkout', 'plan': 'pro'},
      );
      expect(jsonDecode(requests.single.body), {
        'body': 'Hello',
        'clientMessageId': '0d6c1b2a-1111-4111-8111-111111111111',
        'metadata': {'screen': 'Checkout', 'plan': 'pro'},
        'assistantCapable': true,
      });
    });

    test('sendChatMessage omits null or empty metadata', () async {
      await client.sendChatMessage(
        body: 'Hello',
        clientMessageId: '0d6c1b2a-1111-4111-8111-111111111111',
      );
      await client.sendChatMessage(
        body: 'Hello',
        clientMessageId: '0d6c1b2a-1111-4111-8111-111111111111',
        metadata: const {},
      );
      for (final request in requests) {
        expect(
            (jsonDecode(request.body) as Map).containsKey('metadata'), isFalse);
      }
    });

    test('markChatRead POSTs', () async {
      await client.markChatRead();
      expect(requests.map((r) => '${r.method} ${r.url.path}'), [
        'POST /api/v1/conversation/read',
      ]);
    });

    test('generated clientMessageIds are RFC 4122 v4 UUIDs', () async {
      // Exercised through the public controller path elsewhere; here the
      // format itself.
      final ids = List.generate(50, (_) => _uuid());
      final pattern = RegExp(
          r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$');
      expect(ids, everyElement(matches(pattern)));
      expect(ids.toSet(), hasLength(50));
    });
  });
}

String _uuid() => generateUuidV4();

class _FakeContext extends Fake implements BuildContext {}
