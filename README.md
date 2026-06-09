# Agentic Architecture — From Chat to ralph

> Workshop für die **Techconference Wien 2026**.
> Wir entwerfen aus einer realen Ausgangslage eine vollständige **Enterprise-Azure-Netzwerk-
> Architektur** — Stufe für Stufe mit zunehmend fähigen agentischen Methoden.
>
> **Speaker:** Matthias Falland — Microsoft Data Platform MVP · Sprache: Deutsch · Level 200–300

## Idee

Eine Architektur zu entwerfen ist eine offene, mehrstufige Aufgabe mit Urteil unter Unsicherheit —
genau dort verdient sich agentische Arbeit ihren Platz. Statt eines Spielzeug-Tasks bauen wir etwas
Echtes und zeigen die **Reifegrad-Leiter der Methoden**, mit der man dorthin kommt.

## Die Leiter (8 Stufen)

| # | Stufe | Methode |
|---|-------|---------|
| 1 | **Chat** | Claude pur, ohne Tools |
| 2 | **MCP-Server** | + Microsoft-Learn-MCP (Live-Fakten statt Raten) |
| 3 | **Eigene Agents** | erste, von Hand geschriebene Agent-Definition |
| 4 | **LLM schreibt Agents** | die Definition vom Modell schärfen lassen |
| 5 | **OMC-Agents** | vordefinierte Rollen (planner/architect/critic/executor) |
| 6 | **Critics** | adversariale Iteration |
| 7 | **Plan + Umsetzung** | strukturiert planen, dann umsetzen |
| 8 | **ralplan + ralph** | beschränkte autonome Konvergenz |

## Ausgangspunkt

[`AUSGANGSLAGE.md`](AUSGANGSLAGE.md) — die *fiktive* Enterprise-Plattform (Helvetia MedTech Group AG):
nur Requirements (business / technical / non-functional) und Parametrisierung (IP-Ranges, Regionen,
Namens-/Tagging-Konventionen, Fabric-Capacity). Bewusst **lösungsfrei** — die Architektur entsteht im Workshop.

## So fährst du es

```bash
./setup.sh                      # einmalig: isoliertes Claude-Config + Login
cd 01-chat && ./run.sh          # dann jede Stufe in ihrem Ordner
```

Jede Stufe ist ein eigener Ordner mit `run.sh` und allem Kontext (Prompt, MCP-Konfig, Agent).
Die Architektur entsteht **live**, nichts ist vorgebacken.

## Struktur

```
setup.sh               # einmalig: isoliertes .claude-demo/ (kein Plugin) + Login
AUSGANGSLAGE.md        # der Input
01-chat/               # Stufe 1: Claude pur                    (isoliert)
02-mcp/                # Stufe 2: + MS-Learn-MCP (.mcp.json)    (isoliert)
03-eigene-agents/      # Stufe 3: handgeschriebene Agent-Def.   (isoliert)
04-llm-agents/         # Stufe 4: Agent vom LLM schreiben       (isoliert)
05-omc-agents/         # Stufe 5: vordefinierte OMC-Agents      (normales Config)
06-critics/            # Stufe 6: Critic-Iteration              (normales Config)
07-plan-umsetzung/     # Stufe 7: Plan + IaC + Validierung      (normales Config)
08-ralplan-ralph/      # Stufe 8: beschränkte Autonomie         (normales Config)
```

**Config:** Stufen 1–4 laufen im isolierten `.claude-demo/` (kein Plugin, kein globales MCP —
sauberer Ausgangspunkt). Ab Stufe 5 nutzt `run.sh` das **normale** Config, damit die
oh-my-claudecode-Agents/Skills verfügbar sind.
