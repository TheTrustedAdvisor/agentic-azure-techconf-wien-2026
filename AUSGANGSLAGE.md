# Ausgangslage — Enterprise-Azure-Plattform (Workshop-Input)

> **Rolle dieses Dokuments im Workshop**
> Dies ist der **Startpunkt**, aus dem wir die Architektur Stufe für Stufe *entwickeln*
> (Chat → MCP → eigene Agents → LLM-geschriebene Agents → OMC-Agents → Critics →
> Plan + Umsetzung → ralplan + ralph).
>
> Es beschreibt **ausschliesslich** (1) die **Requirements** (business, technical,
> non-functional) und (2) die **Parametrisierung** (gegebene Inputs/Constraints).
> Es enthält **bewusst keine Lösung**: keine Topologie, keine Subnetz-Aufteilung, keine
> Ressourcenplatzierung, keine Routing-/Firewall-Entscheidungen. Die entstehen im Workshop.
>
> **Trennlinie:** „Adressraum `10.16.0.0/12` ist dem Unternehmen zugeteilt" = Parametrisierung
> (Input). „VNet X mit Subnetz `10.16.4.0/22` für AKS" = Lösung (gehört **nicht** hierher).
>
> `VERIFY`-Markierungen = vor produktivem/Contribution-Einsatz gegen aktuelle Azure-Fakten zu prüfen.

---

## 1. Business-Requirements

### 1.1 Unternehmensprofil (fiktiv)

| Attribut | Wert |
|---|---|
| Name | **Helvetia MedTech Group AG** (fiktiv) |
| Branche | Medizintechnik / Diagnostik-Geräte + SaaS-Auswerteplattform (regulierte Medizinprodukte) |
| Rechtsform / HQ | AG, Hauptsitz Zürich (CH) |
| Grösse | ~4.200 Mitarbeitende, davon ~450 in IT/Engineering |
| Umsatz | ~1,1 Mrd. CHF p.a. |
| Geschäftsmodell | (a) Verkauf von In-vitro-Diagnostik-Geräten, (b) Cloud-SaaS zur Auswertung von Patientendaten/Geräte-Telemetrie, (c) Service/Wartung |
| Physische Standorte | Zürich (HQ + primäres RZ), Genf (Vertrieb/Entwicklung), München (DE-Tochter), Boston (US-Tochter, FDA-Markt), Singapur (APAC-Vertrieb) |
| Bestehende RZ | 2 On-Prem-Rechenzentren (Zürich primär, Bern Co-Location als Ausweich) |

### 1.2 Geschäftliche Treiber

- **Cloud-Transformation:** Konsolidierung zweier On-Prem-RZ auf eine Azure-First-Plattform; On-Prem trägt mittelfristig nur noch Legacy-Fertigung + lokale Identitätsanker.
- **Time-to-Market:** Neue SaaS-Features statt halbjährlich in Wochen ausrollen.
- **Datenplattform-Konsolidierung:** Geräte-Telemetrie, Service- und kommerzielle Daten in *einer* Analytics-Plattform (Self-Service-BI + ML für Predictive Maintenance).
- **Regulatorischer Druck:** EU-MDR, FDA (US-Markt), CH-DSG + EU-DSGVO für Patientendaten.
- **M&A-Fähigkeit:** Zukäufe netzwerkseitig integrieren — *ohne* Adressraum-Kollisionen.

### 1.3 Stakeholder

| Rolle | Anforderung an die Plattform |
|---|---|
| CIO | Konsolidierung, Kostentransparenz, strategische Cloud-Quote |
| CISO | Zero-Trust, Auditierbarkeit, Segmentierung, Compliance-Nachweise |
| Head of Platform/Cloud | Betreibbarkeit, IaC, Standardisierung, Self-Service mit Leitplanken |
| Head of Data & Analytics | Fabric-Capacity, Self-Service-BI, sichere Datenpfade |
| Quality/Regulatory Affairs | Validierbarkeit (GxP-nah), Nachvollziehbarkeit, Datenintegrität |
| Datenschutzbeauftragter (DPO) | Data-Residency, Zweckbindung, Löschkonzepte |
| Werk-/OT-IT | sichere, kontrollierte Anbindung der Produktionssysteme |
| Finance/FinOps | Budget-Einhaltung, Kostenallokation je Geschäftsbereich |
| Application-Teams | schneller Self-Service-Zugang zu Netz/PaaS innerhalb von Leitplanken |

