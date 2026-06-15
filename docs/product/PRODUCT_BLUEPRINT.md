# NOVELFLEX Product Blueprint

Date: 2026-06-13

Reference UI source: `/docs/product/reference-ui`

## Product Vision

NOVELFLEX is an Arabic-first serialized reading and writing platform for novels, short stories, manga/comics, and creator-led fiction. The product should feel familiar to readers who understand Webnovel-style discovery, but it must become a distinct Arabic RTL experience rather than a clone.

The first release should focus on one promise: readers can discover Arabic serialized stories, start reading quickly, save what they like, return to their reading progress, and interact through reviews and follows. Authors can publish basic serialized content without monetization complexity. Admins can keep the catalog clean, categorized, and launch-ready.

The MVP should be fast, content-first, and operationally simple. It should avoid heavy creator economy features until the core reading loop has real content, retention, moderation, and author publishing reliability.

## Target Users

### Reader

Readers browse stories by genre, open novel details, read chapters, save novels to their library, continue reading, rate/review stories, and follow authors. Readers may be guests for discovery and reading public content, but saving, reviewing, following, and persistent history require authentication.

### Author

Authors create novels, edit metadata, publish chapters, manage their story list, and see basic content status. In MVP, authors do not manage earnings, coins, paid chapters, contracts, withdrawals, or subscription products.

### Admin

Admins manage platform quality. They review content, categories, reports, author eligibility, and inappropriate reviews. Admin workflows should be dense, searchable, auditable, and designed for repeated operational use.

## Core Features For MVP

- Arabic RTL reader web app.
- Supabase authentication: email, Google, Apple, guest mode.
- Browse by category/genre.
- Search novels.
- Novel details with cover, author, category, rating, stats, synopsis, and chapter list.
- Chapter reader with previous/next navigation.
- Reading progress saved to `reading_progress`.
- Save novel to library through `favorites`.
- Reviews and ratings through `ratings`.
- Follow author through `follows`.
- Reader library and reading history.
- Basic author portal: dashboard, my novels, create/edit novel, chapter manager.
- Basic admin portal: moderation, categories, reports, content approval.
- Responsive mobile-first layout with desktop browse/detail density.
- Empty states for missing production content.

## Features To Avoid For MVP

- Coins, gems, wallet, points, paid unlocks, and in-app currencies.
- Subscriptions, memberships, revenue sharing, withdrawals, and creator payouts.
- Contracts, contract applications, contract status, and legal monetization flows.
- Webnovel contests, prize banners, daily rewards, check-in rewards, and gamified earning.
- App download modals and aggressive app promotion overlays.
- Recommendation algorithms beyond simple latest/popular/category lists.
- Complex social feeds, private messaging, inbox, groups, or creator forums.
- Multi-role financial dashboards.
- Any feature requiring sensitive payment compliance before the reading loop is stable.

## Reader Journey

1. Reader lands on Home.
2. Reader browses highlighted novels, categories, and continue-reading items.
3. Reader opens Browse and filters by category, status, popularity, rating, or update recency.
4. Reader opens Novel Details.
5. Reader reviews cover, title, author, category, synopsis, rating, chapters, and reviews.
6. Reader starts the first available chapter.
7. Reader uses Chapter Reader with readable Arabic typography, previous/next controls, and progress saving.
8. Reader saves the novel to Library.
9. Reader returns later through Library or Reading History.
10. Reader rates/reviews the novel or follows the author after signing in.

## Author Journey

1. Author signs in.
2. Author opens Author Dashboard.
3. Author views basic status: total novels, published/draft count, chapters, and recent activity.
4. Author creates a novel with title, Arabic description, category, language, cover, and status.
5. Author edits metadata and manages chapters.
6. Author publishes chapters when ready.
7. Author checks basic analytics: views, saves, ratings, and chapter count.

Future-only author journey:

- Contract application.
- Monetization setup.
- Paid chapters.
- Revenue dashboard.
- Withdrawals.
- Subscription/coin performance.

## Admin Journey

1. Admin signs in with admin role.
2. Admin opens moderation dashboard.
3. Admin reviews reported novels, chapters, comments/reviews, users, and authors.
4. Admin manages categories and sort order.
5. Admin approves, rejects, hides, or archives content.
6. Admin reviews reports and records action notes.
7. Admin audits recent moderation decisions.

