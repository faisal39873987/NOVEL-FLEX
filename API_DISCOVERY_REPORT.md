# API DISCOVERY REPORT

## Scope

Audit target: Flutter/Dart code under `lib/`.

Primary API source: `lib/Utils/ApiUtils.dart`.

The app uses direct `http` package calls, a few `MultipartRequest` uploads, and newer Supabase repositories under `lib/data`. This report focuses on the legacy/custom REST API requested in the audit.

## Base API URLs

| Base | Value | Evidence | Notes |
| --- | --- | --- | --- |
| NovelFlex REST API | `https://apptocom.com/novelflex2/api/v1` | `lib/Utils/ApiUtils.dart:3` | Main backend for auth, users, authors, books, payments, notifications, uploads. |
| Google People API | `https://people.googleapis.com/v1/people/me/connections` | `lib/UserAuthScreen/SignUpScreens/signUpScreen_First.dart:64` | Used during Google/social signup flow. |
| PayPal production API | `https://api.paypal.com` | `lib/MixScreens/PayPall/paypall_services.dart:12` | Used for PayPal OAuth/payment execution outside `ApiUtils`. |
| PayPal sandbox API | `https://api.sandbox.paypal.com` | `lib/MixScreens/PayPall/paypall_services.dart:11` | Present but commented. |

## Authorization Methods

| Method | Usage | Evidence |
| --- | --- | --- |
| Bearer token | Most authenticated NovelFlex endpoints use `Authorization: Bearer ${context.read<UserProvider>().UserToken}`. | Examples: `lib/tab_screen.dart:209`, `lib/MixScreens/BooksScreens/BookDetail.dart:598`, `lib/MixScreens/Uploadscreens/UploadDataScreen.dart:737`. |
| Reset token bearer | Password update uses the reset token returned by reset-password email flow. | `lib/UserAuthScreen/FogetPassword/NewPasswordScreen.dart:415`. |
| No auth header | Login, registration, social login/register, home data, forgot password. | `lib/UserAuthScreen/login_screen.dart:692`, `lib/UserAuthScreen/SignUpScreens/signUpScreen_Third.dart:374`, `lib/TabScreens/home_screen.dart:1184`. |
| PayPal bearer token | PayPal payment calls use OAuth access token. | `lib/MixScreens/PayPall/paypall_services.dart:45`, `lib/MixScreens/PayPall/paypall_services.dart:83`. |

Token storage/use:

- `UserModel` parses `access_token` from login response: `lib/Models/UserModel.dart:57`.
- Forgot password response also parses `access_token`: `lib/Models/forgetPasswordModelEmail.dart:61`.
- User token is stored by `UserProvider.setUserToken`: `lib/Provider/UserProvider.dart:47`.

## Hidden Admin Endpoints

No literal `/admin` endpoint was found in `lib/`.

Admin-like or privileged endpoints were found. These are not named `admin`, but they perform destructive, moderation, payment, withdrawal, or privileged author actions:

| Endpoint | Reason | Evidence |
| --- | --- | --- |
| `GET /author/delete/account` | Deletes author/account profile. | `lib/Utils/ApiUtils.dart:19`, `lib/MixScreens/AccountInfoScreen.dart:506`. |
| `POST /book/deleteChapter` | Deletes PDF/chapter. | `lib/Utils/ApiUtils.dart:38`, `lib/MixScreens/Uploadscreens/BookUploadEditTabScreen.dart:736`. |
| `POST /book/deleteBook` | Deletes book. | `lib/Utils/ApiUtils.dart:39`, `lib/MixScreens/Uploadscreens/upload_history_screen.dart:363`. |
| `POST /updata/status` | Agreement/status mutation; spelling suggests legacy backend route. | `lib/Utils/ApiUtils.dart:70`, `lib/tab_screen.dart:399`. |
| `POST /updata/social` | Social link mutation; spelling suggests legacy backend route. | `lib/Utils/ApiUtils.dart:78`, `lib/MixScreens/author_profile_links.dart:576`. |
| `POST /advertisment/add` | Adds private ads/media for author profile. | `lib/Utils/ApiUtils.dart:79`, `lib/MixScreens/ProfileScreens/HomeProfileScreen.dart:1705`. |
| `POST /user/subscription/applyWithdrawAmount` | Applies withdrawal request. | `lib/Utils/ApiUtils.dart:65`, `lib/MixScreens/WalletDirectory/withdrawPaymentScreen.dart:436`. |
| `POST /user/subscription/payment` | Sends raw card fields to backend. | `lib/Utils/ApiUtils.dart:40`, `lib/MixScreens/StripePayment/StripePayment.dart:352`, `lib/MixScreens/StripePayment/GiftScreen.dart:192`. |

