-- RechtsAmpel / Datenbank – Supabase Schema + Leserechte
-- In Supabase: SQL Editor -> New query -> einfügen -> Run

create table if not exists public.eintraege (
  id text primary key,
  kategorie text,
  name text,
  ampel text,
  doc jsonb not null,
  updated_at timestamptz default now()
);

create index if not exists eintraege_kategorie_idx on public.eintraege(kategorie);

alter table public.eintraege enable row level security;

-- Öffentliches Lesen erlauben (anon). Schreiben bleibt gesperrt.
drop policy if exists "public read" on public.eintraege;
create policy "public read" on public.eintraege
  for select to anon using (true);
