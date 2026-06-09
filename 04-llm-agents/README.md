# Stufe 4 — Agents vom LLM schreiben lassen

**Methode:** isoliertes Claude (wie Stufe 1–3, kein Plugin). Statt die Agent-Definition von Hand zu schreiben, lässt man sie das Modell schreiben.

## Ausführen

```bash
cd 04-llm-agents && ./run.sh
```

Prompt aus [`PROMPT.md`](PROMPT.md) einfügen (mit dem Inhalt der schwachen Definition aus [`../03-eigene-agents/.claude/agents/azure-helfer.md`](../03-eigene-agents/.claude/agents/azure-helfer.md)). Claude erzeugt eine geschärfte `.claude/agents/azure-network-architect.md` — klare Rolle, Tools, Output-Format, Bezug zur Ausgangslage. Direkt vergleichen mit Stufe 3.