## Endpoint Inventory

### Authentication Endpoints

| Endpoint | Method | Auth | Request | Response/model | Evidence |
| --- | --- | --- | --- | --- | --- |
| `POST /user/login` | POST | None | `email`, `password`, `firebase_token` | `UserModel`, includes `user.access_token` | `lib/Utils/ApiUtils.dart:6`, `lib/UserAuthScreen/login_screen.dart:688`, `lib/UserAuthScreen/login_screen.dart:705`. |
| `POST /user/check_user_status` | POST | None observed | `email`, `google_id` | `CheckStatusModel` | `lib/Utils/ApiUtils.dart:7`, `lib/UserAuthScreen/login_screen.dart:732`, `lib/UserAuthScreen/login_screen.dart:749`. |
| `POST /user/google/register` | POST | None | `username`, `email`, `type`, `google_id`, optional `image` | Generic JSON / social register result | `lib/Utils/ApiUtils.dart:8`, `lib/UserAuthScreen/SignUpScreens/signUpScreen_Author.dart:307`, `lib/UserAuthScreen/SignUpScreens/signUpScreen_Third.dart:464`. |
| `POST /user/googlelogin` | POST | None | `email`, `firebase_token` | `UserModel` | `lib/Utils/ApiUtils.dart:9`, `lib/UserAuthScreen/login_screen.dart:833`, `lib/UserAuthScreen/login_screen.dart:852`. |
| `POST /reader/register` | POST | None | `username`, `email`, `phone`, `password`, `confirm_password`, `type=reader` | Generic JSON registration result | `lib/Utils/ApiUtils.dart:4`, `lib/UserAuthScreen/SignUpScreens/signUpScreen_Third.dart:365`. |
| `POST /writer/register` | Multipart POST | None | `username`, `email`, `phone`, `password`, `confirm_password`, `description`, image file | Generic JSON registration result | `lib/Utils/ApiUtils.dart:5`, `lib/UserAuthScreen/SignUpScreens/signUpScreen_Author.dart:250`. |
| `POST /user/reset_password` | POST | None | `email` | `ForgetPasswordModelEmail`, includes `user.access_token` | `lib/Utils/ApiUtils.dart:42`, `lib/UserAuthScreen/FogetPassword/forgetPasswordEmailScreen.dart:342`, `lib/UserAuthScreen/FogetPassword/forgetPasswordEmailScreen.dart:354`. |
| `POST /user/change_password` | POST | Bearer reset token | `password`, `password_confirmation` | `ResetPasswordModel` | `lib/Utils/ApiUtils.dart:43`, `lib/UserAuthScreen/FogetPassword/NewPasswordScreen.dart:407`, `lib/UserAuthScreen/FogetPassword/NewPasswordScreen.dart:427`. |

### User/Profile Endpoints

