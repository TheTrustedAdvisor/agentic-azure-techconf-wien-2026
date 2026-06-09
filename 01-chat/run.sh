#!/usr/bin/env bash
# Startet Claude isoliert (kein Plugin, kein globales MCP), Arbeitsverzeichnis = dieser Ordner.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"
CFG="$ROOT/.claude-demo"
[ -d "$CFG" ] || { echo "Zuerst im Repo-Root ./setup.sh ausfuehren (einmal einloggen)."; exit 1; }
cd "$HERE"
exec env CLAUDE_CONFIG_DIR="$CFG" claude "$@"
