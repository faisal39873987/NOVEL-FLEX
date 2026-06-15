# NOVELFLEX Legacy API Migration Report

Date: 2026-06-13  
Scope: Static audit only. No code was removed or modified.

> Update 2026-06-15: `ApiUtils` no longer defaults to
> `https://apptocom.com/novelflex2/api/v1`. Legacy REST is disabled by default
> and requires an explicit build flag:
> `--dart-define=ENABLE_LEGACY_API=true --dart-define=LEGACY_API_BASE_URL=...`.
> The remaining `ApiUtils` references are migration targets, not production
> dependencies unless that flag is deliberately enabled.

## Executive Summary

NOVELFLEX still contains active legacy REST usage in the Flutter mobile app under `lib/`. The legacy API surface is centralized in `lib/Utils/ApiUtils.dart` and points to:

```text
https://apptocom.com/novelflex2/api/v1
```

The new web MVP under `web/frontend-ui/` uses Supabase directly and does not depend on the legacy REST API. The older web prototype under `web/novelflex/` also uses Supabase, but it still references legacy-style table names such as `writer_profiles`, `chapters`, `ratings`, and `reading_progress`; those are data model alignment issues, not REST API calls.

One transitional adapter exists:

```text
lib/data/services/supabase_legacy_api_adapter.dart
```

It attempts Supabase first for selected reader features, then falls back to `ApiUtils.ALL_HOME_CATEGORIES_API` when Supabase content is empty, unavailable, or blocked by RLS. This fallback is useful during migration but remains a production dependency on the legacy backend.

## Current Legacy REST Inventory

### Active Endpoints

| Domain | Legacy endpoints currently referenced | Primary files | Supabase replacement |
|---|---|---|---|
| Auth and account status | `/user/check_user_status`, `/user/google/register`, `/home/checkUserType`, `/updata/status` | `lib/UserAuthScreen/login_screen.dart`, `lib/UserAuthScreen/SignUpScreens/*`, `lib/tab_screen.dart`, `lib/TabScreens/Menu_screen.dart`, `lib/MixScreens/ProfileScreens/HomeProfileScreen.dart` | Supabase Auth session, `profiles.role`, `writer_profiles.is_approved` |
| Profile management | `/author/profile`, `/author/update/profile`, `/author/delete/account`, `/author/update/image`, `/author/backgroundImage`, `/tab/userProfile` | `lib/MixScreens/AccountInfoScreen.dart`, `lib/MixScreens/ProfileScreens/HomeProfileScreen.dart`, `lib/TabScreens/Menu_screen.dart` | `profiles`, `writer_profiles`, Supabase Storage buckets for avatar/background, Edge Function for account deletion |
| Home, browse, categories, search | `/home/alldetails`, `/home/categoriesWiseBooksById`, `/author/getByCategories`, `/categories/subcategory`, `/home/subcategory/books`, `/categories/alls`, `/categories/subcategories`, `/home/recently/book/all`, `/home/recently/book` | `lib/data/services/supabase_legacy_api_adapter.dart`, `lib/MixScreens/SeeAllBooksScreen.dart`, `lib/MixScreens/SEARCHSCREENS/*`, `lib/MixScreens/RecentNovelsScreen.dart`, `lib/MixScreens/Uploadscreens/UploadDataScreen.dart` | `categories`, `books`, `profiles`, `writer_profiles`; search service over title, author, category, tags |
| Book and chapter authoring | `/book/add`, `/book/uploadFile`, `/author/bookLinkDetail`, `/author/books/all`, `/book/getBooksById`, `/book/update/book-Image`, `/book/book-update`, `/book/deleteChapter`, `/book/deleteBook`, `/book/uploadAudioFile`, `/book/uploadTextFile`, `/book/update/audio`, `/book/update/text` | `lib/MixScreens/Uploadscreens/*`, `lib/MixScreens/BookEditScreens/BookDetailEditScreen.dart`, `lib/MixScreens/ProfileScreens/HomeProfileScreen.dart`, `lib/MixScreens/BooksScreens/AuthorViewByUserScreen.dart` | `books`, `chapters`, Supabase Storage for covers/files/audio/text |
| Reader playback/content access | `/book/views/add`, `/book/audio`, `/book/text` | `lib/MixScreens/BooksScreens/BookViewTab.dart` | `books.views_count`, `chapters`, Storage signed/public URLs, `reading_progress` |
| Library and reactions | `/book/all-saved`, `/book/all-liked` | `lib/TabScreens/MyCorner.dart` | `favorites`, `book_reactions`, `reading_progress` |
| Follow and author stats | `/user/follow/checkUserStatus`, `/user/follow`, `/user/follow/totalFollower` | `lib/MixScreens/BooksScreens/AuthorViewByUserScreen.dart`, `lib/MixScreens/PieChartScreen.dart` | `follows` plus aggregate query/view/RPC for follower counts |
| Notifications | `/notifications/all`, `/notifications/count`, `/notifications/read?all` | `lib/MixScreens/notification_screen.dart`, `lib/TabScreens/home_screen.dart` | `notifications` table, realtime subscriptions, mark-read mutation |
| Social links and ads | `/social`, `/updata/social`, `/advertisment/add` | `lib/MixScreens/author_profile_links.dart`, `lib/MixScreens/ProfileScreens/HomeProfileScreen.dart` | `writer_profiles.social_links` or normalized author links table; ads should remain future/admin-controlled |
| Monetization and wallet | `/user/subscription`, `/user/subscription/referral`, `/user/subscription/amount`, `/user/subscription/withdrawAmount`, `/user/subscription/userGiftAmount`, `/user/subscription/applyWithdrawAmount`, `/user/follow/totalGifts` | `lib/MixScreens/PayPall/PaymentDoneScreen.dart`, `lib/MixScreens/StripePayment/StripePayment.dart`, `lib/MixScreens/WalletDirectory/*`, `lib/MixScreens/PieChartScreen.dart`, `lib/TabScreens/Menu_screen.dart` | Future monetization layer only: server-side payment provider integration, subscriptions, wallets, withdrawals, gifts; not MVP |

