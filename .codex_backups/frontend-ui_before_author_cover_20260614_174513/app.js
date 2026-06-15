const genres = [
  { slug: "fantasy", name: "خيال", count: 38 },
  { slug: "romance", name: "رومانسي", count: 25 },
  { slug: "mystery", name: "غموض", count: 18 },
  { slug: "urban", name: "حضري", count: 31 },
  { slug: "historical", name: "تاريخي", count: 16 },
  { slug: "sci-fi", name: "خيال علمي", count: 12 },
];

const books = [
  {
    id: "ink-city",
    title: "مدينة الحبر الأخيرة",
    author: "ليان منصور",
    genre: "خيال",
    genreSlug: "fantasy",
    status: "قيد النشر",
    chapters: 86,
    rating: 4.8,
    reads: "٢.٤ مليون",
    progress: 64,
    tone: "teal",
    summary: "قارئة تكتشف أن رواية قديمة لا تنتهي، وكل فصل جديد يعيد تشكيل المدينة التي تعيش فيها.",
    tags: ["عوالم موازية", "بطلة قوية", "غموض"],
  },
  {
    id: "sand-gate",
    title: "بوابة الرمل",
    author: "ناصر الرومي",
    genre: "تاريخي",
    genreSlug: "historical",
    status: "مكتملة",
    chapters: 124,
    rating: 4.7,
    reads: "١.٨ مليون",
    progress: 28,
    tone: "gold",
    summary: "رحلة بين ممالك عربية قديمة وأسرار لا تظهر إلا حين يختفي آخر ضوء في الصحراء.",
    tags: ["مغامرة", "تراث", "ملحمي"],
  },
  {
    id: "neon-vow",
    title: "وعد النيون",
    author: "سارة البحري",
    genre: "حضري",
    genreSlug: "urban",
    status: "منشورة",
    chapters: 52,
    rating: 4.6,
    reads: "٩٤٠ ألف",
    progress: 0,
    tone: "blue",
    summary: "في مدينة لا تنام، تقود رسالة مشفرة محققا شابا إلى عائلة تخفي نصف تاريخ المدينة.",
    tags: ["تحقيق", "حضري", "تشويق"],
  },
  {
    id: "glass-letters",
    title: "رسائل الزجاج",
    author: "ميرا يونس",
    genre: "رومانسي",
    genreSlug: "romance",
    status: "منشورة",
    chapters: 67,
    rating: 4.5,
    reads: "١.١ مليون",
    progress: 41,
    tone: "rose",
    summary: "تبدأ القصة برسالة بلا توقيع وتنتهي باختيار صعب بين حياة آمنة وحلم قديم.",
    tags: ["رومانسي", "دراما", "بطيء الاشتعال"],
  },
  {
    id: "silent-court",
    title: "المحكمة الصامتة",
    author: "جاد الكيلاني",
    genre: "غموض",
    genreSlug: "mystery",
    status: "مكتملة",
    chapters: 91,
    rating: 4.9,
    reads: "٣.٢ مليون",
    progress: 82,
    tone: "ink",
    summary: "قاضية سابقة تعود لقضية ظنت أنها انتهت، لتجد أن الشهود اختفوا في الليلة نفسها.",
    tags: ["جريمة", "قضاء", "تشويق"],
  },
  {
    id: "orbit-nine",
    title: "مدار تسعة",
    author: "آدم سليم",
    genre: "خيال علمي",
    genreSlug: "sci-fi",
    status: "منشورة",
    chapters: 44,
    rating: 4.4,
    reads: "٦١٠ ألف",
    progress: 0,
    tone: "violet",
    summary: "طاقم صغير في محطة بعيدة يكتشف أن الإشارة التي ينتظرونها منذ سنوات ليست بشرية.",
    tags: ["فضاء", "نجاة", "تقنية"],
  },
];

const chapters = [
  { id: "c1", number: 1, title: "الصفحة التي لم تكتب", status: "منشور", reads: "٤٢ ألف" },
  { id: "c2", number: 2, title: "شارع الورق", status: "منشور", reads: "٣٨ ألف" },
  { id: "c3", number: 3, title: "حبر تحت المطر", status: "منشور", reads: "٣٣ ألف" },
  { id: "c4", number: 4, title: "رسالة من آخر المدينة", status: "منشور", reads: "٢٩ ألف" },
];

const reviews = [
  { name: "مها القارئة", rating: 5, text: "الإيقاع ممتاز والشخصيات واضحة. كل فصل يترك سؤالا جديدا.", meta: "قبل ساعتين" },
  { name: "عبدالله", rating: 4, text: "لغة جميلة وبناء مشوق. أعجبني أن تفاصيل العالم تظهر تدريجيا.", meta: "أمس" },
];

const authorNovels = [
  { ...books[0], draft: false, updated: "اليوم", approval: "منشور" },
  { ...books[2], draft: false, updated: "أمس", approval: "قيد المراجعة" },
  { ...books[5], draft: true, updated: "قبل ٣ أيام", approval: "مسودة" },
];

const academyPosts = [
  { title: "كيف تبني افتتاحية تجذب القارئ العربي", type: "دليل كتابة", time: "٨ دقائق" },
  { title: "مراجعة الفصل قبل النشر", type: "قائمة تدقيق", time: "٥ دقائق" },
  { title: "العقود والدخل مرحلة مستقبلية فقط", type: "تنبيه منتج", time: "٣ دقائق" },
];

const appState = {
  saved: new Set(),
  routeMessage: "",
  authMessage: "",
  authBusy: false,
  reading: {
    loaded: false,
    loading: false,
    saving: false,
    error: "",
    historyError: "",
    message: "",
    favorites: [],
    history: [],
    favoriteIds: new Set(),
    progressByChapter: new Map(),
  },
  social: {
    loadedBooks: new Set(),
    loadingBooks: new Set(),
    saving: false,
    message: "",
    reviewErrors: new Map(),
    reactionErrors: new Map(),
    followErrors: new Map(),
    reviewsByBook: new Map(),
    reactionsByBook: new Map(),
    followsByAuthor: new Map(),
  },
  notifications: {
    loaded: false,
    loading: false,
    error: "",
    items: [],
  },
  reader: {
    loaded: false,
    loading: false,
    error: "",
    categories: [],
    books: [],
    profiles: [],
    authors: [],
    authorTableStatus: "unchecked",
    chapterSource: "chapters",
    tableIssues: [],
    chaptersByBook: new Map(),
    chapterErrors: new Map(),
    loadingChapters: new Set(),
    searchResults: new Map(),
    searchLoading: new Set(),
    searchErrors: new Map(),
  },
  authorPortal: {
    loaded: false,
    loading: false,
    saving: false,
    error: "",
    message: "",
    profile: null,
    author: null,
    authorTableStatus: "unchecked",
    tableIssues: [],
    categories: [],
    novels: [],
    chaptersByBook: new Map(),
    chapterErrors: new Map(),
    loadingChapters: new Set(),
  },
  adminPortal: {
    loaded: false,
    loading: false,
    saving: false,
    error: "",
    message: "",
    profile: null,
    tableErrors: {},
    profiles: [],
    authors: [],
    books: [],
    reviews: [],
    reports: [],
    categories: [],
  },
  auth: {
    ready: false,
    session: null,
    user: null,
    isGuest: false,
    lastError: "",
  },
};

const escapeHtml = (value) =>
  String(value)
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#039;");

const dual = (ar, _en) => ar;

const routeToHash = (path) => `#${path}`;

function getRoute() {
  const raw = window.location.hash.slice(1) || "/";
  if (
    raw.startsWith("access_token=") ||
    raw.startsWith("refresh_token=") ||
    raw.startsWith("expires_in=") ||
    raw.startsWith("error=") ||
    raw.startsWith("code=")
  ) {
    return { path: "/auth/callback", params: new URLSearchParams() };
  }
  const [path, queryString = ""] = raw.split("?");
  return { path: path || "/", params: new URLSearchParams(queryString) };
}

function findBook(id) {
  return books.find((book) => book.id === id) || books[0];
}

function authApi() {
  return window.NovelFlexAuth || null;
}

function supabaseClient() {
  return authApi()?.client || null;
}

function syncAuthState(nextState = {}) {
  appState.auth = {
    ...appState.auth,
    ...nextState,
  };
}

function getDisplayName() {
  const auth = authApi();
  if (auth?.displayName) return auth.displayName();
  const metadata = appState.auth.user?.user_metadata || {};
  return (
    metadata.username ||
    metadata.name ||
    metadata.full_name ||
    appState.auth.user?.email?.split("@")[0] ||
    (appState.auth.isGuest ? "ضيف" : "زائر")
  );
}

function getAvatarLetter() {
  return getDisplayName().trim().charAt(0) || "ن";
}

function authStatusLabel() {
  if (!appState.auth.ready) return "جار التحقق";
  if (appState.auth.user) return "حساب نشط";
  if (appState.auth.isGuest) return "وضع الضيف";
  return "زائر";
}

function isMissingTableError(error) {
  return error?.code === "PGRST205" || /Could not find the table/i.test(error?.message || "");
}

function markReaderIssue(issue) {
  if (!appState.reader.tableIssues.includes(issue)) appState.reader.tableIssues.push(issue);
}

function resetReadingFeatures() {
  appState.reading.loaded = false;
  appState.reading.loading = false;
  appState.reading.saving = false;
  appState.reading.error = "";
  appState.reading.historyError = "";
  appState.reading.message = "";
  appState.reading.favorites = [];
  appState.reading.history = [];
  appState.reading.favoriteIds = new Set();
  appState.reading.progressByChapter = new Map();
  appState.saved = new Set();
}

function resetSocialFeatures() {
  appState.social.loadedBooks = new Set();
  appState.social.loadingBooks = new Set();
  appState.social.saving = false;
  appState.social.message = "";
  appState.social.reviewErrors = new Map();
  appState.social.reactionErrors = new Map();
  appState.social.followErrors = new Map();
  appState.social.reviewsByBook = new Map();
  appState.social.reactionsByBook = new Map();
  appState.social.followsByAuthor = new Map();
}

function resetNotifications() {
  appState.notifications.loaded = false;
  appState.notifications.loading = false;
  appState.notifications.error = "";
  appState.notifications.items = [];
}

function resetAdminPortal() {
  appState.adminPortal.loaded = false;
  appState.adminPortal.loading = false;
  appState.adminPortal.saving = false;
  appState.adminPortal.error = "";
  appState.adminPortal.message = "";
  appState.adminPortal.profile = null;
  appState.adminPortal.tableErrors = {};
  appState.adminPortal.profiles = [];
  appState.adminPortal.authors = [];
  appState.adminPortal.books = [];
  appState.adminPortal.reviews = [];
  appState.adminPortal.reports = [];
  appState.adminPortal.categories = [];
}

function isAdminUser() {
  return appState.adminPortal.profile?.role === "admin";
}

function recordAdminTableError(table, result) {
  if (result?.error) appState.adminPortal.tableErrors[table] = result.error.message || `تعذر تحميل ${table}.`;
}

async function loadAdminPortal({ force = false } = {}) {
  const user = appState.auth.user;
  if (!user) {
    resetAdminPortal();
    appState.adminPortal.loaded = true;
    return;
  }
  if (appState.adminPortal.loading) return;
  if (appState.adminPortal.loaded && !force) return;

  const client = supabaseClient();
  if (!client) {
    appState.adminPortal.error = "Supabase client غير جاهز.";
    appState.adminPortal.loaded = true;
    route();
    return;
  }

  appState.adminPortal.loading = true;
  appState.adminPortal.error = "";
  appState.adminPortal.tableErrors = {};
  route();

  try {
    const profileResult = await client
      .from("profiles")
      .select("id,role,display_name,username,avatar_url,bio,is_public,created_at")
      .eq("id", user.id)
      .limit(1);
    if (profileResult.error) throw profileResult.error;
    appState.adminPortal.profile = profileResult.data?.[0] || null;
    if (!isAdminUser()) {
      appState.adminPortal.error = "حسابك الحالي ليس admin في جدول profiles.";
      appState.adminPortal.loaded = true;
      return;
    }

    const [profilesResult, authorsResult, booksResult, reviewsResult, reportsResult, categoriesResult] = await Promise.all([
      client.from("profiles").select("id,role,display_name,username,is_public,created_at").order("created_at", { ascending: false }).limit(100),
      client.from("writer_profiles").select("id,user_id,pen_name,bio_ar,bio_en,is_approved,created_at,updated_at,profile:profiles!writer_profiles_user_id_fkey(id,display_name,username,avatar_url)").limit(100),
      client
        .from("books")
        .select("id,author_id,category_id,title_ar,title_en,status,language,chapters_count,created_at,updated_at,category:categories!books_category_id_fkey(id,slug,name_ar),author:profiles!books_author_id_fkey(id,display_name,username)")
        .order("created_at", { ascending: false })
        .limit(100),
      client.from("ratings").select("id,book_id,user_id,rating,review,created_at").order("created_at", { ascending: false }).limit(100),
      client.from("reports").select("*").limit(100),
      client.from("categories").select("id,slug,name_ar,name_en,is_active,sort_order,created_at").order("sort_order", { ascending: true }).limit(100),
    ]);

    recordAdminTableError("writer_profiles", authorsResult);
    recordAdminTableError("books", booksResult);
    recordAdminTableError("ratings", reviewsResult);
    recordAdminTableError("reports", reportsResult);
    recordAdminTableError("categories", categoriesResult);
    recordAdminTableError("profiles", profilesResult);

    appState.adminPortal.profiles = profilesResult.data || [];
    appState.adminPortal.authors = authorsResult.data || [];
    appState.adminPortal.books = (booksResult.data || []).map(normalizeAuthorNovel);
    appState.adminPortal.reviews = reviewsResult.data || [];
    appState.adminPortal.reports = reportsResult.data || [];
    appState.adminPortal.categories = (categoriesResult.data || []).map(normalizeCategory);
    appState.adminPortal.loaded = true;
  } catch (error) {
    appState.adminPortal.error = error.message || "تعذر تحميل لوحة الإدارة.";
    appState.adminPortal.loaded = true;
  } finally {
    appState.adminPortal.loading = false;
    route();
  }
}

async function runAdminAction(action, successMessage) {
  const client = supabaseClient();
  if (!client || !isAdminUser()) {
    appState.adminPortal.message = "صلاحية الإدارة غير متاحة.";
    route();
    return;
  }
  appState.adminPortal.saving = true;
  appState.adminPortal.message = "";
  route();
  try {
    const result = await action(client);
    if (result?.error) throw result.error;
    appState.adminPortal.message = successMessage;
    appState.adminPortal.loaded = false;
    await loadAdminPortal({ force: true });
  } catch (error) {
    appState.adminPortal.message = error.message || "تعذر تنفيذ إجراء الإدارة.";
  } finally {
    appState.adminPortal.saving = false;
    route();
  }
}

function updateAdminUserRole(userId, role) {
  return runAdminAction(
    (client) => client.from("profiles").update({ role }).eq("id", userId),
    "تم تحديث دور المستخدم.",
  );
}

function toggleAdminUserVisibility(userId, isPublic) {
  return runAdminAction(
    (client) => client.from("profiles").update({ is_public: isPublic }).eq("id", userId),
    "تم تحديث ظهور المستخدم.",
  );
}

function updateAdminBookStatus(bookId, status) {
  return runAdminAction(
    (client) => client.from("books").update({ status }).eq("id", bookId),
    "تم تحديث حالة الرواية.",
  );
}

function updateAdminReportStatus(reportId, status) {
  return runAdminAction(
    (client) => client.from("reports").update({ status }).eq("id", reportId),
    "تم تحديث البلاغ.",
  );
}

function updateAdminCategory(form) {
  const formData = new FormData(form);
  const id = form.getAttribute("data-admin-category-form");
  return runAdminAction(
    (client) =>
      client
        .from("categories")
        .update({
          name_ar: String(formData.get("name_ar") || "").trim(),
          slug: String(formData.get("slug") || "").trim(),
          sort_order: Number(formData.get("sort_order") || 0),
          is_active: formData.get("is_active") === "true",
        })
        .eq("id", id),
    "تم تحديث التصنيف.",
  );
}

