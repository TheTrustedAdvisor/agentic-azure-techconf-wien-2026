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

## Struktur

```
AUSGANGSLAGE.md        # der Input
01-chat/               # Stufe 1: Prompt + Launch (Claude pur)
02-mcp/                # Stufe 2: MS-Learn-MCP + Prompt
03-eigene-agents/      # Stufe 3: handgeschriebene Agent-Definition
…                      # Stufen 4–8 folgen
archive/               # frühere Demo-Iteration (Referenz)
```

Jede Stufe enthält das **Setup zum Live-Fahren** (Prompt, Konfig, Agent-Code) — die Architektur
wird live erzeugt, nicht vorgebacken.
