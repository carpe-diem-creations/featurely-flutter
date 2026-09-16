# featurely

In-app feedback for Flutter apps, backed by a self-hosted
[Featurely](https://github.com/carpe-diem-creations) instance: end users
browse feature requests and issue reports, vote, comment, and submit new
feedback (with an optional screenshot and email), and message your team
privately through In-App Chat — your team triages and replies from the
Featurely web dashboard.

- **Two-line integration** — `init` once, `show` anywhere.
- **In-App Chat** — a private one-to-one thread with your team, as a
  standalone sheet (`showChat`) or from the feedback sheet's "Message us"
  action.
- **Native-feeling** — inherits your accent color, corner radius, font, and
  light/dark mode; iOS and Android adaptive details.
- **34 languages** including RTL (`ar`, `he`), resolved independently of the
  host app's locale.
- **Automatic sandbox/live separation** — one API key; debug builds report
  to Sandbox (with an unmistakable amber SANDBOX strip), release builds to
  Live. Test data can never pollute Live.
- Android and iOS only.

## Getting started

```yaml
dependencies:
  featurely: ^0.3.0
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

### Environments

Each project has a single API key (always available in Project Settings);
the SDK declares the environment on every request. By default it follows
the build type — debug builds report to Sandbox, release builds to Live —
so there is nothing to configure. For special flavors (e.g. a staging
release build that should stay in Sandbox), override it at `init`:

```dart
await Featurely.init(
  baseUrl: …,
  apiKey: …,
  environment: FeaturelyEnvironment.sandbox,
);
```

Sandbox sessions render an amber SANDBOX strip across the top of the sheet
so QA always knows which mode they're in. It is never a user-facing runtime
toggle.

## In-App Chat

End users can message your team privately; the team answers from the
dashboard **Inbox**. Replies show up in the open chat within a few seconds
(the SDK polls every 5 s while the chat is on screen and the app is in the
foreground), and are also emailed when the user left an address via the
optional "Get replies by email" row.

Two entry points:

```dart
// 1. A standalone chat sheet, from your own "Contact us" button:
await Featurely.showChat(context);

// 2. Automatically: the feedback sheet opened by Featurely.show shows a
//    "Message us" action that pushes the chat inside the same sheet.
```

To start the user off, prefill the composer — for example from an order
screen:

```dart
await Featurely.showChat(
  context,
  initialMessage: 'I have a question about order #1234',
);
```

The text is only placed in the composer (cursor at the end, field focused);
it is never sent automatically, and the user can edit or delete it. Blank
text is ignored, it is capped to the 4 000-character message limit, and it
is applied once per `showChat` call — it doesn't come back after the user
sends or clears it. The "Message us" chat opens with an empty composer.

### Chat metadata

Give your team context with each message — the current screen, the plan, an
order id. Set an app-wide map once (it applies to every message sent from
then on; `null` clears it), and/or pass a map when you open the chat:

```dart
Featurely.setChatMetadata({'plan': 'pro', 'appVersion': '2.4.1'});

await Featurely.showChat(
  context,
  metadata: {'screen': 'Checkout', 'orderId': '1234'}, // wins on collisions
);
```

Metadata is shown to your team only — next to the message in the Inbox and
in the support alert email. It is never shown to the user and never returned
by the API, but **don't put secrets in it**. Values are strings; keys are
trimmed and at most 64 characters, values are truncated to 500 characters,
and at most 20 entries are sent (the SDK drops or trims anything else rather
than failing the send). A retried message keeps the metadata it was
composed with. The "Message us" chat inside the feedback sheet uses the
app-wide map only.

Show an unread badge on your own button with `unreadMessageCount()` — it
never throws and returns `0` before `init`, when the device has no
conversation, when the server doesn't support chat, or on any error:

```dart
final unread = await Featurely.unreadMessageCount(); // e.g. on app resume
```

For a plain dot badge, `hasUnreadMessages()` returns
`unreadMessageCount() > 0` with the same never-throws semantics (`false`
wherever the count is `0`). Each call is a network request, so refresh it on
demand — for example on app resume and after the chat closes:

```dart
Future<bool> _unread = Featurely.hasUnreadMessages();

// In build():
FutureBuilder<bool>(
  future: _unread,
  builder: (context, snapshot) => Badge(
    isLabelVisible: snapshot.data ?? false,
    child: IconButton(
      icon: const Icon(Icons.chat_bubble_outline),
      onPressed: () async {
        await Featurely.showChat(context);
        setState(() => _unread = Featurely.hasUnreadMessages());
      },
    ),
  ),
)
```

Things to know:

- **One thread per device.** The conversation belongs to the SDK's device
  ID, not to `login(userId)`, so it never follows a user across devices.
  `logout()` (and logging in as a different user) rotates the device ID and
  starts a fresh, empty chat; the old thread stays in your Inbox.
- **Don't collect secrets in chat.** Anyone holding the device ID can read
  that device's thread, the same trust level as votes.
- Messages are plain text, up to 4 000 characters. Messages that fail to
  send show "Not sent — Tap to retry" and are kept only while the chat is
  open. A retry never double-posts.
- Chat needs a Featurely server that reports `chatEnabled` in
  `GET /api/v1/config`. Against older servers the "Message us" action is
  hidden and `unreadMessageCount()` returns `0`; gate your own
  `showChat` button accordingly, since on those servers the chat screen
  can only show its failed-load state.
- The chat uses the same theming, localization (including RTL) and SANDBOX
  strip as the feedback sheet.

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

The sheet ships all 34 Featurely locales and resolves its language from the
device locale (or the `locale:` override passed to `init`), independent of
your `MaterialApp`'s locale — fallback chain: language + script → language +
region → base language → English. Chinese uses Traditional (`zh-Hant`) for a
`Hant` script or, without a script, for the regions TW, HK and MO
(`Locale('zh', 'TW')` → `zh-Hant`); everything else gets Simplified (`zh`). `ar` and `he` render fully right-to-left.

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

## Observability

The sheet handles every failure with its own localized UI, so errors are
invisible to the host by default. To log or report them (a rotated key, an
unreachable instance), pass `onError` — it receives each API operation that
ultimately fails, after retries:

```dart
await Featurely.init(
  …,
  onError: (operation, error) => log.warning('featurely $operation: $error'),
);
```

`error` is a `FeaturelyApiException` (branch on its `code`) or a
`FeaturelyNetworkException`; neither ever contains the API key. Exceptions
thrown by the listener are swallowed — they never break the SDK's own
handling.

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
  --dart-define=FEATURELY_API_KEY=fk_…
```

(Use `http://10.0.2.2:3000` on the Android emulator.) It exposes theming
knobs, a locale override, and login/logout buttons.

## Requirements

- Flutter `>=3.27.0`, Dart `^3.6.0`
- Android & iOS (no web/desktop)
- A Featurely instance serving the frozen `/api/v1` contract (any server
  version — the SDK decodes leniently and never breaks on additive changes).
  In-App Chat needs a server that reports `chatEnabled`.
