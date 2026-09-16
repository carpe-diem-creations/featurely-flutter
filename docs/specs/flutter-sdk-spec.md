You are implementing the **Featurely Flutter SDK** for the Featurely feedback platform.
Use this specification as your single source of truth.
Do not make assumptions about any requirement not listed here. If something
is ambiguous or missing, stop and ask before proceeding.

# Featurely Flutter SDK

## OVERVIEW

Featurely is a self-hosted feedback platform: mobile apps embed an SDK that lets end
users submit feature requests and bug reports, vote, and comment, while the team triages
everything in a web dashboard. This spec covers the **Flutter SDK** — a Dart package
named **`featurely`**, published to pub.dev from this repo (`featurely-flutter`), that
renders the end-user feedback sheet inside host apps on **iOS and Android** (mobile
only; no web/desktop support).

The SDK is a **guest in the host app**: it inherits the host's accent color, corner
radius, font, and light/dark mode, ships localized UI in 34 locales, and talks
exclusively to the **frozen public API contract** documented in
`featurely-app/docs/api-v1.md` (referred to below as *the API contract* — read it in
full before implementing; its identity, pagination, error, and visibility semantics are
normative). The server is self-hosted, so the SDK takes the instance base URL as
configuration. Target integration effort for a host app: **init + one line to present
the sheet**.

Authoritative sources this spec is derived from:

- `featurely-app/docs/featurely-prd.md` §4.10, §7 (SDK requirements), §8
- `featurely-app/docs/api-v1.md` (the frozen v1 API contract)
- `featurely-app/packages/locales/catalog/en.arb` (canonical string catalog — `sdk.*` keys)
- Design mockups: Claude Design project "Featurely UI mockups and prototype"
  (`Featurely Screens.dc.html`), designed at 390×844 iOS-first

## GOALS

- A host app integrates in two calls: `Featurely.init(...)` once at startup and
  `Featurely.show(context)` from any trigger.
- The sheet feels native and on-brand in any host: any accent hue, any corner radius,
  light and dark, 34 locales including RTL (`ar`, `he`).
- Feedback lands in the correct environment 100% of the time; sandbox and live can
  never mix (environment is derived from the API key, never a runtime toggle).
- The package stays a good guest: minimal, ubiquitous dependencies only; no
  state-management or DI frameworks leak into host apps.
- Publishable quality: pub.dev score-clean (`flutter analyze` clean, documented public
  API, example app, CHANGELOG).

## USER STORIES

- As an **end user**, I want to open a feedback sheet inside the app, browse existing
  requests, and vote, so that I can support ideas without creating an account.
- As an **end user**, I want to submit a feature request or issue with an optional
  screenshot and optional email, so that the team hears me and can tell me when it ships.
- As an **end user**, I want to comment on a request and see team replies, so that I
  can add context and know the team is listening.
- As an **end user using the app in my language**, I want the whole sheet localized
  (including RTL), so that giving feedback is effortless.
- As a **host-app developer**, I want a two-line integration with theming knobs, so
  that the sheet looks native in my app with minimal work.
- As a **host-app developer with my own auth**, I want `login`/`logout` linking, so
  that a user's votes follow them across devices and reinstalls.
- As a **QA engineer**, I want debug builds to hit Sandbox with an unmistakable
  indicator, so that test data never pollutes live and I always know which mode I'm in.

## ACCEPTANCE CRITERIA

Numbered, testable; each verifiable pass/fail. "The contract" = `docs/api-v1.md`.

### Initialization & configuration

1. `Featurely.init(baseUrl:, apiKey:, userId:, plan:, theme:, locale:)` configures the
   singleton. `baseUrl` and `apiKey` are required; all else optional. Calling `init`
   again replaces the configuration (idempotent, safe on every launch).
2. The SDK derives environment from the key prefix: `fk_test_…` → Sandbox,
   `fk_live_…` → Live. There is no environment parameter and no runtime toggle. A key
   matching neither prefix is accepted and treated as Live (forward-compatible), but
   asserts in debug mode.
3. `Featurely.show(context)` presents the full-height feedback sheet. Calling it before
   `init` throws a `StateError` with an actionable message.
