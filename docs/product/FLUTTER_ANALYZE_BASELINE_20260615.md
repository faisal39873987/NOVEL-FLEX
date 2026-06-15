# Flutter Analyze Baseline

Date: 2026-06-15

## Current Result

`flutter analyze` currently exits non-zero with 112 issues. The current output is
warning/info debt rather than direct compile errors.

Major buckets:

- `must_be_immutable` on many `Widget` classes with mutable constructor fields.
- `unused_field`, `unused_local_variable`, and `unused_element` in legacy screens.
- Deprecated APIs such as `ImagePicker.getImage`, `Share.share`, and
  `url_launcher.launch`.
- Old package/tooling warnings for iOS Swift Package Manager support.

## Fixes Applied In This Pass

- Removed an unused local variable in the login screen.
- Restored `Languages.home` in the abstract localization contract so Arabic and
  English implementations no longer override a missing getter.
- Updated the Dart SDK constraint in `pubspec.yaml` from `>=2.18.5 <3.0.0` to
  `>=3.4.0 <4.0.0`.

## Recommended Cleanup Order

1. Convert mutable `Widget` constructor fields to `final`.
2. Remove unused fields only where the surrounding screen behavior is understood.
3. Replace deprecated image/share/url APIs in grouped screen passes.
4. Keep `tool/test.sh` as the local test command while the Flutter native-assets
   crash on this external volume remains reproducible.
