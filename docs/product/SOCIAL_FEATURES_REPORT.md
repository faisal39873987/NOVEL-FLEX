# NOVELFLEX Social Features Report

Date: 2026-06-13

## Scope

This phase connects reader social features through Supabase only.

Tables used:

- `reviews`
- `book_reactions`
- `follows`

Implemented:

- Ratings
- Reviews
- Like/Dislike
- Follow Author

Explicitly not implemented:

- Payments
- Premium access
- Legacy REST APIs
- Schema changes
- Fallback to `ratings`
- Moderation/reporting workflow

## Files Changed

- `web/frontend-ui/app.js`
  - Added social feature state.
  - Added Supabase service functions for `reviews`.
  - Added Supabase service functions for `book_reactions`.
  - Added Supabase service functions for `follows`.
  - Added review/rating form on Novel Details.
  - Added like/dislike buttons.
  - Added follow author button.
  - Replaced mock-only review display with Supabase-backed social state.

- `docs/product/SOCIAL_FEATURES_REPORT.md`
  - Documents implementation status, verification, and blockers.

## Feature Mapping

### Ratings and Reviews

Table:

```text
reviews
```

Load:

```text
reviews
where book_id = :bookId
order by created_at desc
```

Insert:

```text
reviews.insert({
  user_id,
  book_id,
  rating,
  review
})
```

### Like / Dislike

Table:

```text
book_reactions
```

Load current user reaction:

```text
book_reactions
where user_id = auth.uid()
and book_id = :bookId
```

Behavior:

- Same reaction clicked twice removes it.
- Different reaction updates the existing row.
- No existing reaction inserts a new row.

Payload:

```text
user_id
book_id
reaction_type
```

Supported values:

- `like`
- `dislike`

### Follow Author

Table:

```text
follows
```

Load:

```text
follows
where follower_id = auth.uid()
and author_id = :authorId
```

Insert:

```text
follows.insert({
  follower_id,
  author_id
})
```

Delete:

```text
follows.delete()
where id = :followId
```

## UI Behavior

Novel Details now includes:

- Follow Author button.
- Like button.
- Dislike button.
- Rating selector.
- Review text area.
- Review list from Supabase if available.
- Error states if tables are missing or blocked by RLS.

Visitor/guest behavior:

- Writing a review redirects to Login.
- Like/Dislike redirects to Login.
- Follow Author redirects to Login.
- Public review loading is attempted from Supabase.

Signed-in behavior:

- Can submit reviews if `reviews` exists and RLS allows insert.
- Can like/dislike if `book_reactions` exists and RLS allows select/insert/update/delete.
- Can follow/unfollow if `follows` exists and RLS allows select/insert/delete.

## Live Supabase Verification

REST checks were run against:

```text
https://ifxzbwaxrloeuztavcef.supabase.co/rest/v1
```

Results:

| Table | Status | Observed result |
| --- | --- | --- |
| `reviews` | FAIL | Missing from schema cache: `PGRST205`. |
| `book_reactions` | FAIL | Missing from schema cache: `PGRST205`. |
| `follows` | PASS/PARTIAL | Table exists and returns `[]` for anon/public check. |

Exact `reviews` issue:

```text
PGRST205: Could not find the table 'public.reviews' in the schema cache
```

Exact `book_reactions` issue:

```text
PGRST205: Could not find the table 'public.book_reactions' in the schema cache
```

No fallback to `ratings` was implemented because this phase explicitly requested `reviews`.

## Required RLS Behavior

### `reviews`

- Public can read approved/published reviews if product allows public reviews.
- Signed-in user can insert own review.
- Signed-in user can update/delete own review if product allows editing.
- User cannot write as another `user_id`.

### `book_reactions`

- Signed-in user can select own reaction.
- Signed-in user can insert own reaction.
- Signed-in user can update own reaction.
- Signed-in user can delete own reaction.
- Unique index recommended on `(user_id, book_id)`.

### `follows`

- Signed-in user can select own follows.
- Signed-in user can insert follows where `follower_id = auth.uid()`.
- Signed-in user can delete own follows.
- Unique index recommended on `(follower_id, author_id)`.

## Verification

Checks run:

- `node --check web/frontend-ui/app.js`: PASS
- Logged-out Novel Details social route harness: PASS
- Logged-in mocked social route harness with reviews/reactions/follows: PASS
- Static scan for legacy/payment clients in `web/frontend-ui`: PASS
- Live Supabase REST checks:
  - `reviews`: missing
  - `book_reactions`: missing
  - `follows`: available

## Blockers

### 1. `reviews` table is missing

Impact:

- Ratings and reviews cannot work in production until `reviews` exists and is exposed.

### 2. `book_reactions` table is missing

Impact:

- Like/Dislike cannot work in production until `book_reactions` exists and is exposed.

### 3. `follows` RLS is unverified with a real signed-in user

Impact:

- The table exists, but follow/unfollow must be verified using a real authenticated session.

### 4. Reader content dependency

Impact:

- Follow Author depends on `books.author_id`.
- Current reader catalog has no visible published books in anon checks, so real end-to-end social testing needs visible content.

## Current Decision

Social feature integration is implemented structurally through Supabase only.

Production usage is blocked until:

- `reviews` exists or the product contract changes.
- `book_reactions` exists or the product contract changes.
- `follows` RLS is verified with a real signed-in user.
- Published books with valid `author_id` are available.
