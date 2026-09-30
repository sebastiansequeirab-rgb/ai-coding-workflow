#!/usr/bin/env bash
# SessionStart — avisa al abrir un chat si el repo tiene algo raro. No ordena skills ni fases:
# si todo está normal, calla.
set -uo pipefail

dir="${CLAUDE_PROJECT_DIR:-$PWD}"
cd "$dir" 2>/dev/null || exit 0
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0

hay_codigo=$(git ls-files 2>/dev/null | grep -cE '\.(ts|tsx|js|jsx|mjs|cjs|py|go|rs|java|kt|swift|rb|php|vue|svelte|dart|c|cpp|cs)$')
agents_raiz="no"; [ -f AGENTS.md ] && agents_raiz="sí"
agents_anidados=$(find . -mindepth 2 -maxdepth 3 -name AGENTS.md -not -path './node_modules/*' 2>/dev/null | wc -l | tr -d ' ')
monorepo="no"
{ [ -f pnpm-workspace.yaml ] || [ -d apps ] || [ -d packages ]; } && monorepo="sí"
sucio=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
ultimo=$(git log -1 --pretty=%s 2>/dev/null | cut -c1-70)
rama=$(git branch --show-current 2>/dev/null)

# Lo único que vale la pena avisar al arrancar.
alertas=""
[ "$hay_codigo" -gt 0 ] && [ "$agents_raiz" = "no" ] && \
  alertas="${alertas}- Hay código pero NO hay AGENTS.md: el agente no conoce las convenciones; /audit lo arma cuando quieras.
"
[ "$monorepo" = "sí" ] && [ "$agents_anidados" -eq 0 ] && [ "$hay_codigo" -gt 0 ] && \
  alertas="${alertas}- Parece monorepo y no hay AGENTS.md anidado por workspace.
"
[ "$sucio" -gt 0 ] && \
  alertas="${alertas}- Hay ${sucio} archivo(s) sin commitear de la sesión anterior.
"
# Si todo está normal, silencio: se pidió así (2026-09-27). Solo habla cuando hay algo raro.
[ -z "$alertas" ] && exit 0

contexto="AVISO DEL REPO (hook automático, no lo pidió el usuario). Rama: ${rama:-?}. Último commit: ${ultimo:-ninguno}.
${alertas}
Menciónalo en una línea al inicio de tu primera respuesta y no lo repitas. No es una orden de correr ninguna skill."

jq -n --arg ctx "$contexto" \
  '{hookSpecificOutput: {hookEventName: "SessionStart", additionalContext: $ctx}}'
