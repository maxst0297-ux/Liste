-- ADMIN & MODERATION einrichten
-- In Supabase: SQL Editor -> New query -> einfügen -> Run.

-- 1) Freigabe-Spalte
alter table public.eintraege add column if not exists approved boolean not null default false;
update public.eintraege set approved = true where approved = false;   -- vorhandene Einträge freigeben

-- 2) Alte Policies entfernen
drop policy if exists "public read"  on public.eintraege;
drop policy if exists "anon insert"  on public.eintraege;
drop policy if exists "anon update"  on public.eintraege;
drop policy if exists "read approved" on public.eintraege;
drop policy if exists "submit pending" on public.eintraege;
drop policy if exists "admin all"    on public.eintraege;

-- 3) Neue Policies
-- Öffentlich: nur FREIGEGEBENE Einträge lesen
create policy "read approved" on public.eintraege
  for select to anon using (approved = true);

-- Öffentlich: einreichen erlaubt, aber NUR als nicht-freigegeben (Moderation)
create policy "submit pending" on public.eintraege
  for insert to anon with check (approved = false);

-- Admin (eingeloggt): alles lesen/schreiben/ändern/löschen + freigeben
create policy "admin all" on public.eintraege
  for all to authenticated using (true) with check (true);
