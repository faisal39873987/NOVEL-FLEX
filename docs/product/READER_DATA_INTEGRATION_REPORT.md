# NOVELFLEX Reader Data Integration Report

Date: 2026-06-13

## Scope

This phase connects reader-facing web data only through Supabase.

Connected pages:

- Home
- Browse
- Genre
- Search
- Novel Details
- Chapter Reader

Connected Supabase sources:

- `categories`
- `books`
- `profiles`
- `authors` check only
- `pdf_files` check first for reader chapters
- `chapters` fallback only when `pdf_files` is missing from the current Supabase schema

Explicitly not connected:

- Payments
- Wallets
- Subscriptions
- Legacy REST APIs
- Library mutations
- Reviews backend
- Favorites backend
- Reading history backend
- Author portal writes
- Admin portal writes

## Files Changed

- `web/frontend-ui/app.js`
  - Added reader data state and Supabase service functions.
  - Added category/book/profile normalization.
  - Added chapter normalization for `pdf_files` and current-schema fallback.
  - Connected Home, Browse, Genre, Search, Novel Details, and Chapter Reader to Supabase data.
  - Added loading, empty, and error states for reader-facing pages.

- `web/frontend-ui/styles.css`
  - Added image cover styling for Supabase `cover_url`.

- `docs/product/READER_DATA_INTEGRATION_REPORT.md`
  - Documents implementation status, live table checks, and blockers.

## Data Flow

### Catalog Load

The frontend loads public reader catalog data from:

- `categories`
  - Active categories only: `is_active = true`
  - Ordered by `sort_order`, then `name_ar`

- `books`
  - Published books only: `status = published`
  - Joined to:
    - `profiles` through `books_author_id_fkey`
    - `categories` through `books_category_id_fkey`

- `profiles`
  - Public author profile records for loaded book authors.

### Search

Search uses Supabase only:

- Table: `books`
- Filter: `status = published`
- Fields searched:
  - `title_ar`
  - `title_en`
  - `description_ar`
  - `description_en`

### Novel Details

Novel Details uses:

- Book record from loaded Supabase catalog.
- Category from joined `categories`.
- Author display from joined `profiles`.
- Chapter list loaded per book.

### Chapter Reader

The reader tries:

1. `pdf_files`
2. If `pdf_files` is missing from schema cache, fallback to `chapters`

The fallback is Supabase-only and does not use legacy APIs.

## Live Supabase Verification

REST checks were run against:

- `https://ifxzbwaxrloeuztavcef.supabase.co/rest/v1`

Results:

| Source | Status | Observed result |
| --- | --- | --- |
| `categories` | PASS | Returned active category rows including `novels`, `short-stories`, and `fantasy`. |
| `profiles` | PASS | Returned public profile rows. |
| `books` | PARTIAL | Request succeeds, but returns `[]` for the anon client. No published reader books are currently visible. |
| `authors` | FAIL | Table is not found in the public schema cache: `PGRST205`. |
| `pdf_files` | FAIL | Table is not found in the public schema cache: `PGRST205`. |
| `chapters` fallback | PARTIAL | Request succeeds, but returns `[]` for the anon client. |

## Page Status

| Page | Status | Notes |
| --- | --- | --- |
| Home | PASS with empty-state risk | Loads Supabase catalog. Shows empty state because `books` currently returns no published rows. |
| Browse | PASS with empty-state risk | Uses Supabase `categories` and `books`. Categories load; books are empty. |
| Genre | PASS with empty-state risk | Filters loaded Supabase books by category slug. |
| Search | PASS with empty-state risk | Searches Supabase `books`; current visible dataset is empty. |
| Novel Details | PASS structurally | Uses Supabase book IDs. Cannot show a real live novel until `books` returns published rows. |
| Chapter Reader | PASS structurally | Tries `pdf_files`; current schema lacks it, so it falls back to `chapters`. Current `chapters` returns empty rows. |

## Blockers Found

### 1. `authors` table is not available

Exact issue:

```text
PGRST205: Could not find the table 'public.authors' in the schema cache
```

Impact:

- The requested `authors` source cannot be connected directly.
- Current implementation uses `profiles` joined through `books.author_id` for author display.

### 2. `pdf_files` table is not available

Exact issue:

```text
PGRST205: Could not find the table 'public.pdf_files' in the schema cache
```

Impact:

- The requested chapter source cannot be connected directly.
- Current implementation falls back to Supabase `chapters` so the reader can work with the current schema.

### 3. `books` returns no visible published rows

Observed result:

```json
[]
```

Impact:

- Reader pages are connected, but they currently render empty states for live catalog content.
- This is likely caused by no published rows, RLS visibility, or Data API exposure/policy state.

### 4. `chapters` fallback returns no visible rows

Observed result:

```json
[]
```

Impact:

- Chapter Reader cannot display live chapter content until chapter rows are visible and linked to published books.

## Verification

Checks run:

- `node --check web/frontend-ui/app.js`
- Route harness across 12 routes: PASS
- Static scan for legacy/payment clients in `web/frontend-ui`: PASS
- Local HTTP check:
  - `http://127.0.0.1:4173/frontend-ui/`: 200 OK
- Live Supabase REST checks for:
  - `categories`
  - `books`
  - `profiles`
  - `authors`
  - `pdf_files`
  - `chapters`

Package note:

- Root `package.json` has dependencies only and no build/lint/test scripts for this static frontend.

## Current Decision

Reader-facing data connection is implemented, but live content readiness is blocked by Supabase data/schema state:

- `authors` missing.
- `pdf_files` missing.
- `books` visible dataset empty.
- `chapters` visible dataset empty.

The frontend now fails gracefully with loading, empty, and error states instead of using legacy APIs or payment code.
