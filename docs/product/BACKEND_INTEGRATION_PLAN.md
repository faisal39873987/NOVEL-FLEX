# NOVELFLEX Backend Integration Plan

Date: 2026-06-13

Scope: Backend integration planning only. No implementation, migrations, schema edits, RLS edits, storage changes, or API connections are included.

## Current Supabase Inventory Summary

The existing inventory shows a schema split between older/legacy names and the newer live Supabase model.

| Requested table/entity | Current integration note |
| --- | --- |
| `users` | Legacy/local identity table. Current direction is Supabase Auth `auth.users` plus public `profiles`. |
| `profiles` | Current canonical app profile and role table. |
| `authors` | Legacy/local author table. Current direction is `writer_profiles` plus `profiles`. |
| `books` | Current canonical novel/book table. |
| `pdf_files` | Legacy/local chapter/file table. Current direction is `chapters`. |
| `categories` | Current canonical category table. |
| `favorites` | Current canonical saved-library table. |
| `reviews` | Legacy/local review table. Current direction is `ratings`. |
| `reading_history` | Legacy/local progress table. Current direction is `reading_progress`. |
| `book_reactions` | Referenced by code, but not confirmed in live schema. Needs decision before implementation. |
| `follows` | Current canonical reader-to-author follow table. |

## Integration Rule

Frontend pages should not query Supabase tables directly. Each page should call a service layer that maps product concepts to the final Supabase tables.

Recommended mapping:

| Product concept | Service | Requested entity | Current preferred table |
| --- | --- | --- | --- |
| User account | `AuthService`, `ProfileService` | `users`, `profiles` | `auth.users`, `profiles` |
| Author profile | `AuthorService` | `authors` | `writer_profiles`, `profiles` |
| Novels | `BookService` | `books` | `books` |
| Chapters | `ChapterService` | `pdf_files` | `chapters` |
| Categories | `CategoryService` | `categories` | `categories` |
| Library | `LibraryService` | `favorites` | `favorites` |
| Reviews/ratings | `ReviewService` | `reviews` | `ratings` |
| Reading progress | `ReadingProgressService` | `reading_history` | `reading_progress` |
| Reactions | `ReactionService` | `book_reactions` | Requires schema confirmation |
| Follows | `FollowService` | `follows` | `follows` |

## Page Integration Matrix

### Reader Pages

| Page | Route | Data Needed | Required Queries | Required Mutations | Security/RLS Notes | Storage Usage |
| --- | --- | --- | --- | --- | --- | --- |
| Home | `/` | Featured/recent/popular books, categories, optional continue-reading for signed-in user | Select published `books`; select active `categories`; join author from `profiles`/`writer_profiles`; if signed in select latest `reading_history` equivalent | Optional analytics event later | Public users can read only published books and active categories. Signed-in user can read only own progress. | Book cover URLs from future `book-covers` bucket or `books.cover_url`. |
| Browse | `/browse` | Catalog list, categories, author snippets, rating summaries | Select published `books` filtered by status/category/sort; select active `categories`; join public author profile | None | Public read only for published/approved content. Avoid exposing drafts or rejected content. | Covers only. |
| Genre | `/genre/:genreSlug` | Category detail, books in category | Select `categories` by slug; select published `books` by category; join author/profile | None | Inactive categories should not appear publicly. | Covers only. |
| Search | `/search?q=:query` | Matching books, authors, categories, future tags | Search `books`; search `profiles`/`writer_profiles`; search `categories`; optionally log `search_events` later | Optional insert search event if signed in or anonymous session policy exists | Search must filter out private profiles, unapproved authors, drafts, removed books. | Covers/avatars only. |
| Novel Details | `/novels/:novelId` | Book metadata, author profile, category, chapters, reviews, saved/follow state | Select `books` by ID/slug; join category and author; select chapter list from `pdf_files` equivalent; select reviews; select own favorite/follow state if signed in | Insert/delete `favorites`; insert/delete `follows`; insert/update `reviews`; insert report later | Public can read only published book and approved public reviews. User can mutate only own favorite/follow/review rows. | Cover image; chapter file metadata only if published and allowed. |
| Chapter Reader | `/novels/:novelId/chapters/:chapterId` | Chapter content/file, book context, previous/next chapters, saved/progress state | Select published chapter from `pdf_files` equivalent; select sibling chapters; select own `reading_history` equivalent | Upsert `reading_history` equivalent; insert chapter read event later; optional save favorite | Public reading policy must be explicit. Signed-in users can write only own progress. Premium/locked content is out of scope. | `pdf-files` or future `chapter-files` bucket; signed URLs if files are private. |
| Library | `/library` | Saved books and continue-reading cards | Select own `favorites` joined to `books`; select own `reading_history` equivalent | Delete favorite; optional insert favorite from inline action | Auth required. User reads/writes only own favorites. | Covers only. |
| Reading History | `/library/history` | Latest reading progress by book/chapter | Select own `reading_history` equivalent joined to `books` and chapter table | Delete/clear history later if product supports it; upsert happens from reader | Auth required. User reads/writes only own progress. | Covers; optional chapter file route only after access check. |
| Profile | `/profile` | Profile identity, role, saved/review/follow summaries | Select own `profiles`; aggregate own favorites/reviews/follows/progress | Update own profile; logout handled by Auth; account deletion later through Edge Function | User can read/update own profile. Public profile fields must be separate from private fields. | Avatar from future `user-avatars` or `author-images` bucket. |
| Login | `/auth/login` | Auth session state, profile after login | Supabase Auth sign-in; select `profiles` after session | Auth sign-in only | Never authorize from user-editable metadata. Role comes from `profiles` or app metadata policy. | None. |
| Register | `/auth/register` | Auth user, initial profile | Supabase Auth sign-up; create/upsert `profiles` | Insert profile row after sign-up | Profile creation must be duplicate-safe and RLS-safe. Default role should be `reader`. | Optional avatar later. |

