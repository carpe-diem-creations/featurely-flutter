import 'package:featurely/src/options.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('trailing slashes are stripped from the base URL', () {
    final options = FeaturelyOptions(
      baseUrl: 'https://feedback.example.com///',
      apiKey: 'fk_live_abc',
    );
    expect(options.baseUrl, 'https://feedback.example.com');
  });

  test('environment derives from the key prefix', () {
    expect(
      FeaturelyOptions(baseUrl: 'https://x.example.com', apiKey: 'fk_test_a')
          .environment,
      FeaturelyEnvironment.sandbox,
    );
    expect(
      FeaturelyOptions(baseUrl: 'https://x.example.com', apiKey: 'fk_live_a')
          .environment,
      FeaturelyEnvironment.live,
    );
  });

  test('an unrecognized key prefix asserts in debug', () {
    expect(
      () => FeaturelyOptions(
        baseUrl: 'https://x.example.com',
        apiKey: 'sk_live_wrong',
      ),
      throwsAssertionError,
    );
  });

  test('non-HTTPS base URLs assert in debug unless local', () {
    expect(
      () => FeaturelyOptions(
        baseUrl: 'http://feedback.example.com',
        apiKey: 'fk_live_a',
      ),
      throwsAssertionError,
    );
    // Local development hosts are exempt.
    for (final url in [
      'http://localhost:3000',
      'http://127.0.0.1:3000',
      'http://10.0.2.2:3000',
      'http://featurely.local',
    ]) {
      expect(FeaturelyOptions(baseUrl: url, apiKey: 'fk_test_a'), isNotNull);
    }
  });
}
