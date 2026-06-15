# NOVELFLEX Architecture Cleanup Report

Date: 2026-06-13  
Scope: Audit and proposed cleanup only. No application code was changed.

## Cleanup Decision

Status: **PROPOSAL ONLY - DO NOT APPLY YET**

The project is not ready for an automatic cleanup pass because mobile, web MVP, Supabase migration work, and older prototype code are currently mixed together. Cleanup should be applied in controlled phases after each proposed change is approved and verified.

## Current Architecture Snapshot

NOVELFLEX currently contains these major code areas:

| Area | Current purpose | Cleanup status |
|---|---|---|
| `lib/` | Flutter mobile app, legacy REST screens, newer Supabase repositories/services | Needs staged refactor |
| `lib/data/` | New Supabase repository/service layer | Keep, standardize |
| `lib/core/` | New config/session/error foundation | Keep, expand carefully |
| `lib/MixScreens`, `lib/TabScreens`, `lib/UserAuthScreen` | Older screen-first Flutter structure | Keep for now, migrate gradually |
| `web/frontend-ui/` | Current NOVELFLEX web MVP | Keep as canonical web MVP |
| `web/design-system/` | Component/design preview | Keep until merged into canonical web app or Storybook-style docs |
| `web/novelflex/` | Older Supabase web prototype | Candidate archive after parity check |
| `web/web-ui`, `web/phone-ui` | Reference screenshots/assets | Keep as product reference only |
| `build/`, `ios/Pods`, `android/.gradle`, `ios/.symlinks` | Generated build/dependency output | Should not be source-controlled; safe cleanup candidates |

## High-Confidence Cleanup Candidates

These are safe to propose because they are generated artifacts, metadata clutter, or unused wrappers. They should still be applied in a separate cleanup commit.

| Proposed change | Target | Reason | Risk |
|---|---|---|---|
| Remove macOS resource fork files | All `._*` files, including `lib/._main.dart`, `web/._index.html`, many files under `ios/Pods` and `build` | These are not real source files and can confuse scans/build tooling | Low |
| Remove generated build output | `build/` | Flutter generated output; should be recreated by build commands | Low |
| Remove generated iOS dependency folders from repo if tracked | `ios/Pods`, `ios/.symlinks` | CocoaPods output should be regenerated with `pod install`/Flutter tooling | Medium if currently relied on locally |
| Remove Gradle/Kotlin caches from repo if tracked | `android/.gradle`, `android/.gradle.prev.1781349474`, `android/.kotlin` | Local build cache; not product source | Low |
| Ignore generated/cache files | `.gitignore` update if repo is restored | Prevent recurrence of cache/resource fork noise | Low |

## Duplicate Repository and Service Layer Findings

### Auth

Current files:

```text
lib/data/services/supabase_auth_service.dart
lib/data/repositories/auth_repository.dart
lib/data/services/supabase_auth_flow_service.dart
lib/core/session/session_controller.dart
lib/Provider/UserProvider.dart
```

Finding:

- `SupabaseAuthService` wraps raw Supabase Auth calls and error handling.
- `SupabaseAuthRepository` wraps `SupabaseAuthService` and owns profile upsert during registration.
- `SupabaseAuthFlowService` wraps repository calls again and synchronizes the legacy `UserProvider`.
- `SessionController` is a newer ChangeNotifier session abstraction but is currently not broadly adopted.
- `UserProvider` remains the active legacy provider for many screens.

Proposed final shape:

```text
lib/core/auth/
  auth_service.dart        // raw Supabase Auth adapter
  auth_repository.dart     // app-level auth use cases
  session_controller.dart  // single source of truth for session state
```

Proposed action before applying:

1. Keep `SupabaseAuthService` as the low-level adapter.
2. Keep `SupabaseAuthRepository` as the app-facing repository.
3. Merge `SupabaseAuthFlowService` responsibilities into a single `SessionController` or `AuthController`.
4. Gradually replace direct `UserProvider` synchronization with the controller, then retire only the duplicated provider fields.

Risk: **High** because auth navigation and mobile launch state can break if done in one pass.

### Storage

Current files:

```text
lib/data/services/supabase_storage_service.dart
lib/data/repositories/storage_repository.dart
```

Finding:

- `SupabaseStorageService` owns bucket operations, file naming, signed URLs, and upload/delete primitives.
- `SupabaseStorageRepository` combines storage upload with table updates for books/profiles.

Proposed final shape:

