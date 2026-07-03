-- BERECHTIGUNGS-FIX
-- Führe diese Query in Supabase → SQL Editor → New query → Run aus.
-- Damit funktionieren Speichern, Freigeben, Löschen und Foto-Moderation.
--
-- Hintergrund: Der Admin dieser App meldet sich nur client-seitig an.
-- Supabase unterscheidet ihn nicht von einem normalen Besucher (beide sind "anon").
-- Die RLS-Regeln müssen deshalb anon die nötigen Schreibrechte geben.

-- ───── Tabelle: eintraege ─────

drop policy if exists "submit pending"  on public.eintraege;
drop policy if exists "admin all"       on public.eintraege;
drop policy if exists "anon insert"     on public.eintraege;
drop policy if exists "anon update"     on public.eintraege;
drop policy if exists "anon delete"     on public.eintraege;

-- Lesen: nur freigegebene Einträge (bleibt eingeschränkt)
drop policy if exists "read approved"   on public.eintraege;
create policy "read approved" on public.eintraege
  for select to anon using (approved = true);

-- Schreiben: anon darf alles (Moderation erfolgt in der App, nicht per RLS)
create policy "anon insert" on public.eintraege
  for insert to anon with check (true);

create policy "anon update" on public.eintraege
  for update to anon using (true) with check (true);

create policy "anon delete" on public.eintraege
  for delete to anon using (true);

-- ───── Tabelle: foto_vorschlaege ─────

drop policy if exists "foto submit"     on public.foto_vorschlaege;
drop policy if exists "foto admin"      on public.foto_vorschlaege;
drop policy if exists "foto read"       on public.foto_vorschlaege;
drop policy if exists "foto update"     on public.foto_vorschlaege;
drop policy if exists "foto delete"     on public.foto_vorschlaege;

-- Admin muss alle (auch nicht freigegebene) Foto-Vorschläge sehen können
create policy "foto read" on public.foto_vorschlaege
  for select to anon using (true);

create policy "foto submit" on public.foto_vorschlaege
  for insert to anon with check (true);

create policy "foto update" on public.foto_vorschlaege
  for update to anon using (true) with check (true);

create policy "foto delete" on public.foto_vorschlaege
  for delete to anon using (true);
