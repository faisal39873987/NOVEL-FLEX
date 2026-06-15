create table if not exists public.client_error_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid default auth.uid() references auth.users (id) on delete set null,
  area text not null,
  message text not null,
  context jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

alter table public.client_error_logs enable row level security;

revoke all on public.client_error_logs from anon;
grant select, insert on public.client_error_logs to authenticated;

drop policy if exists "client error logs insert own" on public.client_error_logs;
create policy "client error logs insert own"
on public.client_error_logs
for insert
to authenticated
with check (
  (select auth.uid()) is not null
  and (user_id is null or user_id = (select auth.uid()))
);

drop policy if exists "client error logs admin read" on public.client_error_logs;
create policy "client error logs admin read"
on public.client_error_logs
for select
to authenticated
using ((select public.is_admin()));

create index if not exists client_error_logs_user_id_idx
on public.client_error_logs (user_id);

create index if not exists client_error_logs_created_at_idx
on public.client_error_logs (created_at desc);