```text
lib/data/storage/storage_service.dart
lib/features/books/book_media_repository.dart
lib/features/profile/profile_media_repository.dart
```

Proposed action before applying:

1. Keep low-level storage operations separate.
2. Split table-specific media updates into feature repositories.
3. Avoid one generic `StorageRepository` that knows about books, authors, profiles, and PDFs at the same time.

Risk: **Medium** because upload flows still rely on legacy REST and Supabase Storage migration is incomplete.

### Supabase Integration Facade

Current file:

```text
lib/data/services/supabase_integration_service.dart
```

Finding:

- Static scan did not show active imports from production screens.
- It duplicates methods already exposed by dedicated repositories.

Proposed action:

- Mark as candidate dead code.
- Remove only after a second scan confirms no dynamic or test-only usage.

Risk: **Low to Medium**.

## Dead Code and Unused Candidates

Static scan identified these files as candidates for removal or archive review. This is not proof they are safe to delete; Flutter navigation can reference classes indirectly.

```text
lib/MixScreens/BooksScreens/BookDetailsAuthor.dart
lib/MixScreens/PayPall/paypall_services.dart
lib/MixScreens/ReplyCommentScreen.dart
lib/MixScreens/SeeAllBooksScreen.dart
lib/MixScreens/Uploadscreens/UploadDatanextScreen.dart
lib/MixScreens/disclimar_screen.dart
lib/MixScreens/final_screen.dart
lib/MixScreens/pdfViewerScreen.dart
lib/UserAuthScreen/SignUpScreens/signUpScreen_First.dart
lib/core/session/session_controller.dart
lib/data/services/supabase_integration_service.dart
lib/slider_screen.dart
```

Additional dead-code indicators:

- `lib/MixScreens/BooksScreens/BookDetailsAuthor.dart` is mostly commented legacy implementation.
- `lib/MixScreens/Pay/Pay.dart`, `lib/MixScreens/WalletDirectory/FlutterPayment.dart`, `lib/MixScreens/StripePayment/CardScanner.dart`, and `lib/MixScreens/StripePayment/scan_option_config_widget.dart` contain large commented sections or future monetization code.
- Monetization files are outside MVP scope and should be isolated behind a future feature flag or moved to archive documentation until Phase 15.

Proposed action before applying:

1. Build a route/import map.
2. Confirm no screen is reachable through named routes, manual `Navigator.push`, or platform callbacks.
3. Archive first, delete later.

Risk: **Medium**.

## Naming Standardization Findings

### Database Entity Naming

Current mixed names:

| Concept | Current names found | Final recommended name |
|---|---|---|
| Authors | `authors`, `writer_profiles` | `writer_profiles` joined through `profiles` |
| Chapters | `pdf_files`, `chapters` | `chapters` |
| Reviews/ratings | `reviews`, `ratings` | `ratings` |
| Reading progress | `reading_history`, `reading_progress`, `chapter_read_events` | `reading_progress` |
| Favorites/follows events | `favorite_events`, `follow_events` | Future audit/event tables only; not MVP |

Current code hotspots:

```text
web/frontend-ui/app.js
web/novelflex/app.js
lib/data/services/supabase_legacy_api_adapter.dart
```

Proposed action:

- Keep the canonical strategy already documented in `DATA_MODEL_ALIGNMENT.md`.
- Avoid adding new references to deprecated names: `authors`, `pdf_files`, `reviews`, or `reading_history`.
- Remove fallback references to old table names only after production Supabase schema is confirmed.

Risk: **Medium to High** because schema availability has been inconsistent in earlier audits.

### Folder and File Naming

Current issues:

- Mixed casing: `MixScreens`, `TabScreens`, `UserAuthScreen`, `Utils`, `Models`, `Provider`.
- Typos: `FogetPassword`, `SocailLinksModel`, `SeeAllModel.dar.dart`, `disclimar_screen.dart`, `PayPall`.
- Mixed screen naming: `home_screen.dart`, `Menu_screen.dart`, `SignUpScreen_Second.dart`, `signUpScreen_Author.dart`.
- Old broad folders group by widget type rather than feature.

Recommended Flutter naming standard:

```text
snake_case files
lowercase folder names
feature-first folders
```

Proposed final mobile structure:

```text
lib/
  core/
    config/
    errors/
    auth/
    routing/
    session/
  data/
    supabase/
    storage/
    repositories/
  features/
    auth/
    reader/
    author/
    library/
    social/
    notifications/
    profile/
    payments_future/
  shared/
    widgets/
    theme/
    localization/
```

