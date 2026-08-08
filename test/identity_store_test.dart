import 'package:featurely/src/identity/identity_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

final RegExp deviceIdPattern = RegExp(r'^u_[A-Za-z0-9_-]{4,64}$');

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('generated IDs match the contract format', () {
    for (var i = 0; i < 100; i++) {
      final id = IdentityStore.generateDeviceId();
      expect(id, matches(deviceIdPattern));
      expect(id.length, 24); // u_ + 22 chars.
    }
  });

  test('device ID persists across store instances', () async {
    final first = await IdentityStore().deviceId();
    final second = await IdentityStore().deviceId();
    expect(second, first);
  });

  test('corrupt stored ID is regenerated', () async {
    SharedPreferences.setMockInitialValues(
        {'featurely.deviceId': 'not-a-device-id'});
    final id = await IdentityStore().deviceId();
    expect(id, matches(deviceIdPattern));
  });

  test('rotation produces a new conforming ID and never reuses the old one',
      () async {
    final store = IdentityStore();
    final original = await store.deviceId();
    final rotated = await store.rotate();
    expect(rotated, matches(deviceIdPattern));
    expect(rotated, isNot(original));
    expect(await store.deviceId(), rotated);
    // And it stuck for fresh instances too.
    expect(await IdentityStore().deviceId(), rotated);
  });

  test('rotation clears the linked user', () async {
    final store = IdentityStore();
    await store.setLinkedUser('usr_1', pending: false);
    await store.rotate();
    expect(await store.linkedUserId(), isNull);
    expect(await store.linkPending(), isFalse);
  });

  test('link pending round-trip', () async {
    final store = IdentityStore();
    await store.setLinkedUser('usr_1', pending: true);
    expect(await store.linkedUserId(), 'usr_1');
    expect(await store.linkPending(), isTrue);
    await store.markLinkSynced();
    expect(await store.linkPending(), isFalse);
  });
}