### Author Pages

| Page | Route | Data Needed | Required Queries | Required Mutations | Security/RLS Notes | Storage Usage |
| --- | --- | --- | --- | --- | --- | --- |
| Author Dashboard | `/author` | Author profile, owned books, chapter counts, reviews, saved counts, read events | Select own `profiles`; select own `authors` equivalent; select own `books`; aggregate chapters/reviews/favorites | None in dashboard | Author access requires role `writer` or admin. Author can see only own dashboard unless admin. | Covers may load from book cover storage. |
| My Novels | `/author/novels` | Owned novel list with status and counts | Select `books` where author owns row; join `categories`; count chapters | None | Owner author or admin only. Drafts visible only to owner/admin. | Covers. |
| Create Novel | `/author/novels/new` | Categories, author profile | Select active `categories`; select own author profile | Insert `books`; upload cover later | Only approved author/admin can create. `author_id` must be server/RLS constrained to current profile. | Future `book-covers` bucket. |
| Edit Novel | `/author/novels/:novelId/edit` | Existing book metadata, categories, cover | Select owned `books`; select active `categories` | Update owned `books`; upload/replace cover later | Update requires SELECT + UPDATE policies. Author cannot edit other authors' books. | Future `book-covers` bucket. |
| Chapter Manager | `/author/novels/:novelId/chapters` | Owned book and chapter list | Select owned `books`; select `pdf_files` equivalent by book | Update chapter ordering/status later; delete/hide chapter later | Author can manage chapters only for owned books. Admin can moderate all. | Chapter file metadata and signed upload/download later. |
| Add Chapter | `/author/novels/:novelId/chapters/new` | Owned book context | Select owned `books`; optionally select last chapter number | Insert `pdf_files` equivalent; upload file/audio later | Author can add only to own book. Publishing may require moderation state. | Future `chapter-files`, `chapter-audio`, or legacy `pdf-files` bucket. |
| Analytics | `/author/analytics` | Reads, favorites, reviews, chapter activity | Select own books; aggregate `favorites`, `reviews` equivalent, reading/history/events | None | Analytics must not reveal individual reader private data. Aggregate only. | None. |
| Academy | `/author/academy` | Static guidance or future CMS articles | No Supabase required for MVP; future select CMS/articles table | None | Public/author readable. No monetization promises. | Optional static images only. |

### Admin Pages

