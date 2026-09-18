import 'dart:convert';
import 'dart:io';

import 'package:featurely/src/api/api_client.dart';
import 'package:featurely/src/api/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

/// The AI Support Assistant wire contract (ai-support-assistant-spec AC #7–#10,
/// #35), checked against the server's own fixtures. The files under
/// `test/fixtures/assistant/` are verbatim copies of featurely-functions
/// `docs/contract/assistant/*.json`, the single source of truth (the server
/// validates them against its schemas); see `test/fixtures/assistant/SOURCE`.
Map<String, dynamic> _fixture(String name) => jsonDecode(
      File('test/fixtures/assistant/$name.json').readAsStringSync(),
    ) as Map<String, dynamic>;

final Map<String, dynamic> _page = _fixture('messages-response');

/// A 0.5.x-era message (a server without the assistant): SDK-local, since
/// the server's fixtures always carry `authorKind`.
const Map<String, dynamic> _legacyMessage = {
  'id': '0b0f6a52-0000-4000-8000-000000000004',
  'author': 'team',
  'body': 'A reply from a server without the assistant.',
  'createdAt': '2026-09-18T09:06:00.000Z',
  'clientMessageId': null,
};

void main() {
  group('decoding', () {
    test('the messages page decodes author kind, name, actions and pending',
        () {
      final page = ChatMessagesPage.fromJson(_page);
      expect(page.assistantPending, isTrue);
      final [user, assistant, team] = page.messages;

      expect(page.olderCursor, isNull);
      expect(page.newerCursor, isNotEmpty);

      expect(user.authorKind, ChatAuthorKind.endUser);
      expect(user.author, ChatAuthor.user);
      expect(user.isAssistant, isFalse);
      expect(user.clientMessageId, '6f9619ff-8b86-4d11-b42d-00c04fc964ff');

      expect(assistant.author, ChatAuthor.team);
      expect(assistant.authorKind, ChatAuthorKind.assistant);
      expect(assistant.isAssistant, isTrue);
      expect(assistant.authorName, 'Lyn');
      expect(assistant.actions, ['retry_pairing']);
      expect(assistant.body, startsWith('Your iPhone never showed'));
      expect(assistant.body, contains('\n1. Keep the watch'));
      expect(assistant.createdAt, DateTime.utc(2026, 9, 18, 10, 0, 6));

      expect(team.authorKind, ChatAuthorKind.team);
      expect(team.authorName, isNull);
      expect(team.actions, isEmpty);
    });

    test('assistant messages keep author team, as 0.5.x decodes them', () {
      // 0.5.x reads only {id, author, body, createdAt, clientMessageId}; the
      // assistant message must still read as a team reply there.
      final raw = (_page['messages'] as List)[1] as Map<String, dynamic>;
      expect(raw['author'], 'team');
      final legacyView = ChatMessage.fromJson({
        for (final key in const [
          'id',
          'author',
          'body',
          'createdAt',
          'clientMessageId',
        ])
          key: raw[key],
      });
      expect(legacyView.author, ChatAuthor.team);
      expect(legacyView.authorKind, ChatAuthorKind.team);
      expect(legacyView.body, raw['body']);
    });

    test('0.5.x-shaped messages (no authorKind) decode as before', () {
      final legacy = ChatMessage.fromJson(_legacyMessage);
      expect(legacy.author, ChatAuthor.team);
      expect(legacy.authorKind, ChatAuthorKind.team);
      expect(legacy.isAssistant, isFalse);
      expect(legacy.authorName, isNull);
      expect(legacy.actions, isEmpty);

      final page = ChatMessagesPage.fromJson({
        'messages': [_legacyMessage],
        'olderCursor': null,
        'newerCursor': 'n4',
      });
      expect(page.assistantPending, isFalse);
      final user = ChatMessage.fromJson({
        'id': 'u',
        'author': 'user',
        'body': 'Hi',
        'createdAt': '2026-09-18T09:00:00.000Z',
      });
      expect(user.authorKind, ChatAuthorKind.endUser);
    });

    test('unknown authorKind falls back to author; stray fields are ignored',
        () {
      final message = ChatMessage.fromJson({
        'id': 'x',
        'author': 'team',
        'authorKind': 'robot_overlord',
        'authorName': 'Nope',
        'actions': ['open_settings'],
        'diagnostics': {'never': 'returned'},
        'body': 'Hi',
        'createdAt': '2026-09-18T09:00:00.000Z',
      });
      expect(message.authorKind, ChatAuthorKind.team);
      // Name and actions belong to assistant messages only.
      expect(message.authorName, isNull);
      expect(message.actions, isEmpty);
    });

    test('non-string action ids are skipped', () {
      final message = ChatMessage.fromJson({
        'id': 'x',
        'author': 'team',
        'authorKind': 'assistant',
        'actions': ['open_settings', 3, null],
        'body': 'Hi',
        'createdAt': '2026-09-18T09:00:00.000Z',
      });
      expect(message.actions, ['open_settings']);
      expect(message.authorName, isNull);
    });

    test('the conversation response decodes', () {
      final conversation = ChatConversation.fromJson(
          _fixture('conversation-response')['conversation']
              as Map<String, dynamic>);
      expect(conversation.id, '3eb0ad85-b1b2-4f88-8a31-6c4e5f708192');
      expect(conversation.status, ConversationStatus.open);
      expect(conversation.unreadCount, 2);
      expect(conversation.lastMessageAt, DateTime.utc(2026, 9, 18, 10, 5));
    });

    test('config decodes assistantEnabled, defaulting to false', () {
      final config = SdkConfig.fromJson(_fixture('config-response'));
      expect(config.assistantEnabled, isTrue);
      expect(config.chatEnabled, isTrue);
      expect(config.commentingEnabled, isTrue);
      expect(config.projectName, 'Lynio');
      expect(config.titleMax, 60);
      expect(config.attachmentMaxBytes, 5242880);
      expect(
          SdkConfig.fromJson(const {'assistantEnabled': true}).assistantEnabled,
          isTrue);
      expect(SdkConfig.fromJson(const {}).assistantEnabled, isFalse);
      expect(const SdkConfig.defaults().assistantEnabled, isFalse);
    });
  });

  group('send body', () {
    late List<http.Request> requests;
    late FeaturelyApiClient client;

    setUp(() {
      requests = [];
      client = FeaturelyApiClient(
        baseUrl: 'https://feedback.example.com',
        apiKey: 'fk_key',
        environment: 'sandbox',
        deviceIdProvider: () async => 'u_device_abcdefgh',
        httpClient: MockClient((request) async {
          requests.add(request);
          final body = jsonDecode(request.body) as Map<String, dynamic>;
          return http.Response(
              jsonEncode({
                'id': 'm1',
                'author': 'user',
                'authorKind': 'end_user',
                'body': body['body'],
                'createdAt': '2026-09-18T09:00:00.000Z',
                'clientMessageId': body['clientMessageId'],
              }),
              201);
        }),
      );
    });

    test('is exactly the server fixture: diagnostics, actions, capability',
        () async {
      final expected = _fixture('send-body');
      await client.sendChatMessage(
        body: expected['body'] as String,
        clientMessageId: expected['clientMessageId'] as String,
        deviceLocale: expected['deviceLocale'] as String,
        resolvedLocale: expected['resolvedLocale'] as String,
        metadata: (expected['metadata'] as Map<String, dynamic>)
            .cast<String, String>(),
        diagnostics: expected['diagnostics'] as Map<String, Object?>,
        availableActions:
            (expected['availableActions'] as List<dynamic>).cast<String>(),
      );
      expect(jsonDecode(requests.single.body), expected);
    });

    test('omits empty diagnostics and actions but always declares support',
        () async {
      await client.sendChatMessage(
        body: 'Hi',
        clientMessageId: '5a3c9e10-1111-4111-8111-111111111111',
        diagnostics: const {},
        availableActions: const [],
      );
      await client.sendChatMessage(
        body: 'Hi',
        clientMessageId: '5a3c9e10-1111-4111-8111-111111111111',
      );
      for (final request in requests) {
        expect(jsonDecode(request.body), {
          'body': 'Hi',
          'clientMessageId': '5a3c9e10-1111-4111-8111-111111111111',
          'assistantCapable': true,
        });
      }
    });
  });
}
