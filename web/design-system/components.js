const mockBooks = [
  {
    id: "ink-city",
    title: "مدينة الحبر الأخيرة",
    author: "ليان منصور",
    genre: "خيال حضري",
    status: "قيد النشر",
    chapters: 86,
    rating: 4.8,
    reads: "٢.٤ مليون",
    summary: "قارئة تكتشف أن رواية قديمة تعيد تشكيل مدينتها كلما ظهر فصل جديد.",
    tags: ["عوالم موازية", "بطلة قوية", "غموض"],
    tone: "teal",
  },
  {
    id: "sand-gate",
    title: "بوابة الرمل",
    author: "ناصر الرومي",
    genre: "تاريخي",
    status: "مكتملة",
    chapters: 124,
    rating: 4.7,
    reads: "١.٨ مليون",
    summary: "رحلة في ممالك عربية قديمة حيث لا تظهر الأسرار إلا قبل اختفاء آخر ضوء.",
    tags: ["مغامرة", "تراث", "ملحمي"],
    tone: "gold",
  },
  {
    id: "neon-vow",
    title: "وعد النيون",
    author: "سارة البحري",
    genre: "تشويق",
    status: "منشورة",
    chapters: 52,
    rating: 4.6,
    reads: "٩٤٠ ألف",
    summary: "رسالة مشفرة تقود محققا شابا إلى عائلة تخفي نصف تاريخ المدينة.",
    tags: ["تحقيق", "حضري", "أسرار"],
    tone: "blue",
  },
];

const mockChapters = [
  { number: 1, title: "الصفحة التي لم تُكتب", status: "منشور", reads: "٤٢ ألف" },
  { number: 2, title: "شارع الورق", status: "منشور", reads: "٣٨ ألف" },
  { number: 3, title: "حبر تحت المطر", status: "مسودة", reads: "غير منشور" },
];

const mockReviews = [
  {
    name: "مها القارئة",
    rating: 5,
    text: "الإيقاع ممتاز والشخصيات واضحة. كل فصل يترك سؤالا جديدا بدون إطالة.",
    meta: "قبل ساعتين",
  },
  {
    name: "عبدالله",
    rating: 4,
    text: "اللغة جميلة والبناء مشوق. أحببت أن تفاصيل العالم تظهر تدريجيا.",
    meta: "أمس",
  },
];

const genres = ["الكل", "خيال", "رومانسي", "غموض", "حضري", "تاريخي", "خيال علمي", "دراما"];

const escapeHtml = (value) =>
  String(value)
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#039;");

function AppNavbar() {
  return `
    <header class="app-navbar">
      <a class="brand" href="#overview" aria-label="NOVELFLEX">
        <span class="brand-mark">N</span>
        <span class="brand-name">NOVELFLEX</span>
      </a>
      <nav class="nav-links" aria-label="التنقل الرئيسي">
        <a class="is-active" href="#overview">الرئيسية</a>
        <a href="#reader">القارئ</a>
        <a href="#author">الكاتب</a>
        <a href="#states">الحالات</a>
      </nav>
      <label class="search-pill">
        <span>بحث</span>
        <input type="search" placeholder="ابحث عن رواية أو كاتب" />
      </label>
      ${UserMenu()}
    </header>
  `;
}

function UserMenu() {
  return `
    <details class="user-menu">
      <summary>
        <span class="avatar">ف</span>
        <span>فيصل</span>
      </summary>
      <div class="user-menu-panel">
        <a href="#library">مكتبتي</a>
        <a href="#author">استوديو الكاتب</a>
        <a href="#states">الإعدادات</a>
      </div>
    </details>
  `;
}

function GenreSidebar(active = "الكل") {
  return `
    <aside class="genre-sidebar" aria-label="تصنيفات الروايات">
      <div class="sidebar-heading">
        <b>التصنيفات</b>
        <span>${genres.length} أنواع</span>
      </div>
      ${genres
        .map(
          (genre) => `
            <a class="${genre === active ? "is-active" : ""}" href="#reader">
              <span>${escapeHtml(genre)}</span>
              <small>${genre === "الكل" ? "128" : "24"}</small>
            </a>
          `,
        )
        .join("")}
    </aside>
  `;
}

function RatingStars(value = 4.8) {
  const filled = Math.round(value);
  return `
    <span class="rating-stars" aria-label="تقييم ${value} من 5">
      ${[1, 2, 3, 4, 5].map((index) => `<span>${index <= filled ? "★" : "☆"}</span>`).join("")}
      <b>${escapeHtml(value)}</b>
    </span>
  `;
}

