# Cheatsheet — Agentic Architecture (From Chat to ralph)

> Eine Seite zum Mitnehmen. Workshop Techconference Wien 2026 · Matthias Falland (MVP).

## Die 8 Methoden-Stufen

| # | Methode | Wofür | Befehl |
|---|---------|-------|--------|
| 1 | **Chat** | schneller Entwurf, kein Live-Wissen | `cd 01-chat && ./run.sh` |
| 2 | **MCP** | echte Doku statt Raten *(viele Aufgaben enden hier)* | `cd 02-mcp && ./run.sh` |
| 3 | **Eigene Agents** | erste Rolle (bewusst schwach) | `cd 03-eigene-agents && ./run.sh` |
| 4 | **LLM schreibt Agents** | Definition schärfen lassen | `cd 04-llm-agents && ./run.sh` |
| 5 | **OMC-Agents** | ein Agent → Rollen-Pipeline | `cd 05-omc-agents && ./run.sh` |
| 6 | **Critics** | unabhängige Prüfung | `cd 06-critics && ./run.sh` |
| 7 | **Plan + Umsetzung** | IaC + objektive Validierung | `cd 07-plan-umsetzung && ./run.sh` |
| 8 | **ralplan + ralph** | beschränkte Autonomie bis „grün" | `cd 08-ralplan-ralph && ./run.sh` |

## Die Regel
**Nimm die einfachste Stufe, die die Aufgabe verlangt.** Höher ist nicht besser — höher ist *anders und teurer*.
- Schrittfolge steht fest → **gar kein Agent** (Skript/IaC).
- Eine klare Datenfrage → Stufe 2.
- Offen + Rollen + Prüfung → Stufe 5–6.
- Offenes Ziel + objektives Kriterium → Stufe 7–8 (mit Limits).

## Konzepte in einem Satz
- **LLM** — sagt das nächste Token voraus; plausibel ≠ korrekt; kein Live-Wissen/Gedächtnis.
- **Kontext** — Modell ist zustandslos; ganze History pro Aufruf → Tokens wachsen.
- **Tool/ACI** — das Modell *bittet* (`tool_use`), der **Host** führt aus; gute Beschreibung ist der wichtigste Faktor.
- **MCP** — offener Standard (Tools/Resources/Prompts via JSON-RPC); Host setzt die Trust-Boundary.
- **Agent** — LLM + Tools + Schleife (`tool_use` → `end_turn`); Fehler = Eingabe, nicht Absturz.
- **Multi-Agent** — Orchestrator (Code) zerlegt dynamisch, frische Kontexte, **Verifier ≠ Autor**.
- **Verifizierung** — Qualität *messen* (grün/rot), nicht behaupten; gegen Fakten-Halluzination hilft nur ein Check **außerhalb** des LLM.
- **Autonomie** — Plan + beschränkte Schleife; Pflicht: Limit, Stopp-Bedingung, Sandbox, nur `validate`.

## Setup (2 Minuten)
```bash
git clone https://github.com/TheTrustedAdvisor/agentic-azure-techconf-wien-2026
cd agentic-azure-techconf-wien-2026
./setup.sh            # einmal: isoliertes Config + Login
```
Stufen 1–4 laufen plugin-frei isoliert; Stufen 5–8 nutzen das normale Config (OMC-Agents).

## Mehr in diesem Ordner
- [`PROMPTING-GUIDE.md`](PROMPTING-GUIDE.md) — Copy-Paste-Prompts je Stufe (wenn ein Prompt nicht zündet)
- [`GLOSSAR.md`](GLOSSAR.md) — jeder Begriff in 2–3 Sätzen
- [`RESSOURCEN.md`](RESSOURCEN.md) — kuratierte Links · [`TROUBLESHOOTING.md`](TROUBLESHOOTING.md) — wenn's klemmt

## Links
- Repo: github.com/TheTrustedAdvisor/agentic-azure-techconf-wien-2026
- Anthropic — *Building Effective Agents* (die Pattern-Grundlage)
- @TheTrustedAdvisor (YouTube · Fabric Friday) · copilot-cockpit.com
