# NOVELFLEX Web MVP User Flow Map

Date: 2026-06-13

Scope: Full user flow documentation for NOVELFLEX Web MVP. This is documentation only. No code, database, backend, or API changes are included.

## Flow Principles

- Arabic RTL is the default layout for every flow.
- Reader discovery starts public, then asks for authentication only when persistence is needed.
- Author publishing requires a signed-in Author account or Admin access.
- Admin moderation requires Admin access only.
- Every flow must support empty, error, loading, and success states.
- Mobile behavior should prioritize bottom navigation, stacked screens, and single primary actions.
- Desktop behavior should prioritize wider layouts, sidebars, tables, and persistent navigation.

## Reader Flow

Primary flow:

```text
Home -> Browse -> Novel Details -> Chapter Reader -> Add to Library -> Continue Reading
```

### Entry Point

Reader can enter from:

- Root URL `/`.
- Shared novel URL `/novels/:novelId`.
- Search result URL `/search?q=:query`.
- Genre URL `/genre/:genreSlug`.
- Library URL `/library` after login.

### Steps

| Step | Route | User Intent | Main Action | Data Needed Later |
| --- | --- | --- | --- | --- |
| Home | `/` | Discover what to read. | Open Browse, Search, Continue Reading, or a novel card. | `books`, `categories`, `ratings`, `reading_progress`, recommendation sections |
| Browse | `/browse` | Explore the catalog. | Filter/sort novels and select a novel. | `books`, `categories`, `profiles`, `writer_profiles`, `ratings` |
| Novel Details | `/novels/:novelId` | Decide whether to read/save/follow/review. | Tap Read, Add to Library, Follow Author, or Reviews. | `books`, `profiles`, `writer_profiles`, `categories`, `chapters`, `ratings`, `favorites`, `follows` |
| Chapter Reader | `/novels/:novelId/chapters/:chapterId` | Read the selected chapter. | Navigate previous/next, adjust reading settings, save progress. | `chapters`, `books`, `reading_progress`, `chapter_read_events` |
| Add to Library | `/novels/:novelId` or reader toolbar action | Save novel for later. | Insert/remove favorite after authentication. | `favorites`, `books`, `profiles` |
| Continue Reading | `/library` or `/library/history` | Resume from last read position. | Open last chapter and restore progress. | `reading_progress`, `books`, `chapters` |

### Empty States

| Step | Empty State |
| --- | --- |
| Home | No featured/recent novels available; show Browse/Search fallback. |
| Browse | No novels match filters; show clear filters and category suggestions. |
| Novel Details | Novel not found or unpublished; show return to Browse. |
| Chapter Reader | No published chapters; show Novel Details and Library actions. |
| Library | No saved novels; show Browse CTA. |
| Reading History | No reading progress; show “ابدأ القراءة” CTA to Browse. |

### Error States

| Step | Error State |
| --- | --- |
| Home | Catalog load failed; show retry and cached content if available. |
| Browse | Filter/search request failed; preserve current filters and allow retry. |
| Novel Details | Novel fetch failed; show retry and safe back link. |
| Chapter Reader | Chapter content failed, access denied, or missing file/content; show retry and return to novel. |
| Add to Library | Guest prompt, duplicate save, permission denied, or network error. |
| Continue Reading | Last chapter removed/unpublished; route to Novel Details with explanation. |

### Success States

| Action | Success State |
| --- | --- |
| Open novel | Novel details load with metadata, chapters, and reviews. |
| Open chapter | Chapter content renders and progress tracking starts. |
| Save novel | Button changes to saved state and Library reflects the novel. |
| Update progress | Continue Reading card points to latest chapter/position. |
| Resume reading | Reader opens at last saved chapter/position where supported. |

### Mobile Behavior

- Home/Browse/Library/Profile should be reachable from bottom navigation.
- Browse filters should open as a drawer or bottom sheet.
- Novel Details should stack hero, actions, synopsis, chapters, and reviews vertically.
- Chapter Reader should hide secondary UI while reading and expose controls through a compact toolbar.
- Add to Library should use a visible icon/button near the primary Read action.
- Continue Reading should appear as a horizontal card or compact list near the top of Home/Library.

