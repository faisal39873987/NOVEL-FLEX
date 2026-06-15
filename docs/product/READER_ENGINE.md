# NOVELFLEX Reader Engine

Date: 2026-06-13
Scope: design only. No code, database migration, API change, or backend implementation.

## 1. Purpose

The Reader Engine is the core NOVELFLEX reading experience. It controls how a reader opens a chapter, navigates between chapters, resumes the last read position, saves reading progress, and customizes the reading surface.

Primary goal:

```text
Reader opens a novel -> starts or continues reading -> navigates chapters -> progress is saved -> Library/History resumes exactly where they left off.
```

## 2. Core Features

- Continue reading.
- Last chapter read.
- Chapter navigation.
- Reading progress.
- Font size controls.
- Theme mode controls.
- Arabic RTL support.

## 3. Canonical Data Sources

Canonical tables:

- `books`
- `chapters`
- `reading_progress`
- `reading_sessions`
- `chapter_read_events`
- `favorites`

Related entities:

- `profiles`
- `categories`
- `ratings`

Legacy names to avoid in new design:

- `pdf_files`
- `reading_history`

Compatibility note:

- Old PDF/file concepts should be absorbed into `chapters`.
- Old reading history concepts should be absorbed into `reading_progress` and `reading_sessions`.

## 4. Reader Engine Architecture

Target service boundary:

```text
Reader UI -> ChapterService / LibraryService -> Supabase repositories -> Supabase tables/storage
```

Reader UI must not query tables directly. It should call service methods:

- `ChapterService.listChapters(novelId)`
- `ChapterService.getChapter(novelId, chapterId)`
- `ChapterService.getProgress(novelId, chapterId)`
- `ChapterService.saveProgress(novelId, chapterId, progress)`
- `ChapterService.recordChapterOpened(novelId, chapterId)`
- `ChapterService.recordChapterCompleted(novelId, chapterId)`
- `LibraryService.continueReading()`
- `LibraryService.getHistory()`

## 5. Chapter Model

Canonical `Chapter` shape:

| Field | Purpose |
| --- | --- |
| `id` | Chapter UUID/string ID. |
| `bookId` | Parent novel/book ID. |
| `number` | Ordered chapter number. |
| `title` | Display title, Arabic preferred. |
| `status` | `draft`, `in_review`, `published`, `rejected`, `archived`. |
| `contentText` | Inline text content if available. |
| `filePath` | Protected/public file path if chapter is file-based. |
| `audioPath` | Optional audio path if audio chapters exist. |
| `publishedAt` | Published timestamp. |
| `previousChapterId` | Derived by service. |
| `nextChapterId` | Derived by service. |

Reader-facing rules:

- Only `published` chapters are visible to Guest/Reader.
- Draft/in-review/rejected chapters are visible only to owning Author/Admin review flows.
- Chapter ordering comes from `chapter_number`, not creation date.
- Missing chapter number should fall back to a stable sort but must be flagged for data cleanup.

## 6. Reading Progress Model

Canonical `ReadingProgress` shape:

| Field | Purpose |
| --- | --- |
| `id` | Progress row ID. |
| `userId` | Reader profile/user ID. |
| `bookId` | Novel/book ID. |
| `chapterId` | Last or current chapter ID. |
| `progressPercent` | 0 to 100. |
| `lastPosition` | JSON metadata for scroll/page position. |
| `lastReadAt` | Timestamp used for Continue Reading. |
| `completedAt` | Optional completion timestamp. |

Recommended `lastPosition` payload:

```json
{
  "percent": 42,
  "scrollY": 1840,
  "contentMode": "text",
  "source": "web",
  "version": 1
}
```

Progress rules:

- `progressPercent` is clamped between 0 and 100.
- Saving progress updates `lastReadAt`.
- When progress reaches 95% or more, the UI can offer “Next chapter”.
- When progress reaches 100%, service records `chapter_read_events.completed`.
- Guests may keep local progress only; signed-in users persist to Supabase.

## 7. Continue Reading

Continue Reading is a personalized resume surface shown on:

- Home.
- Library.
- Reading History.
- Novel Details if the reader has previous progress for that novel.

Entry points:

