-- FOTO-VORSCHLÄGE (moderiert): Besucher reichen Fotos zu Einträgen ein,
-- Admin gibt sie frei -> dann für alle sichtbar.
-- In Supabase: SQL Editor -> New query -> einfügen -> Run.

create table if not exists public.foto_vorschlaege (
  id bigint generated always as identity primary key,
  entry_id   text not null,
  entry_name text,
  bild       text not null,
  approved   boolean not null default false,
  created_at timestamptz default now()
);

alter table public.foto_vorschlaege enable row level security;

-- Hinweis: Admin ist client-seitig, deshalb braucht anon vollständige Schreibrechte.

drop policy if exists "foto read"   on public.foto_vorschlaege;
drop policy if exists "foto submit" on public.foto_vorschlaege;
drop policy if exists "foto update" on public.foto_vorschlaege;
drop policy if exists "foto delete" on public.foto_vorschlaege;
drop policy if exists "foto admin"  on public.foto_vorschlaege;

-- Admin muss alle Vorschläge (auch nicht freigegebene) sehen und bearbeiten können
create policy "foto read" on public.foto_vorschlaege
  for select to anon using (true);

create policy "foto submit" on public.foto_vorschlaege
  for insert to anon with check (true);

create policy "foto update" on public.foto_vorschlaege
  for update to anon using (true) with check (true);

create policy "foto delete" on public.foto_vorschlaege
  for delete to anon using (true);