function normalizeNotification(row = {}) {
  const data = row.data || {};
  return {
    id: row.id,
    userId: row.user_id,
    type: row.type || data.type || "notification",
    title: row.title_ar || row.title_en || data.title || data.title_ar || "إشعار جديد",
    body: row.body_ar || row.body_en || data.body || data.body_ar || "",
    isRead: Boolean(row.is_read),
    createdAt: row.created_at || "",
    data,
  };
}

function unreadNotificationCount() {
  return appState.notifications.items.filter((item) => !item.isRead).length;
}

async function loadNotifications({ force = false } = {}) {
  const user = appState.auth.user;
  if (!user) {
    resetNotifications();
    appState.notifications.loaded = true;
    return;
  }
  if (appState.notifications.loading) return;
  if (appState.notifications.loaded && !force) return;

  const client = supabaseClient();
  if (!client) return;

  appState.notifications.loading = true;
  appState.notifications.error = "";
  route();

  try {
    const { data, error } = await client
      .from("notifications")
      .select("id,user_id,type,title_ar,title_en,body_ar,body_en,data,is_read,created_at")
      .eq("user_id", user.id)
      .order("created_at", { ascending: false })
      .limit(20);
    if (error) throw error;
    appState.notifications.items = (data || []).map(normalizeNotification);
    appState.notifications.loaded = true;
  } catch (error) {
    appState.notifications.error = error.message || "تعذر تحميل الإشعارات.";
    appState.notifications.loaded = true;
  } finally {
    appState.notifications.loading = false;
    route();
  }
}

async function createNotification(userId, type, data = {}) {
  const client = supabaseClient();
  if (!client || !userId) return;
  const typeMap = {
    new_chapter_published: "chapter_published",
    new_review: "comment",
    new_follower: "follow",
  };
  try {
    const { error } = await client.from("notifications").insert({
      user_id: userId,
      type: typeMap[type] || type || "system",
      title_ar: data.title || data.title_ar || "إشعار جديد",
      body_ar: data.body || data.body_ar || "",
      data: { ...data, type },
      is_read: false,
    });
    if (error) throw error;
  } catch (error) {
    appState.notifications.error = error.message || "تعذر إنشاء الإشعار.";
  }
}

async function notifyNewChapterPublished(book, chapter) {
  const client = supabaseClient();
  const authorId = book?.authorId || appState.auth.user?.id;
  if (!client || !authorId || !chapter) return;
  try {
    const { data, error } = await client.from("follows").select("follower_id").eq("author_id", authorId).limit(500);
    if (error) throw error;
    await Promise.all(
      (data || []).map((follow) =>
        createNotification(follow.follower_id, "new_chapter_published", {
          title: "فصل جديد",
          body: `تم نشر فصل جديد في ${book?.title || "رواية تتابعها"}.`,
          book_id: book?.id,
          chapter_id: chapter?.id,
          author_id: authorId,
        }),
      ),
    );
  } catch (error) {
    appState.notifications.error = error.message || "تعذر إرسال إشعار الفصل الجديد.";
  }
}

async function notifyNewReview(book, reviewText) {
  const authorId = book?.authorId;
  if (!authorId || authorId === appState.auth.user?.id) return;
  await createNotification(authorId, "new_review", {
    title: "مراجعة جديدة",
    body: `وصلت مراجعة جديدة على ${book?.title || "إحدى رواياتك"}.`,
    book_id: book?.id,
    preview: reviewText.slice(0, 120),
  });
}

async function notifyNewFollower(authorId) {
  if (!authorId || authorId === appState.auth.user?.id) return;
  await createNotification(authorId, "new_follower", {
    title: "متابع جديد",
    body: `${getDisplayName()} بدأ متابعة حسابك.`,
    follower_id: appState.auth.user?.id,
  });
}

function formatCount(value, fallback = "٠") {
  const number = Number(value || 0);
  if (!number) return fallback;
  if (number >= 1000000) return `${(number / 1000000).toFixed(1)}م`;
  if (number >= 1000) return `${Math.round(number / 1000)} ألف`;
  return new Intl.NumberFormat("ar").format(number);
}

function normalizeCategory(row = {}) {
  return {
    id: row.id,
    slug: row.slug || row.id,
    name: row.name_ar || row.name_en || row.name || "تصنيف",
    description: row.description_ar || row.description_en || "",
    count: 0,
    isActive: row.is_active !== false,
    sortOrder: row.sort_order || 0,
  };
}

function normalizeProfile(row = {}) {
  return {
    id: row.id,
    name: row.display_name || row.username || row.pen_name || "كاتب NOVELFLEX",
    username: row.username || "",
    avatarUrl: row.avatar_url || "",
    bio: row.bio || row.bio_ar || row.bio_en || "",
  };
}

function normalizeBook(row = {}) {
  const category = normalizeCategory(row.category || {});
  const author = normalizeProfile(row.author || row.profile || {});
  const title = row.title_ar || row.title_en || row.title || "رواية بدون عنوان";
  return {
    id: row.id,
    authorId: row.author_id,
    categoryId: row.category_id,
    title,
    author: author.name,
    genre: category.name || "روايات",
    genreSlug: category.slug || row.category_id || "novels",
    status: row.status === "completed" ? "مكتملة" : "منشورة",
    chapters: Number(row.chapters_count || row.chapter_count || 0),
    rating: Number(row.rating_average || row.rating || 0) || 4.5,
    ratingsCount: Number(row.ratings_count || 0),
    reads: formatCount(row.views_count || row.reads_count || 0),
    progress: 0,
    tone: "teal",
    summary: row.description_ar || row.description_en || row.summary || "لا يوجد وصف منشور لهذه الرواية بعد.",
    tags: [category.name || "روايات", row.language || "ar"].filter(Boolean),
    coverUrl: row.cover_url || "",
    publishedAt: row.published_at || row.created_at || "",
  };
}

function normalizeChapter(row = {}) {
  const number = Number(row.chapter_number || row.order_index || row.number || 1);
  return {
    id: row.id,
    bookId: row.book_id,
    number,
    title: row.title_ar || row.title_en || row.title || `الفصل ${number}`,
    status: row.status === "published" || !row.status ? "منشور" : row.status,
    reads: formatCount(row.views_count || row.reads_count || 0, "جاهز"),
    content:
      row.content_text ||
      row.text_content ||
      row.description_ar ||
      row.description ||
      "هذا الفصل متاح كملف قراءة في Supabase. سيتم عرض محتوى الملف الكامل عند اكتمال طبقة التخزين.",
    filePath: row.file_path || row.pdf_url || row.url || "",
    publishedAt: row.published_at || row.created_at || "",
  };
}

function readerBooks() {
  return appState.reader.loaded && appState.reader.books.length ? appState.reader.books : books;
}

function readerCategories() {
  if (!appState.reader.loaded) return genres;
  if (!appState.reader.books.length) return genres;
  const counts = new Map();
  appState.reader.books.forEach((book) => counts.set(book.genreSlug, (counts.get(book.genreSlug) || 0) + 1));
  return appState.reader.categories.map((category) => ({
    ...category,
    count: counts.get(category.slug) || 0,
  }));
}

function findReaderBook(id) {
  return readerBooks().find((book) => book.id === id) || null;
}

function hydrateReadingBook(bookId, joinedBook = null) {
  if (joinedBook) return normalizeBook(joinedBook);
  return findReaderBook(bookId) || books.find((book) => book.id === bookId) || {
    id: bookId,
    title: "رواية غير محملة",
    author: "NOVELFLEX",
    genre: "روايات",
    genreSlug: "novels",
    status: "منشورة",
    chapters: 0,
    rating: 0,
    reads: "٠",
    progress: 0,
    tone: "ink",
    summary: "لم يتم تحميل بيانات هذه الرواية بعد.",
    tags: ["روايات"],
  };
}

function normalizeFavorite(row = {}) {
  return {
    id: row.id,
    bookId: row.book_id,
    createdAt: row.created_at || "",
    book: hydrateReadingBook(row.book_id, row.book),
  };
}

function normalizeHistory(row = {}) {
  const progress = Number(row.progress_percent || row.progress || row.last_position?.percent || 0);
  return {
    id: row.id,
    bookId: row.book_id,
    chapterId: row.chapter_id,
    progress,
    lastReadAt: row.last_read_at || row.updated_at || row.created_at || "",
    book: hydrateReadingBook(row.book_id, row.book),
  };
}

function readingProgressKey(bookId, chapterId) {
  return `${bookId}:${chapterId}`;
}

function readingResumeHref(item) {
  if (item.chapterId) return `#/novels/${item.bookId}/chapters/${item.chapterId}`;
  return `#/novels/${item.bookId}`;
}

async function loadReadingFeatures({ force = false } = {}) {
  const user = appState.auth.user;
  if (!user) {
    resetReadingFeatures();
    appState.reading.loaded = true;
    return;
  }
  if (appState.reading.loading) return;
  if (appState.reading.loaded && !force) return;

  const client = supabaseClient();
  if (!client) {
    appState.reading.error = "Supabase client غير جاهز.";
    appState.reading.loaded = true;
    route();
    return;
  }

  appState.reading.loading = true;
  appState.reading.error = "";
  appState.reading.historyError = "";
  route();

  try {
    const favoritesResult = await client
      .from("favorites")
      .select("id,user_id,book_id,created_at")
      .eq("user_id", user.id)
      .order("created_at", { ascending: false });
    if (favoritesResult.error) throw favoritesResult.error;

    appState.reading.favorites = (favoritesResult.data || []).map(normalizeFavorite);
    appState.reading.favoriteIds = new Set(appState.reading.favorites.map((item) => item.bookId));
    appState.saved = new Set(appState.reading.favoriteIds);

    const historyResult = await client
      .from("reading_progress")
      .select("id,user_id,book_id,chapter_id,progress_percent,last_position,last_read_at,created_at,updated_at")
      .eq("user_id", user.id)
      .order("last_read_at", { ascending: false });

    if (historyResult.error) {
      appState.reading.historyError = historyResult.error.message || "تعذر تحميل reading_progress.";
    } else {
      appState.reading.history = (historyResult.data || []).map(normalizeHistory);
      appState.reading.progressByChapter = new Map(
        appState.reading.history
          .filter((item) => item.bookId && item.chapterId)
          .map((item) => [readingProgressKey(item.bookId, item.chapterId), item.progress]),
      );
    }

    appState.reading.loaded = true;
  } catch (error) {
    appState.reading.error = error.message || "تعذر تحميل ميزات القراءة.";
    appState.reading.loaded = true;
  } finally {
    appState.reading.loading = false;
    route();
  }
}

async function toggleLibraryBook(bookId) {
  const user = appState.auth.user;
  if (!user) {
    appState.routeMessage = "سجل الدخول لإضافة الرواية إلى المكتبة.";
    window.location.hash = "/auth/login";
    return;
  }
  const client = supabaseClient();
  if (!client) return;

  appState.reading.saving = true;
  appState.routeMessage = "";
  route();

  try {
    const isSaved = appState.reading.favoriteIds.has(bookId);
    const result = isSaved
      ? await client.from("favorites").delete().eq("user_id", user.id).eq("book_id", bookId)
      : await client.from("favorites").insert({ user_id: user.id, book_id: bookId });
    if (result.error) throw result.error;

    appState.routeMessage = isSaved ? "تمت إزالة الرواية من المكتبة." : "تمت إضافة الرواية إلى المكتبة.";
    appState.reading.loaded = false;
    await loadReadingFeatures({ force: true });
  } catch (error) {
    appState.routeMessage = error.message || "تعذر تحديث المكتبة.";
  } finally {
    appState.reading.saving = false;
    route();
  }
}

async function saveReadingProgress(bookId, chapterId, progress = 65) {
  const user = appState.auth.user;
  const client = supabaseClient();
  if (!user || !client || !bookId || !chapterId) return;

  const payload = {
    user_id: user.id,
    book_id: bookId,
    chapter_id: chapterId,
    progress_percent: progress,
    last_position: { percent: progress },
    last_read_at: new Date().toISOString(),
  };

  try {
    const existing = await client
      .from("reading_progress")
      .select("id")
      .eq("user_id", user.id)
      .eq("book_id", bookId)
      .eq("chapter_id", chapterId)
      .limit(1);
    if (existing.error) throw existing.error;
    const result = existing.data?.[0]?.id
      ? await client.from("reading_progress").update(payload).eq("id", existing.data[0].id)
      : await client.from("reading_progress").insert(payload);
    if (result.error) throw result.error;

    appState.reading.historyError = "";
    appState.reading.progressByChapter.set(readingProgressKey(bookId, chapterId), progress);
    appState.reading.loaded = false;
    await loadReadingFeatures({ force: true });
  } catch (error) {
    appState.reading.historyError = error.message || "تعذر حفظ تقدم القراءة.";
  }
}

function normalizeSocialReview(row = {}) {
  const profile = normalizeProfile(row.profile || {});
  return {
    id: row.id,
    bookId: row.book_id,
    userId: row.user_id,
    name: profile.name || row.display_name || "قارئ NOVELFLEX",
    rating: Number(row.rating || row.score || 0) || 5,
    text: row.review || row.review_text || row.content || row.comment || "",
    meta: row.created_at ? new Date(row.created_at).toLocaleDateString("ar") : "حديثا",
  };
}

function socialReviewsForBook(bookId) {
  return appState.social.reviewsByBook.get(bookId) || [];
}

function currentReactionForBook(bookId) {
  return appState.social.reactionsByBook.get(bookId) || "";
}

function isFollowingAuthor(authorId) {
  return Boolean(appState.social.followsByAuthor.get(authorId));
}

async function loadSocialFeatures(book, { force = false } = {}) {
  if (!book?.id) return;
  if (appState.social.loadingBooks.has(book.id)) return;
  if (appState.social.loadedBooks.has(book.id) && !force) return;

  const client = supabaseClient();
  if (!client) return;

  appState.social.loadingBooks.add(book.id);
  appState.social.reviewErrors.delete(book.id);
  appState.social.reactionErrors.delete(book.id);
  appState.social.followErrors.delete(book.authorId);
  route();

  try {
    const reviewsResult = await client
      .from("ratings")
      .select("id,book_id,user_id,rating,review,created_at,profile:profiles!ratings_user_id_fkey(id,display_name,username,avatar_url)")
      .eq("book_id", book.id)
      .order("created_at", { ascending: false })
      .limit(50);

    if (reviewsResult.error) {
      appState.social.reviewErrors.set(book.id, reviewsResult.error.message || "تعذر تحميل ratings.");
    } else {
      appState.social.reviewsByBook.set(book.id, (reviewsResult.data || []).map(normalizeSocialReview));
    }

    if (appState.auth.user) {
      if (book.authorId) {
        const followResult = await client
          .from("follows")
          .select("id")
          .eq("follower_id", appState.auth.user.id)
          .eq("author_id", book.authorId)
          .limit(1);
        if (followResult.error) {
          appState.social.followErrors.set(book.authorId, followResult.error.message || "تعذر تحميل follows.");
        } else {
          appState.social.followsByAuthor.set(book.authorId, followResult.data?.[0]?.id || "");
        }
      }
    }

    appState.social.loadedBooks.add(book.id);
  } finally {
    appState.social.loadingBooks.delete(book.id);
    route();
  }
}

async function submitReview(form) {
  const user = appState.auth.user;
  if (!user) {
    appState.routeMessage = "سجل الدخول لكتابة مراجعة.";
    window.location.hash = "/auth/login";
    return;
  }
  const client = supabaseClient();
  const formData = new FormData(form);
  const bookId = form.getAttribute("data-book-id");
  const rating = Number(formData.get("rating") || 5);
  const review = String(formData.get("review") || "").trim();
  if (!client || !bookId) return;
  if (!review) {
    appState.social.reviewErrors.set(bookId, "نص المراجعة مطلوب.");
    route();
    return;
  }

  appState.social.saving = true;
  appState.social.message = "";
  appState.social.reviewErrors.delete(bookId);
  route();

  try {
    const { error } = await client.from("ratings").insert({
      user_id: user.id,
      book_id: bookId,
      rating,
      review,
    });
    if (error) throw error;
    appState.social.message = "تم نشر المراجعة.";
    await notifyNewReview(findReaderBook(bookId), review);
    appState.social.loadedBooks.delete(bookId);
    await loadSocialFeatures(findReaderBook(bookId), { force: true });
  } catch (error) {
    appState.social.reviewErrors.set(bookId, error.message || "تعذر نشر المراجعة.");
  } finally {
    appState.social.saving = false;
    route();
  }
}

