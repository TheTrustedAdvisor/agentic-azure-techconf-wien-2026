# Prompting-Guide — von „nett" zu „prüfbar"

> Die Methoden-Stufen ändern *wie* das Modell arbeitet. Der Prompt ändert *woran* es arbeitet.
> Beides zusammen entscheidet über das Ergebnis. Dieser Guide gibt dir Muster und fertige
> Copy-Paste-Vorlagen für jede Stufe — am Beispiel der Workshop-Aufgabe
> ([`../AUSGANGSLAGE.md`](../AUSGANGSLAGE.md), Helvetia MedTech).

---

## 1. Die Anatomie eines starken Prompts

Ein guter Prompt beantwortet fünf Fragen — in dieser Reihenfolge:

| Baustein | Frage | Beispiel |
|---------|-------|----------|
| **Rolle/Kontext** | Wer bist du, was ist die Lage? | „Du bist Azure-Netzwerkarchitekt. Eingabe ist `AUSGANGSLAGE.md`." |
| **Ziel** | Was genau soll entstehen? | „Entwirf die Hub-Spoke-Topologie für WEU + DR in NEU." |
| **Grenzen/Constraints** | Was ist Pflicht, was verboten? | „Strikt private PaaS. IP-Raum 10.16.0.0/12. Keine öffentlichen Endpunkte." |
| **Output-Format** | Wie soll die Antwort aussehen? | „Als Tabelle: VNet · CIDR · Zweck. Danach die offenen Annahmen." |
| **Definition of Done** | Woran erkennen *wir beide* „fertig"? | „Fertig, wenn keine CIDR-Overlaps und jede PaaS-Zone eine Private-DNS-Zone hat." |

> Faustregel: Wenn du das Ergebnis nicht **objektiv prüfen** kannst, fehlt die *Definition of Done*.
> Das ist der häufigste Grund für „klingt gut, ist aber falsch".

---

## 2. Universelle Muster (stufenunabhängig)

**Plan-first** — erst denken lassen, dann tun:
> „Erstelle **zuerst** einen nummerierten Plan mit Prüfkriterien. Beginne erst nach meinem ‚go'."

**Zerlegen** — eine grosse Frage in prüfbare Teile:
> „Zerlege die Aufgabe in unabhängige Teilaufgaben. Nummeriere sie. Markiere, welche voneinander abhängen."

**Selbstkritik** — das Modell gegen sich selbst:
> „Nenne drei Schwächen deines eigenen Entwurfs und wie ein Critic ihn angreifen würde."

**Quelle erzwingen** — gegen Halluzination (nur wirksam mit Tool/MCP!):
> „Belege jede Aussage zu DNS-Zonen/SKUs mit einer Microsoft-Learn-Quelle. Wenn du keine findest, schreibe ‚unbelegt'."

**Few-shot** — ein Beispiel sagt mehr als zehn Adjektive:
> „Format wie dieses Beispiel: `snet-app-weu | 10.16.1.0/24 | App-Tier Spoke`."

**Annahmen sichtbar machen:**
> „Liste am Ende alle Annahmen, die du getroffen hast, getrennt vom Ergebnis."

---

## 3. Anti-Muster (das kostet dich Zeit)