function TagsList(tags = []) {
  return `<div class="tags-list">${tags.map((tag) => `<span>${escapeHtml(tag)}</span>`).join("")}</div>`;
}

function BookCard(book) {
  return `
    <article class="book-card">
      <div class="book-cover cover-${book.tone}" aria-hidden="true">
        <span>${escapeHtml(book.genre)}</span>
      </div>
      <div class="book-card-body">
        <div class="meta-line">
          <span>${escapeHtml(book.status)}</span>
          <span>${book.chapters} فصل</span>
        </div>
        <h3>${escapeHtml(book.title)}</h3>
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
      <div class="book-cover cover-${book.tone}" aria-hidden="true"></div>
      <div>
        <div class="meta-line">
          <span>${escapeHtml(book.genre)}</span>
          <span>${escapeHtml(book.reads)} قراءة</span>
        </div>
        <h3>${escapeHtml(book.title)}</h3>
        <p>${escapeHtml(book.summary)}</p>
      </div>
      <div class="list-side">
        ${RatingStars(book.rating)}
        <button class="icon-button" aria-label="إضافة ${escapeHtml(book.title)} للمكتبة">＋</button>
      </div>
    </article>
  `;
}

function FilterTabs() {
  return `
    <div class="tabs" role="tablist" aria-label="فلترة المحتوى">
      <button class="is-active">الكل</button>
      <button>مكتملة</button>
      <button>قيد النشر</button>
      <button>الأعلى تقييما</button>
    </div>
  `;
}

function SortTabs() {
  return `
    <div class="sort-tabs" aria-label="ترتيب النتائج">
      <button class="is-active">الرائج</button>
      <button>الأحدث</button>
      <button>التقييم</button>
      <button>عدد الفصول</button>
    </div>
  `;
}

function NovelHero(book = mockBooks[0]) {
  return `
    <section class="novel-hero">
      <div class="book-cover cover-${book.tone}" aria-hidden="true"></div>
      <div class="novel-hero-copy">
        <span class="eyebrow">NOVELFLEX Original</span>
        <h1>${escapeHtml(book.title)}</h1>
        <p>${escapeHtml(book.summary)} تجربة قراءة عربية بهوية NOVELFLEX ومساحة واضحة للفصول والمراجعات.</p>
        <div class="hero-meta">
          <span>${escapeHtml(book.author)}</span>
          <span>${escapeHtml(book.genre)}</span>
          <span>${book.chapters} فصل</span>
        </div>
        ${RatingStars(book.rating)}
        ${TagsList(book.tags)}
        <div class="action-row">
          <button class="btn primary">ابدأ القراءة</button>
          <button class="btn secondary">أضف للمكتبة</button>
          <button class="btn ghost">متابعة الكاتب</button>
        </div>
      </div>
    </section>
  `;
}

function ChapterList() {
  return `
    <div class="chapter-list">
      ${mockChapters
        .map(
          (chapter) => `
            <a class="chapter-row" href="#reader">
              <span class="chapter-number">${chapter.number}</span>
              <div>
                <b>${escapeHtml(chapter.title)}</b>
                <small>${escapeHtml(chapter.reads)}</small>
              </div>
              <span class="status ${chapter.status === "مسودة" ? "draft" : ""}">${escapeHtml(chapter.status)}</span>
            </a>
          `,
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
        <div class="review-head">
          <b>${escapeHtml(review.name)}</b>
          ${RatingStars(review.rating)}
        </div>
        <p>${escapeHtml(review.text)}</p>
        <div class="review-actions">
          <span>${escapeHtml(review.meta)}</span>
          <button>مفيد</button>
          <button>إبلاغ</button>
        </div>
      </div>
    </article>
  `;
}

function LibraryCard(book = mockBooks[0]) {
  return `
    <article class="library-card">
      <div class="book-cover cover-${book.tone}" aria-hidden="true"></div>
      <div>
        <span class="eyebrow">متابعة القراءة</span>
        <h3>${escapeHtml(book.title)}</h3>
        <p>آخر قراءة: الفصل ١٢ · التقدم ٦٤٪</p>
        <div class="progress"><span style="width:64%"></span></div>
      </div>
      <button class="btn primary">استئناف</button>
    </article>
  `;
}

