# NOVELFLEX Data Model Alignment

Date: 2026-06-13

Scope: Naming consistency audit before backend connection. Documentation only. No implementation, migrations, code edits, RLS edits, or backend changes are included.

## Executive Decision

NOVELFLEX should standardize on the newer live Supabase model:

| Product concept | Final name |
| --- | --- |
| Auth identity | `auth.users` |
| App profile and role | `profiles` |
| Author profile | `writer_profiles` |
| Novel/book | `books` |
| Chapter/content unit | `chapters` |
| Book ownership | `books.author_id -> profiles.id` |

Legacy names should be treated as migration/adaptor terms only:

- `authors` -> replace with `writer_profiles` plus `profiles`.
- `pdf_files` -> replace with `chapters`.
- App-level `users` -> replace with Supabase `auth.users` plus `profiles`.

## Current Naming Conflicts

### 1. `authors` vs `writer_profiles`

Current conflict:

- Older local schema and some Flutter book repository paths still expect `authors`.
- Current live schema exposes `writer_profiles`.
- Current web joins `books.author_id` to `profiles`.
- `writer_profiles.user_id` points back to the user's `profiles.id`.

Risk:

- Author identity can split across two tables.
- Author dashboard may show no books if ownership points to a different ID type.
- RLS may grant or deny incorrectly if `books.author_id` sometimes means `authors.id` and sometimes means `profiles.id`.
- Search, public author profile, and admin author approval can disagree.

Final strategy:

- Use `writer_profiles` as the author-specific extension table.
- Use `profiles` as the user identity and role table.
- Do not use `authors` in new frontend/backend service contracts.
- If legacy mobile code still needs `authors`, handle it through a temporary compatibility adapter only.

Final relationship:

```text
auth.users.id
  -> profiles.id
  -> writer_profiles.user_id
  -> books.author_id
```

Meaning:

- `profiles.id` is the user's application identity.
- `writer_profiles.user_id` is the writer extension for that user.
- `books.author_id` stores the owning author's `profiles.id`, not `writer_profiles.id` and not legacy `authors.id`.

## 2. `pdf_files` vs `chapters`

Current conflict:

- Older Flutter repository constants still reference `pdf_files`.
- Current live schema exposes `chapters`.
- Current web/product docs use chapter routes and chapter service language.
- `pdf_files` is format-specific, while the product needs text, file, and audio chapter support.

Risk:

- Reader page may query one table while author upload writes another.
- Continue Reading can point to stale or missing chapter IDs.
- Storage paths can diverge between `pdf-files` and future `chapter-files`.
- Admin content moderation may review one table while public reader displays another.

Final strategy:

- Use `chapters` as the canonical product table.
- Do not expose `pdf_files` in new product-facing service names or frontend types.
- Keep `pdf_files` only as a legacy import/source term if migration requires it.
- Name the service `ChapterService`, not `PdfFileService`.

Final chapter model:

```text
books.id
  -> chapters.book_id
```

Recommended final fields:

- `chapters.id`
- `chapters.book_id`
- `chapters.chapter_number`
- `chapters.title_ar`
- `chapters.title_en`
- `chapters.content_text`
- `chapters.file_path`
- `chapters.audio_path`
- `chapters.status`
- `chapters.published_at`
- `chapters.created_at`
- `chapters.updated_at`

## 3. Books Ownership Fields

Current conflict:

- Older schema: `books.author_id -> authors.id`.
- Current live architecture: `books.author_id -> profiles.id`.
- Some local code references `owner_user_id` fallback behavior.
- Web joins `author:profiles!books_author_id_fkey(...)`.

Risk:

- Author cannot see owned novels.
- Admin cannot reliably review content by author.
- Public author links can route to the wrong profile.
- RLS ownership policies become unsafe.

Final strategy:

- Canonical ownership field: `books.author_id`.
- Canonical ownership target: `profiles.id`.
- Do not introduce `owner_user_id` as a parallel ownership field for new code.
- Do not point `books.author_id` to `writer_profiles.id`; use `writer_profiles` only for author metadata.

Final ownership rule:

```text
books.author_id = profiles.id
writer_profiles.user_id = profiles.id
```

RLS implication:

- An author owns a book when `books.author_id = auth.uid()` if `profiles.id` equals `auth.users.id`.
- Admin override should be separate and role-based.

Service-layer naming:

| Field in service model | Source |
| --- | --- |
| `book.id` | `books.id` |
| `book.authorId` | `books.author_id` |
| `book.authorProfile` | `profiles` joined by `books.author_id` |
| `book.writerProfile` | `writer_profiles` joined by `profiles.id` |

## 4. User/Profile/Author Relationships

Current conflict:

- Older local model includes `users`.
- Current live model exposes `profiles`.
- Supabase Auth owns credentials through `auth.users`.
- Role checks now belong to `profiles.role` or trusted app metadata, not a legacy `users.role`.

Risk:

- Duplicate account identity.
- Wrong role checks.
- User profile and author profile can drift.
- Admin/user moderation can update the wrong entity.

Final strategy:

- Use `auth.users` only for authentication identity.
- Use `profiles` for app-visible identity and route roles.
- Use `writer_profiles` only for author-specific metadata and approval.
- Do not create new frontend dependencies on `users`.

