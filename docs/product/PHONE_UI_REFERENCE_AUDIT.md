# NOVELFLEX Phone UI Reference Audit

Date: 2026-06-14
Scope: Flutter mobile app redesign reference audit only.

This document analyzes every phone UI screenshot in `assets/phone-ui` and `web/phone-ui` before implementation. The screenshots are Webnovel-style references, not assets to copy literally. NOVELFLEX must keep its own brand, Arabic/English product voice, backend limits, and launch scope.

## Global Direction

### Product Decision

NOVELFLEX should use a Webnovel-like reading experience:

- Mobile-first.
- Dark app shell on discovery/profile areas.
- Large white rounded content panels.
- Book-cover-heavy browsing.
- Fast search, genre discovery, rankings, and library access.
- Clear writer entry point.
- Chapter-based reading, not PDF-first reading.

NOVELFLEX must not copy:

- Webnovel logo or mascot.
- Webnovel brand text.
- Paid coins, fast pass, store, discounts, top up, vouchers, or purchase history as active services.
- Any App Store review prompt that says "Like Webnovel".
- Any mature/R18 labels unless the backend has moderation and store compliance rules.

### Visual System Extracted

- Background: black `#000000` for shell and discovery pages.
- Content panels: white cards with very large corner radius, approximately 32-44 px.
- Accent: cyan-to-blue/purple gradient underline and call-to-action fills.
- Typography: large, clean sans-serif; headings strong but not excessively bold. For NOVELFLEX use medium/semi-bold weights to avoid the heavy look the current site has.
- Book covers: dominant visual element, usually 2:3 aspect ratio.
- Bottom navigation: fixed, five slots, raised center action/mascot.
- Layout rhythm: thick vertical spacing between panels, no dense dashboard feel.

### Backend Constraints

Use only current product capabilities for launch:

- `profiles`
- `writer_profiles`
- `books`
- `chapters`
- `categories`
- `favorites`
- `reviews`
- `reading_history`
- `book_reactions`
- `follows`

Do not expose payment, wallet, store, premium chapters, coins, withdrawals, or subscriptions until those systems exist in production and pass store review.

## Screenshot Inventory And Target Names

| # | Current screenshot | Target semantic name | Product screen |
|---|---|---|---|
| 01 | `Screenshot 2026-06-13 at 4.32.15 pm.png` | `01_onboarding_preferences.png` | First-run preference onboarding |
| 02 | `Screenshot 2026-06-13 at 4.33.18 pm.png` | `02_featured_home_top.png` | Featured home top |
| 03 | `Screenshot 2026-06-13 at 4.33.21 pm-2.png` | `03_featured_home_rankings.png` | Featured rankings |
| 04 | `Screenshot 2026-06-13 at 4.33.23 pm-3.png` | `04_featured_home_weekly_featured.png` | Weekly featured section |
| 05 | `Screenshot 2026-06-13 at 4.33.25 pm-4.png` | `05_featured_home_readers_picks.png` | Readers' picks section |
| 06 | `Screenshot 2026-06-13 at 4.33.28 pm-5.png` | `06_featured_home_cheering_reads.png` | Cheering reads section |
| 07 | `Screenshot 2026-06-13 at 4.33.30 pm-6.png` | `07_featured_home_completed_offer.png` | Completed novels and offer-like section |
| 08 | `Screenshot 2026-06-13 at 4.33.33 pm-7.png` | `08_featured_home_serialized_highlights.png` | Serialized highlights |
| 09 | `Screenshot 2026-06-13 at 4.33.36 pm-8.png` | `09_featured_home_discussion_recommendations.png` | Discussion card and recommendations |
| 10 | `Screenshot 2026-06-13 at 4.33.41 pm-9.png` | `10_featured_home_recommendation_list.png` | Recommendation list continuation |
| 11 | `Screenshot 2026-06-13 at 4.35.41 pm.png` | `11_explore_genre_grid.png` | Explore and genre discovery |
| 12 | `Screenshot 2026-06-13 at 4.36.19 pm.png` | `12_profile_top_account_wallet.png` | Profile top and account actions |
| 13 | `Screenshot 2026-06-13 at 4.36.21 pm-1.png` | `13_profile_settings_services.png` | Profile settings and support |

## Image 01: First-Run Preference Onboarding

Reference file: `Screenshot 2026-06-13 at 4.32.15 pm.png`

### What The Screen Shows

- Black full-screen onboarding.
- Brand mark at top-left.
- Large headline: choose a preference and start reading.
- Two oversized rounded gradient cards:
  - More Fantasy.
  - More Romance.
