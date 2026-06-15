# NOVELFLEX Full QA Audit Report

Date: 2026-06-13  
Scope: NOVELFLEX Web MVP in `web/frontend-ui/`, with supporting Flutter project health checks.

> Update 2026-06-15: Supabase naming has been standardized in
> `SUPABASE_CANONICAL_CONTRACT_20260615.md`, and launch seed content has been
> added in `LAUNCH_CONTENT_SEED_20260615.md`. Older references to missing
> `authors`, `pdf_files`, `reviews`, or `reading_history` are superseded by
> `writer_profiles`, `chapters`, `ratings`, and `reading_progress`.

## Final QA Verdict

Status: **FAIL - NOT QA READY**

The UI routes render without JavaScript syntax errors, and the app has good empty/error state coverage. However, full Reader, Author, and Admin journeys cannot pass end-to-end because required Supabase data/tables are missing or unavailable, and two author routes bypass the author access gate.

## Test Environment

| Item | Result |
|---|---|
| Local web URL | `http://127.0.0.1:4173/frontend-ui/` |
| Static server | PASS, returned `200` for `/frontend-ui/`, `app.js`, and `styles.css` |
| Browser automation | BLOCKED, Codex in-app browser was unavailable in this session |
| Web syntax check | PASS, `node --check web/frontend-ui/app.js` |
| Auth script syntax check | PASS, `node --check web/novelflex/auth.js` |
| Flutter analyze | FAIL, 112 warning/info issues and no direct compile errors |
| Flutter test | PASS, `flutter test --no-test-assets` completed 4 tests in about 5 seconds |

## Automated Route Rendering

I executed a lightweight DOM simulation against `web/frontend-ui/app.js` and rendered the route table in three states:

- unauthenticated visitor
- guest mode
- admin mock session

Result: **PASS**

All tested routes rendered HTML without throwing runtime exceptions:

```text
/
/browse
/genre/fantasy
/search?q=مدينة
/novels/1
/novels/1/chapters/1
/library
/library/history
/profile
/auth/login
/auth/register
/auth/callback
/author
/author/novels
/author/drafts
/author/published
/author/novels/new
/author/novels/1/edit
/author/novels/1/chapters
/author/novels/1/chapters/new
/author/novels/1/chapters/1/edit
/author/analytics
/author/academy
/admin
/admin/users
/admin/authors
/admin/novels
/admin/reviews
/admin/reports
/admin/categories
/missing
```

This means the router is structurally stable, but it does not mean every journey passes functionally.

## Supabase Live Data Check

| Table | Result | Impact |
|---|---|---|
| `profiles` | PASS, returns rows | Admin/user profile basics can load |
| `categories` | PASS, returns rows | Browse category shell can work |
| `books` | PARTIAL, table returns `200` but anon query returns `[]` | Reader catalog has no live novels |
| `authors` | FAIL, `PGRST205` table not found | Author profile/admin author management blocked |
| `pdf_files` | FAIL, `PGRST205` table not found | Chapter list, reader page, author chapter manager blocked |
| `favorites` | PASS, returns empty list | Library table exists |
| `reviews` | FAIL, `PGRST205` table not found | Reviews/ratings blocked |
| `book_reactions` | FAIL, `PGRST205` table not found | Like/dislike blocked |
| `follows` | PASS, returns empty list | Follow table exists |
| `reading_history` | FAIL, `PGRST205`; hint suggests `reading_sessions` | Continue reading/history blocked |
| `notifications` | PASS, returns empty list | Notification foundation table exists |
| `reports` | PASS, returns empty list | Admin reports queue table exists |

## Reader Flow QA

Target flow:

```text
Home -> Browse -> Genre -> Search -> Novel Details -> Chapter Reader -> Library -> Reading History -> Profile
```

Status: **FAIL**

| Area | Status | Notes |
|---|---|---|
| Navigation | PASS | Routes render without crashing |
| Home | FAIL | `books` returns no published data for anon; home falls to empty/error state |
| Browse | FAIL | Category route renders, but book grid is empty because `books` returns `[]` |
| Genre | PARTIAL | Route works, but no novels can be listed |
| Search | PARTIAL | UI renders; meaningful results require `books` data |
| Novel Details | FAIL | `/novels/1` shows “الرواية غير موجودة” with current live data |
| Chapter Reader | FAIL | `pdf_files` table is missing; fallback `chapters` route exists in code but current service layer target is `pdf_files` |
| Library | PASS gate, FAIL data | Requires auth and `favorites`; gate works, but no end-to-end saved novel can be verified because books/chapters are unavailable |
| Reading History | FAIL | `reading_history` table missing |
| Empty states | PASS | Empty states are present and Arabic |
| Error states | PASS | Missing Supabase/client/table errors are surfaced |
| Guest behavior | PASS gate | Guest can browse shell/profile but cannot access library/history |