Final relationship:

```text
auth.users.id
  -> profiles.id
profiles.id
  -> writer_profiles.user_id
profiles.id
  -> favorites.user_id
profiles.id
  -> ratings.user_id
profiles.id
  -> reading_progress.user_id
profiles.id
  -> follows.follower_id
profiles.id
  -> follows.author_id
profiles.id
  -> books.author_id
```

Role naming:

| Product role | Final database value |
| --- | --- |
| Guest | No authenticated profile |
| Reader | `profiles.role = 'reader'` |
| Author | `profiles.role = 'writer'` plus `writer_profiles.is_approved = true` |
| Moderator | Future role if needed |
| Admin | `profiles.role = 'admin'` |

Do not use both `author` and `writer` as role values. Final value should be `writer` because the live architecture already uses `writer_profiles`.

## Final Naming Strategy

### Tables

| Legacy/current conflict | Final table name | Status |
| --- | --- | --- |
| `users` vs `profiles` | `profiles` with `auth.users` | Final |
| `authors` vs `writer_profiles` | `writer_profiles` | Final |
| `pdf_files` vs `chapters` | `chapters` | Final |
| old book ownership variants | `books.author_id -> profiles.id` | Final |

### Service Names

| Product area | Final service name |
| --- | --- |
| Auth/session | `AuthService` |
| User profile | `ProfileService` |
| Author profile | `AuthorService` or `WriterProfileService` |
| Books/novels | `BookService` |
| Chapters | `ChapterService` |
| Library | `LibraryService` |
| Reading progress | `ReadingProgressService` |
| Reviews/ratings | `ReviewService` |
| Follows | `FollowService` |

Recommended choice:

- Use `AuthorService` at product level.
- Internally map it to `writer_profiles` and `profiles`.
- This keeps product language friendly while database naming remains precise.

### Frontend Type Names

| UI type | Backend source |
| --- | --- |
| `UserProfile` | `profiles` |
| `AuthorProfile` | `writer_profiles` + `profiles` |
| `Novel` | `books` |
| `Chapter` | `chapters` |
| `LibraryItem` | `favorites` + `books` |
| `ReadingProgress` | `reading_progress` |
| `Review` | `ratings` |
| `Follow` | `follows` |

## Migration/Adapter Rules

Until all legacy code is cleaned:

- Legacy table names may appear only inside adapters, migration scripts, or historical audit docs.
- UI pages and new service contracts must use final product names.
- No new feature should import or query `authors` or `pdf_files` directly.
- If `pdf_files` data must be imported, map it into `chapters`.
- If `authors` data must be imported, map it into `writer_profiles` and link to `profiles`.

Temporary adapter examples:

| Adapter | Purpose |
| --- | --- |
| `LegacyAuthorAdapter` | Converts old `authors` payloads into `AuthorProfile`. |
| `LegacyPdfFileAdapter` | Converts old `pdf_files` payloads into `Chapter`. |
| `LegacyUserAdapter` | Converts old `users` payloads into `UserProfile` where needed. |

Adapters should be deleted after migration confidence is reached.

## Backend Connection Rules

Before connecting frontend pages:

1. Confirm `profiles.id` equals `auth.users.id`.
2. Confirm `books.author_id` references `profiles.id`.
3. Confirm `writer_profiles.user_id` references `profiles.id`.
4. Confirm chapter reads use `chapters`, not `pdf_files`.
5. Confirm Author Dashboard queries owned books through `books.author_id`.
6. Confirm public author cards join `books.author_id -> profiles.id -> writer_profiles.user_id`.
7. Confirm RLS policies follow this ownership model.

## RLS Implications

Recommended ownership policies should follow this model:

- Public can read published `books`.
- Public can read published `chapters`.
- Public can read public `profiles`.
- Public can read approved `writer_profiles`.
- Author can insert/update books where `books.author_id = auth.uid()`.
- Author can insert/update chapters only for books they own.
- Author can update own `writer_profiles` row where `writer_profiles.user_id = auth.uid()`.
- Admin can moderate all rows through `profiles.role = 'admin'` or equivalent trusted role check.

Avoid:

- RLS based on legacy `authors.id`.
- RLS based on `raw_user_meta_data`.
- Mixed ownership checks using both `owner_user_id` and `author_id`.

## Risks If Not Aligned

| Risk | Impact |
| --- | --- |
| `authors` and `writer_profiles` both active | Author dashboard, search, and approval can disagree. |
| `pdf_files` and `chapters` both active | Reader, progress, and moderation can point to different content. |
| `books.author_id` points to different entity types | Ownership/RLS becomes unreliable. |
| `users.role` and `profiles.role` both active | Route guards can grant or block incorrectly. |
| Legacy code writes to old tables | Web pages connected to current tables show missing data. |

## Final Recommendation

Use this final naming strategy:

```text
auth.users
  -> profiles
  -> writer_profiles

profiles
  -> books.author_id
books
  -> chapters
```

Final table names for backend connection:

- `profiles`, not `users`
- `writer_profiles`, not `authors`
- `chapters`, not `pdf_files`
- `books.author_id`, always pointing to `profiles.id`

This should be the source of truth for NOVELFLEX Web backend integration. Legacy names should remain only in migration/adaptor code until removed.
