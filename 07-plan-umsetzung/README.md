# Stufe 7 — Plan + Umsetzung

**Methode:** normales Config (OMC aktiv). Strukturiert planen (planner), dann umsetzen (executor) — mit **objektiver Validierung** (`terraform validate` / `what-if` / CIDR-Check) statt nur Prosa.

## Ausführen

```bash
cd 07-plan-umsetzung && ./run.sh
```

Prompt aus [`PROMPT.md`](PROMPT.md). Ergebnis: ein Plan + IaC-Skelett (Bicep/Terraform) für ein Architektur-Segment, das gegen ein objektives Tool grün läuft.

**Fähigkeitssprung:** aus „Architektur als Text" wird **überprüfbare Umsetzung** — das Validierungs-Tool kann verbindlich „falsch" sagen.