4. On first launch the SDK generates a device ID matching `^u_[A-Za-z0-9_-]{4,64}$`
   (`u_` + 22 chars from `Random.secure()`), persists it via `shared_preferences`, and
   reuses it across launches. Every API request sends it as `X-Featurely-Device-Id`.
5. `GET /config` is fetched when the sheet opens and cached for the app session; the
   cached copy is reused on later opens and refreshed in the background. The sheet
   still opens (with cached or default limits) if the fetch fails; `project.name` from
   config supplies `{appName}` in strings.

### Identity

6. Passing `userId` at init, or calling `Featurely.login(userId)`, links the device via
   `POST /identify`. Both are idempotent; `login()` overrides an init-time `userId`
   (last write wins). Linking is fire-and-forget: failures are silently retried on next
   launch/link, never surfaced to the end user.
7. `Featurely.logout()` follows the contract's exact sequence: (a) `DELETE /identify`
   (best-effort, ignore failures), (b) generate a **new** device ID, (c) persist it;
   all subsequent requests use the new ID. The old ID is never sent again.
8. Account switching is enforced by the SDK: if `login(B)` (or `init(userId: B)`) is
   called while a different user A is linked (tracked locally), the SDK first performs
   the logout rotation of criterion 7, then links B on the fresh device ID.

### List screen (root)

9. The root screen shows the localized title ("Feedback"), a close button (leading), a
   filter button (trailing), and rows with: tappable vote box (chevron + count,
   accent-filled when the viewer has voted), title, status pill, comment count. A
   sticky full-width accent **New feedback** CTA sits above the safe area.
10. The list loads via `GET /feedback` with cursor pagination: infinite scroll appends
    pages using `nextCursor` verbatim until it is `null`; sort and filter are held
    constant across pages; changing either restarts from no cursor. Pull-to-refresh
    restarts from no cursor.
11. Default sort is `votes`. The filter bottom sheet offers Sort (Most voted / Newest /
    Oldest), Status chips (All / Open / Planned / In Progress / Done), Reset, and a
    primary "Show N requests" button with a live count. **Declined does not exist in
    the SDK**: no enum value, no chip, no string.
12. Vote taps are optimistic and toggleable: the UI flips immediately, then reconciles
    counts from the `POST`/`DELETE …/vote` response. On failure the UI reverts; on
    `404` the item is removed from the list.
13. States: first-load skeleton rows; a failed-load screen with localized error copy
    and a Retry button; an empty state with the localized "Nothing here yet…" copy and
    the New feedback CTA.

### Submit flow

14. The form has: Type segmented control (**"Feature" / "Issue"** — never the word
    "Bug" anywhere user-facing); Title (required, 60-char limit, live
    "{n} characters left" counter shown at ≤10 remaining); Description (required,
    multiline, placeholder varies by type and injects `{appName}`); optional Email with
    the localized helper copy; a single screenshot slot; a Submit button pinned to the
    bottom, disabled until title and description are non-blank, showing an in-place
    spinner while sending.
15. The screenshot is picked from the **photo library only** (`image_picker`, no camera).
    After picking, the SDK validates magic bytes; if the file is not PNG/JPEG/WebP
    (e.g. HEIC), it re-encodes to PNG via `dart:ui`. Files exceeding
    `config.limits.attachmentMaxBytes` after any re-encode are rejected client-side
    with an inline message before upload. The thumbnail has an × to remove; max one.
16. Submission `POST /feedback` is multipart with `title`, `description`, `type`
    (`feature`|`bug` — the stored value for "Issue" is `bug`), optional `email`,
    optional `screenshot`, plus auto-captured metadata: `plan` (from init/`setPlan`),
    `appVersion` + `appBuild` (package_info_plus), `osVersion` + `deviceModel`
    (device_info_plus), `deviceLocale` (the device's locale), `resolvedLocale` (the
    locale the SDK actually rendered in).
17. Success shows the full-screen confirmation (check mark, localized copy) with a
    button back to the list; the new item appears in the list after return (refresh).
    Never silently dismiss.
