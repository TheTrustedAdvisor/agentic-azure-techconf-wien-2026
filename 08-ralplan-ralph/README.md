# Stufe 8 — ralplan + ralph

**Methode:** normales Config (OMC aktiv). Erst planen (`ralplan`), dann eine **beschränkte** autonome Schleife (`ralph`), die bis zur Definition of Done konvergiert.

## Ausführen

```bash
cd 08-ralplan-ralph && ./run.sh
```

Ablauf aus [`PROMPT.md`](PROMPT.md): `/oh-my-claudecode:ralplan <Ziel + Definition of Done>` → `/oh-my-claudecode:ralph` → mit `/oh-my-claudecode:cancel` beenden.

**Ehrlicher Abschluss der Leiter:** Autonomie mit Plan, Iterations-Limit und objektivem Abbruchkriterium — das Pattern, mit dem so eine Architektur iterativ wirklich fertig wird.
