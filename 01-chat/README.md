# Stufe 1 — Chat

**Methode:** Claude pur, ohne Tools, ohne Plugins.

## Ausführen

```bash
# einmalig im Repo-Root (isoliertes Config + Login):
./setup.sh
# dann:
cd 01-chat && ./run.sh
```

`run.sh` startet Claude mit dem isolierten Config (`.claude-demo/` im Repo-Root) und diesem Ordner als Arbeitsverzeichnis. Verifizieren: `/mcp` (leer) · `/plugin` (leer).

**Ablauf:** Prompt aus [`PROMPT.md`](PROMPT.md) + Inhalt von [`../AUSGANGSLAGE.md`](../AUSGANGSLAGE.md) einfügen. Claude entwirft die Architektur allein aus dem Modellgewicht.