18. Failure shows the localized inline error, preserves the draft **in memory** (fields
    and picked image stay populated; closing the sheet discards it), and relabels the
    button "Try again". A `201` is never retried (no duplicate submissions); only
    transport errors/5xx/429 make the form retryable — validation `4xx` is surfaced
    as a field error, not a retry.

### Detail screen

19. Detail (`GET /feedback/:id`) shows title, status pill, localized "Submitted {date}"
    (platform-formatted), full description, attachment (when `hasAttachment`, loaded
    from `GET /feedback/:id/attachment` with both auth headers), a large full-width
    vote button (accent; "Vote" → "▲ Voted · n", optimistic per criterion 12), and the
    public comment thread: end-user authors render as localized "Anonymous", `team`
    authors get an accent **Team** badge. Internal notes can never appear (the API
    never returns them).
20. The comment composer renders only when cached config says `commentingEnabled`.
    `POST /feedback/:id/comments` appends optimistically-pending comments; a `403
    comments_disabled` response hides the composer and shows a brief notice (config was
    stale). A `404` on any detail action pops back to the list and removes the item.

### Theming, sandbox, platform

21. `FeaturelyTheme(accentColor:, cornerRadius:, brightness:, fontFamily:)` — all
    optional. Defaults: accent from the host's `Theme.of(context).colorScheme.primary`,
    radius 12, brightness follows the host/system, font inherits the host's default.
    All components must remain legible for any accent hue (compute on-accent
    foreground by contrast) in both light and dark.
22. Sandbox keys render a thin solid amber strip labeled with the localized SANDBOX
    string across the top of the sheet — fixed amber `#F59E0B`-family (same family as
    the dashboard treatment), never themed by the host, and the only element exempt
    from host theming. Live keys render no strip.
23. The sheet is one custom design on both platforms with platform-adaptive details
    only: iOS gets swipe-to-dismiss and Cupertino scroll physics; Android gets ripples
    and back-gesture/predictive-back handling. System back on Android pops the sheet's
    internal navigation stack before dismissing the sheet.

### Localization

24. All UI strings come from the committed ARB catalogs (`sdk.*` keys of the canonical
    catalog, key names camelCased, e.g. `sdk.list.title` → `sdkListTitle`); no
    user-facing string literals in widget code. Plurals use ICU via `intl`
    (vote/comment counts, "Show N requests", the title counter).
25. Locale resolution: init `locale` override, else the device locale; fallback chain
    language-Script → language-REGION → language (`pt-PT` → `pt`, unsupported
    regionals and scripts collapse to base; script-less `zh-TW`/`HK`/`MO` →
    `zh-Hant`) → `en`, replicating `packages/locales/src/locales.ts` including case- and
    `_`-separator-insensitivity. The resolved locale is rendered **regardless of the
    host `MaterialApp`'s locale** (the SDK subtree wraps its own `Localizations`
    override) and is sent as `resolvedLocale` on submissions.
26. `ar` and `he` render fully RTL: the SDK subtree derives `Directionality` from the
    resolved locale (not the host), mirroring layout, chevrons, and gestures.
    User-generated content renders in whatever script/direction it was written.

### API conformance & resilience

27. Every request sends `Authorization: Bearer <key>` and `X-Featurely-Device-Id`.
    Error responses are decoded to `{error: {code, message}}`; the SDK branches on
    `code` only, shows its own localized copy (never the server `message`), treats
    unknown codes as generic failures, and **ignores unknown JSON fields** everywhere.
28. `429` responses honor the `retry-after` header: user-initiated actions surface a
    localized "try again in a moment" state; the SDK never auto-retries before
    `retry-after` elapses. Non-429 `4xx` are never retried unchanged; `5xx`/transport
    errors on reads retry with backoff (max 2 retries).
29. The SDK never logs or exposes the API key, submitter emails, or external user IDs;
    `hasAttachment: false` in a `201` is accepted silently (contract's
    partial-failure note — no resubmit).

### Package & repo

30. The package passes `flutter analyze` with zero issues, declares
    `environment: sdk: ^3.6.0` and `flutter: ">=3.27.0"`, supports only Android and
    iOS, and every public symbol has a doc comment.
