# Hosting-Anleitung: Vercel + Supabase

Die App (`index.html`) läuft **sofort** auch ohne Supabase mit eingebetteten Daten.
Mit Supabase kannst du die ~2149 Einträge in der Datenbank pflegen, **ohne Code-Push**.

> **Wichtig: eigenes, getrenntes Projekt!**
> Du hast bereits ein Projekt bei Supabase und Vercel. Für diese App legst du auf **beiden**
> Diensten ein **NEUES, eigenes Projekt** an. Dein bestehendes Projekt wird dadurch nicht
> berührt – jedes Projekt hat eigene URL/Schlüssel (Supabase) bzw. ist an ein eigenes Repo
> gebunden (Vercel).

## Teil A – Supabase einrichten (eigene, neue Datenbank)

1. Supabase-Dashboard → **New project** → Name z. B. „rechtsampel“ / „datenbank“, Region wählen,
   DB-Passwort setzen → **Create**. (NICHT dein bestehendes Projekt verwenden.)
   - Hinweis: Der kostenlose Tarif erlaubt meist **2 aktive Projekte** pro Organisation.
2. In **diesem neuen Projekt**: links **SQL Editor** → **New query**.
3. Inhalt von **`supabase/setup.sql`** einfügen → **Run** (legt Tabelle `eintraege` + Leserecht an).
4. Daten importieren – **eine** Query:
   - **`supabase/data.sql`** einfügen → **Run** (kompakt, ~224 KB, ~2149 Einträge in einem Schritt).
   (Danach hat die Tabelle 2149 Zeilen – prüfbar unter **Table Editor → eintraege**.)
5. Schlüssel **dieses neuen Projekts** kopieren: **Project Settings → API**:
   - **Project URL** (z. B. `https://abcd.supabase.co`)
   - **anon public** key (langer `eyJ...`-String) – dieser ist *öffentlich*, kein Geheimnis.
   - Achte darauf, dass oben das **neue** Projekt ausgewählt ist (nicht dein altes).

## Teil B – Schlüssel in die App eintragen

In `index.html` ganz oben im `<script>` die zwei Zeilen mit den Werten des **neuen** Projekts ausfüllen:

```js
const SUPABASE_URL = 'https://abcd.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOi...';
```

Speichern, committen, pushen. Im Profil der App steht dann „Datenquelle: **Supabase**“.

## Teil C – Auf Vercel veröffentlichen (eigenes, neues Projekt)

1. vercel.com → **Add New… → Project**.
2. Importiere das Repo **`Liste`** (`github.com/maxst0297-ux/Liste`) – also NICHT das Repo
   deines bestehenden Vercel-Projekts. Dadurch entsteht automatisch ein **separates** Vercel-Projekt.
3. Framework Preset: **Other** (kein Build nötig – statische Seite).
4. **Deploy**. Vercel liefert `index.html` automatisch aus.
5. Fertig – du bekommst eine eigene URL wie `https://dein-neues-projekt.vercel.app`.

> Bei jeder Änderung in der Supabase-Tabelle siehst du die neuen Daten nach **Neuladen** der Seite –
> ohne neuen Deploy. Code-Änderungen (Layout etc.) erfordern wie üblich einen Git-Push (Vercel
> deployt dann automatisch neu).

## Hinweise
- Alles läuft in **eigenen, getrennten Projekten** – dein bestehendes Supabase-/Vercel-Projekt bleibt unberührt.
- Der **anon-Key** gehört in den Client-Code; durch Row Level Security ist nur **Lesen** erlaubt.
- Schreiben/Ändern geht aktuell **nur** im Supabase-Table-Editor (kein Schreibzugriff aus der App).
