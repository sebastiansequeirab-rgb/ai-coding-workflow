#!/usr/bin/env bash
# PreToolUse (Write|Edit) — avisa si se está tocando código en un repo sin AGENTS.md.
# Avisa, NO bloquea. Una sola vez por sesión, para no volverse ruido.
set -uo pipefail

entrada=$(cat)
archivo=$(printf '%s' "$entrada" | jq -r '.tool_input.file_path // empty')
sesion=$(printf '%s' "$entrada" | jq -r '.session_id // "x"')
[ -z "$archivo" ] && exit 0

# Solo archivos de código; documentación y config no cuentan.
case "$archivo" in
  *.ts|*.tsx|*.js|*.jsx|*.mjs|*.cjs|*.py|*.go|*.rs|*.java|*.kt|*.swift|*.rb|*.php|*.vue|*.svelte|*.dart) ;;
  *) exit 0 ;;
esac

dir="${CLAUDE_PROJECT_DIR:-$PWD}"
cd "$dir" 2>/dev/null || exit 0
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0
[ -f AGENTS.md ] && exit 0

marca="/tmp/claude-aviso-agents-${sesion}"
[ -f "$marca" ] && exit 0
touch "$marca"

jq -n '{systemMessage: "⚠️  Este repo no tiene AGENTS.md y ya se está tocando código. El agente está trabajando sin conocer tus convenciones. Corre /audit cuando puedas: arma el AGENTS.md desde el código."}'
