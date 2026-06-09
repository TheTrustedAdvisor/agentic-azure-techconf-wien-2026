# Stufe 5 — Vordefinierte OMC-Agents

**Methode:** **normales** Claude-Config (oh-my-claudecode-Plugin aktiv) — daher kein `CLAUDE_CONFIG_DIR`-Override in `run.sh`. Statt eigene Agents zu schreiben, nutzen wir erprobte Rollen.

## Ausführen

```bash
cd 05-omc-agents && ./run.sh
```

Prüfen, dass die Agents da sind: `/agents` (z. B. `oh-my-claudecode:analyst`, `architect`, `executor`, `critic`, `code-reviewer`, `planner`). Dann Prompt aus [`PROMPT.md`](PROMPT.md).

**Fähigkeitssprung:** wartbare Rollen von der Stange mit passendem Modell-Routing (Opus für Architektur/Analyse), statt jede Definition selbst zu pflegen.
