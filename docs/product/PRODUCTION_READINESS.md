# NOVELFLEX Production Readiness Report

Date: 2026-06-13  
Scope: Environment variables, Supabase configuration, storage, security, SEO, performance, and launch blockers.  
Decision: **NOT READY FOR PRODUCTION LAUNCH**

> Update 2026-06-15: Supabase naming has been standardized in
> `SUPABASE_CANONICAL_CONTRACT_20260615.md`. The canonical tables are
> `writer_profiles`, `chapters`, `ratings`, and `reading_progress`; older
> mentions of missing `authors`, `pdf_files`, `reviews`, or `reading_history`
> in this historical report should be read as superseded.

## Executive Summary

NOVELFLEX is not production-ready. The frontend shell and mobile configuration are progressing, and the canonical app identifier appears aligned as `com.artstyle.novelflex`, but production launch is blocked by missing Supabase tables, missing storage buckets, incomplete data, permission gaps, weak production observability, and SEO/performance inconsistencies between the current web MVP and the older web shell.

No code or backend configuration was changed by this report.

## Readiness Matrix

| Area | Status | Decision |
|---|---|---|
| Environment variables | PARTIAL | Required values exist locally, but web config is hardcoded and release secret management is not proven |
| Supabase configuration | FAIL | Required tables are missing or unavailable in production schema cache |
| Storage buckets | FAIL | Storage bucket API returned an empty bucket list |
| Security | FAIL | Keys exist inside project folders; author/admin permission gaps remain |
| SEO | PARTIAL | `web/novelflex` has SEO assets; current `web/frontend-ui` is still marked mock and lacks production metadata |
| Performance | PARTIAL/FAIL | Static app is simple, but large assets and no route splitting/minification strategy |
| QA | FAIL | Full QA report marks Reader/Author/Admin journeys not ready |
| Launch verdict | FAIL | Do not launch |

## Environment Variables

### Found

Local `.env` includes:

```text
NEXT_PUBLIC_SUPABASE_URL
NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY
SUPABASE_URL
SUPABASE_ANON_KEY
AUTH_REDIRECT_URL=com.artstyle.novelflex://auth-callback
GOOGLE_IOS_CLIENT_ID
GOOGLE_ANDROID_PACKAGE_NAME=com.artstyle.novelflex
APPLE_BUNDLE_ID=com.artstyle.novelflex
LEGACY_API_BASE_URL
```

Flutter reads Supabase values from Dart defines in:

```text
lib/core/config/supabase_config.dart
```

Web auth config is currently hardcoded in:

```text
web/novelflex/auth.js
```

### Status

**PARTIAL**

### Issues

1. Production web values are hardcoded instead of injected through deployment configuration.
2. `.env` contains production-looking values in the local project. That is acceptable only if `.env` is excluded from source control and deployment uses secret storage.
3. `LEGACY_API_BASE_URL` is still present, confirming legacy backend dependency remains possible.
4. `web/frontend-ui/index.html` still describes the app as mock/no-backend even though the current MVP now calls Supabase.

## Supabase Configuration

### Live Table Check

| Table | Live result | Launch impact |
|---|---|---|
| `profiles` | PASS | Basic user/admin profile data available |
| `categories` | PASS | Category browsing can be seeded |
| `books` | PARTIAL, returns `[]` | No public readable novels for launch |
| `authors` | FAIL, `PGRST205` table missing | Author portal/admin author management blocked |
| `pdf_files` | FAIL, `PGRST205` table missing | Chapter reader and chapter manager blocked |
| `favorites` | PASS empty | Library base table exists |
| `reviews` | FAIL, `PGRST205` table missing | Reviews/ratings blocked |
| `book_reactions` | FAIL, `PGRST205` table missing | Like/dislike blocked |
| `follows` | PASS empty | Follow base table exists |
| `reading_history` | FAIL, `PGRST205`; hint suggests `reading_sessions` | Continue reading/history blocked |
| `notifications` | PASS empty | Notification foundation exists |
| `reports` | PASS empty | Admin reports base table exists |