| Page | Route | Data Needed | Required Queries | Required Mutations | Security/RLS Notes | Storage Usage |
| --- | --- | --- | --- | --- | --- | --- |
| Admin Dashboard | `/admin` | Counts for reports, users, authors, books, pending content, categories | Select/aggregate `profiles`, `authors` equivalent, `books`, `pdf_files` equivalent, `categories`, reviews/reports if enabled | None | Admin only. Do not load admin data before role check. | None or content preview thumbnails. |
| Reports | `/admin/reports` | Report queue and related target content | Select reports table if available; join `profiles`, `books`, `pdf_files` equivalent, `reviews` equivalent | Update report status/admin notes | Admin/moderator only. Mutations should be audited. | Target previews: covers/chapter files only with admin access. |
| Categories | `/admin/categories` | Category list/tree and usage counts | Select all `categories`; count related `books` | Insert/update/deactivate/reorder categories | Admin only. Public reads only active categories. Prevent breaking existing book references. | Optional category images if added later. |
| Users | `/admin/users` | User profiles, roles, author status, ban/restriction status later | Select `profiles`; select `authors` equivalent; report counts | Update roles/status later; ban/restrict later | Admin only. Role changes must be privileged and audited. Avoid relying on user metadata. | Avatars. |
| Content Moderation | `/admin/content-moderation` | Pending/reported books, chapters, reviews, authors | Select `books`; select `pdf_files` equivalent; select `reviews` equivalent; select author/profile context | Approve/reject/hide/remove content; update moderation status | Admin only. Soft removal preferred. Every action should write audit event later. | Covers and chapter file previews under admin access. |

## Query Plan By Entity

### `users`

Current status:

- Treat as legacy/local table unless production confirms it exists.
- Use Supabase Auth `auth.users` for credentials and `profiles` for public app data.

Queries:

- Do not query `users` directly from frontend MVP.
- After auth, select `profiles` by current auth user ID.

Mutations:

- Do not insert/update `users` from frontend.
- User creation is handled by Supabase Auth plus profile upsert.

RLS notes:

- Do not authorize from user-editable metadata.
- Keep role/permissions in `profiles.role` or trusted app metadata strategy.

### `profiles`

Queries:

- Current user profile.
- Public author/user fragments for book cards, reviews, follows.
- Admin user list.

Mutations:

- User updates own display name, username, avatar, bio.
- Admin updates roles/status only through privileged path.

RLS notes:

- Own profile read/update.
- Public read only for `is_public = true` fields.
- Admin full read/write only after verified role.

### `authors`

Current status:

- Requested entity is legacy. Current preferred equivalent is `writer_profiles`.

Queries:

- Author profile by user/profile ID.
- Approved public author directory/search.
- Author dashboard profile.

Mutations:

- Create/update own writer profile.
- Admin approve/reject author status.

RLS notes:

- Public read only approved authors.
- Author can update own writer profile.
- Admin approves `is_approved`.

### `books`

Queries:

- Published catalog.
- Book details.
- Author-owned book list.
- Admin moderation lists.

Mutations:

- Author inserts/updates own books.
- Admin approves/rejects/hides/removes books.
- Counters should be updated server-side or through controlled RPC later.

RLS notes:

- Public read only published books.
- Author read/write only own books.
- Admin can moderate all.

### `pdf_files`

Current status:

- Requested legacy chapter/file entity. Current preferred equivalent is `chapters`.

Queries:

- Published chapter list by book.
- Chapter reader content/file metadata.
- Author-owned chapter manager.
- Admin content moderation.

Mutations:

- Author inserts/updates chapters for owned books.
- Admin approves/rejects/hides/removes chapters.

RLS notes:

- Public read only published chapters.
- Author manage only chapters for own books.
- Admin access all moderation states.

### `categories`

Queries:

- Active public categories for Home/Browse/Genre/Create Novel.
- Admin full category list.

Mutations:

- Admin create/update/deactivate/reorder.

RLS notes:

- Public read only `is_active = true`.
- Admin-only writes.

### `favorites`

Queries:

- Own saved library.
- Own saved state on Novel Details.
- Aggregate saved counts for author analytics later.

Mutations:

- Insert favorite.
- Delete favorite.

RLS notes:

- User can read/write only own rows.
- Unique `(user_id, book_id)` required to prevent duplicates.

### `reviews`

Current status:

- Requested legacy entity. Current preferred equivalent is `ratings`.

Queries:

- Public approved reviews/ratings by book.
- Own review for a book.
- Author aggregate ratings for own books.
- Admin review moderation list.

Mutations:

- Insert/update own review/rating.
- Delete own review if product allows.
- Admin hide/remove/moderate review.

RLS notes:

- Public read only approved/non-deleted reviews.
- User write only own review.
- Admin moderation must be privileged.

### `reading_history`

Current status:

- Requested legacy entity. Current preferred equivalent is `reading_progress`.

Queries:

- Own latest reading progress.
- Continue Reading cards.
- Reading History timeline.

Mutations:

- Upsert progress from Chapter Reader.
- Optional clear history later.

RLS notes:

- User can read/write only own progress.
- Never expose individual reader history to authors; author analytics must be aggregated.