async function setBookReaction(bookId, reactionType) {
  const user = appState.auth.user;
  if (!user) {
    appState.routeMessage = "سجل الدخول للتفاعل مع الرواية.";
    window.location.hash = "/auth/login";
    return;
  }
  const client = supabaseClient();
  if (!client) return;

  appState.social.saving = true;
  appState.social.reactionErrors.delete(bookId);
  route();

  try {
    appState.social.reactionsByBook.set(bookId, reactionType);
    appState.social.message = "التفاعل محفوظ في الواجهة فقط حالياً؛ جدول book_reactions غير موجود في Supabase الإنتاج.";
  } catch (error) {
    appState.social.reactionErrors.set(bookId, error.message || "تعذر تحديث التفاعل.");
  } finally {
    appState.social.saving = false;
    route();
  }
}

async function toggleFollowAuthor(authorId) {
  const user = appState.auth.user;
  if (!user) {
    appState.routeMessage = "سجل الدخول لمتابعة الكاتب.";
    window.location.hash = "/auth/login";
    return;
  }
  const client = supabaseClient();
  if (!client || !authorId) return;

  appState.social.saving = true;
  appState.social.followErrors.delete(authorId);
  route();

  try {
    const existingId = appState.social.followsByAuthor.get(authorId);
    const result = existingId
      ? await client.from("follows").delete().eq("id", existingId)
      : await client.from("follows").insert({ follower_id: user.id, author_id: authorId }).select("id").limit(1);
    if (result.error) throw result.error;
    appState.social.followsByAuthor.set(authorId, existingId ? "" : result.data?.[0]?.id || "pending");
    appState.social.message = existingId ? "تم إلغاء متابعة الكاتب." : "تمت متابعة الكاتب.";
    if (!existingId) await notifyNewFollower(authorId);
  } catch (error) {
    appState.social.followErrors.set(authorId, error.message || "تعذر تحديث المتابعة.");
  } finally {
    appState.social.saving = false;
    route();
  }
}

function readerChaptersForBook(bookId) {
  return appState.reader.chaptersByBook.get(bookId) || [];
}

async function loadReaderCatalog({ force = false } = {}) {
  if (appState.reader.loading) return;
  if (appState.reader.loaded && !force) return;

  const client = supabaseClient();
  if (!client) {
    appState.reader.error = "Supabase client غير جاهز. تأكد من تحميل auth.js.";
    appState.reader.loaded = true;
    route();
    return;
  }

  appState.reader.loading = true;
  appState.reader.error = "";
  route();

  try {
    const [categoriesResult, booksResult, authorsResult] = await Promise.all([
      client
        .from("categories")
        .select("id,slug,name_ar,name_en,description_ar,description_en,sort_order,is_active")
        .eq("is_active", true)
        .order("sort_order", { ascending: true })
        .order("name_ar", { ascending: true }),
      client
        .from("books")
        .select(
          [
            "id",
            "author_id",
            "category_id",
            "title_ar",
            "title_en",
            "description_ar",
            "description_en",
            "cover_url",
            "status",
            "language",
            "views_count",
            "likes_count",
            "rating_average",
            "ratings_count",
            "chapters_count",
            "published_at",
            "created_at",
            "author:profiles!books_author_id_fkey(id,display_name,username,avatar_url,bio)",
            "category:categories!books_category_id_fkey(id,slug,name_ar,name_en)",
          ].join(","),
        )
        .eq("status", "published")
        .order("published_at", { ascending: false })
        .order("created_at", { ascending: false })
        .limit(100),
      client.from("writer_profiles").select("id,user_id,pen_name,bio_ar,bio_en,is_approved,profile:profiles!writer_profiles_user_id_fkey(id,display_name,username,avatar_url,bio)").limit(25),
    ]);

    if (categoriesResult.error) throw categoriesResult.error;
    if (booksResult.error) throw booksResult.error;

    if (authorsResult.error) {
      appState.reader.authorTableStatus = "missing";
      markReaderIssue(`writer_profiles: ${authorsResult.error.message}`);
    } else {
      appState.reader.authorTableStatus = "available";
      appState.reader.authors = authorsResult.data || [];
    }

    appState.reader.categories = (categoriesResult.data || []).map(normalizeCategory);
    appState.reader.books = (booksResult.data || []).map(normalizeBook);

    const authorIds = [...new Set(appState.reader.books.map((book) => book.authorId).filter(Boolean))];
    if (authorIds.length) {
      const profilesResult = await client
        .from("profiles")
        .select("id,display_name,username,avatar_url,bio,is_public")
        .in("id", authorIds)
        .eq("is_public", true);
      if (profilesResult.error) {
        markReaderIssue(`profiles: ${profilesResult.error.message}`);
      } else {
        appState.reader.profiles = (profilesResult.data || []).map(normalizeProfile);
      }
    } else {
      appState.reader.profiles = [];
    }

    appState.reader.loaded = true;
  } catch (error) {
    appState.reader.error = error.message || "تعذر تحميل بيانات القارئ من Supabase.";
    appState.reader.loaded = true;
  } finally {
    appState.reader.loading = false;
    route();
  }
}

async function searchReaderBooks(query) {
  const needle = query.trim();
  if (!needle || appState.reader.searchLoading.has(needle) || appState.reader.searchResults.has(needle)) return;
  const client = supabaseClient();
  if (!client) {
    appState.reader.searchErrors.set(needle, "Supabase client غير جاهز.");
    route();
    return;
  }

  appState.reader.searchLoading.add(needle);
  appState.reader.searchErrors.delete(needle);
  route();

  try {
    const escaped = needle.replace(/[%_]/g, "\\$&");
    const { data, error } = await client
      .from("books")
      .select(
        [
          "id",
          "author_id",
          "category_id",
          "title_ar",
          "title_en",
          "description_ar",
          "description_en",
          "cover_url",
          "status",
          "language",
          "views_count",
          "rating_average",
          "ratings_count",
          "chapters_count",
          "published_at",
          "created_at",
          "author:profiles!books_author_id_fkey(id,display_name,username,avatar_url,bio)",
          "category:categories!books_category_id_fkey(id,slug,name_ar,name_en)",
        ].join(","),
      )
      .eq("status", "published")
      .or(`title_ar.ilike.%${escaped}%,title_en.ilike.%${escaped}%,description_ar.ilike.%${escaped}%,description_en.ilike.%${escaped}%`)
      .order("published_at", { ascending: false })
      .limit(50);
    if (error) throw error;
    appState.reader.searchResults.set(needle, (data || []).map(normalizeBook));
  } catch (error) {
    appState.reader.searchErrors.set(needle, error.message || "تعذر تنفيذ البحث.");
  } finally {
    appState.reader.searchLoading.delete(needle);
    route();
  }
}

async function loadReaderChapters(bookId) {
  if (!bookId || appState.reader.chaptersByBook.has(bookId) || appState.reader.loadingChapters.has(bookId)) return;
  const client = supabaseClient();
  if (!client) {
    appState.reader.chapterErrors.set(bookId, "Supabase client غير جاهز.");
    route();
    return;
  }

  appState.reader.loadingChapters.add(bookId);
  appState.reader.chapterErrors.delete(bookId);
  route();

  try {
    const chaptersResult = await client
      .from("chapters")
      .select("id,book_id,chapter_number,title_ar,title_en,content_text,file_path,audio_path,status,published_at,created_at,updated_at")
      .eq("book_id", bookId)
      .eq("status", "published")
      .order("chapter_number", { ascending: true });

    if (chaptersResult.error) throw chaptersResult.error;
    appState.reader.chapterSource = "chapters";
    appState.reader.chaptersByBook.set(bookId, (chaptersResult.data || []).map(normalizeChapter));
  } catch (error) {
    appState.reader.chapterErrors.set(bookId, error.message || "تعذر تحميل الفصول.");
  } finally {
    appState.reader.loadingChapters.delete(bookId);
    route();
  }
}

function resetAuthorPortal() {
  appState.authorPortal.loaded = false;
  appState.authorPortal.loading = false;
  appState.authorPortal.saving = false;
  appState.authorPortal.error = "";
  appState.authorPortal.message = "";
  appState.authorPortal.profile = null;
  appState.authorPortal.author = null;
  appState.authorPortal.authorTableStatus = "unchecked";
  appState.authorPortal.tableIssues = [];
  appState.authorPortal.categories = [];
  appState.authorPortal.novels = [];
  appState.authorPortal.chaptersByBook = new Map();
  appState.authorPortal.chapterErrors = new Map();
  appState.authorPortal.loadingChapters = new Set();
}

function markAuthorIssue(issue) {
  if (!appState.authorPortal.tableIssues.includes(issue)) appState.authorPortal.tableIssues.push(issue);
}

function normalizeAuthorNovel(row = {}) {
  const book = normalizeBook(row);
  const statusMap = {
    draft: "مسودة",
    published: "منشورة",
    in_review: "قيد المراجعة",
    rejected: "مرفوضة",
    archived: "مؤرشفة",
  };
  return {
    ...book,
    rawStatus: row.status || "draft",
    approval: statusMap[row.status] || row.status || "مسودة",
    updated: row.updated_at || row.published_at || row.created_at || "",
  };
}

function authorNovelIdsForUser(userId, authorRow) {
  return [...new Set([userId, authorRow?.id, authorRow?.user_id, authorRow?.profile_id].filter(Boolean))];
}

function authorCategories() {
  return appState.authorPortal.categories.length ? appState.authorPortal.categories : readerCategories();
}

function authorNovelsLive(filter = "all") {
  const list = appState.authorPortal.novels;
  if (filter === "drafts") return list.filter((book) => ["draft", "in_review", "rejected"].includes(book.rawStatus));
  if (filter === "published") return list.filter((book) => book.rawStatus === "published");
  return list;
}

function findAuthorNovel(id) {
  return appState.authorPortal.novels.find((book) => book.id === id) || null;
}

function normalizePdfChapter(row = {}) {
  const number = Number(row.chapter_number || row.order_index || row.number || 1);
  return {
    id: row.id,
    bookId: row.book_id,
    number,
    title: row.title_ar || row.title_en || row.title || `الفصل ${number}`,
    content: row.content_text || row.text_content || row.description || "",
    filePath: row.file_path || row.pdf_url || row.url || "",
    rawStatus: row.status || "draft",
    status: row.status === "published" ? "منشور" : "مسودة",
    updated: row.updated_at || row.published_at || row.created_at || "",
  };
}

function authorChaptersForBook(bookId, filter = "all") {
  const list = appState.authorPortal.chaptersByBook.get(bookId) || [];
  if (filter === "drafts") return list.filter((chapter) => chapter.rawStatus !== "published");
  if (filter === "published") return list.filter((chapter) => chapter.rawStatus === "published");
  return list;
}

function findAuthorChapter(bookId, chapterId) {
  return authorChaptersForBook(bookId).find((chapter) => chapter.id === chapterId) || null;
}

async function loadAuthorChapters(bookId, { force = false } = {}) {
  if (!bookId) return;
  if (appState.authorPortal.loadingChapters.has(bookId)) return;
  if (appState.authorPortal.chaptersByBook.has(bookId) && !force) return;

  const book = findAuthorNovel(bookId);
  if (!book) {
    appState.authorPortal.chapterErrors.set(bookId, "لا يمكن تحميل فصول رواية لا تملكها.");
    route();
    return;
  }

  const client = supabaseClient();
  if (!client) {
    appState.authorPortal.chapterErrors.set(bookId, "Supabase client غير جاهز.");
    route();
    return;
  }

  appState.authorPortal.loadingChapters.add(bookId);
  appState.authorPortal.chapterErrors.delete(bookId);
  route();

  try {
    const { data, error } = await client
      .from("chapters")
      .select("id,book_id,chapter_number,title_ar,title_en,content_text,file_path,audio_path,status,created_at,updated_at,published_at")
      .eq("book_id", bookId)
      .order("chapter_number", { ascending: true });

    if (error) throw error;
    appState.authorPortal.chaptersByBook.set(bookId, (data || []).map(normalizePdfChapter));
  } catch (error) {
    appState.authorPortal.chapterErrors.set(bookId, error.message || "تعذر تحميل فصول chapters.");
  } finally {
    appState.authorPortal.loadingChapters.delete(bookId);
    route();
  }
}

async function saveAuthorChapter(form) {
  const client = supabaseClient();
  const user = appState.auth.user;
  if (!client || !user) {
    appState.authorPortal.error = "يجب تسجيل الدخول قبل حفظ الفصل.";
    route();
    return;
  }

  const formData = new FormData(form);
  const mode = form.getAttribute("data-chapter-mode");
  const bookId = form.getAttribute("data-book-id");
  const chapterId = form.getAttribute("data-chapter-id");
  const book = findAuthorNovel(bookId);
  if (!book) {
    appState.authorPortal.error = "لا يمكن حفظ فصل لرواية لا تملكها.";
    route();
    return;
  }

  const statusAction = formData.get("status_action") || "draft";
  const payload = {
    book_id: bookId,
    chapter_number: Number(formData.get("chapter_number") || 1),
    title_ar: String(formData.get("title_ar") || "").trim(),
    content_text: String(formData.get("content_text") || "").trim(),
    file_path: String(formData.get("file_path") || "").trim() || null,
    status: statusAction === "publish" ? "published" : "draft",
    updated_at: new Date().toISOString(),
  };

  if (!payload.title_ar) {
    appState.authorPortal.error = "عنوان الفصل مطلوب.";
    route();
    return;
  }

  appState.authorPortal.saving = true;
  appState.authorPortal.error = "";
  appState.authorPortal.message = "";
  route();

  try {
    const result =
      mode === "edit"
        ? await client.from("chapters").update(payload).eq("id", chapterId).eq("book_id", bookId).select("id").limit(1)
        : await client
            .from("chapters")
            .insert({
              ...payload,
              created_at: new Date().toISOString(),
            })
            .select("id")
            .limit(1);

    if (result.error) throw result.error;
    appState.authorPortal.message = mode === "edit" ? "تم تحديث الفصل." : "تم إنشاء الفصل.";
    if (payload.status === "published") {
      await notifyNewChapterPublished(book, {
        id: result.data?.[0]?.id || chapterId,
        title: payload.title_ar,
      });
    }
    appState.authorPortal.chaptersByBook.delete(bookId);
    await loadAuthorChapters(bookId, { force: true });
    window.location.hash = `/author/novels/${bookId}/chapters`;
  } catch (error) {
    appState.authorPortal.error = error.message || "تعذر حفظ الفصل في chapters.";
  } finally {
    appState.authorPortal.saving = false;
    route();
  }
}

async function deleteAuthorChapter(bookId, chapterId) {
  const client = supabaseClient();
  const book = findAuthorNovel(bookId);
  if (!client || !book) return;

  appState.authorPortal.saving = true;
  appState.authorPortal.error = "";
  appState.authorPortal.message = "";
  route();

  try {
    const { error } = await client.from("chapters").delete().eq("id", chapterId).eq("book_id", bookId);
    if (error) throw error;
    appState.authorPortal.message = "تم حذف الفصل.";
    appState.authorPortal.chaptersByBook.delete(bookId);
    await loadAuthorChapters(bookId, { force: true });
  } catch (error) {
    appState.authorPortal.error = error.message || "تعذر حذف الفصل.";
  } finally {
    appState.authorPortal.saving = false;
    route();
  }
}

async function reorderAuthorChapter(bookId, chapterId, direction) {
  const client = supabaseClient();
  const list = authorChaptersForBook(bookId);
  const index = list.findIndex((chapter) => chapter.id === chapterId);
  const targetIndex = direction === "up" ? index - 1 : index + 1;
  if (!client || index < 0 || targetIndex < 0 || targetIndex >= list.length) return;

  const current = list[index];
  const target = list[targetIndex];
  appState.authorPortal.saving = true;
  appState.authorPortal.error = "";
  route();

  try {
    const updates = [
      client.from("chapters").update({ chapter_number: target.number, updated_at: new Date().toISOString() }).eq("id", current.id).eq("book_id", bookId),
      client.from("chapters").update({ chapter_number: current.number, updated_at: new Date().toISOString() }).eq("id", target.id).eq("book_id", bookId),
    ];
    const results = await Promise.all(updates);
    const failed = results.find((result) => result.error);
    if (failed) throw failed.error;
    appState.authorPortal.message = "تم تحديث ترتيب الفصول.";
    appState.authorPortal.chaptersByBook.delete(bookId);
    await loadAuthorChapters(bookId, { force: true });
  } catch (error) {
    appState.authorPortal.error = error.message || "تعذر إعادة ترتيب الفصول.";
  } finally {
    appState.authorPortal.saving = false;
    route();
  }
}