### Status

**FAIL**

### Blockers

1. Required production tables are missing or not exposed: `authors`, `pdf_files`, `reviews`, `book_reactions`, `reading_history`.
2. `books` is reachable but returns no public rows, so Home/Browse/Search/Novel pages cannot demonstrate real production content.
3. Current code and docs still have naming conflicts: `pdf_files` vs `chapters`, `reviews` vs `ratings`, `reading_history` vs `reading_sessions/reading_progress`.
4. Local SQL files define RLS for tables that do not match the live schema currently exposed through PostgREST.

## Storage Buckets

### Expected Buckets

Local SQL and service code expect:

```text
book-covers
author-images
pdf-files
```

### Live Result

Supabase Storage bucket API returned:

```text
[]
```

### Status

**FAIL**

### Blockers

1. No production storage buckets are visible with the configured publishable key.
2. Chapter PDF upload/reading cannot work without `pdf-files`.
3. Book covers and author images cannot be production-ready without bucket setup and policies.
4. Storage policies in `storage_setup.sql`/`supabase_storage_buckets.sql` appear local/planned, not verified live production truth.

## Security

### Status

**FAIL**

### Findings

1. Sensitive credential material exists inside the project workspace:

```text
Google OAuth client secret JSON files under key/google sign in keys/
Apple Sign in with Apple private key files under key/apple signe in/
```

These must not live in the application repository or deploy artifact.

2. `web/frontend-ui` has a known permission defect from QA:

```text
/author/analytics
/author/academy
```

These render for unauthenticated/guest users.

3. Author create/publish mutation checks signed-in user but does not enforce `author` or `admin` role before mutation.

4. Account deletion readiness is not confirmed as a secure Supabase Edge Function. Client-side deletion of Auth users is not acceptable for production.

5. Legacy REST API dependency remains in the mobile app and is documented separately in `LEGACY_API_MIGRATION_REPORT.md`.

6. No production error tracking provider is configured. This is both an operational and security issue because failures cannot be triaged after launch.

## SEO

### `web/novelflex`

Status: **PARTIAL PASS**

Found:

- Arabic `lang="ar"` and `dir="rtl"`.
- Canonical URL.
- Meta description.
- Open Graph metadata.
- Twitter card metadata.
- JSON-LD WebSite schema.
- `robots.txt`.
- `sitemap.xml`.

### `web/frontend-ui`

Status: **FAIL for production SEO**

Findings:

- Title is `NOVELFLEX Web MVP Mock`.
- Description says mock data and no backend.
- No Open Graph metadata.
- No Twitter metadata.
- No canonical link.
- No JSON-LD.
- Relies on `../novelflex/auth.js` and vendor file, which creates coupling to the older web shell.

### SEO Blocker

The canonical production web target must be decided. If `web/frontend-ui` is the launch target, it needs production SEO before launch. If `web/novelflex` is the launch target, it still contains older data-model references and must be reconciled with the MVP.

## Performance

### Static Asset Sizes

Largest inspected assets:

```text
14.8 MB  web/novelflex/assets/bg_author.jpg
2.6 MB   web/novelflex/assets/book.gif
649 KB   web/novelflex/assets/manga_books.jpg
310 KB   web/novelflex/assets/home_screen.jpg
203 KB   web/novelflex/vendor/supabase.js
124 KB   web/novelflex/app.js
122 KB   web/frontend-ui/app.js
```

### Status

**PARTIAL/FAIL**

### Issues

1. `bg_author.jpg` is too large for production web.
2. `book.gif` is too large and should not be a core launch asset unless optimized/replaced.
3. No route splitting exists; each app loads one large `app.js`.
4. `web/frontend-ui` imports a vendored Supabase bundle from `web/novelflex/vendor/supabase.js`.
5. No production build/minification pipeline is present for the static web MVP.
6. No confirmed query caching policy beyond in-memory state.

## QA Status

Source report:

```text
docs/product/QA_REPORT.md
```

Summary:

