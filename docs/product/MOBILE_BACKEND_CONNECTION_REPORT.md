# MOBILE_BACKEND_CONNECTION_REPORT

Date: 2026-06-14

## Scope

Connected the Flutter data layer toward the current NOVELFLEX Supabase schema without changing mobile UI/design.

## Important App Store Connect Note

An `altool` process was detected during this work, but the IPA path was:

- `xcode-upload-output/after-clean-export/Tactical PS1 Emulator.ipa`

This is not NOVELFLEX, so no action was taken against that upload process.

## Backend Contract Used

Current production Supabase schema:

- `profiles`
- `writer_profiles`
- `categories`
- `books`
- `chapters`
- `favorites`
- `reading_progress`
- `ratings`
- `book_view_events`
- `chapter_read_events`
- Storage:
  - `book-covers`
  - `chapter-covers`
  - `author-images`
  - `chapter-files`

## Flutter Data Layer Changes

Updated:

- `lib/data/services/supabase_database_service.dart`
- `lib/data/repositories/book_repository.dart`
- `lib/data/repositories/category_repository.dart`
- `lib/data/repositories/favorite_repository.dart`
- `lib/data/repositories/storage_repository.dart`
- `lib/data/repositories/author_repository.dart`
- `lib/data/services/supabase_storage_service.dart`
- `lib/data/services/supabase_integration_service.dart`
- `lib/data/services/supabase_legacy_api_adapter.dart`

## What Changed

### Books

- `books` now uses current fields:
  - `id`
  - `author_id`
  - `category_id`
  - `title_ar`
  - `title_en`
  - `description_ar`
  - `description_en`
  - `cover_url`
  - `status`
  - `views_count`
  - `rating_average`
  - `ratings_count`
  - `chapters_count`

Removed assumptions from the data layer:

- `authors(*)`
- `users(*)`
- `title`
- `description`
- `cover_image_url`
- `cover_image_path`
- `is_active`
- `deleted_at`
- `subcategory_id`

### Chapters

Mobile data layer now treats `chapters` as the source for readable content.

The old method name `getBookPdfFiles` is kept as a compatibility bridge, but it now reads from:

- `chapters`

Instead of:

- `pdf_files`

### Categories

Categories now use:

- `name_ar`
- `name_en`
- `slug`
- `description_ar`
- `description_en`
- `sort_order`
- `is_active`

### Favorites

Favorites now use UUID book IDs.

### Storage

Storage now targets:

- `book-covers`
- `chapter-covers`
- `author-images`
- `chapter-files`

### Legacy Compatibility

Some older Flutter screens still expect integer IDs.

To avoid redesigning screens now, the adapter generates stable numeric IDs from UUIDs and resolves them back to real UUIDs when opening a book, loading chapters, saving, or removing favorites.

## Verification

- `flutter analyze lib/data`: PASS
- `flutter analyze`: PASS

## What Was Not Changed

- No mobile UI changes.
- No app design changes.
- No payment UI cleanup yet.
- No App Store Connect upload action.
- No iOS/Android runtime test yet.

## Remaining Mobile Work

1. Run app on real Android/iPhone.
2. Verify:
   - Home loads Supabase books.
   - Book details open with UUID bridge.
   - Books without chapters do not open reader.
   - Chapters load from `chapters`.
   - Favorite add/remove works.
3. Update old PDF reader screens to render `content_text` cleanly.
4. Hide payment/wallet/subscription surfaces for MVP.
5. Add mobile design polish after the data path is stable.
