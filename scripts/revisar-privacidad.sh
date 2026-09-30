#!/usr/bin/env bash
# Busca términos privados (clientes, personas, rutas) antes de que lleguen al repo público.
# La lista NO vive en el repo: publicarla revelaría lo que protege. Por defecto se lee de
# ~/.claude/personal/terminos-privados.txt (una regex por línea, # para comentarios).
#
#   scripts/revisar-privacidad.sh          revisa lo que está en stage (lo usa el pre-commit)
#   scripts/revisar-privacidad.sh --todo   revisa todos los archivos y todo el historial
set -uo pipefail

LISTA="${TERMINOS_PRIVADOS:-$HOME/.claude/personal/terminos-privados.txt}"
[ -f "$LISTA" ] || { echo "revisar-privacidad: no hay lista en $LISTA, nada que revisar."; exit 0; }
patrones=$(mktemp); trap 'rm -f "$patrones"' EXIT
grep -vE '^\s*(#|$)' "$LISTA" > "$patrones"

cd "$(git rev-parse --show-toplevel)" || exit 1
if [ "${1:-}" = "--todo" ]; then
  hallazgos=$(git ls-files -z | xargs -0 grep -nIiE -f "$patrones" 2>/dev/null)
  historial=$(git log --all -p --format='commit %h' | grep -iE -f "$patrones" | head -20)
  nombres=$(git log --all --name-only --format='' | sort -u | grep -iE -f "$patrones")
  mensajes=$(git log --all --format='%h %s%n%b' | grep -iE -f "$patrones")
  [ -n "$historial$nombres$mensajes" ] && hallazgos="$hallazgos
--- en el historial ---
$historial
$nombres
$mensajes"
else
  hallazgos=$(git diff --cached -U0 --no-color | grep -E '^\+' | grep -iE -f "$patrones")
  nombres=$(git diff --cached --name-only | grep -iE -f "$patrones")
  [ -n "$nombres" ] && hallazgos="$hallazgos
$nombres"
fi

hallazgos=$(printf '%s' "$hallazgos" | sed '/^\s*$/d')
if [ -n "$hallazgos" ]; then
  echo "revisar-privacidad: hay términos privados. Redacta antes de seguir:"
  printf '%s\n' "$hallazgos" | cut -c1-200
  exit 1
fi
echo "revisar-privacidad: limpio."
