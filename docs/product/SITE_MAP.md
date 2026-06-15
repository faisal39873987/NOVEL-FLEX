# NOVELFLEX Web MVP Site Map

Date: 2026-06-13

Scope: Required pages and routes for the NOVELFLEX Web MVP. This is documentation only. No code, database, backend, or API changes are included.

## Route Principles

- Arabic RTL is the default experience.
- Reader discovery pages are public unless they require personal data.
- Library, reading history, and profile require authentication.
- Author pages require an approved Author role or Admin.
- Admin pages require Admin role only.
- Future monetization pages are excluded from MVP routes.
- All routes should be handled through the frontend route layer and one service layer later.

## User Role Access

| Role | Access Definition |
| --- | --- |
| Guest | Public reader discovery and public reading where policy allows |
| Reader | Guest access plus library, history, profile, reviews, follows, saved novels |
| Author | Reader access plus author workspace |
| Admin | Full access plus admin/moderation workspace |

## Reader Pages

| Page | URL Path | Page Purpose | User Role Access | Main Components | Data Needed Later |
| --- | --- | --- | --- | --- | --- |
| Home | `/` | First landing page for readers to discover featured, recent, popular, and recommended novels. | Guest, Reader, Author, Admin | Header, search entry, featured novel section, continue reading strip, category chips, novel carousels/lists, mobile bottom navigation | `books`, `categories`, `profiles`, `writer_profiles`, `ratings`, `reading_progress`, future recommendation data |
| Browse | `/browse` | Main catalog page for browsing all public novels with filters and sorting. | Guest, Reader, Author, Admin | Filter sidebar/sheet, category list, sort control, novel cards, pagination/load more, empty state | `books`, `categories`, `profiles`, `writer_profiles`, `ratings`, `chapters_count` |
| Genre | `/genre/:genreSlug` | Category-specific catalog page for one genre/category. | Guest, Reader, Author, Admin | Genre header, active category state, filter chips, novel grid/list, sort control, empty genre state | `categories`, `books`, `profiles`, `writer_profiles`, `ratings` |
| Search | `/search?q=:query` | Search results page for novels, authors, categories, and future tags. | Guest, Reader, Author, Admin | Search input, grouped results, tabs for all/novels/authors/categories/tags, recent searches, no-results state | `books`, `profiles`, `writer_profiles`, `categories`, future `tags`, future `search_events` |
| Novel Details | `/novels/:novelId` | Full detail page for one novel with synopsis, metadata, author, chapters, reviews, and save/follow actions. | Guest read, Reader+ for save/follow/review actions | Novel hero, cover, title, author block, rating widget, stats, synopsis, chapter list, reviews preview, save button, follow author button, report action | `books`, `profiles`, `writer_profiles`, `categories`, `chapters`, `ratings`, `favorites`, `follows`, `reports` |
| Chapter Reader | `/novels/:novelId/chapters/:chapterId` | Reading experience for a published chapter with progress and navigation. | Guest for public chapters if allowed, Reader+ for synced progress | Reader toolbar, chapter title, chapter content/PDF fallback, previous/next controls, progress indicator, font/theme controls, save progress state | `chapters`, `books`, `reading_progress`, `chapter_read_events`, storage paths if files are used |
| Library | `/library` | Signed-in reader’s saved novels and continue-reading shortcuts. | Reader, Author, Admin | Auth guard, saved novel list, continue reading cards, remove saved action, empty library state | `favorites`, `books`, `chapters`, `reading_progress`, `profiles` |
| Reading History | `/library/history` | Timeline of recently read novels/chapters with resume actions. | Reader, Author, Admin | History list, resume button, progress bar, last-read timestamp, stale chapter fallback, empty history state | `reading_progress`, `books`, `chapters`, future `reading_sessions` |
| Profile | `/profile` | Signed-in user account/profile page and account actions. | Reader, Author, Admin | Profile header, avatar/name, role badge, account menu, saved/review/follow summaries, logout action, settings links | `profiles`, Supabase Auth session, `favorites`, `ratings`, `follows`, `reading_progress` |

## Author Pages

