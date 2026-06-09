# Stufe 1 — Chat: Prompt zum Live-Ausführen

Diesen Prompt live ins Chat (Claude / ChatGPT / Copilot) einfügen — zusammen mit dem Inhalt von [`../AUSGANGSLAGE.md`](../AUSGANGSLAGE.md). Kein Tool, keine Anbindung.

---

```text
Du bist Senior Azure Network Architect. Auf Basis der folgenden Ausgangslage
(Requirements + Parametrisierung) entwirf die vollständige Azure-Netzwerk- und
Plattform-Architektur für die Helvetia MedTech Group AG.

Liefere:
1. Designprinzipien (abgeleitet aus den Requirements)
2. Topologie (Hub-Spoke je Region, Primär = West Europe, DR = North Europe)
3. Adressplan: VNets + Subnetze aus dem zugeteilten Block 10.16.0.0/12
4. Konnektivität: ExpressRoute, VPN, Peering, Routing/Forced Tunneling
5. Private Endpoints + Private-DNS-Zonen + DNS Private Resolver (Hybrid)
6. Ingress (Front Door / App Gateway / WAF) und API Management
7. Workload-Platzierung (AKS, VMs, App Service, Event Hubs)
8. Daten + Microsoft Fabric Capacity (private Anbindung)
9. Identität, Security, Observability, DR
10. Governance (Policy, IaC)

Halte dich strikt an die Parametrisierung (IP-Ranges, Regionen, Namens-/Tagging-
Konventionen). Antworte auf Deutsch, mit konkreten CIDRs und einem Mermaid-Topologie-
Diagramm.

--- AUSGANGSLAGE ---
[Inhalt von AUSGANGSLAGE.md hier einfügen]
```
