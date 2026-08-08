import 'dart:convert';

import 'package:featurely/src/api/api_client.dart';
import 'package:featurely/src/api/api_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

const String apiKey = 'fk_test_abc123';

FeaturelyApiClient clientWith(
  MockClient mock, {
  void Function(String operation, Object error)? onError,
}) =>
    FeaturelyApiClient(
      baseUrl: 'https://feedback.example.com',
      apiKey: apiKey,
      deviceIdProvider: () async => 'u_testdevice1234567890ab',
      httpClient: mock,
      readRetryDelay: (_) => Duration.zero,
      onError: onError,
    );

http.Response errorResponse(String code, int status) => http.Response(
      jsonEncode({
        'error': {'code': code, 'message': 'developer facing'}
      }),
      status,
      headers: {'content-type': 'application/json'},
    );

void main() {
  test('onError reports a read failure once, after retries are exhausted',
      () async {
    final reported = <(String, Object)>[];
    var attempts = 0;
    final client = clientWith(
      MockClient((request) async {
        attempts++;
        return errorResponse('internal_error', 500);
      }),
      onError: (operation, error) => reported.add((operation, error)),
    );
    await expectLater(
        client.getConfig(), throwsA(isA<FeaturelyApiException>()));
    expect(attempts, 3); // 1 try + 2 retries
    expect(reported, hasLength(1));
    expect(reported.single.$1, 'getConfig');
    expect(reported.single.$2, isA<FeaturelyApiException>());
    // The API key never leaks through the hook.
    expect(reported.single.$2.toString(), isNot(contains(apiKey)));
  });

  test('write failures report their operation name', () async {
    final operations = <String>[];
    final client = clientWith(
      MockClient((request) async => errorResponse('not_found', 404)),
      onError: (operation, error) => operations.add(operation),
    );
    await expectLater(
        client.vote('item-1'), throwsA(isA<FeaturelyApiException>()));
    await expectLater(client.addComment('item-1', 'hi'),
        throwsA(isA<FeaturelyApiException>()));
    expect(operations, ['vote', 'addComment']);
  });

  test('transport failures are reported as FeaturelyNetworkException',
      () async {
    final reported = <Object>[];
    final client = clientWith(
      MockClient((request) async => throw Exception('socket down')),
      onError: (operation, error) => reported.add(error),
    );
    await expectLater(
        client.identify('usr_1'), throwsA(isA<FeaturelyNetworkException>()));
    expect(reported.single, isA<FeaturelyNetworkException>());
  });

  test('successful requests report nothing', () async {
    final reported = <String>[];
    final client = clientWith(
      MockClient((request) async => http.Response('', 204)),
      onError: (operation, error) => reported.add(operation),
    );
    await client.identify('usr_1');
    expect(reported, isEmpty);
  });

  test('a throwing listener neither masks nor swallows the SDK error',
      () async {
    final client = clientWith(
      MockClient((request) async => errorResponse('not_found', 404)),
      onError: (operation, error) => throw StateError('host bug'),
    );
    await expectLater(
        client.vote('item-1'), throwsA(isA<FeaturelyApiException>()));
  });
}