| Page | URL Path | Page Purpose | User Role Access | Main Components | Data Needed Later |
| --- | --- | --- | --- | --- | --- |
| Author Dashboard | `/author` | Overview of author publishing activity and basic content status. | Author, Admin | Author sidebar, metric cards, recent activity, draft/published counts, quick actions, empty author state | `profiles`, `writer_profiles`, `books`, `chapters`, `ratings`, `favorites`, `chapter_read_events` |
| My Novels | `/author/novels` | List and manage novels owned by the author. | Owner Author, Admin | Novel table/list, status badges, search/filter, create novel CTA, row action menu | `books`, `categories`, `chapters`, `writer_profiles` |
| Create Novel | `/author/novels/new` | Create a new novel draft with metadata. | Author, Admin | Novel form, title fields, description fields, category select, cover upload placeholder, save draft action, validation states | `books`, `categories`, `profiles`, `writer_profiles`, storage bucket later for covers |
| Edit Novel | `/author/novels/:novelId/edit` | Edit metadata and status for an existing author-owned novel. | Owner Author, Admin | Populated novel form, cover section, status badge, save action, validation errors, owner guard | `books`, `categories`, `chapters`, `profiles`, `writer_profiles`, storage paths |
| Chapter Manager | `/author/novels/:novelId/chapters` | Manage chapter list for one novel. | Owner Author, Admin | Chapter table/list, status badges, chapter order, add chapter CTA, edit actions, publish/review state | `books`, `chapters`, `profiles`, `writer_profiles`, storage paths |
| Add Chapter | `/author/novels/:novelId/chapters/new` | Add a new chapter draft to an author-owned novel. | Owner Author, Admin | Chapter form/editor, title fields, content field/PDF placeholder, save draft, submit/publish action, validation states | `books`, `chapters`, storage paths, moderation status |
| Analytics | `/author/analytics` | Show basic content performance for the author. | Author, Admin | Metric cards, per-novel table, views/reads/saves/ratings charts, date range placeholder, empty analytics state | `books`, `chapters`, `ratings`, `favorites`, `chapter_read_events`, future `book_view_events`, future `reading_sessions` |
| Academy | `/author/academy` | Educational hub for writing and publishing guidance. | Guest read optional, Author focused, Admin | Academy feed, guide cards, writing guide sections, contract guide coming-soon notice, author sidebar link | Static content now, future CMS/articles table if needed |

## Admin Pages

| Page | URL Path | Page Purpose | User Role Access | Main Components | Data Needed Later |
| --- | --- | --- | --- | --- | --- |
| Admin Dashboard | `/admin` | Admin overview for moderation health, reports, pending content, users, and categories. | Admin | Admin sidebar, metric cards, urgent reports, pending content summary, quick links, system status cards | `reports`, `books`, `chapters`, `profiles`, `writer_profiles`, `categories`, `ratings` |
| Reports | `/admin/reports` | Review and resolve user/content reports. | Admin | Reports table, status filters, reason filters, priority badges, report detail panel, resolve/dismiss/escalate actions | `reports`, `profiles`, `books`, `chapters`, `ratings`, future `moderation_actions` |
| Categories | `/admin/categories` | Manage public browse categories and genre structure. | Admin | Category table/tree, create/edit form, active toggle, sort order controls, dependency warning, validation states | `categories`, `books` |
| Users | `/admin/users` | Review users, roles, author status, and account moderation states. | Admin | User table, role/status filters, profile preview, author profile link, ban/restrict action placeholders | `profiles`, `writer_profiles`, `reports`, future `user_moderation_actions` |
| Content Moderation | `/admin/content-moderation` | Review, approve, hide, reject, or remove books/chapters/reviews. | Admin | Moderation queue, content preview, target type tabs, approval buttons, remove/hide actions, admin note field | `books`, `chapters`, `ratings`, `reports`, `profiles`, `writer_profiles`, future `moderation_actions` |

## Navigation Hierarchy

```text
NOVELFLEX Web MVP
├─ Reader
│  ├─ Home /
│  ├─ Browse /browse
│  │  └─ Genre /genre/:genreSlug
│  ├─ Search /search?q=:query
│  ├─ Novel Details /novels/:novelId
│  │  └─ Chapter Reader /novels/:novelId/chapters/:chapterId
│  ├─ Library /library
│  │  └─ Reading History /library/history
│  └─ Profile /profile
├─ Author
│  ├─ Author Dashboard /author
│  ├─ My Novels /author/novels
│  ├─ Create Novel /author/novels/new
│  ├─ Edit Novel /author/novels/:novelId/edit
│  ├─ Chapter Manager /author/novels/:novelId/chapters
│  ├─ Add Chapter /author/novels/:novelId/chapters/new
│  ├─ Analytics /author/analytics
│  └─ Academy /author/academy
└─ Admin
   ├─ Admin Dashboard /admin
   ├─ Reports /admin/reports
   ├─ Categories /admin/categories
   ├─ Users /admin/users
   └─ Content Moderation /admin/content-moderation
```

## MVP Route Guards

| Route Group | Guard |
| --- | --- |
| `/`, `/browse`, `/genre/:genreSlug`, `/search`, `/novels/:novelId` | Public |
| `/novels/:novelId/chapters/:chapterId` | Public if chapter policy allows; authenticated for synced progress |
| `/library`, `/library/history`, `/profile` | Authenticated Reader+ |
| `/author/*` | Author or Admin |
| `/admin/*` | Admin only |

## Data Notes For Later Implementation

- Use `books` as the canonical novel table.
- Use `chapters` as the canonical chapter table.
- Use `ratings`, not legacy `reviews`, for reviews/ratings if live schema remains unchanged.
- Use `reading_progress`, not legacy `reading_history`, for continue reading and history.
- Use `profiles` plus `writer_profiles` for author/user identity.
- Use `categories` for Browse and Genre.
- Use `reports` for Admin Reports and Content Moderation.
- Future monetization routes are intentionally excluded from this MVP site map.
