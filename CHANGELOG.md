# Changelog

## Unreleased

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
