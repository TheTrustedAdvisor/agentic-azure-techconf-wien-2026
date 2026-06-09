# Präsentations-Narrativ — Agentic Architecture: From Chat to ralph

> Master-Narrativ. Quelle für Mermaids, Infografiken und das Präsentations-Markdown.
> Prinzip: jede Aussage trägt eine **Begründung** (Problem→Solution→Tradeoff /
> Traditional→Modern→Benefit / If-Then), nie nur ein Feature. Substanz vor Behauptung.

## Meta
- **Titel:** Agentic Architecture — From Chat to ralph
- **Event:** Techconference Wien 2026 · **Sprecher:** Matthias Falland (Microsoft Data Platform MVP)
- **Publikum:** Microsoft-Techniker, Level 200–300 · **Sprache:** Deutsch · **Dauer:** ~75 Min
- **Doppelziel:** (a) *erklären* — LLM, Kontext, MCP, Agent, Multi-Agent, Verifizierung, Autonomie;
  (b) *zeigen* — dieselbe Azure-Architektur-Aufgabe mit zunehmend reiferen Methoden bearbeiten.

## Der rote Faden (ein Satz)
> Die meisten Architektur-Fragen sind auf Stufe 2–3 beantwortet. Nur **offene, prüfintensive** Aufgaben
> rechtfertigen Multi-Agent und Autonomie. Die Kunst ist nicht hochzuklettern, sondern die **richtige
> Stufe zu erkennen** — und zu wissen, wann sogar gar kein Agent die beste Antwort ist.

