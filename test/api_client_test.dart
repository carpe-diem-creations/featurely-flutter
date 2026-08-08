import 'dart:convert';

import 'package:featurely/src/api/api_client.dart';
import 'package:featurely/src/api/api_exception.dart';
import 'package:featurely/src/api/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

FeaturelyApiClient clientWith(MockClient mock) => FeaturelyApiClient(
      baseUrl: 'https://feedback.example.com',
      apiKey: 'fk_test_abc123',
      deviceIdProvider: () async => 'u_testdevice1234567890ab',
      httpClient: mock,
      readRetryDelay: (_) => Duration.zero,
    );

http.Response jsonResponse(Object body, [int status = 200]) =>
    http.Response(jsonEncode(body), status,
        headers: {'content-type': 'application/json'});

const Map<String, Object> itemJson = {
  'id': 'item-1',
  'title': 'Offline mode',
  'description': 'Please',
  'type': 'feature',
  'status': 'planned',
  'votes': 12,
  'viewerHasVoted': true,
  'commentCount': 3,
  'hasAttachment': false,
  'createdAt': '2026-07-14T08:21:04.117Z',
};

void main() {
  test('every request carries both auth headers', () async {
    final requests = <http.Request>[];
    final client = clientWith(MockClient((request) async {
      requests.add(request);
      return jsonResponse({'items': <Object>[], 'nextCursor': null});
    }));
    await client.listFeedback();
    expect(requests, hasLength(1));
    expect(requests.first.headers['Authorization'], 'Bearer fk_test_abc123');
    expect(requests.first.headers['X-Featurely-Device-Id'],
        'u_testdevice1234567890ab');
  });

  test('error shape decodes to a stable code', () async {
    final client = clientWith(MockClient((request) async => jsonResponse(
        {'error': {'code': 'invalid_cursor', 'message': 'nope'}}, 400)));
    await expectLater(
      client.listFeedback(cursor: 'bad'),
      throwsA(isA<FeaturelyApiException>().having(
          (e) => e.code, 'code', FeaturelyErrorCode.invalidCursor)),
    );
  });

  test('unknown error codes decode to unknown (generic failure)', () async {
    final client = clientWith(MockClient((request) async => jsonResponse(
        {'error': {'code': 'brand_new_code', 'message': 'later'}}, 400)));
    await expectLater(
      client.getFeedback('x'),
      throwsA(isA<FeaturelyApiException>()
          .having((e) => e.code, 'code', FeaturelyErrorCode.unknown)),
    );
  });

  test('unknown JSON fields are ignored everywhere', () async {
    final client = clientWith(MockClient((request) async => jsonResponse({
          'items': [
            {...itemJson, 'shinyNewField': true, 'pinned': 1},
          ],
          'nextCursor': null,
          'totalCount': 999,
        })));
    final page = await client.listFeedback();
    expect(page.items.single.id, 'item-1');
    expect(page.items.single.status, FeedbackStatus.planned);
  });

  test('429 surfaces retry-after and is never auto-retried', () async {
    var calls = 0;
    final client = clientWith(MockClient((request) async {
      calls++;
      return http.Response(
        jsonEncode({'error': {'code': 'rate_limited', 'message': ''}}),
        429,
        headers: {'retry-after': '17'},
      );
    }));
    await expectLater(
      client.listFeedback(),
      throwsA(isA<FeaturelyApiException>()
          .having((e) => e.code, 'code', FeaturelyErrorCode.rateLimited)
          .having((e) => e.retryAfter, 'retryAfter',
              const Duration(seconds: 17))),
    );
    expect(calls, 1);
  });

  test('reads retry 5xx with backoff, max 2 retries', () async {
    var calls = 0;
    final client = clientWith(MockClient((request) async {
      calls++;
      return jsonResponse(
          {'error': {'code': 'internal_error', 'message': ''}}, 500);
    }));
    await expectLater(
      client.getConfig(),
      throwsA(isA<FeaturelyApiException>()
          .having((e) => e.code, 'code', FeaturelyErrorCode.internalError)),
    );
    expect(calls, 3); // 1 attempt + 2 retries.
  });

  test('reads recover when a retry succeeds', () async {
    var calls = 0;
    final client = clientWith(MockClient((request) async {
      calls++;
      if (calls < 2) return jsonResponse({'error': {'code': 'internal_error'}}, 500);
      return jsonResponse({'items': <Object>[], 'nextCursor': null});
    }));
    final page = await client.listFeedback();
    expect(page.items, isEmpty);
    expect(calls, 2);
  });

  test('non-429 4xx is never retried', () async {
    var calls = 0;
    final client = clientWith(MockClient((request) async {
      calls++;
      return jsonResponse({'error': {'code': 'not_found', 'message': ''}}, 404);
    }));
    await expectLater(client.getFeedback('gone'),
        throwsA(isA<FeaturelyApiException>()));
    expect(calls, 1);
  });

  test('writes are not retried on 5xx', () async {
    var calls = 0;
    final client = clientWith(MockClient((request) async {
      calls++;
      return jsonResponse({'error': {'code': 'internal_error'}}, 500);
    }));
    await expectLater(client.vote('x'), throwsA(isA<FeaturelyApiException>()));
    expect(calls, 1);
  });

  test('cursor is passed verbatim', () async {
    late Uri seen;
    const cursor = 'eyJzIjpbMzFdLCJpZCI6IjdiMWQ5ZTQyIn0=';
    final client = clientWith(MockClient((request) async {
      seen = request.url;
      return jsonResponse({'items': <Object>[], 'nextCursor': null});
    }));
    await client.listFeedback(
        sort: FeedbackSort.newest, cursor: cursor, limit: 25);
    expect(seen.queryParameters['cursor'], cursor);
    expect(seen.queryParameters['sort'], 'newest');
    expect(seen.queryParameters['limit'], '25');
  });

  test('nextCursor null on a full page is the end-of-list signal', () async {
    final client = clientWith(MockClient((request) async => jsonResponse({
          'items': List<Object>.filled(50, itemJson),
          'nextCursor': null,
        })));
    final page = await client.listFeedback();
    expect(page.items, hasLength(50));
    expect(page.nextCursor, isNull);
  });

  test('vote and unvote reconcile from the response', () async {
    final client = clientWith(MockClient((request) async {
      expect(request.url.path, '/api/v1/feedback/item-1/vote');
      return jsonResponse({'votes': 32, 'viewerHasVoted': true});
    }));
    final result = await client.vote('item-1');
    expect(result.votes, 32);
    expect(result.viewerHasVoted, isTrue);
  });

  test('transport failures throw FeaturelyNetworkException after retries',
      () async {
    var calls = 0;
    final client = clientWith(MockClient((request) async {
      calls++;
      throw http.ClientException('boom');
    }));
    await expectLater(
        client.listFeedback(), throwsA(isA<FeaturelyNetworkException>()));
    expect(calls, 3);
  });

  test('exception text never contains the API key', () {
    final exception = FeaturelyApiException(FeaturelyErrorCode.unknown, 500);
    expect(exception.toString(), isNot(contains('fk_')));
  });

  test('config decodes limits and project name', () async {
    final client = clientWith(MockClient((request) async => jsonResponse({
          'project': {'name': 'Northwind Reader'},
          'commentingEnabled': true,
          'visibleStatuses': ['open', 'planned', 'in_progress', 'done'],
          'limits': {
            'titleMax': 60,
            'descriptionMax': 10000,
            'commentMax': 5000,
            'attachmentMaxBytes': 1048576,
            'attachmentTypes': ['image/png'],
          },
        })));
    final config = await client.getConfig();
    expect(config.projectName, 'Northwind Reader');
    expect(config.commentingEnabled, isTrue);
    expect(config.attachmentMaxBytes, 1048576);
  });
}