| ❌ Anti-Muster | Warum es schiefgeht | ✅ Besser |
|---------------|---------------------|----------|
| „Mach mir eine gute Azure-Architektur." | kein Ziel, keine Grenzen → beliebig | Rolle + Ziel + Constraints + DoD |
| „Ist das sicher?" | Ja/Nein ohne Kriterium | „Prüfe gegen: keine öffentlichen Endpunkte, PE+Private DNS, NSG je Subnet." |
| Alles in einem Riesen-Prompt | Modell verliert den Faden („lost in the middle") | zerlegen, Plan-first |
| „Vertrau mir, das stimmt." | Behauptung statt Beleg | Quelle erzwingen (Stufe 2+) |
| Bei Fehlern neu anfangen | wirft Selbstkorrektur weg | Fehlermeldung **zurück in den Loop** geben |

---

## 4. Copy-Paste-Vorlagen je Stufe

> Ersetze `<…>` durch deinen Fall. Alle Vorlagen beziehen sich auf [`../AUSGANGSLAGE.md`](../AUSGANGSLAGE.md).

### Stufe 1 — Chat (schneller Entwurf, ungeprüft)
```
Du bist Azure-Netzwerkarchitekt. Lies die folgende Ausgangslage und entwirf eine
Hub-Spoke-Topologie (Primärregion West Europe, DR in North Europe).

Constraints: IP-Raum 10.16.0.0/12, strikt private PaaS, zentraler Egress über Firewall.
Output: Tabelle (VNet | CIDR | Zweck), danach eine Liste deiner Annahmen.
Definition of Done: keine CIDR-Overlaps; jede Region hat einen Hub.

<AUSGANGSLAGE einfügen>
```
*Erwartung:* plausibel, aber **ungeprüft** — DNS-Zonen/SKUs kann das Modell hier nur raten.

### Stufe 2 — MCP (echte Doku statt Raten)
```
Gleiche Aufgabe wie eben. ABER: Belege jede Aussage zu Private-DNS-Zonen-Namen,
Firewall-SKU und Regionsverfügbarkeit mit dem Microsoft-Learn-MCP.
Wenn du eine Aussage nicht belegen kannst, markiere sie als "unbelegt".
Gib pro belegter Aussage die Quell-URL an.
```
*Erwartung:* dieselbe Struktur, jetzt mit **Belegen** (z. B. `privatelink.blob.core.windows.net`).

### Stufe 3 — Eigene Agents (bewusst schwach)
```
@azure-helfer Entwirf die Spoke-Struktur für die Daten-Workloads.
```
*Erwartung:* **beliebig** — die Agent-Definition ist absichtlich vage. Das ist die Lektion.

### Stufe 4 — LLM schärft die Agent-Definition
```
Hier ist eine schwache Agent-Definition (azure-helfer.md). Schärfe sie:
- präzise Rolle, klare Tool-Liste, explizite Grenzen (read-only? welche Quellen?)
- eine Definition of Done, gegen die man das Ergebnis objektiv prüfen kann
Gib die überarbeitete Definition als vollständige Markdown-Datei zurück.

<azure-helfer.md einfügen>
```
*Erwartung:* eine **scharfe** Definition — der menschliche Blick entscheidet, was „scharf" heisst.

### Stufe 5 — OMC-Agents (Rollen-Pipeline)
```
Nutze nacheinander: analyst (Anforderungen klären) → architect (Topologie entwerfen)
→ executor (als Terraform-Skizze ausformulieren). Reiche das Ergebnis jeder Rolle
an die nächste weiter. Halte dich an die Constraints aus AUSGANGSLAGE.md.
```
*Erwartung:* ein Artefakt, das durch **mehrere Rollen** gereift ist — nicht eine Stimme.

### Stufe 6 — Critics (unabhängige Prüfung)
```
Lass critic und security-reviewer den Entwurf unabhängig prüfen.
Sie sollen NICHT verbessern, sondern Schwächen finden: CIDR-Overlaps, fehlende
Private-DNS-Zonen, offene Egress-Pfade, fehlende NSGs. Liste Befunde mit Schweregrad.
```
*Erwartung:* **Design-Schwächen** werden sichtbar (z. B. ein Overlap, den niemand sah).

### Stufe 7 — Plan + Umsetzung (IaC + objektive Validierung)
```
1) ralplan: zerlege das Ziel in Schritte MIT Prüfkriterien (Definition of Done).
2) executor: setze Schritt für Schritt als Terraform um.
3) Validierung: `terraform validate` und `what-if` — niemals `apply`.
Stopp, sobald alle Checks grün sind.
```
*Erwartung:* IaC, deren Qualität **gemessen** statt behauptet wird.

### Stufe 8 — ralplan + ralph (beschränkte Autonomie)
```
/oh-my-claudecode:ralplan  Ziel: validierte Hub-Spoke-IaC gemäss AUSGANGSLAGE.md.
Definition of Done: terraform validate grün, keine CIDR-Overlaps, alle PaaS privat.
Dann ralph mit: max. Iterationen, nur validate/what-if (nie apply), Stopp bei "grün".
Beenden mit /oh-my-claudecode:cancel.
```
*Erwartung:* die Schleife konvergiert **bis grün** — mit harten Grenzen.

---

## 5. Azure-spezifische Prompt-Hebel

- **CIDR rechnen lassen, dann prüfen:** „Teile 10.16.0.0/12 in Hub + 6 Spokes; zeige die /24-Subnetze und beweise, dass nichts überlappt."
- **`what-if` statt `apply`:** Bei Azure ist `az deployment ... what-if` das gefahrlose Verb — immer das verlangen, nie `apply` in einer Schleife.
- **Private-DNS-Zonen exakt benennen lassen:** „Nenne die korrekte `privatelink.*`-Zone je PaaS-Dienst und belege sie per MS-Learn." (Die Namen sind fix — raten ist tödlich.)
- **Pflicht-Tags als Check:** „Prüfe, ob jede Ressource die Pflicht-Tags trägt; liste Verstöße."

---

## 6. Die Meta-Regel

> Ein besserer Prompt ersetzt oft eine teurere Stufe.
> Bevor du auf Multi-Agent oder Autonomie hochschaltest: **Hat dein Prompt eine Definition of Done?**
> Wenn nicht, löst eine höhere Stufe dein Problem nicht — sie macht es nur teurer.
