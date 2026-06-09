# Mermaid-Patterns (technisch + logisch)

> Technische Präzision zu den Infografiken. Jeder Block einzeln nach mermaid.live → SVG/PNG,
> oder inline im Präsentations-Markdown. Validiert mit `mmdc`.

## m-agent-loop — Der Agent-Loop (think → act → observe)

```mermaid
sequenceDiagram
    participant App as Aufruf
    participant Host as Host (Agent-Loop)
    participant LLM as Modell
    participant Tool as Werkzeug
    App->>Host: Aufgabe
    loop bis stop_reason = end_turn
        Host->>LLM: Verlauf + Werkzeuge
        LLM-->>Host: stop_reason=tool_use, tool_use(Argumente)
        Host->>Tool: Host fuehrt aus (Trust-Boundary)
        Tool-->>Host: Ergebnis (tool_result)
    end
    LLM-->>Host: stop_reason=end_turn, finale Antwort
    Host-->>App: Ergebnis
```

> Das Modell führt nichts selbst aus — es *bittet*, der Host *handelt*. Limit verhindert Endlosschleifen.

## m-mcp-architektur — MCP: ein Standard, viele Quellen

```mermaid
flowchart LR
    HOST["Host / KI-Client<br/>(z. B. Claude)"] -->|"MCP"| S1["MCP-Server<br/>Microsoft Learn"]
    HOST -->|"MCP"| S2["MCP-Server<br/>Datenbank"]
    HOST -->|"MCP"| S3["MCP-Server<br/>Dateisystem"]
    S1 --> Q1[("Doku")]
    S2 --> Q2[("DB")]
    S3 --> Q3[("Dateien")]
    HOST -. "Host gibt jeden Server einzeln frei" .-> G["Trust-Boundary"]
    style HOST fill:#e8f0fe,stroke:#1c2832,color:#000
    style G fill:#fdecea,stroke:#cc2229,color:#000
```

## m-multi-agent — Orchestrator + Rollen + Critic-Tor

```mermaid
flowchart TB
    ORC["Orchestrator<br/>(Code, deterministisch)"] --> AN["Analyst"]
    AN --> AR["Architekt"]
    AR --> CR{"Critic<br/>freigegeben?"}
    CR -->|"ja"| EX["Executor"]
    CR -->|"nein"| AR
    EX --> OUT["Artefakt"]
    style ORC fill:#ede7f6,stroke:#5e35b1,color:#000
    style CR fill:#fff9c4,stroke:#f9a825,color:#000
```

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

## m-methoden-leiter — 8 Stufen mit Gewinn/Preis

```mermaid
flowchart LR
    S1["1 Chat"] -->|"+Daten / +Latenz"| S2["2 MCP"]
    S2 -->|"+Rolle / Tal"| S3["3 eigene Agents"]
    S3 -->|"+Schaerfe"| S4["4 LLM-Agents"]
    S4 -->|"single→multi"| S5["5 OMC-Agents"]
    S5 -->|"+Pruefung"| S6["6 Critics"]
    S6 -->|"+Validierung"| S7["7 Plan+IaC"]
    S7 -->|"+Autonomie/−Determinismus"| S8["8 ralplan+ralph"]
    style S1 fill:#e1f5ff,stroke:#0288d1,color:#000
    style S8 fill:#fce4ec,stroke:#c2185b,color:#000
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
