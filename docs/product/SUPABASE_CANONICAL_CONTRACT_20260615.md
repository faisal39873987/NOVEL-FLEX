# NOVELFLEX Supabase Canonical Contract

Date: 2026-06-15

## Final Table Names

Use these names in all new code, SQL, documentation, and QA reports:

| Domain | Canonical table |
|---|---|
| User profile and role | `profiles` |
| Writer/author metadata | `writer_profiles` |
| Books/novels | `books` |
| Chapters/content units | `chapters` |
| Ratings and written reviews | `ratings` |
| Reading progress/history | `reading_progress` |
| Library/saved books | `favorites` |
| Follows | `follows` |
| Notifications | `notifications` |
| Reports/moderation | `reports` |

## Deprecated Names

Do not introduce these names in new product-facing code:

| Deprecated name | Replacement |
|---|---|
| `authors` | `writer_profiles` joined through `profiles` |
| `pdf_files` | `chapters` |
| `reviews` | `ratings` |
| `reading_history` | `reading_progress` |

## Relationship Rules

- `profiles.id` is the user id and primary role source.
- `writer_profiles.user_id` references `profiles.id`.
- `books.author_id` references `profiles.id`, not `writer_profiles.id`.
- `chapters.book_id` references `books.id`.
- `ratings.book_id` references `books.id`.
- `reading_progress.user_id` references `profiles.id`.

## Code Rules

- New Flutter code should use `SupabaseTables.writerProfiles`, `chapters`,
  `ratings`, and `readingProgress`.
- Legacy aliases exist only inside `SupabaseTables` to keep older screens
  compiling during migration.
- No production build should rely on `ApiUtils` unless explicitly built with
  `--dart-define=ENABLE_LEGACY_API=true` and a deliberate
  `LEGACY_API_BASE_URL`.
