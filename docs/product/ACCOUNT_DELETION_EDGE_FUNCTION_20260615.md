# Account Deletion Edge Function

Date: 2026-06-15

## Status

Account deletion is now routed through Supabase instead of the legacy REST API.

- Mobile call site: `lib/MixScreens/AccountInfoScreen.dart`
- Flutter auth service: `lib/data/services/supabase_auth_service.dart`
- Supabase function source: `supabase/functions/delete-account/index.ts`
- Function slug: `delete-account`
- JWT verification: enabled in `supabase/config.toml`

Supabase project `ifxzbwaxrloeuztavcef` currently has an ACTIVE `delete-account`
Edge Function with `verify_jwt=true`.

## Security Model

The Flutter app sends the current user's access token to the Edge Function.
The function verifies that token with the anon client, then uses the service-role
client server-side to delete private rows and finally delete the auth user.

The service-role key must never be shipped in Flutter, web frontend code, or repo
files. Configure it as an Edge Function secret only:

```sh
supabase secrets set SUPABASE_SERVICE_ROLE_KEY=...
```

## Cleanup Scope

The function deletes user-linked rows from:

- `notifications.user_id`
- `reading_progress.user_id`
- `ratings.user_id`
- `favorites.user_id`
- `follows.follower_id`
- `follows.author_id`
- `reports.reporter_id`
- `reports.reported_user_id`
- `books.author_id`
- `writer_profiles.user_id`
- `profiles.id`
- Supabase Auth user via `auth.admin.deleteUser`

## Deploy

Deploy after reviewing any schema changes:

```sh
supabase functions deploy delete-account --project-ref ifxzbwaxrloeuztavcef
```

## Remaining Launch Check

If author uploads are enabled at launch, add server-side storage cleanup for user
owned files in the same function or a background job. The database account
deletion path is no longer legacy-bound.
