import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

/// Generates, persists, and rotates the pseudonymous device ID, and tracks
/// the locally-linked external user.
///
/// The device ID matches `^u_[A-Za-z0-9_-]{4,64}$` (`u_` + 22 chars from
/// `Random.secure()`), is generated once per install, and is only ever
/// replaced by [rotate] (logout / account switch). A retired ID is never
/// sent again.
class IdentityStore {
  static const String _deviceIdKey = 'featurely.deviceId';
  static const String _linkedUserKey = 'featurely.linkedUserId';
  static const String _linkPendingKey = 'featurely.linkPending';

  static final RegExp _deviceIdPattern = RegExp(r'^u_[A-Za-z0-9_-]{4,64}$');
  static const String _alphabet =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_-';

  SharedPreferences? _prefs;
  String? _deviceId;

  Future<SharedPreferences> get _preferences async =>
      _prefs ??= await SharedPreferences.getInstance();

  /// Generates a new conforming device ID from a secure random source.
  static String generateDeviceId() {
    final random = Random.secure();
    final chars = List<String>.generate(
      22,
      (_) => _alphabet[random.nextInt(_alphabet.length)],
    );
    return 'u_${chars.join()}';
  }

  /// The persistent device ID, generated on first use. A stored value that
  /// fails the format check (corrupt or empty) is regenerated — a lost ID
  /// only orphans pseudonymous votes.
  Future<String> deviceId() async {
    final cached = _deviceId;
    if (cached != null) return cached;
    final prefs = await _preferences;
    final stored = prefs.getString(_deviceIdKey);
    if (stored != null && _deviceIdPattern.hasMatch(stored)) {
      return _deviceId = stored;
    }
    final generated = generateDeviceId();
    await prefs.setString(_deviceIdKey, generated);
    return _deviceId = generated;
  }

  /// Replaces the device ID with a freshly generated one and clears the
  /// linked-user record. The old ID is never used again.
  Future<String> rotate() async {
    final prefs = await _preferences;
    final generated = generateDeviceId();
    _deviceId = generated;
    await prefs.setString(_deviceIdKey, generated);
    await prefs.remove(_linkedUserKey);
    await prefs.remove(_linkPendingKey);
    return generated;
  }

  /// The external user this device is (or should be) linked to, or null.
  Future<String?> linkedUserId() async =>
      (await _preferences).getString(_linkedUserKey);

  /// Whether the recorded link still needs a successful `POST /identify`.
  Future<bool> linkPending() async =>
      (await _preferences).getBool(_linkPendingKey) ?? false;

  /// Records the desired link; [pending] is true until the server confirmed.
  Future<void> setLinkedUser(String userId, {required bool pending}) async {
    final prefs = await _preferences;
    await prefs.setString(_linkedUserKey, userId);
    await prefs.setBool(_linkPendingKey, pending);
  }

  /// Marks the recorded link as confirmed by the server.
  Future<void> markLinkSynced() async =>
      (await _preferences).setBool(_linkPendingKey, false);
}
