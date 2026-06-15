# NOVELFLEX Chapter System Report

Date: 2026-06-13

## Scope

This phase connects Author Chapter Management using `pdf_files`.

Important naming decision:

- Database table name remains `pdf_files`.
- The frontend treats `pdf_files` as chapters only in the service/UI layer.
- No database table was renamed.
- No schema migration was created.

Implemented:

- Create Chapter
- Edit Chapter
- Delete Chapter
- Reorder Chapters
- Draft Chapters
- Published Chapters

Explicitly not implemented:

- Payments
- Premium chapters
- Legacy APIs
- Database schema changes
- Table rename from `pdf_files`
- Storage upload workflow

## Files Changed

- `web/frontend-ui/app.js`
  - Added `pdf_files` chapter service state under Author Portal.
  - Added chapter load/create/edit/delete/reorder operations.
  - Added Draft and Published chapter filters.
  - Added Chapter Manager UI.
  - Added Create/Edit Chapter form.
  - Added chapter routes and interaction handlers.

- `web/frontend-ui/styles.css`
  - Added support for tab links used by chapter filters.

- `docs/product/CHAPTER_SYSTEM_REPORT.md`
  - Documents implementation, verification, and blockers.

## Routes

| Route | Status | Purpose |
| --- | --- | --- |
| `#/author/novels/:bookId/chapters` | PASS structurally | Manage all chapters for one owned novel. |
| `#/author/novels/:bookId/chapters?filter=drafts` | PASS structurally | Show draft/non-published `pdf_files` rows. |
| `#/author/novels/:bookId/chapters?filter=published` | PASS structurally | Show published `pdf_files` rows. |
| `#/author/novels/:bookId/chapters/new` | PASS structurally | Create a new `pdf_files` row. |
| `#/author/novels/:bookId/chapters/:chapterId/edit` | PASS structurally | Edit an existing `pdf_files` row. |

## Service Layer Mapping

Internal UI concept:

```text
Chapter
```

Database source:

```text
pdf_files
```

Mapped fields:

| UI Field | `pdf_files` Field |
| --- | --- |
| `chapter.id` | `id` |
| `chapter.bookId` | `book_id` |
| `chapter.number` | `chapter_number` |
| `chapter.title` | `title_ar`, `title_en`, or `title` |
| `chapter.content` | `content_text` or `text_content` |
| `chapter.filePath` | `file_path`, `pdf_url`, or `url` |
| `chapter.status` | `status` |
| `chapter.updated` | `updated_at`, `published_at`, or `created_at` |

## Operations

### Load Chapters

Reads:

```text
pdf_files
```

Filters:

```text
book_id = :bookId
```

Ordering:

```text
chapter_number ASC
```

### Create Chapter

Inserts into:

```text
pdf_files
```

Fields:

- `book_id`
- `chapter_number`
- `title_ar`
- `content_text`
- `file_path`
- `status`
- `created_at`
- `updated_at`

### Edit Chapter

Updates:

```text
pdf_files
```

Owner-level guard used by the UI:

- The chapter form is reachable only after the book exists in the signed-in author's owned `books` list.

Database update filters:

```text
id = :chapterId
book_id = :bookId
```

### Delete Chapter

Deletes from:

```text
pdf_files
```

Filters:

```text
id = :chapterId
book_id = :bookId
```

### Reorder Chapters

Swaps `chapter_number` between two `pdf_files` rows:

```text
chapter_number
```

Filters each update by:

```text
id = :chapterId
book_id = :bookId
```

## Draft and Published Rules

Draft chapters:

```text
status != published
```

Published chapters:

```text
status = published
```

Create/Edit form behavior:

- Save as draft sets `status = draft`.
- Publish sets `status = published`.

## Live Supabase Verification

REST check against:

```text
https://ifxzbwaxrloeuztavcef.supabase.co/rest/v1/pdf_files?select=*&limit=1
```

Current result:

```text
PGRST205: Could not find the table 'public.pdf_files' in the schema cache
```

Status:

```text
FAIL live table availability
```

Impact:

- The chapter management UI and service layer are implemented.
- Live create/edit/delete/reorder cannot succeed until `pdf_files` exists and is exposed to the Supabase Data API with correct RLS.

## Required RLS Behavior

For launch, `pdf_files` must support:

- Author can select chapters for books they own.
- Author can insert chapters only for books they own.
- Author can update chapters only for books they own.
- Author can delete chapters only for books they own.
- Public/reader access to published chapters must be separate from author write policies.

Expected ownership relationship:

```text
pdf_files.book_id -> books.id
books.author_id -> profiles.id / auth.uid()
```

## Verification

Checks run:

- `node --check web/frontend-ui/app.js`: PASS
- Logged-out chapter route harness: PASS
- Logged-in mocked chapter route harness with `pdf_files` rows: PASS
- Supabase REST check for `pdf_files`: FAIL, table missing from schema cache

## Blockers

### 1. `pdf_files` is missing from Supabase schema cache

Exact issue:

```text
PGRST205: Could not find the table 'public.pdf_files' in the schema cache
```

Impact:

- Chapter management cannot operate against production Supabase yet.

### 2. RLS for `pdf_files` is unverified

Impact:

- Even after the table is available, create/edit/delete/reorder will fail unless authenticated author policies are configured.

### 3. Storage upload is not connected

Impact:

- The form accepts an optional existing `file_path`.
- It does not upload PDFs to Supabase Storage yet.

## Current Decision

Chapter management is implemented structurally against `pdf_files` only.

Production usage is blocked until:

- `pdf_files` exists in the exposed schema.
- `pdf_files` has required columns or compatible aliases.
- RLS policies allow owner author CRUD and reorder operations.
- A real signed-in author account verifies end-to-end chapter operations.
