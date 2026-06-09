# Stufe 6 — Critics: Invocation

Den Architektur-Entwurf adversarial prüfen lassen und die Funde einarbeiten.

---

```text
Lass die Architektur (Stand aus Stufe 5) adversarial prüfen:

1. oh-my-claudecode:critic — strukturierte, mehrperspektivische Review: CIDR-Overlaps /
   Subnetz-Sizing, Zero-Trust (NFR-07), Data-Residency (NFR-08), Hub-Spoke vs. vWAN,
   DR-Mechanismen, NFR-Abdeckung gesamt. Severity-bewertet.
2. oh-my-claudecode:security-reviewer — öffentliche Endpunkte, Egress-Kontrolle,
   Identitäts-/Secrets-Pfade.

Fasse die bestätigten Findings priorisiert zusammen und arbeite die kritischen direkt
in die Architektur ein. Zeige, was sich geändert hat.
```

> Fähigkeitssprung: Ein zweiter, unabhängiger Blick fängt, was die Generierung übersah — z. B. einen CIDR-Overlap. Das ist der Wert, nicht die erste Fassung.
