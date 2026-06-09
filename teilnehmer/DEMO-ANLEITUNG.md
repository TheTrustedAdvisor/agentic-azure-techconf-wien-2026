# Demo-Anleitung — Schritt für Schritt selber bauen

> Du baust dieselbe Azure-Architektur wie im Workshop — Stufe für Stufe. Eingabe ist immer
> [`../AUSGANGSLAGE.md`](../AUSGANGSLAGE.md) (Helvetia MedTech, nur Requirements + Parametrisierung).

## Voraussetzungen
- **Claude Code** installiert (`claude --version`) — Installation (macOS/Linux/WSL) siehe [RESSOURCEN.md](RESSOURCEN.md) → Claude Code
- ein **Anthropic-Login** (für `claude`)
- **für Stufen 5–8:** das **oh-my-claudecode (OMC)**-Plugin im *normalen* `~/.claude` installiert (liefert die OMC-Agents) — im Workshop vorinstalliert; beim Selbstbau siehe [RESSOURCEN.md](RESSOURCEN.md)
- *optional, nur Stufe 7–8 gegen echtes Azure:* Azure-Subscription + `az login` (nur für `what-if` nötig; `terraform validate` läuft offline)

### Windows? → WSL2 verwenden (empfohlen)
Das Lab nutzt Bash-Skripte (`setup.sh`, `run.sh`). Unter Windows läuft das am saubersten in **WSL2**
(Windows-Subsystem für Linux) — keine PowerShell-Portierung nötig, alles ist „wie auf Linux".

```powershell
# 1) In PowerShell ALS ADMINISTRATOR, danach Neustart:
wsl --install            # installiert WSL2 + Ubuntu
```
Danach den **Rechner neu starten** — beim ersten Start öffnet sich Ubuntu automatisch und legt den Linux-User an.
```bash
# 2) Ubuntu starten (Startmenü → "Ubuntu"), Linux-User anlegen, dann:
sudo apt update && sudo apt install -y git
# 3) Claude Code in WSL installieren (siehe RESSOURCEN.md → Claude Code)
# 4) WICHTIG: ins Linux-Home klonen, NICHT nach /mnt/c/...
cd ~
```
> **Warum im Linux-Home (`~`) und nicht unter `/mnt/c/`?** Im Windows-Dateisystem ist WSL deutlich
> langsamer, und Skript-Rechte/Zeilenenden (CRLF) machen Ärger. Im Linux-Home läuft alles glatt.
> Ab hier sind alle Befehle unten **identisch** zu macOS/Linux.

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

> **Ab Stufe 5** nutzt `run.sh` dein **normales** Claude-Config (kein Isolations-Override), damit die **OMC-Agents** verfügbar sind. `run.sh` installiert nichts — es setzt nur kein `CLAUDE_CONFIG_DIR`. **Voraussetzung:** oh-my-claudecode ist in `~/.claude` installiert (siehe Voraussetzungen).

## Tipps & Stolpersteine
- **Stufe 2:** beim ersten Start fragt Claude, ob dem Projekt-MCP `microsoft-learn` vertraut wird → bestätigen.
- **Stufe 8:** immer mit `/oh-my-claudecode:cancel` sauber beenden.
- **In der Schleife nie `apply`** — nur `validate`/`what-if`. Autonomie braucht Grenzen.
- **Kosten:** Stufen 5–8 (Multi-Agent, ralph-Schleifen) verbrauchen spürbar API-Tokens — bei knappem Budget genügt eine Iteration.
- **Reset:** lösche `.claude-demo/` und führe `./setup.sh` erneut aus.
- Jede Stufe ist eigenständig lauffähig — du musst nicht alle der Reihe nach machen.

## Wenn ein Prompt nicht zündet
Fertige Copy-Paste-Vorlagen je Stufe stehen im [`PROMPTING-GUIDE.md`](PROMPTING-GUIDE.md).
Stolpersteine (Setup, MCP-Freigabe, ralph beenden) im [`TROUBLESHOOTING.md`](TROUBLESHOOTING.md).

## Die Leitfrage bei jeder Aufgabe
**Welche Stufe verlangt diese Aufgabe wirklich?** Meistens reicht 2–3. Steig nur auf, wenn die Aufgabe offen, mehrstufig und prüfintensiv ist.