| Endpoint | Method | Auth | Request | Response/model | Evidence |
| --- | --- | --- | --- | --- | --- |
| `GET /home/checkUserType` | GET | Bearer | None | `StatusCheckModel` | `lib/Utils/ApiUtils.dart:30`, `lib/tab_screen.dart:209`, `lib/TabScreens/Menu_screen.dart:1063`. |
| `GET /tab/userProfile` | GET | Bearer | None | `MenuProfileModel` | `lib/Utils/ApiUtils.dart:61`, `lib/TabScreens/Menu_screen.dart:1086`, `lib/TabScreens/Menu_screen.dart:1095`. |
| `GET /book/getReaderProfile` | GET | Bearer | None | `ReaderProfileModel` | `lib/Utils/ApiUtils.dart:29`, `lib/MixScreens/ProfileScreens/HomeProfileScreen.dart:1190`, `lib/MixScreens/ProfileScreens/HomeProfileScreen.dart:1199`. |
| `GET /author/delete/account` | GET | Bearer | None | Generic JSON | `lib/Utils/ApiUtils.dart:19`, `lib/MixScreens/AccountInfoScreen.dart:506`. |
| `POST /updata/status` | POST | Bearer | No body observed in call sites | Generic JSON | `lib/Utils/ApiUtils.dart:70`, `lib/tab_screen.dart:399`, `lib/TabScreens/Menu_screen.dart:1365`. |
| `GET /notifications/all` | GET | Bearer | None | `NotificationsModel` | `lib/Utils/ApiUtils.dart:51`, `lib/MixScreens/notification_screen.dart:269`, `lib/MixScreens/notification_screen.dart:279`. |
| `GET /notifications/count` | GET | Bearer | None | Raw JSON/count | `lib/Utils/ApiUtils.dart:52`, `lib/TabScreens/home_screen.dart:1158`. |
| `GET /notifications/read?all` | GET | Bearer | Query has `all` flag embedded in URL | Raw JSON | `lib/Utils/ApiUtils.dart:53`, `lib/MixScreens/notification_screen.dart:294`. |

### Author Endpoints

| Endpoint | Method | Auth | Request | Response/model | Evidence |
| --- | --- | --- | --- | --- | --- |
| `GET /author/profile` | GET | Bearer | None | `AuthorProfileEditModel` | `lib/Utils/ApiUtils.dart:17`, `lib/MixScreens/AccountInfoScreen.dart:411`, `lib/MixScreens/AccountInfoScreen.dart:421`. |
| `POST /author/profile` | POST | Bearer | Reused constant for viewed author profile in some screens | `AuthorProfileViewModel` when view screens use related author detail endpoints | `lib/Utils/ApiUtils.dart:22`. |
| `POST /author/update/profile` | POST | Bearer | `username`, `email`, `phone` | Generic JSON | `lib/Utils/ApiUtils.dart:18`, `lib/MixScreens/AccountInfoScreen.dart:472`. |
| `POST /author/update/image` | Multipart POST | Bearer | Profile image file | Generic JSON | `lib/Utils/ApiUtils.dart:60`, `lib/MixScreens/AccountInfoScreen.dart:559`. |
| `POST /author/backgroundImage` | Multipart POST | Bearer | Background image file | Generic JSON | `lib/Utils/ApiUtils.dart:31`, `lib/MixScreens/ProfileScreens/HomeProfileScreen.dart:1246`. |
| `POST /author/bookLinkDetail` | POST | Bearer | `user_id` | `AuthorProfileViewModel` | `lib/Utils/ApiUtils.dart:27`, `lib/MixScreens/BooksScreens/AuthorViewByUserScreen.dart:884`, `lib/MixScreens/ProfileScreens/HomeProfileScreen.dart:1158`. |
| `GET /author/books/all` | GET | Bearer | None | `UploadBooksModel` | `lib/Utils/ApiUtils.dart:34`, `lib/MixScreens/Uploadscreens/upload_history_screen.dart:311`, `lib/MixScreens/Uploadscreens/upload_history_screen.dart:321`. |
| `POST /author/getByCategories` | POST | Bearer | `category_id` | `SearchAuthorbyCategoriesIdModel` | `lib/Utils/ApiUtils.dart:14`, `lib/MixScreens/SEARCHSCREENS/AuthorSearchScreen.dart:454`, `lib/MixScreens/SEARCHSCREENS/AuthorSearchScreen.dart:471`. |
| `GET /author/all` | GET | Bearer | None | `SearchAuthorModel` | `lib/Utils/ApiUtils.dart:54`, `lib/TabScreens/SearchScreen.dart:483`, `lib/TabScreens/SearchScreen.dart:492`. |
| `GET /social` | GET | Bearer | None | `GetSocailLinksModel` | `lib/Utils/ApiUtils.dart:77`, `lib/MixScreens/author_profile_links.dart:646`, `lib/MixScreens/author_profile_links.dart:666`. |
| `POST /updata/social` | POST | Bearer | `facebook_link`, `youtube_link`, `instagram_link`, `twitter_link`, `ticktok_link` | `SocailLinksModel` | `lib/Utils/ApiUtils.dart:78`, `lib/MixScreens/author_profile_links.dart:570`, `lib/MixScreens/author_profile_links.dart:588`. |
| `POST /advertisment/add` | Multipart POST | Bearer | `link`, ad image file | Generic JSON | `lib/Utils/ApiUtils.dart:79`, `lib/MixScreens/ProfileScreens/HomeProfileScreen.dart:1705`. |