Risk: **High** if renames are applied before route/import coverage is stable.

## Web Structure Cleanup

Current web folders:

```text
web/design-system/
web/frontend-ui/
web/novelflex/
web/phone-ui/
web/web-ui/
```

Proposed canonical structure:

```text
web/
  frontend-ui/        // current app
  design-system/      // preview only, temporary
docs/product/reference-ui/
```

Proposed actions:

1. Keep `web/frontend-ui/` as the canonical MVP.
2. Keep `web/design-system/` until components are fully merged or documented.
3. Move any remaining screenshot-only material from `web/phone-ui/` and `web/web-ui/` into `docs/product/reference-ui/`.
4. Archive or remove `web/novelflex/` after verifying no required behavior exists only there.

Risk: **Medium** because `web/novelflex` contains older Supabase flows that may still be useful as reference.

## Legacy API Cleanup Dependency

Architecture cleanup cannot safely remove `ApiUtils.dart` or `package:http/http.dart` yet.

Reason:

- Many mobile screens still call legacy REST directly.
- `supabase_legacy_api_adapter.dart` still has a legacy REST fallback.
- The separate `LEGACY_API_MIGRATION_REPORT.md` already marks the project as not ready to remove legacy APIs.

Proposed action:

- Treat REST removal as its own migration track.
- Do not combine REST removal with folder restructuring.

Risk: **High**.

## Proposed Cleanup Phases

### Phase 1 - Safe Project Hygiene

Apply after approval:

- Remove `._*` files.
- Remove generated build/cache folders if tracked or present in the working tree.
- Add/update ignore rules for generated folders and macOS resource forks.
- Do not touch app logic.

Verification:

- `flutter clean`
- `flutter pub get`
- `flutter analyze`
- iOS/Android debug launch if available

### Phase 2 - Web Canonicalization

Apply after approval:

- Declare `web/frontend-ui` canonical.
- Archive `web/novelflex` if no unique production features remain.
- Move screenshot/reference-only assets to `docs/product/reference-ui`.
- Keep `web/design-system` until preview components are either merged or replaced.

Verification:

- Serve `web/frontend-ui`.
- Check reader, author, admin routes.
- Confirm no Webnovel branding or legacy REST references.

### Phase 3 - Mobile Feature Folder Migration

Apply after route map:

- Move auth screens into `lib/features/auth`.
- Move reader screens into `lib/features/reader`.
- Move author upload/profile screens into `lib/features/author`.
- Move payment/wallet screens into `lib/features/payments_future` or archive.
- Move shared widgets/theme/localization into `lib/shared`.

Verification:

- Full import compile.
- Navigation smoke test.
- Auth state smoke test.

### Phase 4 - Service Layer Consolidation

Apply after Supabase schema is stable:

- Keep one low-level Supabase service per product area.
- Keep one repository/use-case layer per feature.
- Remove `SupabaseIntegrationService` if unused.
- Merge auth flow/provider duplication into a single session controller.

Verification:

- Email login/register/logout.
- Guest mode.
- UserProvider/session synchronization.
- Reader data fetch.

### Phase 5 - Legacy REST Removal

Apply only after backend parity:

- Replace all `ApiUtils` calls.
- Remove legacy fallback from `SupabaseLegacyApiAdapter`.
- Delete unused REST constants.
- Remove `http` dependency only if no remaining use exists.

Verification:

- Mobile reader flow.
- Author publish flow.
- Notifications.
- Account deletion.
- Offline/expired token launch.

## Proposed Changes Before Applying

No cleanup should be applied until these proposed changes are approved:

1. **Approve safe hygiene cleanup:** remove `._*`, generated build/cache folders, and add ignore rules.
2. **Approve canonical web target:** keep `web/frontend-ui`, archive `web/novelflex` only after parity review.
3. **Approve naming strategy:** use `writer_profiles`, `chapters`, `ratings`, and `reading_progress` as the canonical production tables.
4. **Approve mobile folder strategy:** move toward `core`, `data`, `features`, and `shared`.
5. **Approve dead-code archive process:** archive first, delete after build and navigation verification.
6. **Approve service consolidation:** merge duplicated Auth/Storage orchestration only after tests/smoke flows pass.

## Final Recommendation

Do **not** perform broad automatic cleanup now.

The correct next step is:

```text
Phase 1 only: safe project hygiene cleanup
```

Then run build/analyze and device smoke tests. After that, proceed to web canonicalization and service-layer consolidation in separate commits.

No application code was changed by this report.
