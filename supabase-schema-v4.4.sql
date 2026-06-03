-- Hillsong Northshore Scheduler v4.4
-- Run this in Supabase Dashboard -> SQL Editor.
-- v4.4 stores the app as one shared JSON document.
-- All authenticated users are treated as admins for now.

create table if not exists public.app_state (
  id text primary key,
  store jsonb not null default '{"activeId": null, "records": []}'::jsonb,
  calendar jsonb not null default '{"events": []}'::jsonb,
  updated_by uuid references auth.users(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.app_state enable row level security;

drop policy if exists "Authenticated users can read scheduler state" on public.app_state;
create policy "Authenticated users can read scheduler state"
on public.app_state
for select
to authenticated
using (auth.uid() is not null);

drop policy if exists "Authenticated users can create scheduler state" on public.app_state;
create policy "Authenticated users can create scheduler state"
on public.app_state
for insert
to authenticated
with check (auth.uid() is not null);

drop policy if exists "Authenticated users can update scheduler state" on public.app_state;
create policy "Authenticated users can update scheduler state"
on public.app_state
for update
to authenticated
using (auth.uid() is not null)
with check (auth.uid() is not null);

drop policy if exists "Authenticated users can delete scheduler state" on public.app_state;
create policy "Authenticated users can delete scheduler state"
on public.app_state
for delete
to authenticated
using (auth.uid() is not null);
