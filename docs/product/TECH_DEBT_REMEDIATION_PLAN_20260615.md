# Technical Debt Remediation Plan

Date: 2026-06-15

## Current State

The newer Supabase layer is moving in the right direction: repositories and
services are separated and easier to test. The remaining launch risk is mostly
in legacy Flutter screens that still own too much networking, state, and UI at
the same time.

## Confirmed Debt Buckets

1. Mutable widgets
   - Many `Widget` classes have non-final constructor fields, causing
     `must_be_immutable`.
   - Fix by converting constructor inputs to `final` and using local state only
     inside `State` classes.

2. Deprecated APIs
   - `ImagePicker.getImage` should become `ImagePicker.pickImage`.
   - `Share.share` should move to `SharePlus.instance.share`.
   - `url_launcher.launch` should move to `launchUrl`.

3. Unused code
   - Many fields, locals, and private helpers are unused.
   - Remove only after checking the screen flow, because several legacy screens
     have side effects hidden in callbacks.

4. SDK constraint
   - Fixed in `pubspec.yaml`: Dart SDK is now `>=3.4.0 <4.0.0`.
   - The old `>=2.18.5 <3.0.0` was incompatible with the modern dependency set
     and current Flutter/Dart tooling.

5. `dependency_overrides`
   - Current overrides may hide compatibility issues:
     `archive`, `flutter_blurhash`, `numberpicker`.
   - Do not remove blindly. First run dependency resolution and targeted smoke
     tests, then remove one override at a time.

## Recommended Order

1. Keep `tool/test.sh` as the stable test command.
2. Convert mutable widget constructor fields to `final` in small screen groups.
3. Replace deprecated image/share/url APIs in one pass per package.
4. Remove unused fields after each screen group is covered by a smoke test.
5. Attempt dependency override removal one package at a time.
