-- Schreibrecht für die App freischalten (Direkt-Speichern ohne Login).
-- ACHTUNG: Damit darf JEDER Besucher der Seite Einträge anlegen/ändern.
-- Nur ausführen, wenn die Seite privat/unbekannt bleibt.
-- In Supabase: SQL Editor -> New query -> einfügen -> Run.

drop policy if exists "anon insert" on public.eintraege;
create policy "anon insert" on public.eintraege
  for insert to anon with check (true);

drop policy if exists "anon update" on public.eintraege;
create policy "anon update" on public.eintraege
  for update to anon using (true) with check (true);

-- (Löschen bleibt absichtlich gesperrt.)
