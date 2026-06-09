#!/usr/bin/env bash
# Ab Stufe 5: NORMALES Claude-Config (oh-my-claudecode-Plugin aktiv → OMC-Agents verfügbar).
# Kein CLAUDE_CONFIG_DIR-Override. Arbeitsverzeichnis = dieser Ordner.
set -euo pipefail
cd "$(cd "$(dirname "$0")" && pwd)"
exec claude "$@"
