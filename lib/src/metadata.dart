import 'dart:io';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Auto-captured submission metadata (app version/build, OS, device model,
/// device locale). Captured lazily once and cached for the app session.
class DeviceMetadata {
  /// Creates the capturer. [override] short-circuits capture in tests.
  DeviceMetadata({Map<String, String>? override}) : _override = override;

  final Map<String, String>? _override;
  Future<Map<String, String>>? _captured;

  /// The metadata fields for `POST /feedback`, each truncated to the
  /// contract's 200-character limit. Failures degrade to omitting fields.
  Future<Map<String, String>> capture() {
    final override = _override;
    if (override != null) return Future.value(override);
    return _captured ??= _capture();
  }

  static Future<Map<String, String>> _capture() async {
    final metadata = <String, String>{};
    try {
      final info = await PackageInfo.fromPlatform();
      metadata['appVersion'] = info.version;
      metadata['appBuild'] = info.buildNumber;
    } catch (_) {}
    try {
      final plugin = DeviceInfoPlugin();
      if (Platform.isIOS) {
        final ios = await plugin.iosInfo;
        metadata['osVersion'] = 'iOS ${ios.systemVersion}';
        metadata['deviceModel'] = ios.utsname.machine;
      } else if (Platform.isAndroid) {
        final android = await plugin.androidInfo;
        metadata['osVersion'] = 'Android ${android.version.release}';
        metadata['deviceModel'] = android.model;
      }
    } catch (_) {}
    metadata['deviceLocale'] = PlatformDispatcher.instance.locale.toLanguageTag();
    return {
      for (final entry in metadata.entries)
        if (entry.value.isNotEmpty) entry.key: truncate(entry.value),
    };
  }

  /// Truncates [value] to the contract's 200-character metadata limit.
  static String truncate(String value) =>
      value.length <= 200 ? value : value.substring(0, 200);
}
