# NOVELFLEX Author Portal Integration Report

Date: 2026-06-13

## Scope

This phase connects the Author Portal to Supabase only.

Implemented pages:

- Author Dashboard
- My Novels
- Create Novel
- Edit Novel
- Drafts
- Published Novels

Supabase tables used:

- `profiles`
- `categories`
- `books`
- `authors` availability check

Explicitly not connected:

- Payments
- Wallets
- Subscriptions
- Legacy REST APIs
- Chapters backend
- Reviews backend
- Analytics backend
- Admin moderation writes

## Files Changed

- `web/frontend-ui/app.js`
  - Added Author Portal state.
  - Added Supabase-only author loading service.
  - Added `profiles`, `authors`, `categories`, and owned `books` queries.
  - Added Create/Edit book mutations against `books`.
  - Added Drafts and Published Novels routes.
  - Replaced mock Author Dashboard, My Novels, and Novel Form content with Supabase-backed states.

- `docs/product/AUTHOR_PORTAL_REPORT.md`
  - Documents implementation status, verification, and launch blockers.

## Routes

| Route | Status | Data source |
| --- | --- | --- |
| `#/author` | PASS structurally | `profiles`, `authors` check, `categories`, `books` |
| `#/author/novels` | PASS structurally | Owned `books` |
| `#/author/drafts` | PASS structurally | Owned `books` filtered by `draft`, `in_review`, `rejected` |
| `#/author/published` | PASS structurally | Owned `books` filtered by `published` |
| `#/author/novels/new` | PASS structurally | Insert into `books` |
| `#/author/novels/:id/edit` | PASS structurally | Update owned row in `books` |

## Data Flow

### Author Session

Author Portal requires:

- Active Supabase Auth user.
- Guest mode is not accepted for author actions.

### Profile

Loaded from:

```text
profiles.id = auth.user.id
```

Fields used:

- `id`
- `role`
- `display_name`
- `username`
- `avatar_url`
- `bio`
- `is_public`

### Author Table Check

The implementation checks `authors` because this phase requested it.

Current live result:

```text
PGRST205: Could not find the table 'public.authors' in the schema cache
```

Because `authors` is not currently available, the portal falls back to ownership through:

```text
books.author_id = auth.user.id
```

This matches the current project direction where `books.author_id` points to `profiles.id`.

### Categories

Loaded from:

```text
categories
```

Filter:

```text
is_active = true
```

Used for:

- Create Novel category select
- Edit Novel category select

### Books

Loaded from:

```text
books.author_id in [auth.user.id, authors.id/user_id/profile_id if authors exists]
```

Used for:

- Author Dashboard metrics
- My Novels
- Drafts
- Published Novels
- Edit Novel

### Create Novel

Inserts into `books`:

- `author_id`
- `category_id`
- `title_ar`
- `description_ar`
- `status`
- `language`
- `created_at`
- `updated_at`

Status behavior:

- Save as draft: `status = draft`
- Publish: `status = published`

### Edit Novel

Updates `books` with owner guard:

```text
id = bookId
author_id = auth.user.id
```

Fields updated:

- `title_ar`
- `description_ar`
- `category_id`
- `status`
- `language`
- `updated_at`

## Live Supabase Verification

REST checks against anon/public access:

| Table | Status | Observed result |
| --- | --- | --- |
| `authors` | FAIL | Missing from schema cache: `PGRST205`. |
| `books` | PARTIAL | Query succeeds but returns `[]` for anon/public visibility. |
| `profiles` | PASS | Public profile rows returned. |
| `categories` | PASS | Active categories returned. |

Important:

- Create/Edit writes require a real signed-in Supabase session and valid RLS policies.
- This automated pass did not use a real production author login.

## Verification

Checks run:

- `node --check web/frontend-ui/app.js`: PASS
- Logged-out route harness for Author routes: PASS
- Logged-in mocked Author route harness: PASS
- Static scan for legacy/payment client usage in `web/frontend-ui`: PASS
- Supabase REST table checks: PASS/PARTIAL/FAIL as documented above

No project lint/build script exists in the root `package.json`; it only declares dependencies.

## Blockers

### 1. `authors` table is missing

Exact issue:

```text
PGRST205: Could not find the table 'public.authors' in the schema cache
```

Impact:

- Cannot truly connect the requested `authors` table.
- Current portal uses `profiles` plus `books.author_id` as the operational ownership path.

### 2. `books` has no visible rows for anon/public checks

Observed:

```json
[]
```

Impact:

- Public reader catalog is empty.
- Author-owned rows may still work after login if RLS allows authenticated ownership reads.

### 3. RLS for author writes is not proven

Impact:

- Create/Edit can fail in production if `authenticated` users cannot insert/update rows where `books.author_id = auth.uid()`.

Required policy behavior:

- Author can select own books.
- Author can insert books with `author_id = auth.uid()`.
- Author can update own books where `author_id = auth.uid()`.
- Author can read active `categories`.
- Author can read own `profiles` row.

## Current Decision

Author Portal integration is implemented structurally and uses Supabase only.

Launch readiness is blocked until:

- `authors` table mismatch is resolved or officially removed from the Author Portal contract.
- A real signed-in author account verifies create/edit against RLS.
- At least one owned `books` row is visible for that author session.
