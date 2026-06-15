# NOVELFLEX Launch Critical Audit

Date: 2026-06-14  
Scope: mobile app, web auth, Supabase backend, store readiness, privacy, upload/build blockers.  
Mode: audit only. No deployment, no schema changes, no code changes.

## Executive Verdict

**NOT READY FOR RELEASE**

NOVELFLEX is close structurally, but launch is currently blocked by four production issues:

1. iOS build/export cannot complete because the Mac system disk is full.
2. Android release build fails because AppleDouble `._*` metadata files are included in build/resources.
3. Apple web sign-in is broken at Apple with `invalid_client` for `com.artstyle.novelflex.web`.
4. Privacy/legal/account deletion paths are not production-complete for App Store review.

## 1. Upload / Build Readiness

### iOS

Status: **FAIL**

Evidence:

- `flutter build ios --release --no-codesign` started successfully.
- Xcode failed with:
  - `No space left on device`
  - Failed writing `temporary_xcresult_bundle`
  - Failed writing DerivedData precompiled module output.
- Disk check:
  - `/` available: `116Mi`
  - `/System/Volumes/Data` available: `116Mi`
  - `~/Library/Developer/Xcode/DerivedData`: `4.8G`
  - project `build/`: `6.5G`

Conclusion:

iOS upload/archive is blocked by local machine storage, not by Flutter code.

### Android

Status: **FAIL**

Evidence:

`flutter build appbundle --release` failed:

```text
Execution failed for task ':app:parseReleaseLocalResources'.
'/Volumes/SANDISK/novelflex-app-main/build/app/intermediates/packaged_res/release/packageReleaseResources/._drawable' is not a directory
```

Root cause:

macOS AppleDouble files `._*` exist in the project/build tree. Found count under `ios/Pods`, `android`, and `build`: `32186`.

Conclusion:

Google Play upload is blocked until `._*` artifacts are removed and the build is rerun cleanly.

## 2. Google Sign-In

### Web

Status: **PASS**

Evidence:

Supabase `/auth/v1/authorize?provider=google` returns HTTP `302` to Google:

```text
https://accounts.google.com/o/oauth2/v2/auth
client_id=689581686707-k1smshq7d5vleq2bu2h77av32alq4bps.apps.googleusercontent.com
redirect_uri=https://ifxzbwaxrloeuztavcef.supabase.co/auth/v1/callback
```

### Mobile

Status: **PARTIAL PASS / DEVICE VERIFICATION REQUIRED**

Evidence:

- iOS `GoogleService-Info.plist` bundle ID: `com.artstyle.novelflex`.
- iOS client ID: `362340188692-sks0s537a6k98j6fuvqgfm4rpcqtuf4n.apps.googleusercontent.com`.
- `Info.plist` includes reversed Google URL scheme.
- Supabase Auth has 3 Google identities.

Remaining requirement:

Physical iPhone and Android tests must confirm session creation and `UserProvider` synchronization after login.

## 3. Apple Sign-In

### Web

Status: **FAIL**

Evidence:

Supabase starts the Apple OAuth flow:

```text
client_id=com.artstyle.novelflex.web
redirect_uri=https://ifxzbwaxrloeuztavcef.supabase.co/auth/v1/callback
```

But Apple returns:

```json
{"errorMessage":"Invalid client.","errorCode":"invalid_client"}
```

Root cause:

Apple Developer configuration for Services ID `com.artstyle.novelflex.web` is not valid for the Supabase callback. The likely missing/incorrect items are:

- Services ID does not exist or is not enabled for Sign in with Apple.
- Services ID is not linked to the primary App ID `com.artstyle.novelflex`.
- Return URL is missing or incorrect:
  - `https://ifxzbwaxrloeuztavcef.supabase.co/auth/v1/callback`
- Web domain configuration for the Services ID is incomplete.
- Supabase Apple provider may have a mismatched client secret for this Services ID.

### Mobile iOS

Status: **PARTIAL PASS / DEVICE VERIFICATION REQUIRED**

Evidence:

- Release entitlements include `com.apple.developer.applesignin = Default`.
- Supabase Auth has 1 Apple identity.
- Native iOS code uses `SignInWithApple.getAppleIDCredential()` and `signInWithIdToken()`.

Risk:

If native Apple fails and falls back to OAuth redirect, it will hit the broken web Apple `invalid_client` path.