### Book Endpoints

| Endpoint | Method | Auth | Request | Response/model | Evidence |
| --- | --- | --- | --- | --- | --- |
| `GET /home/alldetails` | GET | None observed | None | `HomeApiResponse` | `lib/Utils/ApiUtils.dart:10`, `lib/TabScreens/home_screen.dart:1184`, `lib/TabScreens/home_screen.dart:1194`. |
| `POST /home/categoriesWiseBooksById` | POST | Bearer | `category_id` | `SeeAllBooksModelClass` | `lib/Utils/ApiUtils.dart:12`, `lib/MixScreens/SeeAllBooksScreen.dart:260`, `lib/MixScreens/SeeAllBooksScreen.dart:278`. |
| `GET /home/recently/book/all` | GET | Bearer | None | `AllRecentModel` | `lib/Utils/ApiUtils.dart:55`, `lib/MixScreens/RecentNovelsScreen.dart:173`, `lib/MixScreens/RecentNovelsScreen.dart:183`. |
| `GET /recentlyBook` | GET/unknown | Unknown | None observed | Unknown | `lib/Utils/ApiUtils.dart:59`; no direct call found in `lib/`. |
| `POST /book/details` | POST | Bearer | `bookId` | `BookDetailsModel` | `lib/Utils/ApiUtils.dart:20`, `lib/MixScreens/BooksScreens/BookDetail.dart:592`, `lib/MixScreens/BooksScreens/BookDetail.dart:609`. |
| `POST /book/likesDislikes/add` | POST | Bearer | `book_id`, `reader_id`, `status` | `LikeDislikeModel` | `lib/Utils/ApiUtils.dart:21`, `lib/MixScreens/BooksScreens/BookDetail.dart:647`, `lib/MixScreens/BooksScreens/BookDetail.dart:664`. |
| `POST /book/saved` | POST | Bearer | `book_id` | Generic JSON | `lib/Utils/ApiUtils.dart:28`, `lib/MixScreens/BooksScreens/BookDetail.dart:672`. |
| `GET /book/all-saved` | GET | Bearer | None | `SavedBooksModel` | `lib/Utils/ApiUtils.dart:32`, `lib/TabScreens/MyCorner.dart:491`, `lib/TabScreens/MyCorner.dart:501`. |
| `GET /book/all-liked` | GET | Bearer | None | `LikesBooksModel` | `lib/Utils/ApiUtils.dart:33`, `lib/TabScreens/MyCorner.dart:517`, `lib/TabScreens/MyCorner.dart:527`. |
| `POST /book/views/add` | POST | Bearer | `book_id`, `reader_id` | Generic JSON | `lib/Utils/ApiUtils.dart:62`, `lib/MixScreens/BooksScreens/BookViewTab.dart:419`. |
| `POST /book/chapters` | POST | Bearer | `bookId` | `BoolAllPdfViewModelClass` | `lib/Utils/ApiUtils.dart:46`, `lib/MixScreens/BooksScreens/BookViewTab.dart:392`, `lib/MixScreens/BooksScreens/BookViewTab.dart:404`. |
| `POST /book/add` | Multipart POST | Bearer | `title`, `category_id`, `subcategory_id`, `description`, `payment_status`, `language`, cover file | `PostImageOtherFieldModel` | `lib/Utils/ApiUtils.dart:24`, `lib/MixScreens/Uploadscreens/UploadDataScreen.dart:741`, `lib/MixScreens/Uploadscreens/UploadDataScreen.dart:767`. |
| `POST /book/uploadFile` | Multipart POST | Bearer | `book_id`, `lesson`, `pdf_status`, file field `filename` | `PdfUploadModel` | `lib/Utils/ApiUtils.dart:25`, `lib/MixScreens/Uploadscreens/UploadDatanextScreen.dart:394`, `lib/MixScreens/Uploadscreens/BookUploadEditTabScreen.dart:682`. |
| `POST /book/uploadAudioFile` | Multipart POST | Bearer | `book_id`, audio file | Generic JSON | `lib/Utils/ApiUtils.dart:71`, `lib/MixScreens/Uploadscreens/BookUploadEditTabScreen.dart:1083`. |
| `POST /book/uploadTextFile` | POST | Bearer | `book_id`, `description` | Generic JSON | `lib/Utils/ApiUtils.dart:72`, `lib/MixScreens/Uploadscreens/BookUploadEditTabScreen.dart:1274`. |
| `POST /book/audio` | POST | Bearer | `bookId` | `GetAudioBookModel` | `lib/Utils/ApiUtils.dart:73`, `lib/MixScreens/BooksScreens/BookViewTab.dart:611`, `lib/MixScreens/BooksScreens/BookViewTab.dart:622`. |
| `POST /book/text` | POST | Bearer | `bookId` | Text JSON/raw body | `lib/Utils/ApiUtils.dart:74`, `lib/MixScreens/BooksScreens/BookViewTab.dart:843`, `lib/MixScreens/Uploadscreens/BookUploadEditTabScreen.dart:1335`. |
| `POST /book/update/audio` | Multipart POST | Bearer | `bookId`, audio file | Generic JSON | `lib/Utils/ApiUtils.dart:75`, `lib/MixScreens/Uploadscreens/BookUploadEditTabScreen.dart:1132`. |
| `POST /book/update/text` | POST | Bearer | `bookId`, `description` | Generic JSON | `lib/Utils/ApiUtils.dart:76`, `lib/MixScreens/Uploadscreens/BookUploadEditTabScreen.dart:1391`. |
| `POST /book/getBooksById` | POST | Bearer | `bookId` | `BookEditModel` | `lib/Utils/ApiUtils.dart:35`, `lib/MixScreens/BookEditScreens/BookDetailEditScreen.dart:387`, `lib/MixScreens/Uploadscreens/upload_history_screen.dart:446`. |
| `POST /book/book-update` | POST | Bearer | `title`, `category_id`, `subcategory_id`, `description`, `bookId` | Generic JSON | `lib/Utils/ApiUtils.dart:37`, `lib/MixScreens/BookEditScreens/BookDetailEditScreen.dart:437`. |
| `POST /book/update/book-Image` | Multipart POST | Bearer | `bookId`, image file | Generic JSON | `lib/Utils/ApiUtils.dart:36`, `lib/MixScreens/BookEditScreens/BookDetailEditScreen.dart:493`. |
| `POST /book/deleteChapter` | POST | Bearer | `chapterId` | Generic JSON | `lib/Utils/ApiUtils.dart:38`, `lib/MixScreens/Uploadscreens/BookUploadEditTabScreen.dart:733`. |
| `POST /book/deleteBook` | POST | Bearer | `bookId` | Generic JSON | `lib/Utils/ApiUtils.dart:39`, `lib/MixScreens/Uploadscreens/upload_history_screen.dart:361`. |