### Desktop Behavior

- Header navigation and search should remain persistent.
- Browse should use a sidebar filter layout with grid/list results.
- Novel Details can use a two-column layout with cover/actions beside synopsis/chapters.
- Chapter Reader should center readable content with a side or top chapter navigation.
- Library can use wider rows with cover, progress, and resume CTA.
- Reading History should support dense chronological rows.

## Author Flow

Primary flow:

```text
Register/Login -> Author Dashboard -> Create Novel -> Add Chapter -> Publish -> View Analytics
```

### Entry Point

Author can enter from:

- `/author`.
- `/author/novels`.
- Create CTA from navigation.
- Login/register page after trying to access an author route.

### Steps

| Step | Route | User Intent | Main Action | Data Needed Later |
| --- | --- | --- | --- | --- |
| Register/Login | `/auth/login`, `/auth/signup`, protected `/author` redirect | Access author workspace. | Authenticate and verify Author role/status. | Supabase Auth, `profiles`, `writer_profiles` |
| Author Dashboard | `/author` | See publishing status and next actions. | Open My Novels, Create Novel, Analytics, or Academy. | `books`, `chapters`, `ratings`, `favorites`, `chapter_read_events` |
| Create Novel | `/author/novels/new` | Start a new novel draft. | Fill metadata and save draft. | `books`, `categories`, `profiles`, `writer_profiles`, storage later for covers |
| Add Chapter | `/author/novels/:novelId/chapters/new` | Add first or next chapter. | Write/upload content and save draft. | `books`, `chapters`, storage paths if files are used |
| Publish | `/author/novels/:novelId/chapters` | Make content available or submit for review. | Submit/publish chapter or novel depending moderation rules. | `books`, `chapters`, `writer_profiles`, moderation status |
| View Analytics | `/author/analytics` | Understand performance. | Review reads, saves, ratings, and chapter activity. | `books`, `chapters`, `ratings`, `favorites`, `chapter_read_events`, future analytics events |

### Empty States

| Step | Empty State |
| --- | --- |
| Register/Login | No account; show sign-up and author eligibility path. |
| Author Dashboard | No novels yet; show Create Novel CTA and Academy guidance. |
| Create Novel | Empty form with required fields and category selector. |
| Add Chapter | No chapters for novel; show Add Chapter form and draft guidance. |
| Publish | Missing required metadata/chapter content; show checklist. |
| Analytics | No reads/saves/ratings yet; show “analytics will appear after readers engage.” |

### Error States

| Step | Error State |
| --- | --- |
| Register/Login | Invalid credentials, OAuth failure, missing profile, role denied, pending author approval. |
| Author Dashboard | Metrics failed to load; show retry and keep navigation available. |
| Create Novel | Validation error, category load failed, save failed, cover upload failed later. |
| Add Chapter | Empty title/content, upload failure, save failure, unsupported file type later. |
| Publish | Owner check failed, moderation rejection, missing required fields, status update failed. |
| Analytics | Analytics query failed or unavailable; show empty-safe fallback. |

### Success States

| Action | Success State |
| --- | --- |
| Login/register | Author reaches Dashboard or sees clear approval/pending state. |
| Create novel | Draft novel appears in My Novels. |
| Add chapter | Chapter appears in Chapter Manager with draft/in-review/published state. |
| Publish | Content status updates to published or in-review. |
| View analytics | Metrics render or a clean no-data state appears. |

### Mobile Behavior

- Author workspace should use a collapsible menu or top segmented navigation.
- Forms should be single-column with sticky primary action where appropriate.
- Chapter Manager should display compact cards instead of wide tables.
- Publish action should require clear confirmation on a small screen.
- Analytics should use stacked metric cards and simple charts/tables.

### Desktop Behavior

- Author workspace should use a persistent sidebar.
- Dashboard should use metric cards plus recent activity.
- My Novels and Chapter Manager can use tables with row actions.
- Create/Edit Novel forms can use two columns for metadata and preview.
- Analytics can use charts, tables, and filter controls in one view.

