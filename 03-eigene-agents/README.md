# Stufe 3 — Eigene Agents (selbst geschrieben)

**Methode:** Unser erster eigener Subagent — von Hand geschrieben, so wie am Anfang üblich.

Der Agent liegt projektlokal in [`.claude/agents/azure-helfer.md`](.claude/agents/azure-helfer.md) und ist eine **bewusst schwache** Definition: vage `description`, kein klarer Auftrag, keine Tools, kein Output-Format, kein Bezug zur Ausgangslage.

## Ausführen

```bash
cd 03-eigene-agents && ./run.sh
```

Claude lädt den Subagent aus `.claude/agents/` automatisch (Arbeitsverzeichnis = dieser Ordner). Dann z. B.:

```
@azure-helfer entwirf die Netzwerk-Architektur aus ../AUSGANGSLAGE.md
```

Ergebnis hängt komplett an der Definition — die ist schwammig, also wird das Resultat beliebig. Das motiviert Stufe 4: **die Definition vom LLM schreiben lassen** und vergleichen.