31. `example/` contains a runnable host app demonstrating init (with `--dart-define`d
    base URL + key), theming knobs, `show()`, and `login`/`logout` buttons — usable for
    manual QA against a local `featurely-app` docker instance.
32. All tests in TESTING REQUIREMENTS pass via `flutter test`.

## TECHNICAL DESIGN

Greenfield Flutter **package** (not app, not plugin — Dart-only; native functionality
comes from the plugin dependencies). Repo `featurely-flutter`, package name
`featurely`, initial version `0.1.0`, license MIT (match the org default; confirm
before first publish if unsure).

### Dependencies

| Package | Purpose | Constraint |
|---|---|---|
| `http` | API client | `^1.x` |
| `image_picker` | photo-library screenshot pick | `^1.x` |
| `shared_preferences` | device-ID + linked-user persistence | `^2.x` |
| `package_info_plus` | appVersion / appBuild metadata | latest `^x` |
| `device_info_plus` | osVersion / deviceModel metadata | latest `^x` |
| `intl` | ICU plurals + date formatting (via `flutter_localizations`) | match Flutter's pin |

Dev deps: `flutter_test`, `flutter_lints` (strict), `build`-less — l10n via
`flutter gen-l10n`. **No** state-management, DI, or codegen runtime packages. Internal
state uses `ChangeNotifier`/`ValueNotifier`.

### Repository layout

```
featurely-flutter/
├── pubspec.yaml
├── l10n.yaml                     # gen-l10n config (arb-dir: lib/src/l10n/arb, no synthetic package)
├── analysis_options.yaml         # flutter_lints, strict
├── CHANGELOG.md
├── README.md                     # integration guide (init, show, theming, login)
├── docs/specs/flutter-sdk-spec.md   # this file
├── lib/
│   ├── featurely.dart            # public exports: Featurely, FeaturelyTheme (only these)
│   └── src/
│       ├── featurely_base.dart   # Featurely singleton facade (init/show/login/logout/setPlan/chat)
│       ├── options.dart          # FeaturelyOptions (resolved init config), FeaturelyEnvironment
│       ├── theme.dart            # FeaturelyTheme + resolution against host Theme
│       ├── identity/
│       │   └── identity_store.dart  # device-ID gen/persist/rotate, linked-user tracking
│       ├── api/
│       │   ├── api_client.dart   # http wrapper: headers, retry/backoff, retry-after
│       │   ├── models.dart       # FeedbackItem, FeedbackComment, SdkConfig, Page<T>
│       │   └── api_exception.dart# error-code enum + unknown-code handling
│       ├── metadata.dart         # device-metadata capture (package_info/device_info/locale)
│       ├── l10n/
│       │   ├── arb/              # featurely_en.arb … featurely_zh_Hant.arb (34 files, committed)
│       │   └── generated/       # gen-l10n output (committed, so consumers need no codegen)
│       └── ui/
│           ├── sheet.dart        # show(): modal route, internal Navigator, Localizations override
│           ├── sandbox_strip.dart
│           ├── screens/          # list, filter_sheet, form, success, detail
│           └── widgets/          # vote_box, status_pill, skeleton, empty/error states, composer
├── example/                      # runnable host app (android + ios)
└── test/                         # see TESTING REQUIREMENTS
```

### APIs / Interfaces (public surface — exactly this)

```dart
class Featurely {
  /// Idempotent; call on every launch.
  static Future<void> init({
    required String baseUrl,        // e.g. https://feedback.example.com (no /api/v1 suffix)
    required String apiKey,         // fk_live_… or fk_test_…; host picks per build
    String? userId,                 // links identity at init (last write wins with login())
    String? plan,                   // e.g. 'Pro Monthly'; sent with submissions
    FeaturelyTheme? theme,
    Locale? locale,                 // override; default = device locale
  });

  static Future<void> show(BuildContext context); // presents the sheet; StateError if not inited
  static Future<void> login(String userId);       // idempotent; enforces rotation on account switch
  static Future<void> logout();                   // DELETE /identify → rotate device ID → persist
  static void setPlan(String? plan);              // update plan mid-session (e.g. after upgrade)

  // In-App Chat
  static Future<void> showChat(BuildContext context,
      {Map<String, String>? metadata,             // wins over setChatMetadata
       String? initialMessage});                  // standalone chat sheet; prefills (never sends) the composer once
  static Future<int> unreadMessageCount();        // never throws; 0 when unavailable
  static void setChatMetadata(Map<String, String>? metadata); // app-wide team-only context on chat messages; null clears
}

class FeaturelyTheme {
  const FeaturelyTheme({Color? accentColor, double? cornerRadius,
                        Brightness? brightness, String? fontFamily});
}
```

