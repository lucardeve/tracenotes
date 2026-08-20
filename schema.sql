-- Paste this whole file into Supabase → SQL Editor → New query → Run.
-- Creates one table for boards and locks it to the signed-in user.

create table if not exists public.boards (
  id         text        not null,
  user_id    uuid        not null references auth.users(id) on delete cascade,
  name       text        not null default 'Board',
  data       jsonb       not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  primary key (user_id, id)
);

alter table public.boards enable row level security;

drop policy if exists "read own boards"   on public.boards;
drop policy if exists "insert own boards" on public.boards;
drop policy if exists "update own boards" on public.boards;
drop policy if exists "delete own boards" on public.boards;

create policy "read own boards"   on public.boards for select using (auth.uid() = user_id);
create policy "insert own boards" on public.boards for insert with check (auth.uid() = user_id);
create policy "update own boards" on public.boards for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "delete own boards" on public.boards for delete using (auth.uid() = user_id);

create index if not exists boards_user_idx on public.boards(user_id);
