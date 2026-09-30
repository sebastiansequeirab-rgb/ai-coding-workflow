# Foto 0003 — ai-coding-workflow, antes y después de la limpieza (spec 0004)

Medición: sesión limpia `claude -p "responde solo: ok" --output-format stream-json --verbose` en la
raíz del repo, con el árbol de git limpio, suma de los tokens del campo `usage` del primer turno.
Con cambios sin commitear el número sube (la lista entra al arranque): medido 23,778 a mitad de
camino, por eso la de después se tomó tras el commit `0d24f38`.

| | Antes (`e37f9d2`) | Después (`0d24f38`) |
|---|---|---|
| Arranque | 23,461 | 23,436 y 23,438 (dos corridas) |
| `AGENTS.md` raíz | 4,232 bytes / 78 líneas | 4,206 / 75 |
| `aprendizaje/AGENTS.md` | 3,269 / 53 | 2,625 / 47 |
| `PLAYBOOK.md` | 14,425 / 226 | 15,843 / 244 (suma las reglas de la entrevista, quita pendientes) |
| Archivos en `aprendizaje/` fuera de registros y `archivo/` | 5 `.md` | 2 (`AGENTS.md`, `RESOURCES.md`) |
| `docs/guias/` | 3 | 2 |
| Referencias vivas a skills archivadas | README, `aprendizaje/AGENTS.md`, `RESOURCES.md` | solo la lista de archivadas del PLAYBOOK |

**Diferencia:** −24 tokens de arranque, dentro del ruido. Era lo esperado: del repo solo carga el
`AGENTS.md` raíz (~1.2k). La ganancia de esta limpieza es de coherencia, no de tokens. Lo que más
pesa del arranque sigue siendo el piso de Claude Code.

Chequeos de la spec 0004: `grep` de skills archivadas fuera de lo histórico, solo en el inventario
del PLAYBOOK; rutas citadas en `AGENTS.md`, `aprendizaje/AGENTS.md`, `README.md` y PLAYBOOK
revisadas con un script (las que no existen aquí son de otros repos o futuras, como
`aprendizaje/lessons/`); `AGENTS.md` raíz nombra `docs/repos.md`; commit `02af7c2` en `~/.claude`.