## Active Endpoint Detail

| Constant | Legacy path | Active refs | Migration target |
|---|---:|---:|---|
| `CHECK_STATUS_API` | `/user/check_user_status` | 1 | Supabase Auth + `profiles` |
| `USER_SOCIAL_REGISTER` | `/user/google/register` | 2 | Supabase OAuth Google/Apple |
| `ALL_HOME_CATEGORIES_API` | `/home/alldetails` | 1 | `categories`, `books`; remove adapter fallback after data/RLS are stable |
| `ALL_BOOKS_CATEGORIES_API` | `/home/categoriesWiseBooksById` | 1 | `books` by `category_id` |
| `SEARCH_AUTHOR_BY_CATEGORIES_ID_API` | `/author/getByCategories` | 1 | `authors`/`profiles` joined with `books` and `categories` |
| `GENERAL_CATEGORIES_NAME_API` | `/categories/subcategory` | 1 | `categories` with parent/subcategory strategy |
| `SEARCH_SUB_CATEGORIES_API` | `/home/subcategory/books` | 1 | `books` filtered by category/subcategory |
| `PROFILE_AUTHOR_API` | `/author/profile` | 1 | `profiles`, `authors` |
| `EDIT_PROFILE_` | `/author/update/profile` | 1 | update `profiles`/`authors` |
| `DELETE_ACCOUNT_PROFILE_API` | `/author/delete/account` | 0 active call sites | Replaced by Supabase Edge Function `delete-account` using the current JWT plus service-role cleanup server-side |
| `MAIN_CATEGORIES_DROPDOWN_API` | `/categories/alls` | 1 | `categories` |
| `ADD_IMAGE_WITH_FILED_API` | `/book/add` | 1 | insert `books` + Storage upload |
| `PDF_UPLOAD_API` | `/book/uploadFile` | 2 | insert/update `pdf_files` + Storage upload |
| `DROPDOWN_SUB_CATEGORIES_API` | `/categories/subcategories` | 1 | `categories` parent/child query |
| `AUTHOR_BOOKS_DETAILS_API` | `/author/bookLinkDetail` | 2 | `books` by author + author/profile join |
| `READER_PROFILE_API` | `/book/getReaderProfile` | 1 | `profiles`, `favorites`, `reading_history` |
| `CHECK_PROFILE_STATUS_API` | `/home/checkUserType` | 5 | `profiles.role`, `authors.status` |
| `UPLOAD_BACKGROUND_IMAGE_API` | `/author/backgroundImage` | 1 | Storage + `profiles.background_image_url` or `authors.background_image_url` |
| `SAVED_BOOKS_API` | `/book/all-saved` | 1 | `favorites` |
| `LIKES_BOOKS_API` | `/book/all-liked` | 1 | `book_reactions` |
| `UPLOAD_BOOKS_HISTORY` | `/author/books/all` | 1 | `books` by author |
| `EDIT_BOOKS_API` | `/book/getBooksById` | 2 | `books` detail query |
| `UPLOAD_BOOK_IMAGE` | `/book/update/book-Image` | 1 | Storage + `books.cover_image_url` |
| `UPDATE_FIELDS_BOOK_API` | `/book/book-update` | 1 | update `books` |
| `DELETE_PDF_API` | `/book/deleteChapter` | 1 | delete/update `pdf_files` |
| `DELETE_BOOK_API` | `/book/deleteBook` | 1 | delete/archive `books` |
| `USER_SUBSCRIPTION_API` | `/user/subscription` | 2 | Future monetization only |
| `USER_REFERRAL_API` | `/user/subscription/referral` | 1 | Future referral/monetization only |
| `USER_PAYMENT_API` | `/user/subscription/amount` | 1 | Future wallet only |
| `USER_PAYMENT_WITHDRAW_API` | `/user/subscription/withdrawAmount` | 1 | Future withdrawal only |
| `USER_STATUS_API` | `/user/follow/checkUserStatus` | 1 | `follows` existence query |
| `FOLLOW_AND_UNFOLLOW_API` | `/user/follow` | 1 | insert/delete `follows` |
| `ALL_NOTIFICATIONS` | `/notifications/all` | 1 | `notifications` |
| `NOTIFICATIONS_COUNT` | `/notifications/count` | 1 | `notifications` unread count |
| `SEEN_NOTIFICATIONS_COUNT` | `/notifications/read?all` | 1 | update `notifications.is_read` |
| `ALL_RECENT_API` | `/home/recently/book/all` | 1 | `books.order(created_at)` |
| `RECENT_API` | `/home/recently/book` | 1 | `books.order(created_at).limit()` |
| `PROFILE_IMAGE_UPDATE_API` | `/author/update/image` | 1 | Storage + profile/avatar field |
| `MENU_PROFILE_API` | `/tab/userProfile` | 1 | `profiles` + role-specific summary |
| `BOOK_VIEW_API` | `/book/views/add` | 1 | RPC or update counter on `books` plus read event |
| `GIFT_PAYMENT` | `/user/subscription/userGiftAmount` | 1 | Future gifts/wallet only |
| `PAYMENT_APPLY_API` | `/user/subscription/applyWithdrawAmount` | 1 | Future withdrawals only |
| `TOTAL_FOLLOWERS_API` | `/user/follow/totalFollower` | 1 | count from `follows` |
| `TOTAL_GIFTS_API` | `/user/follow/totalGifts` | 1 | Future gifts/wallet only |
| `AGREEMENT_API` | `/updata/status` | 3 | profile/onboarding agreement status field |
| `UPLOAD_AUDIO_API` | `/book/uploadAudioFile` | 1 | Storage + `pdf_files`/chapter media metadata |
| `UPLOAD_TEXT_BOOK` | `/book/uploadTextFile` | 1 | Storage or chapter content field |
| `GET_AUDIO_BOOK` | `/book/audio` | 1 | `pdf_files`/chapter media metadata |
| `GET_TEXT_BOOK` | `/book/text` | 2 | `pdf_files`/chapter content metadata |
| `UPDATE_AUDIO_BOOK` | `/book/update/audio` | 1 | Storage + chapter media update |
| `UPDATE_TEXT_BOOK` | `/book/update/text` | 1 | chapter content update |
| `GET_LINKS` | `/social` | 1 | `authors.social_links` or `author_links` |
| `UPDATE_LINKS` | `/updata/social` | 1 | update `authors.social_links` or `author_links` |
| `ADD_PRIVATE_ADS_API` | `/advertisment/add` | 1 | Future ads/admin feature only |