async function loadAuthorPortal({ force = false } = {}) {
  const user = appState.auth.user;
  if (!user) {
    resetAuthorPortal();
    appState.authorPortal.loaded = true;
    return;
  }
  if (appState.authorPortal.loading) return;
  if (appState.authorPortal.loaded && !force) return;

  const client = supabaseClient();
  if (!client) {
    appState.authorPortal.error = "Supabase client غير جاهز.";
    appState.authorPortal.loaded = true;
    route();
    return;
  }

  appState.authorPortal.loading = true;
  appState.authorPortal.error = "";
  route();

  try {
    const [profileResult, authorsResult, categoriesResult] = await Promise.all([
      client.from("profiles").select("id,role,display_name,username,avatar_url,bio,is_public").eq("id", user.id).limit(1),
      client.from("writer_profiles").select("*").limit(100),
      client
        .from("categories")
        .select("id,slug,name_ar,name_en,description_ar,description_en,sort_order,is_active")
        .eq("is_active", true)
        .order("sort_order", { ascending: true })
        .order("name_ar", { ascending: true }),
    ]);

    if (profileResult.error) throw profileResult.error;
    if (categoriesResult.error) throw categoriesResult.error;

    appState.authorPortal.profile = normalizeProfile(profileResult.data?.[0] || {
      id: user.id,
      display_name: user.email?.split("@")[0],
    });
    appState.authorPortal.categories = (categoriesResult.data || []).map(normalizeCategory);

    if (authorsResult.error) {
      appState.authorPortal.authorTableStatus = "missing";
      markAuthorIssue(`writer_profiles: ${authorsResult.error.message}`);
    } else {
      appState.authorPortal.authorTableStatus = "available";
      appState.authorPortal.author =
        (authorsResult.data || []).find((row) => [row.id, row.user_id, row.profile_id].includes(user.id)) || null;
    }

    const ownerIds = authorNovelIdsForUser(user.id, appState.authorPortal.author);
    const booksResult = await client
      .from("books")
      .select(
        [
          "id",
          "author_id",
          "category_id",
          "title_ar",
          "title_en",
          "description_ar",
          "description_en",
          "cover_url",
          "status",
          "language",
          "views_count",
          "likes_count",
          "rating_average",
          "ratings_count",
          "chapters_count",
          "published_at",
          "created_at",
          "updated_at",
          "category:categories!books_category_id_fkey(id,slug,name_ar,name_en)",
        ].join(","),
      )
      .in("author_id", ownerIds)
      .order("updated_at", { ascending: false })
      .order("created_at", { ascending: false });

    if (booksResult.error) throw booksResult.error;
    appState.authorPortal.novels = (booksResult.data || []).map(normalizeAuthorNovel);
    appState.authorPortal.loaded = true;
  } catch (error) {
    appState.authorPortal.error = error.message || "تعذر تحميل بوابة الكاتب.";
    appState.authorPortal.loaded = true;
  } finally {
    appState.authorPortal.loading = false;
    route();
  }
}

async function saveAuthorNovel(form) {
  const user = appState.auth.user;
  if (!user) {
    appState.authorPortal.error = "يجب تسجيل الدخول ككاتب قبل الحفظ.";
    route();
    return;
  }
  const client = supabaseClient();
  if (!client) {
    appState.authorPortal.error = "Supabase client غير جاهز.";
    route();
    return;
  }

  const formData = new FormData(form);
  const mode = form.getAttribute("data-novel-mode");
  const bookId = form.getAttribute("data-book-id");
  const statusAction = formData.get("status_action") || "draft";
  const payload = {
    title_ar: String(formData.get("title_ar") || "").trim(),
    description_ar: String(formData.get("description_ar") || "").trim(),
    category_id: String(formData.get("category_id") || "") || null,
    status: statusAction === "publish" ? "published" : "draft",
    language: "ar",
    updated_at: new Date().toISOString(),
  };

  if (!payload.title_ar) {
    appState.authorPortal.error = "عنوان الرواية مطلوب.";
    route();
    return;
  }

  appState.authorPortal.saving = true;
  appState.authorPortal.error = "";
  appState.authorPortal.message = "";
  route();

  try {
    let result;
    if (mode === "edit") {
      result = await client.from("books").update(payload).eq("id", bookId).eq("author_id", user.id).select("id").limit(1);
    } else {
      result = await client
        .from("books")
        .insert({
          ...payload,
          author_id: user.id,
          created_at: new Date().toISOString(),
        })
        .select("id")
        .limit(1);
    }

    if (result.error) throw result.error;
    appState.authorPortal.message = mode === "edit" ? "تم تحديث الرواية." : "تم إنشاء الرواية.";
    appState.authorPortal.loaded = false;
    await loadAuthorPortal({ force: true });
    window.location.hash = statusAction === "publish" ? "/author/published" : "/author/drafts";
  } catch (error) {
    appState.authorPortal.error = error.message || "تعذر حفظ الرواية.";
  } finally {
    appState.authorPortal.saving = false;
    route();
  }
}

function AppNavbar(active = "") {
  const nav = [
    ["/browse", dual("تصفح", "Browse")],
    ["/search", dual("بحث", "Search")],
    ["/library", dual("مكتبتي", "Library")],
    ["/author", dual("إنشاء", "Create")],
    ["/admin", dual("الإدارة", "Admin")],
  ];
  return `
    <header class="app-navbar">
      <a class="brand" href="#/" aria-label="NOVELFLEX">
        <span class="brand-mark">N</span>
        <span class="brand-name">NOVELFLEX</span>
      </a>
      <nav class="nav-links" aria-label="التنقل الرئيسي">
        ${nav.map(([href, label]) => `<a class="${active === href ? "is-active" : ""}" href="#${href}">${label}</a>`).join("")}
      </nav>
      <form class="search-pill" data-search-form>
        <input name="q" type="search" placeholder="ابحث عن رواية أو كاتب" />
        <button aria-label="بحث">⌕</button>
      </form>
      ${UserMenu()}
    </header>
  `;
}

function MobileNav(active = "") {
  return `
    <nav class="mobile-nav" aria-label="تنقل الهاتف">
      ${[
        ["/", dual("الرئيسية", "Home")],
        ["/browse", dual("تصفح", "Browse")],
        ["/search", dual("بحث", "Search")],
        ["/library", dual("مكتبتي", "Library")],
        ["/profile", dual("حسابي", "Profile")],
      ]
        .map(([href, label]) => `<a class="${active === href ? "is-active" : ""}" href="#${href}">${label}</a>`)
        .join("")}
    </nav>
  `;
}

function UserMenu() {
  const isSignedIn = Boolean(appState.auth.user);
  const isGuest = appState.auth.isGuest;
  const name = getDisplayName();
  if (isSignedIn && !appState.notifications.loaded) loadNotifications();
  const unread = unreadNotificationCount();
  return `
    <details class="user-menu">
      <summary><span class="avatar">${escapeHtml(getAvatarLetter())}</span><span>${escapeHtml(name)}</span>${unread ? `<b class="notification-badge">${unread}</b>` : ""}</summary>
      <div class="user-menu-panel">
        <span class="menu-status">${authStatusLabel()}</span>
        ${
          isSignedIn
            ? `<div class="notification-list">
                <b>الإشعارات</b>
                ${
                  appState.notifications.error
                    ? `<small>${escapeHtml(appState.notifications.error)}</small>`
                    : appState.notifications.items.length
                      ? appState.notifications.items.slice(0, 3).map((item) => `<small>${escapeHtml(item.title)}${item.body ? ` · ${escapeHtml(item.body)}` : ""}</small>`).join("")
                      : `<small>لا توجد إشعارات.</small>`
                }
              </div>`
            : ""
        }
        <a href="#/profile">${dual("الملف الشخصي", "Profile")}</a>
        ${
          isSignedIn || isGuest
            ? `<button type="button" data-logout>${dual("تسجيل الخروج", "Sign Out")}</button>`
            : `<a href="#/auth/login">${dual("تسجيل الدخول", "Login")}</a><a href="#/auth/register">${dual("إنشاء حساب", "Register")}</a><button type="button" data-guest>${dual("الدخول كضيف", "Guest Mode")}</button>`
        }
        <a href="#/author">${dual("استوديو الكاتب", "Author Studio")}</a>
      </div>
    </details>
  `;
}

function GenreSidebar(active = "") {
  const liveGenres = readerCategories();
  const firstGroup = liveGenres.slice(0, Math.max(8, Math.ceil(liveGenres.length / 2)));
  const secondGroup = liveGenres.slice(firstGroup.length);
  return `
    <aside class="genre-sidebar" aria-label="التصنيفات">
      <div class="side-title"><b>${dual("تصنيفات الروايات", "Genre of Novels")}</b><span>⌄</span></div>
      <a class="${!active ? "is-active" : ""}" href="#/browse"><span>${dual("الكل", "All")}</span><small>${readerBooks().length}</small></a>
      ${firstGroup
        .map(
          (genre) => `
            <a class="${active === genre.slug ? "is-active" : ""}" href="#/genre/${genre.slug}">
              <span>${escapeHtml(genre.name)}</span><small>${genre.count}</small>
            </a>
          `,
        )
        .join("")}
      <div class="side-title"><b>${dual("تصنيفات القصص المصورة", "Genre of Comics")}</b><span>⌄</span></div>
      ${secondGroup
        .map(
          (genre) => `
            <a class="${active === genre.slug ? "is-active" : ""}" href="#/genre/${genre.slug}">
              <span>${escapeHtml(genre.name)}</span><small>${genre.count}</small>
            </a>
          `,
        )
        .join("")}
      <div class="side-title"><b>${dual("تصنيفات الفان فيك", "Genre of Fan-fic")}</b><span>⌃</span></div>
    </aside>
  `;
}

function FilterTabs() {
  return `
    <div class="tabs">
      <button class="is-active">${dual("الكل", "All")}</button>
      <button>${dual("أصلي", "Original")}</button>
      <button>${dual("مترجم", "Translated")}</button>
      <button>${dual("مكتمل", "Completed")}</button>
      <button>${dual("مستمر", "Ongoing")}</button>
    </div>
  `;
}

function SortTabs() {
  return `
    <div class="sort-tabs">
      <button class="is-active">${dual("الأشهر", "Popular")}</button>
      <button>${dual("موصى به", "Recommended")}</button>
      <button>${dual("الأكثر حفظا", "Most collections")}</button>
      <button>${dual("التقييم", "Rating")}</button>
      <button>${dual("آخر تحديث", "Time updated")}</button>
    </div>
  `;
}

function RatingStars(value = 4.8) {
  const rounded = Math.round(value);
  return `<span class="rating-stars">${[1, 2, 3, 4, 5].map((i) => `<span>${i <= rounded ? "★" : "☆"}</span>`).join("")}<b>${value}</b></span>`;
}

function TagsList(tags = []) {
  return `<div class="tags-list">${tags.map((tag) => `<span>${escapeHtml(tag)}</span>`).join("")}</div>`;
}

function BookCover(book) {
  if (book.coverUrl) {
    return `<img class="book-cover cover-image" src="${escapeHtml(book.coverUrl)}" alt="غلاف ${escapeHtml(book.title)}" loading="lazy" />`;
  }
  return `<div class="book-cover cover-${book.tone}" aria-hidden="true"><span>${escapeHtml(book.genre)}</span></div>`;
}

function BookCard(book) {
  return `
    <article class="book-card">
      <a href="#/novels/${book.id}">${BookCover(book)}</a>
      <div class="book-card-body">
        <div class="meta-line"><span>${escapeHtml(book.status)}</span><span>${book.chapters} فصل</span></div>
        <h3><a href="#/novels/${book.id}">${escapeHtml(book.title)}</a></h3>
        <p>${escapeHtml(book.summary)}</p>
        ${RatingStars(book.rating)}
        ${TagsList(book.tags)}
      </div>
    </article>
  `;
}

function BookListItem(book) {
  return `
    <article class="book-list-item">
      <a href="#/novels/${book.id}">${BookCover(book)}</a>
      <div>
        <div class="meta-line"><span>${escapeHtml(book.genre)}</span><span>${escapeHtml(book.reads)} قراءة</span></div>
        <h3><a href="#/novels/${book.id}">${escapeHtml(book.title)}</a></h3>
        <p>${escapeHtml(book.summary)}</p>
      </div>
      <div class="list-side">${RatingStars(book.rating)}<button class="icon-button" data-save="${book.id}" aria-label="حفظ">＋</button></div>
    </article>
  `;
}

function NovelHero(book) {
  const firstChapter = readerChaptersForBook(book.id)[0];
  const startHref = firstChapter ? `#/novels/${book.id}/chapters/${firstChapter.id}` : `#/novels/${book.id}`;
  const isSaved = appState.reading.favoriteIds.has(book.id) || appState.saved.has(book.id);
  const following = isFollowingAuthor(book.authorId);
  return `
    <section class="novel-hero">
      ${BookCover(book)}
      <div class="novel-hero-copy">
        <span class="eyebrow">${dual("أصلي", "Original")}</span>
        <h1>${escapeHtml(book.title)}</h1>
        <div class="hero-meta"><span>${escapeHtml(book.genre)}</span><span>${book.chapters} فصل</span><span>${escapeHtml(book.reads)} قراءة</span><span>${dual("الكاتب", "Author")}: ${escapeHtml(book.author)}</span></div>
        ${RatingStars(book.rating)}
        <p>${escapeHtml(book.summary)}</p>
        ${TagsList(book.tags)}
        <div class="action-row">
          <a class="btn primary" href="${startHref}">${dual("اقرأ", "Read")}</a>
          <button class="btn secondary" data-save="${book.id}">${isSaved ? dual("في المكتبة", "In Library") : `+ ${dual("أضف للمكتبة", "Add to Library")}`}</button>
          <button class="btn ghost" data-follow-author="${escapeHtml(book.authorId || "")}">${following ? "متابع" : "متابعة الكاتب"}</button>
        </div>
      </div>
    </section>
  `;
}

function ChapterList(book = books[0], chapterItems = chapters) {
  return `
    <div class="chapter-list">
      ${chapterItems
        .map(
          (chapter) => `
          <a class="chapter-row" href="#/novels/${book.id}/chapters/${chapter.id}">
            <span class="chapter-number">${chapter.number}</span>
            <div><b>${escapeHtml(chapter.title)}</b><small>${escapeHtml(chapter.reads)}</small></div>
            <span class="status">${escapeHtml(chapter.status)}</span>
          </a>`,
        )
        .join("")}
    </div>
  `;
}

function ReviewCard(review) {
  return `
    <article class="review-card">
      <span class="avatar">${escapeHtml(review.name.slice(0, 1))}</span>
      <div>
        <div class="review-head"><b>${escapeHtml(review.name)}</b>${RatingStars(review.rating)}</div>
        <p>${escapeHtml(review.text)}</p>
        <div class="review-actions"><span>${escapeHtml(review.meta)}</span><button>مفيد</button><button>إبلاغ</button></div>
      </div>
    </article>
  `;
}

function SocialPanel(book) {
  const reaction = currentReactionForBook(book.id);
  const reactionError = appState.social.reactionErrors.get(book.id);
  const followError = appState.social.followErrors.get(book.authorId);
  return `
    <div class="social-panel">
      ${appState.social.message ? `<div class="toast">${escapeHtml(appState.social.message)}</div>` : ""}
      ${reactionError ? `<p class="auth-alert error">${escapeHtml(reactionError)}</p>` : ""}
      ${followError ? `<p class="auth-alert error">${escapeHtml(followError)}</p>` : ""}
      <div class="action-row">
        <button class="btn ${reaction === "like" ? "primary" : "secondary"}" type="button" data-book-reaction="like" data-book-id="${book.id}">إعجاب</button>
        <button class="btn ${reaction === "dislike" ? "primary" : "secondary"}" type="button" data-book-reaction="dislike" data-book-id="${book.id}">عدم إعجاب</button>
        <button class="btn ghost" type="button" data-follow-author="${escapeHtml(book.authorId || "")}">${isFollowingAuthor(book.authorId) ? "إلغاء متابعة الكاتب" : "متابعة الكاتب"}</button>
      </div>
    </div>
  `;
}

