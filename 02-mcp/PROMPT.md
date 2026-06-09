# Stufe 2 — MCP: Prompt zum Live-Ausführen

Jetzt hat Claude über den Microsoft-Learn-MCP **Zugriff auf echte, aktuelle Doku**. Damit erden wir den Stufe-1-Entwurf: Behauptungen werden zu belegten Fakten.

---

```text
Du bist Senior Azure Network Architect mit Zugriff auf den Microsoft-Learn-MCP-Server.
Nutze ihn, um die folgenden Punkte aus dem Architektur-Entwurf gegen die AKTUELLE
Microsoft-Doku zu verifizieren und zu korrigieren — zitiere jeweils die Quelle:

1. Exakte Private-DNS-Zonennamen aller verwendeten PaaS-Dienste — inkl. der korrekten
   Zonen/Netzwerkisolation für Microsoft Fabric (Private Link / Managed Private Endpoints).
2. Region-Pairing West Europe / North Europe für DR.
3. Verfügbarkeit der benötigten Dienste/SKUs in den gewählten Regionen (insb. Fabric,
   Azure OpenAI; Switzerland North für CH-Residency).
4. API-Management-SKU-Anforderung für VNet-Integration; AKS-CNI-Optionen und ihre
   IP-Bedarfe; PostgreSQL Flexible Server: delegiertes Subnetz vs. Private Endpoint.
5. Empfehlung Hub-Spoke vs. Azure Virtual WAN für 5 Regionen + Branch-Standorte.

Gib eine korrigierte Faktenliste mit Quellenangaben aus und markiere, was sich gegenüber
dem ungeprüften Entwurf geändert hat. Deutsch.
```

> Das ist der erste echte Fähigkeitssprung gegenüber Stufe 1: **Wissen statt Behauptung.**
