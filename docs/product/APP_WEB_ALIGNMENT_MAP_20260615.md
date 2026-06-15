# NOVELFLEX App/Web Alignment Map

Date: 2026-06-15
Source references: `web/phone-ui/*.png`

Purpose: align the Flutter mobile app, web frontend, backend data, and visual direction before launch. The screenshots are product references only. Do not copy Webnovel branding, mascot, legal text, wallet/store/coins, paid passes, discounts, or mature labels unless NOVELFLEX has the backend, policy, and store-review coverage for them.

## Launch Order

For reader launch QA, use this order:

1. Home / Featured feed
2. Browse / Explore categories
3. Novel details
4. Chapter reader
5. Library and reading history
6. Profile/account
7. Author portal
8. Admin portal

This order catches the most visible problems first: navigation, search, empty content, links, responsiveness, copy, and backend availability.

## App Screens From References

| Ref | App screen | Current Flutter status | Web counterpart | Backend source | Launch decision |
|---|---|---|---|---|---|
| `01_onboarding_preferences.png` | First-run preferences | Present: `PhoneOnboardingPreferencesScreen` | Future `/onboarding` or first visit modal | `categories`; saved locally in `SharedPreferences` | Launch as local first-run preference gate |
| `02_featured_home_top.png` | Featured home top | Present: `PhoneFeaturedScreen` | `/` | `books`, `categories`, `chapters` through `SupabaseLegacyApiAdapter.homeDetails()` | Keep, Arabic/NOVELFLEX copy only |
| `03_featured_home_rankings.png` | Rankings section | Present inside `PhoneFeaturedScreen` | `/`, `/browse?sort=popular` | `books.views_count`, `rating_average`, `ratings_count` | No fake ranking data |
| `04_featured_home_weekly_featured.png` | Weekly featured | Present inside `PhoneFeaturedScreen` | `/` | Published books | Use real published books |
| `05_featured_home_readers_picks.png` | Readers' picks | Present inside `PhoneFeaturedScreen` | `/` | Ratings/favorites if available; fallback published books | Label as picks only if backed by data |
| `06_featured_home_cheering_reads.png` | Rising/cheering reads | Present inside `PhoneFeaturedScreen` | `/` | Recent/high-view books | Avoid paid cheer/vote mechanics |
| `07_featured_home_completed_offer.png` | Completed + offer-like section | Completed present; offers must not launch | `/browse?filter=completed` | `books.status`, `chapters_count` | Remove/avoid discounts/offers |
| `08_featured_home_serialized_highlights.png` | Serialized highlights | Present inside `PhoneFeaturedScreen` | `/` | Recently updated serialized books | OK if real data |
| `09_featured_home_discussion_recommendations.png` | Discussion + recommendations | Discussion panel present, recommendations present | Future community; `/` recommendations | `books`, future comments/discussions | Keep discussion read-only until backend exists |
| `10_featured_home_recommendation_list.png` | Recommendation list | Present inside `PhoneFeaturedScreen` | `/`, `/browse` | Published books; preferences later | OK with real books |
| `11_explore_genre_grid.png` | Explore genre grid | Present: `PhoneExploreScreen` | `/browse`, `/genre/:slug` | `categories`, representative books | Needs parity with web categories |
| `12_profile_top_account_wallet.png` | Profile top/account | Present: `PhoneProfileScreen` | `/profile` | Auth, `profiles`, library/history counts | Remove wallet/store/coins from launch |
| `13_profile_settings_services.png` | Profile settings/support | Present: `PhoneProfileScreen` | `/profile`, support/FAQ | Auth, local dark mode, support link | Use NOVELFLEX support/review copy |

## Flutter Implementation Inventory

| Area | File | Notes |
|---|---|---|
| Bottom shell | `lib/tab_screen.dart` | Tabs: Library, Featured, center writer action, Explore, Profile |
| Featured feed | `lib/phone_ui/phone_featured_screen.dart` | Loads home books via Supabase adapter; builds all feed sections |
| Explore | `lib/phone_ui/phone_explore_screen.dart` | Loads active categories; opens category screen |
| Profile | `lib/phone_ui/phone_profile_screen.dart` | Auth-aware profile hub; removes active wallet/store mechanics |
| Shared UI | `lib/phone_ui/phone_widgets.dart` | Header, rounded panels, covers, cards |
| Onboarding | `lib/phone_ui/phone_onboarding_preferences_screen.dart` | First-run preference selection from active categories |
| Models | `lib/phone_ui/phone_models.dart` | Normalizes legacy/Supabase payloads |
| Backend adapter | `lib/data/services/supabase_legacy_api_adapter.dart` | Prefers Supabase, legacy public content gated by `ENABLE_LEGACY_PUBLIC_CONTENT` |

## Backend Checklist

