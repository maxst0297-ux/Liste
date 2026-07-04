-- ADMIN & MODERATION einrichten
-- In Supabase: SQL Editor -> New query -> einfügen -> Run.
--
-- Hinweis: Der Admin dieser App meldet sich nur client-seitig an (kein Supabase Auth).
-- Schreibrechte werden deshalb generell für "anon" freigegeben;
-- die Moderation (Freigabe/Ablehnung) findet in der App statt.

-- 1) Freigabe-Spalte
alter table public.eintraege add column if not exists approved boolean not null default false;
update public.eintraege set approved = true where approved = false;   -- vorhandene Einträge freigeben

-- 2) Alte Policies entfernen
drop policy if exists "public read"    on public.eintraege;
drop policy if exists "anon insert"    on public.eintraege;
drop policy if exists "anon update"    on public.eintraege;
drop policy if exists "anon delete"    on public.eintraege;
drop policy if exists "read approved"  on public.eintraege;
drop policy if exists "submit pending" on public.eintraege;
drop policy if exists "admin all"      on public.eintraege;

-- 3) Neue Policies
-- Öffentlich (ohne Login): nur FREIGEGEBENE Einträge lesen
create policy "read approved" on public.eintraege
  for select to anon using (approved = true);

-- Besucher: Einträge einreichen und bearbeiten (z. B. eigene pending-Einreichung)
create policy "anon insert" on public.eintraege
  for insert to anon with check (true);

create policy "anon update" on public.eintraege
  for update to anon using (true) with check (true);

create policy "anon delete" on public.eintraege
  for delete to anon using (true);

-- Admin (nach signInWithPassword, role: authenticated): voller Zugriff
create policy "admin all" on public.eintraege
  for all to authenticated using (true) with check (true);
