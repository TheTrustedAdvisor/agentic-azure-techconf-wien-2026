# Troubleshooting — wenn's klemmt

> Die wahrscheinlichsten Stolpersteine, nach Stelle sortiert. Erst hier schauen, dann fragen.

## Setup

**`./setup.sh` bricht beim Login ab**
Claude braucht einen einmaligen Login. Führe den Login-Schritt aus, den das Skript nennt,
und starte `./setup.sh` erneut. Das Setup ist **idempotent** — mehrfach ausführen schadet nicht.

**„command not found: claude"**
Claude Code ist nicht installiert oder nicht im PATH. Prüfe mit `claude --version`.
Installationsanleitung: siehe [RESSOURCEN.md](RESSOURCEN.md) → Claude Code.

**Ich will einen sauberen Neustart**
Lösche das isolierte Verzeichnis `.claude-demo/` und führe `./setup.sh` erneut aus.
Dein normales Claude-Config (`~/.claude`) bleibt davon unberührt — genau dafür ist die Isolation da.

## Stufen 1–4 (isoliert, ohne Plugin)

**Stufe 1 zeigt erfundene DNS-Zonen / SKUs**
Das ist **so gewollt**. Ohne MCP rät das Modell. Genau das motiviert Stufe 2.

**Stufe 2: Claude fragt, ob es dem MCP `microsoft-learn` vertrauen soll**
Beim ersten Start normal — **bestätigen**. Der Host gibt jeden Server einzeln frei (Trust-Boundary).

**Stufe 2: MCP liefert nichts / Timeout**
Netzwerk prüfen (der MCP ist remote). Bei Firmen-Proxy kann der Zugriff blockiert sein —
dann die Stufe später mit offenem Netz wiederholen.

**Stufe 3: `@azure-helfer` gibt beliebigen Output**
Erwartetes Verhalten — die Agent-Definition ist **absichtlich vage**. Die Lektion ist Stufe 4.

## Stufen 5–8 (normales Config, OMC-Agents)

**Ab Stufe 5: „Agent/Skill nicht gefunden"**
Diese Stufen brauchen das **normale** Claude-Config mit Plugin — `run.sh` schaltet automatisch um.
Wenn du manuell startest: nicht im isolierten `.claude-demo/` laufen lassen.

**Stufe 7/8: Terraform**
In der Schleife **nie `apply`** — nur `terraform validate` bzw. `what-if`/`az deployment ... what-if`.
Autonomie braucht Grenzen; Schreiben gehört nicht in eine selbstlaufende Schleife.

**Stufe 8: ralph hört nicht auf**
Das ist der Test der Guardrails. Beende sauber mit:
```
/oh-my-claudecode:cancel
```
Wenn das nicht greift: `/oh-my-claudecode:cancel --force`.

**Versehentlich ralph/ultrawork ausgelöst (Stichwort getriggert)**
Manche Schlüsselwörter starten einen Modus. Einfach `/oh-my-claudecode:cancel` — beendet den aktiven Modus.

## Mermaid / Diagramme (falls du sie selbst renderst)

**`mmdc` schlägt mit Sandbox-Fehler fehl**
Puppeteer braucht in manchen Umgebungen `--no-sandbox`. Lege `/tmp/pptr.json` an:
```json
{"args":["--no-sandbox"]}
```
und rufe `mmdc -p /tmp/pptr.json …` auf.

**Sequenzdiagramm parst nicht**
Vorsicht mit Teilnehmer-IDs, die **Schlüsselwörter** sind (`loop`, `alt`, `end`). Benenne sie um
(z. B. `Ag` statt `Loop`).

## Git / Repo

**Push abgelehnt („diverged")**
Während des Workshops arbeiten evtl. mehrere am Repo. `git fetch origin` → `git rebase origin/main`
→ erneut pushen. Vorher `git status -sb` zeigt die Divergenz früh.

## Die Grundregel bei jedem Stocken

> Frag dich: **verlangt die Aufgabe diese Stufe wirklich?** Oft hängt man fest, weil man eine
> Stufe zu hoch gebaut hat. Eine Stufe runter ist häufig die Lösung, nicht eine weitere hoch.