### 1.4 Compliance & Regulatorik (als Anforderung, nicht Implementierung)

- **ISO/IEC 27001** (ISMS, zertifizierungsrelevant)
- **SOC 2 Type II** (für SaaS-Kunden, v.a. US)
- **EU-DSGVO** + **CH-DSG** (Patienten-/Personendaten)
- **EU-MDR** sowie **FDA 21 CFR Part 11** (elektronische Aufzeichnungen/Signaturen, GxP-nahe Validierung) — `VERIFY`: konkreter Geltungsumfang auf die SaaS-Komponenten mit RA schärfen.
- **Microsoft Cloud Security Benchmark (MCSB)** als interne Governance-Baseline.

### 1.5 Budget- & Zeitrahmen (Constraints, keine Lösung)

- **Programmbudget Plattform-Grundschicht:** ~CHF 2,5 Mio. im 1. Jahr; laufend ~CHF 1,8 Mio./Jahr OpEx-Ziel.
- **Zeithorizont:** Landing-Zone-Grundgerüst produktiv in 6 Monaten; erste Workload-Migration nach 9 Monaten; On-Prem-RZ-Exit Ziel 30 Monate.
- **Betriebsmodell-Ziel:** zentrales Plattform-Team (≤ 8 FTE), Application-Teams konsumieren self-service.

### 1.6 Zu tragende Geschäftsfähigkeiten

- Hosting der Kunden-SaaS (multi-tenant, internetexponiert, hochverfügbar)
- Sichere weltweite Aufnahme von **Geräte-Telemetrie** (IoT-/Eventing-Last)
- **Analytics & BI** + ML für Predictive Maintenance
- **Integration On-Prem** (Fertigung, Legacy-ERP, lokale AD-Anker)
- **Partner-/B2B-Anbindung** (Service-Partner, Labore)
- M&A-Integration ohne Re-IP-Zwang

---

## 2. Workload- / Technical-Requirements (BEDARF, nicht Design)

### 2.1 Compute & Workloads

| Workload-Klasse | Bedarf (*was*, nicht *wie*) |
|---|---|
| **VMs — Legacy/Lift&Shift** | Windows-/Linux-VMs für migriertes ERP, DC-Repliken, Batch/Integration, Buildagenten; Patch-Zugang ohne direkte Internetexposition. |
| **VMs — OT-/Fertigungs-Gateways** | Wenige, stark abgeschottete Vermittler zu Produktionssystemen. |
| **AKS** | (a) Kunden-SaaS-Microservices (internet-erreichbar, mandantenfähig), (b) interne Plattform-APIs, (c) Stream-Processing für Telemetrie. Bedarf: private Cluster-Konnektivität, kontrollierter Egress, Lastskalierung. |
| **API Management** | Zentrales Gateway für externe Kunden-APIs + interne API-Föderation; getrennte interne/externe Exposure-Pfade. |
| **Web-/App-Hosting (PaaS)** | App Service / Container Apps für Frontends, Admin-/Service-Portale; private Anbindung interner Apps, kontrollierte öffentliche Exposition der Kunden-Frontends. |
| **Datenbanken** | **Azure SQL** (transaktionale SaaS-Kerndaten), **PostgreSQL Flexible Server** (Dienst-/Telemetrie-Metadaten). Ausschliesslich privat erreichbar. |
| **Caching** | Azure Cache for Redis (SaaS-Session/Hot-Path), privat. |
| **Storage** | Blob (Telemetrie-Rohdaten, Backups, Artefakte), Data Lake Gen2 (Analytics-Landing), Files (Legacy-Shares). Private Datenpfade, Lifecycle-/Residency-Kontrolle. |
| **Messaging / Eventing** | **Event Hubs** (Telemetrie-Ingestion, hoher Durchsatz), **Service Bus** (interne Entkopplung), optional **Event Grid**. Privat erreichbar. |
| **Microsoft Fabric Capacity** | Einheitliche Data-Platform: Telemetrie-Aufbereitung (Lakehouse/Notebooks), Self-Service-BI (Power BI), Data Engineering, perspektivisch Real-Time Intelligence. Bedarf: sichere, möglichst private Datenanbindung; klare Capacity-Dimensionierung + Kostenkontrolle. |
| **AI/ML** | Azure ML / Azure OpenAI für Predictive-Maintenance + interne Assistenz. Private Anbindung, Data-Residency der Trainingsdaten. `VERIFY`: Modell-/Regionsverfügbarkeit zum Bauzeitpunkt. |