### `book_reactions`

Current status:

- Requested entity is referenced by code but not confirmed in current live schema.

Queries:

- Own reaction state for a book.
- Aggregate likes/dislikes if table is created.

Mutations:

- Insert/update/delete own reaction.

RLS notes:

- Must be created/confirmed before implementation.
- User can mutate only own reaction.
- Public aggregates should not reveal user identities.

### `follows`

Queries:

- Own follow state for an author.
- Followed authors list.
- Author follower count/aggregate.

Mutations:

- Follow author.
- Unfollow author.

RLS notes:

- User can read/write own follow rows.
- Public follower counts should be aggregate-only.
- Prevent duplicate follows with unique `(follower_id, author_id)`.

## Storage Bucket Usage

Current inventory indicates live Storage buckets were not visible, while local SQL expects buckets such as `book-covers`, `author-images`, and `pdf-files`.

Recommended bucket plan:

| Bucket | Purpose | Used by pages | Access model |
| --- | --- | --- | --- |
| `book-covers` | Novel cover images | Home, Browse, Genre, Search, Novel Details, Library, Author pages | Public read for published books; author/admin write for owned books |
| `author-images` | Author avatars/profile images | Novel Details, Profile, Author Dashboard, Admin Users | Public read for public/approved profiles; owner/admin write |
| `pdf-files` | Legacy PDF chapter files if `pdf_files` remains | Chapter Reader, Chapter Manager, Content Moderation | Prefer private/protected reads through signed URLs |
| `chapter-files` | Future canonical chapter file attachments | Chapter Reader, Add Chapter, Admin moderation | Private/protected; access after chapter visibility/RLS check |
| `chapter-audio` | Future audio chapter files | Chapter Reader | Private/protected; not MVP unless audio is included |

Storage risks:

- Do not use permanent public URLs for non-public chapters.
- Storage upsert needs INSERT + SELECT + UPDATE policies.
- Author file writes must be constrained to owned books/chapters.
- Admin moderation should be able to view/quarantine files without making them public.

## Security/RLS Notes

- Enable and verify RLS on every exposed public table.
- Public users can read only published books, published chapters, active categories, public profiles, approved authors, and public approved reviews.
- Authenticated readers can read/write only their own favorites, reading history/progress, follows, reactions, and reviews.
- Authors can create/update only their own books and chapters.
- Admin operations must be role-checked before any query loads admin data.
- Do not rely on `raw_user_meta_data` or user-editable metadata for roles.
- Admin role should come from trusted `profiles.role`, app metadata, or a server-side role check.
- UPDATE policies need matching SELECT policies or updates may silently affect zero rows.
- Privileged mutations such as account deletion, content removal, role changes, and admin moderation should use secure server-side functions if RLS alone is insufficient.

## Risks Before Implementation

1. Legacy/current schema drift:
   - `users` vs `auth.users` + `profiles`
   - `authors` vs `writer_profiles`
   - `pdf_files` vs `chapters`
   - `reviews` vs `ratings`
   - `reading_history` vs `reading_progress`

2. `book_reactions` is not confirmed in the current live schema.

3. Storage buckets are not confirmed available remotely.

4. Live RLS policy definitions were not verified from `pg_policies`.

5. Existing Flutter/mobile repository assumptions still use legacy names and integer IDs in some paths.

6. Author ownership must be standardized:
   - Decide whether `books.author_id` references `profiles.id` or an author-specific table.

7. Public/private content rules must be final before connecting Chapter Reader.

8. Search and Browse need indexes before catalog growth.

9. Admin moderation should not be connected until role checks and audit strategy are ready.

10. Monetization/payment tables exist in inventory but must remain out of MVP backend integration.

## Implementation Readiness Checklist

- Confirm final table mapping for every legacy/current pair.
- Confirm live schema columns and ID types.
- Confirm RLS policies with direct Postgres read-only access.
- Create/verify required storage buckets and storage policies.
- Define service layer interfaces before page-level data wiring.
- Implement read-only public pages first: Home, Browse, Genre, Search, Novel Details.
- Then implement authenticated reader writes: favorites, reviews, follows, reading progress.
- Then implement author ownership workflows.
- Then implement admin workflows through privileged, audited operations.

## Final Decision

The backend integration should use Supabase as the canonical backend, but pages must connect through a service layer that shields the frontend from legacy/current table differences. Before implementation, NOVELFLEX must resolve the legacy entity names requested here against the live preferred tables and verify RLS/storage readiness.
