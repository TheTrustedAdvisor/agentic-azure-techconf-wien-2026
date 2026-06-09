# Stufe 4 — LLM schreibt den Agent: Prompt

Statt die Definition von Hand zu schreiben (Stufe 3), lassen wir sie das Modell schreiben.

---

```text
Hier ist eine schwache, von Hand geschriebene Subagent-Definition:

--- BISHER (../03-eigene-agents/.claude/agents/azure-helfer.md) ---
[Inhalt einfügen]
---

Schreibe daraus eine professionelle Claude-Code-Subagent-Definition für einen
"azure-network-architect". Anforderungen:
- scharfe `description` (genau wann dieser Agent zu nutzen ist, wann nicht)
- klare Rolle + schrittweises Vorgehen (Requirements lesen → Adressplan → Topologie →
  Konnektivität → Private DNS → Ingress → Workloads → Governance)
- explizit deklarierte Tools (nur die nötigen)
- verbindliches Output-Format (Markdown-Architektur-Doc + Mermaid-Topologie)
- Bezug zur ../AUSGANGSLAGE.md und strikte Einhaltung der Parametrisierung
  (IP-Ranges, Regionen, Namens-/Tagging-Konventionen)
- Leitplanken (keine erfundenen Fakten; Annahmen kennzeichnen)

Lege die fertige Definition unter .claude/agents/azure-network-architect.md an
und erkläre kurz, was du gegenüber der schwachen Version verbessert hast.
```

> Fähigkeitssprung: Der gleiche Agent-Mechanismus wie Stufe 3 — aber die *Definition* ist jetzt vom Modell geschärft (klare Rolle, Tools, Output), statt vage von Hand.