### Category/Search Endpoints

| Endpoint | Method | Auth | Request | Response/model | Evidence |
| --- | --- | --- | --- | --- | --- |
| `GET /categories/all` | GET | Bearer | None | `SearchCategoriesModel` | `lib/Utils/ApiUtils.dart:13`, `lib/TabScreens/SearchScreen.dart:459`, `lib/TabScreens/SearchScreen.dart:469`. |
| `POST /categories/subcategory` | POST | Bearer | `category_id` | `GeneralCategoriesNameModel` | `lib/Utils/ApiUtils.dart:15`, `lib/MixScreens/SEARCHSCREENS/GeneralCategoriesSearchScreen.dart:305`, `lib/MixScreens/SEARCHSCREENS/GeneralCategoriesSearchScreen.dart:322`. |
| `POST /home/subcategory/books` | POST | Bearer | `subcategory_id` | `SubCategoriesModel` | `lib/Utils/ApiUtils.dart:16`, `lib/MixScreens/SEARCHSCREENS/GeneralCategoriesSearchScreen.dart:395`, `lib/MixScreens/SEARCHSCREENS/GeneralCategoriesSearchScreen.dart:412`. |
| `GET /categories/alls` | GET | Bearer | None | `DropDownCategoriesModel` list | `lib/Utils/ApiUtils.dart:23`, `lib/MixScreens/Uploadscreens/UploadDataScreen.dart:595`, `lib/MixScreens/Uploadscreens/UploadDataScreen.dart:602`. |
| `POST /categories/subcategories` | POST | Bearer | `category_id` | `DropDownSubCategoriesModel` list | `lib/Utils/ApiUtils.dart:26`, `lib/MixScreens/Uploadscreens/UploadDataScreen.dart:662`, `lib/MixScreens/Uploadscreens/UploadDataScreen.dart:675`. |

