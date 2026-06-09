# Ressourcen — zum Vertiefen

> Kuratiert, kein Link-Dump. Jeder Eintrag mit einem Satz „warum lesen".
> Azure-Links sind gegen Microsoft Learn geprüft (Stand Workshop).

## Agentische Grundlagen (das Fundament des Workshops)

- **Anthropic — Building Effective Agents**
  https://www.anthropic.com/engineering/building-effective-agents
  *Die Pattern-Grundlage: Workflows vs. Agents, wann was. Der wichtigste Text, wenn du nur einen liest.*
- **Anthropic — Prompt Engineering (Doku)**
  https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/overview
  *Konkrete Techniken: klare Instruktionen, Beispiele, „think step by step", Rollen.*
- **Anthropic — Tool use (Doku)**
  https://docs.anthropic.com/en/docs/agents-and-tools/tool-use/overview
  *Wie `tool_use`/`tool_result` mechanisch funktionieren — das Herz des Agent-Loops.*

## MCP — Model Context Protocol

- **MCP — Einführung**
  https://modelcontextprotocol.io
  *Was MCP ist und warum „USB-C für KI-Tools": ein Protokoll, viele Quellen.*
- **MCP — Spezifikation**
  https://modelcontextprotocol.io/specification
  *Die drei Primitive (Tools/Resources/Prompts) über JSON-RPC, sauber definiert.*
- **Microsoft Learn MCP** (im Workshop auf Stufe 2 genutzt)
  https://learn.microsoft.com/training/support/mcp
  *Der MCP-Server, der echte, aktuelle MS-Doku liefert statt Trainingswissen.*

## Claude Code & OMC (das Werkzeug im Lab)

- **Claude Code — Doku & Installation**
  https://docs.anthropic.com/en/docs/claude-code/overview
  *CLI, Installation (macOS/Linux/WSL), Konfiguration, MCP-Server, eigene Agents/Skills — die Basis für Stufen 1–8.*
- **oh-my-claudecode (OMC)** — die Agent-Sammlung für **Stufen 5–8**
  *Im Workshop vorinstalliert. Beim Selbstbau ins normale `~/.claude` installieren (oh-my-claudecode-Projektseite).*

## Azure Networking (die gebaute Architektur)

- **Hub-spoke network topology in Azure** *(Referenzarchitektur)*
  https://learn.microsoft.com/azure/architecture/networking/architecture/hub-spoke
  *Genau das Muster, das wir bauen: Hub mit Firewall/Gateway, isolierte Spokes, zentraler Egress.*
- **Define an Azure network topology** *(Cloud Adoption Framework)*
  https://learn.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/define-an-azure-network-topology
  *Warum Hub-Spoke der empfohlene Default ist — die Entscheidungsgrundlage.*
- **Azure Private Endpoint — Private DNS zone values**
  https://learn.microsoft.com/azure/private-link/private-endpoint-dns
  *Die exakten `privatelink.*`-Zonennamen je Dienst. Diese Namen sind fix — nichts zum Raten.*
- **Azure Private Link — Overview**
  https://learn.microsoft.com/azure/private-link/private-link-overview
  *PaaS privat erreichbar machen, ohne öffentliche Endpunkte.*
- **Azure DNS Private Resolver**
  https://learn.microsoft.com/azure/dns/dns-private-resolver-overview
  *Wie Namen über die `privatelink`-Zonen hybrid (On-Prem ↔ Azure) aufgelöst werden.*
- **Azure Firewall — Well-Architected Service Guide**
  https://learn.microsoft.com/azure/well-architected/service-guides/azure-firewall
  *Der zentrale Egress-/Inspektionspunkt im Hub.*

## Azure Landing Zones (der Enterprise-Rahmen)

- **What is an Azure landing zone?**
  https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/
  *Hub-Spoke ist das Netzwerk-Fundament der Landing Zone — hier der grosse Rahmen.*
- **Landing zone design areas**
  https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-areas
  *Die acht Entwurfsbereiche (Identität, Netzwerk, Governance …) — was eine Architektur vollständig macht.*

## Microsoft Fabric (das optionale Daten-Finale)

- **Private links for Fabric tenants**
  https://learn.microsoft.com/fabric/security/security-private-links-overview
  *Fabric ohne öffentliches Internet — Tenant-/Workspace-Level Private Link, Grenzen & Stolpersteine.*
- **Protect inbound traffic to Microsoft Fabric tenants**
  https://learn.microsoft.com/fabric/security/protect-inbound-traffic
  *Wie die Fabric Capacity in dieselbe Zero-Trust-Logik eingebunden wird wie der Rest.*

## Workshop-Repo

- **github.com/TheTrustedAdvisor/agentic-azure-techconf-wien-2026** — alles aus diesem Workshop.
- **Fabric Friday** (YouTube @TheTrustedAdvisor) · **copilot-cockpit.com**