function ReviewForm(book) {
  return `
    <form class="editor-form review-form" data-review-form data-book-id="${book.id}">
      <label><span>التقييم</span><select name="rating"><option value="5">5</option><option value="4">4</option><option value="3">3</option><option value="2">2</option><option value="1">1</option></select></label>
      <label class="full"><span>المراجعة</span><textarea name="review" rows="4" placeholder="اكتب رأيك في الرواية"></textarea></label>
      <div class="form-actions"><button class="btn primary" type="submit" ${appState.social.saving ? "disabled" : ""}>نشر المراجعة</button></div>
    </form>
  `;
}

function LibraryCard(item) {
  const book = item.book || item;
  const progress = Number(item.progress || book.progress || 0);
  const href = item.chapterId ? readingResumeHref(item) : `#/novels/${book.id}`;
  return `
    <article class="library-card">
      <a href="#/novels/${book.id}">${BookCover(book)}</a>
      <div>
        <span class="eyebrow">متابعة القراءة</span>
        <h3>${escapeHtml(book.title)}</h3>
        <p>${item.lastReadAt ? `آخر قراءة: ${escapeHtml(new Date(item.lastReadAt).toLocaleDateString("ar"))}` : "محفوظ في المكتبة"} · التقدم ${progress || 0}٪</p>
        <div class="progress"><span style="width:${Math.max(0, Math.min(100, progress || 0))}%"></span></div>
      </div>
      <a class="btn primary" href="${href}">استئناف</a>
    </article>
  `;
}

function EmptyState(title = "لا توجد بيانات", text = "ستظهر العناصر هنا عند توفرها.", href = "/browse") {
  return `
    <div class="empty-state">
      <span class="state-icon">□</span>
      <h3>${escapeHtml(title)}</h3>
      <p>${escapeHtml(text)}</p>
      <a class="btn secondary" href="#${href}">متابعة</a>
    </div>
  `;
}

function LoadingState() {
  return `<div class="loading-state"><span></span><span></span><span></span></div>`;
}

function PageShell(active, content) {
  return `${AppNavbar(active)}<main class="app-main">${appState.routeMessage ? `<div class="toast">${escapeHtml(appState.routeMessage)}</div>` : ""}${content}</main>${SiteFooter()}${active === "/" ? "" : AppDownloadModal()}${MobileNav(active)}`;
}

function SiteFooter() {
  return `
    <footer class="site-footer">
      <div class="site-footer-inner">
        <div>
          <a class="footer-brand" href="#/"><span class="brand-mark">N</span><span>NOVELFLEX</span></a>
          <p>© 2026 NOVELFLEX. ${dual("منصة روايات عربية", "Arabic webnovel platform")}.</p>
        </div>
        <div class="footer-links">
          <div><b>${dual("الفريق", "Teams")}</b><a href="#/author">${dual("كن كاتبا", "Be an Author")}</a><a href="#/author/academy">${dual("الأكاديمية", "Academy")}</a></div>
          <div><b>${dual("التواصل", "Contacts")}</b><a href="#/admin/reports">${dual("البلاغات", "Reports")}</a><a href="#/profile">${dual("الحساب", "Account")}</a></div>
          <div><b>${dual("الموارد", "Resources")}</b><a href="#/browse">${dual("تصفح", "Browse")}</a><a href="#/library">${dual("المكتبة", "Library")}</a></div>
        </div>
      </div>
    </footer>
  `;
}

function AppDownloadModal() {
  return `
    <aside class="app-download-modal" aria-label="NOVELFLEX app links">
      <button class="close" type="button" aria-label="إغلاق">×</button>
      <span class="brand-mark">N</span>
      <b>${dual("حمّل تطبيق NOVELFLEX", "Download NOVELFLEX App")}</b>
      <div class="download-actions">
        <a class="btn primary" href="#/auth/login">${dual("عبر البريد", "Via Email")}</a>
        <a class="btn primary" href="#/library">${dual("آب ستور", "App Store")}</a>
        <a class="btn primary" href="#/browse">${dual("جوجل بلاي", "Google Play")}</a>
      </div>
    </aside>
  `;
}

function Section(title, subtitle, body, action = "") {
  return `
    <section class="section">
      <div class="section-heading">
        <div><span class="eyebrow">NOVELFLEX</span><h2>${escapeHtml(title)}</h2>${subtitle ? `<p>${escapeHtml(subtitle)}</p>` : ""}</div>
        ${action}
      </div>
      ${body}
    </section>
  `;
}

function renderHome() {
  if (!appState.reader.loaded) {
    loadReaderCatalog();
    return PageShell("/", LoadingState());
  }
  if (appState.reader.error) {
    return PageShell("/", EmptyState("تعذر تحميل بيانات القراءة", appState.reader.error, "/auth/login"));
  }
  const liveBooks = readerBooks();
  const liveGenres = readerCategories();
  if (appState.auth.user && !appState.reading.loaded) loadReadingFeatures();
  const savedBooks = appState.reading.history.length ? appState.reading.history.slice(0, 3) : appState.reading.favorites.slice(0, 3);
  const featured = liveBooks[0];
  const platformEntrances = [
    {
      title: dual("القارئ", "Reader"),
      text: "تصفح، بحث، تفاصيل الرواية، القارئ، المكتبة، والسجل.",
      links: [
        ["/browse", dual("تصفح", "Browse")],
        ["/search", dual("بحث", "Search")],
        [featured ? `/novels/${featured.id}` : "/browse", dual("تفاصيل الرواية", "Novel Details")],
        [featured ? `/novels/${featured.id}/reviews` : "/browse", dual("المراجعات", "Reviews")],
        ["/library", dual("المكتبة", "Library")],
        ["/library/history", dual("السجل", "History")],
        ["/profile", dual("الملف الشخصي", "Profile")],
      ],
    },
    {
      title: dual("الكاتب", "Author"),
      text: "لوحة الكاتب، الروايات، إنشاء رواية، الفصول، التحليلات، والأكاديمية.",
      links: [
        ["/author", dual("لوحة التحكم", "Dashboard")],
        ["/author/novels", dual("رواياتي", "My Novels")],
        ["/author/novels/new", dual("إنشاء رواية", "Create Novel")],
        ["/author/drafts", dual("المسودات", "Drafts")],
        ["/author/published", dual("المنشورة", "Published")],
        ["/author/analytics", dual("التحليلات", "Analytics")],
        ["/author/academy", dual("الأكاديمية", "Academy")],
      ],
    },
    {
      title: dual("الإدارة", "Admin"),
      text: "إدارة المستخدمين، الكتّاب، الروايات، المراجعات، البلاغات، والتصنيفات.",
      links: [
        ["/admin", dual("لوحة التحكم", "Dashboard")],
        ["/admin/users", dual("المستخدمون", "Users")],
        ["/admin/authors", dual("الكتّاب", "Authors")],
        ["/admin/content-moderation", dual("المحتوى", "Content")],
        ["/admin/reviews", dual("المراجعات", "Reviews")],
        ["/admin/reports", dual("البلاغات", "Reports")],
        ["/admin/categories", dual("التصنيفات", "Categories")],
      ],
    },
  ];
  return PageShell(
    "/",
    `
      <section class="home-hero">
        <div>
          <span class="eyebrow">منصة روايات عربية</span>
          <h1>اكتشف روايتك التالية.</h1>
          <p>NOVELFLEX تجربة قراءة وكتابة عربية بواجهة ويب كثيفة وسريعة: تصفح، اقرأ، احفظ، وانشر من مكان واحد.</p>
          <div class="action-row"><a class="btn primary" href="#/browse">${dual("تصفح", "Browse")}</a><a class="btn secondary" href="#/library">${dual("المكتبة", "Library")}</a><a class="btn ghost" href="#/author">${dual("أنشئ", "Create")}</a></div>
        </div>
        ${featured ? BookCard(featured) : EmptyState("لا توجد روايات منشورة", "جدول books لا يعيد روايات منشورة حاليا.", "/browse")}
      </section>
      ${Section(
        "بوابات المنصة",
        "كل الصفحات الأساسية حسب الخطة ظاهرة هنا حتى لا تختفي داخل المسارات.",
        `<div class="site-map-grid">${platformEntrances
          .map(
            (group) => `
            <article class="site-map-card">
              <h3>${group.title}</h3>
              <p>${group.text}</p>
              <div>${group.links.map(([href, label]) => `<a href="#${href}">${label}</a>`).join("")}</div>
            </article>`,
          )
          .join("")}</div>`,
      )}
      ${savedBooks.length ? Section("متابعة القراءة", "ارجع مباشرة إلى آخر رواياتك.", `<div class="list-stack">${savedBooks.map(LibraryCard).join("")}</div>`) : ""}
      ${Section("الأكثر قراءة", "روايات منشورة من Supabase.", liveBooks.length ? `<div class="book-grid">${liveBooks.slice(0, 4).map(BookCard).join("")}</div>` : EmptyState("لا توجد روايات منشورة", "تحقق من RLS أو حالة النشر في جدول books.", "/browse"), `<a class="btn ghost" href="#/browse">عرض الكل</a>`)}
      ${Section("تصنيفات سريعة", "اختصر الطريق إلى النوع الذي تحبه.", liveGenres.length ? `<div class="genre-cloud">${liveGenres.map((genre) => `<a href="#/genre/${genre.slug}">${escapeHtml(genre.name)}<small>${genre.count}</small></a>`).join("")}</div>` : EmptyState("لا توجد تصنيفات", "جدول categories لا يعيد تصنيفات نشطة حاليا.", "/browse"))}
    `,
  );
}

function renderBrowse(activeGenre = "") {
  if (!appState.reader.loaded) {
    loadReaderCatalog();
    return PageShell("/browse", LoadingState());
  }
  if (appState.reader.error) {
    return PageShell("/browse", EmptyState("تعذر تحميل التصفح", appState.reader.error, "/"));
  }
  const liveBooks = readerBooks();
  const liveGenres = readerCategories();
  const list = activeGenre ? liveBooks.filter((book) => book.genreSlug === activeGenre) : liveBooks;
  const genre = liveGenres.find((item) => item.slug === activeGenre);
  return PageShell(
    "/browse",
    `
      <div class="browse-layout">
        ${GenreSidebar(activeGenre)}
        <section class="browse-results">
          <div class="page-title"><span class="eyebrow">${dual("تصفح", "Browse")}</span><h1>${genre ? genre.name : dual("تصنيفات الروايات", "Genre of Novels")}</h1><p>${genre ? "استكشف الروايات ضمن هذا التصنيف." : "اختيارات واسعة من الروايات العربية المنشورة."}</p></div>
          ${FilterTabs()}
          ${SortTabs()}
          ${list.length ? `<div class="book-grid">${list.map(BookCard).join("")}</div>` : EmptyState("لا توجد روايات في هذا التصنيف", "جرّب تصنيفا آخر أو عد إلى كل الروايات.", "/browse")}
        </section>
      </div>
    `,
  );
}

function renderSearch(query = "") {
  if (!appState.reader.loaded) {
    loadReaderCatalog();
    return PageShell("/search", LoadingState());
  }
  const normalized = query.trim();
  if (normalized && !appState.reader.searchResults.has(normalized) && !appState.reader.searchErrors.has(normalized)) {
    searchReaderBooks(normalized);
  }
  const results = normalized ? appState.reader.searchResults.get(normalized) || [] : readerBooks().slice(0, 3);
  const isLoading = normalized && appState.reader.searchLoading.has(normalized);
  const searchError = normalized ? appState.reader.searchErrors.get(normalized) : "";
  return PageShell(
    "/search",
    `
      <div class="page-title"><span class="eyebrow">${dual("بحث", "Search")}</span><h1>${dual("البحث", "Search")}</h1><p>ابحث بالعنوان، الكاتب، التصنيف، أو الوسوم.</p></div>
      <form class="search-page-form" data-search-form>
        <input name="q" type="search" value="${escapeHtml(normalized)}" placeholder="مثال: خيال، ليان، غموض" />
        <button class="btn primary">بحث</button>
      </form>
      ${Section(normalized ? `نتائج "${normalized}"` : "اقتراحات شائعة", "نتائج Supabase للروايات المنشورة فقط.", isLoading ? LoadingState() : searchError ? EmptyState("تعذر تنفيذ البحث", searchError, "/browse") : results.length ? `<div class="list-stack">${results.map(BookListItem).join("")}</div>` : EmptyState("لا توجد نتائج", "جرّب كلمة أقصر أو تصنيفا مختلفا.", "/browse"))}
    `,
  );
}

function renderNovelDetails(bookId) {
  if (!appState.reader.loaded) {
    loadReaderCatalog();
    return PageShell("", LoadingState());
  }
  const book = findReaderBook(bookId);
  if (!book) {
    return PageShell("", EmptyState("الرواية غير موجودة", "لم تعد Supabase رواية منشورة بهذا المعرف.", "/browse"));
  }
  loadReaderChapters(book.id);
  loadSocialFeatures(book);
  const liveChapters = readerChaptersForBook(book.id);
  const chapterError = appState.reader.chapterErrors.get(book.id);
  const liveReviews = socialReviewsForBook(book.id);
  const reviewError = appState.social.reviewErrors.get(book.id);
  return PageShell(
    "",
    `
      ${NovelHero(book)}
      ${SocialPanel(book)}
      <div class="two-column">
        ${Section("الفصول", `مصدر الفصول: ${appState.reader.chapterSource}.`, appState.reader.loadingChapters.has(book.id) ? LoadingState() : chapterError ? EmptyState("تعذر تحميل الفصول", chapterError, "/browse") : liveChapters.length ? ChapterList(book, liveChapters) : EmptyState("لا توجد فصول منشورة", "لم تعد Supabase فصولا منشورة لهذه الرواية.", "/browse"))}
        ${Section("المراجعات", "تقييمات ومراجعات من جدول ratings.", `${ReviewForm(book)}${appState.social.loadingBooks.has(book.id) ? LoadingState() : reviewError ? `<p class="auth-alert error">${escapeHtml(reviewError)}</p>` : liveReviews.length ? liveReviews.slice(0, 3).map(ReviewCard).join("") : EmptyState("لا توجد مراجعات بعد", "كن أول من يكتب مراجعة لهذه الرواية.", "/auth/login")}`, `<a class="btn ghost" href="#/novels/${book.id}/reviews">كل المراجعات</a>`)}
      </div>
      ${Section("روايات مشابهة", "اقتراحات حسب التصنيف من Supabase.", `<div class="book-grid">${readerBooks().filter((item) => item.id !== book.id && item.genreSlug === book.genreSlug).slice(0, 3).map(BookCard).join("")}</div>`)}
    `,
  );
}

function renderNovelReviews(bookId) {
  if (!appState.reader.loaded) {
    loadReaderCatalog();
    return PageShell("", LoadingState());
  }
  const book = findReaderBook(bookId);
  if (!book) {
    return PageShell("", EmptyState("الرواية غير موجودة", "لم تعد Supabase رواية منشورة بهذا المعرف.", "/browse"));
  }
  loadSocialFeatures(book);
  const liveReviews = socialReviewsForBook(book.id);
  const reviewError = appState.social.reviewErrors.get(book.id);
  return PageShell(
    "",
    `
      <div class="page-title"><span class="eyebrow">${dual("المراجعات", "Reviews")}</span><h1>مراجعات ${escapeHtml(book.title)}</h1><p>صفحة مستقلة للمراجعات والتقييمات.</p></div>
      <div class="two-column">
        ${Section("اكتب مراجعة", "شارك رأيك مع القراء.", ReviewForm(book))}
        ${Section("كل المراجعات", "مرتبة حسب أحدث البيانات المتاحة.", appState.social.loadingBooks.has(book.id) ? LoadingState() : reviewError ? `<p class="auth-alert error">${escapeHtml(reviewError)}</p>` : liveReviews.length ? liveReviews.map(ReviewCard).join("") : EmptyState("لا توجد مراجعات بعد", "كن أول من يكتب مراجعة لهذه الرواية.", "/auth/login"))}
      </div>
    `,
  );
}

