# Stufe 2 — MCP-Server (Grounding)

**Methode:** Claude + **genau ein** MCP-Server (Microsoft Learn), keine Plugins.

Der MCP-Server ist projektlokal in [`.mcp.json`](.mcp.json) definiert — er lädt automatisch, weil `run.sh` Claude *in diesem Ordner* startet.

## Ausführen

```bash
cd 02-mcp && ./run.sh
```

Beim ersten Start fragt Claude, ob der Projekt-MCP-Server `microsoft-learn` vertraut werden soll → bestätigen. Verifizieren: `/mcp` zeigt `microsoft-learn ✓`.

**Ablauf:** Prompt aus [`PROMPT.md`](PROMPT.md) einfügen. Das Modell erdet den Stufe-1-Entwurf an echter Microsoft-Doku (exakte Private-DNS-Zonen inkl. Fabric, SKU-/Regions-Verfügbarkeit, Region-Pairing) — Wissen statt Behauptung.