Everything else is `src/`-private. `show()` awaits sheet dismissal.

### State & data flow

- **Presentation:** `show()` pushes a `ModalBottomSheetRoute` (full-height,
  `isScrollControlled`, `useSafeArea`) hosting an internal `Navigator` for
  list → form/detail → success. The subtree is wrapped in `Localizations.override`
  + `Directionality` (resolved locale) and a `Theme` built from `FeaturelyTheme`
  resolved against the host theme at present time. iOS: swipe-to-dismiss enabled;
  Android: `PopScope` routes system back through the internal navigator first.
- **Controllers:** `FeedbackListController` (items, cursor, sort/filter, optimistic
  vote reconcile) and `FeedbackDetailController` (item, comments, composer) are
  `ChangeNotifier`s created per sheet presentation and disposed on dismissal. Config
  cache and identity live app-session-long in the `Featurely` singleton.
- **Init sequence:** synchronously store options → async: load/generate device ID,
  then if `userId` given and ≠ locally-tracked linked user, run the account-switch
  logic (criterion 8), then `POST /identify` fire-and-forget. Init never blocks the
  host app on network.
- **Metadata capture** runs once lazily (cached): `PackageInfo.fromPlatform()`,
  `DeviceInfoPlugin` (`Platform.isIOS ? iosInfo : androidInfo` →
  `"iOS ${systemVersion}"` / `"Android ${version.release}"`, `utsname.machine` /
  `model`), `PlatformDispatcher.instance.locale` for `deviceLocale`.
- **Attachment rendering:** `Image.network(attachmentUrl, headers: {auth, deviceId})`
  relying on the endpoint's `Cache-Control: private, max-age=86400`.

### Localization pipeline

- Canonical source: `featurely-app/packages/locales/catalog/*.arb` (dot-namespaced
  keys, `sdk.*` + `email.*`). This repo commits **derived Flutter ARBs** under
  `lib/src/l10n/arb/`: only `sdk.*` keys, renamed to lowerCamelCase
  (`sdk.form.emailHelper` → `sdkFormEmailHelper` — mechanical rule: strip dots,
  camel-case each segment boundary), with `@`-metadata and placeholders preserved.
- Updating is a **manual copy/transform** when the canonical catalog changes (no sync
  tooling in v1). Record the source commit hash of `featurely-app` in a comment at the
  top of a `lib/src/l10n/arb/SOURCE` file on each sync.
- As of this writing only `en` exists upstream; the 33 translations are a
  `featurely-app` Phase 3 deliverable. **Build against `en` now**; wire all 34 locales
  in `supportedLocales` behind the fallback chain so dropping in the translated ARBs
  is the only step left. Publishing `1.0.0` requires all 34 catalogs; `0.x` may ship
  English-only.
- Fallback resolution is implemented in `resolveLocale()` in Dart, mirroring
  `locales.ts` exactly (same inputs → same outputs; unit-tested against the same cases).

### Fixed design tokens

Status colors (identical everywhere, not themed): Open `#4B7BE5`, Planned `#8B5CF6`,
In Progress `#0E9888`, Done `#23A55A`. Sandbox amber strip: `#F59E0B` background with
dark-on-amber label. There is no Declined token. Saturated color is reserved for
status pills and the sandbox strip; everything else derives from the host theme's
neutral surfaces plus the single accent.

## DEPENDENCIES & INTEGRATIONS

- **Server:** any Featurely instance serving `/api/v1` per the frozen contract; the
  example app targets a local `featurely-app` docker instance. The contract is frozen:
  additive changes only — decode leniently, never fail on unknown fields/codes.
