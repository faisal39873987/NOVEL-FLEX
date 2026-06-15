# AUTHOR_UPLOAD_FIX_REPORT

Date: 2026-06-14

## Scope

Fixed the first production blocker in the author upload flow:

- New authenticated users were missing rows in `profiles`.
- Author book creation failed with `books_author_id_fkey`.
- Book cover upload was not ready because Supabase Storage had no buckets.

## Backend Changes

### Profile synchronization

Created a Supabase trigger to insert a `profiles` row whenever a new `auth.users` row is created.

Backfilled existing auth users without profiles.

Verification:

- `auth_users_without_profile = 0`

### Storage buckets

Created and verified:

- `book-covers`
  - Public: yes
  - MIME: `image/jpeg`, `image/png`, `image/webp`
  - Limit: 2MB
- `chapter-covers`
  - Public: yes
  - MIME: `image/jpeg`, `image/png`, `image/webp`
  - Limit: 2MB
- `author-images`
  - Public: yes
  - MIME: `image/jpeg`, `image/png`, `image/webp`
  - Limit: 2MB
- `chapter-files`
  - Public: no
  - MIME: `application/pdf`
  - Limit: 10MB

### Storage policies

Rules:

- Public can read public image buckets.
- Authenticated users can upload/update/delete only inside their own folder:
  `/{auth.uid()}/...`
- Private chapter files can only be read by the owning authenticated user for now.

## Web Changes

Updated:

- `web/frontend-ui/app.js`
- `web/frontend-ui/styles.css`

Implemented:

- Book cover file input in Create/Edit Novel.
- Cover validation:
  - JPG/PNG/WebP only.
  - Max 2MB.
- Upload to Supabase Storage bucket `book-covers`.
- Save generated public URL into `books.cover_url`.
- Manual cover URL fallback.
- Existing cover preview on edit.
- Required cover validation for book creation.

## Product Decision

NOVELFLEX MVP is text-chapter-first:

- Books: `books`
- Chapters: `chapters`
- Main reading source: `chapters.content_text`
- PDF is not the default reading engine for MVP.

## Verification

- `node --check web/frontend-ui/app.js`: PASS
- Supabase bucket verification: PASS
- Storage policies verification: PASS
- Profile sync verification: PASS
- Local screenshot captured:
  - `docs/product/author-create-route-local-auth-gate.png`
- Note: the author create form is auth-gated. Full upload verification requires a signed-in browser session.

## Deployment

Live files updated:

- `https://novelflex.online/frontend-ui/app.js`
- `https://novelflex.online/frontend-ui/styles.css`

Server backup:

- `/home/artshgwf/private_backups/frontend_ui_author_upload_20260614_094951`

HTTP verification:

- `/frontend-ui/`: 200
- `/frontend-ui/app.js`: 200
- `/frontend-ui/styles.css`: 200

Live content verification:

- Published `app.js` contains `uploadNovelCover`.
- Published `app.js` contains `book-covers`.
- Published `app.js` contains Arabic cover validation text.

## Remaining Work

1. Test actual Create Novel from the live UI with a signed-in user.
2. Add Chapter cover upload.
3. Connect mobile Flutter upload flow to `books + chapters`.
4. Hide payment/wallet/subscription surfaces from current MVP UI.
5. Create safe cleanup report before deleting obsolete files.
