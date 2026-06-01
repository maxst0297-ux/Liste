# Hosting-Anleitung: Vercel + Supabase

Die App (`index.html`) läuft **sofort** auch ohne Supabase mit eingebetteten Daten.
Mit Supabase kannst du die ~2149 Einträge in der Datenbank pflegen, **ohne Code-Push**.

## Teil A – Supabase einrichten (Datenbank)

1. Öffne dein Supabase-Projekt → links **SQL Editor** → **New query**.
2. Inhalt von **`supabase/setup.sql`** einfügen → **Run** (legt Tabelle `eintraege` + Leserecht an).
3. Daten importieren – nacheinander je eine neue Query:
   - **`supabase/data_1.sql`** einfügen → Run
   - **`supabase/data_2.sql`** einfügen → Run
   - **`supabase/data_3.sql`** einfügen → Run
   (Danach hat die Tabelle 2149 Zeilen – prüfbar unter **Table Editor → eintraege**.)
4. Schlüssel kopieren: **Project Settings → API**:
   - **Project URL** (z. B. `https://abcd.supabase.co`)
   - **anon public** key (langer `eyJ...`-String) – dieser ist *öffentlich*, kein Geheimnis.

## Teil B – Schlüssel in die App eintragen

In `index.html` ganz oben im `<script>` die zwei Zeilen ausfüllen:

```js
const SUPABASE_URL = 'https://abcd.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOi...';
```

Speichern, committen, pushen. Im Profil der App steht dann „Datenquelle: **Supabase**“.

## Teil C – Auf Vercel veröffentlichen

1. vercel.com → **Add New… → Project** → dein GitHub-Repo importieren.
2. Framework Preset: **Other** (kein Build nötig – statische Seite).
3. **Deploy**. Vercel liefert `index.html` automatisch aus.
4. Fertig – du bekommst eine URL wie `https://dein-projekt.vercel.app`.

> Bei jeder Änderung in der Supabase-Tabelle siehst du die neuen Daten nach **Neuladen** der Seite –
> ohne neuen Deploy. Code-Änderungen (Layout etc.) erfordern wie üblich einen Git-Push (Vercel
> deployt dann automatisch neu).

## Hinweise
- Der **anon-Key** gehört in den Client-Code; durch Row Level Security ist nur **Lesen** erlaubt.
- Schreiben/Ändern geht aktuell **nur** im Supabase-Table-Editor (kein Schreibzugriff aus der App).
