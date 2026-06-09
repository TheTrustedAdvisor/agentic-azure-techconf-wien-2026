# Demo-Anleitung — Schritt für Schritt selber bauen

> Du baust dieselbe Azure-Architektur wie im Workshop — Stufe für Stufe. Eingabe ist immer
> [`../AUSGANGSLAGE.md`](../AUSGANGSLAGE.md) (Helvetia MedTech, nur Requirements + Parametrisierung).

## Voraussetzungen
- **Claude Code** installiert (`claude --version`)
- **uv** (`pip install uv`) — für die optionalen Python-Demos nicht nötig, schadet aber nicht
- ein **Anthropic-Login** (für `claude`)
- *optional, nur Stufe 7–8 gegen echtes Azure:* Azure-Subscription + `az login`

## Einmal: Setup
```bash
git clone https://github.com/TheTrustedAdvisor/agentic-azure-techconf-wien-2026
cd agentic-azure-techconf-wien-2026
./setup.sh        # legt isoliertes .claude-demo/ an (kein Plugin) + einmal einloggen
```
> Warum isoliert? Stufen 1–4 sollen ein „nacktes" Claude zeigen — ohne Plugins, ohne fremde MCP-Server.

## Stufe für Stufe

| Stufe | `cd … && ./run.sh` | Was tun | Was du siehst |
|------|--------------------|---------|----------------|
| **1 Chat** | `01-chat` | Prompt aus `PROMPT.md` + Ausgangslage einfügen | Architektur-Entwurf — plausibel, aber **ungeprüft** |
| **2 MCP** | `02-mcp` | Projekt-MCP `microsoft-learn` freigeben, Prompt einfügen | Fakten **belegt** (DNS-Zonen, SKUs, Regionen) |
| **3 Eigene Agents** | `03-eigene-agents` | `@azure-helfer …` aufrufen | absichtlich **beliebiges** Ergebnis (vage Definition) |
| **4 LLM schreibt Agents** | `04-llm-agents` | Prompt: Definition schärfen lassen | eine **scharfe** Agent-Definition entsteht |
| **5 OMC-Agents** | `05-omc-agents` | `analyst → architect → executor` nutzen | erprobte **Rollen-Pipeline** |
| **6 Critics** | `06-critics` | `critic` + `security-reviewer` prüfen lassen | findet **Design-Schwächen** (z. B. CIDR-Overlap) |
| **7 Plan + Umsetzung** | `07-plan-umsetzung` | `planner → executor`, dann `terraform validate` | **IaC + objektive Validierung** |
| **8 ralplan + ralph** | `08-ralplan-ralph` | `/oh-my-claudecode:ralplan …` → `ralph` | beschränkte Schleife konvergiert bis **„grün"**, dann `cancel` |

> **Ab Stufe 5** braucht `run.sh` das **normale** Claude-Config (oh-my-claudecode-Plugin aktiv) — das macht das Skript automatisch.

## Tipps & Stolpersteine
- **Stufe 2:** beim ersten Start fragt Claude, ob dem Projekt-MCP `microsoft-learn` vertraut wird → bestätigen.
- **Stufe 8:** immer mit `/oh-my-claudecode:cancel` sauber beenden.
- **In der Schleife nie `apply`** — nur `validate`/`what-if`. Autonomie braucht Grenzen.
- **Reset:** lösche `.claude-demo/` und führe `./setup.sh` erneut aus.
- Jede Stufe ist eigenständig lauffähig — du musst nicht alle der Reihe nach machen.

## Die Leitfrage bei jeder Aufgabe
**Welche Stufe verlangt diese Aufgabe wirklich?** Meistens reicht 2–3. Steig nur auf, wenn die Aufgabe offen, mehrstufig und prüfintensiv ist.
