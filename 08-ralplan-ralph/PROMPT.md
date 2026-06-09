# Stufe 8 — ralplan + ralph: Invocation

Beschränkte autonome Konvergenz: erst planen (ralplan), dann eine begrenzte Schleife laufen lassen (ralph), bis die Validierung grün ist.

---

**Schritt 1 — Plan (ralplan):**
```text
/oh-my-claudecode:ralplan Vollständige, validierte IaC für die Azure-Netzwerk-Architektur
aus ../AUSGANGSLAGE.md (Hub + Spokes WEU, Konnektivität, Private DNS, Governance).
Definition of Done: terraform validate grün, kein CIDR-Overlap, alle Pflicht-Tags gesetzt,
keine öffentlichen Datenendpunkte.
```

**Schritt 2 — Autonome Schleife (ralph):**
```text
/oh-my-claudecode:ralph
```
ralph arbeitet den Plan ab, validiert nach jeder Runde und konvergiert — **beschränkt** durch
Iterations-Limit und Stopp-Bedingung (Definition of Done). Beenden mit
`/oh-my-claudecode:cancel`.

> Fähigkeitssprung & ehrlicher Abschluss: Autonomie mit Plan, Limit und objektivem Abbruch-
> kriterium — produktiv genau das Pattern, mit dem solche Architekturen iterativ fertig werden.