Reader QA result: **FAIL due backend/data blockers**

## Author Flow QA

Target flow:

```text
Login -> Dashboard -> My Novels -> Create Novel -> Edit Novel -> Chapter Manager -> Add Chapter -> Publish -> Analytics -> Academy
```

Status: **FAIL**

| Area | Status | Notes |
|---|---|---|
| Auth gate for dashboard/novels/forms | PASS | `AuthorAccessGate()` blocks unauthenticated users for most author routes |
| Author role permission | FAIL | Any authenticated user can enter author portal; no explicit `role === author/admin` gate before create/publish |
| Dashboard | FAIL live | Depends on `authors` and `books`; `authors` missing and `books` empty |
| My Novels | FAIL live | No owned books can be verified |
| Create Novel | PARTIAL | Form renders behind auth gate, but save only checks signed-in user, not author role |
| Edit Novel | PARTIAL | Ownership check exists through `author_id`, but no live authored books to test |
| Chapter Manager | FAIL | `pdf_files` table missing |
| Add/Edit/Delete/Reorder Chapter | FAIL | All require `pdf_files` |
| Publish | PARTIAL | Status can be set to `published` in payload, but end-to-end save was not verified due live data/schema blockers |
| Analytics | FAIL permission | `/author/analytics` renders to unauthenticated/guest users |
| Academy | FAIL permission | `/author/academy` renders to unauthenticated/guest users |
| Empty states | PASS | Missing novels/chapters states are present |
| Error states | PASS | Author portal errors and table issues are surfaced |

Code references:

- `AuthorAccessGate()` exists at `web/frontend-ui/app.js:2331`.
- Router applies no gate to analytics/academy at `web/frontend-ui/app.js:2806` and `web/frontend-ui/app.js:2807`.
- `renderAnalytics()` and `renderAcademy()` render directly at `web/frontend-ui/app.js:2516` and `web/frontend-ui/app.js:2531`.
- `saveAuthorNovel()` checks only `appState.auth.user`, not author role, at `web/frontend-ui/app.js:1629`.

Author QA result: **FAIL due permission and schema blockers**

## Admin Flow QA

Target flow:

```text
Login -> Admin Dashboard -> Users -> Authors -> Novels -> Reviews -> Reports -> Categories -> Actions
```

Status: **PARTIAL FAIL**

| Area | Status | Notes |
|---|---|---|
| Admin login gate | PASS | Unauthenticated users see admin login empty state |
| Admin role gate | PASS | `loadAdminPortal()` checks `profiles.role === "admin"` |
| Dashboard route | PASS render | Admin mock renders dashboard |
| Users | PASS structure | Depends on `profiles`, which exists |
| Authors | FAIL | `authors` table missing |
| Novels | PARTIAL | `books` exists but returns no data |
| Reviews | FAIL | `reviews` table missing |
| Reports | PASS structure | `reports` exists, currently empty |
| Categories | PASS structure | `categories` exists |
| Admin actions | PARTIAL | Buttons/forms are wired, but live mutation verification requires an admin session |
| Empty states | PASS | Empty states exist for each admin page |
| Error states | PASS | Table-specific errors are recorded and displayed |

Additional issue:

- `AdminLayout()` calls `PageShell("/author", ...)` at `web/frontend-ui/app.js:2576`, so top-level active nav can incorrectly mark the author area while viewing admin pages.

Admin QA result: **PARTIAL FAIL due missing tables and one navigation-state issue**

## Permissions QA

| Permission case | Status | Notes |
|---|---|---|
| Guest cannot open library | PASS |
| Guest cannot open reading history | PASS |
| Guest cannot open author dashboard/forms | PASS |
| Guest can open author analytics | FAIL |
| Guest can open author academy | FAIL |
| Non-admin cannot open admin after profile load | PASS by design, requires live profile load |
| Any signed-in reader can access author create flow | FAIL |
| Author ownership check for edit/chapter management | PARTIAL | Code filters by current user/owned book, but no live authored data verified |

## Empty State QA

