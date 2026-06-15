# NOVELFLEX Notification Foundation Report

Date: 2026-06-13

## Scope

This phase designs and implements a minimal notification foundation.

Events covered:

- New Chapter Published
- New Review
- New Follower

Implementation constraints:

- Use existing schema where possible.
- Keep implementation minimal.
- No schema migration.
- No Edge Functions.
- No push notification provider.
- No legacy REST APIs.

## Files Changed

- `web/frontend-ui/app.js`
  - Added notification state.
  - Added notification loading from Supabase.
  - Added notification creation helper.
  - Added notification UI inside `UserMenu`.
  - Added notification events after:
    - publishing a chapter
    - submitting a review
    - following an author

- `web/frontend-ui/styles.css`
  - Added notification badge and compact notification list styling.

- `docs/product/NOTIFICATION_REPORT.md`
  - Documents implementation, live schema verification, and blockers.

## Existing Schema Verification

Live table check:

```text
notifications?select=*&limit=1
```

Result:

```json
[]
```

Status:

```text
PASS/PARTIAL
```

The table exists but has no public rows in the anon check.

Confirmed columns through selective REST checks:

- `id`
- `user_id`
- `type`
- `data`
- `is_read`
- `created_at`

Columns confirmed absent:

- `title`
- `body`
- `message`
- `payload`
- `recipient_id`
- `actor_id`
- `book_id`

## Notification Payload

The minimal insert payload is:

```json
{
  "user_id": "recipient-user-id",
  "type": "event_type",
  "data": {
    "title": "Arabic title",
    "body": "Arabic body",
    "book_id": "optional",
    "chapter_id": "optional",
    "author_id": "optional",
    "follower_id": "optional"
  },
  "is_read": false
}
```

No standalone `title` or `body` columns are used because they do not exist in the current live schema.

## Event Design

### 1. New Chapter Published

Trigger point:

- After an author saves a chapter with `status = published`.

Recipient lookup:

```text
follows
where author_id = current author id
```

Notification type:

```text
new_chapter_published
```

Data:

- `title`
- `body`
- `book_id`
- `chapter_id`
- `author_id`

Current limitation:

- This depends on working chapter publishing through `pdf_files`, which is currently blocked because `pdf_files` is missing from schema cache.

### 2. New Review

Trigger point:

- After a reader submits a review.

Recipient:

```text
books.author_id
```

Notification type:

```text
new_review
```

Data:

- `title`
- `body`
- `book_id`
- `preview`

Current limitation:

- This depends on `reviews`, which is currently missing from schema cache.

### 3. New Follower

Trigger point:

- After a reader follows an author.

Recipient:

```text
follows.author_id
```

Notification type:

```text
new_follower
```

Data:

- `title`
- `body`
- `follower_id`

Current limitation:

- `follows` exists, but RLS must be verified with a real signed-in user.

## UI Implementation

Location:

- `UserMenu`

Behavior:

- Loads the latest 20 notifications for signed-in users.
- Shows an unread badge when `is_read = false`.
- Displays the latest 3 notification titles/bodies.
- Shows a compact error if loading fails.

No mark-as-read implementation was added in this minimal phase.

## Supabase Queries

### Load Notifications

```text
notifications
select id,user_id,type,data,is_read,created_at
where user_id = auth.uid()
order by created_at desc
limit 20
```

### Create Notification

```text
notifications.insert({
  user_id,
  type,
  data,
  is_read: false
})
```

## Verification

Checks run:

- `node --check web/frontend-ui/app.js`: PASS
- Mocked signed-in notification UI harness: PASS
- Live REST schema checks for `notifications`: PASS/PARTIAL
- Static scan for legacy/payment APIs in notification changes: PASS
- Local frontend HTTP check remains available at:
  - `http://127.0.0.1:4173/frontend-ui/`

## Blockers

### 1. Event source tables are not all production-ready

Current known state:

- `pdf_files`: missing from schema cache.
- `reviews`: missing from schema cache.
- `follows`: exists but authenticated RLS is unverified.

Impact:

- New Chapter Published cannot fire end-to-end until chapter publishing works.
- New Review cannot fire end-to-end until reviews work.
- New Follower can work after follow RLS is verified.

### 2. Notification inserts require RLS verification

Required policy:

- Authenticated users or controlled backend logic can insert notification rows for valid event recipients.
- Users can select only their own notifications:

```text
notifications.user_id = auth.uid()
```

### 3. No push delivery yet

This phase only implements in-app notification foundation.

Future push delivery options:

- Supabase Edge Function
- Expo/FCM/APNs bridge
- Scheduled digest

## Current Decision

Notification foundation is implemented minimally using the existing `notifications` table.

Production usage is partially blocked until:

- Related event source tables are available.
- Notification insert/select RLS is verified.
- A real signed-in user flow is tested for each event.
