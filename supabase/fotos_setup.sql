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

-- Besucher dürfen einreichen (nur als nicht-freigegeben), aber nicht lesen
drop policy if exists "foto submit" on public.foto_vorschlaege;
create policy "foto submit" on public.foto_vorschlaege
  for insert to anon with check (approved = false);

-- Admin (eingeloggt): alles (lesen, freigeben, löschen)
drop policy if exists "foto admin" on public.foto_vorschlaege;
create policy "foto admin" on public.foto_vorschlaege
  for all to authenticated using (true) with check (true);
