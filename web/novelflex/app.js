const genres = [
  { slug: "fantasy", label: "خيال" },
  { slug: "romance", label: "رومانسي" },
  { slug: "urban", label: "حضري" },
  { slug: "mystery", label: "غموض" },
  { slug: "sci-fi", label: "خيال علمي" },
  { slug: "historical", label: "تاريخي" },
  { slug: "comedy", label: "كوميديا" },
  { slug: "drama", label: "دراما" },
];

const books = [
  {
    id: "ink-city",
    title: "مدينة الحبر الأخيرة",
    author: "ليان منصور",
    genre: "fantasy",
    genreLabel: "خيال",
    status: "منشورة",
    chapters: 86,
    rating: 4.8,
    reads: "2.4M",
    saved: "48K",
    color: "cover-teal",
    summary:
      "قارئة تكتشف أن رواية قديمة لا تنتهي، وكل فصل جديد يعيد تشكيل المدينة التي تعيش فيها.",
    tags: ["عوالم موازية", "بطلة قوية", "غموض"],
  },
  {
    id: "sand-gate",
    title: "بوابة الرمل",
    author: "ناصر الرومي",
    genre: "historical",
    genreLabel: "تاريخي",
    status: "مكتملة",
    chapters: 124,
    rating: 4.7,
    reads: "1.8M",
    saved: "31K",
    color: "cover-gold",
    summary:
      "رحلة بين ممالك عربية قديمة وأسرار لا تظهر إلا حين يختفي آخر ضوء في الصحراء.",
    tags: ["مغامرة", "تراث", "أسرار"],
  },
  {
    id: "neon-vow",
    title: "وعد النيون",
    author: "سارة البحري",
    genre: "urban",
    genreLabel: "حضري",
    status: "قيد النشر",
    chapters: 52,
    rating: 4.6,
    reads: "940K",
    saved: "18K",
    color: "cover-blue",
    summary:
      "في مدينة لا تنام، يطارد محقق شاب رسالة مشفرة تقوده إلى عائلة تخفي نصف تاريخ المدينة.",
    tags: ["تحقيق", "حضري", "تشويق"],
  },
  {
    id: "glass-letters",
    title: "رسائل الزجاج",
    author: "ميرا يونس",
    genre: "romance",
    genreLabel: "رومانسي",
    status: "منشورة",
    chapters: 67,
    rating: 4.5,
    reads: "1.1M",
    saved: "22K",
    color: "cover-rose",
    summary:
      "تبدأ القصة برسالة بلا توقيع وتنتهي باختيار صعب بين حياة آمنة وحلم قديم.",
    tags: ["رومانسي", "دراما", "بطيء الاشتعال"],
  },
  {
    id: "orbit-nine",
    title: "مدار تسعة",
    author: "آدم سليم",
    genre: "sci-fi",
    genreLabel: "خيال علمي",
    status: "منشورة",
    chapters: 44,
    rating: 4.4,
    reads: "610K",
    saved: "12K",
    color: "cover-violet",
    summary:
      "طاقم صغير في محطة بعيدة يكتشف أن الإشارة التي ينتظرونها منذ سنوات ليست بشرية.",
    tags: ["فضاء", "نجاة", "تقنية"],
  },
  {
    id: "silent-court",
    title: "المحكمة الصامتة",
    author: "جاد الكيلاني",
    genre: "mystery",
    genreLabel: "غموض",
    status: "مكتملة",
    chapters: 91,
    rating: 4.9,
    reads: "3.2M",
    saved: "54K",
    color: "cover-ink",
    summary:
      "قاضية سابقة تعود لقضية ظنت أنها انتهت، لتجد أن الشهود جميعاً اختفوا في الليلة نفسها.",
    tags: ["جريمة", "قضاء", "تشويق"],
  },
];

const catalogState = {
  books: [],
  categories: [],
  loaded: false,
  loading: false,
  error: "",
  searchResults: new Map(),
  searchLoading: "",
  searchError: "",
};

const chapterState = {
  byBook: new Map(),
  loadingBooks: new Set(),
  errors: new Map(),
  progress: new Map(),
  progressSaving: new Set(),
  openedEvents: new Set(),
  completedEvents: new Set(),
  progressMessage: "",
};

const interactionState = {
  favoriteBookIds: new Set(),
  followedAuthorIds: new Set(),
  reactedBookIds: new Set(),
  reactionCheckedBookIds: new Set(),
  reactionLoadingBookIds: new Set(),
  reviewsByBook: new Map(),
  libraryBooks: [],
  readingHistory: [],
  loadedForUser: "",
  loading: false,
  reactionsAvailable: null,
  actionMessage: "",
  error: "",
};

const adminState = {
  loaded: false,
  loading: false,
  error: "",
  actionMessage: "",
  profile: null,
  reports: [],
  profiles: [],
  authors: [],
  categories: [],
  books: [],
  chapters: [],
};

const authorAccessState = {
  loaded: false,
  loading: false,
  error: "",
  profile: null,
  author: null,
};

const coverColors = ["cover-teal", "cover-gold", "cover-blue", "cover-rose", "cover-violet", "cover-ink"];

const chapters = [
  { id: "c1", title: "الفصل 1: باب لا يظهر في الخرائط", words: "2,480", read: true },
  { id: "c2", title: "الفصل 2: المدينة تقرأك أولاً", words: "2,930", read: true },
  { id: "c3", title: "الفصل 3: الحبر الذي يتنفس", words: "3,120", read: false },
  { id: "c4", title: "الفصل 4: سوق العناوين المفقودة", words: "2,760", read: false },
  { id: "c5", title: "الفصل 5: وعد تحت المطر", words: "3,040", read: false },
];

const reviews = [
  {
    name: "مها القارئة",
    rating: 5,
    date: "اليوم",
    body:
      "الإيقاع ممتاز والشخصيات واضحة. أكثر شيء أعجبني أن كل فصل يترك سؤالاً جديداً بدون إطالة.",
  },
  {
    name: "راشد",
    rating: 4,
    date: "أمس",
    body:
      "العالم جميل جداً، وأتمنى أن تكون الفصول القادمة أعمق في خلفية المدينة وقوانينها.",
  },
  {
    name: "نورة",
    rating: 5,
    date: "منذ 3 أيام",
    body:
      "قرأت أول عشرة فصول في جلسة واحدة. الكتابة سلسة والحوارات طبيعية.",
  },
];

const historyItems = [
  { bookId: "ink-city", chapter: "الفصل 3", progress: 62, time: "قبل ساعتين" },
  { bookId: "silent-court", chapter: "الفصل 18", progress: 44, time: "أمس" },
  { bookId: "glass-letters", chapter: "الفصل 7", progress: 81, time: "الأسبوع الماضي" },
];

const authorNovels = [
  {
    id: "ink-city",
    title: "مدينة الحبر الأخيرة",
    status: "منشورة",
    chapters: 86,
    views: "2.4M",
    saves: "48K",
    rating: 4.8,
    updated: "اليوم",
    completion: 92,
    color: "cover-teal",
  },
  {
    id: "paper-moon",
    title: "قمر الورق",
    status: "مسودة",
    chapters: 12,
    views: "18K",
    saves: "820",
    rating: 4.1,
    updated: "أمس",
    completion: 38,
    color: "cover-rose",
  },
  {
    id: "north-library",
    title: "مكتبة الشمال",
    status: "قيد المراجعة",
    chapters: 27,
    views: "112K",
    saves: "4.6K",
    rating: 4.4,
    updated: "منذ 3 أيام",
    completion: 64,
    color: "cover-blue",
  },
];

const academyPosts = [
  {
    title: "كيف تبني افتتاحية قوية خلال أول 800 كلمة",
    type: "Writing Guide",
    time: "درس 8 دقائق",
  },
  {
    title: "قائمة مراجعة قبل نشر الفصل الأول",
    type: "Academy Feed",
    time: "تحديث اليوم",
  },
  {
    title: "فهم العقود والمنح: دليل تعريفي فقط",
    type: "Contract Guide",
    time: "مرحلة مستقبلية",
  },
];

const app = document.querySelector("#app");
const SEO_BASE_URL = "https://novelflex.online";
const SEO_DEFAULT_IMAGE = `${SEO_BASE_URL}/assets/home_screen.jpg`;
const CACHE_VERSION = "v1";
const CACHE_TTL = {
  catalog: 5 * 60 * 1000,
  search: 2 * 60 * 1000,
  chapters: 5 * 60 * 1000,
  reviews: 2 * 60 * 1000,
  private: 45 * 1000,
};

document.querySelector("[data-search-form]").addEventListener("submit", (event) => {
  event.preventDefault();
  const query = new FormData(event.currentTarget).get("q")?.toString().trim() || "";
  location.hash = `#/search${query ? `?q=${encodeURIComponent(query)}` : ""}`;
});

window.addEventListener("hashchange", renderRoute);
window.addEventListener("DOMContentLoaded", () => {
  window.NovelFlexAuth?.onChange((auth) => {
    updateAccountPill();
    if (!auth.user) {
      interactionState.favoriteBookIds = new Set();
      interactionState.followedAuthorIds = new Set();
      interactionState.reactedBookIds = new Set();
      interactionState.reactionCheckedBookIds = new Set();
      interactionState.reactionLoadingBookIds = new Set();
      interactionState.libraryBooks = [];
      interactionState.readingHistory = [];
      interactionState.loadedForUser = "";
      interactionState.reactionsAvailable = null;
      resetAuthorAccessState();
      resetAdminState();
    } else if (authorAccessState.profile && authorAccessState.profile.id !== auth.user.id) {
      resetAuthorAccessState();
    } else if (adminState.profile && adminState.profile.id !== auth.user.id) {
      resetAdminState();
    }
    const path = routePath().split("?")[0];
    if (path === "/auth/callback" && window.NovelFlexAuth.getState().user) {
      location.hash = "#/profile";
      return;
    }
    if (path.startsWith("/auth") || path === "/profile" || path.startsWith("/author")) {
      renderRoute();
    }
  });
  window.NovelFlexAuth?.init();
  renderRoute();
});

