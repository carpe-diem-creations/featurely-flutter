# Changelog

## 0.6.0

**AI Support Assistant:** a Featurely project can let an AI assistant
answer chat messages within seconds and hand off to the team when it can't
help. Needs a Featurely server with the assistant enabled for the
environment; against older servers everything below is ignored and chat
works as before.

- Every chat send now declares `assistantCapable: true`, so the assistant
  may answer conversations from this SDK.
- Assistant replies show the assistant's name and a small "AI" tag. They
  are plain text (no markdown); numbered lines get a hanging indent.
- While the assistant is writing, the chat shows "{name} is typing…" and
  polls every 1.5 s, returning to 5 s when the reply lands or after 60 s.
- New `Featurely.setChatDiagnosticsProvider(provider)`: a live app-state
  snapshot sent with each message. The provider gets 1 s; a timeout, a
  throw, or a result over the limits (4 096 bytes of JSON, 3 levels deep,
  200-character strings, 30-item lists) sends the message without it. If the
  server rejects the snapshot, the message is re-sent once without it.
- New `Featurely.registerChatActions([FeaturelyChatAction(id:, title:)])`
  and `Featurely.setChatActionHandler(handler)`: the assistant can suggest
  registered actions, shown as buttons under its reply. The handler returns
  `FeaturelyChatActionResult.stay` or `.dismiss` (closes the chat sheet); a
  tapped action shows as used for the session.
- Localized "AI", "Assistant" and "{name} is typing…" strings
  (`sdkChatAiTag`, `sdkChatAssistantName`, `sdkChatAssistantTyping`) in all
  34 locales.

## 0.5.0

- Refreshed the chat screen. Messages are grouped under day separators
  (Today, Yesterday, the weekday, then the date), so each message shows only
  its time. Bubbles have a smaller corner on the sender's side, and team
  messages no longer carry a visible "Team" label (screen readers still
  announce it). A message that failed to send shows as a tinted outline
  bubble.
- The "Get replies by email" row is now a card above the composer instead of
  a bar under the header. The composer and send button were resized.
- Localized "Today" and "Yesterday" strings (`sdkChatToday`,
  `sdkChatYesterday`) in all 34 locales.

## 0.4.0

- 8 new locales: Bulgarian (`bg`), Greek (`el`), Finnish (`fi`), Indonesian
  (`id`), Lithuanian (`lt`), Romanian (`ro`), Slovak (`sk`) and Albanian
  (`sq`) — and Traditional Chinese (`zh-Hant`): 34 in total, matching the
  Featurely server.
- Locale resolution now honors script subtags like the server: a `Hant`
  script, or a script-less `zh` with region TW, HK or MO, resolves to
  `zh-Hant` (previously `zh`); `zh-Hans-*` and other regions stay `zh`, and
  unsupported scripts are ignored (`pt-Latn-BR` → `pt-BR`).
- New `Featurely.hasUnreadMessages()` — `true` when
  `unreadMessageCount()` is above zero, for a simple badge. Never throws;
  `false` before `init`, when chat is unavailable, and on any error.
- `Featurely.showChat(context, initialMessage: text)` prefills the chat
  composer (cursor at the end, field focused). It is never sent
  automatically; blank text is ignored, it is capped to the 4 000-character
  limit, and it is applied once per `showChat` call.
- **Chat metadata:** new `Featurely.setChatMetadata(map)` attaches app-wide
  context (e.g. plan, app version) to every chat message sent from then on,
  and `Featurely.showChat(context, metadata: map)` adds per-presentation
  context (it wins on key collisions). The team sees it next to the message
  in the Inbox and the alert email; it is never shown to the user. The SDK
  trims and caps it to the server's limits (20 entries, 64-character keys,
  500-character values) instead of failing the send, and a retried message
  keeps its original metadata. The field is omitted when empty; servers
  that predate chat metadata ignore it.

## 0.3.0

