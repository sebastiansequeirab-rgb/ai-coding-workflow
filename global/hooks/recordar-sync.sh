#!/usr/bin/env bash
# Stop — recuerda /sync cuando hubo trabajo de verdad y el repo quedó sin reconciliar.
# Throttle de 25 minutos por sesión: avisa poco, para que cuando avise se lea.
set -uo pipefail

entrada=$(cat)
sesion=$(printf '%s' "$entrada" | jq -r '.session_id // "x"')

dir="${CLAUDE_PROJECT_DIR:-$PWD}"
cd "$dir" 2>/dev/null || exit 0
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0

# ¿Hubo trabajo de verdad? 3+ archivos de trabajo (código o markdown) tocados y sin commitear.
tocados=$(git status --porcelain 2>/dev/null \
  | grep -cE '\.(ts|tsx|js|jsx|mjs|cjs|py|go|rs|java|kt|swift|rb|php|vue|svelte|dart|md|mdx|markdown)$')
[ "$tocados" -lt 3 ] && exit 0

marca="/tmp/claude-sync-${sesion}"
if [ -f "$marca" ]; then
  ahora=$(date +%s)
  antes=$(cat "$marca" 2>/dev/null || echo 0)
  [ $((ahora - antes)) -lt 1500 ] && exit 0
fi
date +%s > "$marca"

jq -n --arg n "$tocados" \
  '{systemMessage: ("🔄  Llevas " + $n + " archivos de trabajo sin commitear. Si el cambio ya está listo para mergear, /sync deja AGENTS.md y el scope al día. Si es un cambio chico, con el commit basta.")}'