function routePath() {
  const searchParams = new URLSearchParams(location.search);
  const routeParam = searchParams.get("route");
  const raw = location.hash.replace(/^#/, "") || routeParam || "/";
  const querySuffix = !location.hash && routeParam && searchParams.get("q") && !raw.includes("?")
    ? `?q=${encodeURIComponent(searchParams.get("q"))}`
    : "";
  if (
    raw.startsWith("access_token=") ||
    raw.startsWith("error=") ||
    raw.includes("refresh_token=") ||
    raw.includes("error_code=")
  ) {
    return "/auth/callback";
  }
  const normalized = raw.startsWith("/") ? raw : `/${raw}`;
  return `${normalized}${querySuffix}`;
}

function renderRoute() {
  const path = routePath();
  const [cleanPath, queryString = ""] = path.split("?");
  const query = new URLSearchParams(queryString);
  setActiveNav(cleanPath);
  updateSeoForRoute(cleanPath, query);
  loadRouteChunk(cleanPath);

  if (cleanPath === "/") return mount(renderHome());
  if (cleanPath === "/browse") return mount(renderBrowse());
  if (cleanPath.startsWith("/genre/")) return mount(renderGenre(cleanPath.split("/")[2]));
  if (cleanPath === "/search") return mount(renderSearch(query.get("q") || ""));
  if (cleanPath === "/library") return mount(renderLibrary());
  if (cleanPath === "/history") return mount(renderHistory());
  if (cleanPath === "/profile") return mount(renderProfile());
  if (cleanPath === "/auth/login") return mount(renderLogin());
  if (cleanPath === "/auth/register") return mount(renderRegister());
  if (cleanPath === "/auth/callback") return mount(renderAuthCallback());
  if (cleanPath === "/author") return mount(renderAuthorDashboard());
  if (cleanPath === "/author/novels") return mount(renderAuthorNovels());
  if (cleanPath === "/author/novels/new") return mount(renderCreateNovel());
  if (cleanPath.includes("/author/novels/") && cleanPath.endsWith("/chapters")) {
    return mount(renderChapterManager(getAuthorNovelFromPath(cleanPath)));
  }
  if (cleanPath.includes("/author/novels/") && cleanPath.endsWith("/edit")) {
    return mount(renderEditNovel(getAuthorNovelFromPath(cleanPath)));
  }
  if (cleanPath === "/author/analytics") return mount(renderAuthorAnalytics());
  if (cleanPath === "/author/academy") return mount(renderAuthorAcademy());
  if (cleanPath === "/admin/reports") return mount(renderAdminReports());
  if (cleanPath === "/admin" || cleanPath === "/admin/moderation") return mount(renderAdminModeration());
  if (cleanPath === "/admin/users") return mount(renderAdminUsers());
  if (cleanPath === "/admin/authors") return mount(renderAdminAuthors());
  if (cleanPath === "/admin/categories") return mount(renderAdminCategories());
  if (cleanPath === "/admin/content-approval") return mount(renderAdminContentApproval());
  if (cleanPath.includes("/reviews")) return mount(renderReviews(getBookFromPath(cleanPath)));
  if (cleanPath.includes("/chapters/")) return mount(renderReader(getBookFromPath(cleanPath), getChapterIdFromPath(cleanPath)));
  if (cleanPath.startsWith("/novels/")) return mount(renderNovelDetails(getBookFromPath(cleanPath)));

  mount(renderNotFound());
}

function mount(html) {
  app.innerHTML = html;
  attachPageHandlers();
  updateAccountPill();
  app.focus({ preventScroll: true });
  window.scrollTo({ top: 0, behavior: "auto" });
}

function setActiveNav(path) {
  document.querySelectorAll(".desktop-nav a").forEach((link) => {
    const hrefPath = link.getAttribute("href")?.replace(/^#/, "") || "";
    const active = hrefPath === "/" ? path === "/" : path.startsWith(hrefPath);
    link.classList.toggle("is-active", active);
  });

  document.querySelectorAll("[data-mobile-route]").forEach((link) => {
    const route = link.getAttribute("data-mobile-route");
    const active = route === "/" ? path === "/" : path.startsWith(route);
    link.classList.toggle("is-active", active);
  });
}

function updateAccountPill() {
  const pill = document.querySelector("[data-account-pill]");
  const label = document.querySelector("[data-account-label]");
  if (!pill || !label) return;

  const auth = window.NovelFlexAuth?.getState();
  if (auth?.user) {
    pill.setAttribute("href", "#/profile");
    label.textContent = window.NovelFlexAuth.displayName();
    return;
  }
  if (auth?.isGuest) {
    pill.setAttribute("href", "#/profile");
    label.textContent = "ضيف";
    return;
  }

  pill.setAttribute("href", "#/auth/login");
  label.textContent = "تسجيل الدخول";
}

function attachPageHandlers() {
  const loginForm = document.querySelector("[data-login-form]");
  loginForm?.addEventListener("submit", async (event) => {
    event.preventDefault();
    await runAuthAction(loginForm, async () => {
      const form = new FormData(loginForm);
      await window.NovelFlexAuth.login(form.get("email"), form.get("password"));
      location.hash = "#/profile";
    });
  });

  const registerForm = document.querySelector("[data-register-form]");
  registerForm?.addEventListener("submit", async (event) => {
    event.preventDefault();
    await runAuthAction(registerForm, async () => {
      const form = new FormData(registerForm);
      await window.NovelFlexAuth.register({
        email: form.get("email"),
        password: form.get("password"),
        username: form.get("username"),
      });
      setAuthMessage(registerForm, "تم إنشاء الحساب. إذا كان تأكيد البريد مفعلاً، افتح رابط التأكيد من بريدك.");
    });
  });

  document.querySelectorAll("[data-oauth]").forEach((button) => {
    button.addEventListener("click", async () => {
      await runAuthAction(button.closest("[data-auth-card]"), async () => {
        await window.NovelFlexAuth.oauth(button.getAttribute("data-oauth"));
      });
    });
  });

  document.querySelectorAll("[data-guest]").forEach((button) => {
    button.addEventListener("click", async () => {
      await window.NovelFlexAuth.continueAsGuest();
      location.hash = "#/";
    });
  });

  document.querySelectorAll("[data-logout]").forEach((button) => {
    button.addEventListener("click", async () => {
      await window.NovelFlexAuth.logout();
      location.hash = "#/auth/login";
    });
  });

  document.querySelectorAll("[data-save-book]").forEach((button) => {
    button.addEventListener("click", async () => {
      await toggleFavorite(button.getAttribute("data-save-book"));
    });
  });

  document.querySelectorAll("[data-follow-author]").forEach((button) => {
    button.addEventListener("click", async () => {
      await toggleFollow(button.getAttribute("data-follow-author"));
    });
  });

  document.querySelectorAll("[data-react-book]").forEach((button) => {
    button.addEventListener("click", async () => {
      await toggleBookReaction(button.getAttribute("data-react-book"));
    });
  });

  document.querySelectorAll("[data-remove-favorite]").forEach((button) => {
    button.addEventListener("click", async () => {
      await removeFavorite(button.getAttribute("data-remove-favorite"));
    });
  });

  document.querySelectorAll("[data-admin-update-report]").forEach((button) => {
    button.addEventListener("click", async () => {
      const reportId = button.getAttribute("data-admin-update-report");
      const select = document.querySelector(`[data-admin-report-status="${reportId}"]`);
      await updateReportStatus(reportId, select?.value || "reviewing");
    });
  });

  document.querySelectorAll("[data-admin-update-role]").forEach((button) => {
    button.addEventListener("click", async () => {
      const userId = button.getAttribute("data-admin-update-role");
      const select = document.querySelector(`[data-admin-user-role="${userId}"]`);
      await updateUserRole(userId, select?.value || "reader");
    });
  });

  document.querySelectorAll("[data-admin-toggle-public]").forEach((button) => {
    button.addEventListener("click", async () => {
      await updateUserVisibility(button.getAttribute("data-admin-toggle-public"), button.getAttribute("data-next-public") === "true");
    });
  });

  document.querySelectorAll("[data-admin-author-approval]").forEach((button) => {
    button.addEventListener("click", async () => {
      await updateAuthorApproval(button.getAttribute("data-admin-author-approval"), button.getAttribute("data-next-approved") === "true");
    });
  });

  document.querySelectorAll("[data-admin-content-status]").forEach((button) => {
    button.addEventListener("click", async () => {
      await updateContentStatus({
        type: button.getAttribute("data-admin-content-type"),
        id: button.getAttribute("data-admin-content-id"),
        status: button.getAttribute("data-admin-content-status"),
      });
    });
  });

  document.querySelectorAll("[data-admin-category-form]").forEach((form) => {
    form.addEventListener("submit", async (event) => {
      event.preventDefault();
      const data = new FormData(form);
      await updateCategory(form.getAttribute("data-admin-category-form"), {
        name_ar: data.get("name_ar"),
        name_en: data.get("name_en"),
        slug: data.get("slug"),
        description_ar: data.get("description_ar"),
        sort_order: data.get("sort_order"),
        is_active: data.get("is_active") === "on",
      });
    });
  });

  const reviewForm = document.querySelector("[data-review-form]");
  reviewForm?.addEventListener("submit", async (event) => {
    event.preventDefault();
    const form = new FormData(reviewForm);
    await submitReview({
      bookId: reviewForm.getAttribute("data-book-id"),
      rating: form.get("rating"),
      review: form.get("review"),
    });
  });

  const readerPage = document.querySelector("[data-reader-page]");
  if (readerPage) {
    const input = readerPage.querySelector("[data-progress-input]");
    const label = readerPage.querySelector("[data-progress-label]");
    const status = readerPage.querySelector("[data-progress-status]");
    input?.addEventListener("input", () => {
      if (label) label.textContent = `${input.value}%`;
    });
    readerPage.querySelector("[data-save-progress]")?.addEventListener("click", async () => {
      await ChapterService.saveProgress(readerPage.dataset.bookId, readerPage.dataset.chapterId, input?.value || 0);
      if (status) status.textContent = chapterState.progressMessage;
    });
    readerPage.querySelector("[data-reader-font]")?.addEventListener("click", () => {
      readerPage.classList.toggle("reader-large-text");
    });
    readerPage.querySelector("[data-reader-theme]")?.addEventListener("click", () => {
      readerPage.classList.toggle("reader-night");
    });
  }
}

async function runAuthAction(container, action) {
  if (!container) return;
  const status = container.querySelector("[data-auth-status]");
  try {
    if (status) status.textContent = "جاري التنفيذ...";
    await action();
    if (status && status.textContent === "جاري التنفيذ...") status.textContent = "";
  } catch (error) {
    if (status) status.textContent = error.message || "تعذر تنفيذ العملية.";
  }
}

function setAuthMessage(container, message) {
  const status = container.querySelector("[data-auth-status]");
  if (status) status.textContent = message;
}

function supabaseClient() {
  return window.NovelFlexAuth?.client;
}

function cacheKey(scope, key = "default") {
  return `novelflex:${CACHE_VERSION}:${scope}:${key}`;
}

function readCache(scope, key, ttl, storage = localStorage) {
  try {
    const raw = storage.getItem(cacheKey(scope, key));
    if (!raw) return null;
    const cached = JSON.parse(raw);
    if (!cached?.createdAt || Date.now() - cached.createdAt > ttl) {
      storage.removeItem(cacheKey(scope, key));
      return null;
    }
    return cached.value;
  } catch {
    return null;
  }
}

function writeCache(scope, key, value, storage = localStorage) {
  try {
    storage.setItem(cacheKey(scope, key), JSON.stringify({ createdAt: Date.now(), value }));
  } catch {
    // Cache is a performance hint only. Quota/private-mode failures should not break the app.
  }
}

function clearCache(scope, key, storage = localStorage) {
  try {
    storage.removeItem(cacheKey(scope, key));
  } catch {
    // ignore
  }
}

const loadedRouteChunks = new Set();

function loadRouteChunk(path) {
  const chunk = path.startsWith("/admin")
    ? "admin"
    : path.includes("/chapters/")
      ? "reader"
      : "";
  if (!chunk || loadedRouteChunks.has(chunk)) return;
  loadedRouteChunks.add(chunk);
  import(`./routes/${chunk}.js`).catch(() => {
    loadedRouteChunks.delete(chunk);
  });
}

function seoRouteUrl(path = "/") {
  const cleanPath = path === "/" ? "/" : path;
  return cleanPath === "/" ? `${SEO_BASE_URL}/` : `${SEO_BASE_URL}/?route=${encodeURIComponent(cleanPath)}`;
}

function setMetaAttribute(selector, attribute, value) {
  let element = document.head.querySelector(selector);
  if (!element) {
    element = document.createElement("meta");
    const nameMatch = selector.match(/meta\[name="([^"]+)"\]/);
    const propertyMatch = selector.match(/meta\[property="([^"]+)"\]/);
    if (nameMatch) element.setAttribute("name", nameMatch[1]);
    if (propertyMatch) element.setAttribute("property", propertyMatch[1]);
    document.head.appendChild(element);
  }
  element.setAttribute(attribute, value);
}

function setLinkHref(rel, href) {
  let element = document.head.querySelector(`link[rel="${rel}"]`);
  if (!element) {
    element = document.createElement("link");
    element.setAttribute("rel", rel);
    document.head.appendChild(element);
  }
  element.setAttribute("href", href);
}

function updateJsonLd(payload) {
  let element = document.head.querySelector("[data-seo-jsonld]");
  if (!element) {
    element = document.createElement("script");
    element.type = "application/ld+json";
    element.setAttribute("data-seo-jsonld", "");
    document.head.appendChild(element);
  }
  element.textContent = JSON.stringify(payload);
}

function updateSeo({ title, description, path = "/", image = SEO_DEFAULT_IMAGE, type = "website", jsonLd }) {
  const url = seoRouteUrl(path);
  document.title = title;
  setMetaAttribute('meta[name="description"]', "content", description);
  setMetaAttribute('meta[name="robots"]', "content", path.startsWith("/auth") || path.startsWith("/admin") || path.startsWith("/profile") || path.startsWith("/library") || path.startsWith("/history") ? "noindex, nofollow" : "index, follow, max-image-preview:large");
  setLinkHref("canonical", url);
  setMetaAttribute('meta[property="og:type"]', "content", type);
  setMetaAttribute('meta[property="og:title"]', "content", title);
  setMetaAttribute('meta[property="og:description"]', "content", description);
  setMetaAttribute('meta[property="og:url"]', "content", url);
  setMetaAttribute('meta[property="og:image"]', "content", image);
  setMetaAttribute('meta[name="twitter:title"]', "content", title);
  setMetaAttribute('meta[name="twitter:description"]', "content", description);
  setMetaAttribute('meta[name="twitter:image"]', "content", image);
  updateJsonLd(jsonLd || {
    "@context": "https://schema.org",
    "@type": "WebSite",
    name: "NOVELFLEX",
    url: SEO_BASE_URL,
    inLanguage: "ar",
    potentialAction: {
      "@type": "SearchAction",
      target: `${SEO_BASE_URL}/?route=/search&q={search_term_string}`,
      "query-input": "required name=search_term_string",
    },
  });
}

function updateSeoForRoute(path, query = new URLSearchParams()) {
  if (path === "/") {
    updateSeo({
      title: "NOVELFLEX | روايات عربية وقراءة تفاعلية",
      description: "اكتشف روايات عربية، اقرأ الفصول، احفظ مكتبتك، وتابع الكتّاب على NOVELFLEX.",
      path,
    });
    return;
  }
  if (path === "/browse") {
    updateSeo({
      title: "تصفح الروايات | NOVELFLEX",
      description: "تصفح الروايات العربية حسب التصنيف والحالة والتقييم على NOVELFLEX.",
      path,
    });
    return;
  }
  if (path.startsWith("/genre/")) {
    const slug = path.split("/")[2] || "";
    updateSeo({
      title: `روايات ${slug} | NOVELFLEX`,
      description: "اكتشف روايات عربية حسب النوع والتصنيف على NOVELFLEX.",
      path,
    });
    return;
  }
  if (path === "/search") {
    const value = query.get("q") || "";
    updateSeo({
      title: value ? `بحث عن ${value} | NOVELFLEX` : "بحث الروايات | NOVELFLEX",
      description: "ابحث عن روايات وكتّاب عرب داخل منصة NOVELFLEX.",
      path: value ? `/search?q=${encodeURIComponent(value)}` : path,
    });
    return;
  }
  if (path.startsWith("/novels/")) {
    updateSeo({
      title: "رواية على NOVELFLEX",
      description: "تفاصيل الرواية والفصول والمراجعات على NOVELFLEX.",
      path,
      type: "book",
    });
    return;
  }
  if (path.startsWith("/author")) {
    updateSeo({
      title: "استوديو الكاتب | NOVELFLEX",
      description: "بوابة الكاتب لإدارة الروايات والفصول على NOVELFLEX.",
      path,
    });
    return;
  }
  updateSeo({
    title: "NOVELFLEX",
    description: "منصة عربية لاكتشاف الروايات وقراءة الفصول ومتابعة الكتّاب.",
    path,
  });
}

function updateSeoForBook(book) {
  if (!book) return;
  const path = `/novels/${book.id}`;
  const title = `${book.title} | NOVELFLEX`;
  const description = book.summary || `اقرأ ${book.title} بقلم ${book.author} على NOVELFLEX.`;
  const image = book.coverUrl || SEO_DEFAULT_IMAGE;
  updateSeo({
    title,
    description,
    path,
    image,
    type: "book",
    jsonLd: {
      "@context": "https://schema.org",
      "@type": "Book",
      name: book.title,
      author: {
        "@type": "Person",
        name: book.author,
      },
      description,
      image,
      inLanguage: "ar",
      url: seoRouteUrl(path),
      aggregateRating: Number(book.rating) > 0 ? {
        "@type": "AggregateRating",
        ratingValue: String(book.rating),
        bestRating: "5",
        ratingCount: String(book.ratingsCount || 1),
      } : undefined,
      genre: book.genreLabel,
    },
  });
}

function liveBooks() {
  return catalogState.books;
}

function liveCategories() {
  return catalogState.categories;
}

function chaptersForBook(bookId) {
  return chapterState.byBook.get(bookId) || [];
}

function isUuid(value) {
  return /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i.test(String(value || ""));
}

function chapterProgressKey(bookId, chapterId) {
  return `${bookId}:${chapterId}`;
}

async function loadCatalog({ force = false } = {}) {
  if (catalogState.loading) return;
  if (catalogState.loaded && !force) return;
  const cached = !force ? readCache("catalog", "published", CACHE_TTL.catalog) : null;
  if (cached) {
    catalogState.categories = cached.categories || [];
    catalogState.books = cached.books || [];
    catalogState.loaded = true;
    catalogState.error = "";
    return;
  }

  catalogState.loading = true;
  catalogState.error = "";
  renderRoute();

  try {
    const client = supabaseClient();
    if (!client) throw new Error("Supabase client is not ready.");

    const [categoriesResult, booksResult] = await Promise.all([
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
    ]);

    if (categoriesResult.error) throw categoriesResult.error;
    if (booksResult.error) throw booksResult.error;

    catalogState.categories = (categoriesResult.data || []).map(normalizeCategory);
    catalogState.books = (booksResult.data || []).map(normalizeBook);
    catalogState.loaded = true;
    writeCache("catalog", "published", {
      categories: catalogState.categories,
      books: catalogState.books,
    });
  } catch (error) {
    catalogState.error = error.message || "تعذر تحميل بيانات Supabase.";
  } finally {
    catalogState.loading = false;
    renderRoute();
  }
}

async function searchSupabaseBooks(query) {
  const needle = query.trim();
  if (!needle) {
    await loadCatalog();
    return liveBooks();
  }
  if (catalogState.searchResults.has(needle)) return catalogState.searchResults.get(needle);
  const cached = readCache("search", needle.toLowerCase(), CACHE_TTL.search);
  if (cached) {
    catalogState.searchResults.set(needle, cached);
    return cached;
  }

  const client = supabaseClient();
  if (!client) throw new Error("Supabase client is not ready.");

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
    .or(`title_ar.ilike.%${escaped}%,title_en.ilike.%${escaped}%,description_ar.ilike.%${escaped}%,description_en.ilike.%${escaped}%`)
    .order("published_at", { ascending: false })
    .limit(50);

  if (error) throw error;
  const results = (data || []).map(normalizeBook);
  catalogState.searchResults.set(needle, results);
  writeCache("search", needle.toLowerCase(), results);
  return results;
}

async function loadBookChapters(bookId, { force = false } = {}) {
  if (!bookId) return [];
  if (!isUuid(bookId)) {
    chapterState.byBook.set(bookId, []);
    return [];
  }
  const cached = !force ? readCache("chapters", bookId, CACHE_TTL.chapters) : null;
  if (cached) {
    chapterState.byBook.set(bookId, cached);
    chapterState.errors.delete(bookId);
    return cached;
  }
  if (chapterState.loadingBooks.has(bookId)) return chaptersForBook(bookId);
  if (chapterState.byBook.has(bookId) && !force) return chaptersForBook(bookId);

  chapterState.loadingBooks.add(bookId);
  chapterState.errors.delete(bookId);
  renderRoute();

  try {
    const client = supabaseClient();
    if (!client) throw new Error("Supabase client is not ready.");
    const { data, error } = await client
      .from("chapters")
      .select("id,book_id,chapter_number,title_ar,title_en,content_text,file_path,audio_path,status,published_at,created_at")
      .eq("book_id", bookId)
      .eq("status", "published")
      .order("chapter_number", { ascending: true });

    if (error) throw error;
    const normalized = (data || []).map(normalizeChapter);
    chapterState.byBook.set(bookId, normalized);
    writeCache("chapters", bookId, normalized);
    return normalized;
  } catch (error) {
    chapterState.errors.set(bookId, error.message || "تعذر تحميل الفصول.");
    return [];
  } finally {
    chapterState.loadingBooks.delete(bookId);
    renderRoute();
  }
}

async function loadReadingProgress(bookId, chapterId) {
  const key = chapterProgressKey(bookId, chapterId);
  if (chapterState.progress.has(key)) return chapterState.progress.get(key);

  const auth = window.NovelFlexAuth?.getState();
  if (!auth?.user) {
    const local = Number(localStorage.getItem(`novelflex_reading_progress:${key}`) || 0);
    chapterState.progress.set(key, local);
    return local;
  }

  const client = supabaseClient();
  if (!client || !isUuid(bookId) || !isUuid(chapterId)) return 0;
  const { data, error } = await client
    .from("reading_progress")
    .select("progress_percent,last_position,last_read_at")
    .eq("user_id", auth.user.id)
    .eq("book_id", bookId)
    .eq("chapter_id", chapterId)
    .order("last_read_at", { ascending: false })
    .limit(1);

  if (!error) {
    const value = Number(data?.[0]?.progress_percent || data?.[0]?.last_position?.percent || 0);
    chapterState.progress.set(key, value);
    renderRoute();
    return value;
  }
  return 0;
}

async function logChapterReadEvent(bookId, chapterId, eventType) {
  if (!isUuid(bookId) || !isUuid(chapterId)) return;
  const key = `${eventType}:${bookId}:${chapterId}`;
  const cache = eventType === "completed" ? chapterState.completedEvents : chapterState.openedEvents;
  if (cache.has(key)) return;

  try {
    const client = supabaseClient();
    if (!client) return;
    const user = currentUser();
    const { error } = await client.from("chapter_read_events").insert({
      user_id: user?.id || null,
      book_id: bookId,
      chapter_id: chapterId,
      event_type: eventType,
    });
    if (error) throw error;
    cache.add(key);
  } catch (error) {
    if (!isMissingTableError(error)) console.warn("Chapter read event was not logged", error);
  }
}

async function saveReadingProgress(bookId, chapterId, percent) {
  const key = chapterProgressKey(bookId, chapterId);
  const safePercent = Math.max(0, Math.min(100, Number(percent || 0)));
  const auth = window.NovelFlexAuth?.getState();
  chapterState.progressSaving.add(key);
  chapterState.progressMessage = "جاري حفظ التقدم...";
  renderRoute();

  try {
    if (!auth?.user) {
      localStorage.setItem(`novelflex_reading_progress:${key}`, String(safePercent));
      chapterState.progress.set(key, safePercent);
      chapterState.progressMessage = "تم حفظ التقدم محلياً للضيف.";
      return;
    }

    const client = supabaseClient();
    if (!client) throw new Error("Supabase client is not ready.");
    if (!isUuid(bookId) || !isUuid(chapterId)) throw new Error("لا يمكن حفظ التقدم إلا لفصل مرتبط ببيانات Supabase الحقيقية.");

    const existing = await client
      .from("reading_progress")
      .select("id")
      .eq("user_id", auth.user.id)
      .eq("book_id", bookId)
      .eq("chapter_id", chapterId)
      .order("last_read_at", { ascending: false })
      .limit(1);
    if (existing.error) throw existing.error;

    const payload = {
      user_id: auth.user.id,
      book_id: bookId,
      chapter_id: chapterId,
      progress_percent: safePercent,
      last_position: { percent: safePercent, source: "novelflex-web" },
      last_read_at: new Date().toISOString(),
    };

    const result = existing.data?.[0]?.id
      ? await client.from("reading_progress").update(payload).eq("id", existing.data[0].id)
      : await client.from("reading_progress").insert(payload);
    if (result.error) throw result.error;

    chapterState.progress.set(key, safePercent);
    chapterState.progressMessage = "تم حفظ التقدم في Supabase.";
    clearCache("interactions", auth.user.id, sessionStorage);
    if (safePercent >= 100) await logChapterReadEvent(bookId, chapterId, "completed");
  } catch (error) {
    chapterState.progressMessage = error.message || "تعذر حفظ التقدم.";
  } finally {
    chapterState.progressSaving.delete(key);
    renderRoute();
  }
}

const ChapterService = {
  listByBook: loadBookChapters,
  getProgress: loadReadingProgress,
  saveProgress: saveReadingProgress,
};

function currentUser() {
  return window.NovelFlexAuth?.getState()?.user || null;
}

function requireSignedIn() {
  const user = currentUser();
  if (!user) throw new Error("سجل الدخول أولاً لتنفيذ هذا الإجراء.");
  return user;
}

function resetAdminState() {
  adminState.loaded = false;
  adminState.loading = false;
  adminState.error = "";
  adminState.actionMessage = "";
  adminState.profile = null;
  adminState.reports = [];
  adminState.profiles = [];
  adminState.authors = [];
  adminState.categories = [];
  adminState.books = [];
  adminState.chapters = [];
}

function resetAuthorAccessState() {
  authorAccessState.loaded = false;
  authorAccessState.loading = false;
  authorAccessState.error = "";
  authorAccessState.profile = null;
  authorAccessState.author = null;
}

function isMissingTableError(error) {
  const message = `${error?.message || ""} ${error?.details || ""} ${error?.hint || ""}`;
  return error?.code === "42P01" || /relation .* does not exist|Could not find the table|schema cache/i.test(message);
}

async function loadUserInteractions({ force = false } = {}) {
  const user = currentUser();
  if (!user) return;
  if (interactionState.loading) return;
  if (interactionState.loadedForUser === user.id && !force) return;
  const cached = !force ? readCache("interactions", user.id, CACHE_TTL.private, sessionStorage) : null;
  if (cached) {
    interactionState.favoriteBookIds = new Set(cached.favoriteBookIds || []);
    interactionState.followedAuthorIds = new Set(cached.followedAuthorIds || []);
    interactionState.libraryBooks = cached.libraryBooks || [];
    interactionState.readingHistory = cached.readingHistory || [];
    interactionState.loadedForUser = user.id;
    interactionState.error = "";
    renderRoute();
    return;
  }

  interactionState.loading = true;
  interactionState.error = "";

  try {
    const client = supabaseClient();
    if (!client) throw new Error("Supabase client is not ready.");
    const [favoritesResult, followsResult, progressResult] = await Promise.all([
      client
        .from("favorites")
        .select(
          [
            "id",
            "book_id",
            "created_at",
            "book:books!favorites_book_id_fkey(id,author_id,category_id,title_ar,title_en,description_ar,description_en,cover_url,status,language,views_count,likes_count,rating_average,ratings_count,chapters_count,published_at,created_at,author:profiles!books_author_id_fkey(id,display_name,username,avatar_url,bio),category:categories!books_category_id_fkey(id,slug,name_ar,name_en))",
          ].join(","),
        )
        .eq("user_id", user.id)
        .order("created_at", { ascending: false }),
      client.from("follows").select("id,author_id,created_at").eq("follower_id", user.id),
      client
        .from("reading_progress")
        .select(
          [
            "id",
            "book_id",
            "chapter_id",
            "progress_percent",
            "last_position",
            "last_read_at",
            "book:books!reading_progress_book_id_fkey(id,author_id,category_id,title_ar,title_en,description_ar,description_en,cover_url,status,language,views_count,likes_count,rating_average,ratings_count,chapters_count,published_at,created_at,author:profiles!books_author_id_fkey(id,display_name,username,avatar_url,bio),category:categories!books_category_id_fkey(id,slug,name_ar,name_en))",
            "chapter:chapters!reading_progress_chapter_id_fkey(id,chapter_number,title_ar,title_en)",
          ].join(","),
        )
        .eq("user_id", user.id)
        .order("last_read_at", { ascending: false }),
    ]);

    if (favoritesResult.error) throw favoritesResult.error;
    if (followsResult.error) throw followsResult.error;
    if (progressResult.error) throw progressResult.error;

    interactionState.favoriteBookIds = new Set((favoritesResult.data || []).map((row) => row.book_id));
    interactionState.followedAuthorIds = new Set((followsResult.data || []).map((row) => row.author_id));
    interactionState.libraryBooks = (favoritesResult.data || [])
      .filter((row) => row.book)
      .map((row, index) => ({ favoriteId: row.id, createdAt: row.created_at, book: normalizeBook(row.book, index) }));
    interactionState.readingHistory = (progressResult.data || [])
      .filter((row) => row.book)
      .map((row, index) => ({
        id: row.id,
        book: normalizeBook(row.book, index),
        chapterId: row.chapter_id,
        chapterTitle: row.chapter?.title_ar || row.chapter?.title_en || "فصل",
        progress: Number(row.progress_percent || row.last_position?.percent || 0),
        lastReadAt: row.last_read_at,
      }));
    interactionState.loadedForUser = user.id;
    writeCache("interactions", user.id, {
      favoriteBookIds: [...interactionState.favoriteBookIds],
      followedAuthorIds: [...interactionState.followedAuthorIds],
      libraryBooks: interactionState.libraryBooks,
      readingHistory: interactionState.readingHistory,
    }, sessionStorage);
  } catch (error) {
    interactionState.error = error.message || "تعذر تحميل تفاعلات المستخدم.";
  } finally {
    interactionState.loading = false;
    renderRoute();
  }
}

async function loadBookReactionState(bookId, { force = false } = {}) {
  const user = currentUser();
  if (!user || !isUuid(bookId)) return false;
  if (interactionState.reactionsAvailable === false) return false;
  if (interactionState.reactionLoadingBookIds.has(bookId)) return interactionState.reactedBookIds.has(bookId);
  if (!force && interactionState.reactionCheckedBookIds.has(bookId)) return interactionState.reactedBookIds.has(bookId);
  if (!force && interactionState.reactedBookIds.has(bookId)) return true;

  try {
    const client = supabaseClient();
    if (!client) return false;
    interactionState.reactionLoadingBookIds.add(bookId);
    const { data, error } = await client
      .from("book_reactions")
      .select("id")
      .eq("user_id", user.id)
      .eq("book_id", bookId)
      .eq("reaction_type", "like")
      .limit(1);
    if (error) throw error;
    interactionState.reactionsAvailable = true;
    if (data?.[0]?.id) interactionState.reactedBookIds.add(bookId);
    else interactionState.reactedBookIds.delete(bookId);
    interactionState.reactionCheckedBookIds.add(bookId);
    renderRoute();
    return Boolean(data?.[0]?.id);
  } catch (error) {
    if (isMissingTableError(error)) {
      interactionState.reactionsAvailable = false;
      interactionState.reactionCheckedBookIds.add(bookId);
      return false;
    }
    interactionState.actionMessage = error.message || "تعذر تحميل تفاعل الرواية.";
    renderRoute();
    return false;
  } finally {
    interactionState.reactionLoadingBookIds.delete(bookId);
  }
}

async function loadBookReviews(bookId, { force = false } = {}) {
  if (!bookId || !isUuid(bookId)) return [];
  if (interactionState.reviewsByBook.has(bookId) && !force) return interactionState.reviewsByBook.get(bookId);
  const cached = !force ? readCache("reviews", bookId, CACHE_TTL.reviews) : null;
  if (cached) {
    interactionState.reviewsByBook.set(bookId, cached);
    return cached;
  }

  const client = supabaseClient();
  if (!client) return [];
  const { data, error } = await client
    .from("ratings")
    .select("id,book_id,user_id,rating,review,created_at,profile:profiles!ratings_user_id_fkey(id,display_name,username,avatar_url)")
    .eq("book_id", bookId)
    .order("created_at", { ascending: false });

  if (!error) {
    const normalized = (data || []).map(normalizeReview);
    interactionState.reviewsByBook.set(bookId, normalized);
    writeCache("reviews", bookId, normalized);
    renderRoute();
    return normalized;
  }
  interactionState.actionMessage = error.message || "تعذر تحميل المراجعات.";
  return [];
}

async function toggleFavorite(bookId) {
  try {
    const user = requireSignedIn();
    if (!isUuid(bookId)) throw new Error("لا يمكن حفظ رواية غير مرتبطة ببيانات Supabase الحقيقية.");
    const client = supabaseClient();
    const existing = await client.from("favorites").select("id").eq("user_id", user.id).eq("book_id", bookId).limit(1);
    if (existing.error) throw existing.error;

    if (existing.data?.[0]?.id) {
      const result = await client.from("favorites").delete().eq("id", existing.data[0].id);
      if (result.error) throw result.error;
      interactionState.favoriteBookIds.delete(bookId);
      interactionState.actionMessage = "تمت إزالة الرواية من المكتبة.";
      await logFavoriteEvent(client, user.id, bookId, "unfavorited");
    } else {
      const result = await client.from("favorites").insert({ user_id: user.id, book_id: bookId });
      if (result.error) throw result.error;
      interactionState.favoriteBookIds.add(bookId);
      interactionState.actionMessage = "تم حفظ الرواية في مكتبتك.";
      await logFavoriteEvent(client, user.id, bookId, "favorited");
    }
    clearCache("interactions", user.id, sessionStorage);
    await loadUserInteractions({ force: true });
  } catch (error) {
    interactionState.actionMessage = error.message || "تعذر حفظ الرواية.";
    renderRoute();
  }
}

async function removeFavorite(bookId) {
  try {
    const user = requireSignedIn();
    const client = supabaseClient();
    const result = await client.from("favorites").delete().eq("user_id", user.id).eq("book_id", bookId);
    if (result.error) throw result.error;
    interactionState.favoriteBookIds.delete(bookId);
    interactionState.actionMessage = "تمت إزالة الرواية من المكتبة.";
    await logFavoriteEvent(client, user.id, bookId, "unfavorited");
    clearCache("interactions", user.id, sessionStorage);
    await loadUserInteractions({ force: true });
  } catch (error) {
    interactionState.actionMessage = error.message || "تعذر إزالة الرواية.";
    renderRoute();
  }
}

async function toggleFollow(authorId) {
  try {
    const user = requireSignedIn();
    if (!isUuid(authorId)) throw new Error("لا يمكن متابعة كاتب غير مرتبط بملف Supabase.");
    const client = supabaseClient();
    const existing = await client.from("follows").select("id").eq("follower_id", user.id).eq("author_id", authorId).limit(1);
    if (existing.error) throw existing.error;

    if (existing.data?.[0]?.id) {
      const result = await client.from("follows").delete().eq("id", existing.data[0].id);
      if (result.error) throw result.error;
      interactionState.followedAuthorIds.delete(authorId);
      interactionState.actionMessage = "تم إلغاء متابعة الكاتب.";
      await logFollowEvent(client, user.id, authorId, "unfollowed");
    } else {
      const result = await client.from("follows").insert({ follower_id: user.id, author_id: authorId });
      if (result.error) throw result.error;
      interactionState.followedAuthorIds.add(authorId);
      interactionState.actionMessage = "تمت متابعة الكاتب.";
      await logFollowEvent(client, user.id, authorId, "followed");
    }
    clearCache("interactions", user.id, sessionStorage);
    await loadUserInteractions({ force: true });
  } catch (error) {
    interactionState.actionMessage = error.message || "تعذر تحديث المتابعة.";
    renderRoute();
  }
}

async function toggleBookReaction(bookId) {
  try {
    const user = requireSignedIn();
    if (!isUuid(bookId)) throw new Error("لا يمكن تسجيل تفاعل لرواية غير مرتبطة ببيانات Supabase الحقيقية.");
    if (interactionState.reactionsAvailable === false) {
      throw new Error("جدول book_reactions غير موجود في Supabase حالياً. التقييمات والحفظ والمتابعة تعمل عبر الجداول المتاحة.");
    }
    const client = supabaseClient();
    const existing = await client
      .from("book_reactions")
      .select("id")
      .eq("user_id", user.id)
      .eq("book_id", bookId)
      .eq("reaction_type", "like")
      .limit(1);
    if (existing.error) throw existing.error;

    if (existing.data?.[0]?.id) {
      const result = await client.from("book_reactions").delete().eq("id", existing.data[0].id);
      if (result.error) throw result.error;
      interactionState.reactedBookIds.delete(bookId);
      interactionState.actionMessage = "تم إلغاء الإعجاب.";
    } else {
      const result = await client.from("book_reactions").insert({ user_id: user.id, book_id: bookId, reaction_type: "like" });
      if (result.error) throw result.error;
      interactionState.reactedBookIds.add(bookId);
      interactionState.actionMessage = "تم تسجيل الإعجاب.";
    }
    interactionState.reactionsAvailable = true;
    interactionState.reactionCheckedBookIds.add(bookId);
    renderRoute();
  } catch (error) {
    if (isMissingTableError(error)) {
      interactionState.reactionsAvailable = false;
      interactionState.actionMessage = "جدول book_reactions غير موجود في Supabase حالياً.";
    } else {
      interactionState.actionMessage = error.message || "تعذر تحديث التفاعل.";
    }
    renderRoute();
  }
}

async function submitReview({ bookId, rating, review }) {
  try {
    const user = requireSignedIn();
    if (!isUuid(bookId)) throw new Error("لا يمكن تقييم رواية غير مرتبطة ببيانات Supabase الحقيقية.");
    const safeRating = Math.max(1, Math.min(5, Number(rating || 0)));
    const client = supabaseClient();
    const existing = await client.from("ratings").select("id").eq("user_id", user.id).eq("book_id", bookId).limit(1);
    if (existing.error) throw existing.error;
    const payload = { user_id: user.id, book_id: bookId, rating: safeRating, review: String(review || "").trim() || null };
    const result = existing.data?.[0]?.id
      ? await client.from("ratings").update(payload).eq("id", existing.data[0].id)
      : await client.from("ratings").insert(payload);
    if (result.error) throw result.error;
    interactionState.actionMessage = "تم حفظ المراجعة.";
    interactionState.reviewsByBook.delete(bookId);
    clearCache("reviews", bookId);
    await loadBookReviews(bookId, { force: true });
  } catch (error) {
    interactionState.actionMessage = error.message || "تعذر حفظ المراجعة.";
    renderRoute();
  }
}

async function logFavoriteEvent(client, userId, bookId, eventType) {
  const { error } = await client.from("favorite_events").insert({ user_id: userId, book_id: bookId, event_type: eventType });
  if (error && !isMissingTableError(error)) console.warn("Favorite event was not logged", error);
}

async function logFollowEvent(client, userId, authorId, eventType) {
  const { error } = await client.from("follow_events").insert({ user_id: userId, author_id: authorId, event_type: eventType });
  if (error && !isMissingTableError(error)) console.warn("Follow event was not logged", error);
}

function isAdminProfile(profile = adminState.profile) {
  return profile?.role === "admin";
}

function hasAuthorAccess() {
  return ["writer", "admin"].includes(authorAccessState.profile?.role || "");
}

async function loadAuthorAccess({ force = false } = {}) {
  const user = currentUser();
  if (!user) return;
  if (authorAccessState.loading) return;
  if (authorAccessState.loaded && !force) return;

  authorAccessState.loading = true;
  authorAccessState.error = "";
  renderRoute();

  try {
    const client = supabaseClient();
    if (!client) throw new Error("Supabase client is not ready.");

    const [profileResult, authorResult] = await Promise.all([
      client
        .from("profiles")
        .select("id,role,display_name,username,avatar_url,bio,created_at,updated_at")
        .eq("id", user.id)
        .maybeSingle(),
      client
        .from("writer_profiles")
        .select("id,user_id,pen_name,is_approved,created_at,updated_at")
        .eq("user_id", user.id)
        .maybeSingle(),
    ]);

    if (profileResult.error) throw profileResult.error;
    if (authorResult.error && !isMissingTableError(authorResult.error)) throw authorResult.error;

    authorAccessState.profile = profileResult.data || null;
    authorAccessState.author = authorResult.data || null;
    authorAccessState.loaded = true;
    if (!hasAuthorAccess()) {
      authorAccessState.error = "بوابة الكاتب مخصصة لحسابات writer أو admin فقط.";
    }
  } catch (error) {
    authorAccessState.error = error.message || "تعذر التحقق من صلاحية الكاتب.";
    authorAccessState.loaded = true;
  } finally {
    authorAccessState.loading = false;
    renderRoute();
  }
}

function renderAuthorAccessGate() {
  const auth = window.NovelFlexAuth?.getState();
  if (!auth?.ready) return renderDataState("جاري تحميل الجلسة...");
  if (!auth.user) return renderDataState("سجل الدخول للوصول إلى بوابة الكاتب", "بوابة الكاتب تحتاج حسابا بصلاحية writer أو admin.", true);
  if (!authorAccessState.loaded && !authorAccessState.loading) loadAuthorAccess();
  if (authorAccessState.loading) return renderDataState("جاري التحقق من صلاحية الكاتب...");
  if (authorAccessState.error) return renderDataState("صلاحية غير كافية", authorAccessState.error, true);
  if (!hasAuthorAccess()) return renderDataState("صلاحية غير كافية", "حسابك الحالي ليس writer أو admin في جدول profiles.", true);
  return "";
}

async function loadAdminData({ force = false } = {}) {
  const user = currentUser();
  if (!user) return;
  if (adminState.loading) return;
  if (adminState.loaded && !force) return;
  const cached = !force ? readCache("admin", user.id, CACHE_TTL.private, sessionStorage) : null;
  if (cached) {
    adminState.profile = cached.profile || null;
    adminState.reports = cached.reports || [];
    adminState.profiles = cached.profiles || [];
    adminState.authors = cached.authors || [];
    adminState.categories = cached.categories || [];
    adminState.books = cached.books || [];
    adminState.chapters = cached.chapters || [];
    adminState.loaded = Boolean(adminState.profile?.role === "admin");
    adminState.error = adminState.loaded ? "" : "هذه اللوحة مخصصة لحسابات الإدارة فقط.";
    renderRoute();
    return;
  }

  adminState.loading = true;
  adminState.error = "";
  renderRoute();

  try {
    const client = supabaseClient();
    if (!client) throw new Error("Supabase client is not ready.");

    const profileResult = await client
      .from("profiles")
      .select("id,role,display_name,username,avatar_url,bio,preferred_language,is_public,created_at,updated_at")
      .eq("id", user.id)
      .maybeSingle();
    if (profileResult.error) throw profileResult.error;
    if (!profileResult.data || profileResult.data.role !== "admin") {
      adminState.profile = profileResult.data || null;
      throw new Error("هذه اللوحة مخصصة لحسابات الإدارة فقط.");
    }
    adminState.profile = profileResult.data;

    const [reportsResult, profilesResult, authorsResult, categoriesResult, booksResult, chaptersResult] = await Promise.all([
      client
        .from("reports")
        .select(
          [
            "id",
            "reporter_id",
            "reported_user_id",
            "book_id",
            "chapter_id",
            "comment_id",
            "reason",
            "details",
            "status",
            "admin_notes",
            "resolved_by",
            "resolved_at",
            "created_at",
            "updated_at",
            "reporter:profiles!reports_reporter_id_fkey(id,display_name,username,role)",
            "reported_user:profiles!reports_reported_user_id_fkey(id,display_name,username,role)",
            "book:books!reports_book_id_fkey(id,title_ar,title_en,status)",
            "chapter:chapters!reports_chapter_id_fkey(id,chapter_number,title_ar,title_en,status)",
            "comment:comments!reports_comment_id_fkey(id,body,is_deleted)",
          ].join(","),
        )
        .order("created_at", { ascending: false })
        .limit(80),
      client
        .from("profiles")
        .select("id,role,display_name,username,avatar_url,bio,preferred_language,is_public,created_at,updated_at")
        .order("created_at", { ascending: false })
        .limit(100),
      client
        .from("writer_profiles")
        .select("id,user_id,pen_name,bio_ar,bio_en,website_url,social_links,is_approved,created_at,updated_at,profile:profiles!writer_profiles_user_id_fkey(id,display_name,username,role,is_public)")
        .order("created_at", { ascending: false })
        .limit(100),
      client
        .from("categories")
        .select("id,slug,name_ar,name_en,description_ar,description_en,sort_order,is_active,created_at,updated_at")
        .order("sort_order", { ascending: true })
        .order("name_ar", { ascending: true }),
      client
        .from("books")
        .select("id,author_id,category_id,title_ar,title_en,status,language,chapters_count,published_at,created_at,updated_at,author:profiles!books_author_id_fkey(id,display_name,username),category:categories!books_category_id_fkey(id,slug,name_ar,name_en)")
        .order("created_at", { ascending: false })
        .limit(100),
      client
        .from("chapters")
        .select("id,book_id,chapter_number,title_ar,title_en,status,published_at,created_at,updated_at,book:books!chapters_book_id_fkey(id,title_ar,title_en,status)")
        .order("created_at", { ascending: false })
        .limit(100),
    ]);

    [reportsResult, profilesResult, authorsResult, categoriesResult, booksResult, chaptersResult].forEach((result) => {
      if (result.error) throw result.error;
    });

    adminState.reports = reportsResult.data || [];
    adminState.profiles = profilesResult.data || [];
    adminState.authors = authorsResult.data || [];
    adminState.categories = categoriesResult.data || [];
    adminState.books = booksResult.data || [];
    adminState.chapters = chaptersResult.data || [];
    adminState.loaded = true;
    writeCache("admin", user.id, {
      profile: adminState.profile,
      reports: adminState.reports,
      profiles: adminState.profiles,
      authors: adminState.authors,
      categories: adminState.categories,
      books: adminState.books,
      chapters: adminState.chapters,
    }, sessionStorage);
  } catch (error) {
    adminState.error = error.message || "تعذر تحميل لوحة الإدارة.";
  } finally {
    adminState.loading = false;
    renderRoute();
  }
}

async function runAdminAction(action, successMessage) {
  try {
    const user = requireSignedIn();
    if (!isAdminProfile()) throw new Error("لا تملك صلاحية الإدارة أو لم يتم تحميل ملف الإدارة.");
    const client = supabaseClient();
    if (!client) throw new Error("Supabase client is not ready.");
    await action(client, user);
    adminState.actionMessage = successMessage;
    adminState.loaded = false;
    clearCache("admin", user.id, sessionStorage);
    await loadAdminData({ force: true });
  } catch (error) {
    adminState.actionMessage = error.message || "تعذر تنفيذ إجراء الإدارة.";
    renderRoute();
  }
}

async function updateReportStatus(reportId, status) {
  await runAdminAction(async (client, user) => {
    const payload = {
      status,
      admin_notes: `تم التحديث من لوحة NOVELFLEX Web إلى ${status}`,
      updated_at: new Date().toISOString(),
    };
    if (status === "resolved" || status === "dismissed") {
      payload.resolved_by = user.id;
      payload.resolved_at = new Date().toISOString();
    }
    const { error } = await client.from("reports").update(payload).eq("id", reportId);
    if (error) throw error;
  }, "تم تحديث حالة البلاغ.");
}

async function updateUserRole(userId, role) {
  await runAdminAction(async (client) => {
    const { error } = await client.from("profiles").update({ role, updated_at: new Date().toISOString() }).eq("id", userId);
    if (error) throw error;
  }, "تم تحديث دور المستخدم.");
}

async function updateUserVisibility(userId, isPublic) {
  await runAdminAction(async (client) => {
    const { error } = await client.from("profiles").update({ is_public: isPublic, updated_at: new Date().toISOString() }).eq("id", userId);
    if (error) throw error;
  }, "تم تحديث ظهور المستخدم.");
}

async function updateAuthorApproval(authorId, isApproved) {
  await runAdminAction(async (client) => {
    const { error } = await client.from("writer_profiles").update({ is_approved: isApproved, updated_at: new Date().toISOString() }).eq("id", authorId);
    if (error) throw error;
  }, isApproved ? "تم اعتماد الكاتب." : "تم إلغاء اعتماد الكاتب.");
}

async function updateCategory(categoryId, values) {
  await runAdminAction(async (client) => {
    const payload = {
      slug: String(values.slug || "").trim(),
      name_ar: String(values.name_ar || "").trim(),
      name_en: String(values.name_en || "").trim(),
      description_ar: String(values.description_ar || "").trim() || null,
      sort_order: Number(values.sort_order || 0),
      is_active: Boolean(values.is_active),
      updated_at: new Date().toISOString(),
    };
    const { error } = await client.from("categories").update(payload).eq("id", categoryId);
    if (error) throw error;
  }, "تم تحديث التصنيف.");
}

async function updateContentStatus({ type, id, status }) {
  await runAdminAction(async (client) => {
    const table = type === "chapter" ? "chapters" : "books";
    const payload = { status, updated_at: new Date().toISOString() };
    if (status === "published") payload.published_at = new Date().toISOString();
    const { error } = await client.from(table).update(payload).eq("id", id);
    if (error) throw error;
  }, "تم تحديث حالة المحتوى.");
}

function normalizeReview(row) {
  const profile = row.profile || {};
  return {
    id: row.id,
    name: profile.display_name || profile.username || "قارئ NOVELFLEX",
    rating: Number(row.rating || 0),
    date: row.created_at ? new Date(row.created_at).toLocaleDateString("ar") : "",
    body: row.review || "قيّم الرواية بدون تعليق نصي.",
  };
}

function normalizeCategory(row) {
  return {
    id: row.id,
    slug: row.slug || row.id,
    label: row.name_ar || row.name_en || "تصنيف",
    description: row.description_ar || row.description_en || "",
  };
}

function normalizeBook(row, index = 0) {
  const category = row.category || {};
  const author = row.author || {};
  const title = row.title_ar || row.title_en || "رواية بدون عنوان";
  return {
    id: row.id,
    title,
    author: author.display_name || author.username || "كاتب NOVELFLEX",
    authorId: row.author_id,
    genre: category.slug || row.category_id || "uncategorized",
    genreLabel: category.name_ar || category.name_en || "غير مصنف",
    status: bookStatusLabel(row.status),
    chapters: Number(row.chapters_count || 0),
    rating: Number(row.rating_average || 0).toFixed(1),
    ratingsCount: Number(row.ratings_count || 0),
    reads: compactNumber(row.views_count || 0),
    saved: compactNumber(row.likes_count || 0),
    color: coverColors[index % coverColors.length],
    coverUrl: row.cover_url || "",
    summary: row.description_ar || row.description_en || "لا توجد نبذة منشورة لهذه الرواية بعد.",
    tags: [category.name_ar || category.name_en, row.language ? `لغة: ${row.language}` : ""].filter(Boolean),
    publishedAt: row.published_at || row.created_at || "",
  };
}

function normalizeChapter(row) {
  return {
    id: row.id,
    bookId: row.book_id,
    number: Number(row.chapter_number || 0),
    title: row.title_ar || row.title_en || `الفصل ${row.chapter_number || ""}`,
    contentText: row.content_text || "",
    filePath: row.file_path || "",
    audioPath: row.audio_path || "",
    status: row.status || "",
    publishedAt: row.published_at || row.created_at || "",
    words: row.content_text ? compactNumber(row.content_text.trim().split(/\s+/).filter(Boolean).length) : "0",
  };
}

function mockChaptersForBook(bookId) {
  return chapters.map((chapter, index) => ({
    id: chapter.id,
    bookId,
    number: index + 1,
    title: chapter.title,
    contentText: [
      "لم تكن البداية صاخبة كما توقعت ليان. كل ما حدث أن الضوء على حافة النافذة تغيّر، ثم بدأت الكلمات القديمة تتحرك كأنها تعرف طريقها إلى الصفحة.",
      "في ذلك الصباح أدركت أن الروايات لا تكذب دائماً، وأن بعض الأبواب لا تظهر إلا لمن يقرأ الجملة الأخيرة بصوت منخفض.",
      "تقدمت خطوة واحدة، فسمعت المدينة كلها تتنفس. كان الفصل الجديد ينتظرها، وكانت تعرف أن العودة لن تكون بالشكل نفسه.",
    ].join("\n\n"),
    filePath: "",
    audioPath: "",
    status: "published",
    publishedAt: "",
    words: chapter.words,
  }));
}

function bookStatusLabel(status) {
  return {
    draft: "مسودة",
    in_review: "قيد المراجعة",
    published: "منشورة",
    archived: "مؤرشفة",
    rejected: "مرفوضة",
  }[status] || status || "غير محدد";
}

function compactNumber(value) {
  return new Intl.NumberFormat("ar", { notation: "compact", maximumFractionDigits: 1 }).format(Number(value || 0));
}

function formatDate(value) {
  if (!value) return "";
  return new Date(value).toLocaleDateString("ar", { year: "numeric", month: "short", day: "numeric" });
}

function getBookFromPath(path) {
  const id = path.split("/")[2];
  return liveBooks().find((book) => book.id === id) || books.find((book) => book.id === id) || null;
}

function getChapterIdFromPath(path) {
  return path.split("/chapters/")[1]?.split("/")[0] || "";
}

function getAuthorNovelFromPath(path) {
  const id = path.split("/")[3];
  return authorNovels.find((novel) => novel.id === id) || authorNovels[0];
}

function renderHome() {
  if (currentUser() && interactionState.loadedForUser !== currentUser().id && !interactionState.loading) loadUserInteractions();
  const featured = books[0];
  const continueItems = interactionState.readingHistory.length ? interactionState.readingHistory.slice(0, 3) : historyItems;
  return `
    <section class="hero" style="--hero-image:url('./assets/home_screen.jpg')">
      <div class="hero-copy">
        <span class="eyebrow">اختيارات هذا الأسبوع</span>
        <h1>${featured.title}</h1>
        <p>${featured.summary}</p>
        <div class="hero-actions">
          <a class="btn btn-primary" href="#/novels/${featured.id}/chapters/c1">ابدأ القراءة</a>
          <a class="btn btn-secondary" href="#/novels/${featured.id}">تفاصيل الرواية</a>
        </div>
      </div>
      <article class="hero-feature">
        ${cover(featured, "cover-large")}
        <div>
          ${rating(featured.rating)}
          <h2>${featured.author}</h2>
          <p>${featured.chapters} فصل · ${featured.reads} قراءة</p>
        </div>
      </article>
    </section>

    <section class="section-grid">
      ${sectionHeader("الأحدث انتشاراً", "روايات محدثة ومرشحة للقراءة الآن", "#/browse")}
      <div class="book-strip">${books.slice(0, 5).map(renderBookTile).join("")}</div>
    </section>

    <section class="content-grid">
      <div class="panel">
        ${sectionHeader("قوائم النوع", "اختصر الطريق حسب مزاج القراءة", "#/genre/fantasy")}
        <div class="genre-grid">${genres.map(renderGenreChip).join("")}</div>
      </div>
      <div class="panel">
        ${sectionHeader("أكمل القراءة", "آخر نشاط من مكتبتك", "#/history")}
        <div class="compact-list">${continueItems.map(renderHistoryMini).join("")}</div>
      </div>
    </section>
  `;
}

function renderBrowse() {
  if (!catalogState.loaded && !catalogState.loading) loadCatalog();
  if (catalogState.error) return renderDataState("تعذر تحميل الروايات", catalogState.error, true);

  const params = routeParams();
  return renderBrowseLayout({
    title: "تصفح الروايات",
    subtitle: "اكتشف الروايات حسب النوع والحالة والترتيب، بنفس تجربة التصفح السريعة التي يتوقعها قارئ الويب.",
    list: liveBooks(),
    activeGenre: "",
    params,
    isLoading: catalogState.loading,
  });
}

function renderGenre(slug) {
  if (!catalogState.loaded && !catalogState.loading) loadCatalog();
  if (catalogState.loading) return renderDataState("جاري تحميل التصنيف من Supabase...");
  if (catalogState.error) return renderDataState("تعذر تحميل التصنيف", catalogState.error, true);

  const genre = liveCategories().find((item) => item.slug === slug) || liveCategories()[0] || { slug, label: "تصنيف" };
  const list = liveBooks().filter((book) => book.genre === genre.slug || book.genre === genre.id);
  const params = routeParams();
  return renderBrowseLayout({
    title: genre.label,
    subtitle: genre.description || `روايات ${genre.label} المنشورة في Supabase.`,
    list,
    activeGenre: genre.slug,
    params,
    isLoading: catalogState.loading,
  });
}

function renderBrowseLayout({ title, subtitle, list, activeGenre, params = new URLSearchParams(), isLoading = false }) {
  const status = params.get("status") || "all";
  const sort = params.get("sort") || "popular";
  const page = Math.max(1, Number(params.get("page") || 1));
  const pageSize = 10;
  const filtered = sortBrowseBooks(filterBrowseBooks(list, status), sort);
  const totalPages = Math.max(1, Math.ceil(filtered.length / pageSize));
  const currentPage = Math.min(page, totalPages);
  const pageItems = filtered.slice((currentPage - 1) * pageSize, currentPage * pageSize);
  const basePath = activeGenre ? `/genre/${activeGenre}` : "/browse";
  const genreGroups = browseGenreGroups(activeGenre);
  const resultWord = filtered.length === 1 ? "رواية" : "روايات";

  return `
    <section class="browse-webnovel-shell" dir="ltr">
      <aside class="browse-sidebar" aria-label="Browse filters">
        ${genreGroups
          .map(
            (group) => `
              <div class="browse-tree-group ${group.open ? "is-open" : ""}">
                <div class="browse-tree-title">
                  <b>${escapeHtml(group.title)}</b>
                  <span>${group.open ? "⌃" : "⌄"}</span>
                </div>
                ${
                  group.open
                    ? `<div class="browse-tree-links">
                        ${group.items
                          .map(
                            (genre) => `
                              <a class="${genre.active ? "is-active" : ""}" href="#${genre.href}">
                                <span>${escapeHtml(genre.label)}</span>
                                <small>${genre.count}</small>
                              </a>
                            `,
                          )
                          .join("")}
                      </div>`
                    : ""
                }
              </div>
            `,
          )
          .join("")}
      </aside>

      <div class="browse-webnovel-main" dir="rtl">
        <header class="browse-webnovel-heading">
          <span class="eyebrow">Browse</span>
          <h1>${escapeHtml(title)}</h1>
          <p>${escapeHtml(subtitle)}</p>
        </header>

        <section class="browse-filter-block" aria-label="فلاتر المحتوى">
          <h2>فلترة حسب</h2>
          <div class="browse-filter-row">
            <span>حالة المحتوى</span>
            <div class="browse-pill-row">
              ${browseFilterLink("الكل", basePath, { status: "all", sort }, status === "all")}
              ${browseFilterLink("مكتملة", basePath, { status: "completed", sort }, status === "completed")}
              ${browseFilterLink("قيد النشر", basePath, { status: "ongoing", sort }, status === "ongoing")}
              ${browseFilterLink("منشورة", basePath, { status: "published", sort }, status === "published")}
            </div>
          </div>
        </section>

        <section class="browse-sort-block" aria-label="ترتيب النتائج">
          <h2>ترتيب حسب</h2>
          <nav class="browse-sort-tabs">
            ${browseFilterLink("الأكثر شعبية", basePath, { status, sort: "popular" }, sort === "popular")}
            ${browseFilterLink("موصى به", basePath, { status, sort: "recommended" }, sort === "recommended")}
            ${browseFilterLink("الأكثر حفظاً", basePath, { status, sort: "saved" }, sort === "saved")}
            ${browseFilterLink("التقييم", basePath, { status, sort: "rating" }, sort === "rating")}
            ${browseFilterLink("آخر تحديث", basePath, { status, sort: "updated" }, sort === "updated")}
          </nav>
        </section>

        <div class="browse-result-summary">
          <b>${filtered.length} ${resultWord}</b>
          <span>${activeGenre ? `التصنيف: ${escapeHtml(title)}` : "كل التصنيفات"} · صفحة ${currentPage} من ${totalPages}</span>
        </div>

        <section class="browse-card-grid" aria-live="polite">
          ${
            isLoading
              ? renderBrowseLoadingCards()
              : pageItems.length
                ? pageItems.map(renderBrowseCard).join("")
                : renderBrowseEmptyState(basePath, status, sort)
          }
        </section>

        ${!isLoading && filtered.length ? renderBrowsePagination(basePath, status, sort, currentPage, totalPages) : ""}
      </div>
    </section>
  `;
}

function routeParams() {
  const query = (location.hash.split("?")[1] || "").split("#")[0];
  return new URLSearchParams(query);
}

function browseUrl(path, nextParams = {}) {
  const params = new URLSearchParams();
  Object.entries(nextParams).forEach(([key, value]) => {
    if (value && value !== "all") params.set(key, value);
  });
  const query = params.toString();
  return `${path}${query ? `?${query}` : ""}`;
}

function browseFilterLink(label, path, params, active = false) {
  return `<a class="${active ? "is-active" : ""}" href="#${browseUrl(path, { ...params, page: "" })}">${escapeHtml(label)}</a>`;
}

function filterBrowseBooks(list, status) {
  if (status === "completed") return list.filter((book) => book.status === "مكتملة" || book.status === "مكتمل");
  if (status === "ongoing") return list.filter((book) => book.status === "قيد النشر" || book.status === "منشورة");
  if (status === "published") return list.filter((book) => book.status === "منشورة" || book.status === "published");
  return list;
}

function sortBrowseBooks(list, sort) {
  const toNumber = (value) => Number(String(value ?? "0").replace(/[^\d.]/g, "")) || 0;
  const copy = [...list];
  if (sort === "rating") return copy.sort((a, b) => Number(b.rating || 0) - Number(a.rating || 0));
  if (sort === "saved") return copy.sort((a, b) => toNumber(b.saved) - toNumber(a.saved));
  if (sort === "updated") return copy.sort((a, b) => new Date(b.publishedAt || 0) - new Date(a.publishedAt || 0));
  if (sort === "recommended") return copy.sort((a, b) => Number(b.chapters || 0) - Number(a.chapters || 0));
  return copy.sort((a, b) => toNumber(b.reads) - toNumber(a.reads));
}

function browseGenreGroups(activeGenre) {
  const categories = liveCategories();
  const loaded = catalogState.loaded;
  const activeBooks = liveBooks();
  const fallbackCategories = genres.map((genre) => ({
    slug: genre.slug,
    label: genre.label,
    count: loaded ? activeBooks.filter((book) => book.genre === genre.slug).length : books.filter((book) => book.genre === genre.slug).length || 0,
  }));
  const source = categories.length ? categories : fallbackCategories;
  const withAll = [
    { slug: "", label: "الكل", count: loaded ? activeBooks.length : books.length },
    ...source.map((genre) => ({
      slug: genre.slug,
      label: genre.label,
      count: loaded ? activeBooks.filter((book) => book.genre === genre.slug || book.genre === genre.id).length : genre.count || 0,
    })),
  ];
  const split = Math.max(4, Math.ceil(withAll.length / 2));
  const mapItem = (genre) => ({
    label: genre.label,
    count: genre.count,
    active: activeGenre === genre.slug || (!activeGenre && !genre.slug),
    href: genre.slug ? `/genre/${genre.slug}` : "/browse",
  });

  return [
    { title: "Genre of Novels", open: true, items: withAll.slice(0, split).map(mapItem) },
    { title: "Genre of Comics", open: true, items: withAll.slice(split).map(mapItem) },
    { title: "Genre of Fan-fic", open: false, items: [] },
  ];
}

function renderBrowseCard(book) {
  return `
    <article class="browse-book-card">
      <a class="browse-cover-link" href="#/novels/${book.id}" aria-label="فتح ${escapeAttribute(book.title)}">
        ${cover(book, "browse-cover")}
      </a>
      <div class="browse-book-info">
        <div class="browse-book-tags">${(book.tags || [book.genreLabel])
          .slice(0, 3)
          .map((tag) => `<span># ${escapeHtml(tag)}</span>`)
          .join("")}</div>
        <h2><a href="#/novels/${book.id}">${escapeHtml(book.title)}</a></h2>
        <p>${escapeHtml(book.summary)}</p>
        <div class="browse-book-meta">
          <span>★ ${escapeHtml(String(book.rating))}</span>
          <span>▣ ${escapeHtml(String(book.chapters))} فصل</span>
          <span>${escapeHtml(book.reads)} قراءة</span>
        </div>
        <div class="browse-book-actions">
          <a href="#/novels/${book.id}/chapters/c1">اقرأ</a>
          <a href="#/novels/${book.id}">+ إضافة</a>
        </div>
      </div>
    </article>
  `;
}

function renderBrowseLoadingCards() {
  return Array.from({ length: 8 })
    .map(
      () => `
        <article class="browse-book-card browse-skeleton">
          <div class="browse-skeleton-cover"></div>
          <div class="browse-book-info">
            <span></span><h2></h2><p></p><p></p><div></div>
          </div>
        </article>
      `,
    )
    .join("");
}

function renderBrowseEmptyState(path, status, sort) {
  return `
    <div class="browse-empty">
      <b>لا توجد روايات تطابق الفلاتر الحالية</b>
      <p>جرّب تغيير الحالة أو اختيار تصنيف آخر. لن نعرض زر قراءة لكتاب لا يملك فصولاً قابلة للفتح.</p>
      <a class="btn btn-primary" href="#${browseUrl(path, { status: "all", sort })}">إعادة ضبط الفلتر</a>
    </div>
  `;
}

function renderBrowsePagination(path, status, sort, page, totalPages) {
  const pages = Array.from({ length: totalPages }).map((_, index) => index + 1);
  return `
    <nav class="browse-pagination" aria-label="Pagination">
      <a class="${page <= 1 ? "is-disabled" : ""}" href="#${browseUrl(path, { status, sort, page: Math.max(1, page - 1) })}">السابق</a>
      ${pages
        .map(
          (item) =>
            `<a class="${item === page ? "is-active" : ""}" href="#${browseUrl(path, { status, sort, page: item })}">${item}</a>`,
        )
        .join("")}
      <a class="${page >= totalPages ? "is-disabled" : ""}" href="#${browseUrl(path, { status, sort, page: Math.min(totalPages, page + 1) })}">التالي</a>
    </nav>
  `;
}

function renderSearch(query) {
  const needle = query.trim();
  if (needle && !catalogState.searchResults.has(needle) && catalogState.searchLoading !== needle) {
    catalogState.searchLoading = needle;
    catalogState.searchError = "";
    searchSupabaseBooks(needle)
      .catch((error) => {
        catalogState.searchError = error.message || "تعذر البحث في Supabase.";
      })
      .finally(() => {
        catalogState.searchLoading = "";
        renderRoute();
      });
  }
  if (!needle && !catalogState.loaded && !catalogState.loading) loadCatalog();

  const results = needle ? catalogState.searchResults.get(needle) || [] : liveBooks();
  const isLoading = catalogState.searchLoading === needle || (!needle && catalogState.loading);
  return `
    <section class="page-heading">
      <div>
        <span class="eyebrow">Search</span>
        <h1>البحث</h1>
        <p>ابحث داخل الروايات المنشورة من Supabase.</p>
      </div>
    </section>
    <form class="search-page-form" onsubmit="event.preventDefault(); location.hash = '#/search?q=' + encodeURIComponent(this.q.value.trim())">
      <input name="q" type="search" value="${escapeHtml(query)}" placeholder="اكتب عنوان رواية أو اسم كاتب" />
      <button class="btn btn-primary">بحث</button>
    </form>
    <section class="results-panel">
      <div class="toolbar"><b>${results.length} نتيجة</b><span>${query ? `عن: ${escapeHtml(query)}` : "اقتراحات شائعة"}</span></div>
      ${catalogState.searchError ? `<p class="auth-status">${escapeHtml(catalogState.searchError)}</p>` : ""}
      <div class="book-list">${isLoading ? renderDataState("جاري البحث في Supabase...") : results.length ? results.map(renderBookRow).join("") : renderEmptyBooks()}</div>
    </section>
  `;
}

function renderNovelDetails(book) {
  if (!catalogState.loaded && !catalogState.loading) loadCatalog();
  if (catalogState.loading) return renderDataState("جاري تحميل تفاصيل الرواية من Supabase...");
  if (catalogState.error) return renderDataState("تعذر تحميل تفاصيل الرواية", catalogState.error, true);
  if (!book) return renderDataState("الرواية غير موجودة", "لم يتم العثور على رواية منشورة بهذا الرابط في Supabase.", true);
  updateSeoForBook(book);
  if (currentUser() && interactionState.loadedForUser !== currentUser().id) loadUserInteractions();
  if (currentUser() && isUuid(book.id) && interactionState.reactionsAvailable !== false) loadBookReactionState(book.id);
  if (isUuid(book.id) && !chapterState.byBook.has(book.id) && !chapterState.loadingBooks.has(book.id)) ChapterService.listByBook(book.id);
  const bookChapters = isUuid(book.id) ? chaptersForBook(book.id) : mockChaptersForBook(book.id);
  const chapterError = chapterState.errors.get(book.id);
  const firstChapter = bookChapters[0];
  const isSaved = interactionState.favoriteBookIds.has(book.id);
  const isFollowing = interactionState.followedAuthorIds.has(book.authorId);
  const isReacted = interactionState.reactedBookIds.has(book.id);

  return `
    <section class="novel-hero">
      ${cover(book, "cover-xl")}
      <div class="novel-hero-body">
        <div class="meta-line">
          <span class="tag tag-success">${escapeHtml(book.status)}</span>
          <span>${escapeHtml(book.genreLabel)}</span>
          <span>${book.chapters} فصل</span>
        </div>
        <h1>${escapeHtml(book.title)}</h1>
        <p class="author-line">بقلم ${escapeHtml(book.author)}</p>
        ${rating(book.rating)}
        <p>${escapeHtml(book.summary)}</p>
        <div class="tag-row">${book.tags.map((tag) => `<span class="tag">${escapeHtml(tag)}</span>`).join("")}</div>
        <div class="hero-actions">
          ${firstChapter
            ? `<a class="btn btn-primary" href="#/novels/${book.id}/chapters/${firstChapter.id}">اقرأ الآن</a>`
            : `<button class="btn btn-primary" disabled>لا توجد فصول منشورة</button>`}
          <button class="btn btn-secondary" data-save-book="${book.id}">${isSaved ? "إزالة من المكتبة" : "أضف للمكتبة"}</button>
          <button class="btn btn-secondary" data-react-book="${book.id}">${isReacted ? "إلغاء الإعجاب" : "إعجاب"}</button>
          <button class="btn btn-secondary" data-follow-author="${book.authorId}">${isFollowing ? "إلغاء متابعة الكاتب" : "متابعة الكاتب"}</button>
          <a class="btn btn-ghost" href="#/novels/${book.id}/reviews">المراجعات</a>
        </div>
        ${
          interactionState.reactionsAvailable === false
            ? `<p class="auth-status">تنبيه: جدول book_reactions غير موجود حالياً في Supabase، لذلك زر الإعجاب ينتظر تفعيل الجدول.</p>`
            : ""
        }
        ${interactionState.actionMessage ? `<p class="auth-status">${escapeHtml(interactionState.actionMessage)}</p>` : ""}
      </div>
    </section>

    <section class="detail-tabs">
      <a class="is-active" href="#/novels/${book.id}">عن الرواية</a>
      ${firstChapter ? `<a href="#/novels/${book.id}/chapters/${firstChapter.id}">الفصول</a>` : `<span>الفصول</span>`}
      <a href="#/novels/${book.id}/reviews">المراجعات</a>
    </section>

    <section class="content-grid detail-grid">
      <article class="panel">
        <h2>نبذة</h2>
        <p class="long-copy">
          ${escapeHtml(book.summary)}
        </p>
        <h2>الفصول</h2>
        ${
          isUuid(book.id) && chapterState.loadingBooks.has(book.id)
            ? renderDataState("جاري تحميل الفصول من Supabase...")
            : chapterError
              ? renderDataState("تعذر تحميل الفصول", chapterError, true)
              : bookChapters.length
                ? `<div class="chapter-list">${bookChapters.map((chapter) => renderChapterRow(book, chapter)).join("")}</div>`
                : renderDataState("لا توجد فصول منشورة", "جدول chapters متصل، لكنه لا يحتوي فصول published لهذه الرواية حالياً.")
        }
      </article>
      <aside class="panel">
        <h2>إحصائيات</h2>
        <div class="stats-grid">
          <span><b>${book.reads}</b><small>قراءة</small></span>
          <span><b>${book.saved}</b><small>حفظ</small></span>
          <span><b>${book.rating}</b><small>تقييم</small></span>
        </div>
        <h2>اقتراحات مشابهة</h2>
        <div class="compact-list">${liveBooks().filter((item) => item.id !== book.id).slice(0, 3).map(renderMiniBook).join("") || renderEmptyBooks("لا توجد اقتراحات مشابهة حالياً.")}</div>
      </aside>
    </section>
  `;
}

function renderReviews(book) {
  if (!book) return renderDataState("الرواية غير موجودة", "لم يتم العثور على رواية منشورة بهذا الرابط في Supabase.", true);
  if (!interactionState.reviewsByBook.has(book.id)) loadBookReviews(book.id);
  const liveReviews = interactionState.reviewsByBook.get(book.id) || [];
  const average = liveReviews.length
    ? (liveReviews.reduce((sum, item) => sum + item.rating, 0) / liveReviews.length).toFixed(1)
    : book.rating;

  return `
    <section class="page-heading">
      <div>
        <span class="eyebrow">Reviews</span>
        <h1>مراجعات ${escapeHtml(book.title)}</h1>
        <p>تقييمات ومراجعات محفوظة في جدول ratings الحالي في Supabase.</p>
      </div>
      <a class="btn btn-secondary" href="#/novels/${book.id}">العودة للتفاصيل</a>
    </section>
    <section class="reviews-layout">
      <aside class="rating-panel">
        <strong>${average}</strong>
        ${rating(average)}
        <small>${liveReviews.length} تقييم</small>
        ${[5, 4, 3, 2, 1]
          .map((score) => {
            const count = liveReviews.filter((item) => Math.round(item.rating) === score).length;
            const value = liveReviews.length ? Math.round((count / liveReviews.length) * 100) : 0;
            return `<div class="bar-row"><span>${score}</span><meter min="0" max="100" value="${value}"></meter></div>`;
          })
          .join("")}
      </aside>
      <div class="review-stack">
        <form class="write-review" data-review-form data-book-id="${book.id}">
          <h2>اكتب مراجعة</h2>
          <label><span>التقييم</span><input name="rating" type="number" min="1" max="5" value="5" required /></label>
          <textarea name="review" rows="4" placeholder="ما رأيك في الرواية؟"></textarea>
          <button class="btn btn-primary">نشر المراجعة</button>
          ${interactionState.actionMessage ? `<p class="auth-status">${escapeHtml(interactionState.actionMessage)}</p>` : ""}
        </form>
        ${liveReviews.length ? liveReviews.map(renderReview).join("") : renderDataState("لا توجد مراجعات بعد", "كن أول قارئ يترك مراجعة لهذه الرواية.")}
      </div>
    </section>
  `;
}

function renderReader(book, chapterId) {
  if (!catalogState.loaded && !catalogState.loading) loadCatalog();
  if (catalogState.loading) return renderDataState("جاري تحميل الرواية من Supabase...");
  if (catalogState.error) return renderDataState("تعذر تحميل الرواية", catalogState.error, true);
  if (!book) return renderDataState("الرواية غير موجودة", "لم يتم العثور على رواية منشورة بهذا الرابط في Supabase.", true);

  if (isUuid(book.id) && !chapterState.byBook.has(book.id) && !chapterState.loadingBooks.has(book.id)) ChapterService.listByBook(book.id);
  const bookChapters = isUuid(book.id) ? chaptersForBook(book.id) : mockChaptersForBook(book.id);
  const chapterError = chapterState.errors.get(book.id);
  if (chapterState.loadingBooks.has(book.id)) return renderDataState("جاري تحميل الفصول من Supabase...");
  if (chapterError) return renderDataState("تعذر تحميل الفصول", chapterError, true);

  const chapter = bookChapters.find((item) => item.id === chapterId) || bookChapters[0];
  if (!chapter) return renderDataState("لا توجد فصول منشورة", "جدول chapters متصل، لكنه لا يحتوي فصول published لهذه الرواية حالياً.");

  const currentIndex = bookChapters.findIndex((item) => item.id === chapter.id);
  const previousChapter = bookChapters[currentIndex - 1];
  const nextChapter = bookChapters[currentIndex + 1];
  const progressKey = chapterProgressKey(book.id, chapter.id);
  if (!chapterState.progress.has(progressKey)) ChapterService.getProgress(book.id, chapter.id);
  logChapterReadEvent(book.id, chapter.id, "opened");
  const progress = chapterState.progress.get(progressKey) || 0;

  return `
    <section class="reader-shell">
      <aside class="reader-toc">
        <a class="back-link" href="#/novels/${book.id}">عودة للرواية</a>
        <h2>الفصول</h2>
        ${bookChapters.map((item) => `<a class="${item.id === chapter.id ? "is-active" : ""}" href="#/novels/${book.id}/chapters/${item.id}">${escapeHtml(item.title)}</a>`).join("")}
      </aside>
      <article class="reader-page" data-reader-page data-book-id="${book.id}" data-chapter-id="${chapter.id}">
        <div class="reader-toolbar">
          <span>${escapeHtml(book.title)}</span>
          <div>
            <button type="button" data-reader-font>خط أكبر</button>
            <button type="button" data-reader-theme>ليلي</button>
            <button type="button" data-save-progress>حفظ</button>
          </div>
        </div>
        <h1>${escapeHtml(chapter.title)}</h1>
        <div class="reader-progress-panel">
          <label>
            <span>تقدم القراءة: <b data-progress-label>${Math.round(progress)}%</b></span>
            <input type="range" min="0" max="100" value="${Math.round(progress)}" data-progress-input />
          </label>
          <p data-progress-status>${escapeHtml(chapterState.progressMessage)}</p>
        </div>
        ${renderChapterContent(chapter)}
        <div class="reader-actions">
          ${previousChapter ? `<a class="btn btn-secondary" href="#/novels/${book.id}/chapters/${previousChapter.id}">الفصل السابق</a>` : `<a class="btn btn-secondary" href="#/novels/${book.id}">تفاصيل الرواية</a>`}
          ${nextChapter ? `<a class="btn btn-primary" href="#/novels/${book.id}/chapters/${nextChapter.id}">الفصل التالي</a>` : `<button class="btn btn-primary" disabled>آخر فصل</button>`}
        </div>
      </article>
    </section>
  `;
}

function renderLibrary() {
  const user = currentUser();
  if (!user) {
    return renderDataState("سجل الدخول لفتح المكتبة", "المكتبة تعتمد على جدول favorites في Supabase.", true);
  }
  if (interactionState.loadedForUser !== user.id && !interactionState.loading) loadUserInteractions();
  if (interactionState.loading) return renderDataState("جاري تحميل مكتبتك من Supabase...");
  if (interactionState.error) return renderDataState("تعذر تحميل المكتبة", interactionState.error, true);

  return `
    <section class="page-heading">
      <div>
        <span class="eyebrow">Library</span>
        <h1>مكتبتي</h1>
        <p>الروايات المحفوظة وقائمة المتابعة.</p>
      </div>
      <a class="btn btn-secondary" href="#/history">سجل القراءة</a>
    </section>
    <section class="library-tabs">
      <a class="is-active" href="#/library">المحفوظة</a>
      <a href="#/history">السجل</a>
    </section>
    <div class="book-list">${interactionState.libraryBooks.length ? interactionState.libraryBooks.map((item) => renderLibraryRow(item.book)).join("") : renderEmptyBooks("لا توجد روايات محفوظة في favorites بعد.")}</div>
  `;
}

function renderHistory() {
  const user = currentUser();
  if (!user) {
    return renderDataState("سجل الدخول لعرض سجل القراءة", "سجل القراءة يعتمد على reading_progress في Supabase.", true);
  }
  if (interactionState.loadedForUser !== user.id && !interactionState.loading) loadUserInteractions();
  if (interactionState.loading) return renderDataState("جاري تحميل سجل القراءة من Supabase...");
  if (interactionState.error) return renderDataState("تعذر تحميل سجل القراءة", interactionState.error, true);

  return `
    <section class="page-heading">
      <div>
        <span class="eyebrow">History</span>
        <h1>سجل القراءة</h1>
        <p>آخر الفصول التي فتحتها ونسبة التقدم.</p>
      </div>
      <a class="btn btn-secondary" href="#/library">مكتبتي</a>
    </section>
    <section class="history-timeline">
      ${interactionState.readingHistory.length ? interactionState.readingHistory.map(renderHistoryFull).join("") : renderDataState("لا يوجد سجل قراءة", "ابدأ قراءة فصل واحفظ التقدم ليظهر هنا.")}
    </section>
  `;
}

function renderProfile() {
  const auth = window.NovelFlexAuth?.getState();
  const displayName = window.NovelFlexAuth?.displayName() || "فاطمة القارئة";
  const email = auth?.user?.email || (auth?.isGuest ? "وضع الضيف" : "غير مسجل");
  const sessionBadge = auth?.user ? "جلسة Supabase نشطة" : auth?.isGuest ? "تصفح كضيف" : "غير مسجل";

  return `
    <section class="profile-hero" style="--profile-bg:url('./assets/bg_author.jpg')">
      <img src="./assets/profile_pic.png" alt="" />
      <div>
        <span class="eyebrow">Reader Profile</span>
        <h1>${displayName}</h1>
        <p>${email} · ${sessionBadge}</p>
      </div>
    </section>
    <section class="content-grid">
      <div class="panel">
        <h2>إحصائيات الحساب</h2>
        <div class="stats-grid">
          <span><b>42</b><small>رواية محفوظة</small></span>
          <span><b>118</b><small>فصل مقروء</small></span>
          <span><b>9</b><small>مراجعات</small></span>
        </div>
      </div>
      <div class="panel">
        <h2>إعدادات سريعة</h2>
        <div class="settings-list">
          <button>تعديل الملف</button>
          <button>اللغة: العربية</button>
          <button>إشعارات القراءة</button>
          ${auth?.user || auth?.isGuest
            ? `<button class="danger-text" data-logout>تسجيل الخروج</button>`
            : `<a class="btn btn-primary" href="#/auth/login">تسجيل الدخول</a>`}
        </div>
      </div>
    </section>
    <section class="panel">
      <h2>آخر المراجعات</h2>
      <div class="review-stack">${reviews.slice(0, 2).map(renderReview).join("")}</div>
    </section>
  `;
}

function renderLogin() {
  const auth = window.NovelFlexAuth?.getState();
  return `
    <section class="auth-layout">
      <article class="auth-card" data-auth-card>
        <span class="eyebrow">Authentication</span>
        <h1>تسجيل الدخول</h1>
        <p>استخدم Supabase Auth الحالي لتسجيل الدخول. بقية صفحات المحتوى ما زالت mock data.</p>
        ${auth?.user ? `<div class="auth-notice">أنت مسجل حالياً باسم ${window.NovelFlexAuth.displayName()}.</div>` : ""}
        <form class="auth-form" data-login-form>
          <label><span>البريد الإلكتروني</span><input name="email" type="email" autocomplete="email" required /></label>
          <label><span>كلمة المرور</span><input name="password" type="password" autocomplete="current-password" required /></label>
          <button class="btn btn-primary">دخول بالبريد</button>
          <p class="auth-status" data-auth-status></p>
        </form>
        <div class="oauth-grid">
          <button class="btn btn-secondary" data-oauth="google">Google Login</button>
          <button class="btn btn-secondary" data-oauth="apple">Apple Login</button>
        </div>
        <button class="btn btn-ghost" data-guest>المتابعة كضيف</button>
        <p class="auth-switch">ليس لديك حساب؟ <a href="#/auth/register">إنشاء حساب</a></p>
      </article>
      <aside class="auth-side">
        <h2>ما الذي يعمل الآن؟</h2>
        <ul>
          <li>Email login عبر Supabase Auth</li>
          <li>Google OAuth عبر Supabase provider</li>
          <li>Apple OAuth عبر Supabase provider</li>
          <li>Guest mode محلي بدون session</li>
        </ul>
      </aside>
    </section>
  `;
}

function renderRegister() {
  return `
    <section class="auth-layout">
      <article class="auth-card" data-auth-card>
        <span class="eyebrow">Create Account</span>
        <h1>إنشاء حساب</h1>
        <p>يسجل الحساب في Supabase Auth فقط، بدون تعديل schema أو إنشاء صفوف في الجداول.</p>
        <form class="auth-form" data-register-form>
          <label><span>اسم المستخدم</span><input name="username" autocomplete="name" required minlength="2" /></label>
          <label><span>البريد الإلكتروني</span><input name="email" type="email" autocomplete="email" required /></label>
          <label><span>كلمة المرور</span><input name="password" type="password" autocomplete="new-password" required minlength="6" /></label>
          <button class="btn btn-primary">إنشاء الحساب</button>
          <p class="auth-status" data-auth-status></p>
        </form>
        <div class="oauth-grid">
          <button class="btn btn-secondary" data-oauth="google">التسجيل عبر Google</button>
          <button class="btn btn-secondary" data-oauth="apple">التسجيل عبر Apple</button>
        </div>
        <button class="btn btn-ghost" data-guest>المتابعة كضيف</button>
        <p class="auth-switch">لديك حساب؟ <a href="#/auth/login">تسجيل الدخول</a></p>
      </article>
      <aside class="auth-side">
        <h2>ملاحظة إنتاجية</h2>
        <p>OAuth يحتاج Redirect URL مضاف في Supabase Dashboard لعنوان الويب الذي ستختبر عليه.</p>
      </aside>
    </section>
  `;
}

function renderAuthCallback() {
  const auth = window.NovelFlexAuth?.getState();
  return `
    <section class="empty-state">
      <h1>جاري تأكيد الجلسة</h1>
      <p>${auth?.user ? "تم تسجيل الدخول بنجاح." : "إذا لم تنتقل تلقائياً، انتظر لحظة أو عد لتسجيل الدخول."}</p>
      <a class="btn btn-primary" href="#/profile">فتح الحساب</a>
    </section>
  `;
}

function renderAuthorDashboard() {
  return renderAuthorShell(
    "dashboard",
    `
      <section class="author-hero">
        <div>
          <span class="eyebrow">Author Portal</span>
          <h1>لوحة الكاتب</h1>
          <p>نظرة تشغيلية على الروايات والفصول والأداء. كل البيانات هنا وهمية للواجهة فقط.</p>
        </div>
        <a class="btn btn-primary" href="#/author/novels/new">إنشاء رواية</a>
      </section>

      <section class="author-metrics">
        ${authorMetric("الروايات", "3", "رواية نشطة")}
        ${authorMetric("المشاهدات", "2.53M", "+18% هذا الأسبوع")}
        ${authorMetric("الحفظ", "53K", "مكتبات القراء")}
        ${authorMetric("متوسط التقييم", "4.6", "آخر 30 يوم")}
      </section>

      <section class="author-grid">
        <div class="panel">
          ${sectionHeader("آخر الروايات", "تابع حالة النشر والتحرير", "#/author/novels")}
          <div class="author-list">${authorNovels.map(renderAuthorNovelRow).join("")}</div>
        </div>
        <aside class="panel">
          ${sectionHeader("مهام اليوم", "أولويات التحرير", "#/author/novels/ink-city/chapters")}
          <div class="task-list">
            <label><input type="checkbox" checked /> مراجعة الفصل 87</label>
            <label><input type="checkbox" /> تحديث وصف الرواية</label>
            <label><input type="checkbox" /> تجهيز غلاف قمر الورق</label>
          </div>
        </aside>
      </section>
    `,
  );
}

function renderAuthorNovels() {
  return renderAuthorShell(
    "novels",
    `
      <section class="page-heading">
        <div>
          <span class="eyebrow">My Novels</span>
          <h1>رواياتي</h1>
          <p>إدارة الروايات المنشورة، المسودات، والأعمال قيد المراجعة.</p>
        </div>
        <a class="btn btn-primary" href="#/author/novels/new">رواية جديدة</a>
      </section>
      <section class="author-table">
        ${authorNovels.map(renderAuthorNovelRow).join("")}
      </section>
    `,
  );
}

function renderCreateNovel() {
  return renderAuthorShell(
    "create",
    `
      <section class="page-heading">
        <div>
          <span class="eyebrow">Create Novel</span>
          <h1>إنشاء رواية</h1>
          <p>نموذج تصميمي فقط. لا يتم حفظ أي بيانات.</p>
        </div>
      </section>
      ${renderNovelForm("إنشاء المسودة", {
        title: "",
        genre: "خيال",
        summary: "",
        status: "مسودة",
      })}
    `,
  );
}

function renderEditNovel(novel) {
  return renderAuthorShell(
    "novels",
    `
      <section class="page-heading">
        <div>
          <span class="eyebrow">Edit Novel</span>
          <h1>تعديل ${novel.title}</h1>
          <p>تحرير بيانات الرواية، الغلاف، التصنيف، وحالة النشر.</p>
        </div>
        <a class="btn btn-secondary" href="#/author/novels/${novel.id}/chapters">إدارة الفصول</a>
      </section>
      ${renderNovelForm("حفظ التعديلات", {
        title: novel.title,
        genre: "خيال",
        summary: "قارئة تكتشف أن رواية قديمة لا تنتهي وكل فصل يغير المدينة.",
        status: novel.status,
      })}
    `,
  );
}

function renderChapterManager(novel) {
  return renderAuthorShell(
    "chapters",
    `
      <section class="page-heading">
        <div>
          <span class="eyebrow">Chapter Manager</span>
          <h1>فصول ${novel.title}</h1>
          <p>إدارة قائمة الفصول، الحالة، وجدولة النشر ببيانات وهمية.</p>
        </div>
        <button class="btn btn-primary">إضافة فصل</button>
      </section>
      <section class="chapter-manager">
        <article class="chapter-editor">
          <h2>محرر الفصل</h2>
          <label><span>عنوان الفصل</span><input value="باب لا يظهر في الخرائط" /></label>
          <label><span>محتوى الفصل</span><textarea rows="10">اكتب الفصل هنا. هذه مساحة معاينة فقط ولا تحفظ البيانات.</textarea></label>
          <div class="button-line">
            <button class="btn btn-secondary">حفظ كمسودة</button>
            <button class="btn btn-primary">نشر وهمي</button>
          </div>
        </article>
        <aside class="chapter-sidebar">
          ${chapters
            .map(
              (chapter, index) => `
                <a class="chapter-admin-row ${index === 0 ? "is-active" : ""}" href="#/author/novels/${novel.id}/chapters">
                  <span>${chapter.title}</span>
                  <small>${index < 2 ? "منشور" : "مسودة"} · ${chapter.words} كلمة</small>
                </a>
              `,
            )
            .join("")}
        </aside>
      </section>
    `,
  );
}

function renderAuthorAnalytics() {
  return renderAuthorShell(
    "analytics",
    `
      <section class="page-heading">
        <div>
          <span class="eyebrow">Analytics</span>
          <h1>تحليلات الكاتب</h1>
          <p>مؤشرات قراءة وحفظ وتفاعل، بدون أي اتصال ببيانات حقيقية.</p>
        </div>
      </section>
      <section class="author-metrics">
        ${authorMetric("قراءات الأسبوع", "182K", "+12%")}
        ${authorMetric("معدل إكمال الفصل", "68%", "+4%")}
        ${authorMetric("مراجعات جديدة", "219", "آخر 7 أيام")}
        ${authorMetric("حفظ جديد", "3.8K", "+9%")}
      </section>
      <section class="analytics-board">
        <article class="panel">
          <h2>أداء الروايات</h2>
          ${authorNovels
            .map(
              (novel) => `
                <div class="analytics-row">
                  <span>${novel.title}</span>
                  <div class="progress"><span style="width:${novel.completion}%"></span></div>
                  <b>${novel.views}</b>
                </div>
              `,
            )
            .join("")}
        </article>
        <article class="panel">
          <h2>مصادر التفاعل</h2>
          <div class="donut-list">
            <span><b></b> صفحة الرواية · 46%</span>
            <span><b></b> البحث · 28%</span>
            <span><b></b> المكتبة · 18%</span>
            <span><b></b> التوصيات · 8%</span>
          </div>
        </article>
      </section>
    `,
  );
}

function renderAuthorAcademy() {
  return renderAuthorShell(
    "academy",
    `
      <section class="author-hero academy-hero" style="--academy-bg:url('./assets/manga_books.jpg')">
        <div>
          <span class="eyebrow">Academy</span>
          <h1>أكاديمية الكاتب</h1>
          <p>دروس ومواد إرشادية مستوحاة من لقطات Creator Academy. العقود والدخل معلومات مستقبلية فقط.</p>
        </div>
      </section>
      <section class="academy-grid">
        ${academyPosts.map(renderAcademyCard).join("")}
      </section>
    `,
  );
}

function renderAdminModeration() {
  return renderAdminPortal("moderation", () => {
    const openReports = adminState.reports.filter((item) => item.status === "open" || item.status === "reviewing");
    const pendingBooks = adminState.books.filter((item) => item.status === "in_review");
    const pendingChapters = adminState.chapters.filter((item) => item.status === "in_review");
    const pendingAuthors = adminState.authors.filter((item) => !item.is_approved);

    return `
      <section class="page-heading">
        <div>
          <span class="eyebrow">Admin</span>
          <h1>لوحة المراجعة</h1>
          <p>مركز تشغيل سريع للبلاغات، المستخدمين، الكتّاب، التصنيفات، واعتماد المحتوى من Supabase.</p>
        </div>
        <a class="btn btn-secondary" href="#/admin/reports">فتح البلاغات</a>
      </section>
      ${renderAdminNotice()}
      <section class="author-metrics">
        ${authorMetric("بلاغات مفتوحة", String(openReports.length), "reports.open/reviewing")}
        ${authorMetric("مستخدمون", String(adminState.profiles.length), "profiles")}
        ${authorMetric("كتّاب بانتظار الاعتماد", String(pendingAuthors.length), "writer_profiles")}
        ${authorMetric("محتوى قيد المراجعة", String(pendingBooks.length + pendingChapters.length), "books + chapters")}
      </section>
      <section class="author-grid">
        <div class="panel">
          ${sectionHeader("أحدث البلاغات", "آخر عناصر reports التي تحتاج نظر", "#/admin/reports")}
          <div class="author-list">${openReports.slice(0, 5).map(renderReportRow).join("") || renderEmptyAdmin("لا توجد بلاغات مفتوحة.")}</div>
        </div>
        <aside class="panel">
          ${sectionHeader("قائمة الاعتماد", "كتب وفصول بحالة in_review", "#/admin/content-approval")}
          <div class="author-list">
            ${pendingBooks.slice(0, 3).map((book) => renderContentApprovalRow("book", book)).join("")}
            ${pendingChapters.slice(0, 3).map((chapter) => renderContentApprovalRow("chapter", chapter)).join("")}
            ${pendingBooks.length || pendingChapters.length ? "" : renderEmptyAdmin("لا يوجد محتوى قيد المراجعة.")}
          </div>
        </aside>
      </section>
    `;
  });
}

function renderAdminCategories() {
  return renderAdminPortal("categories", () => `
      <section class="page-heading">
        <div>
          <span class="eyebrow">Categories</span>
          <h1>إدارة التصنيفات</h1>
          <p>تعديل التصنيفات الحالية من جدول categories بدون إنشاء schema جديد.</p>
        </div>
        <span class="tag tag-soft">${adminState.categories.length} تصنيف</span>
      </section>
      ${renderAdminNotice()}
      <section class="author-table">
        ${adminState.categories.length ? adminState.categories.map(renderCategoryAdminRow).join("") : renderEmptyAdmin("لا توجد تصنيفات.")}
      </section>
    `);
}

function renderAdminReports() {
  return renderAdminPortal("reports", () => `
      <section class="page-heading">
        <div>
          <span class="eyebrow">Reports</span>
          <h1>البلاغات</h1>
          <p>مراجعة بلاغات القراء على الروايات، الفصول، التعليقات، أو المستخدمين.</p>
        </div>
        <span class="tag tag-soft">${adminState.reports.length} بلاغ</span>
      </section>
      ${renderAdminNotice()}
      <section class="author-table">
        ${adminState.reports.length ? adminState.reports.map(renderReportRow).join("") : renderEmptyAdmin("لا توجد بلاغات في reports.")}
      </section>
    `);
}

function renderAdminUsers() {
  return renderAdminPortal("users", () => `
      <section class="page-heading">
        <div>
          <span class="eyebrow">Users</span>
          <h1>إدارة المستخدمين</h1>
          <p>تعديل الدور وحالة الظهور العامة من جدول profiles.</p>
        </div>
        <span class="tag tag-soft">${adminState.profiles.length} مستخدم</span>
      </section>
      ${renderAdminNotice()}
      <section class="author-table">
        ${adminState.profiles.length ? adminState.profiles.map(renderUserAdminRow).join("") : renderEmptyAdmin("لا توجد ملفات مستخدمين.")}
      </section>
    `);
}

function renderAdminAuthors() {
  return renderAdminPortal("authors", () => `
      <section class="page-heading">
        <div>
          <span class="eyebrow">Authors</span>
          <h1>إدارة الكتّاب</h1>
          <p>اعتماد أو تعليق ملفات الكاتب من جدول writer_profiles.</p>
        </div>
        <span class="tag tag-soft">${adminState.authors.length} كاتب</span>
      </section>
      ${renderAdminNotice()}
      <section class="author-table">
        ${adminState.authors.length ? adminState.authors.map(renderAuthorAdminRow).join("") : renderEmptyAdmin("لا توجد ملفات كتّاب في writer_profiles.")}
      </section>
    `);
}

function renderAdminContentApproval() {
  return renderAdminPortal("approval", () => {
    const booksInScope = adminState.books.filter((item) => ["draft", "in_review", "rejected"].includes(item.status));
    const chaptersInScope = adminState.chapters.filter((item) => ["draft", "in_review", "rejected"].includes(item.status));
    return `
      <section class="page-heading">
        <div>
          <span class="eyebrow">Content Approval</span>
          <h1>اعتماد المحتوى</h1>
          <p>تغيير حالة الكتب والفصول بين draft, in_review, published, rejected, archived.</p>
        </div>
        <span class="tag tag-soft">${booksInScope.length + chaptersInScope.length} عنصر</span>
      </section>
      ${renderAdminNotice()}
      <section class="author-table">
        ${booksInScope.map((book) => renderContentApprovalRow("book", book)).join("")}
        ${chaptersInScope.map((chapter) => renderContentApprovalRow("chapter", chapter)).join("")}
        ${booksInScope.length || chaptersInScope.length ? "" : renderEmptyAdmin("لا يوجد محتوى يحتاج اعتماد حالياً.")}
      </section>
    `;
  });
}

function renderAdminPortal(active, contentFactory) {
  const auth = window.NovelFlexAuth?.getState();
  if (!auth?.user) return renderDataState("سجل الدخول كمدير", "لوحة الإدارة تعتمد على profiles.role = admin.", true);
  if (!adminState.loaded && !adminState.loading) loadAdminData();
  if (adminState.loading) return renderDataState("جاري تحميل لوحة الإدارة من Supabase...");
  if (adminState.error) return renderDataState("تعذر فتح لوحة الإدارة", adminState.error, true);
  if (!isAdminProfile()) return renderDataState("صلاحية غير كافية", "حسابك الحالي ليس admin في جدول profiles.", true);
  return renderAdminShell(active, contentFactory());
}

function renderAdminShell(active, content) {
  return `
    <section class="author-shell admin-shell">
      <aside class="author-nav admin-nav">
        <b>لوحة الإدارة</b>
        <a class="${active === "moderation" ? "is-active" : ""}" href="#/admin/moderation">المراجعة</a>
        <a class="${active === "reports" ? "is-active" : ""}" href="#/admin/reports">البلاغات</a>
        <a class="${active === "users" ? "is-active" : ""}" href="#/admin/users">المستخدمون</a>
        <a class="${active === "authors" ? "is-active" : ""}" href="#/admin/authors">الكتّاب</a>
        <a class="${active === "categories" ? "is-active" : ""}" href="#/admin/categories">التصنيفات</a>
        <a class="${active === "approval" ? "is-active" : ""}" href="#/admin/content-approval">اعتماد المحتوى</a>
        <span>المدفوعات · خارج MVP</span>
      </aside>
      <div class="author-content">${content}</div>
    </section>
  `;
}

function renderAdminNotice() {
  return adminState.actionMessage ? `<p class="auth-status">${escapeHtml(adminState.actionMessage)}</p>` : "";
}

function renderEmptyAdmin(message) {
  return `<article class="empty-state empty-state-inline"><h1>لا توجد بيانات</h1><p>${escapeHtml(message)}</p></article>`;
}

function renderReportRow(report) {
  const target = report.book?.title_ar || report.book?.title_en || report.chapter?.title_ar || report.chapter?.title_en || report.reported_user?.display_name || report.comment?.body || "عنصر غير محدد";
  return `
    <article class="author-novel-row">
      <div>
        <h2>${escapeHtml(target)}</h2>
        <p>${escapeHtml(report.reason)} · ${escapeHtml(report.status)} · ${formatDate(report.created_at)}</p>
        ${report.details ? `<small>${escapeHtml(report.details)}</small>` : ""}
        <small>المبلّغ: ${escapeHtml(report.reporter?.display_name || report.reporter?.username || report.reporter_id || "-")}</small>
      </div>
      <div class="author-row-actions">
        <span class="tag ${report.status === "resolved" ? "tag-success" : "tag-soft"}">${escapeHtml(report.status)}</span>
        <select data-admin-report-status="${report.id}">
          ${adminStatusOptions(["open", "reviewing", "resolved", "dismissed"], report.status)}
        </select>
        <button class="btn btn-primary" data-admin-update-report="${report.id}">حفظ</button>
      </div>
    </article>
  `;
}

function renderUserAdminRow(profile) {
  return `
    <article class="author-novel-row">
      <div>
        <h2>${escapeHtml(profile.display_name || profile.username || "مستخدم NOVELFLEX")}</h2>
        <p>${escapeHtml(profile.username || profile.id)} · ${escapeHtml(profile.role)} · ${profile.is_public ? "عام" : "مخفي"}</p>
        <small>${formatDate(profile.created_at)}</small>
      </div>
      <div class="author-row-actions">
        <select data-admin-user-role="${profile.id}">
          ${adminStatusOptions(["reader", "writer", "admin"], profile.role)}
        </select>
        <button class="btn btn-primary" data-admin-update-role="${profile.id}">تحديث الدور</button>
        <button class="btn btn-secondary" data-admin-toggle-public="${profile.id}" data-next-public="${profile.is_public ? "false" : "true"}">${profile.is_public ? "إخفاء" : "إظهار"}</button>
      </div>
    </article>
  `;
}

function renderAuthorAdminRow(author) {
  const profile = author.profile || {};
  return `
    <article class="author-novel-row">
      <div>
        <h2>${escapeHtml(author.pen_name || profile.display_name || "كاتب بدون اسم")}</h2>
        <p>${escapeHtml(profile.username || author.user_id)} · ${author.is_approved ? "معتمد" : "بانتظار الاعتماد"}</p>
        ${author.bio_ar || author.bio_en ? `<small>${escapeHtml(author.bio_ar || author.bio_en)}</small>` : ""}
      </div>
      <div class="author-row-actions">
        <span class="tag ${author.is_approved ? "tag-success" : "tag-soft"}">${author.is_approved ? "معتمد" : "غير معتمد"}</span>
        <button class="btn ${author.is_approved ? "btn-secondary" : "btn-primary"}" data-admin-author-approval="${author.id}" data-next-approved="${author.is_approved ? "false" : "true"}">${author.is_approved ? "تعليق الاعتماد" : "اعتماد الكاتب"}</button>
      </div>
    </article>
  `;
}

function renderCategoryAdminRow(category) {
  return `
    <article class="admin-edit-card">
      <form data-admin-category-form="${category.id}">
        <div class="admin-edit-grid">
          <label><span>الاسم العربي</span><input name="name_ar" value="${escapeHtml(category.name_ar || "")}" required /></label>
          <label><span>English name</span><input name="name_en" value="${escapeHtml(category.name_en || "")}" required /></label>
          <label><span>Slug</span><input name="slug" value="${escapeHtml(category.slug || "")}" required /></label>
          <label><span>الترتيب</span><input name="sort_order" type="number" value="${Number(category.sort_order || 0)}" /></label>
        </div>
        <label><span>الوصف</span><textarea name="description_ar" rows="2">${escapeHtml(category.description_ar || "")}</textarea></label>
        <div class="author-row-actions">
          <label class="inline-check"><input name="is_active" type="checkbox" ${category.is_active ? "checked" : ""} /> نشط</label>
          <span class="tag ${category.is_active ? "tag-success" : "tag-soft"}">${category.is_active ? "ظاهر" : "مخفي"}</span>
          <button class="btn btn-primary">حفظ التصنيف</button>
        </div>
      </form>
    </article>
  `;
}

function renderContentApprovalRow(type, item) {
  const isChapter = type === "chapter";
  const title = isChapter
    ? `${item.book?.title_ar || item.book?.title_en || "رواية"} · ${item.title_ar || item.title_en || `الفصل ${item.chapter_number}`}`
    : item.title_ar || item.title_en || "رواية بدون عنوان";
  const subtitle = isChapter
    ? `فصل ${item.chapter_number || "-"} · ${item.status}`
    : `${item.author?.display_name || item.author?.username || "كاتب"} · ${item.category?.name_ar || item.category?.name_en || "غير مصنف"} · ${item.status}`;
  return `
    <article class="author-novel-row">
      ${!isChapter ? cover({ title, coverUrl: "", color: "cover-ink" }, "cover-mini") : ""}
      <div>
        <h2>${escapeHtml(title)}</h2>
        <p>${escapeHtml(subtitle)} · ${formatDate(item.created_at)}</p>
      </div>
      <div class="author-row-actions">
        <span class="tag ${item.status === "published" ? "tag-success" : "tag-soft"}">${escapeHtml(item.status)}</span>
        <button class="btn btn-secondary" data-admin-content-type="${type}" data-admin-content-id="${item.id}" data-admin-content-status="rejected">رفض</button>
        <button class="btn btn-secondary" data-admin-content-type="${type}" data-admin-content-id="${item.id}" data-admin-content-status="archived">أرشفة</button>
        <button class="btn btn-primary" data-admin-content-type="${type}" data-admin-content-id="${item.id}" data-admin-content-status="published">اعتماد</button>
      </div>
    </article>
  `;
}

function adminStatusOptions(options, current) {
  return options.map((option) => `<option value="${option}" ${option === current ? "selected" : ""}>${option}</option>`).join("");
}

function renderAuthorShell(active, content) {
  const gate = renderAuthorAccessGate();
  if (gate) return gate;

  return `
    <section class="author-shell">
      <aside class="author-nav">
        <b>استوديو الكاتب</b>
        <a class="${active === "dashboard" ? "is-active" : ""}" href="#/author">لوحة الكاتب</a>
        <a class="${active === "novels" ? "is-active" : ""}" href="#/author/novels">رواياتي</a>
        <a class="${active === "create" ? "is-active" : ""}" href="#/author/novels/new">إنشاء رواية</a>
        <a class="${active === "chapters" ? "is-active" : ""}" href="#/author/novels/ink-city/chapters">إدارة الفصول</a>
        <a class="${active === "analytics" ? "is-active" : ""}" href="#/author/analytics">التحليلات</a>
        <a class="${active === "academy" ? "is-active" : ""}" href="#/author/academy">الأكاديمية</a>
        <span>الإيرادات · مرحلة لاحقة</span>
      </aside>
      <div class="author-content">${content}</div>
    </section>
  `;
}

function authorMetric(label, value, note) {
  return `<article class="author-metric"><small>${label}</small><strong>${value}</strong><span>${note}</span></article>`;
}

function renderAuthorNovelRow(novel) {
  return `
    <article class="author-novel-row">
      ${cover({ ...novel, author: "ليان منصور" }, "cover-mini")}
      <div>
        <h2>${novel.title}</h2>
        <p>${novel.status} · ${novel.chapters} فصل · آخر تحديث ${novel.updated}</p>
        <div class="progress"><span style="width:${novel.completion}%"></span></div>
      </div>
      <div class="author-row-actions">
        <span class="tag ${novel.status === "منشورة" ? "tag-success" : "tag-soft"}">${novel.status}</span>
        <a class="btn btn-secondary" href="#/author/novels/${novel.id}/edit">تعديل</a>
        <a class="btn btn-ghost" href="#/author/novels/${novel.id}/chapters">الفصول</a>
      </div>
    </article>
  `;
}

function renderNovelForm(actionLabel, values) {
  return `
    <section class="author-form">
      <div class="cover-upload">
        <div class="book-cover cover-teal cover-xl"><span>غلاف</span></div>
        <button class="btn btn-secondary">اختيار غلاف</button>
      </div>
      <form class="form-grid" onsubmit="event.preventDefault()">
        <label><span>عنوان الرواية</span><input value="${escapeHtml(values.title)}" placeholder="مثال: مدينة الحبر الأخيرة" /></label>
        <label><span>النوع</span><select><option>${values.genre}</option><option>رومانسي</option><option>غموض</option></select></label>
        <label><span>حالة النشر</span><select><option>${values.status}</option><option>مسودة</option><option>قيد المراجعة</option><option>منشورة</option></select></label>
        <label class="full"><span>النبذة</span><textarea rows="6" placeholder="اكتب نبذة الرواية">${escapeHtml(values.summary)}</textarea></label>
        <div class="button-line full">
          <button class="btn btn-secondary">معاينة</button>
          <button class="btn btn-primary">${actionLabel}</button>
        </div>
      </form>
    </section>
  `;
}

function renderAcademyCard(post) {
  return `
    <article class="academy-card">
      <span class="tag">${post.type}</span>
      <h2>${post.title}</h2>
      <p>${post.time}</p>
      <button class="btn btn-secondary">قراءة</button>
    </article>
  `;
}

function renderNotFound() {
  return `
    <section class="empty-state">
      <h1>الصفحة غير موجودة</h1>
      <p>الرابط المطلوب غير متاح داخل واجهة البيانات الوهمية.</p>
      <a class="btn btn-primary" href="#/">العودة للرئيسية</a>
    </section>
  `;
}

function renderDataState(title, detail = "", isError = false) {
  return `
    <section class="empty-state">
      <h1>${escapeHtml(title)}</h1>
      ${detail ? `<p>${escapeHtml(detail)}</p>` : ""}
      ${isError ? `<button class="btn btn-primary" onclick="location.reload()">إعادة المحاولة</button>` : ""}
    </section>
  `;
}

function renderEmptyBooks(message = "لا توجد روايات منشورة في Supabase حالياً.") {
  return `
    <section class="empty-state empty-state-inline">
      <h1>لا توجد نتائج</h1>
      <p>${escapeHtml(message)}</p>
    </section>
  `;
}

function renderBookTile(book) {
  return `
    <a class="book-tile" href="#/novels/${book.id}">
      ${cover(book)}
      <b>${escapeHtml(book.title)}</b>
      <small>${escapeHtml(book.author)}</small>
      ${rating(book.rating)}
    </a>
  `;
}

function renderBookRow(book) {
  return `
    <article class="book-row">
      <a href="#/novels/${book.id}">${cover(book)}</a>
      <div class="book-row-body">
        <div class="meta-line"><span class="tag">${escapeHtml(book.genreLabel)}</span><span>${escapeHtml(book.status)}</span><span>${book.chapters} فصل</span></div>
        <h2><a href="#/novels/${book.id}">${escapeHtml(book.title)}</a></h2>
        <p>${escapeHtml(book.summary)}</p>
        <div class="tag-row">${book.tags.map((tag) => `<span class="tag tag-soft">${escapeHtml(tag)}</span>`).join("")}</div>
      </div>
      <div class="book-row-side">
        ${rating(book.rating)}
        <small>${escapeHtml(book.reads)} قراءة</small>
        <a class="btn btn-secondary" href="#/novels/${book.id}">عرض</a>
      </div>
    </article>
  `;
}

function renderLibraryRow(book) {
  return `
    <article class="book-row">
      <a href="#/novels/${book.id}">${cover(book)}</a>
      <div class="book-row-body">
        <h2><a href="#/novels/${book.id}">${escapeHtml(book.title)}</a></h2>
        <p>محفوظ في مكتبتك · ${escapeHtml(book.genreLabel)} · ${book.chapters} فصل</p>
      </div>
      <div class="book-row-side">
        <a class="btn btn-primary" href="#/novels/${book.id}">فتح</a>
        <button class="btn btn-ghost" data-remove-favorite="${book.id}">إزالة</button>
      </div>
    </article>
  `;
}

function renderChapterRow(book, chapter) {
  return `
    <a class="chapter-row" href="#/novels/${book.id}/chapters/${chapter.id}">
      <span>${escapeHtml(chapter.title)}</span>
      <small>الفصل ${chapter.number || "-"} · ${chapter.filePath ? "PDF" : `${escapeHtml(chapter.words)} كلمة`}</small>
    </a>
  `;
}

function renderChapterContent(chapter) {
  if (chapter.contentText) {
    return `<div class="chapter-copy">${chapter.contentText
      .split(/\n{2,}/)
      .map((paragraph) => `<p>${escapeHtml(paragraph.trim())}</p>`)
      .join("")}</div>`;
  }

  if (chapter.filePath) {
    const url = escapeAttribute(chapter.filePath);
    return `
      <div class="chapter-file">
        <h2>ملف الفصل</h2>
        <p>هذا الفصل مرتبط بملف PDF من جدول chapters.</p>
        <a class="btn btn-primary" href="${url}" target="_blank" rel="noopener">فتح PDF</a>
        <iframe src="${url}" title="Chapter PDF"></iframe>
      </div>
    `;
  }

  if (chapter.audioPath) {
    return `
      <div class="chapter-file">
        <h2>الفصل الصوتي</h2>
        <audio controls src="${escapeAttribute(chapter.audioPath)}"></audio>
      </div>
    `;
  }

  return renderDataState("الفصل بلا محتوى", "الفصل منشور لكن لا يحتوي content_text أو file_path أو audio_path.");
}

function renderMiniBook(book) {
  return `
    <a class="mini-row" href="#/novels/${book.id}">
      ${cover(book, "cover-mini")}
      <span><b>${escapeHtml(book.title)}</b><small>${escapeHtml(book.genreLabel)} · ${escapeHtml(String(book.rating))}</small></span>
    </a>
  `;
}

function renderHistoryMini(item) {
  const book = item.book || books.find((entry) => entry.id === item.bookId) || books[0];
  const chapterId = item.chapterId || "c1";
  const chapter = item.chapterTitle || item.chapter || "فصل";
  const progress = Math.round(item.progress || 0);
  return `
    <a class="mini-row" href="#/novels/${book.id}/chapters/${chapterId}">
      ${cover(book, "cover-mini")}
      <span><b>${escapeHtml(book.title)}</b><small>${escapeHtml(chapter)} · ${progress}%</small></span>
    </a>
  `;
}

function renderHistoryFull(item) {
  const book = item.book || books.find((entry) => entry.id === item.bookId) || books[0];
  const progress = Math.round(item.progress || 0);
  const chapterTitle = item.chapterTitle || item.chapter || "فصل";
  const href = item.chapterId ? `#/novels/${book.id}/chapters/${item.chapterId}` : `#/novels/${book.id}`;
  return `
    <article class="history-card">
      ${cover(book)}
      <div>
        <h2>${escapeHtml(book.title)}</h2>
        <p>${escapeHtml(chapterTitle)} · ${item.lastReadAt ? new Date(item.lastReadAt).toLocaleDateString("ar") : item.time || ""}</p>
        <div class="progress"><span style="width:${progress}%"></span></div>
      </div>
      <a class="btn btn-primary" href="${href}">متابعة</a>
    </article>
  `;
}

function renderReview(review) {
  return `
    <article class="review-card">
      <div class="avatar">${escapeHtml(review.name.slice(0, 1))}</div>
      <div>
        <div class="review-top"><b>${escapeHtml(review.name)}</b><span>${escapeHtml(review.date)}</span></div>
        ${rating(review.rating)}
        <p>${escapeHtml(review.body)}</p>
        <div class="review-actions"><button>مفيد</button><button>رد</button><button>إبلاغ</button></div>
      </div>
    </article>
  `;
}

function renderGenreChip(genre) {
  return `<a class="genre-chip" href="#/genre/${genre.slug}">${genre.label}<span>${books.filter((book) => book.genre === genre.slug).length || 3}</span></a>`;
}

function sectionHeader(title, subtitle, href) {
  return `
    <div class="section-head">
      <div><h2>${title}</h2><p>${subtitle}</p></div>
      <a href="${href}">عرض الكل</a>
    </div>
  `;
}

function cover(book, extraClass = "") {
  if (book.coverUrl) {
    return `<div class="book-cover ${book.color} ${extraClass}"><img src="${escapeAttribute(book.coverUrl)}" alt="غلاف ${escapeAttribute(book.title)}" loading="lazy" decoding="async" referrerpolicy="no-referrer"></div>`;
  }
  return `<div class="book-cover ${book.color} ${extraClass}" aria-label="غلاف ${escapeHtml(book.title)}"><span>${escapeHtml(book.title.slice(0, 2))}</span></div>`;
}

function rating(value) {
  return `<div class="rating" aria-label="تقييم ${escapeHtml(String(value))} من 5"><span>★</span><b>${escapeHtml(String(value))}</b></div>`;
}

function escapeHtml(value) {
  return String(value ?? "").replace(/[&<>"']/g, (char) => ({
    "&": "&amp;",
    "<": "&lt;",
    ">": "&gt;",
    '"': "&quot;",
    "'": "&#039;",
  })[char]);
}

function escapeAttribute(value) {
  return String(value ?? "").replace(/['"\\()]/g, "");
}