## Story-Arc
**Hook → Grundlagen verstehen → die Methoden-Galerie an einer Aufgabe → wann welche Stufe (inkl. „kein Agent") → Take-away.**

---

# Teil A — Grundlagen (alles erklären)

### A1 · Was ist ein LLM?
- **Kernidee:** sagt das *nächste Token* voraus — optimiert auf **plausible Fortsetzung, nicht auf Wahrheit.**
- **Why (P→S→T):** Sprache ohne Programmierung. **Tradeoff:** kein Live-Wissen, kein Gedächtnis, keine Aktionen.
- **Halluzination präzise:** das Modell erzeugt Plausibles; **Grounding (Tools/MCP) senkt die Rate, beseitigt sie nicht.** Auch mit perfekten Quellen kann es abweichen. → später: gegen *Fakten*-Halluzination hilft nur ein **deterministischer Check außerhalb des LLM.**
- **Analogie:** brillanter Berater am ersten Tag — eloquent, kennt eure Zahlen nicht.
- **Infografik:** `llm-anatomie`.

### A2 · Kontext & Tokens
- **Kernidee:** das Modell ist *zustandslos*. „Gedächtnis" = die ganze Konversation wird bei jedem Aufruf erneut mitgeschickt.
- **Tiefe (300er):** **Prompt-Caching** funktioniert, weil identische Präfixe wiederverwendbar sind (KV-Cache). **Context-Rot / „lost in the middle":** mehr Kontext ist nicht monoton besser — ein Grund für *frische* Kontexte pro Rolle (Stufe 5–6).
- **Kosten-Realismus:** Tokens wachsen pro Runde → Stufe 8 kostet ein Vielfaches von Stufe 2 **für dieselbe Aufgabe**. Hebel: Caching, Modell-Routing, Limits. *(Im Talk: echte Token-/Kostenzahlen der Anker-Aufgabe pro Stufe zeigen.)*
- **Infografik:** `kontextfenster`.

### A3 · Tools / Function Calling — *wer* führt aus?
- **Mechanismus (wichtig):** Das Modell **führt das Tool nicht selbst aus.** Es gibt einen `tool_use`-Block (JSON: welches Tool, welche Argumente) zurück; der **Host** führt das Tool aus und schickt das Ergebnis als `tool_result` zurück. → Das ist die **Vertrauensgrenze**: der Host bestimmt, was erlaubt ist.
- **Why (T→M→B):** vorher raten → jetzt holen/handeln → geerdet, überprüfbar. **Tradeoff:** Latenz + Trust-Boundary.
- **ACI:** eine gute Tool-Beschreibung ist der **wichtigste Einzelfaktor**; vage Tools → Fehlaufrufe, Endlosschleifen, verbranntes Budget.
- **Infografik:** `tool-use-aci`.

### A4 · MCP (Model Context Protocol)
- **Konkret zuerst:** der Microsoft-Learn-MCP gibt dem Modell *aktuelle, echte Doku* statt Trainingswissen. **Dann die Analogie:** ein offener Standard wie „USB-C für KI-Tools".
- **Why (P→S→T):** statt pro Tool eine eigene Integration → ein Standard, viele Quellen.
- **Sicherheit (für MS-Publikum):** MCP-Server laufen mit den Rechten, die man ihnen gibt. Risiken: **Tool-Poisoning, Prompt-Injection über Tool-Ergebnisse, Confused-Deputy.** Der **Host** setzt die Trust-Boundary durch, nicht das Protokoll; jeder Server wird einzeln freigegeben.
- **Infografiken/Mermaid:** `mcp-usb-c`, `m-trust-boundary`.

### A5 · Der Agent (think → act → observe)
- **Kernidee:** Agent = LLM + Tools + **Schleife**.
- **Mechanik (300er):** Die Schleife läuft, solange das Modell ein Tool aufruft (`stop_reason: tool_use`), und endet, wenn es ohne Tool antwortet (`end_turn`). Fehler kommen als `tool_result` zurück → Selbstkorrektur. Ein **Limit** verhindert Endlosschleifen.
- **Tradeoff:** mehr Tokens/Latenz, weniger Determinismus.
- **Infografik/Mermaid:** `agent-loop`, `m-agent-loop`.

### A6 · Multi-Agent (Rollen + Orchestrierung in Code)
- **Übergang von A5:** Eine Schleife löst *eine* Aufgabe. Für Arbeitsteilung koordiniert **Code** (nicht das Modell) mehrere spezialisierte Agenten. **„Multi-Agent = Code-Struktur, kein Magie-Prompt."**
- **Rollen:** Analyst (holt Fakten) → Architekt (entwirft) → **Critic** (prüft unabhängig) → Executor (setzt um).
- **Why:** Spezialisierung + unabhängige Prüfung + frische Kontexte heben Qualität. **Grenze:** der Critic ist *dasselbe Modell* und kann selbst irren → er findet **Design**-Schwächen; gegen **Fakten**-Halluzination braucht es A8.
- **Tradeoff:** teurer, koordinationsanfällig.
- **Infografik/Mermaid:** `multi-agent-workforce`, `m-multi-agent`.

### A7 · Autonomie (Plan + beschränkte Schleife)
- **Kernidee:** erst planen (ralplan), dann eine *begrenzte* Schleife (ralph) gegen ein objektives Kriterium.
- **Compounding errors:** ein Fehler in Runde *n* landet im Kontext und konditioniert Runde *n+1* → ohne Grenzen schaukelt sich das auf.
- **Leitplanken (Pflicht, nicht Fußnote):** Tool-Allowlist pro Rolle, in der Schleife nur `validate`/`what-if` (**nie** `apply`), hartes Iterations-/Budget-Limit, Sandbox (die Demo läuft in isoliertem `.claude-demo/`), Mensch an irreversiblen Punkten.
- **Infografik:** `autonomie-grenzen`.

### A8 · Verifizierung & Guardrails (der Konzept-Anker, auf den alles hinausläuft)
- **Kernidee:** Qualität wird **gemessen**, nicht behauptet. Ein **objektives, nicht-LLM** Abbruchkriterium schlägt jedes „sieht gut aus".
- **Konkret für die Domäne:** CIDR-Overlap-Check (Skript/`terraform plan`), Private-DNS-Zonennamen gegen MS-Learn-MCP, Pflicht-Tags vollständig, keine öffentlichen Datenendpunkte, NFR-Abdeckungsmatrix gefüllt → **grün/rot.**
- **Why:** Das ist der ehrliche Konter gegen „der Critic verbessert die Qualität" — woran erkennt man's? An bestandenen Checks. **Halluzination heilt man nicht mit mehr Agenten, sondern mit deterministischer externer Prüfung.**
- **Mermaid:** `m-eval-gate` (grün/rot-Tor), `m-trust-boundary`.

---

# Teil B — Methoden-Galerie an EINER Aufgabe (8 Stufen)

> Ehrlich: Das ist **keine** strikte Pipeline (Output→Input) und **keine** Rangliste. Es ist **dieselbe
> Anker-Aufgabe** (`AUSGANGSLAGE.md`, Helvetia MedTech), bearbeitet mit einer jeweils **reiferen Methode** —
> mit bewusst eingebauten Tälern und einem klaren Methodenwechsel.

| Stufe | Methode | Was sie zeigt (ehrlich) |
|---|---|---|
| 1 | **Chat** | schneller Entwurf — **für viele Skizzen reicht das schon** |
| 2 | **MCP-Server** | echte MS-Doku → Behauptung wird belegtes Wissen *(viele Aufgaben enden hier)* |
| 3 | **Eigene Agents** | **bewusstes Tal**: eine vage Definition → beliebiges Ergebnis. Zeigt, wie sehr Qualität an der Definition hängt |
| 4 | **LLM schreibt Agents** | das Modell schärft die Definition (Risiko: es kuratiert seine eigene Schwäche → menschlicher Blick nötig) |
| 5 | **OMC-Agents** | **der eigentliche Sprung: ein Agent → Rollen-Pipeline** (analyst/architect/executor), erprobt + Modell-Routing |
| 6 | **Critics** | unabhängige Prüfung findet **Design**-Schwächen (z. B. CIDR-Overlap-Verdacht) |
| 7 | **Plan + Umsetzung** | aus Text wird IaC + **objektive Validierung** (`terraform validate` / `what-if`) |
| 8 | **ralplan + ralph** | beschränkte Autonomie konvergiert bis „grün" (Definition of Done) |

- **Anker-Aufgabe:** aus `AUSGANGSLAGE.md` die Netzwerk-Architektur entwickeln (Adressplan, Hub-Spoke, Private Endpoints/DNS, Ingress/Egress, AKS/APIM/Fabric, Governance).
- **Über die Stufen mitschneiden:** Tokens/Kosten **und** bestandene Checks pro Stufe → die Kosten- und Eval-Achse (A2/A8) wird real, nicht behauptet.
- **Infografik/Mermaid:** `methoden-leiter`, `m-methoden-leiter`.

---

# Teil C — Das gebaute Ergebnis (Azure-Zielbild)

- **Zielbild:** Hub-Spoke (WEU primär, NEU DR), zentrale Konnektivität (ExpressRoute + VPN, Azure Firewall, DNS Private Resolver), strikt private PaaS (Private Endpoints + Private DNS), kontrollierter Ingress/Egress, AKS/APIM, Microsoft Fabric Capacity, Zero-Trust + Data-Residency.
- **Why (Zero-Trust):** keine öffentlichen Datenpfade — by design. Read-only/privat ist Architektur, kein Nachgedanke.
- **Infografik/Mermaid:** `azure-zielarchitektur`, `zero-trust-private`, `m-azure-hubspoke`, `m-private-dns`.

---

# Teil D — Wann welche Stufe? (inkl. „wann gar kein Agent")

> Die wichtigste praktische Folie. Entscheidungsbaum statt Moral.

- **Deterministisch + geschlossen** (Schrittfolge steht fest) → **gar kein Agent**: Skript / IaC-Template ist billiger, schneller, sicherer.
- **Daten/Fakten nötig, eine klare Frage** → Stufe 2 (Tool/MCP).
- **Verschiedene Anfragetypen** → Routing.
- **Offen, mehrstufig, Rollen + Prüfung** → Stufe 5–6.
- **Offenes Ziel mit objektivem Abbruchkriterium** → Stufe 7–8 (mit Limits).
- **Ehrlich:** „Architekt + ChatGPT" *ist* Stufe 1–2 und reicht für ~70 % der Architektur-Skizzen. Die Stufen 6–8 zahlen sich nur, wenn das Ergebnis **gebaut + maschinell geprüft** werden muss.
- **Mermaid:** `m-entscheidung` (mit „kein Agent"-Ast) — früh zeigen, nicht als Anhang.

---

# Take-away
1. Versteh die Schichten: LLM → Tools/MCP → Agent → Multi-Agent → **Verifizierung** → Autonomie.
2. Jede Stufe ist ein Werkzeug mit Preis. **Die meisten Aufgaben enden auf Stufe 2–3.**
3. Wert entsteht an **offenen, prüfintensiven** Aufgaben — und nur, wenn Qualität **gemessen** wird (grün/rot).
4. Autonomie braucht Grenzen: Plan, Limit, Sandbox, objektives Abbruchkriterium.
5. Manchmal ist die beste „KI-Architektur" ein deterministisches Skript.

---

# Artefakt-Inventar

> Bewusst: **Infografik = Konzept-Hook**, **Mermaid = technische Präzision.** Bei 75 Min ist pro Konzept
> eines davon Streichmasse — Reihenfolge unten = Priorität.

## Infografiken (Gemini Pro Image, Brand: matthias-falland, 16:9, Deutsch)
1. `agent-loop` ✓ · 2. `methoden-leiter` · 3. `mcp-usb-c` · 4. `multi-agent-workforce` ·
5. `autonomie-grenzen` · 6. `azure-zielarchitektur` · 7. `llm-anatomie` · 8. `kontextfenster` ·
9. `zero-trust-private` · 10. `tool-use-aci`

## Mermaids (technische + logische Patterns)
- `m-agent-loop` — Sequenz Host→LLM→Tool→Observe (`stop_reason`)
- `m-mcp-architektur` — Host/Client ↔ MCP-Server ↔ Quellen
- `m-multi-agent` — Orchestrator → Analyst/Critic/Executor
- `m-eval-gate` — objektives grün/rot-Tor (Verifizierung)
- `m-trust-boundary` — read-only (Agent) vs. write (Orchestrator)
- `m-methoden-leiter` — die 8 Stufen mit Gewinn/Preis
- `m-azure-hubspoke` — Hub-Spoke WEU + DR-NEU
- `m-private-dns` — Private Endpoint + Private-DNS (hybrid)
- `m-entscheidung` — „welche Stufe wann" inkl. „kein Agent"