### 2.2 Konnektivität (Bedarf)

| Kategorie | Bedarf |
|---|---|
| **On-Prem-Anbindung** | Redundant, latenzarm zu beiden RZ. **ExpressRoute** als Produktionsziel (Bandbreite + SLA), **Site-to-Site VPN** als Backup/Übergang + kleine Standorte. BGP-fähig. |
| **Branch-Anbindung** | Genf/München/Boston/Singapur gemanagt anbinden; User-zu-App-Pfade für interne Apps ohne Internet-Umweg. |
| **Private PaaS-Konnektivität** | Alle PaaS-Dienste (SQL, PostgreSQL, Storage, Key Vault, Event Hubs, Service Bus, ACR, interne App Services) über **Private Endpoints**; keine öffentlichen Datenpfade für interne/Patientendaten. |
| **Internet-Ingress** | Kontrollierter, WAF-geschützter Eingang für öffentliche SaaS + öffentliche APIs. |
| **Internet-Egress** | Zentral kontrolliert, gefiltert, protokolliert (Allow-Listing, Egress-Inspektion). Kein unkontrollierter Direkt-Egress. |
| **Inter-Region** | Sichere private Verbindung Primär↔Sekundär für DR-Replikation + regionsübergreifende Dienste. |
| **DNS** | Hybride Namensauflösung: Private-Endpoint-FQDNs aus Azure **und** On-Prem auflösbar; Forwarding beidseitig. |

### 2.3 Identität, Secrets, Observability, Backup/DR (Bedarf)

| Kategorie | Bedarf |
|---|---|
| **Identität** | **Microsoft Entra ID** als zentrales IdP; Hybrid-Anbindung On-Prem-AD; Conditional Access; PIM für privilegierten Zugriff; Workload-Identities. |
| **Secrets/Keys** | **Azure Key Vault** für Secrets/Zertifikate/Schlüssel; CMK-Fähigkeit; nur privater Zugriff. |
| **Observability** | Zentrales Log/Metrik-Sammeln (Azure Monitor / Log Analytics), Netzwerk-Flow-Sichtbarkeit, manipulationssichere Langzeit-Aufbewahrung für Audit/Forensik. |
| **Backup/DR** | Backups für VMs, DBs, Storage; regionsübergreifende DR; definierte Wiederherstellungsziele (§3). |
| **Governance/Policy** | Plattformweite Leitplanken (Policy-as-Code), erzwungene Namens-/Tagging-/Residency-Regeln, präventive Verhinderung öffentlicher Endpunkte. |

---

## 3. Non-functional / nichttechnische Requirements

