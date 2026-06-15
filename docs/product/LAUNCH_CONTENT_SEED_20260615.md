# NOVELFLEX Launch Content Seed

Date: 2026-06-15

## Purpose

This seed unblocks the reader QA loop by adding one approved writer profile,
one published Arabic novel, and three published text chapters to the live
Supabase project.

## Supabase Project

- Project: `NOFEL FLEX`
- Project ref: `ifxzbwaxrloeuztavcef`

## Seeded Records

### Writer

- Profile id: `11111111-1111-4111-8111-111111111111`
- Display name: `RevenueCat QA`
- Role updated to: `writer`
- Writer profile pen name: `كاتب نوفلفلكس`
- Writer profile status: approved

### Book

- Book id: `22222222-2222-4222-8222-222222222222`
- Arabic title: `مدينة الحبر`
- English title: `Ink City`
- Category: `فانتازيا`
- Status: `published`
- Language: `ar`
- Published chapters count: `3`

### Chapters

- Chapter 1: `الباب الذي لا يصدأ`
- Chapter 2: `خريطة في الهامش`
- Chapter 3: `حارس الفصل الأخير`

## Verification

Direct SQL counts after seeding:

```text
writer_profiles: 1
books: 1
published_books: 1
chapters: 3
published_chapters: 3
```

Anon Data API verification passed for:

- published book list
- published chapter list for book `22222222-2222-4222-8222-222222222222`

## Notes

- The seed uses fixed UUIDs and upsert-safe behavior so it can be rerun without
  duplicating the book or chapters.
- This content is suitable for QA and launch smoke testing. It should be
  replaced or expanded with editorially approved launch content before public
  marketing.
