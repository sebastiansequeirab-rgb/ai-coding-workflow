# ai-coding-workflow

El vocabulario del workflow. Estos términos aparecen en el `PLAYBOOK.md`, en `~/.claude/CLAUDE.md`,
en los hooks y en los registros, y significan siempre lo mismo. Si un documento usa otra palabra
para algo que ya está aquí, el documento está mal.

## Cómo se trabaja

**Modo**:
Una de las dos formas de tomar un pedido. El agente lo propone en la primera línea, Sebastián
confirma, y de ahí sale cuánto workflow aplica.
_Evitar_: fase, etapa, nivel, profundidad (esa palabra es de `/scope`, por proyecto)

**Tiro al piso**:
El modo para un bug, un ajuste visual, un texto, un diff que cabe en una oración, o "hazlo rápido".
Sin skills, sin plan, sin spec. Cambio, evidencia, commit.
_Evitar_: tarea chica, quick fix, hotfix

**Planear y crear**:
El modo para una feature o algo con varias piezas. Diálogo con propuestas, un plan corto en
archivo, aprobación, construcción. `/architect` solo ante una decisión grande de verdad.
_Evitar_: misión, proyecto, ciclo completo

**Plan corto**:
Una página en `docs/specs/NNNN-titulo.md` con tres cosas: qué se hace, qué no, y cómo sabremos que
quedó. Sale del diálogo y no crece después de aprobado. Sobrevive al auto-compact porque es un `.md`.
_Evitar_: spec (esa es la que escribe `/architect`), PRD, roadmap

**Evidencia**:
Lo que reemplaza a "listo": salida de un comando, resultado de un test, o una captura. La elige el
agente según el cambio, no por ritual. Un cambio visual chico se ve, no se captura.
_Evitar_: verificación, validación, QA

**Después**:
La lista donde va lo que aparece a mitad de un plan aprobado. El plan no crece; la lista sí.
_Evitar_: backlog, TODO

## Herramientas

**Skill**:
Un procedimiento que Claude Code carga cuando se invoca. Las de JS Mastery son sugerencias, nunca
compuertas. Set mínimo: la que no se usa se archiva en `~/.claude/skills-archive/`.
_Evitar_: comando, plugin, fase

**Subagente**:
Un agente aparte con su propio contexto. `scout` lee el repo y devuelve un mapa; `researcher`
busca en la web y devuelve un resumen. El chat principal decide y construye.
_Evitar_: worker, helper, bot

**Sync**:
Lo que hace `/sync`: poner `AGENTS.md`, el scope y las specs al día con el código. Va alrededor del
merge, no al cierre de cada chat. Un cambio chico con su commit ya está sincronizado.

## Contexto y medición

**Arranque**:
Los tokens que un chat carga antes del primer mensaje. Se mide en el campo `usage` del primer turno
del transcript en `~/.claude/projects/`. Se compara siempre en el mismo repo.
_Evitar_: contexto inicial, overhead, baseline

**Piso**:
La parte del arranque que es Claude Code mismo (prompt de sistema y herramientas base). Hoy ~28k.
No depende de nada que esté en un repo.

**Foto**:
El registro de estado de un repo en un momento dado, en `docs/reviews/NNNN-foto-*.md`, con formato
fijo para comparar antes y después de una limpieza.
_Evitar_: snapshot, auditoría, diagnóstico

**Pasada**:
Cada intento de bajar el arranque, con lo que se quitó y el número medido después. Tabla en el
PLAYBOOK, sección "Arranque liviano".

**Aviso**:
Lo que hace un hook cuando detecta algo raro (archivos sin commitear, código sin `AGENTS.md`). Los
hooks avisan y nunca bloquean, y si todo está normal, callan.
_Evitar_: alerta, error, bloqueo, orden