| # | Requirement | Zielwert / Aussage |
|---|---|---|
| NFR-01 | Verfügbarkeit Kunden-SaaS | ≥ 99,9 % monatlich, zonenredundant in der Primärregion. |
| NFR-02 | Verfügbarkeit Plattform-Kerndienste (DNS, Konnektivität, Identität) | ≥ 99,95 %; keine Single-Zone-Abhängigkeit. |
| NFR-03 | RTO | Kritische SaaS-Dienste ≤ 4 h; Plattform-Grundkonnektivität ≤ 1 h. |
| NFR-04 | RPO | Transaktionsdaten ≤ 15 min; Telemetrie-Rohdaten ≤ 1 h; Analytics ≤ 24 h. |
| NFR-05 | Latenz | Interne App-zu-DB-Pfade < 5 ms innerhalb Region; On-Prem↔Azure-Produktivpfad < 25 ms (ExpressRoute-Ziel). `VERIFY` standortabhängig. |
| NFR-06 | Skalierbarkeit | Telemetrie-Ingestion nimmt Spitzen des 5-fachen Tagesmittels verlustfrei auf; SaaS horizontal skalierbar. |
| NFR-07 | Security / Zero-Trust | „Assume breach"; keine impliziten Trust-Zonen; Mikrosegmentierung; least privilege; keine öffentlichen Datenendpunkte; jeder Zugriff authentifiziert + autorisiert. |
| NFR-08 | Data-Residency | EU-/CH-Patientendaten in EU/CH-Regionen; US-Marktdaten getrennt; keine Verarbeitung ausserhalb genehmigter Geographien. |
| NFR-09 | Auditierbarkeit | Lückenlose, manipulationssichere Protokollierung; Aufbewahrung ≥ 1 Jahr online, ≥ 7 Jahre archiviert. `VERIFY` Frist mit RA/Legal. |
| NFR-10 | Kostenkontrolle / FinOps | Kostenallokation je BU/Umgebung via Tagging; Budget-Alerts; Fabric-Capacity mit Pause/Resize. |
| NFR-11 | Betrieb / Governance | Alles als IaC; präventive Policies; standardisierte Self-Service-Bereitstellung mit Leitplanken. |
| NFR-12 | Compliance-Frameworks | ISO 27001, SOC 2, DSGVO/DSG, EU-MDR; FDA 21 CFR Part 11 für relevante Komponenten (§1.4). |
| NFR-13 | Wartbarkeit / Reproduzierbarkeit | Jede Umgebung deterministisch aus Code reproduzierbar; Drift-Erkennung. |
| NFR-14 | M&A-/Wachstums-Headroom | Adressraum + Namens-/Zonenkonzept nehmen Zukäufe + neue Regionen ohne Re-Design auf. |

---

## 4. Parametrisierung (gegebene Inputs / Constraints)

> Konkrete, kollisionsfreie Werte als **Eingaben** in den Architektur-Entwurf, nicht als Ergebnis.
> Subnetzaufteilung und Ressourcenplatzierung sind hier **bewusst nicht** enthalten.

### 4.1 Azure-Adressraum-Allokation (zugeteilt, mit Wachstumsreserve)

| Zweck (Allokation) | CIDR | Bemerkung |
|---|---|---|
| **Azure-Gesamtblock (Supernet)** | `10.16.0.0/12` (`10.16.0.0`–`10.31.255.255`) | Reserviert für Wachstum/M&A/neue Regionen. |
| Region Primär (West Europe) — Pool | `10.16.0.0/14` | Reservepool Primärregion. |
| Region Sekundär (North Europe) — Pool | `10.20.0.0/14` | Reservepool Sekundärregion. |
| Region US (East US 2) — Pool | `10.24.0.0/15` | US-Marktdaten-Trennung. |
| Region APAC (Southeast Asia) — Pool | `10.26.0.0/16` | APAC-Wachstum. |
| Reserve / M&A / future | `10.28.0.0/14` | Unzugeteilter Headroom. |

> Diese Spalte benennt nur grobe **Pools/Reserven** als Input. Welche VNets/Subnetze/Gateways daraus entstehen, ist Lösung.

### 4.2 On-Prem-Adressräume (gegeben, kollisionsfrei zu Azure)

| Standort / RZ | CIDR | Bemerkung |
|---|---|---|
| On-Prem RZ Zürich (primär) | `10.4.0.0/16` | Produktion On-Prem. |
| On-Prem RZ Bern (Co-Location) | `10.5.0.0/16` | Ausweich/DR. |
| Campus/User Zürich HQ | `10.8.0.0/16` | Clients. |
| Standort Genf | `10.9.0.0/16` | |
| Standort München | `10.10.0.0/16` | |
| Standort Boston | `10.12.0.0/16` | |
| Standort Singapur | `10.13.0.0/16` | |
| OT-/Fertigungsnetz Zürich | `172.20.0.0/16` | Bewusst eigener Block, streng segmentiert. |

