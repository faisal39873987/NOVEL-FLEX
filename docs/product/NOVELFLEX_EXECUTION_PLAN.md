# NOVELFLEX Execution Plan

تاريخ الفحص: 2026-06-14

## القرار المنتج

NOVELFLEX منصة روايات عربية بأسلوب Webnovel، لكنها ليست نسخة من Webnovel. المنتج الحالي يجب أن يركز على القراءة والكتابة والمكتبة والتفاعل، بدون دفع أو عملات أو اشتراكات في مرحلة الإطلاق.

## الحقيقة الحالية من الباك إند

- Supabase هو المصدر الأساسي للإطلاق.
- `books.author_id` يشير إلى `profiles.id`.
- `chapters.book_id` يشير إلى `books.id`.
- جدول `pdf_files` غير موجود في قاعدة الإنتاج الحالية.
- جدول `chapters` هو جدول الفصول الصحيح حالياً.
- لا توجد Storage buckets حالياً، لذلك رفع أغلفة الكتب/الفصول غير جاهز إنتاجياً.
- كان يوجد مستخدمون في `auth.users` بدون صف في `profiles`، وهذا سبب خطأ:
  `insert or update on table "books" violates foreign key constraint "books_author_id_fkey"`.

## ما تم إصلاحه الآن

- إنشاء backfill لكل مستخدم Auth لا يملك `profiles`.
- إضافة trigger ينشئ `profiles` تلقائياً لأي مستخدم جديد.
- إغلاق تنفيذ دالة إنشاء profile من `anon` و `authenticated` حتى لا تظهر كـ RPC عامة.

## الفرق بين NOVELFLEX و Webnovel

Webnovel يعتمد على روايات نصية مقسمة إلى فصول، مع صفحة تفاصيل قوية، تقييمات، تعليقات، مكتبة، وسجل قراءة.

NOVELFLEX يجب أن يتبع نفس منطق التجربة، لا نفس العلامة:

- القراءة الأساسية: فصول نصية من جدول `chapters.content_text`.
- PDF: خيار مرفق أو استيراد لاحق، وليس أساس القراءة في MVP.
- كل رواية يمكن أن تكون:
  - رواية قصيرة بفصل واحد.
  - رواية طويلة بعدة فصول.
- كل فصل يمكن أن يملك غلافاً اختيارياً لاحقاً، لكن غلاف الرواية إلزامي لتجربة احترافية.

## مواصفات الصور

- غلاف الرواية: نسبة 2:3، مقاس موصى به `1200x1800`، WebP/JPG/PNG، حد مبدئي 2MB.
- صورة الفصل الاختيارية: نسبة 16:9، مقاس موصى به `1600x900`، حد مبدئي 2MB.
- صورة الكاتب: مربعة `512x512`.
- بانر الكاتب: `1600x600`.

## Storage المطلوب قبل رفع حقيقي

Buckets مقترحة:

- `book-covers`: عام للقراءة السريعة.
- `chapter-covers`: عام.
- `author-images`: عام.
- `chapter-files`: خاص، للـ PDF أو ملفات مستقبلية.

## الصفحات الضرورية للإطلاق

### القارئ

- Splash / Loading
- Home
- Browse
- Search
- Novel Details
- Chapter Reader
- Library
- Reading History
- Profile
- Login / Register / Forgot Password
- Support

### الكاتب

- Author Dashboard
- My Novels
- Create Novel
- Edit Novel
- Chapter Manager
- Add/Edit Chapter
- Drafts
- Published
- Basic Analytics

### الإدارة

- Admin Dashboard
- Users
- Writers
- Books
- Chapters
- Comments/Reports
- Categories

## الخدمات التي لا تظهر في MVP

يتم إخفاؤها أو أرشفتها من الواجهة حتى لا نبيع شيئاً غير موجود:

- Payments
- Coins
- Wallet
- Withdrawals
- Subscriptions
- Premium chapters
- Ads monetization
- Contracts
- Revenue sharing

تبقى كخطة مستقبلية فقط، لا تظهر للمستخدم الآن.

## User Flow المطلوب

### Auth

- تسجيل دخول بالبريد.
- إنشاء حساب.
- Google login.
- Apple login.
- Guest mode.
- Logout.
- Forgot password.
- Delete account.
- Session restore.
- Expired token handling.

### Reader

Home -> Browse/Search -> Novel Details -> Chapter Reader -> Add to Library -> Continue Reading -> Rating/Comment

### Author

Login -> Author Dashboard -> Create Novel -> Upload Cover -> Add Chapter -> Draft/Publish -> Edit/Delete -> Analytics

### Admin

Login -> Reports -> Review Book/Chapter/Comment -> Approve/Reject/Remove -> Manage Categories

## ترتيب التنفيذ

1. Backend Stability
   - تثبيت profile sync.
   - إنشاء Storage buckets وسياسات آمنة.
   - توحيد `chapters` كاسم خدمة داخلي ونهائي.

2. Author Upload
   - إصلاح إنشاء الرواية.
   - إضافة/تعديل/حذف الرواية.
   - إضافة/تعديل/حذف الفصول.
   - رفع غلاف الرواية.

3. Reader Engine
   - لا يظهر زر "اقرأ" إلا إذا توجد فصول منشورة.
   - عرض الفصل النصي.
   - حفظ التقدم.
   - السابق/التالي.
   - عدد المشاهدات.

4. Social
   - Library/Favorites.
   - Ratings.
   - Comments.
   - Follow author.

5. Design Polish
   - تطبيق عربي RTL خفيف الخط.
   - Webnovel-like layout بدون نسخ علامة Webnovel.
   - Splash animation.
   - Loading skeletons.
   - Empty states احترافية.
   - صور وأغلفة واقعية.

6. Cleanup
   - أرشفة ملفات payment/wallet/subscription من الواجهة الحالية.
   - إزالة المراجع القديمة بعد تقرير حذف آمن.
   - منع أي حذف مباشر بدون backup.

7. QA / Launch
   - Web desktop/mobile.
   - Android real device.
   - iPhone real device.
   - Auth flows.
   - Create book/chapter.
   - Reader flows.
   - Account deletion.

## فريق العمل المقترح

- Faisal: Product Owner وقرار المنتج النهائي.
- Codex Principal Engineer: قيادة التنفيذ والربط والإطلاق.
- Backend/Supabase Engineer: الجداول، RLS، Storage، Auth.
- Flutter Engineer: التطبيق iOS/Android.
- Web UI Engineer: الموقع وتجربة Webnovel-like.
- Product Designer: RTL، الخط، الحركة، الصور.
- QA Release Engineer: matrix الاختبار قبل الإطلاق.
- Content/Admin Ops: التصنيفات، البلاغات، قبول المحتوى.

## أولويات التنفيذ الفورية

1. اختبار إنشاء رواية بعد إصلاح `profiles`.
2. إنشاء Storage buckets وسياسات رفع الأغلفة.
3. إصلاح web author portal إذا بقي يعتمد على بيانات قديمة.
4. توحيد Flutter services مع `books` و `chapters` الحالية بدل `pdf_files`.
5. إخفاء monetization من الواجهات الحالية.