### Reviews/Comments Endpoints

| Endpoint | Method | Auth | Request | Response/model | Evidence |
| --- | --- | --- | --- | --- | --- |
| `GET/POST /comments` | Unknown in active call sites | Unknown | Likely book id or query params | `BookReviewModel` exists but no active direct call found | `lib/Utils/ApiUtils.dart:68`, `lib/Models/BookReviewModel.dart:7`. |
| `POST /comment/store` | Unknown in active call sites | Unknown | Likely review/comment fields | `AddReviewModel` exists but no active direct call found | `lib/Utils/ApiUtils.dart:69`, `lib/Models/AddReviewModel.dart:7`. |

### Follow/Social/User Status Endpoints

| Endpoint | Method | Auth | Request | Response/model | Evidence |
| --- | --- | --- | --- | --- | --- |
| `POST /user/follow/checkUserStatus` | POST | Bearer | Author/writer id inferred from surrounding screen state | `UserStatusTypeModel` | `lib/Utils/ApiUtils.dart:49`, `lib/MixScreens/BooksScreens/AuthorViewByUserScreen.dart:912`, `lib/MixScreens/BooksScreens/AuthorViewByUserScreen.dart:924`. |
| `POST /user/follow` | POST | Bearer | `writer_id` | Generic JSON | `lib/Utils/ApiUtils.dart:50`, `lib/MixScreens/BooksScreens/AuthorViewByUserScreen.dart:942`. |
| `GET /user/follow/totalFollower` | GET | Bearer | None | Raw JSON/count | `lib/Utils/ApiUtils.dart:66`, `lib/MixScreens/PieChartScreen.dart:237`. |
| `GET /user/follow/totalGifts` | GET | Bearer | None | Raw JSON/count | `lib/Utils/ApiUtils.dart:67`, `lib/MixScreens/PieChartScreen.dart:269`. |