- **featurely-app locales package:** upstream source for ARB catalogs (manual sync,
  above). Translated catalogs are pending Phase 3 upstream — tracked as a `1.0.0`
  release blocker, not an implementation blocker.
- **Host-app requirements** (document in README): iOS `Info.plist` needs no photo
  permission on iOS 14+ (PHPicker); Android needs no runtime permission with Photo
  Picker (API 33+; on older APIs `image_picker` handles the legacy path). Host passes
  the correct key per build — recommend `--dart-define=FEATURELY_API_KEY=…` with
  flavors/build-modes choosing live vs test keys.

## OUT OF SCOPE

- Web, desktop, or watchOS support (mobile Android + iOS only).
- Camera capture or in-app screen capture for the screenshot slot (photo library only).
- Draft persistence across sheet dismissals or app restarts (in-memory per session).
- Offline queueing of submissions/votes/comments; background sync.
- Any Declined-status surface, roadmap view, analytics, or dashboard functionality.
- Displaying the Team's names/avatars (the API returns author *kind* only).
- Push/in-app notifications; email UI beyond the optional email field.
- l10n sync tooling/CI between repos (manual copy in v1).
- GitHub Actions CI (explicitly deferred by the maintainer; add later).
- Custom statuses, multiple attachments, merge/duplicate flows (platform v1 non-goals).

## EDGE CASES & ERROR HANDLING

- **Show before init** → `StateError('Featurely.init must be called before show')`.
- **Config fetch fails at sheet open** → open anyway with defaults (limits 60/10 000/
  5 000/5 MiB, commenting hidden until config confirms it, `{appName}` falls back to
  empty-string-safe copy); retry the fetch on next open.
- **`nextCursor` null on a full page** → that *is* the last page; no extra request.
- **`400 invalid_cursor`** (e.g. after a sort change race) → restart list from no cursor.
- **Vote/unvote 404** → remove item from list (it was deleted/declined); no error toast.
- **`votes`-sort pagination duplicates** (contract-accepted) → de-dupe appended pages
  by item `id`.
- **Comment `403 comments_disabled`** → hide composer, show localized notice, update
  cached config.
- **Screenshot is HEIC** → decode + re-encode to PNG via `dart:ui`; if decode fails,
  reject with the localized "couldn't attach" message.
- **Screenshot over `attachmentMaxBytes`** → reject client-side before upload with
  inline message (never rely on the server 400 for the happy path, but map
  `attachment_too_large`/`attachment_not_image` to the same inline error if it occurs).
- **Submit transport failure/5xx/429** → inline "Couldn't send…" copy, draft retained,
  button becomes "Try again"; 429 additionally waits out `retry-after` before
  re-enabling.
- **Submit `201` with `hasAttachment: false`** despite an uploaded file → success as
  normal (server partial-failure semantics); never resubmit.
- **`login(B)` while A linked** → auto logout-rotation then link B (criterion 8).
- **`logout()` when anonymous** → still rotates the device ID (harmless, keeps the
  shared-device guarantee); `DELETE /identify` best-effort.
- **shared_preferences read fails/empty on rotation write** → regenerate; a lost
  device ID only orphans pseudonymous votes (accepted).
- **Device locale changes mid-session** → resolved locale is fixed per sheet
  presentation; next `show()` re-resolves.
- **Very long titles/descriptions in list rows** → title 2-line ellipsis, excerpt
  1-line; RTL scripts and CJK render correctly (no char-boundary truncation).
- **Empty list vs failed load** are distinct states (empty copy + CTA vs error + Retry).
- **60-char title counting** is in Unicode characters (grapheme-safe enough via
  `String.characters`), matching the server's character-not-byte rule.

## SECURITY & PERFORMANCE

- The API key ships inside the host binary by design (project-scoped, SDK-surface
  only); the SDK must never log it, and redacts `Authorization` from any debug output.
  Base URL must be HTTPS in release (assert in debug for non-HTTPS non-localhost).
- No PII: device IDs are pseudonymous; `userId` is treated as an opaque string and
  never exposed in UI/logs; submitter email is sent once in the multipart body and
  never stored on device beyond the in-memory draft.
