# Glossar — jeder Begriff in 2–3 Sätzen

> Zum Nachschlagen. Aufbau: **Begriff** — was es ist · *warum es zählt*.

## LLM & Kontext

**LLM (Large Language Model)** — Ein Modell, das das **nächste Token** vorhersagt, optimiert auf Plausibilität, nicht auf Wahrheit. *Warum: „plausibel ≠ korrekt" ist keine Panne, sondern die Arbeitsweise — deshalb braucht es Prüfung.*

**Token** — Die kleinste Einheit, in der das Modell Text verarbeitet (ein Wortteil). *Warum: Kosten und Kontextgrenzen rechnen in Tokens, nicht in Wörtern.*

**Kontextfenster** — Der gesamte Text (System + Verlauf + Eingabe), den das Modell pro Aufruf „sieht". Das Modell ist **zustandslos** — der ganze Verlauf wird jedes Mal neu geschickt. *Warum: pro Runde wachsen die Tokens → das ist die Wurzel der Kostenkurve.*

**KV-Cache / Prompt-Caching** — Identische Präfixe einer Anfrage können wiederverwendet werden, statt sie neu zu rechnen. *Warum: macht lange, stabile Systemprompts bezahlbar — verändert man den Anfang, ist der Cache hin.*

**Halluzination** — Eine plausibel klingende, aber falsche Aussage. *Warum: lässt sich nicht „mit mehr Agenten" heilen — nur mit einem Check **ausserhalb** des Modells.*

**Grounding** — Das Modell mit echten Quellen versorgen (z. B. via MCP/RAG). *Warum: **senkt** Halluzination, **beseitigt** sie nicht.*

## Tools, MCP & Agents

**Tool / Tool use** — Eine Funktion, die das Modell aufrufen *möchte*. Es gibt `tool_use` (JSON) zurück; ausgeführt wird vom **Host**, der `tool_result` liefert. *Warum: das Modell bittet, der Host handelt — dort liegt die Kontrolle.*

**ACI (Agent-Computer-Interface)** — Die Qualität der Tool-Beschreibung (Name, Parameter, Doku). *Warum: der **wichtigste Einzelfaktor** — vage Tools = Fehlaufrufe, Schleifen, verbranntes Budget.*

**MCP (Model Context Protocol)** — Offener Standard, über den Hosts und externe Quellen reden. Drei Primitive: **Tools** (Aktionen), **Resources** (Daten), **Prompts** (Vorlagen), transportiert über **JSON-RPC**. *Warum: „ein Protokoll, viele Quellen" — kein proprietäres Kabel.*

**Host / Client / Server** — Der Host (z. B. Claude) enthält den MCP-Client; der MCP-Server stellt Tools/Resources bereit. *Warum: der Host setzt die **Vertrauensgrenze** durch und gibt jeden Server einzeln frei.*

**Vertrauensgrenze (Trust-Boundary)** — Die Linie, an der unkontrollierte Eingaben auf kontrollierte Ausführung treffen. *Warum: Tool-Poisoning / Prompt-Injection sind reale Risiken — der Host muss mediieren.*

**Agent** — LLM + Tools + **Schleife**: denken → handeln → beobachten, bis `end_turn`. *Warum: Fehler kommen als Ergebnis zurück → Selbstkorrektur; ein **Limit** stoppt Endlosschleifen.*

**Agent-Loop** — Der Zyklus, der läuft, solange das Modell ein Tool ruft. *Warum: das ist die ganze „Magie" — alles Weitere ist Struktur drumherum.*

**Orchestrator** — Code (nicht Prompt), der eine Aufgabe **zur Laufzeit** zerlegt und an Rollen delegiert. *Warum: Multi-Agent ist Code-Struktur, keine versteckte Prompt-Magie.*

**Multi-Agent** — Mehrere spezialisierte Rollen mit je frischem Kontext, vom Orchestrator zusammengeführt. *Warum: frische Kontexte je Rolle + Prüfer ≠ Autor.*

**Critic** — Eine Rolle, die einen Entwurf **prüft statt verbessert**. *Warum: findet **Design**-Schwächen — ist aber dasselbe Modell und kann selbst irren.*

**Verifier / Verifizierung** — Qualität **messen** (grün/rot) statt behaupten, idealerweise deterministisch. *Warum: gegen **Fakten**-Halluzination hilft nur ein Check ausserhalb des LLM.*

**Definition of Done** — Die objektiven Kriterien, an denen „fertig" festgemacht wird. *Warum: ohne sie ist jede höhere Stufe nur teurer, nicht besser.*

## Autonomie

**Guardrail** — Eine erzwungene Grenze: Iterations-/Budget-Limit, Stopp-Bedingung, Sandbox, nur `validate`. *Warum: Autonomie ohne Grenzen schaukelt Fehler auf.*

**ralplan** — Die **Plan**-Phase: das Ziel in Schritte + Definition of Done zerlegen, *bevor* gehandelt wird. *Warum: Planen ist billiger als blindes Tun.*

**ralph** — Die **Umsetzungs**-Phase: eine beschränkte Schleife, jede Runde handeln → objektiv prüfen → Tor. *Warum: jede Runde misst gegen die Definition of Done, statt zu raten.*

**Routing** — Eingaben nach Typ an die passende Behandlung verteilen. *Warum: oft die einfachste „intelligente" Antwort — nicht jede Aufgabe braucht einen Agenten.*

## Azure (die gebaute Architektur)

**Hub-Spoke** — Ein zentraler Hub (Firewall, Gateway, DNS) mit angehängten, isolierten Spokes. *Warum: der von Microsoft empfohlene Default für Enterprise-Netze.*

**Spoke** — Ein isoliertes VNet für eine Workload, über Peering am Hub. *Warum: trennt Workloads, leitet Egress kontrolliert über den Hub.*

**Private Endpoint (PE)** — Eine private IP in deinem VNet für einen PaaS-Dienst. *Warum: PaaS ohne öffentlichen Endpunkt erreichbar.*

**Private DNS Zone** — Eine `privatelink.*`-Zone, die den Dienstnamen auf die private IP auflöst. *Warum: die Zonennamen sind **fix** je Dienst — falsch geraten = keine Auflösung.*

**Private Resolver** — Azure-Dienst, der DNS hybrid (On-Prem ↔ Azure) auflöst. *Warum: macht private Namensauflösung über Standortgrenzen hinweg möglich.*

**CIDR** — Schreibweise für IP-Bereiche (`10.16.0.0/12`). *Warum: **Overlaps** sind ein klassischer, deterministisch prüfbarer Fehler.*

**Landing Zone** — Der standardisierte Enterprise-Rahmen (Netzwerk, Identität, Governance …), auf Hub-Spoke aufgebaut. *Warum: macht aus „ein paar VNets" eine betreibbare Plattform.*

**Zero-Trust** — Kein impliziter Vertrauensraum; privat/least-privilege als Default. *Warum: read-only/privat ist Architektur, kein Nachgedanke.*

**Fabric Capacity** — Die F-SKU-Recheneinheit hinter Microsoft Fabric. *Warum: der optionale Daten-Endpunkt, der in dieselbe Zero-Trust-Logik eingebunden wird.*

**Lakehouse vs. Warehouse** — In Fabric: der SQL-Endpunkt eines Lakehouse ist **read-only**, ein Warehouse erlaubt **Schreiben** (z. B. CTAS). *Warum: bestimmt, wo Daten transformiert werden dürfen.*