### Subscription, Wallet, Payment Endpoints

| Endpoint | Method | Auth | Request | Response/model | Evidence |
| --- | --- | --- | --- | --- | --- |
| `POST /user/subscription/payment` | POST | Bearer | `cardno`, `month`, `year`, `cvv`, `amount`, `payment_method`, `name` | Raw JSON | `lib/Utils/ApiUtils.dart:40`, `lib/MixScreens/StripePayment/StripePayment.dart:344`, `lib/MixScreens/StripePayment/GiftScreen.dart:184`. |
| `POST /user/subscription` | POST | Bearer | `referral_code` | `SubscriptionModelClass` exists; call uses raw JSON | `lib/Utils/ApiUtils.dart:41`, `lib/MixScreens/StripePayment/StripePayment.dart:377`, `lib/MixScreens/PayPall/PaymentDoneScreen.dart:48`. |
| `GET /user/subscription/referral` | GET | Bearer | None | `UserReferralModel` | `lib/Utils/ApiUtils.dart:44`, `lib/TabScreens/Menu_screen.dart:1154`, `lib/TabScreens/Menu_screen.dart:1167`. |
| `GET/unknown /user/subscription/check` | No active call found | Unknown | Unknown | Unknown | `lib/Utils/ApiUtils.dart:45`. |
| `GET /user/subscription/amount` | GET | Bearer | None | `UserPaymentModel` | `lib/Utils/ApiUtils.dart:47`, `lib/MixScreens/WalletDirectory/MyWalletScreen.dart:258`, `lib/MixScreens/WalletDirectory/MyWalletScreen.dart:266`. |
| `GET /user/subscription/withdrawAmount` | GET | Bearer | None | `UserWithDrawPaymentModel` | `lib/Utils/ApiUtils.dart:48`, `lib/MixScreens/WalletDirectory/MyWalletScreen.dart:279`, `lib/MixScreens/WalletDirectory/MyWalletScreen.dart:288`. |
| `POST /user/subscription/gifts` | POST | Bearer | `user_id`, `amount` | Raw JSON | `lib/Utils/ApiUtils.dart:63`, `lib/MixScreens/StripePayment/GiftScreen.dart:217`. |
| `GET /user/subscription/userGiftAmount` | GET | Bearer | None | `GiftAmountModel` | `lib/Utils/ApiUtils.dart:64`, `lib/MixScreens/WalletDirectory/MyWalletScreen.dart:300`, `lib/MixScreens/WalletDirectory/MyWalletScreen.dart:308`. |
| `POST /user/subscription/applyWithdrawAmount` | POST | Bearer | `iban`, `username`, `father_name` | Raw JSON | `lib/Utils/ApiUtils.dart:65`, `lib/MixScreens/WalletDirectory/withdrawPaymentScreen.dart:432`. |

### Guest/Slider Endpoint

| Endpoint | Method | Auth | Request | Response/model | Evidence |
| --- | --- | --- | --- | --- | --- |
| `GET/unknown /guest` | No active call found | Unknown | Unknown | Unknown | `lib/Utils/ApiUtils.dart:56`. |

## Non-NovelFlex External Endpoints

