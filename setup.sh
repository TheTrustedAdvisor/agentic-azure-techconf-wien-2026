#!/usr/bin/env bash
# Einmaliges Setup: isoliertes Claude-Config-Verzeichnis fuer die Demo.
# Kein oh-my-claudecode-Plugin, kein globales MCP — ein "nacktes" Claude.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
CFG="$ROOT/.claude-demo"
mkdir -p "$CFG"
echo "Isoliertes Demo-Config: $CFG"
echo "Bitte EINMAL einloggen (/login), dann beenden. Danach: in einen Stufen-Ordner wechseln und ./run.sh"
exec env CLAUDE_CONFIG_DIR="$CFG" claude