- Each card includes tag text, stacked book covers, and a right arrow.
- Legal footer at bottom.

### NOVELFLEX Interpretation

This should become the first-run preference screen for readers. The user selects preferred genres/tags before entering the feed.

### Required Components

- `PhoneOnboardingScreen`
- `PreferenceHeroTitle`
- `PreferenceCard`
- `StackedCoverPreview`
- `LegalFooter`

### Data Needed

- `categories`
- Optional future user preference table or local storage.

### Implementation Notes

- Use NOVELFLEX logo and wording, not Webnovel.
- Arabic-first copy with optional English toggle.
- If user skips, enter home with default recommendations.
- Store locally first; profile persistence can come later.

### Do Not Implement Now

- Cookie settings unless web-specific.
- Webnovel legal copy.

## Image 02: Featured Home Top

Reference file: `Screenshot 2026-06-13 at 4.33.18 pm.png`

### What The Screen Shows

- Black header with small mascot/logo, centered search, globe/language icon.
- Gradient underline under search.
- Top tabs: Novel, New Novel, Comic, Fanfic.
- White rounded shortcut panel with five icon actions.
- White rounded tag panel with active hashtag tab and compact book lists.
- Bottom navigation with Library, Featured, center mascot action, Explore, Profile.

### NOVELFLEX Interpretation

This is the main reader home/feed. It should replace the current app's older home with a book-discovery-first layout.

### Required Components

- `PhoneShellHeader`
- `SearchBarHero`
- `ContentTypeTabs`
- `QuickActionStrip`
- `HashtagBookPanel`
- `CompactBookRow`
- `PhoneBottomNav`

### Data Needed

- Published books with at least one published chapter.
- Categories/tags.
- Cover image.
- Chapter count.

### Implementation Notes

- Use NOVELFLEX tabs: روايات, جديد, تصنيفات, كتّاب.
- Remove WSA/Win-Win if not a real feature.
- Replace "Free" with "مجاني" only if all current platform content is free.

## Image 03: Featured Rankings

Reference file: `Screenshot 2026-06-13 at 4.33.21 pm-2.png`

### What The Screen Shows

- Continuation of Featured home.
- Rankings panel with title and "More".
- Segmented control: Golden and Bestseller.
- Two-column ranking list from 1 to 10.
- Top 3 ranks use colored badges.
- Weekly Featured begins below.

### NOVELFLEX Interpretation

This should be a ranking module inside the home feed. It should be driven by available metrics, not fake monetization.

### Required Components

- `RankingPanel`
- `SegmentedRankingTabs`
- `RankedBookTile`
- `RankBadge`

### Data Needed

- `books.views_count` or equivalent.
- `books.rating_average`.
- `favorites` count if available.

### Implementation Notes

- Golden can become "الأعلى تقييماً".
- Bestseller can become "الأكثر قراءة".
- If metrics are missing, use deterministic fallback ordering and mark as "مختارات".

## Image 04: Weekly Featured

Reference file: `Screenshot 2026-06-13 at 4.33.23 pm-3.png`

### What The Screen Shows

- White rounded section.
- Title "Weekly Featured".
- Two-row grid with four book covers per row.
- Each item has title and genre.
- Full-width gray "Switch" button.
- Readers' Picks starts below.

### NOVELFLEX Interpretation

This should become a reusable featured collection block.

### Required Components

- `CoverGridSection`
- `BookCoverGridItem`
- `SwitchCollectionButton`

### Data Needed

- Books ordered by editorial/recent/fallback.
- Category title.

### Implementation Notes

- "Switch" can refresh the collection or rotate categories.
- Use actual Arabic titles where available.

## Image 05: Readers' Picks

Reference file: `Screenshot 2026-06-13 at 4.33.25 pm-4.png`

### What The Screen Shows

- White rounded "Readers' Picks" card.
- Three-column book grid.
- Larger covers than the weekly section.
- Title and genre under each cover.
- Switch button.

### NOVELFLEX Interpretation

This should be recommendations based on ratings/favorites/reading history. For MVP, it can use reviewed or high-rated books.

### Required Components

- `ReadersPicksSection`
- `LargeBookGridItem`

### Data Needed

- `reviews`
- `favorites`
- `reading_history`
- fallback books.

### Implementation Notes

- If personalization is not available, label it "اختيارات القرّاء".

## Image 06: Cheering Reads

Reference file: `Screenshot 2026-06-13 at 4.33.28 pm-5.png`

### What The Screen Shows

