-- BERECHTIGUNGS-FIX
-- Führe diese Query in Supabase → SQL Editor → New query → Run aus.
-- Damit funktionieren Speichern, Freigeben, Löschen und Foto-Moderation.
--
-- Admin-Login nutzt Supabase Auth (signInWithPassword) → role: authenticated.
-- Besucher ohne Login → role: anon.

-- ───── Tabelle: eintraege ─────

drop policy if exists "submit pending"  on public.eintraege;
drop policy if exists "admin all"       on public.eintraege;
drop policy if exists "anon insert"     on public.eintraege;
drop policy if exists "anon update"     on public.eintraege;
drop policy if exists "anon delete"     on public.eintraege;

-- Lesen: nur freigegebene Einträge für Besucher (Nicht-Angemeldete)
drop policy if exists "read approved"   on public.eintraege;
create policy "read approved" on public.eintraege
  for select to anon using (approved = true);

-- Besucher: einreichen erlaubt (wird als pending=false gespeichert)
create policy "anon insert" on public.eintraege
  for insert to anon with check (true);

create policy "anon update" on public.eintraege
  for update to anon using (true) with check (true);

create policy "anon delete" on public.eintraege
  for delete to anon using (true);

-- Admin (eingeloggt via Supabase Auth): voller Zugriff (alle Einträge, inkl. pending)
create policy "admin all" on public.eintraege
  for all to authenticated using (true) with check (true);

-- ───── Tabelle: foto_vorschlaege ─────

drop policy if exists "foto submit"     on public.foto_vorschlaege;
drop policy if exists "foto admin"      on public.foto_vorschlaege;
drop policy if exists "foto read"       on public.foto_vorschlaege;
drop policy if exists "foto update"     on public.foto_vorschlaege;
drop policy if exists "foto delete"     on public.foto_vorschlaege;

-- Besucher: Foto-Vorschläge einreichen
create policy "foto submit" on public.foto_vorschlaege
  for insert to anon with check (true);

-- Admin (authenticated): voller Zugriff auf alle Vorschläge
create policy "foto admin" on public.foto_vorschlaege
  for all to authenticated using (true) with check (true);