function AuthorDashboardLayout() {
  return `
    <section class="author-layout">
      <aside>
        <b>استوديو الكاتب</b>
        <a class="is-active">لوحة التحكم</a>
        <a>رواياتي</a>
        <a>إضافة فصل</a>
        <a>التحليلات</a>
        <a>الأكاديمية</a>
      </aside>
      <div class="author-main">
        <div class="metric-grid">
          <article><span>الروايات</span><b>٣</b></article>
          <article><span>الفصول</span><b>١٦٢</b></article>
          <article><span>القراءات</span><b>٢.٤م</b></article>
        </div>
        <div class="panel">
          <h3>مهام اليوم</h3>
          <p>راجع الفصل الأخير، ثم أرسل المسودة للمراجعة عند اكتمالها.</p>
          ${ChapterList()}
        </div>
      </div>
    </section>
  `;
}

function EmptyState() {
  return `
    <div class="empty-state">
      <span class="state-icon">□</span>
      <h3>لا توجد روايات محفوظة بعد</h3>
      <p>ابدأ من التصفح واحفظ الروايات التي تريد الرجوع إليها لاحقا.</p>
      <button class="btn secondary">تصفح الروايات</button>
    </div>
  `;
}

function LoadingState() {
  return `
    <div class="loading-state" aria-label="جاري التحميل">
      <span></span>
      <span></span>
      <span></span>
    </div>
  `;
}

function Section(title, id, content, subtitle = "") {
  return `
    <section class="preview-section" id="${id}">
      <div class="section-heading">
        <span class="eyebrow">Component</span>
        <h2>${escapeHtml(title)}</h2>
        ${subtitle ? `<p>${escapeHtml(subtitle)}</p>` : ""}
      </div>
      ${content}
    </section>
  `;
}

function renderPreview() {
  const app = document.querySelector("#app");
  app.innerHTML = `
    ${AppNavbar()}
    <main class="preview-shell" id="overview">
      <aside class="preview-rail" aria-label="فهرس المكونات">
        <a href="#foundation">الهوية</a>
        <a href="#navigation">الملاحة</a>
        <a href="#reader">القارئ</a>
        <a href="#novel">تفاصيل الرواية</a>
        <a href="#library">المكتبة</a>
        <a href="#author">الكاتب</a>
        <a href="#states">الحالات</a>
      </aside>
      <div class="preview-content">
        <section class="hero-preview" id="foundation">
          <div>
            <span class="eyebrow">DESIGN SYSTEM</span>
            <h1>نظام تصميم NOVELFLEX للويب</h1>
            <p>
              مكونات عربية RTL، مستوحاة من تخطيطات منصات الروايات، لكنها مصممة لهوية NOVELFLEX
              ببيانات وهمية فقط وبدون أي اتصال خلفي.
            </p>
            <div class="foundation-grid">
              <span>Clean Arabic Typography</span>
              <span>Mobile First</span>
              <span>Desktop Responsive</span>
              <span>Mock Data Only</span>
            </div>
          </div>
          ${BookCard(mockBooks[0])}
        </section>

        ${Section("AppNavbar + UserMenu", "navigation", `
          <div class="component-frame">${AppNavbar()}</div>
        `, "تنقل علوي بسيط للويب مع بحث وقائمة مستخدم.")}

        ${Section("GenreSidebar + FilterTabs + SortTabs", "reader", `
          <div class="browse-preview">
            ${GenreSidebar("خيال")}
            <div class="browse-main">
              ${FilterTabs()}
              ${SortTabs()}
              <div class="book-grid">${mockBooks.map(BookCard).join("")}</div>
            </div>
          </div>
        `)}

        ${Section("BookCard + BookListItem + RatingStars + TagsList", "cards", `
          <div class="book-grid">${mockBooks.map(BookCard).join("")}</div>
          <div class="list-stack">${mockBooks.map(BookListItem).join("")}</div>
        `)}

        ${Section("NovelHero + ChapterList + ReviewCard", "novel", `
          ${NovelHero(mockBooks[0])}
          <div class="two-column">
            <div class="panel">
              <h3>الفصول</h3>
              ${ChapterList()}
            </div>
            <div class="panel">
              <h3>المراجعات</h3>
              ${mockReviews.map(ReviewCard).join("")}
            </div>
          </div>
        `)}

        ${Section("LibraryCard", "library", `
          <div class="list-stack">
            ${LibraryCard(mockBooks[0])}
            ${LibraryCard(mockBooks[1])}
          </div>
        `)}

        ${Section("AuthorDashboardLayout", "author", AuthorDashboardLayout())}

        ${Section("EmptyState + LoadingState", "states", `
          <div class="two-column">
            ${EmptyState()}
            ${LoadingState()}
          </div>
        `)}
      </div>
    </main>
  `;
}

renderPreview();
