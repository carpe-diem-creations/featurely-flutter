import 'dart:convert';

import 'package:featurely/src/api/api_client.dart';
import 'package:featurely/src/core.dart';
import 'package:featurely/src/identity/identity_store.dart';
import 'package:featurely/src/metadata.dart';
import 'package:featurely/src/options.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecordedRequest {
  RecordedRequest(this.method, this.path, this.deviceId, this.body);

  final String method;
  final String path;
  final String? deviceId;
  final String body;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late List<RecordedRequest> requests;
  late FeaturelyCore core;
  late IdentityStore identity;

  FeaturelyCore buildCore({bool failIdentify = false}) {
    identity = IdentityStore();
    final options = FeaturelyOptions(
      baseUrl: 'https://feedback.example.com',
      apiKey: 'fk_key1',
    );
    return FeaturelyCore(
      options: options,
      identity: identity,
      metadata: DeviceMetadata(override: const {}),
      api: FeaturelyApiClient(
        baseUrl: options.baseUrl,
        apiKey: options.apiKey,
        environment: options.environment.name,
        deviceIdProvider: () => identity.deviceId(),
        readRetryDelay: (_) => Duration.zero,
        httpClient: MockClient((request) async {
          requests.add(RecordedRequest(
            request.method,
            request.url.path,
            request.headers['X-Featurely-Device-Id'],
            request.body,
          ));
          if (failIdentify && request.method == 'POST') {
            throw http.ClientException('offline');
          }
          return http.Response('', 204);
        }),
      ),
    );
  }

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    requests = [];
    core = buildCore();
  });

  test('link posts /identify with the current device ID', () async {
    final deviceId = await identity.deviceId();
    await core.link('usr_a');
    expect(requests, hasLength(1));
    expect(requests.single.method, 'POST');
    expect(requests.single.path, '/api/v1/identify');
    expect(requests.single.deviceId, deviceId);
    expect(jsonDecode(requests.single.body), {'userId': 'usr_a'});
    expect(await identity.linkedUserId(), 'usr_a');
    expect(await identity.linkPending(), isFalse);
  });

  test('repeating the same link is a no-op (idempotent)', () async {
    await core.link('usr_a');
    await core.link('usr_a');
    expect(requests.where((r) => r.method == 'POST'), hasLength(1));
  });

  test('account switch rotates: logout sequence then link on fresh ID',
      () async {
    final firstDevice = await identity.deviceId();
    await core.link('usr_a');
    requests.clear();

    await core.link('usr_b');

    expect(requests, hasLength(2));
    // (a) best-effort DELETE /identify on the old device ID.
    expect(requests[0].method, 'DELETE');
    expect(requests[0].path, '/api/v1/identify');
    expect(requests[0].deviceId, firstDevice);
    // (b)+(c) new device ID persisted, link B on the fresh ID.
    final secondDevice = await identity.deviceId();
    expect(secondDevice, isNot(firstDevice));
    expect(requests[1].method, 'POST');
    expect(requests[1].deviceId, secondDevice);
    expect(jsonDecode(requests[1].body), {'userId': 'usr_b'});
  });

  test('logout rotates even when anonymous and DELETE fails', () async {
    core = buildCore(failIdentify: true);
    final before = await identity.deviceId();
    await core.logout();
    final after = await identity.deviceId();
    expect(after, isNot(before));
  });

  test('failed link stays pending and is retried on next launch', () async {
    core = buildCore(failIdentify: true);
    await core.link('usr_a');
    expect(await identity.linkPending(), isTrue);

    // Next launch: identify succeeds now.
    requests = [];
    core = buildCore();
    await core.retryPendingLink();
    expect(requests.single.method, 'POST');
    expect(jsonDecode(requests.single.body), {'userId': 'usr_a'});
    expect(await identity.linkPending(), isFalse);
  });

  test('old device ID is never sent after rotation', () async {
    final oldId = await identity.deviceId();
    await core.logout();
    requests.clear();
    await core.link('usr_c');
    expect(requests.every((r) => r.deviceId != oldId), isTrue);
  });
}
