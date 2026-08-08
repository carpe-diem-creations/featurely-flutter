# Changelog

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