## UI Inspiration Notes From Screenshots

### Browse Screens

The browse screenshots show a useful structure: persistent top navigation, genre sidebar, filter chips, sort chips, and compact two-column book results. NOVELFLEX should adopt the information architecture, not the exact styling. The Arabic version should place filters and category navigation in RTL order, with category names and chips optimized for Arabic scanning.

Useful ideas:

- Genre side navigation.
- Filter by content type, status, and sort mode.
- Dense list cards with cover, tags, title, excerpt, rating, chapters, and save action.
- Clear active state for selected genre/filter.

### Novel Detail Screens

The detail screenshots show a strong detail page pattern: large cover, title, author, chapter count, views, rating, primary Read button, Add to Library, report action, About/Table of Contents tabs, synopsis, reviews, and recommendations.

Useful ideas:

- Cover-first hero.
- Strong primary Read action.
- Secondary library action.
- Clear rating and chapter count.
- Tabs for About, Chapters, and Reviews.
- Recommendations below the main content.

### Library And History Screenshot

The history screenshot shows a simple return loop: tabbed Library/History, saved/continued book rows, progress indicator, and continue-reading link. NOVELFLEX should keep this lightweight and avoid clutter.

Useful ideas:

- Separate Library and History tabs.
- Continue reading action.
- Progress display from backend state.
- Account dropdown with sign out.

### Creator Academy Screenshot

The academy screenshot is useful as inspiration for author education and creator guidance, but most contract and monetization content should be future phase only.

Useful ideas:

- Author sidebar navigation.
- Academy/feed page for writing guides.
- Dense list of educational posts.
- Follow/learn-more actions for future community content.

Avoid for MVP:

- Contract application banners.
- Income, privilege, and monetization navigation.
- Reward-driven creator features.

## What Should Be Arabic RTL

- Entire reader-facing app shell.
- Navigation labels and account menu.
- Browse filters and category sidebar.
- Search forms and result metadata.
- Novel titles, descriptions, tags, and author names where Arabic content exists.
- Chapter reader body text, table of contents, previous/next controls.
- Library, history, reviews, ratings, and empty states.
- Author dashboard labels, forms, status badges, and validation messages.
- Admin moderation labels, filters, decisions, reports, and audit messages.
- Date formatting and number formatting where possible.

Arabic RTL implementation principles:

- Text alignment defaults to right.
- Primary reading flow should feel natural from right to left.
- Use Arabic labels that are short and operational.
- Avoid mixing English feature names unless required for brand/provider names such as Google or Apple.
- Preserve English novel titles only when the source content is English.

## What Should NOT Be Copied From Webnovel

- Webnovel logo, brand colors as an exact palette, icon identity, or layout proportions.
- Exact copy, labels, navigation order, and modal wording.
- App download popup patterns.
- Contest/prize banners.
- Coin, points, check-in, rewards, and gamified membership UI.
- Sexualized or low-quality cover presentation patterns.
- Fanfic/IP-heavy positioning that creates copyright or store-compliance risk.
- Overly cluttered desktop whitespace and tiny text density.
- Contract guidance and monetization promises before NOVELFLEX has legal, payment, and creator policy readiness.

NOVELFLEX should borrow product patterns, not brand expression.

## MVP Launch Scope

### In Scope

- Arabic RTL web reader.
- Authenticated and guest discovery.
- Browse categories.
- Search novels.
- Novel details.
- Chapter list and chapter reader.
- Save to library.
- Continue reading.
- Ratings and reviews.
- Follow authors.
- Basic author portal with mock-light or connected publishing surfaces depending backend readiness.
- Basic admin moderation surfaces.
- Responsive mobile and desktop layouts.
- Production empty states for missing content.

### Out Of Scope

- Paid content.
- Creator contracts.
- Wallets, coins, gifts, subscriptions, withdrawals, and revenue.
- Complex recommendation engine.
- Social messaging.
- Contests.
- Native app download conversion modals.
- Advanced analytics beyond basic counts.

### Launch Decision Principle

MVP is ready when the reader loop works end to end with real Supabase data:

Home -> Browse/Search -> Novel Details -> Chapter Reader -> Save -> Continue Reading -> Review/Rating -> Follow Author

Author and Admin can be simpler at launch, but they must not expose incomplete monetization promises. The launch product should be honest, Arabic-first, and stable before it becomes financially complex.