## 4. Supabase Backend / Tables

Status: **PARTIAL PASS**

Project: `ifxzbwaxrloeuztavcef` / `NOFEL FLEX`

Core counts:

| Entity | Count |
|---|---:|
| auth.users | 5 |
| profiles | 5 |
| auth users without profile | 0 |
| books | 0 |
| published books | 0 |
| chapters | 0 |
| published chapters | 0 |
| active categories | 10 |
| writer_profiles | 0 |
| favorites | 0 |
| ratings | 0 |
| reading_progress | 0 |

Good:

- Auth/profile sync is currently healthy.
- `profiles`, `books`, `chapters`, `favorites`, `ratings`, `reading_progress`, `reports`, and storage all have RLS enabled.
- Triggers exist for:
  - creating profile after auth user creation
  - syncing book chapter counts
  - incrementing views from book/chapter events
- Storage buckets exist:
  - `book-covers`
  - `chapter-covers`
  - `author-images`
  - `chapter-files`

Blocker:

There is no live content in `books`, `chapters`, or `writer_profiles`. Real reader/author QA cannot pass until at least one author, one book, and one published chapter exist.

## 5. Supabase Security

Status: **NEEDS FIX BEFORE PUBLIC LAUNCH**

Security advisor findings:

- `public.is_admin()` is `SECURITY DEFINER` and executable by `anon` and `authenticated`.
- `public.set_updated_at()` has mutable `search_path`.
- `citext` extension is installed in `public`.
- Leaked password protection is disabled.
- MFA options are insufficient.

Highest-priority backend fix:

Revoke direct public execution of `public.is_admin()` while preserving its use inside RLS policies.

## 6. Legal / Privacy / Account Deletion

Status: **FAIL**

Evidence:

- App links privacy and terms to:
  - `https://www.novelflex.com/privacy-policy`
  - `https://www.novelflex.com/terms`
- `www.novelflex.com` currently fails SSL verification because the certificate is expired.
- Live `novelflex.online` paths return `404`:
  - `https://novelflex.online/privacy-policy`
  - `https://novelflex.online/terms`
- Account deletion button exists, but calls legacy endpoint:
  - `https://apptocom.com/novelflex2/api/v1/author/delete/account`
- No evidence that deletion removes:
  - Supabase Auth user
  - profile row
  - favorites
  - reading history/progress
  - reviews/ratings
  - uploaded content or anonymized author content

Conclusion:

Privacy/legal/account deletion is an App Store rejection risk.

## 7. Store Rejection Risks

High risk:

- Missing valid privacy policy and terms URLs.
- Account deletion not proven for full Supabase account/data deletion.
- Apple web sign-in invalid client.
- Facebook provider remains enabled in Supabase with bad client ID.
- Payment/subscription/wallet/ad code references remain in the app while monetization is not launch scope.
- App-level `PrivacyInfo.xcprivacy` is missing.
- iOS associated domains still point to `applinks:www.novelflex.com` instead of the live domain.

Medium risk:

- Android uses broad legacy storage permissions.
- iOS background modes include fetch, processing, and remote notification; each needs product justification.
- UGC moderation exists partially through report email/admin reports, but block/filter/full moderation workflow is not fully proven.

## Required Next Actions

### Immediate Build Recovery

1. Free system disk space on the Mac before any iOS archive/upload.
2. Remove AppleDouble `._*` files from project/build artifacts.
3. Re-run:
   - `flutter analyze`
   - `flutter build appbundle --release`
   - `flutter build ios --release --no-codesign`

### Auth Fixes

1. Fix Apple Developer Services ID:
   - `com.artstyle.novelflex.web`
   - Return URL: `https://ifxzbwaxrloeuztavcef.supabase.co/auth/v1/callback`
2. Disable or fix Facebook provider in Supabase.
3. Verify native Apple and Google login on physical devices.

### Backend / Privacy Fixes

1. Create production-safe account deletion backend.
2. Publish working privacy and terms pages on `novelflex.online`.
3. Change app legal links from `www.novelflex.com` to `novelflex.online`.
4. Add app-level iOS `PrivacyInfo.xcprivacy`.
5. Seed or create one real approved writer, book, and published chapter for QA.

## Final Decision

**NOT READY FOR RELEASE**

The project can move forward, but upload and review should stop until the build blockers, Apple Service ID, legal URLs, and account deletion are fixed.