- Respect server rate limits (120 reads/min per key is shared across *all* devices of
  the app): fetch config once per session, no polling, no auto-refresh loops;
  pull-to-refresh is the only refresh trigger.
- Optimistic vote UI must render the toggle instantly (<16 ms frame); list scrolling
  uses `ListView.builder` with const-friendly rows; skeletons render immediately while
  the first page loads.
- Screenshot re-encode runs off the UI thread: the `dart:ui` codecs decode and
  encode on the engine's worker threads (a `compute` isolate cannot host `dart:ui`
  codecs or the platform HEIC decoder), and re-encoded images are downscaled to at
  most 2048 px on the longest edge to bound the work and the PNG output size.
- Never trust server `message` strings into UI (English, developer-facing).

## TESTING REQUIREMENTS

Unit tests (`test/`):
- `resolveLocale`: mirrors `locales.ts` cases — exact, region collapse (`pt-BR`→`pt`,
  `de-CH`→`de`), `_` separators, case-insensitivity, unknown → `en`, null/empty → `en`.
- Device ID: format regex, persistence round-trip, rotation on logout produces a new
  conforming ID and never reuses the old one, account-switch auto-rotation.
- API client: headers on every request; error-shape decoding; unknown-code → generic;
  unknown-fields ignored; retry-after honored; backoff on 5xx; no retry on 4xx;
  cursor passed verbatim; `Page` end detection on `nextCursor: null`.
- Magic-byte validation: PNG/JPEG/WebP accepted; HEIC/GIF/zero-byte rejected →
  re-encode path invoked.
- Title character counting at the 60 limit (multibyte/emoji cases).

Widget tests:
- Form: submit disabled until valid; counter appears at ≤10 remaining; type toggle
  swaps placeholders; failure preserves draft + relabels button; success screen shown
  on 201 (mock client).
- List: skeleton → items; optimistic vote flip + reconcile + revert-on-error;
  empty vs error states; filter sheet result-count button.
- Detail: comment composer hidden when `commentingEnabled: false`; 403 hides composer;
  Team badge on `team` comments; "Anonymous" label.
- Localization/RTL: sheet renders under `ar` with `TextDirection.rtl` regardless of a
  LTR host app; a pseudo-long-string case (+30%) doesn't overflow the form's buttons.
- Sandbox strip present with an `fk_test_` key, absent with `fk_live_`.

Manual QA (example app against local docker `featurely-app`):
- Full submit-with-screenshot flow lands in the dashboard's Sandbox with correct
  metadata (version, build, OS, model, locales, plan).
- Vote from two simulated devices, `login` with the same userId on both → count
  dedupes to 1; logout on one → fresh anonymous identity, votes gone from view.
- Team reply in dashboard appears in SDK thread with Team badge.

## DEPLOYMENT / ROLLOUT NOTES

- Versioning: semver from `0.1.0`; CHANGELOG entry per release; `1.0.0` gated on all
  34 locale catalogs landing and a round of integration against a deployed instance.
- Publish flow (manual in v1): `flutter analyze` clean → `flutter test` green →
  `dart pub publish --dry-run` clean → `dart pub publish`. Tag `v{version}` in git.
- pub.dev listing: README doubles as the integration guide; `example/` is the pub
  example; add `topics: [feedback, widget]`-style metadata and issue tracker URL
  pointing at this repo.
- No feature flags and no server-side coordination needed: the contract is frozen and
  additive-only, so SDK releases and server upgrades are independent by design.
- Rollback = pub retraction (`dart pub retract`) within the allowed window, or a
  patch release; host apps pin caret constraints so a bad release is skippable.

## OPEN QUESTIONS

*(none — all resolved with the maintainer on 2026-08-08: pub.dev name `featurely`;
one custom look with platform-adaptive details; minimal deps + package_info_plus +
device_info_plus; single `apiKey` init parameter; photo-library-only screenshots;
committed ARB copies, manual sync; in-memory drafts; Flutter 3.27+/Dart 3.6+;
example app in scope, CI deferred.)*

---

Do not begin implementation until you have confirmed your understanding of the
acceptance criteria and the OPEN QUESTIONS section is empty.