| Feature | Required tables/storage | Current risk |
|---|---|---|
| Featured feed | `books`, `categories`, `chapters`, cover URLs/storage | Empty Supabase returns empty feed by design |
| Rankings | `books.views_count`, `rating_average`, `ratings_count` | Must not show fake rank claims |
| Explore grid | `categories`, optional representative book covers | Category images may be missing; fallback cover needed |
| Novel details | `books`, `chapters`, `profiles`, `favorites`, `ratings` | Must resolve Flutter numeric IDs to Supabase UUIDs |
| Library | `favorites`, `reading_history` or `reading_progress` | Auth/RLS must be verified with real user |
| Profile | Supabase Auth, `profiles`, `favorites`, `reading_progress`, `ratings`, `follows` | Auth/RLS must be verified with real user |
| Writer entry | Auth, writer role/profile, author portal/upload flow | Center action still checks legacy profile status API |

## Design Rules

- Use NOVELFLEX brand only.
- Arabic-first labels on launch screens.
- Keep black mobile shell, white rounded panels, strong cover imagery.
- Web should not copy mobile one-to-one on desktop, but mobile web should align with the same information architecture.
- Do not launch: coins, top up, fast pass, vouchers, store, purchase history, paid discounts, Webnovel review prompt, Webnovel logo/mascot, R18 labels.

## Next Work Items

1. Replace `tab_screen.dart` center action legacy status check with Supabase role/profile check.
2. Add web/mobile parity smoke test for `/`, `/browse`, `/genre/:slug`, `/profile`.
3. Verify real Supabase data returns enough published books/categories before App Store/TestFlight review.

## Page QA Log

### 1. Home / Featured Feed

Status: checked on 2026-06-15.

| Layer | Result | Notes |
|---|---|---|
| Flutter | Pass with fix | `PhoneFeaturedScreen` loads via `SupabaseLegacyApiAdapter.homeDetails()` and now shows an explicit error state when the backend request fails. |
| Web | Pass with fix | `/` uses the same public reader catalog source and no longer exposes internal `books`/`categories`/RLS wording in empty states. |
| Backend | Conditional pass | Uses published books/categories through Supabase adapter. Before launch, verify real production data has published books with readable chapters and active categories. |
| Design | Pass | No wallet, coins, top-up, store, paid discounts, Webnovel branding, or unsupported purchase mechanics on the featured/home feed. |

Remaining gap: app feed is richer than the desktop web home. This is acceptable for launch if both use the same source data, but the web can later add matching sections such as rankings, weekly picks, and recommendations.

### 0. Onboarding Preferences

Status: checked on 2026-06-15.

| Layer | Result | Notes |
|---|---|---|
| Flutter | Pass with fix | Added `PhoneOnboardingPreferencesScreen` and routed first launch through it before auth/tab handoff. |
| Backend | Pass | Loads active categories through `SupabaseLegacyApiAdapter.searchCategories('')`; falls back to safe local categories if public content is temporarily unavailable. |
| Persistence | Pass | Saves selected category ids/titles and completion flag in `SharedPreferences`. No new table or RLS change required for launch. |
| Design | Pass | Matches the phone reference direction with black shell, large headline, rounded gradient preference cards, and NOVELFLEX branding only. |

Future enhancement: sync preferences to a user profile table after login once the recommendation backend exists.

### 2. Explore / Genres

Status: checked on 2026-06-15.

| Layer | Result | Notes |
|---|---|---|
| Flutter | Pass with fix | `PhoneExploreScreen` loads categories via `SupabaseLegacyApiAdapter.searchCategories('')` and now separates backend error from empty category state. |
| Web | Pass | `/browse` and `/genre/:slug` use the public reader catalog, support filter/sort links, and show a clear unknown-category state. |
| Backend | Conditional pass | Requires active rows in `categories`; category detail navigation resolves Flutter legacy ids through the adapter. |
| Design | Pass | Matches the Explore reference with black shell, side rail, rounded white content area, and genre grid. No unsupported commerce features. |

Remaining gap: representative category cover images depend on category image data. Flutter has a local mini-cover fallback, so launch is not blocked.

### 3. Profile / Account / Settings

Status: checked on 2026-06-15.

| Layer | Result | Notes |
|---|---|---|
| Flutter | Pass with fix | `PhoneProfileScreen` now loads real account metrics for library, reading progress, reviews, and follows when a Supabase user is signed in. |
| Web | Pass with fix | `/profile` now loads the same metric set from Supabase instead of using partial in-memory UI state. |
| Backend | Conditional pass | Requires RLS access for the signed-in user on `favorites`, `reading_progress`, `ratings`, and `follows`. |
| Design | Pass | Wallet/coins/top-up/store/purchase history are not present; support replaces unsupported message/store style actions. |

Remaining gap: profile metrics show `0` for guest/unsigned users by design. Verify a real signed-in user in production before app submission.
