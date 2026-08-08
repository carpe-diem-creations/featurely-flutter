# featurely

In-app feedback for Flutter apps, backed by a self-hosted
[Featurely](https://github.com/carpe-diem-creations) instance: end users
browse feature requests and issue reports, vote, comment, and submit new
feedback (with an optional screenshot and email) — your team triages
everything in the Featurely web dashboard.

- **Two-line integration** — `init` once, `show` anywhere.
- **Native-feeling** — inherits your accent color, corner radius, font, and
  light/dark mode; iOS and Android adaptive details.
- **25 languages** including RTL (`ar`, `he`), resolved independently of the
  host app's locale.
- **Sandbox/live separation by key** — `fk_test_…` keys hit Sandbox and show
  an unmistakable amber SANDBOX strip; test data can never pollute Live.
- Android and iOS only.

## Getting started

```yaml
dependencies:
  featurely: ^0.1.0
```

Initialize once at startup (idempotent — call it on every launch), then
present the sheet from any trigger:

```dart
import 'package:featurely/featurely.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Featurely.init(
    baseUrl: 'https://feedback.example.com', // your instance, no /api/v1
    apiKey: const String.fromEnvironment('FEATURELY_API_KEY'),
  );
  runApp(const MyApp());
}

// From any button:
await Featurely.show(context);
```

### Choosing the API key per build

The key determines the project **and** the environment: `fk_live_…` reads
and writes Live data, `fk_test_…` only Sandbox data. There is no runtime
toggle — pick the key from the build type, e.g. with
`--dart-define=FEATURELY_API_KEY=…` and flavors/build modes, so debug and
staging builds always carry a sandbox key. Sandbox sessions render an amber
SANDBOX strip across the top of the sheet so QA always knows which mode
they're in.

## Theming

```dart
await Featurely.init(
  baseUrl: …,
  apiKey: …,
  theme: const FeaturelyTheme(
    accentColor: Color(0xFFD9572B), // default: your Theme's colorScheme.primary
    cornerRadius: 16,               // default: 12
    brightness: Brightness.dark,    // default: follows the host theme
    fontFamily: 'Inter',            // default: host font
  ),
);
```

Status pill colors and the sandbox strip are fixed by design and are not
themed. On-accent text color is computed by contrast, so any accent hue stays
legible in light and dark.

## Localization

The sheet ships all 25 Featurely locales and resolves its language from the
device locale (or the `locale:` override passed to `init`), independent of
your `MaterialApp`'s locale — fallback chain: exact match → base language →
English. `ar` and `he` render fully right-to-left.

## Identity: login / logout

By default users are pseudonymous per install. If your app has its own
accounts, link them so votes follow the user across devices and reinstalls:

```dart
await Featurely.init(…, userId: currentUser.id); // or:
await Featurely.login(currentUser.id);           // on sign-in
await Featurely.logout();                        // on sign-out
```

- Pass an **opaque internal id**, never an email or other PII.
- `login` is idempotent and safe on every launch; switching accounts is
  handled automatically (the SDK rotates its device identity between users).
- `logout` starts the next user of the device with a clean slate.

`Featurely.setPlan('Pro Monthly')` updates the plan label attached to
submissions (drives the PAYING badge in your dashboard).

## Screenshots & permissions

The submit form offers one optional screenshot from the photo library
(no camera). No `Info.plist` entry is needed on iOS 14+ (PHPicker), and no
runtime permission on Android (Photo Picker on API 33+; older APIs are
handled by `image_picker`'s legacy path). HEIC images are transcoded to PNG
automatically before upload.

## Example app

[`example/`](example/) is a runnable host app for manual QA against a local
`featurely-app` docker instance:

```sh
cd example
flutter run \
  --dart-define=FEATURELY_BASE_URL=http://localhost:3000 \
  --dart-define=FEATURELY_API_KEY=fk_test_…
```

(Use `http://10.0.2.2:3000` on the Android emulator.) It exposes theming
knobs, a locale override, and login/logout buttons.

## Requirements

- Flutter `>=3.27.0`, Dart `^3.6.0`
- Android & iOS (no web/desktop)
- A Featurely instance serving the frozen `/api/v1` contract (any server
  version — the SDK decodes leniently and never breaks on additive changes)
