# Stufe 6 — Mit Critics iterieren

**Methode:** normales Config (OMC aktiv). Der Entwurf wird von unabhängigen Critic-Agents adversarial geprüft und die Funde eingearbeitet.

## Ausführen

```bash
cd 06-critics && ./run.sh
```

Prompt aus [`PROMPT.md`](PROMPT.md) — `oh-my-claudecode:critic` (+ `security-reviewer`) prüfen Topologie, CIDR-Konsistenz, Zero-Trust, Residency, NFR-Abdeckung; die kritischen Findings werden direkt eingearbeitet.

**Fähigkeitssprung:** ein zweiter, unabhängiger Blick fängt Fehler, die in der ersten Generierung plausibel mitliefen.