Status: **PASS**

Empty states exist for:

- no published books
- no categories
- no search results
- novel not found
- no chapters
- no reviews
- unauthenticated library/history
- no saved books
- no reading history
- no author novels
- no admin users/authors/books/reviews/reports/categories
- route not found

The Arabic copy is clear and actionable enough for MVP.

## Error State QA

Status: **PASS with backend blockers**

The UI surfaces:

- Supabase client unavailable
- missing reader data
- missing chapter data
- missing author portal data
- missing table-specific admin errors
- review/reaction/follow errors
- reading history errors

Current live backend produces real blocking errors for `authors`, `pdf_files`, `reviews`, `book_reactions`, and `reading_history`.

## Mobile QA

Status: **PARTIAL PASS**

Verified from source:

- `index.html` has `dir="rtl"` and viewport meta.
- CSS has mobile-first defaults.
- Breakpoints exist at `720px` and `980px`.
- Main layouts switch from single-column/mobile to multi-column desktop.
- Bottom/mobile navigation exists and is hidden at desktop breakpoint.

Not verified:

- No visual screenshot pass was possible because browser automation was unavailable in this session.
- No tap-target/overflow screenshot inspection was performed.

Mobile QA result: **PARTIAL PASS, visual verification still required**

## Desktop QA

Status: **PARTIAL PASS**

Verified from source:

- Desktop breakpoint exists at `980px`.
- Navbar expands on wider screens.
- Browse, hero, novel details, workspace, admin rows, and forms gain multi-column layouts.

Not verified:

- No visual screenshot pass was possible.
- No real browser layout measurement was performed.

Desktop QA result: **PARTIAL PASS, visual verification still required**

## Tooling QA

| Check | Status | Result |
|---|---|---|
| `curl -I http://127.0.0.1:4173/frontend-ui/` | PASS | `200 OK` |
| `node --check web/frontend-ui/app.js` | PASS | No syntax errors |
| `node --check web/novelflex/auth.js` | PASS | No syntax errors |
| Static route render simulation | PASS | All tested routes rendered |
| Supabase REST smoke test | FAIL | Multiple missing tables |
| `flutter analyze` | FAIL | 112 warning/info issues; no direct compile errors found |
| `flutter test --no-test-assets` | PASS | 4 unit tests passed |

## Launch Blockers Found

1. `books` returns no public/published rows, blocking Home/Browse/Search/Novel Details.
2. `pdf_files` missing from Supabase schema cache, blocking Chapter Reader and Chapter Manager.
3. `authors` missing from Supabase schema cache, blocking author/admin author flows.
4. `reviews` missing from Supabase schema cache, blocking reviews/ratings.
5. `book_reactions` missing from Supabase schema cache, blocking like/dislike.
6. `reading_history` missing from Supabase schema cache, blocking Continue Reading and History.
7. `/author/analytics` and `/author/academy` bypass `AuthorAccessGate`.
8. Author create/publish flow does not enforce author role before mutation.
9. `AdminLayout()` passes `/author` as active shell route, causing admin navigation state mismatch.
10. Supabase/backend end-to-end smoke tests still need authenticated Reader/Author/Admin users.

## Required Fixes Before QA Pass

1. Confirm final Supabase schema and expose required tables through the Data API.
2. Seed or publish at least one readable Arabic book with category and author relationship.
3. Make `pdf_files` available or update the web service layer to the final chapter table name.
4. Make `reviews`, `book_reactions`, and `reading_history` match the implemented service layer.
5. Gate `/author/analytics` and `/author/academy` with `AuthorAccessGate`.
6. Enforce `author` or `admin` role before author create/edit/publish mutations.
7. Change `AdminLayout()` shell active route from `/author` to `/admin`.
8. Keep `tool/test.sh` as the stable local test entrypoint until the Flutter native-assets crash on this external volume is gone.
9. Run visual QA with desktop and mobile screenshots after the above fixes.

## Final Result By Flow

| Flow | Status |
|---|---|
| Reader flows | **FAIL** |
| Author flows | **FAIL** |
| Admin flows | **PARTIAL FAIL** |
| Navigation | **PASS structural / FAIL full journey** |
| Permissions | **FAIL** |
| Empty states | **PASS** |
| Error states | **PASS** |
| Mobile | **PARTIAL PASS** |
| Desktop | **PARTIAL PASS** |

Final QA decision: **NOT READY**

No application code was modified by this QA audit.
