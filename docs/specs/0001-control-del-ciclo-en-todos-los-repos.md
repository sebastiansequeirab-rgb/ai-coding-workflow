# Spec 0001 — Control del ciclo en todos los repos

> **Superseded 2026-09-27** por `PLAYBOOK.md` (registro `aprendizaje/learning-records/0005`): `/brujula` archivada, los hooks solo informan y ya no ordenan ubicar el pedido en el ciclo. Se conserva como historia.

- **Fecha:** 2026-09-01
- **Decisión de:** Sebastián (nivel de control y alcance elegidos explícitamente)

## Problema

El workflow guiaba de forma pasiva. `~/.claude/CLAUDE.md` es una recomendación que el agente
puede ignorar, y `/brujula` solo corre si Sebastián la pide. Resultado medido en campo
(learning-record 0002): los rituales de apertura y cierre se aplican en Proyecto B y
no viajan a Proyecto A.

## Decisión

Tres capas, de menor a mayor fuerza:

| Capa | Qué es | Puede ignorarse |
|---|---|---|
| `~/.claude/CLAUDE.md` | Guía y ruteo del ciclo | Sí, el modelo decide |
| Output style `Concise` | Modifica el system prompt | No, pero solo afecta el tono |
| Hooks | Los ejecuta Claude Code, no el modelo | No |

**Nivel de control elegido: avisar fuerte, no bloquear.** Descartado el bloqueo duro porque
un día de apuro (hotfix) el sistema lo dejaría trancado. Revisable con evidencia: si en dos
semanas hay avisos ignorados de forma repetida, esos se convierten en bloqueo.

**Alcance: global** (`~/.claude/settings.json`), aplica a Proyecto A, Proyecto B, backoffice y a cualquier
repo nuevo sin configurar nada.

## Los tres hooks

| Hook | Evento | Qué hace | Anti-ruido |
|---|---|---|---|
| `ciclo-arranque.sh` | SessionStart | Recoge evidencia del repo (AGENTS.md, scope, specs, reviews, commits de sync, trabajo sin commitear) y la inyecta al modelo con las alertas | Solo al abrir chat |
| `aviso-agents.sh` | PreToolUse `Write\|Edit` | Si se toca un archivo de código en un repo sin `AGENTS.md`, avisa que falta `/audit` | Una vez por sesión; ignora `.md` y config |
| `recordar-sync.sh` | Stop | Si hay 3+ archivos de código sin commitear, recuerda `/sync` | Máximo una vez cada 25 minutos |

Diseño deliberado del primero: **el hook entrega datos, no diagnostica.** La interpretación fina
la hace el modelo (o `/brujula`). Un bash no debe adivinar la fase del ciclo; sí puede probar
si un archivo existe.

## Verificación

Los tres se probaron con la entrada JSON real que reciben:
`ciclo-arranque` devuelve el cuadro correcto de este repo; `aviso-agents` dispara con `.ts`,
calla con `.md` y calla en el segundo intento de la misma sesión; `recordar-sync` calla con el
repo limpio. `settings.json` valida contra el esquema y las tres rutas son ejecutables.

## Pendiente

- Reevaluar en dos semanas qué avisos se ignoraron. Esos son candidatos a bloqueo.
- `AGENTS.md` de este repo: el propio hook lo señaló como faltante. Correr `/audit` aquí.