**In-App Chat:** a private one-to-one thread between the device and your
team, answered from the dashboard Inbox. Needs a Featurely server that
reports `chatEnabled` in `GET /config`; older servers keep working with chat
hidden.

- New `Featurely.showChat(context)` presents the chat as a standalone sheet.
- New `Featurely.unreadMessageCount()` returns the number of unread team
  messages for a host-app badge. It never throws and returns `0` when chat
  is unavailable.
- The feedback sheet shows a "Message us" action (when the server supports
  chat) that opens the chat inside the same sheet.
- The chat has optimistic sends with tap-to-retry, "Load earlier" history,
  an optional "Get replies by email" row, 5 s polling while the chat is on
  screen and the app is in the foreground (paused for 30 s after a `429`),
  and read markers. It also shows the SANDBOX strip and supports RTL.
- The thread is tied to the device ID, so `logout()` starts a fresh chat.
- `FeaturelyErrorCode` gains `invalidMessage` and `conversationNotFound`.
- 16 new `sdk.chat.*` strings in all 25 locales.

## 0.2.3

- Releases are now published to pub.dev automatically from CI when a
  version tag is pushed. No package changes.

## 0.2.2

- The header close and filter buttons are larger: 40pt circles (up from
  32pt), with the icon scaling up accordingly — a more comfortable tap
  target.

## 0.2.1

- The submit form's description hints are now just the question, in all 25
  locales: "What should {appName} do?" (Feature) and "What went wrong in
  {appName}?" (Issue) — the trailing coaching sentences are dropped.

## 0.2.0

**Breaking:** the environment is no longer derived from the API key prefix.
Each project now has a single key (`fk_…`, always visible in Project
Settings); the SDK declares the environment on every request via the
`X-Featurely-Environment` header. Requires a Featurely instance running the
single-key migration or later — and older `fk_live_…`/`fk_test_…` keys are
regenerated by that migration, so update the key when upgrading.

- `Featurely.init` accepts `environment:` (`FeaturelyEnvironment`, now
  exported). Default: debug builds → Sandbox, release builds → Live.
- The key-prefix assert now only checks for `fk_`; the sandbox strip is
  driven by the resolved environment instead of the key.

- `Featurely.init` accepts `onError`, an observability hook receiving every
  API operation that ultimately fails; `FeaturelyApiException`,
  `FeaturelyErrorCode`, and `FeaturelyNetworkException` are now exported.
- Comment composer enforces the server's `commentMax` client-side, matching
  the title and description fields.
- Feedback list rows show a one-line description excerpt, and vote boxes
  announce "N votes" to screen readers.
- A failed next-page load now renders an inline Retry footer instead of
  waiting silently for another scroll.
- The filter sheet's apply button reads "Show 100+ requests" when more
  results exist beyond the count preview page (new
  `sdkFilterShowResultsOverflow` string in all 25 locales).
- Screenshot re-encodes (e.g. HEIC) are downscaled to at most 2048 px on
  the longest edge, so large photos no longer produce PNGs that exceed the
  instance upload limit.
- Example app: the dark-mode switch now exercises the
  `FeaturelyTheme.brightness` override.

## 0.1.0

Initial release.

- `Featurely.init` / `Featurely.show` two-call integration.
- Feedback list with cursor pagination, pull-to-refresh, filter & sort
  sheet, and optimistic toggleable voting.
- Submit form: Feature/Issue, title with live counter, description,
  optional email, one screenshot (photo library; HEIC transcoded to PNG),
  auto-captured device metadata, full-screen confirmation.
- Detail screen with attachment, large vote button, and the public comment
  thread (Team badges, optimistic composer).
- Host theming (accent, radius, brightness, font) with fixed status colors;
  amber SANDBOX strip for `fk_test_…` keys.
- Identity linking: `login`/`logout` with automatic device-ID rotation and
  account-switch handling; `setPlan`.
- All 25 Featurely locales, RTL included, resolved independently of the
  host app's locale.
