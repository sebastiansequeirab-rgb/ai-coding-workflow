#!/usr/bin/env bash
# Instala el workflow en ~/.claude sin pisar lo que ya tienes.
# Respalda antes de tocar, mezcla settings.json en vez de reemplazarlo y nunca toca tu personal.md.
#
#   ./install.sh                 instala copiando los archivos
#   ./install.sh --dry-run       muestra lo que haría, sin tocar nada
#   ./install.sh --link          enlaza CLAUDE.md y hooks al repo (para quien mantiene el repo)
#   ./install.sh --con-firecrawl suma las skills de Firecrawl (piden API key)
#   ./install.sh --sin-skills    no instala las skills de terceros
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DESTINO="$HOME/.claude"
AGENTES_URL="https://raw.githubusercontent.com/jsmastery-pro/skills/main/.claude/agents"
SECO=0; ENLAZAR=0; FIRECRAWL=0; SKILLS=1

for arg in "$@"; do
  case "$arg" in
    --dry-run) SECO=1 ;;
    --link) ENLAZAR=1 ;;
    --con-firecrawl) FIRECRAWL=1 ;;
    --sin-skills) SKILLS=0 ;;
    -h|--help) sed -n '2,10p' "$0"; exit 0 ;;
    *) echo "Opción desconocida: $arg (usa --help)"; exit 1 ;;
  esac
done

hacer() { if [ "$SECO" = 1 ]; then local t="$*"; echo "  [dry-run] ${t//$DESTINO/~/.claude}"; else eval "$@"; fi; }
paso() { echo "→ $*"; }

# 1. Requisitos
faltan=""
for cmd in jq git curl; do command -v "$cmd" >/dev/null || faltan="$faltan $cmd"; done
[ "$SKILLS" = 1 ] && { command -v npx >/dev/null || faltan="$faltan npx(Node.js)"; }
[ -n "$faltan" ] && { echo "Falta instalar:$faltan"; exit 1; }
command -v claude >/dev/null || echo "Aviso: no encuentro 'claude' en el PATH. El workflow queda instalado igual."
[ "$REPO" != "$HOME/ai-coding-workflow" ] && \
  echo "Aviso: el CLAUDE.md apunta a ~/ai-coding-workflow/PLAYBOOK.md y el repo está en $REPO."

# 2. Respaldo de lo que existe, y lista de lo que se va a crear (para desinstalar)
# Si ya se instaló antes, el respaldo que vale es el de la primera vez: es lo que tenías antes del workflow.
MARCA="$DESTINO/.workflow-respaldo"
REINSTALA=0
if [ -f "$MARCA" ] && [ -d "$(cat "$MARCA")" ]; then
  RESPALDO="$(cat "$MARCA")"; REINSTALA=1
  paso "Ya estaba instalado: se actualiza. Tu respaldo original sigue en $RESPALDO"
else
  RESPALDO="$DESTINO/backups/workflow-$(date +%Y%m%d-%H%M%S)"
  paso "Respaldo en $RESPALDO"
fi
hacer "mkdir -p '$RESPALDO' '$DESTINO/hooks' '$DESTINO/agents'"
creados=()
respaldar() {
  [ "$REINSTALA" = 1 ] && return 0
  local rel="$1"
  if [ -e "$DESTINO/$rel" ] || [ -L "$DESTINO/$rel" ]; then
    hacer "mkdir -p '$RESPALDO/$(dirname "$rel")' && cp -RP '$DESTINO/$rel' '$RESPALDO/$rel'"
  else
    creados+=("$rel")
  fi
}
for rel in CLAUDE.md settings.json workflow-CLAUDE.md personal.md \
  hooks/arranque-repo.sh hooks/aviso-agents.sh hooks/recordar-sync.sh \
  agents/scout.md agents/researcher.md; do
  respaldar "$rel"
done

# Copia o enlace, según el modo
poner() {
  local origen="$1" rel="$2"
  if [ "$ENLAZAR" = 1 ]; then hacer "ln -sfn '$origen' '$DESTINO/$rel'"
  else hacer "rm -f '$DESTINO/$rel' && cp '$origen' '$DESTINO/$rel'"; fi
}

