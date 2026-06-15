# NOVELFLEX Role System

Date: 2026-06-13
Scope: Permission design only. No implementation, database migration, RLS change, or code change.

## 1. Purpose

This document defines the target role model for NOVELFLEX before implementation. It is the product and security contract for navigation, UI visibility, Supabase RLS, admin tools, and future backend functions.

Current known backend roles use `profiles.role` values such as `reader`, `writer`, and `admin`. This document adds the product-level `Moderator` role as a future role that should be implemented deliberately before exposing moderator tools.

## 2. Roles

| Product role | Current/future backend mapping | Description |
| --- | --- | --- |
| Guest | No Supabase session, optional local guest flag | Anonymous visitor who can discover public content but cannot persist actions. |
| Reader | `profiles.role = reader` | Signed-in user who reads, saves, reviews, follows, and reports. |
| Author | `profiles.role = writer` plus `writer_profiles` | Reader with permission to create and manage owned novels/chapters. |
| Moderator | Future: `profiles.role = moderator` or separate role table | Operational reviewer who handles reports and content queues without full admin control. |
| Admin | `profiles.role = admin` | Full platform operator with content, user, category, and system-level control. |

## 3. Permission Principles

- Deny by default.
- Public read is allowed only for approved/published public content.
- Signed-in actions must be tied to `auth.uid()`.
- Author writes are owner-scoped unless performed by Admin.
- Moderator permissions are operational and limited.
- Admin permissions are powerful and must be audited.
- Financial, payout, service-role, and provider-secret operations must be server-side only.
- UI hiding is not security; Supabase RLS and backend checks remain mandatory.

## 4. Permission Matrix

| Capability | Guest | Reader | Author | Moderator | Admin |
| --- | --- | --- | --- | --- | --- |
| View home/browse/search | Yes | Yes | Yes | Yes | Yes |
| View published novel details | Yes | Yes | Yes | Yes | Yes |
| Read published free chapters | Yes, if policy allows | Yes | Yes | Yes | Yes |
| Save novels to library | No | Yes | Yes | Yes | Yes |
| Persist reading progress | Local only | Yes | Yes | Yes | Yes |
| Rate/review novels | No | Yes | Yes | Yes | Yes |
| Comment on public content | No | Yes | Yes | Yes | Yes |
| Follow authors | No | Yes | Yes | Yes | Yes |
| Report content/users | No or login prompt | Yes | Yes | Yes | Yes |
| Edit own profile | No | Yes | Yes | Yes | Yes |
| Delete own account | No | Yes | Yes | Yes | Yes |
| Create novels | No | No | Yes | No | Yes |
| Edit own novels | No | No | Yes | No | Yes |
| Create/edit own chapters | No | No | Yes | No | Yes |
| Submit content for review | No | No | Yes | No | Yes |
| View own author analytics | No | No | Yes | No | Yes |
| View moderation queue | No | No | No | Yes | Yes |
| View reports | No | No | Own submitted reports only | Yes | Yes |
| Resolve/dismiss reports | No | No | No | Yes | Yes |
| Hide comments/reviews | No | No | No | Yes | Yes |
| Approve/reject books/chapters | No | No | No | Yes, limited | Yes |
| Manage categories | No | No | No | No | Yes |
| Change user roles | No | No | No | No | Yes |
| Approve author profiles | No | No | No | Limited review only | Yes |
| Suspend users/authors | No | No | No | Recommend/temporary hold only | Yes |
| Access audit logs | No | No | No | Limited own actions | Yes |
| Configure platform settings | No | No | No | No | Yes |
| Access monetization/revenue operations | No | No | Future own data only | No | Future admin only |
| Process withdrawals/payouts | No | No | No | No | Future admin/server only |

## 5. Guest

Guest is any user without a valid Supabase session.

Allowed:

- Browse public home sections.
- Search public/published novels.
- Open public novel details.
- Read published free chapters if product policy allows guest reading.
- View public reviews and ratings.
- Enter guest mode for local browsing.

Not allowed:

- Save to library.
- Persist cloud reading progress.
- Rate, review, comment, follow, or report.
- Access profile, author studio, moderation, admin, or settings.
- Access premium/future monetized content.

Expected UI:

- Login prompts for protected actions.
- Guest badge or clear account state.
- Public content must not look broken when unauthenticated.
- No fake saved/reviewed/followed state.

## 6. Reader

Reader is a signed-in user with `profiles.role = reader`.

Allowed:

- All Guest capabilities.
- Save/remove novels through `favorites`.
- Persist reading progress through `reading_progress`.
- Rate and review through `ratings`.
- Comment if comments are enabled.
- Follow/unfollow authors through `follows`.
- Submit reports through `reports`.
- Manage own profile and account.
- Delete own account through the approved backend flow.

Not allowed:

- Create or edit books/chapters.
- Access author publishing tools unless upgraded to Author.
- Access moderator/admin queues.
- View private user data belonging to others.
- Change roles, categories, content status, or platform settings.

Expected UI:

- Reader navigation: Home, Browse, Search, Library, History, Profile.
- Protected action success/error states.
- Empty Library/History states for new accounts.

## 7. Author

Author is a signed-in user with `profiles.role = writer` and a `writer_profiles` record.

Allowed:

- All Reader capabilities.
- Access Author Studio.
- Create draft novels.
- Edit owned novels.
- Add/edit owned chapters.
- Submit books/chapters for publishing or review.
- View basic analytics for owned content.
- View own author profile.

Ownership rule:

- Author can only manage records where `books.author_id = auth.uid()` or where the row is otherwise explicitly connected to their author profile.

Not allowed:

