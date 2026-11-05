#!/usr/bin/env bash
# Install these skills into a skills directory an AI coding agent reads.
#
# Usage:
#   ./install.sh                 # → ~/.config/opencode/skills   (OpenCode, global)
#   ./install.sh agents          # → ~/.agents/skills            (cross-agent dir: OpenCode, Claude Code, …)
#   ./install.sh claude          # → ~/.claude/skills            (Claude Code)
#   ./install.sh <path>          # → any directory (e.g. a project's .opencode/skills)
#   ./install.sh --help
#
# Copy-mode only: existing skills are added/updated, nothing is ever deleted.
# To remove a skill, delete its <skill-id> directory in the target.

set -euo pipefail

SRC="$(cd "$(dirname "$0")/skills" && pwd)"

case "${1:-opencode}" in
  opencode) DEST="$HOME/.config/opencode/skills" ;;
  agents)   DEST="$HOME/.agents/skills" ;;
  claude)   DEST="$HOME/.claude/skills" ;;
  -h|--help) grep '^#' "$0" | sed 's/^# \{0,1\}//' ; exit 0 ;;
  *)        DEST="$1" ;;
esac

mkdir -p "$DEST"

if command -v rsync >/dev/null 2>&1; then
  rsync -a "$SRC"/ "$DEST"/
else
  cp -a "$SRC"/. "$DEST"/
fi

echo "Installed $(find "$SRC" -mindepth 1 -maxdepth 1 -type d | wc -l) skills into $DEST"
echo "OpenCode picks up skill changes on /reload."