## Admin Flow

Primary flow:

```text
Login -> Reports -> Review Content -> Approve/Reject/Remove
```

### Entry Point

Admin can enter from:

- `/admin`.
- `/admin/reports`.
- `/admin/content-moderation`.
- Direct report/content moderation links.

### Steps

| Step | Route | User Intent | Main Action | Data Needed Later |
| --- | --- | --- | --- | --- |
| Login | `/auth/login` or protected `/admin` redirect | Access admin workspace. | Authenticate and verify Admin role. | Supabase Auth, `profiles` |
| Reports | `/admin/reports` | Review incoming reports. | Filter, open, assign, resolve, dismiss, or escalate report. | `reports`, `profiles`, `books`, `chapters`, `ratings` |
| Review Content | `/admin/content-moderation` | Inspect reported or pending content. | Preview book/chapter/review and check context. | `books`, `chapters`, `ratings`, `profiles`, `writer_profiles`, `reports` |
| Approve | `/admin/content-moderation` | Allow content to stay or publish. | Mark content approved/published. | `books`, `chapters`, future `moderation_actions` |
| Reject | `/admin/content-moderation` | Reject submitted content before publication. | Save rejection state and note. | `books`, `chapters`, `reports`, future `moderation_actions` |
| Remove | `/admin/content-moderation` | Remove unsafe/publicly violating content. | Hide/remove content and preserve audit reason. | `books`, `chapters`, `ratings`, `reports`, future `moderation_actions` |

### Empty States

| Step | Empty State |
| --- | --- |
| Login | No admin session; show login form. |
| Reports | No open reports; show resolved count or quiet queue state. |
| Review Content | No pending/reported content; show empty moderation queue. |
| Approve/Reject/Remove | No selected item; prompt admin to select report/content first. |

### Error States

| Step | Error State |
| --- | --- |
| Login | Invalid credentials, missing profile, non-admin role denied. |
| Reports | Reports failed to load; show retry and preserve filters. |
| Review Content | Content target missing/deleted; show report context and safe fallback. |
| Approve | Status update failed; keep previous state and show retry. |
| Reject | Missing admin note or update failed; do not change content state. |
| Remove | Permission denied, stale content state, or action conflict; re-fetch before retry. |

### Success States

| Action | Success State |
| --- | --- |
| Admin login | Admin lands on Reports or Dashboard. |
| Open report | Detail panel shows report, target preview, and actions. |
| Approve content | Content becomes approved/published and queue updates. |
| Reject content | Content becomes rejected with saved admin note. |
| Remove content | Content becomes hidden/removed and public pages no longer show it. |
| Resolve report | Report status updates and action history is retained. |

### Mobile Behavior

- Admin mobile layout should be functional but not the primary operational target.
- Use stacked list-to-detail navigation: Reports list first, detail screen second.
- Action buttons should be explicit and confirmation-based.
- Long tables should collapse into cards with priority/status badges.
- Admin note field should be required before destructive actions.

### Desktop Behavior

- Admin desktop layout should use persistent sidebar navigation.
- Reports should use a dense table with filters and a detail panel.
- Content review should support side-by-side report and target preview.
- Approve/Reject/Remove actions should remain visible in the detail panel.
- Admin should see clear status, actor, timestamp, and required note fields.

## Cross-Flow Rules

- Protected routes should preserve intended destination after login.
- Non-author access to Author routes should show a role/eligibility state, not a blank page.
- Non-admin access to Admin routes should show access denied and never load admin data.
- Guests can read public content but cannot save, review, follow, or persist cloud progress.
- Every destructive action must require confirmation and display a result state.
- Future monetization, subscriptions, coins, contracts, withdrawals, and revenue flows are outside this MVP user flow.

## Completion Criteria

Reader flow is complete when:

- A user can discover a novel, open details, read a chapter, save it, and resume from Library/History.

Author flow is complete when:

- An approved author can log in, reach Dashboard, create a novel, add a chapter, publish or submit it, and view basic analytics.

Admin flow is complete when:

- An admin can log in, review reports, inspect content, and approve/reject/remove with clear success and error states.