> On-Prem liegt in `10.4.0.0/14` + `10.8.0.0/13`-Bereich + `172.20.0.0/16` und **überschneidet sich nicht** mit dem Azure-Block `10.16.0.0/12`.

### 4.3 WAN / öffentliche IP-Adressen

| Element | Wert | Bemerkung |
|---|---|---|
| Öffentlicher Adressblock (eigen, PI) | `203.0.113.0/24` | Doku-Beispielblock (RFC 5737) — reale PI-Werte später ersetzen. |
| Primärer Internet-Breakout HQ | `203.0.113.10` | On-Prem-Edge. |
| ExpressRoute Peering ASN (Kunde) | `65010` | privater ASN (RFC 6996). |
| ExpressRoute Microsoft Peering ASN | `12076` | von Microsoft fest vergeben. `VERIFY`. |
| On-Prem BGP Router-IDs | aus `10.4.0.0/16` / `10.5.0.0/16` | konkret im Konnektivitäts-Schritt. |

### 4.4 Azure-Regionen

| Rolle | Region | Begründung (Input) |
|---|---|---|
| Primär | **West Europe** | Nähe CH/EU, Fabric-/PaaS-Verfügbarkeit, Zonenredundanz. |
| Sekundär (DR) | **North Europe** | EU-Residency, etabliertes Pairing zu West Europe. `VERIFY` Region-Pairing. |
| US-Markt | **East US 2** | FDA-Marktdaten-Trennung. |
| APAC | **Southeast Asia** | APAC-Vertrieb/Latenz. |

> Residency-Constraint (NFR-08): EU/CH-Patientendaten nur in West/North Europe; CH-spezifisch ggf. **Switzerland North** — `VERIFY` Fabric-/Dienst-Verfügbarkeit dort.

### 4.5 Umgebungen

| Umgebung | Kürzel | Zweck | Daten |
|---|---|---|---|
| Production | `prod` | Live-SaaS, Live-Analytics | echte/Patientendaten |
| Test/Staging | `test` | Vorabnahme, Last-/Integrationstests | anonymisiert/synthetisch |
| Development | `dev` | Entwicklung | synthetisch |
| Sandbox | `sbx` | Experimente, kurzlebig | keine echten Daten |

### 4.6 Namenskonvention (Input-Schema)

Schema: `{org}-{workload}-{env}-{region}-{type}-{instance}`

| Token | Werte (gegeben) |
|---|---|
| `org` | `hmt` |
| `env` | `prod` \| `test` \| `dev` \| `sbx` |
| `region` | `weu`, `neu`, `eus2`, `sea`, `chn` |
| `type` | `vnet`, `snet`, `rg`, `kv`, `sql`, `pg`, `st`, `aks`, `apim`, `evh`, `sb`, `fab` … |
| `instance` | `001`, `002`, … |

Beispiele (nur Schema-Illustration, keine Topologie): `hmt-shared-prod-weu-rg-001`, `hmt-data-prod-weu-fab-001`.

### 4.7 Tagging-Konvention (Pflicht-Tags)

| Tag | Beispielwerte | Zweck |
|---|---|---|
| `environment` | prod/test/dev/sbx | Lifecycle |
| `costCenter` | `CC-SAAS`, `CC-DATA`, `CC-PLATFORM` | FinOps (NFR-10) |
| `dataClassification` | `public`/`internal`/`confidential`/`restricted-patient` | Residency/Security |
| `owner` | Team-/Mailalias | Verantwortung |
| `compliance` | `mdr`,`gdpr`,`soc2`,`part11` | Audit-Scoping |
| `businessUnit` | `Diagnostics`,`SaaS`,`Service` | Allokation |

### 4.8 DNS-Domänen & Private-DNS-Zonen-Bedarf

**Domänen (gegeben):**