- Home “أكمل القراءة”.
- Library continue cards.
- History list.
- Novel Details primary button changes from “ابدأ القراءة” to “أكمل القراءة”.

Data query:

- Source: `reading_progress`.
- Join: `books`, `chapters`.
- Sort: `last_read_at desc`.
- Filter: current signed-in user.

Guest behavior:

- Show local continue-reading only for the current browser/device if local progress exists.
- Do not imply cloud sync.
- Prompt login to sync progress.

Expected UI states:

- Loading continue list.
- Empty state: “لم تبدأ القراءة بعد”.
- Resume card with cover, title, chapter title, progress bar, and last read time.
- Stale state if chapter was unpublished/removed.
- Error state with retry.

## 8. Last Chapter Read

The last chapter read is derived from the newest `reading_progress` record for a book.

For each novel:

1. Find latest progress by `user_id` + `book_id`.
2. Resolve `chapter_id`.
3. Verify chapter is still `published`.
4. If valid, resume that chapter.
5. If invalid, fall back to:
   - next available published chapter, or
   - first published chapter, or
   - Novel Details with “No chapters available” state.

Display:

- Novel Details: “آخر قراءة: الفصل X”.
- Library: progress card.
- History: chronological item.

## 9. Chapter Navigation

Navigation controls:

- Previous chapter.
- Next chapter.
- Chapter list/table of contents.
- Back to Novel Details.
- Back to Library/History when entered from resume.

Rules:

- Previous button disabled or routes to Novel Details on first chapter.
- Next button disabled or shows “آخر فصل” on final published chapter.
- Chapter list highlights current chapter.
- Navigation must preserve current reader settings.
- On chapter change, record opened event once per session.
- Save current progress before navigating when possible.

Keyboard/future shortcuts:

- Arrow left/right should respect RTL semantics carefully.
- For Arabic RTL, “next chapter” should be visually and textually unambiguous.
- Do not rely only on arrow icons.

## 10. Reading Progress Behavior

Progress can be calculated by:

- Scroll position for text chapters.
- Page number for PDF/file chapters.
- Manual slider in early web MVP.
- Audio timestamp for future audio chapters.

Recommended production behavior:

- Auto-save progress every 15 to 30 seconds while reading.
- Save on page visibility hidden.
- Save before chapter navigation.
- Save when user reaches chapter end.
- Debounce writes to avoid excessive Supabase updates.

Conflict handling:

- If another device has newer `lastReadAt`, prefer newer progress.
- If local progress is higher but older, ask or silently keep server state depending product choice.
- Never overwrite a newer server progress with stale local state.

## 11. Font Size Controls

Reader must support at least:

- Small.
- Default.
- Large.
- Extra large.

Recommended values:

| Setting | Text size |
| --- | --- |
| Small | 16px |
| Default | 18px |
| Large | 20px |
| Extra large | 22px |

Rules:

- Font setting is user preference, not chapter data.
- Persist locally for guests.
- Persist to profile/user preferences later for signed-in sync.
- Font changes must not reset reading progress.
- Line height should scale with font size.
- Arabic text must remain comfortable and avoid cramped lines.

Recommended default:

- Arabic chapter body: 18px, line-height 1.9.
- Max text width around 680-760px on desktop.

## 12. Theme Mode

Reader themes:

- Light.
- Sepia.
- Dark.

Theme responsibilities:

- Background.
- Text color.
- Link/control contrast.
- Progress bar contrast.
- Reader toolbar contrast.

Recommended theme tokens:

| Theme | Background | Text | Use case |
| --- | --- | --- | --- |
| Light | warm off-white | near-black | Default daytime reading |
| Sepia | soft paper beige | dark brown/ink | Long-form comfort |
| Dark | near-black | warm light gray | Night reading |

Rules:

- Theme is reader preference.
- Persist locally for guests.
- Sync to profile preferences later for signed-in users.
- Theme must meet accessibility contrast.
- Theme changes must not reset reading progress.

## 13. RTL Support

Arabic reading is first-class.

Required RTL behavior:

- Document or reader surface uses `dir="rtl"` for Arabic content.
- Body text aligns right.
- Chapter titles align right.
- Table of contents lists chapters in natural Arabic order.
- Previous/next labels use Arabic text, not icon-only controls.
- Paragraph spacing supports Arabic long-form reading.
- Mixed English terms remain readable with correct bidirectional behavior.

LTR future support:

- Chapter language should control text direction when content is not Arabic.
- UI can remain Arabic RTL while chapter body can use `dir="ltr"` for English content if needed.

## 14. Reader UI Layout

Mobile:

- Top compact header with title/back.
- Reader toolbar collapsible or sticky.
- Chapter body full-width with safe padding.
- Bottom controls for previous/next.
- Progress indicator visible but not distracting.

Desktop:

- Center reading column.
- Optional side table of contents.
- Sticky minimal toolbar.
- Avoid card-heavy framing around the chapter body.

Reader screen sections:

1. Reader toolbar.
2. Chapter title and metadata.
3. Progress control/status.
4. Chapter body/file viewer.
5. Previous/next navigation.
6. Table of contents.

## 15. UI States

| State | Behavior |
| --- | --- |
| Loading chapter | Show skeleton or calm loading text. |
| Empty chapter | Show missing content message and return to Novel Details. |
| Published chapter | Render body/file with reader controls. |
| Guest reading | Allow public reading if policy permits; local progress only. |
| Signed-in reading | Persist progress to Supabase. |
| Save progress loading | Show “جاري حفظ التقدم...”. |
| Save progress success | Show short confirmation. |
| Save progress failure | Keep local progress and show retry. |
| Offline | Continue existing loaded chapter, queue local progress if supported later. |
| Removed/unpublished chapter | Show unavailable state and route to Novel Details. |
| Final chapter | Disable next or offer return to Novel Details/Library. |

## 16. Service Events

Events to record:

- `chapter_opened`
- `chapter_completed`
- `progress_saved`
- `continue_reading_opened`

Canonical tables:

- `chapter_read_events`
- `reading_sessions`
- `reading_progress`

Event rules:

- Do not spam `chapter_opened`; once per chapter per reader session is enough.
- `chapter_completed` should be idempotent.
- Guests can record anonymous aggregate events only if privacy policy allows.
- Do not store sensitive content in event payloads.

## 17. Offline Behavior

MVP:

- If chapter is already loaded, user can continue reading.
- Guest/local progress can be stored locally.
- Signed-in progress should retry later only if offline queue is implemented.

Future:

- Local queue for progress writes.
- Conflict resolution on reconnect.
- Optional cached recent chapters.

Offline UI:

- Show unobtrusive offline indicator.
- Do not block reading already-loaded content.
- Make sync status clear: local only vs synced.

## 18. Accessibility

Required:

- Adjustable font size.
- Sufficient contrast in all themes.
- Buttons with text labels.
- Keyboard focus states.
- Screen-reader readable progress label.
- Avoid tiny tap targets in chapter navigation.

Recommended:

- Reduce motion in reader transitions.
- Keep toolbar stable while reading.
- Avoid automatic scroll jumps after saving settings.

## 19. Security And Access

Public access:

- Published free chapters may be readable by guests if product policy allows.

Protected access:

- Draft/in-review/rejected chapters hidden from public readers.
- Author preview only for owner or admin.
- Future premium chapters require entitlement checks.

Never expose:

- Private storage paths if signed URLs are required.
- Draft chapter content to public clients.
- Other users’ reading progress.

RLS requirements:

- Reader can read/write only own `reading_progress`.
- Reader can read public published chapters.
- Author can preview/edit own chapters.
- Admin/moderator access must be role-guarded.

## 20. Acceptance Criteria

Reader Engine is complete when:

- Reader can open a novel and start first published chapter.
- Reader can navigate previous/next chapters.
- Reader can return to last chapter read.
- Reader can continue reading from Home, Library, and History.
- Progress persists for signed-in users.
- Guest progress is local and clearly indicated.
- Font size changes persist and do not reset progress.
- Theme changes persist and do not reset progress.
- Arabic RTL chapter content is comfortable and correct.
- Missing/offline/error states are handled without blank screens.

Final status:

```text
READER ENGINE DESIGNED - NOT IMPLEMENTED
```
