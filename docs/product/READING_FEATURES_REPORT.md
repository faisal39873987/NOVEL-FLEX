# NOVELFLEX Reading Features Report

Date: 2026-06-13

## Scope

This phase connects reader library and progress features through Supabase.

Tables used:

- `favorites`
- `reading_history`

Implemented:

- Add to Library
- Remove from Library
- Continue Reading
- Reading Progress
- Reading History

Explicitly not implemented:

- Payments
- Premium chapter locking
- Legacy REST APIs
- Reviews
- Ratings
- Follows
- Storage uploads
- Schema changes

## Files Changed

- `web/frontend-ui/app.js`
  - Added reading feature state.
  - Added Supabase service functions for `favorites`.
  - Added Supabase service functions for `reading_history`.
  - Connected Add/Remove Library buttons.
  - Connected Library page to `favorites`.
  - Connected Reading History page to `reading_history`.
  - Added automatic progress save when a signed-in reader opens a chapter.
  - Added Continue Reading links from history/favorites.

- `docs/product/READING_FEATURES_REPORT.md`
  - Documents implementation, verification, and blockers.

## Routes And Features

| Feature | Route/UI | Status |
| --- | --- | --- |
| Add to Library | Novel Details / Reader toolbar | PASS structurally |
| Remove from Library | Same library button | PASS structurally |
| Library | `#/library` | PASS structurally |
| Continue Reading | Library and History cards | PASS structurally |
| Reading Progress | Chapter Reader | PASS structurally |
| Reading History | `#/library/history` | PASS structurally |

## Data Flow

### Favorites

Load:

```text
favorites
where user_id = auth.user.id
```

Insert:

```text
favorites.insert({ user_id, book_id })
```

Delete:

```text
favorites.delete()
where user_id = auth.user.id
and book_id = :bookId
```

### Reading History

Load:

```text
reading_history
where user_id = auth.user.id
order by last_read_at desc
```

Save progress:

```text
reading_history
```

Payload:

- `user_id`
- `book_id`
- `chapter_id`
- `progress_percent`
- `last_position`
- `last_read_at`

Update behavior:

- Select existing row by `user_id`, `book_id`, and `chapter_id`.
- Update existing row if found.
- Insert new row if not found.

## Auth Behavior

Signed-in user:

- Can add/remove favorites.
- Can load Library.
- Can load Reading History.
- Can save reading progress when opening a chapter.

Guest/visitor:

- Library route asks the user to sign in.
- Reading History route asks the user to sign in.
- Add to Library redirects to Login.

## Live Supabase Verification

REST checks were run against:

```text
https://ifxzbwaxrloeuztavcef.supabase.co/rest/v1
```

Results:

| Table | Status | Observed result |
| --- | --- | --- |
| `favorites` | PASS/PARTIAL | Table exists and returns `[]` for anon/public check. |
| `reading_history` | FAIL | Missing from schema cache: `PGRST205`. |

Exact `reading_history` issue:

```text
PGRST205: Could not find the table 'public.reading_history' in the schema cache
```

Supabase hint:

```text
Perhaps you meant the table 'public.reading_sessions'
```

No fallback to `reading_sessions` was implemented because this phase explicitly requested `reading_history`.

## Required RLS Behavior

For launch, Supabase must allow:

### `favorites`

- User can select own favorites.
- User can insert only own favorites.
- User can delete only own favorites.
- Duplicate `(user_id, book_id)` should be prevented by a unique index or handled by upsert policy later.

### `reading_history`

- User can select own history.
- User can insert own progress.
- User can update own progress.
- User cannot read or write another user's progress.

Expected ownership:

```text
favorites.user_id = auth.uid()
reading_history.user_id = auth.uid()
```

## Verification

Checks run:

- `node --check web/frontend-ui/app.js`: PASS
- Logged-out reading route harness: PASS
- Logged-in mocked route harness for `favorites` and `reading_history`: PASS
- Live Supabase REST check:
  - `favorites`: table available
  - `reading_history`: table missing

## Blockers

### 1. `reading_history` table is missing

Impact:

- Reading History page displays the table error.
- Reading Progress save cannot succeed in production until the table exists and is exposed.

### 2. Real signed-in RLS not verified

Impact:

- `favorites` exists, but add/remove still requires confirmation with a real authenticated session and RLS policies.

### 3. Reader content dependency

Impact:

- Continue Reading requires visible books and chapters.
- Current earlier checks showed public `books` and chapter sources are empty/missing, so live end-to-end reading may still have no content to resume.

## Current Decision

Reading features are implemented structurally through Supabase only.

Production usage is blocked until:

- `reading_history` exists or the product contract is changed to the existing table.
- RLS for `favorites` and `reading_history` is verified with a real signed-in user.
- Published books and chapters are available for readers.