| Endpoint | Method | Auth | Request/response | Evidence |
| --- | --- | --- | --- | --- |
| `GET https://people.googleapis.com/v1/people/me/connections` | GET | Google OAuth token inferred from Google sign-in flow | Google People API connections response | `lib/UserAuthScreen/SignUpScreens/signUpScreen_First.dart:64`. |
| `POST https://api.paypal.com/v1/oauth2/token?grant_type=client_credentials` | POST | PayPal Basic auth/client credentials inferred | Returns PayPal `access_token` | `lib/MixScreens/PayPall/paypall_services.dart:26`, `lib/MixScreens/PayPall/paypall_services.dart:28`. |
| `POST https://api.paypal.com/v1/payments/payment` | POST | PayPal bearer token | Creates PayPal payment | `lib/MixScreens/PayPall/paypall_services.dart:41`. |
| PayPal execute payment URL | POST | PayPal bearer token | Executes approved PayPal payment | `lib/MixScreens/PayPall/paypall_services.dart:79`. |

## Response Models Found

These Dart models are used to parse API responses:

| Model | Used by endpoint area |
| --- | --- |
| `UserModel` | Login/social login. |
| `CheckStatusModel`, `StatusCheckModel`, `ProfileStatusModel` | User status/profile type. |
| `HomeApiResponse` | Home screen aggregate data. |
| `SearchCategoriesModel`, `GeneralCategoriesNameModel`, `SubCategoriesModel`, `DropDownCategoriesModel`, `DropDownSubCategoriesModel` | Category/search/dropdown APIs. |
| `SearchAuthorModel`, `SearchAuthorbyCategoriesIdModel`, `AuthorProfileEditModel`, `AuthorProfileViewModel`, `AuthorProfileModel` | Author APIs. |
| `BookDetailsModel`, `BookEditModel`, `UploadBooksModel`, `PostImageOtherFieldModel`, `PdfUploadModel`, `UploadMultipleFileModel`, `BoolAllPdfViewModelClass`, `GetAudioBookModel` | Book/PDF/audio/text APIs. |
| `SavedBooksModel`, `LikesBooksModel`, `LikeDislikeModel` | Favorites/likes/book reactions. |
| `ReaderProfileModel`, `MenuProfileModel`, `UserReferralModel` | Reader/menu/profile APIs. |
| `NotificationsModel` | Notifications. |
| `UserPaymentModel`, `UserWithDrawPaymentModel`, `GiftAmountModel`, `SubscriptionModelClass` | Payment/subscription/wallet. |
| `ForgetPasswordModelEmail`, `ResetPasswordModel` | Password reset. |
| `BookReviewModel`, `AddReviewModel` | Reviews/comments, though active call sites were not found in this scan. |
| `SocailLinksModel`, `GetSocailLinksModel` | Social link update/read. |

## Request Content Types

| Type | Endpoints |
| --- | --- |
| Form body via `http.post(... body: map)` | Login, social login/register, categories, book details, likes, saved book, password reset, book update/delete, follows, payment/subscription, text upload/update. |
| Multipart form via `http.MultipartRequest` | Writer registration, book add with cover, PDF upload, audio upload/update, book image update, author profile image, author background image, private ad upload. |
| GET with bearer token | Profile status, notifications, profile/menu, saved/liked books, categories, authors, wallet/payment summaries, followers/gifts. |
| GET without bearer token | Home aggregate `/home/alldetails` observed without headers. |

## Observations and Risks

- The API base URL is hardcoded in `ApiUtils.BASE`; it is not environment-driven.
- Several privileged routes are client-callable with only a bearer token, including account delete, book delete, chapter delete, withdrawal, and ad creation.
- Card data fields (`cardno`, `month`, `year`, `cvv`) are sent directly to `/user/subscription/payment`, which is a high-risk payment architecture unless the backend is PCI-compliant.
- Some route names contain typos (`/updata/status`, `/updata/social`, `/advertisment/add`), which should be preserved during migration only if backward compatibility is required.
- Some constants are defined but no active call site was found: `/user/subscription/check`, `/guest`, `/recentlyBook`, `/comments`, `/comment/store`.
- Commented legacy book detail code remains in `BookDetailsAuthor.dart`; active book detail calls are in `BookDetail.dart`.
