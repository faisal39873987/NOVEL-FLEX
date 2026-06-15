# NOVELFLEX Design System

Date: 2026-06-13

Scope: design-only system for NOVELFLEX Web. Inspired by the provided reference screenshots and prepared for Arabic RTL, mobile-first layouts, and responsive desktop screens. No backend, database, or API behavior is included.

Preview: `web/design-system/index.html`

## Design Direction

NOVELFLEX should feel like a fast reading product, not a marketing site. The visual language should be content-first, dense enough for browsing, and calm enough for long reading sessions.

Principles:

- Arabic RTL first, with LTR support later.
- Mobile first, then expand to desktop with sidebars and wider content grids.
- Clear hierarchy: cover, title, author, status, rating, action.
- Familiar reading platform patterns: top nav, genre sidebar, filters, cards, table of contents, reviews, library/history tabs.
- Monetization, contracts, revenue, withdrawals, and subscriptions remain future-phase surfaces only.

## Color System

| Token | Value | Use |
| --- | --- | --- |
| `--nf-bg` | `#f7f4ef` | App background |
| `--nf-surface` | `#fffdf9` | Main surfaces |
| `--nf-surface-raised` | `#ffffff` | Cards, panels, popovers |
| `--nf-ink` | `#1c1a17` | Primary text |
| `--nf-muted` | `#716a60` | Secondary text |
| `--nf-line` | `#e5ded3` | Borders and dividers |
| `--nf-brand` | `#137c7a` | Primary brand/action |
| `--nf-brand-dark` | `#0f5f5e` | Hover/active primary |
| `--nf-gold` | `#c8842d` | Ratings and premium accent |
| `--nf-red` | `#b54747` | Destructive/report |
| `--nf-green` | `#2f7d4f` | Published/success |
| `--nf-blue` | `#3867a6` | Informational links |
| `--nf-chip` | `#eee7dc` | Filter chips |

Avoid one-note palettes. The screenshots lean mostly light/neutral; NOVELFLEX should add teal, gold, blue, and restrained red/green semantics.

## Typography

Recommended stack:

```css
font-family: "Tajawal", "IBM Plex Sans Arabic", "Noto Sans Arabic", system-ui, sans-serif;
```

Scale:

| Token | Size | Line height | Use |
| --- | --- | --- | --- |
| Display | 32px | 1.2 | Novel hero titles on desktop |
| H1 | 26px | 1.25 | Page titles |
| H2 | 21px | 1.3 | Section headers |
| H3 | 17px | 1.35 | Card titles |
| Body | 15px | 1.7 | Reading/product text |
| Small | 13px | 1.5 | Metadata, badges |
| Tiny | 11px | 1.4 | Labels/counters |

Mobile titles should stay compact. Do not use oversized hero typography inside dashboards, cards, or tool panels.

## Layout

- Mobile page width: full viewport with 16px horizontal padding.
- Tablet/desktop content max width: 1180px.
- Cards use 8px radius max.
- Repeated list items use fixed cover dimensions to prevent layout shift.
- Reader content should use a comfortable max width around 720px.
- Author/admin pages use side navigation on desktop and drawer/navigation tabs on mobile.

## Components

### Buttons

- Primary: filled teal, for Read, Publish, Save.
- Secondary: white with line border, for Add to Library, Edit.
- Ghost: transparent, for navigation and low-emphasis actions.
- Danger: red text or red filled for destructive actions.

### Cards

- Book cards: cover thumbnail, category/status badge, title, author, rating, chapter count, short synopsis, add action.
- Novel hero card: cover, metadata, rating, primary actions, status tags.
- Dashboard metric cards: compact count, label, trend, no decorative nesting.

### Inputs

- Search input with icon affordance.
- Text fields with visible labels.
- Select/filter controls as chips or segmented controls.
- Textarea for chapter/review content.

### Tags

- Genre tags: neutral chip.
- Status tags: semantic color.
- Content tags: compact, wrap naturally.
- Future-only tags: muted with Coming Soon state.

### Rating Widgets

- Star rating uses gold.
- Review summary shows average, count, and distribution.
- User input should allow 1-5 selection with clear active state.

### Review Widgets

- Review item includes avatar, name, rating, date, body, like/report actions.
- Long reviews collapse after a readable preview.
- Replies/comments use indentation in desktop and subtle line in mobile.

### Navigation

- Reader top nav: logo, Browse, Rankings, Create, search, Library, account.
- Mobile bottom nav: Home, Browse, Search, Library, Profile.
- Author side nav: Dashboard, My Novels, Create, Analytics, Academy.
- Admin side nav: Moderation, Categories, Reports, Content Approval.

## Responsive Behavior

Mobile:

- One-column content.
- Sticky bottom nav for reader.
- Filter panels collapse into sheet/drawer.
- Novel details stack cover/title/actions.
- Author/admin side navigation collapses into horizontal tabs or drawer.

Desktop:

- Browse uses genre/filter sidebar plus content list.
- Novel detail uses cover/meta hero with content tabs below.
- Author/admin use persistent left side navigation and dense tables/lists.

## Accessibility

- Minimum tap target: 44px.
- Text contrast should meet WCAG AA.
- Keyboard focus rings are visible.
- Rating controls must have accessible labels.
- Do not encode state only by color.
- RTL spacing, icon direction, and text alignment must be intentional.

## Phase Boundaries

Phase 1 active design:

- Reader discovery, search, novel details, chapter reader, reviews, library, history, profile.
- Author dashboard, my novels, create/edit novel, add chapter, basic analytics, academy.
- Admin moderation, categories, reports, content approval.

Coming Soon only:

- Payments
- Subscriptions
- Coins
- Revenue
- Withdrawals
- Contracts
- Monetization dashboards