- Edit novels/chapters owned by other authors.
- Approve own content as published if admin/moderator review is required.
- Moderate reports.
- Manage categories.
- Change user roles.
- Access platform-wide analytics.
- Access monetization, withdrawals, or revenue tools in MVP.

Expected UI:

- Author dashboard with owned content only.
- Clear draft, in-review, rejected, and published states.
- No MVP navigation to revenue, paid chapters, subscriptions, withdrawals, or contracts except disabled Coming Soon if product chooses to show them.

## 8. Moderator

Moderator is a future operational role between Author and Admin.

Recommended backend mapping:

- Future `profiles.role = moderator`, or
- A normalized role/permission table if multiple roles per user are needed.

Allowed:

- All Reader capabilities.
- View moderation dashboard.
- View reports queue.
- View reported content and public user context required to review a report.
- Change report status: `reviewing`, `resolved`, `dismissed`, or equivalent.
- Hide or restore comments/reviews when policy allows.
- Approve/reject content in review queues if assigned that permission.
- Add moderation notes.
- Escalate sensitive cases to Admin.

Not allowed:

- Change user roles.
- Delete users.
- Permanently delete content unless explicitly approved by Admin policy.
- Manage categories.
- Manage Supabase settings, OAuth, storage, backups, or environment variables.
- Access service role keys or backend secrets.
- Access monetization, wallet, revenue, or withdrawal operations.
- View private user data beyond what is needed for moderation.

Expected UI:

- Moderator navigation should be limited to Moderation, Reports, Content Approval if enabled, and own Profile.
- Moderator actions must require reason notes for destructive or visibility-changing actions.
- Moderator should see escalation states for cases requiring Admin.

Audit requirement:

- Every Moderator action must write an audit event in the future audit system.
- Audit event should include moderator ID, target entity, action, before/after state, reason, and timestamp.

## 9. Admin

Admin is a signed-in user with `profiles.role = admin`.

Allowed:

- All Reader and Author capabilities.
- View and manage moderation queues.
- View and resolve reports.
- Approve/reject/hide books and chapters.
- Manage categories.
- Review users and author profiles.
- Change user roles where policy allows.
- Access admin-only operational dashboards.
- Manage future monetization operations only after that phase is approved.

High-risk Admin actions:

- Role changes.
- User suspension/deletion.
- Category deletion/disable.
- Content removal.
- Author approval/rejection.
- Manual entitlement grants in future monetization.
- Withdrawal/payout operations in future monetization.

Requirements:

- High-risk actions must require confirmation.
- Every admin mutation must be audited.
- Admin UI must distinguish content moderation from platform configuration.
- Admin permissions should be impossible to grant from the public client alone.

## 10. Route Access Rules

| Route area | Guest | Reader | Author | Moderator | Admin |
| --- | --- | --- | --- | --- | --- |
| `/` | Yes | Yes | Yes | Yes | Yes |
| `/browse`, `/genre/*`, `/search` | Yes | Yes | Yes | Yes | Yes |
| `/novels/:id` | Yes | Yes | Yes | Yes | Yes |
| `/novels/:id/chapters/:id` | Public policy | Yes | Yes | Yes | Yes |
| `/library`, `/history`, `/profile` | No | Yes | Yes | Yes | Yes |
| `/auth/*` | Yes | Yes, redirect if signed in | Yes, redirect if signed in | Yes, redirect if signed in | Yes, redirect if signed in |
| `/author/*` | No | No | Own content | No | Yes |
| `/admin/moderation` | No | No | No | Yes | Yes |
| `/admin/reports` | No | No | No | Yes | Yes |
| `/admin/content-approval` | No | No | No | Limited if enabled | Yes |
| `/admin/categories` | No | No | No | No | Yes |
| `/admin/users` | No | No | No | Limited if enabled | Yes |
| `/admin/audit-log` | No | No | No | Own actions only if enabled | Yes |

## 11. Database Entity Access Summary

Public readable:

- Published `books`.
- Active `categories`.
- Published `chapters` if guest reading is allowed.
- Public profile/author display fields.
- Public `ratings`/reviews if policy allows.

Reader-owned:

- Own `favorites`.
- Own `reading_progress`.
- Own `reading_sessions`.
- Own `ratings`.
- Own `comments`.
- Own `follows`.
- Own `reports`.
- Own `notifications`.
- Own `profiles` editable fields.

Author-owned:

- Own `books`.
- Own `chapters`.
- Own writer profile.
- Own author analytics views/events.

Moderator:

- Read assigned or global `reports` depending operational model.
- Read reported content context.
- Update moderation status fields only.
- Add moderation notes.

Admin:

- Platform-wide moderation entities.
- Categories.
- User role/status management.
- Content approval status.
- Future audit log and financial admin surfaces.

## 12. Implementation Notes For Later

No implementation is part of this document, but future work should:

- Add `moderator` to the canonical role strategy only after RLS and UI gates are designed.
- Prefer server-verified role checks for privileged operations.
- Avoid using user-editable metadata for authorization.
- Keep authorization data in `profiles.role` or secure app metadata, not public profile fields.
- Add RLS tests for Guest, Reader, Author, Moderator, and Admin.
- Add route guard tests for every protected route.
- Add audit logging before enabling Moderator/Admin write actions in production.

## 13. Open Decisions

- Whether one user can hold multiple roles, such as Author + Moderator.
- Whether Moderator can approve content directly or only recommend action.
- Whether guest chapter reading is allowed for all published chapters or only selected books.
- Whether profile public fields should be readable by anonymous users.
- Whether Admin role changes require two-person approval.

Final status:

```text
ROLE SYSTEM DESIGNED ONLY - NOT IMPLEMENTED
```