# 3. Hooks
paso "Hooks: arranque-repo, aviso-agents, recordar-sync (solo avisan, nunca bloquean)"
for h in "$REPO"/global/hooks/*.sh; do
  poner "$h" "hooks/$(basename "$h")"
  [ "$ENLAZAR" = 0 ] && hacer "chmod +x '$DESTINO/hooks/$(basename "$h")'"
done

# 4. Subagentes scout y researcher, bajados de su fuente (JS Mastery, MIT)
paso "Subagentes scout y researcher desde jsmastery-pro/skills"
for a in scout researcher; do
  hacer "curl -fsSL '$AGENTES_URL/$a.md' -o '$DESTINO/agents/$a.md'"
done

# 5. CLAUDE.md
if [ "$ENLAZAR" = 1 ]; then
  paso "CLAUDE.md enlazado al repo (tu versión anterior quedó en el respaldo)"
  poner "$REPO/global/CLAUDE.md" "CLAUDE.md"
elif [ ! -e "$DESTINO/CLAUDE.md" ]; then
  paso "CLAUDE.md nuevo"
  poner "$REPO/global/CLAUDE.md" "CLAUDE.md"
else
  paso "Ya tienes CLAUDE.md: no se pisa. El workflow va a workflow-CLAUDE.md y se importa desde el tuyo"
  poner "$REPO/global/CLAUDE.md" "workflow-CLAUDE.md"
  grep -qF '@~/.claude/workflow-CLAUDE.md' "$DESTINO/CLAUDE.md" 2>/dev/null || \
    hacer "printf '\n@~/.claude/workflow-CLAUDE.md\n' >> '$DESTINO/CLAUDE.md'"
fi

# 6. personal.md: solo si no existe
if [ ! -e "$DESTINO/personal.md" ]; then
  paso "personal.md creado desde la plantilla: llénalo con tu idioma, quién eres y tus repos"
  hacer "cp '$REPO/global/personal.ejemplo.md' '$DESTINO/personal.md'"
else
  paso "personal.md ya existe: no se toca"
fi

# 7. settings.json: se mezcla. Lo tuyo gana; las listas (deny, hooks) se suman sin duplicar
paso "settings.json mezclado (lo que ya tenías se conserva)"
actual="$DESTINO/settings.json"
[ -f "$actual" ] || actual=/dev/null
usuario=$(cat "$actual" 2>/dev/null || true); [ -n "$usuario" ] || usuario="{}"
mezcla=$(jq -n --argjson u "$usuario" --slurpfile wf "$REPO/global/settings.json" '
  $wf[0] as $w
  | def nombre: split("/") | last;
  ($w * $u)
  | .permissions.deny = ((($u.permissions.deny // []) + ($w.permissions.deny // [])) | unique)
  | .hooks = reduce ($w.hooks | keys[]) as $ev (($u.hooks // {});
      .[$ev] = ((.[$ev] // []) as $cur
        | ([$cur[].hooks[]?.command | nombre]) as $ya
        | $cur + [$w.hooks[$ev][] | select(([.hooks[].command | nombre] - $ya) | length > 0)]))
')
if [ "$SECO" = 1 ]; then
  echo "  [dry-run] settings.json quedaría así:"; echo "$mezcla" | sed 's/^/    /'
else
  echo "$mezcla" > "$DESTINO/settings.json"
fi

# 8. Skills de terceros (MIT), instaladas desde su fuente
if [ "$SKILLS" = 1 ]; then
  paso "Skills de JS Mastery y Matt Pocock (npx, puede tardar ~1 min)"
  hacer "npx -y skills@latest add jsmastery-pro/skills -a claude-code -g -y"
  hacer "npx -y skills@latest add mattpocock/skills -s grill-me -s grilling -s domain-modeling -s prototype -s handoff -a claude-code -g -y"
  [ "$FIRECRAWL" = 1 ] && hacer "npx -y skills@latest add firecrawl/cli -a claude-code -g -y"
fi

# 9. Manifiesto para desinstalar (solo la primera vez)
if [ "$SECO" = 0 ] && [ "$REINSTALA" = 0 ]; then
  echo "$RESPALDO" > "$MARCA"
  printf '%s\n' "${creados[@]+"${creados[@]}"}" > "$RESPALDO/.creados"
  cp -P "$DESTINO/settings.json" "$RESPALDO/.settings-instalado.json" 2>/dev/null || true
  [ "$actual" = /dev/null ] && echo settings.json >> "$RESPALDO/.creados"
fi

echo
echo "Listo. Abre Claude Code en cualquier repo."
echo "  1. Llena ~/.claude/personal.md (idioma, quién eres, tus repos)."
echo "  2. Lee PLAYBOOK.md para entender los dos modos."
echo "  3. Para deshacer: ./uninstall.sh (restaura $RESPALDO)."