function renderReader(bookId, chapterId) {
  if (!appState.reader.loaded) {
    loadReaderCatalog();
    return PageShell("", LoadingState());
  }
  const book = findReaderBook(bookId);
  if (!book) {
    return PageShell("", EmptyState("الرواية غير موجودة", "لم تعد Supabase رواية منشورة بهذا المعرف.", "/browse"));
  }
  loadReaderChapters(book.id);
  const liveChapters = readerChaptersForBook(book.id);
  const chapterError = appState.reader.chapterErrors.get(book.id);
  if (appState.reader.loadingChapters.has(book.id)) return PageShell("", LoadingState());
  if (chapterError) return PageShell("", EmptyState("تعذر تحميل الفصل", chapterError, `/novels/${book.id}`));
  const chapter = liveChapters.find((item) => item.id === chapterId) || liveChapters[0];
  if (!chapter) return PageShell("", EmptyState("لا توجد فصول منشورة", "لم تعد Supabase فصولا لهذه الرواية.", `/novels/${book.id}`));
  const index = liveChapters.findIndex((item) => item.id === chapter.id);
  const prev = liveChapters[index - 1];
  const next = liveChapters[index + 1];
  const progressKey = readingProgressKey(book.id, chapter.id);
  const currentProgress = appState.reading.progressByChapter.get(progressKey) || 0;
  if (appState.auth.user && !currentProgress && !appState.reading.historyError) saveReadingProgress(book.id, chapter.id, 65);
  return PageShell(
    "",
    `
      <article class="reader-page">
        <div class="reader-toolbar">
          <a class="btn ghost" href="#/novels/${book.id}">تفاصيل الرواية</a>
          <span>${escapeHtml(book.title)} · ${currentProgress || 65}٪</span>
          <button class="btn secondary" data-save="${book.id}">${appState.reading.favoriteIds.has(book.id) ? "محفوظ في المكتبة" : "أضف للمكتبة"}</button>
        </div>
        <div class="reader-content">
          <span class="eyebrow">الفصل ${chapter.number}</span>
          <h1>${escapeHtml(chapter.title)}</h1>
          ${String(chapter.content)
            .split(/\n{2,}/)
            .filter(Boolean)
            .map((paragraph) => `<p>${escapeHtml(paragraph)}</p>`)
            .join("")}
          ${chapter.filePath ? `<p><a class="btn secondary" href="${escapeHtml(chapter.filePath)}" target="_blank" rel="noopener">فتح ملف الفصل</a></p>` : ""}
        </div>
        <div class="reader-footer">
          ${prev ? `<a class="btn secondary" href="#/novels/${book.id}/chapters/${prev.id}">الفصل السابق</a>` : `<a class="btn secondary" href="#/novels/${book.id}">تفاصيل الرواية</a>`}
          ${next ? `<a class="btn primary" href="#/novels/${book.id}/chapters/${next.id}">الفصل التالي</a>` : `<a class="btn primary" href="#/library/history">متابعة السجل</a>`}
        </div>
      </article>
    `,
  );
}

function renderLibrary() {
  if (!appState.auth.ready) return PageShell("/library", LoadingState());
  if (!appState.auth.user) {
    return PageShell("/library", EmptyState("سجل الدخول لفتح مكتبتك", "المكتبة مرتبطة بجدول favorites في Supabase.", "/auth/login"));
  }
  if (!appState.reading.loaded) {
    loadReadingFeatures();
    return PageShell("/library", LoadingState());
  }
  const list = appState.reading.favorites;
  return PageShell(
    "/library",
    `
      <div class="page-title"><span class="eyebrow">${dual("المكتبة", "Library")}</span><h1>${dual("المكتبة", "Library")}</h1><p>الروايات المحفوظة من جدول favorites.</p></div>
      <nav class="library-tabs"><a class="is-active" href="#/library">${dual("المكتبة", "Library")}</a><a href="#/library/history">${dual("السجل", "History")}</a></nav>
      ${appState.reading.error ? `<p class="auth-alert error">${escapeHtml(appState.reading.error)}</p>` : ""}
      ${list.length ? `<div class="list-stack">${list.map(LibraryCard).join("")}</div>` : EmptyState("لا توجد روايات محفوظة بعد", "احفظ رواية من صفحة التفاصيل لتظهر هنا.", "/browse")}
    `,
  );
}

function renderHistory() {
  if (!appState.auth.ready) return PageShell("/library", LoadingState());
  if (!appState.auth.user) {
    return PageShell("/library", EmptyState("سجل الدخول لفتح سجل القراءة", "سجل القراءة مرتبط بجدول reading_progress في Supabase.", "/auth/login"));
  }
  if (!appState.reading.loaded) {
    loadReadingFeatures();
    return PageShell("/library", LoadingState());
  }
  const history = appState.reading.history;
  return PageShell(
    "/library",
    `
      <div class="page-title"><span class="eyebrow">${dual("السجل", "History")}</span><h1>${dual("سجل القراءة", "Reading History")}</h1><p>آخر الفصول التي قرأتها من جدول reading_progress.</p></div>
      <nav class="library-tabs"><a href="#/library">${dual("المكتبة", "Library")}</a><a class="is-active" href="#/library/history">${dual("السجل", "History")}</a></nav>
      ${appState.reading.historyError ? `<p class="auth-alert error">${escapeHtml(appState.reading.historyError)}</p>` : ""}
      ${history.length ? `<div class="list-stack">${history.map(LibraryCard).join("")}</div>` : EmptyState("لا يوجد سجل قراءة", "افتح فصلا لتسجيل التقدم تلقائيا.", "/browse")}
    `,
  );
}

function renderProfile() {
  const isSignedIn = Boolean(appState.auth.user);
  const isGuest = appState.auth.isGuest;
  const name = getDisplayName();
  const email = appState.auth.user?.email || "";
  const description = isSignedIn
    ? `تم تسجيل الدخول عبر Supabase Auth${email ? ` باستخدام ${email}` : ""}.`
    : isGuest
      ? "تستخدم NOVELFLEX حاليا كضيف. يمكنك تصفح بيانات القراءة العامة من Supabase بدون إنشاء حساب."
      : "سجل الدخول أو تابع كضيف لتفعيل حالة المستخدم في الواجهة.";
  return PageShell(
    "/profile",
    `
      <section class="profile-page">
        <span class="avatar avatar-large">${escapeHtml(getAvatarLetter())}</span>
        <div>
          <span class="eyebrow">${dual("ملف القارئ", "Reader Profile")} · ${authStatusLabel()}</span>
          <h1>${escapeHtml(name)}</h1>
          <p>${escapeHtml(description)}</p>
          ${
            appState.authMessage
              ? `<p class="auth-alert success">${escapeHtml(appState.authMessage)}</p>`
              : ""
          }
          <div class="metric-grid">
            <article><span>محفوظة</span><b>${appState.saved.size}</b></article>
            <article><span>مراجعات</span><b>١٢</b></article>
            <article><span>متابعات</span><b>٨</b></article>
          </div>
          ${
            isSignedIn || isGuest
              ? `<div class="form-actions"><button class="btn secondary" type="button" data-logout>تسجيل الخروج</button></div>`
              : `<div class="form-actions"><a class="btn primary" href="#/auth/login">تسجيل الدخول</a><button class="btn secondary" type="button" data-guest>الدخول كضيف</button></div>`
          }
        </div>
      </section>
    `,
  );
}

function renderAuth(mode = "login") {
  const isRegister = mode === "register";
  const isSignedIn = Boolean(appState.auth.user);
  const isGuest = appState.auth.isGuest;
  const helperText = isRegister
    ? "أنشئ حسابك للقراءة، حفظ الروايات، ومتابعة الفصول."
    : "ادخل إلى مكتبتك وسجل القراءة وتفضيلاتك.";
  if (isSignedIn || isGuest) {
    return PageShell(
      "",
      `
        <section class="auth-page">
          <div class="auth-intro">
            <span class="eyebrow">${dual("المصادقة", "Authentication")}</span>
            <h1>${isSignedIn ? "أنت مسجل الدخول" : "أنت في وضع الضيف"}</h1>
            <p>${escapeHtml(getDisplayName())} · ${authStatusLabel()}</p>
            ${appState.authMessage ? `<p class="auth-alert success">${escapeHtml(appState.authMessage)}</p>` : ""}
          </div>
          <div class="auth-card auth-form">
            <a class="btn primary" href="#/profile">فتح الملف الشخصي</a>
            <button class="btn secondary" type="button" data-logout>تسجيل الخروج</button>
          </div>
        </section>
      `,
    );
  }
  return PageShell(
    "",
    `
      <section class="auth-page">
        <div class="auth-intro">
          <span class="eyebrow">${dual("المصادقة", "Authentication")}</span>
          <h1>${isRegister ? "إنشاء حساب" : "تسجيل الدخول"}</h1>
          <p>${helperText}</p>
          ${appState.authMessage ? `<p class="auth-alert success">${escapeHtml(appState.authMessage)}</p>` : ""}
          ${appState.auth.lastError ? `<p class="auth-alert error">${escapeHtml(appState.auth.lastError)}</p>` : ""}
        </div>
        <form class="auth-card auth-form" data-auth-form data-auth-mode="${isRegister ? "register" : "login"}">
          ${isRegister ? `<label><span>الاسم</span><input name="username" autocomplete="name" placeholder="اسم المستخدم" required /></label>` : ""}
          <label><span>البريد الإلكتروني</span><input name="email" type="email" autocomplete="email" placeholder="reader@example.com" required /></label>
          <label><span>كلمة المرور</span><input name="password" type="password" autocomplete="${isRegister ? "new-password" : "current-password"}" minlength="6" required /></label>
          <button class="btn primary" type="submit" ${appState.authBusy ? "disabled" : ""}>${appState.authBusy ? "جار المعالجة..." : isRegister ? "إنشاء الحساب" : "دخول بالبريد"}</button>
          <div class="auth-provider-row">
            <button class="btn secondary" type="button" data-oauth="apple">تسجيل الدخول عبر Apple</button>
            <button class="btn secondary" type="button" data-oauth="google">تسجيل الدخول عبر Google</button>
          </div>
          <button class="btn ghost" type="button" data-guest>المتابعة كضيف</button>
          <p class="auth-switch">${isRegister ? "لديك حساب؟" : "ليس لديك حساب؟"} <a href="#/auth/${isRegister ? "login" : "register"}">${isRegister ? "تسجيل الدخول" : "إنشاء حساب"}</a></p>
        </form>
      </section>
    `,
  );
}

function renderAuthCallback() {
  return PageShell(
    "",
    `
      <section class="auth-page">
        <div class="auth-intro">
          <span class="eyebrow">${dual("عودة المصادقة", "Auth Callback")}</span>
          <h1>جار إكمال تسجيل الدخول</h1>
          <p>تم استقبال العودة من مزود المصادقة، وسيتم تحديث حالة الجلسة تلقائيا.</p>
          ${appState.auth.lastError ? `<p class="auth-alert error">${escapeHtml(appState.auth.lastError)}</p>` : ""}
        </div>
        <div class="auth-card auth-form">
          <a class="btn primary" href="#/profile">فتح الملف الشخصي</a>
          <a class="btn secondary" href="#/auth/login">العودة لتسجيل الدخول</a>
        </div>
      </section>
    `,
  );
}

function AuthorDashboardLayout(active, body) {
  const links = [
    ["/author", "لوحة التحكم"],
    ["/author/novels", "رواياتي"],
    ["/author/drafts", "المسودات"],
    ["/author/published", "المنشورة"],
    ["/author/novels/new", "إنشاء رواية"],
    ["/author/analytics", "التحليلات"],
    ["/author/academy", "الأكاديمية"],
  ];
  return PageShell(
    "/author",
    `
      <section class="workspace-layout">
        <aside class="workspace-sidebar">
          <b>استوديو الكاتب</b>
          ${links.map(([href, label]) => `<a class="${active === href ? "is-active" : ""}" href="#${href}">${label}</a>`).join("")}
        </aside>
        <div class="workspace-main">${body}</div>
      </section>
    `,
  );
}

function AuthorAccessGate() {
  if (!appState.auth.ready) return PageShell("/author", LoadingState());
  if (!appState.auth.user) {
    return PageShell(
      "/author",
      EmptyState("سجل الدخول للوصول إلى بوابة الكاتب", "بوابة الكاتب تحتاج حساب Supabase نشط، وليس وضع الضيف.", "/auth/login"),
    );
  }
  if (!appState.authorPortal.loaded) {
    loadAuthorPortal();
    return PageShell("/author", LoadingState());
  }
  if (appState.authorPortal.error) {
    return AuthorDashboardLayout(
      "/author",
      EmptyState("تعذر تحميل بوابة الكاتب", appState.authorPortal.error, "/author"),
    );
  }
  return "";
}

function AuthorTableNotice() {
  if (appState.authorPortal.authorTableStatus !== "missing") return "";
  return `<div class="toast">ملف الكاتب يعتمد على writer_profiles، وملكية الروايات مرتبطة عبر profiles/books.</div>`;
}

function renderAuthorDashboard() {
  const gate = AuthorAccessGate();
  if (gate) return gate;
  const novels = authorNovelsLive();
  const drafts = authorNovelsLive("drafts");
  const published = authorNovelsLive("published");
  return AuthorDashboardLayout(
    "/author",
    `
      ${AuthorTableNotice()}
      ${appState.authorPortal.message ? `<div class="toast">${escapeHtml(appState.authorPortal.message)}</div>` : ""}
      <div class="page-title"><span class="eyebrow">${dual("لوحة الكاتب", "Author Dashboard")}</span><h1>${dual("لوحة الكاتب", "Author Dashboard")}</h1><p>بيانات الكاتب والروايات من Supabase فقط.</p></div>
      <div class="metric-grid">
        <article><span>الروايات</span><b>${novels.length}</b></article>
        <article><span>المسودات</span><b>${drafts.length}</b></article>
        <article><span>المنشورة</span><b>${published.length}</b></article>
      </div>
      ${Section("آخر الروايات", "أحدث عناصر books المملوكة لحسابك.", novels.length ? `<div class="list-stack">${novels.slice(0, 4).map(AuthorNovelRow).join("")}</div>` : EmptyState("لا توجد روايات بعد", "أنشئ أول رواية كمسودة من بوابة الكاتب.", "/author/novels/new"), `<a class="btn primary" href="#/author/novels/new">رواية جديدة</a>`)}
    `,
  );
}

function AuthorNovelRow(book) {
  return `
    <article class="admin-row">
      ${BookCover(book)}
      <div>
        <h3>${escapeHtml(book.title)}</h3>
        <p>${escapeHtml(book.approval)} · ${book.chapters} فصل · ${escapeHtml(book.genre)} · ${book.updated ? `آخر تحديث ${escapeHtml(new Date(book.updated).toLocaleDateString("ar"))}` : "بدون تاريخ"}</p>
      </div>
      <a class="btn secondary" href="#/author/novels/${book.id}/edit">تحرير</a>
      <a class="btn ghost" href="#/novels/${book.id}">معاينة</a>
    </article>`;
}

function renderMyNovels(filter = "all") {
  const gate = AuthorAccessGate();
  if (gate) return gate;
  const list = authorNovelsLive(filter);
  const titleMap = {
    all: [dual("رواياتي", "My Novels"), "رواياتي", "كل الروايات المرتبطة بحساب الكاتب."],
    drafts: [dual("المسودات", "Drafts"), "المسودات", "الروايات غير المنشورة أو قيد المراجعة."],
    published: [dual("المنشورة", "Published"), "الروايات المنشورة", "الروايات المتاحة للقراء."],
  };
  const [eyebrow, title, subtitle] = titleMap[filter] || titleMap.all;
  return AuthorDashboardLayout(
    filter === "drafts" ? "/author/drafts" : filter === "published" ? "/author/published" : "/author/novels",
    `
      ${AuthorTableNotice()}
      <div class="page-title"><span class="eyebrow">${eyebrow}</span><h1>${title}</h1><p>${subtitle}</p></div>
      ${list.length ? `<div class="list-stack">${list.map(AuthorNovelRow).join("")}</div>` : EmptyState("لا توجد روايات هنا", "ابدأ بإنشاء رواية جديدة كمسودة.", "/author/novels/new")}
    `,
  );
}

