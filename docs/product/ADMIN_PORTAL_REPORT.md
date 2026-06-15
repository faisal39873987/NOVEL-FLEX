# NOVELFLEX Admin Portal Report

Date: 2026-06-13

## Scope

This phase builds a minimal Admin Portal using existing Supabase entities where available.

Features implemented:

- User Management
- Author Management
- Novel Management
- Review Moderation
- Reports Queue
- Categories

Explicitly not implemented:

- Payments
- Wallets
- Legacy REST APIs
- Schema migrations
- Service role usage in the browser
- Hard deletes for content moderation

## Files Changed

- `web/frontend-ui/app.js`
  - Added Admin Portal state.
  - Added admin-only access gate through `profiles.role = admin`.
  - Added data loading from Supabase.
  - Added admin routes.
  - Added lightweight admin actions for available tables.

- `docs/product/ADMIN_PORTAL_REPORT.md`
  - Documents implementation, live schema status, and blockers.

## Routes

| Route | Feature |
| --- | --- |
| `#/admin` | Admin dashboard |
| `#/admin/users` | User Management |
| `#/admin/authors` | Author Management |
| `#/admin/novels` | Novel Management |
| `#/admin/reviews` | Review Moderation |
| `#/admin/reports` | Reports Queue |
| `#/admin/categories` | Categories |

## Access Control

The portal requires:

```text
profiles.role = admin
```

Behavior:

- Visitor: redirected to login call-to-action.
- Signed-in non-admin: blocked with an insufficient permission message.
- Admin: portal loads data from Supabase.

No authorization decision uses `user_metadata`.

## Entities And Actions

### User Management

Table:

```text
profiles
```

Implemented:

- List users.
- Update role.
- Toggle public visibility.

Fields used:

- `id`
- `role`
- `display_name`
- `username`
- `is_public`
- `created_at`

### Author Management

Requested entity:

```text
authors
```

Implemented:

- Attempts to load `authors`.
- Displays table error if unavailable.

Live status:

```text
FAIL: authors missing from schema cache
```

### Novel Management

Table:

```text
books
```

Implemented:

- List novels.
- Update novel status.

Supported statuses in UI:

- `draft`
- `in_review`
- `published`
- `rejected`
- `archived`

### Review Moderation

Requested table:

```text
reviews
```

Implemented:

- Attempts to load `reviews`.
- Displays table error if unavailable.

Live status:

```text
FAIL: reviews missing from schema cache
```

No fallback to `ratings` was implemented because this phase requested review moderation against existing entities and earlier phases explicitly used `reviews`.

### Reports Queue

Table:

```text
reports
```

Implemented:

- List reports.
- Update report status.

Supported statuses in UI:

- `open`
- `reviewing`
- `resolved`
- `dismissed`

### Categories

Table:

```text
categories
```

Implemented:

- List categories.
- Update:
  - `name_ar`
  - `slug`
  - `sort_order`
  - `is_active`

## Live Supabase Verification

REST checks were run against:

```text
https://ifxzbwaxrloeuztavcef.supabase.co/rest/v1
```

Results:

| Entity | Status | Observed result |
| --- | --- | --- |
| `profiles` | PASS | Returned public profile rows. |
| `authors` | FAIL | Missing from schema cache: `PGRST205`. |
| `books` | PASS/PARTIAL | Table query succeeds, currently returns `[]` for anon/public check. |
| `reviews` | FAIL | Missing from schema cache: `PGRST205`. |
| `reports` | PASS/PARTIAL | Table query succeeds, currently returns `[]`. |
| `categories` | PASS | Returned active category rows. |

Exact `authors` issue:

```text
PGRST205: Could not find the table 'public.authors' in the schema cache
```

Exact `reviews` issue:

```text
PGRST205: Could not find the table 'public.reviews' in the schema cache
```

## Verification

Checks run:

- `node --check web/frontend-ui/app.js`: PASS
- Logged-out admin route harness: PASS
- Logged-in mocked admin route harness: PASS
- Live Supabase REST table checks: PASS/PARTIAL/FAIL as documented
- Static scan for legacy/payment usage in `web/frontend-ui`: PASS

Local frontend server:

```text
http://127.0.0.1:4173/frontend-ui/
```

## Required RLS

Admin portal production use requires policies that allow admins to:

- Read `profiles`.
- Update `profiles.role` and `profiles.is_public`.
- Read and update `books.status`.
- Read and update `reports.status`.
- Read and update `categories`.
- Read and moderate `reviews` once the table exists.
- Read/manage `authors` once the table contract is resolved.

Admin check should be based on trusted data:

```text
profiles.role = admin
```

Avoid:

- Authorizing from user-editable metadata.
- Exposing service-role keys in the browser.

## Blockers

### 1. `authors` table is missing

Impact:

- Author Management cannot be fully functional.

### 2. `reviews` table is missing

Impact:

- Review Moderation cannot be fully functional.

### 3. Admin RLS is unverified with a real admin account

Impact:

- UI is structurally complete, but update actions may fail until policies are verified.

### 4. Empty content tables

Observed:

- `books` returns `[]`.
- `reports` returns `[]`.

Impact:

- Novel Management and Reports Queue render empty states until data exists or admin RLS reveals rows.

## Current Decision

Admin Portal is implemented structurally and uses Supabase only.

Production readiness is blocked until:

- A real admin account verifies access.
- Admin RLS policies are confirmed.
- `authors` and `reviews` schema mismatch is resolved.
- Representative books/reports exist for moderation testing.