- White rounded card.
- Four-column grid, two rows.
- Book title and category.
- Switch button.
- Completed Novel horizontal row starts below.

### NOVELFLEX Interpretation

This is another reusable collection block. Use it for "روايات تستحق القراءة" or "روايات صاعدة".

### Required Components

- Reuse `CoverGridSection`.
- Reuse `BookCoverGridItem`.

### Data Needed

- Books by recent activity or views.

### Implementation Notes

- Avoid too many identical sections unless data variety exists.

## Image 07: Completed And Offer-Like Section

Reference file: `Screenshot 2026-06-13 at 4.33.30 pm-6.png`

### What The Screen Shows

- Completed Novel horizontal carousel at top.
- Limited Time Offer section with discount badges.
- Offer grid uses large covers and discount labels.

### NOVELFLEX Interpretation

Completed Novel is useful. Limited Time Offer is not launch-ready because monetization is not active.

### Required Components

- `HorizontalBookCarousel`
- `CompletedBooksSection`

### Data Needed

- `books.status = completed` or equivalent.

### Do Not Implement Now

- Discount badges.
- Limited time sale logic.
- Any paid/coin purchase path.

### Replacement

Use "روايات مكتملة" and "مختارات مجانية" instead of offers.

## Image 08: Serialized Highlights

Reference file: `Screenshot 2026-06-13 at 4.33.33 pm-7.png`

### What The Screen Shows

- White rounded section.
- Four-column grid, two rows.
- Switch button.
- Gradient discussion card begins below.

### NOVELFLEX Interpretation

This becomes "روايات متسلسلة" or "قيد النشر".

### Required Components

- Reuse `CoverGridSection`.
- `PublishingStatusBadge`.

### Data Needed

- Books with status `ongoing` or `published`.
- Recent chapter date.

## Image 09: Discussion And Recommendations

Reference file: `Screenshot 2026-06-13 at 4.33.36 pm-8.png`

### What The Screen Shows

- Gradient card "Let's read together".
- Q&A/topic rows.
- "You May Also Like" vertical recommendation list.
- Recommendation row has cover, tags, title, synopsis, category, chapter count, overflow menu.

### NOVELFLEX Interpretation

Discussion can become a future community feature. The recommendation list is launch-relevant.

### Required Components

- `DiscussionPromptCard`
- `RecommendationList`
- `RecommendationBookTile`
- `TagPill`

### Data Needed

- Books.
- Tags/categories.
- Chapter count.
- Future comments/community table if discussion is enabled.

### Do Not Implement Now

- Interactive Q&A/community if no backend table exists.

### Replacement

Display static "أسئلة القرّاء" only if non-clickable, or hide until community is ready.

## Image 10: Recommendation List Continuation

Reference file: `Screenshot 2026-06-13 at 4.33.41 pm-9.png`

### What The Screen Shows

- Long vertical recommendation list.
- Left cover, right metadata.
- Tags at top.
- Title, description, genre, chapter count.
- Three-dot menu.

### NOVELFLEX Interpretation

This should become the standard list layout for search results, category results, and recommendations.

### Required Components

- `BookListTileRich`
- `BookTagRow`
- `BookMetaRow`
- `OverflowBookMenu`

### Data Needed

- `books`
- `categories`
- `chapters_count`
- `rating_average`

### Implementation Notes

- Excellent for Arabic because text area is generous.
- Keep line clamps stable to prevent layout jumping.

## Image 11: Explore Genre Grid

Reference file: `Screenshot 2026-06-13 at 4.35.41 pm.png`

### What The Screen Shows

- Black shell header.
- Search and content-type tabs.
- Left vertical navigation rail.
- White rounded main panel titled "Find Books by Tags".
- Two-column genre grid with cover stacks.
- Bottom nav Explore active.

### NOVELFLEX Interpretation

This should become the mobile Explore tab. It is not the same as the desktop Browse page.

### Required Components

- `ExploreScreen`
- `ExploreSideRail`
- `GenreTileGrid`
- `GenreImageStackTile`

### Data Needed

- `categories`.
- Representative book covers per category.

### Implementation Notes

- Arabic labels first.
- Side rail should use NOVELFLEX features only: تصنيفات, ترتيب, جديد, مكتمل, شائع.
- Remove Golden/Power/Win-Win unless product supports them.

## Image 12: Profile Top

Reference file: `Screenshot 2026-06-13 at 4.36.19 pm.png`

### What The Screen Shows

- Black profile shell.
- Sign In row with avatar.
- Large white wallet card with coins and Top Up.
- Rewards and Store cards.
- Be a writer gradient CTA.
- Menu card: Inbox, My Gear, My Privileges, Purchase History.
- Bottom nav Profile active.

