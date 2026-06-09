# Stufe 7 — Plan + Umsetzung: Invocation

Erst strukturiert planen, dann umsetzen — mit objektiver Validierung statt nur Text.

---

```text
Setze ein Architektur-Segment als Infrastruktur-Code um (z. B. Hub-VNet + Subnetze +
Private-DNS-Zonen aus dem geprüften Entwurf):

1. oh-my-claudecode:planner — erstelle einen expliziten Umsetzungsplan (Schritte,
   Dateien, Reihenfolge, Validierungskriterien).
2. oh-my-claudecode:executor — setze den Plan um: Bicep- oder Terraform-Skelett, das die
   Parametrisierung aus ../AUSGANGSLAGE.md verwendet (IP-Ranges, Regionen, Namen, Tags).
3. Validiere objektiv — nicht „sieht gut aus", sondern:
     terraform validate   (oder: az deployment ... what-if  /  bicep build)
   plus ein CIDR-Overlap-Check über alle definierten Subnetze.

Iteriere, bis die Validierung grün ist. Zeige Plan, Code und Validierungs-Output.
```

> Fähigkeitssprung: Plan-zuerst reduziert Fehlläufe; und ein **objektives Validierungs-Tool** sagt verbindlich „richtig/falsch" — aus Text-Generierung wird überprüfbare Umsetzung.