| Zweck | Domain |
|---|---|
| Corporate (öffentlich) | `helvetia-medtech.com` (fiktiv) |
| Kunden-SaaS (öffentlich) | `app.hmt-diagnostics.com` (fiktiv) |
| Interne AD-Domäne (On-Prem) | `corp.hmtgroup.local` |
| Interne Azure-Privatzone (Corp) | `azure.hmtgroup.internal` |

**Benötigte Azure-Private-DNS-Zonen** (Microsoft-vorgegebene Zonennamen, gegen MS Learn verifiziert, Public Commercial Cloud):

| Dienst (Bedarf) | Private-DNS-Zone |
|---|---|
| Azure SQL Database | `privatelink.database.windows.net` |
| PostgreSQL Flexible Server | `privatelink.postgres.database.azure.com` |
| Blob Storage | `privatelink.blob.core.windows.net` |
| Data Lake Gen2 | `privatelink.dfs.core.windows.net` |
| File Storage | `privatelink.file.core.windows.net` |
| Key Vault | `privatelink.vaultcore.azure.net` |
| AKS API-Server | `privatelink.{regionName}.azmk8s.io` |
| Container Registry | `privatelink.azurecr.io` |
| App Service / Web Apps | `privatelink.azurewebsites.net` |
| Event Hubs / Service Bus | `privatelink.servicebus.windows.net` |
| Azure Cache for Redis | `privatelink.redis.cache.windows.net` |
| Azure Monitor (AMPLS) | `privatelink.monitor.azure.com` (+ zugehörige oms/ods/agentsvc-Zonen) |

> Ob für jeden Dienst tatsächlich eine Zone angelegt wird, ist Lösungsentscheidung.

### 4.9 Microsoft Fabric — Parametrisierung (Bedarf, keine Platzierung)

| Parameter | Wert (Input) | Bemerkung |
|---|---|---|
| Tenant-Home-Region | West Europe | bestimmt Standard-Residenz der Fabric-Metadaten. `VERIFY`. |
| Geplante Capacity-Grösse (Start) | **F64** | Schwelle, ab der Power-BI-Inhalte ohne Pro-Lizenz je Betrachter verteilbar sind (verifiziert). |
| Skalierungsband | F32 ↔ F128 | Pause/Resize zur Kostensteuerung (NFR-10). |
| Verfügbare F-SKUs (Referenz) | F2, F4, F8, F16, F32, F64, F128, F256, F512, F1024, F2048 | verifiziert (MS Learn). |
| Residency-Constraint | EU-Region(en) | Patientendaten-Analytics nur in EU; ggf. dedizierte Capacity je Geographie. |

### 4.10 Konsistenz-/Kollisions-Check (Inputs)

- Azure `10.16.0.0/12` ∩ On-Prem (`10.4.0.0/14`, `10.8.0.0/16`–`10.13.0.0/16`, `172.20.0.0/16`) = **leer** → kollisionsfrei.
- US-/APAC-Pools innerhalb des Azure-Supernets → kein gegenseitiger Overlap.
- Öffentliche IPs und ASN getrennt von privaten Bereichen.

---

## Verifizierte Quellen (MS Learn)
- *Azure Private Endpoint private DNS zone values* → §4.8
- *Understand Microsoft Fabric licenses / Capacity & SKUs* → §4.9 (F-SKUs, F64-Schwelle)
- *Fabric features parity* (Pause/Resume, Resizing) → NFR-10
- *Fabric region availability* → §4.4/§4.9 `VERIFY`-Hinweise

## Offene `VERIFY`-Punkte vor Contribution
21-CFR-Part-11-Scope (§1.4) · Latenz-Annahmen (NFR-05) · Audit-Fristen (NFR-09) ·
Azure-OpenAI-Verfügbarkeit (§2.1) · Region-Pairing WEU/NEU (§4.4) · Switzerland-North-Dienst-/Fabric-Verfügbarkeit (§4.4/§4.9) · ExpressRoute-MS-ASN 12076 (§4.3) · Tenant-Home-Region (§4.9).