## Unused Legacy Endpoint Constants

The following constants are defined in `ApiUtils.dart` but have no active non-commented references in `lib/`:

```text
URL_REGISTER_READER_API
URL_REGISTER_WRITER_API
URL_LOGIN_USER_API
USER_SOCIAL_LOGIN
SEARCH_CATEGORIES_API
BOOK_DETAIL_API
LIKES_AND_DISLIKES_API
AUTHOR_PROFILE_VIEW
SAVE_BOOK_API
STRIPE_PAYMENT_API
FORGET_PASSWORD_API
UPDATE_PASSWORD_API
USER_CHECK_SUBSCRIPTION_API
ALL_CHAPTERS_API
SEARCH_AUTHORS
SLIDER_API
GIFT_API
SEE_ALL_REVIEWS_API
ADD_REVIEW_API
```

Notes:

- `BOOK_DETAIL_API`, `LIKES_AND_DISLIKES_API`, and `SAVE_BOOK_API` appear only inside commented legacy code in `lib/MixScreens/BooksScreens/BookDetailsAuthor.dart`.
- Password reset constants are currently unused; production password recovery should use Supabase Auth reset flow.
- Monetization constants should remain out of MVP and be replaced later by a server-side payment architecture.

## Existing Supabase Replacements

The repository already contains Supabase service/repository work that can replace sections of the legacy REST API:

```text
lib/data/repositories/auth_repository.dart
lib/data/repositories/author_repository.dart
lib/data/repositories/book_repository.dart
lib/data/repositories/category_repository.dart
lib/data/repositories/favorite_repository.dart
lib/data/repositories/profile_repository.dart
lib/data/repositories/storage_repository.dart
lib/data/services/supabase_auth_service.dart
lib/data/services/supabase_database_service.dart
lib/data/services/supabase_storage_service.dart
lib/data/services/supabase_legacy_api_adapter.dart
```

The web MVP also directly uses Supabase tables for:

```text
profiles
authors
books
categories
pdf_files
favorites
reviews
book_reactions
follows
reading_history
notifications
reports
```

## Supabase Replacement Matrix

| Legacy feature | Final Supabase target |
|---|---|
| Email login/register | Supabase Auth email/password |
| Google/Apple login | Supabase Auth OAuth providers |
| User role/profile status | `profiles.role`, `profiles.is_public`, `writer_profiles.is_approved` |
| Author profile | `writer_profiles` + `profiles` |
| Reader profile | `profiles`, `favorites`, `reading_progress` |
| Categories/subcategories | `categories` with final parent/slug model |
| Home/browse/recent | `books`, `categories`, `writer_profiles`/`profiles` |
| Search by category/author/book | Supabase queries or RPC over `books`, `writer_profiles`, `categories`, tags |
| Book creation/edit/delete | `books` with RLS by owner/author |
| Book cover/background/profile images | Supabase Storage |
| PDF/chapter upload | `chapters` plus Storage file metadata |
| Audio/text chapters | Storage + `chapters` metadata/content fields |
| Favorites/library | `favorites` |
| Likes/dislikes | `book_reactions` |
| Reviews/ratings | `ratings` |
| Follow author | `follows` |
| Notifications | `notifications` |
| Reports/moderation | `reports`, admin-only moderation queries |
| Account deletion | Supabase Edge Function with service role |
| Payments/wallet/referrals/gifts | Future monetization schema and provider integration; not MVP |

## Production Blockers Before Removing Legacy APIs

1. Mobile upload flows still use REST multipart endpoints for book covers, chapter files, audio, text, backgrounds, and profile images. These must move to Supabase Storage before REST removal.
2. Some profile, search, author-view, and upload screens still import `ApiUtils`.
3. Account deletion must be implemented as a secure Supabase Edge Function before it can be re-enabled.
4. Monetization/wallet screens are outside MVP and should remain disabled or hidden until a secure future payment architecture exists.

## Migration Order

1. Freeze legacy REST: no new screens should call `ApiUtils`.
2. Keep the public home fallback removed from `SupabaseLegacyApiAdapter`; public catalog must come from Supabase.
3. Migrate auth/profile status calls to Supabase Auth + `profiles`.
4. Migrate reader catalog, book details, library, follows, reactions, reviews, and notifications.
5. Migrate author publishing and media uploads to Supabase Storage + `books` + `chapters`.
6. Replace account deletion with a Supabase Edge Function.
7. Hide or isolate monetization screens until the future monetization architecture is implemented.
8. Delete unused constants, then remove `ApiUtils.dart` and the `http` dependency only after all active references are gone.

## Final Audit Decision

Status: **NOT READY TO REMOVE LEGACY APIs**

Reason: active mobile flows still depend on legacy REST for auth status, profiles, browse/search, author uploads, notifications, wallet/monetization, and content media. The web MVP is already aligned toward Supabase, but the Flutter mobile app remains hybrid.

No code was removed in this audit.