### NOVELFLEX Interpretation

This becomes profile/account hub. Wallet/payment items must be hidden or marked future only.

### Required Components

- `ProfileHeader`
- `AccountStatusCard`
- `WriterCtaCard`
- `ProfileMenuGroup`
- `ProfileMenuItem`

### Data Needed

- Supabase Auth session.
- `profiles`.
- `writer_profiles`.

### Do Not Implement Now

- Coins balance.
- Top Up.
- Store.
- Purchase History.
- Privileges.

### Replacement

- Sign in / account info.
- Become a writer.
- My library.
- My drafts if writer.
- Inbox/notifications if backend supports it.

## Image 13: Profile Settings And Support

Reference file: `Screenshot 2026-06-13 at 4.36.21 pm-1.png`

### What The Screen Shows

- Lower profile menu.
- Redeem.
- Dark Mode toggle.
- Review prompt.
- FAQ.
- Customer Online Service.

### NOVELFLEX Interpretation

This should be settings/support.

### Required Components

- `SettingsGroup`
- `DarkModeToggle`
- `SupportMenuItem`
- `FaqMenuItem`

### Data Needed

- Local preference for dark mode.
- Support email/link.

### Do Not Implement Now

- Redeem.
- Webnovel review text.

### Replacement

- "قيّم NOVELFLEX" with App Store/Play Store link later.
- "تواصل مع الدعم" using configured support email.
- "الأسئلة الشائعة".

## Current Flutter App Mapping

Current relevant files:

- `lib/tab_screen.dart`
  - Current bottom navigation uses four functional pages and asset icons.
  - Required change: move to five-tab NOVELFLEX shell matching the reference.
- `lib/TabScreens/home_screen.dart`
  - Current home should become Featured feed.
- `lib/TabScreens/SearchScreen.dart`
  - Current search/explore should become Explore/Genre.
- `lib/TabScreens/MyCorner.dart`
  - Current library area should map to Library.
- `lib/TabScreens/Menu_screen.dart`
  - Current menu should become Profile.
- `lib/main.dart`
  - Current splash exists but onboarding behavior must be checked before redesign.
- `lib/data/repositories/book_repository.dart`
  - Already uses `books` and `chapters` in parts.
- `lib/data/services/supabase_legacy_api_adapter.dart`
  - Must be handled carefully because some old screens still depend on legacy-shaped data.

## Required App Architecture For This Redesign

### UI Layer

- `PhoneAppShell`
- `PhoneShellHeader`
- `PhoneBottomNav`
- `NovelFlexBookCover`
- `RoundedFeedPanel`
- `BookGridSection`
- `BookRankingSection`
- `BookRecommendationList`
- `ProfileActionGroup`

### Data Layer

For launch, the mobile feed should read from Supabase-facing repositories where possible:

- Home/Featured: `books`, `categories`, `chapters`
- Explore: `categories`, representative `books`
- Profile: Supabase Auth, `profiles`, `writer_profiles`
- Reader: `chapters`, `reading_history`

### Guardrails

- A book should not show "Read" unless it has at least one published chapter.
- PDF should not be the main reading model.
- Payment-related UI stays hidden.
- Empty states must be beautiful and Arabic-first.

## Implementation Order

1. Rename reference images to semantic names.
2. Create mobile design constants:
   - colors
   - typography weights
   - card radius
   - spacing
   - cover aspect ratios
3. Replace bottom navigation shell.
4. Build onboarding preferences.
5. Build Featured home sections from images 02-10.
6. Build Explore/Genre from image 11.
7. Build Profile from images 12-13.
8. Wire sections to existing data without schema changes.
9. Run on real/mobile simulator and capture visual comparison screenshots.

## Launch Scope Decision

### Implement Now

- Preference onboarding.
- Featured feed.
- Rankings based on available metrics.
- Genre explore.
- Library tab.
- Profile/account hub.
- Writer CTA.
- Dark mode toggle if low-risk.
- Support/FAQ links.

### Future Only

- Coins.
- Top Up.
- Store.
- Rewards.
- Redeem.
- Privileges.
- Purchase history.
- Discounts.
- Paid chapters.
- Subscriptions.

## Verification Checklist

Every redesigned screen must pass:

- Screenshot compared to reference.
- No Webnovel branding.
- No broken paid service links.
- Arabic/English copy consistent.
- Real books with covers where available.
- Empty state if data missing.
- App launches on iOS/Android.
- No regression to login, Google, Apple, guest mode.