function NovelForm(mode, book = books[0]) {
  const gate = AuthorAccessGate();
  if (gate) return gate;
  const isEdit = mode === "edit";
  const liveBook = isEdit ? findAuthorNovel(book?.id || book) : null;
  if (isEdit && !liveBook) {
    return AuthorDashboardLayout("/author/novels", EmptyState("الرواية غير موجودة", "لم يتم العثور على رواية مملوكة لحسابك بهذا المعرف.", "/author/novels"));
  }
  const activeBook = liveBook || {};
  const title = mode === "create" ? "إنشاء رواية" : "تحرير رواية";
  const categoryOptions = authorCategories()
    .map((category) => `<option value="${escapeHtml(category.id)}" ${category.id === activeBook.categoryId ? "selected" : ""}>${escapeHtml(category.name)}</option>`)
    .join("");
  return AuthorDashboardLayout(
    mode === "create" ? "/author/novels/new" : "/author/novels",
    `
      <div class="page-title"><span class="eyebrow">${mode === "create" ? dual("إنشاء رواية", "Create Novel") : dual("تحرير رواية", "Edit Novel")}</span><h1>${title}</h1><p>يحفظ هذا النموذج في جدول books عبر Supabase فقط.</p></div>
      ${appState.authorPortal.error ? `<p class="auth-alert error">${escapeHtml(appState.authorPortal.error)}</p>` : ""}
      <form class="editor-form" data-author-novel-form data-novel-mode="${mode}" data-book-id="${escapeHtml(activeBook.id || "")}">
        <label><span>عنوان الرواية</span><input name="title_ar" value="${escapeHtml(activeBook.title || "")}" placeholder="مثال: مدينة الحبر الأخيرة" required /></label>
        <label><span>التصنيف</span><select name="category_id" required>${categoryOptions}</select></label>
        <label><span>الحالة</span><select name="status_action"><option value="draft" ${activeBook.rawStatus !== "published" ? "selected" : ""}>حفظ كمسودة</option><option value="publish" ${activeBook.rawStatus === "published" ? "selected" : ""}>نشر</option></select></label>
        <label class="full"><span>الملخص</span><textarea name="description_ar" rows="6">${escapeHtml(activeBook.summary || "")}</textarea></label>
        <div class="form-actions">
          <button class="btn primary" type="submit" ${appState.authorPortal.saving ? "disabled" : ""}>${appState.authorPortal.saving ? "جار الحفظ..." : "حفظ"}</button>
          <a class="btn secondary" href="#/author/novels">عودة</a>
        </div>
      </form>
    `,
  );
}

function AuthorChapterRow(book, chapter, index, total) {
  return `
    <article class="admin-row">
      <div class="chapter-number">${chapter.number}</div>
      <div>
        <h3>${escapeHtml(chapter.title)}</h3>
        <p>${escapeHtml(chapter.status)} · ${chapter.filePath ? "ملف مرتبط" : "نص داخلي"} · ${chapter.updated ? `آخر تحديث ${escapeHtml(new Date(chapter.updated).toLocaleDateString("ar"))}` : "بدون تاريخ"}</p>
      </div>
      <button class="btn ghost" type="button" data-reorder-chapter="${chapter.id}" data-book-id="${book.id}" data-direction="up" ${index === 0 ? "disabled" : ""}>أعلى</button>
      <button class="btn ghost" type="button" data-reorder-chapter="${chapter.id}" data-book-id="${book.id}" data-direction="down" ${index === total - 1 ? "disabled" : ""}>أسفل</button>
      <a class="btn secondary" href="#/author/novels/${book.id}/chapters/${chapter.id}/edit">تحرير</a>
      <button class="btn ghost" type="button" data-delete-chapter="${chapter.id}" data-book-id="${book.id}">حذف</button>
    </article>`;
}

function renderChapterManager(bookId, filter = "all") {
  const gate = AuthorAccessGate();
  if (gate) return gate;
  const book = findAuthorNovel(bookId);
  if (!book) return AuthorDashboardLayout("/author/novels", EmptyState("الرواية غير موجودة", "لا يمكن إدارة فصول رواية لا تملكها.", "/author/novels"));
  loadAuthorChapters(book.id);
  const allChapters = authorChaptersForBook(book.id);
  const list = authorChaptersForBook(book.id, filter);
  const chapterError = appState.authorPortal.chapterErrors.get(book.id);
  const activeHref = `/author/novels/${book.id}/chapters`;
  return AuthorDashboardLayout(
    "/author/novels",
    `
      <div class="page-title"><span class="eyebrow">${dual("إدارة الفصول", "Chapter Manager")}</span><h1>فصول ${escapeHtml(book.title)}</h1><p>إدارة الفصول من جدول chapters.</p></div>
      ${appState.authorPortal.error ? `<p class="auth-alert error">${escapeHtml(appState.authorPortal.error)}</p>` : ""}
      ${appState.authorPortal.message ? `<div class="toast">${escapeHtml(appState.authorPortal.message)}</div>` : ""}
      <div class="tabs">
        <a class="${filter === "all" ? "is-active" : ""}" href="#${activeHref}">الكل (${allChapters.length})</a>
        <a class="${filter === "drafts" ? "is-active" : ""}" href="#${activeHref}?filter=drafts">المسودات (${authorChaptersForBook(book.id, "drafts").length})</a>
        <a class="${filter === "published" ? "is-active" : ""}" href="#${activeHref}?filter=published">المنشورة (${authorChaptersForBook(book.id, "published").length})</a>
      </div>
      ${Section("قائمة الفصول", "إنشاء / تحرير / حذف / ترتيب الفصول تعمل على chapters.", appState.authorPortal.loadingChapters.has(book.id) ? LoadingState() : chapterError ? EmptyState("تعذر تحميل chapters", chapterError, "/author/novels") : list.length ? `<div class="list-stack">${list.map((chapter, index) => AuthorChapterRow(book, chapter, index, list.length)).join("")}</div>` : EmptyState("لا توجد فصول", "أضف أول فصل للرواية من هنا.", `/author/novels/${book.id}/chapters/new`), `<a class="btn primary" href="#/author/novels/${book.id}/chapters/new">${dual("إضافة فصل", "Add Chapter")}</a>`)}
    `,
  );
}

function renderChapterForm(bookId, chapterId = "") {
  const gate = AuthorAccessGate();
  if (gate) return gate;
  const book = findAuthorNovel(bookId);
  if (!book) return AuthorDashboardLayout("/author/novels", EmptyState("الرواية غير موجودة", "لا يمكن تحرير فصول رواية لا تملكها.", "/author/novels"));
  loadAuthorChapters(book.id);
  const isEdit = Boolean(chapterId);
  const chapter = isEdit ? findAuthorChapter(book.id, chapterId) : null;
  const nextNumber = authorChaptersForBook(book.id).length + 1;
  if (isEdit && appState.authorPortal.loadingChapters.has(book.id)) return AuthorDashboardLayout("/author/novels", LoadingState());
  if (isEdit && !chapter) return AuthorDashboardLayout("/author/novels", EmptyState("الفصل غير موجود", "لم يتم العثور على الفصل داخل chapters.", `/author/novels/${book.id}/chapters`));
  return AuthorDashboardLayout(
    "/author/novels",
    `
      <div class="page-title"><span class="eyebrow">${isEdit ? dual("تحرير فصل", "Edit Chapter") : dual("إنشاء فصل", "Create Chapter")}</span><h1>${isEdit ? "تحرير فصل" : "إضافة فصل"} إلى ${escapeHtml(book.title)}</h1><p>يحفظ هذا النموذج في جدول chapters.</p></div>
      ${appState.authorPortal.error ? `<p class="auth-alert error">${escapeHtml(appState.authorPortal.error)}</p>` : ""}
      <form class="editor-form" data-author-chapter-form data-chapter-mode="${isEdit ? "edit" : "create"}" data-book-id="${escapeHtml(book.id)}" data-chapter-id="${escapeHtml(chapter?.id || "")}">
        <label><span>رقم الفصل</span><input name="chapter_number" type="number" min="1" value="${escapeHtml(chapter?.number || nextNumber)}" required /></label>
        <label><span>عنوان الفصل</span><input name="title_ar" value="${escapeHtml(chapter?.title || "")}" placeholder="عنوان الفصل" required /></label>
        <label><span>الحالة</span><select name="status_action"><option value="draft" ${chapter?.rawStatus !== "published" ? "selected" : ""}>مسودة</option><option value="publish" ${chapter?.rawStatus === "published" ? "selected" : ""}>منشور</option></select></label>
        <label><span>مسار ملف PDF اختياري</span><input name="file_path" value="${escapeHtml(chapter?.filePath || "")}" placeholder="storage/path/file.pdf أو رابط" /></label>
        <label class="full"><span>نص الفصل</span><textarea name="content_text" rows="10">${escapeHtml(chapter?.content || "")}</textarea></label>
        <div class="form-actions">
          <button class="btn primary" type="submit" ${appState.authorPortal.saving ? "disabled" : ""}>${appState.authorPortal.saving ? "جار الحفظ..." : "حفظ الفصل"}</button>
          <a class="btn secondary" href="#/author/novels/${book.id}/chapters">إلغاء</a>
        </div>
      </form>
    `,
  );
}

function renderAnalytics() {
  const gate = AuthorAccessGate();
  if (gate) return gate;
  return AuthorDashboardLayout(
    "/author/analytics",
    `
      <div class="page-title"><span class="eyebrow">${dual("التحليلات", "Analytics")}</span><h1>${dual("التحليلات", "Analytics")}</h1><p>مؤشرات للقراءات والحفظ والتقييم.</p></div>
      <div class="metric-grid">
        <article><span>قراءات الشهر</span><b>١٨٤,٢٠٠</b></article>
        <article><span>حفظ جديد</span><b>٤,٨٩٠</b></article>
        <article><span>متوسط التقييم</span><b>4.7</b></article>
      </div>
      <div class="list-stack">${authorNovels.map(BookListItem).join("")}</div>
    `,
  );
}

function renderAcademy() {
  const gate = AuthorAccessGate();
  if (gate) return gate;
  return AuthorDashboardLayout(
    "/author/academy",
    `
      <div class="page-title"><span class="eyebrow">${dual("الأكاديمية", "Academy")}</span><h1>${dual("أكاديمية الكاتب", "Author Academy")}</h1><p>محتوى إرشادي عربي، والعقود/الدخل مستقبلية فقط.</p></div>
      <div class="book-grid">${academyPosts
        .map(
          (post) => `
          <article class="academy-card">
            <span class="eyebrow">${escapeHtml(post.type)}</span>
            <h3>${escapeHtml(post.title)}</h3>
            <p>${escapeHtml(post.time)} قراءة · ${dual("محتوى إرشادي", "Guidance content")}</p>
          </article>`,
        )
        .join("")}</div>
    `,
  );
}

function AdminAccessGate(active = "dashboard") {
  if (!appState.auth.ready) return PageShell("/admin", LoadingState());
  if (!appState.auth.user) {
    return PageShell("/admin", EmptyState("سجل الدخول كمدير", "لوحة الإدارة تعتمد على profiles.role = admin.", "/auth/login"));
  }
  if (!appState.adminPortal.loaded) {
    loadAdminPortal();
    return PageShell("/admin", LoadingState());
  }
  if (appState.adminPortal.error) {
    return PageShell("/admin", EmptyState("تعذر فتح لوحة الإدارة", appState.adminPortal.error, "/"));
  }
  return "";
}

function AdminLayout(active, body) {
  const links = [
    ["/admin", "الرئيسية", "dashboard"],
    ["/admin/users", "المستخدمون", "users"],
    ["/admin/authors", "الكتّاب", "authors"],
    ["/admin/novels", "الروايات", "novels"],
    ["/admin/content-moderation", "المحتوى", "content"],
    ["/admin/reviews", "المراجعات", "reviews"],
    ["/admin/reports", "البلاغات", "reports"],
    ["/admin/categories", "التصنيفات", "categories"],
  ];
  return PageShell(
    "/admin",
    `
      <section class="workspace-layout">
        <aside class="workspace-sidebar">
          <b>لوحة الإدارة</b>
          ${links.map(([href, label, key]) => `<a class="${active === key ? "is-active" : ""}" href="#${href}">${label}</a>`).join("")}
        </aside>
        <div class="workspace-main">
          ${appState.adminPortal.message ? `<div class="toast">${escapeHtml(appState.adminPortal.message)}</div>` : ""}
          ${body}
        </div>
      </section>
    `,
  );
}

function AdminTableErrors() {
  const entries = Object.entries(appState.adminPortal.tableErrors);
  if (!entries.length) return "";
  return `<div class="list-stack">${entries.map(([table, message]) => `<p class="auth-alert error">${escapeHtml(table)}: ${escapeHtml(message)}</p>`).join("")}</div>`;
}

function renderAdminDashboard() {
  const gate = AdminAccessGate("dashboard");
  if (gate) return gate;
  return AdminLayout(
    "dashboard",
    `
      <div class="page-title"><span class="eyebrow">${dual("الإدارة", "Admin")}</span><h1>${dual("لوحة الإدارة", "Admin Dashboard")}</h1><p>إدارة المحتوى والمستخدمين من Supabase فقط.</p></div>
      ${AdminTableErrors()}
      <div class="metric-grid">
        <article><span>المستخدمون</span><b>${appState.adminPortal.profiles.length}</b></article>
        <article><span>الكتّاب</span><b>${appState.adminPortal.authors.length}</b></article>
        <article><span>الروايات</span><b>${appState.adminPortal.books.length}</b></article>
        <article><span>البلاغات</span><b>${appState.adminPortal.reports.length}</b></article>
      </div>
    `,
  );
}

function renderAdminUsers() {
  const gate = AdminAccessGate("users");
  if (gate) return gate;
  return AdminLayout(
    "users",
    `
      <div class="page-title"><span class="eyebrow">${dual("إدارة المستخدمين", "User Management")}</span><h1>${dual("إدارة المستخدمين", "User Management")}</h1><p>تحديث الدور وحالة الظهور من profiles.</p></div>
      ${appState.adminPortal.profiles.length ? `<div class="list-stack">${appState.adminPortal.profiles.map(AdminUserRow).join("")}</div>` : EmptyState("لا توجد ملفات مستخدمين", "لم يرجع جدول profiles أي صفوف.", "/admin")}
    `,
  );
}

function AdminUserRow(profile) {
  return `
    <article class="admin-row">
      <span class="avatar">${escapeHtml((profile.display_name || profile.username || "?").slice(0, 1))}</span>
      <div><h3>${escapeHtml(profile.display_name || profile.username || profile.id)}</h3><p>${escapeHtml(profile.role || "reader")} · ${profile.is_public ? "ظاهر" : "مخفي"}</p></div>
      <select data-admin-user-role="${profile.id}">
        ${["reader", "writer", "admin"].map((role) => `<option value="${role}" ${profile.role === role ? "selected" : ""}>${role}</option>`).join("")}
      </select>
      <button class="btn secondary" data-admin-update-role="${profile.id}">تحديث</button>
      <button class="btn ghost" data-admin-toggle-public="${profile.id}" data-next-public="${profile.is_public ? "false" : "true"}">${profile.is_public ? "إخفاء" : "إظهار"}</button>
    </article>`;
}

function renderAdminAuthors() {
  const gate = AdminAccessGate("authors");
  if (gate) return gate;
  const error = appState.adminPortal.tableErrors.writer_profiles;
  return AdminLayout(
    "authors",
    `
      <div class="page-title"><span class="eyebrow">${dual("إدارة الكتّاب", "Author Management")}</span><h1>${dual("إدارة الكتّاب", "Author Management")}</h1><p>يعتمد هذا القسم على جدول writer_profiles.</p></div>
      ${error ? `<p class="auth-alert error">${escapeHtml(error)}</p>` : ""}
      ${appState.adminPortal.authors.length ? `<div class="list-stack">${appState.adminPortal.authors.map((author) => `<article class="admin-row"><div><h3>${escapeHtml(author.pen_name || author.profile?.display_name || author.profile?.username || author.id)}</h3><p>${escapeHtml(author.bio_ar || author.bio_en || (author.is_approved ? "كاتب معتمد" : "كاتب بانتظار الاعتماد"))}</p></div></article>`).join("")}</div>` : EmptyState("لا توجد بيانات كتّاب", "جدول writer_profiles فارغ.", "/admin")}
    `,
  );
}