| Flow | Status |
|---|---|
| Reader flows | FAIL |
| Author flows | FAIL |
| Admin flows | PARTIAL FAIL |
| Navigation | PASS structural / FAIL full journey |
| Permissions | FAIL |
| Empty states | PASS |
| Error states | PASS |
| Mobile | PARTIAL PASS |
| Desktop | PARTIAL PASS |

Additional tooling results from QA:

- `flutter analyze`: FAIL; 112 warning/info issues remain, with no direct compile errors found.
- `flutter test --no-test-assets`: PASS; 4 unit tests passed in about 5 seconds.
- Web syntax checks: PASS.

## Launch Blockers

1. Missing production Supabase tables: `authors`, `pdf_files`, `reviews`, `book_reactions`, `reading_history`.
2. `books` returns no public launch content.
3. Storage buckets are not visible or not configured: `book-covers`, `author-images`, `pdf-files`.
4. Reader journey cannot complete from Home to Chapter to Library/History.
5. Author journey cannot complete Create Novel -> Add Chapter -> Publish -> Analytics.
6. Admin journey cannot manage authors/reviews fully because required tables are missing.
7. `/author/analytics` and `/author/academy` bypass auth/author gate.
8. Author create/publish does not enforce author role.
9. Secrets/credential files exist inside project workspace under `key/`.
10. Production error tracking is not configured.
11. Production analytics/consent/privacy posture is not configured.
12. Web launch target is unresolved: `web/frontend-ui` is current MVP but has mock SEO; `web/novelflex` has SEO but older data references.
13. Large unoptimized assets exceed reasonable production web launch size.
14. Authenticated Reader/Author/Admin smoke tests still need to be run against production Supabase.
15. Legacy REST API dependency remains in the mobile app.

## Required Tasks Before Launch

### Backend

1. Apply or reconcile production schema for required MVP entities.
2. Confirm RLS policies live in production and match actual access rules.
3. Seed/publish at least one real Arabic novel with author, category, and chapter data.
4. Decide final chapter table strategy: keep `pdf_files` or update code to the existing `chapters` table.
5. Decide final reading history table strategy: `reading_history` vs `reading_sessions`.
6. Configure account deletion backend as a secure Edge Function.

### Storage

1. Create and verify `book-covers`, `author-images`, and `pdf-files` buckets.
2. Apply storage policies.
3. Upload sample cover/avatar/chapter PDF and verify read/write rules by role.
4. Ensure private chapter content cannot leak through public URLs.

### Security

1. Remove credential files from project workspace and rotate them if they were ever committed or shared.
2. Move Apple/Google secret material to secure secret storage.
3. Gate all author pages with `AuthorAccessGate`.
4. Enforce author/admin role before author mutations.
5. Keep service-role keys out of mobile/web clients.
6. Add production error tracking with PII/token scrubbing.

### SEO

1. Select canonical web launch target.
2. Add production metadata to the selected target.
3. Ensure `robots.txt` and `sitemap.xml` are deployed at domain root.
4. Generate sitemap from real published novels, not mock/example IDs.
5. Ensure novel detail pages have indexable metadata and Open Graph images.

### Performance

1. Optimize or replace `bg_author.jpg` and `book.gif`.
2. Add minification/build pipeline or migrate web MVP to a proper bundled app.
3. Split routes or lazy-load admin/author sections.
4. Cache Supabase queries intentionally.
5. Run Lighthouse/mobile performance checks after deployment preview.

### QA

1. Use `tool/test.sh` for the stable local Flutter test run, and investigate the upstream Flutter native-assets crash separately.
2. Run real browser QA on mobile and desktop viewports.
3. Run authenticated Reader/Author/Admin smoke tests against production Supabase.
4. Verify OAuth and password recovery redirect URLs.
5. Verify storage upload/download on production roles.

## Final Verdict

**NOT READY FOR PRODUCTION LAUNCH**

NOVELFLEX should not be launched until Supabase schema/storage are corrected, security issues are closed, SEO target is finalized, and full Reader/Author/Admin QA passes end-to-end.
