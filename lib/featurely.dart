/// Featurely Flutter SDK — an in-app feedback sheet for the self-hosted
/// Featurely platform.
///
/// Host apps integrate in two calls:
///
/// ```dart
/// await Featurely.init(
///   baseUrl: 'https://feedback.example.com',
///   apiKey: 'fk_…', // the project key, from Project Settings
/// );
/// // …from any button:
/// await Featurely.show(context);
/// ```
///
/// Debug builds report to the Sandbox environment automatically; release
/// builds to Live. Pass `environment:` to `init` to override.
library;

export 'src/api/api_exception.dart'
    show FeaturelyApiException, FeaturelyErrorCode, FeaturelyNetworkException;
export 'src/featurely_base.dart' show Featurely;
export 'src/options.dart' show FeaturelyEnvironment, FeaturelyErrorListener;
export 'src/theme.dart' show FeaturelyTheme;
