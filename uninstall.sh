#!/usr/bin/env bash
# Deshace install.sh: devuelve ~/.claude a como estaba antes de la primera instalación.
#
#   ./uninstall.sh                                          usa el respaldo de la primera instalación
#   ./uninstall.sh ~/.claude/backups/workflow-20261001-1200 usa ese respaldo
#
# Las skills de terceros no se quitan solas. Si quieres: npx skills remove -g <nombre>
set -euo pipefail

DESTINO="$HOME/.claude"
MARCA="$DESTINO/.workflow-respaldo"
RESPALDO="${1:-$(cat "$MARCA" 2>/dev/null || ls -d "$DESTINO"/backups/workflow-* 2>/dev/null | sort | head -1)}"
[ -d "$RESPALDO" ] || { echo "No encuentro respaldo del workflow en $DESTINO/backups/"; exit 1; }
echo "Restaurando desde $RESPALDO"

# Lo que el instalador creó y no existía antes: se borra
if [ -f "$RESPALDO/.creados" ]; then
  while IFS= read -r rel; do
    [ -n "$rel" ] && rm -f "$DESTINO/$rel" && echo "  borrado  $rel"
  done < "$RESPALDO/.creados"
fi

# Lo que existía: vuelve como estaba
(cd "$RESPALDO" && find . \( -type f -o -type l \) ! -name '.creados' ! -name '.settings-instalado.json' | sed 's#^\./##') |
while IFS= read -r rel; do
  mkdir -p "$DESTINO/$(dirname "$rel")"
  rm -f "$DESTINO/$rel"
  cp -P "$RESPALDO/$rel" "$DESTINO/$rel"
  echo "  restaurado $rel"
done

# La línea de import que el instalador sumó a un CLAUDE.md ajeno ya viene quitada con el restaurado.
rm -f "$MARCA"
echo "Listo."
