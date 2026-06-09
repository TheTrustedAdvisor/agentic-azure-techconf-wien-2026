# Mermaid-Patterns (technisch + logisch)

> Technische Präzision zu den Infografiken — Mechanik, nicht Offensichtliches. Jeder Block einzeln
> nach mermaid.live → SVG/PNG (oder gerenderte PNGs in `images/`). Validiert mit `mmdc`.

## m-agent-loop — Loop mit Selbstkorrektur (das Nicht-Offensichtliche)

```mermaid
sequenceDiagram
    participant Host as Host (Agent-Loop)
    participant LLM as Modell
    participant Tool as Werkzeug
    Host->>LLM: System + Werkzeuge + Verlauf
    loop bis stop_reason = end_turn
        LLM-->>Host: stop_reason=tool_use · tool_use(name, args)
        alt Aufruf gueltig
            Host->>Tool: ausfuehren (Host, nicht das Modell)
            Tool-->>Host: tool_result (Daten)
        else Fehler
            Host-->>LLM: tool_result · is_error=true
            Note over Host,LLM: Fehler ist Eingabe, kein Absturz → Modell korrigiert SQL/Args selbst
        end
    end
    LLM-->>Host: stop_reason=end_turn · finale Antwort
```

> Pointe: Fehler werden in den Loop *zurückgegeben* — Resilienz by design. Das Modell bittet, der Host handelt.

## m-mcp-architektur — MCP ist ein typisiertes Protokoll, kein Kabel

```mermaid
flowchart LR
    subgraph HOST["Host (Claude) — setzt Trust-Boundary + Freigabe durch"]
        CL["MCP-Client"]
    end
    subgraph SRV["MCP-Server (lokal oder remote)"]
        T["Tools<br/>(Aktionen)"]
        R["Resources<br/>(Daten/Kontext)"]
        PR["Prompts<br/>(Vorlagen)"]
    end
    CL <-->|"JSON-RPC: Fähigkeiten aushandeln"| SRV
    CL -->|"Aufruf nur nach Freigabe"| T
    R --> Q[("Quelle: Doku/DB/Files")]
    style HOST fill:#e8f0fe,stroke:#1c2832,color:#000
    style SRV fill:#f3f4f6,stroke:#455a64,color:#000
    style T fill:#fdecea,stroke:#cc2229,color:#000
```

> Nicht „ein Stecker", sondern drei typisierte Primitive (Tools/Resources/Prompts) über JSON-RPC; der Host mediiert jeden Zugriff.

## m-multi-agent — Dynamische Zerlegung + Verifier-Schleife

```mermaid
flowchart TB
    TASK["Komplexe Aufgabe"] --> ORC["Orchestrator (Code)<br/>zerlegt ZUR LAUFZEIT"]
    ORC -->|"delegiert"| W1["Analyst<br/>frischer Kontext"]
    ORC -->|"delegiert"| W2["Architekt<br/>frischer Kontext"]
    ORC -->|"delegiert"| W3["Executor<br/>frischer Kontext"]
    W1 --> SYN["Orchestrator: fuehrt zusammen"]
    W2 --> SYN
    W3 --> SYN
    SYN --> VER{"Verifier (eigene Instanz)<br/>Kriterien erfuellt?"}
    VER -->|"nein"| ORC
    VER -->|"ja"| OUT["Artefakt"]
    style ORC fill:#ede7f6,stroke:#5e35b1,color:#000
    style VER fill:#fff9c4,stroke:#f9a825,color:#000
```

> Teilaufgaben stehen *nicht* vorab fest; jeder Worker hat ein frisches Kontextfenster; der Prüfer ist nicht der Autor.

## m-plan-umsetzung — ralplan denkt, ralph handelt

```mermaid
flowchart LR
    GOAL["Ziel"] --> PLAN["ralplan: Plan + Definition of Done<br/>(Schritte + objektive Checks)"]
    PLAN --> LOOP
    subgraph LOOP["ralph — beschraenkte Schleife"]
        direction TB
        ACT["handeln (Schritt umsetzen)"] --> VAL["validate (nie apply)"]
        VAL --> GATE{"alles gruen?"}
        GATE -->|"nein & Runde < max"| ACT
    end
    GATE -->|"ja"| DONE["fertig"]
    LOOP -->|"Runde = max"| STOP["kontrollierter Stopp"]
    style PLAN fill:#e0f7fa,stroke:#00838f,color:#000
    style LOOP fill:#fff5f7,stroke:#c2185b,color:#000
    style GATE fill:#e8f5e9,stroke:#388e3c,color:#000
```

> Planen (denken) und Umsetzen (handeln+prüfen) sind getrennte Phasen; jede Runde prüft objektiv, statt zu raten.

## m-eval-gate — Objektives Tor (grün/rot statt „sieht gut aus")