function renderAdminNovels() {
  const gate = AdminAccessGate("novels");
  if (gate) return gate;
  return AdminLayout(
    "novels",
    `
      <div class="page-title"><span class="eyebrow">${dual("إدارة الروايات", "Novel Management")}</span><h1>${dual("إدارة الروايات", "Novel Management")}</h1><p>تحديث حالة الروايات من books.</p></div>
      ${appState.adminPortal.tableErrors.books ? `<p class="auth-alert error">${escapeHtml(appState.adminPortal.tableErrors.books)}</p>` : ""}
      ${appState.adminPortal.books.length ? `<div class="list-stack">${appState.adminPortal.books.map(AdminBookRow).join("")}</div>` : EmptyState("لا توجد روايات", "جدول books لا يرجع عناصر حاليا.", "/admin")}
    `,
  );
}

function AdminBookRow(book) {
  return `
    <article class="admin-row">
      ${BookCover(book)}
      <div><h3>${escapeHtml(book.title)}</h3><p>${escapeHtml(book.author)} · ${escapeHtml(book.approval || book.rawStatus)}</p></div>
      <select data-admin-book-status="${book.id}">
        ${["draft", "in_review", "published", "rejected", "archived"].map((status) => `<option value="${status}" ${book.rawStatus === status ? "selected" : ""}>${status}</option>`).join("")}
      </select>
      <button class="btn secondary" data-admin-update-book="${book.id}">حفظ الحالة</button>
    </article>`;
}

function renderAdminReviews() {
  const gate = AdminAccessGate("reviews");
  if (gate) return gate;
  return AdminLayout(
    "reviews",
    `
      <div class="page-title"><span class="eyebrow">${dual("مراجعة التقييمات", "Review Moderation")}</span><h1>${dual("مراجعة التقييمات", "Review Moderation")}</h1><p>يعتمد هذا القسم على جدول ratings.</p></div>
      ${appState.adminPortal.tableErrors.ratings ? `<p class="auth-alert error">${escapeHtml(appState.adminPortal.tableErrors.ratings)}</p>` : ""}
      ${appState.adminPortal.reviews.length ? `<div class="list-stack">${appState.adminPortal.reviews.map((review) => `<article class="admin-row"><div><h3>${escapeHtml(String(review.rating || ""))} نجوم</h3><p>${escapeHtml(review.review || review.id)}</p></div></article>`).join("")}</div>` : EmptyState("لا توجد مراجعات", "جدول ratings فارغ.", "/admin")}
    `,
  );
}

function renderAdminReports() {
  const gate = AdminAccessGate("reports");
  if (gate) return gate;
  return AdminLayout(
    "reports",
    `
      <div class="page-title"><span class="eyebrow">${dual("طابور البلاغات", "Reports Queue")}</span><h1>${dual("طابور البلاغات", "Reports Queue")}</h1><p>متابعة بلاغات reports.</p></div>
      ${appState.adminPortal.tableErrors.reports ? `<p class="auth-alert error">${escapeHtml(appState.adminPortal.tableErrors.reports)}</p>` : ""}
      ${appState.adminPortal.reports.length ? `<div class="list-stack">${appState.adminPortal.reports.map(AdminReportRow).join("")}</div>` : EmptyState("لا توجد بلاغات", "جدول reports فارغ حاليا.", "/admin")}
    `,
  );
}

function AdminReportRow(report) {
  return `
    <article class="admin-row">
      <div><h3>${escapeHtml(report.reason || report.type || report.id)}</h3><p>${escapeHtml(report.status || "open")} · ${escapeHtml(report.created_at || "")}</p></div>
      <select data-admin-report-status="${report.id}">
        ${["open", "reviewing", "resolved", "dismissed"].map((status) => `<option value="${status}" ${report.status === status ? "selected" : ""}>${status}</option>`).join("")}
      </select>
      <button class="btn secondary" data-admin-update-report="${report.id}">حفظ</button>
    </article>`;
}

function renderAdminCategories() {
  const gate = AdminAccessGate("categories");
  if (gate) return gate;
  return AdminLayout(
    "categories",
    `
      <div class="page-title"><span class="eyebrow">${dual("التصنيفات", "Categories")}</span><h1>${dual("التصنيفات", "Categories")}</h1><p>تحديث التصنيفات الحالية من categories.</p></div>
      ${appState.adminPortal.tableErrors.categories ? `<p class="auth-alert error">${escapeHtml(appState.adminPortal.tableErrors.categories)}</p>` : ""}
      ${appState.adminPortal.categories.length ? `<div class="list-stack">${appState.adminPortal.categories.map(AdminCategoryRow).join("")}</div>` : EmptyState("لا توجد تصنيفات", "جدول categories لا يرجع عناصر.", "/admin")}
    `,
  );
}

function AdminCategoryRow(category) {
  return `
    <article class="admin-row">
      <form class="editor-form full" data-admin-category-form="${category.id}">
        <label><span>الاسم</span><input name="name_ar" value="${escapeHtml(category.name)}" /></label>
        <label><span>${dual("المعرّف", "Slug")}</span><input name="slug" value="${escapeHtml(category.slug)}" /></label>
        <label><span>الترتيب</span><input name="sort_order" type="number" value="${escapeHtml(category.sortOrder || 0)}" /></label>
        <label><span>الحالة</span><select name="is_active"><option value="true" ${category.isActive ? "selected" : ""}>نشط</option><option value="false" ${!category.isActive ? "selected" : ""}>مخفي</option></select></label>
        <div class="form-actions"><button class="btn secondary" type="submit">حفظ التصنيف</button></div>
      </form>
    </article>`;
}

function renderNotFound() {
  return PageShell("", EmptyState("الصفحة غير موجودة", "المسار المطلوب غير موجود في MVP.", "/"));
}

async function initAuth() {
  const auth = authApi();
  if (!auth) {
    syncAuthState({ ready: true });
    return;
  }

  auth.onChange((nextState) => {
    const previousUserId = appState.auth.user?.id || "";
    syncAuthState(nextState);
    const nextUserId = appState.auth.user?.id || "";
    if (nextUserId && getRoute().path === "/auth/callback") {
      window.location.hash = "/profile";
      return;
    }
    if (previousUserId !== nextUserId) {
      resetAuthorPortal();
      resetReadingFeatures();
      resetSocialFeatures();
      resetNotifications();
      resetAdminPortal();
    }
    route();
  });

  try {
    await auth.init();
    syncAuthState(auth.getState());
    if (appState.auth.user && getRoute().path === "/auth/callback") {
      window.location.hash = "/profile";
      return;
    }
  } catch (error) {
    syncAuthState({
      ready: true,
      lastError: error.message || "تعذر تهيئة المصادقة.",
    });
  }
  route();
}

function route() {
  const { path, params } = getRoute();
  let html;
  if (path === "/") html = renderHome();
  else if (path === "/browse") html = renderBrowse();
  else if (path.startsWith("/genre/")) html = renderBrowse(path.split("/")[2]);
  else if (path === "/search") html = renderSearch(params.get("q") || "");
  else if (path.match(/^\/novels\/[^/]+\/chapters\/[^/]+$/)) {
    const [, , bookId, , chapterId] = path.split("/");
    html = renderReader(bookId, chapterId);
  } else if (path.match(/^\/novels\/[^/]+\/reviews$/)) html = renderNovelReviews(path.split("/")[2]);
  else if (path.startsWith("/novels/")) html = renderNovelDetails(path.split("/")[2]);
  else if (path === "/library") html = renderLibrary();
  else if (path === "/library/history") html = renderHistory();
  else if (path === "/profile") html = renderProfile();
  else if (path === "/auth/login") html = renderAuth("login");
  else if (path === "/auth/register" || path === "/auth/signup") html = renderAuth("register");
  else if (path === "/auth/callback") html = renderAuthCallback();
  else if (path === "/author") html = renderAuthorDashboard();
  else if (path === "/author/novels") html = renderMyNovels();
  else if (path === "/author/drafts") html = renderMyNovels("drafts");
  else if (path === "/author/published") html = renderMyNovels("published");
  else if (path === "/author/novels/new") html = NovelForm("create");
  else if (path.match(/^\/author\/novels\/[^/]+\/edit$/)) html = NovelForm("edit", path.split("/")[3]);
  else if (path.match(/^\/author\/novels\/[^/]+\/chapters\/new$/)) html = renderChapterForm(path.split("/")[3]);
  else if (path.match(/^\/author\/novels\/[^/]+\/chapters\/[^/]+\/edit$/)) html = renderChapterForm(path.split("/")[3], path.split("/")[5]);
  else if (path.match(/^\/author\/novels\/[^/]+\/chapters$/)) html = renderChapterManager(path.split("/")[3], params.get("filter") || "all");
  else if (path === "/author/analytics") html = renderAnalytics();
  else if (path === "/author/academy") html = renderAcademy();
  else if (path === "/admin") html = renderAdminDashboard();
  else if (path === "/admin/users") html = renderAdminUsers();
  else if (path === "/admin/authors") html = renderAdminAuthors();
  else if (path === "/admin/content-moderation") html = renderAdminNovels();
  else if (path === "/admin/novels") html = renderAdminNovels();
  else if (path === "/admin/reviews") html = renderAdminReviews();
  else if (path === "/admin/reports") html = renderAdminReports();
  else if (path === "/admin/categories") html = renderAdminCategories();
  else html = renderNotFound();

  document.querySelector("#app").innerHTML = html;
  bindInteractions();
  window.scrollTo({ top: 0, behavior: "instant" });
}

function bindInteractions() {
  document.querySelectorAll("[data-admin-update-role]").forEach((button) => {
    button.addEventListener("click", () => {
      const userId = button.getAttribute("data-admin-update-role");
      const select = document.querySelector(`[data-admin-user-role="${userId}"]`);
      updateAdminUserRole(userId, select?.value || "reader");
    });
  });

  document.querySelectorAll("[data-admin-toggle-public]").forEach((button) => {
    button.addEventListener("click", () => {
      toggleAdminUserVisibility(button.getAttribute("data-admin-toggle-public"), button.getAttribute("data-next-public") === "true");
    });
  });

  document.querySelectorAll("[data-admin-update-book]").forEach((button) => {
    button.addEventListener("click", () => {
      const bookId = button.getAttribute("data-admin-update-book");
      const select = document.querySelector(`[data-admin-book-status="${bookId}"]`);
      updateAdminBookStatus(bookId, select?.value || "draft");
    });
  });

  document.querySelectorAll("[data-admin-update-report]").forEach((button) => {
    button.addEventListener("click", () => {
      const reportId = button.getAttribute("data-admin-update-report");
      const select = document.querySelector(`[data-admin-report-status="${reportId}"]`);
      updateAdminReportStatus(reportId, select?.value || "open");
    });
  });

  document.querySelectorAll("[data-admin-category-form]").forEach((form) => {
    form.addEventListener("submit", (event) => {
      event.preventDefault();
      updateAdminCategory(form);
    });
  });

  document.querySelectorAll("[data-review-form]").forEach((form) => {
    form.addEventListener("submit", (event) => {
      event.preventDefault();
      submitReview(form);
    });
  });

  document.querySelectorAll("[data-book-reaction]").forEach((button) => {
    button.addEventListener("click", () => {
      setBookReaction(button.getAttribute("data-book-id"), button.getAttribute("data-book-reaction"));
    });
  });

  document.querySelectorAll("[data-follow-author]").forEach((button) => {
    button.addEventListener("click", () => {
      toggleFollowAuthor(button.getAttribute("data-follow-author"));
    });
  });

  document.querySelectorAll("[data-author-chapter-form]").forEach((form) => {
    form.addEventListener("submit", (event) => {
      event.preventDefault();
      saveAuthorChapter(form);
    });
  });

  document.querySelectorAll("[data-delete-chapter]").forEach((button) => {
    button.addEventListener("click", () => {
      const bookId = button.getAttribute("data-book-id");
      const chapterId = button.getAttribute("data-delete-chapter");
      deleteAuthorChapter(bookId, chapterId);
    });
  });

  document.querySelectorAll("[data-reorder-chapter]").forEach((button) => {
    button.addEventListener("click", () => {
      const bookId = button.getAttribute("data-book-id");
      const chapterId = button.getAttribute("data-reorder-chapter");
      const direction = button.getAttribute("data-direction");
      reorderAuthorChapter(bookId, chapterId, direction);
    });
  });

  document.querySelectorAll("[data-author-novel-form]").forEach((form) => {
    form.addEventListener("submit", (event) => {
      event.preventDefault();
      saveAuthorNovel(form);
    });
  });

  document.querySelectorAll("[data-auth-form]").forEach((form) => {
    form.addEventListener("submit", async (event) => {
      event.preventDefault();
      const auth = authApi();
      const mode = form.getAttribute("data-auth-mode");
      const formData = new FormData(form);
      const email = String(formData.get("email") || "").trim();
      const password = String(formData.get("password") || "");
      const username = String(formData.get("username") || "").trim();

      if (!auth) {
        syncAuthState({ lastError: "ملف Supabase Auth غير محمل." });
        route();
        return;
      }

      appState.authBusy = true;
      appState.authMessage = "";
      syncAuthState({ lastError: "" });
      route();

      try {
        if (mode === "register") {
          await auth.register({ email, password, username });
          appState.authMessage = "تم إرسال طلب إنشاء الحساب. تحقق من البريد إذا كان تأكيد البريد مفعلا في Supabase.";
        } else {
          await auth.login(email, password);
          appState.authMessage = "تم تسجيل الدخول بنجاح.";
        }
        syncAuthState(auth.getState());
        window.location.hash = "/profile";
      } catch (error) {
        syncAuthState({ lastError: error.message || "فشلت عملية المصادقة." });
      } finally {
        appState.authBusy = false;
        route();
      }
    });
  });

  document.querySelectorAll("[data-oauth]").forEach((button) => {
    button.addEventListener("click", async () => {
      const auth = authApi();
      const provider = button.getAttribute("data-oauth");
      appState.authMessage = "";
      syncAuthState({ lastError: "" });
      if (!auth?.oauth) {
        syncAuthState({ lastError: "ملف Supabase OAuth غير محمل." });
        route();
        return;
      }
      try {
        await auth.oauth(provider);
      } catch (error) {
        syncAuthState({ lastError: error.message || "تعذر بدء تسجيل الدخول الخارجي." });
        route();
      }
    });
  });

  document.querySelectorAll("[data-guest]").forEach((button) => {
    button.addEventListener("click", async () => {
      const auth = authApi();
      appState.authMessage = "";
      syncAuthState({ lastError: "" });
      try {
        if (auth) {
          await auth.continueAsGuest();
          syncAuthState(auth.getState());
        } else {
          syncAuthState({ ready: true, session: null, user: null, isGuest: true });
        }
        appState.authMessage = "تم تفعيل وضع الضيف.";
        window.location.hash = "/profile";
      } catch (error) {
        syncAuthState({ lastError: error.message || "تعذر تفعيل وضع الضيف." });
        route();
      }
    });
  });

  document.querySelectorAll("[data-logout]").forEach((button) => {
    button.addEventListener("click", async () => {
      const auth = authApi();
      appState.authMessage = "";
      syncAuthState({ lastError: "" });
      try {
        if (auth) {
          await auth.logout();
          syncAuthState(auth.getState());
        } else {
          syncAuthState({ ready: true, session: null, user: null, isGuest: false });
        }
        appState.authMessage = "تم تسجيل الخروج.";
        window.location.hash = "/auth/login";
      } catch (error) {
        syncAuthState({ lastError: error.message || "تعذر تسجيل الخروج." });
        route();
      }
    });
  });

  document.querySelectorAll("[data-search-form]").forEach((form) => {
    form.addEventListener("submit", (event) => {
      event.preventDefault();
      const q = new FormData(form).get("q") || "";
      window.location.hash = `/search?q=${encodeURIComponent(String(q).trim())}`;
    });
  });

  document.querySelectorAll("[data-save]").forEach((button) => {
    button.addEventListener("click", () => {
      const id = button.getAttribute("data-save");
      toggleLibraryBook(id);
    });
  });

  document.querySelectorAll(".app-download-modal .close").forEach((button) => {
    button.addEventListener("click", () => {
      button.closest(".app-download-modal")?.remove();
    });
  });
}

window.addEventListener("hashchange", route);
initAuth();
route();