```mermaid
flowchart LR
    GEN["Entwurf / IaC"] --> CHK{"Deterministische Checks"}
    CHK --> C1["CIDR-Overlap?"]
    CHK --> C2["Private-DNS-Zonen korrekt?"]
    CHK --> C3["Pflicht-Tags vollstaendig?"]
    CHK --> C4["keine oeffentlichen Endpunkte?"]
    C1 --> V{"alle gruen?"}
    C2 --> V
    C3 --> V
    C4 --> V
    V -->|"ja"| OK["freigeben"]
    V -->|"nein"| GEN
    style V fill:#e8f5e9,stroke:#388e3c,color:#000
    style OK fill:#e8f5e9,stroke:#388e3c,color:#000
```

> Gegen *Fakten*-Halluzination hilft nur ein Check **außerhalb** des LLM.

## m-trust-boundary — read-only (Agent) vs. write (Orchestrator)

```mermaid
flowchart TD
    subgraph A["Agent darf"]
        R["lesen / abfragen<br/>read-only"]
    end
    subgraph O["nur Orchestrator darf"]
        W["schreiben / provisionieren<br/>validate, nie apply in der Schleife"]
    end
    R --> BASE[("Quelldaten / Doku")]
    W --> ART[("Artefakte / IaC")]
    style A fill:#e8f5e9,stroke:#388e3c,color:#000
    style O fill:#e3f2fd,stroke:#1565c0,color:#000
```

## m-methoden-leiter — Stufen mit zwei Achsen (Fähigkeit ↑, Determinismus ↓)

```mermaid
flowchart LR
    S1["1 Chat"] -->|"+Daten"| S2["2 MCP"]
    S2 -->|"+Rolle / Tal"| S3["3 eigene Agents"]
    S3 -->|"+Schaerfe"| S4["4 LLM-Agents"]
    S4 -->|"single→multi"| S5["5 OMC-Agents"]
    S5 -->|"+Pruefung"| S6["6 Critics"]
    S6 -->|"+Validierung"| S7["7 Plan+IaC"]
    S7 -->|"+Autonomie"| S8["8 ralplan+ralph"]
    K["Kosten/Tokens →"] -. "steigen mit jeder Stufe" .-> S8
    D["Determinismus →"] -. "sinkt ab Stufe 8" .-> S8
    style S1 fill:#e1f5ff,stroke:#0288d1,color:#000
    style S8 fill:#fce4ec,stroke:#c2185b,color:#000
    style K fill:#fff3e0,stroke:#f57c00,color:#000
    style D fill:#eceff1,stroke:#455a64,color:#000
```

## m-azure-hubspoke — Hub-Spoke WEU + DR-NEU

```mermaid
flowchart TB
    ONP["On-Premises<br/>10.4.0.0/14"]
    subgraph HUB["Hub-VNet WEU"]
        FW["Azure Firewall"]
        GW["ExpressRoute + VPN"]
        DNS["DNS Private Resolver"]
    end
    ONP <-->|"ExpressRoute + VPN"| GW
    GW --- FW
    FW --- SAAS["Spoke: SaaS/AKS"]
    FW --- DATA["Spoke: Daten + Fabric"]
    FW --- INT["Spoke: Integration"]
    FW -. "Global Peering" .-> NEU["Hub NEU (DR)"]
    NET["Internet"] -->|"Front Door + WAF"| SAAS
    style HUB fill:#ede7f6,stroke:#5e35b1,color:#000
```

## m-private-dns — Private Endpoint + Auflösung (hybrid)

```mermaid
sequenceDiagram
    participant App as App (Spoke)
    participant DNS as Private DNS Resolver
    participant PE as Private Endpoint
    participant SQL as Azure SQL
    App->>DNS: sql.database.windows.net?
    DNS-->>App: private IP (privatelink-Zone)
    App->>PE: Verbindung zur privaten IP
    PE->>SQL: nur privater Pfad
    SQL-->>App: Daten
```

## m-entscheidung — Welche Stufe wann (inkl. „kein Agent")

```mermaid
flowchart TD
    S{"Schrittfolge steht fest?"}
    S -->|"ja, deterministisch"| NOAG["kein Agent —<br/>Skript / IaC-Template"]
    S -->|"nein"| D{"Braucht es Daten/Fakten?"}
    D -->|"eine klare Frage"| TOOL["Stufe 2: Tool / MCP"]
    D -->|"viele Typen"| ROUTE["Routing"]
    TOOL --> MANY{"offen, Rollen + Pruefung?"}
    MANY -->|"ja"| WF["Stufe 5–6: Workforce + Critics"]
    WF --> AUTO{"offenes Ziel + objektives Kriterium?"}
    AUTO -->|"ja, mit Limits"| RALPH["Stufe 7–8: Plan + ralph"]
    style NOAG fill:#eceff1,stroke:#455a64,color:#000
    style TOOL fill:#e8f5e9,stroke:#388e3c,color:#000
    style RALPH fill:#fce4ec,stroke:#c2185b,color:#000
```

> Die meisten Aufgaben enden bei Stufe 2–3. „Architekt + ChatGPT" *ist* Stufe 1–2.
