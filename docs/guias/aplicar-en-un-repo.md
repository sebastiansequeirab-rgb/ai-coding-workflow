# Guía: aplicar el workflow en un repo

Para cuando ya corriste `install.sh` y quieres trabajar así en un proyecto. Sirve igual para un repo
nuevo, uno con años de código o uno que ya usaba otro workflow. El primer chat es de diagnóstico;
desde el segundo ya se trabaja.

## Antes (una vez)

- `~/.claude/personal.md` tiene tu idioma y quién eres. Si el repo tiene **usuarios reales** o lo
  toca **más gente**, anótalo en el mapa de repos: eso cambia qué pide permiso y quién mergea.
- El repo es un repo git. Si no lo es, el agente te lo va a proponer primero.

## Chat 1: el diagnóstico

Abre Claude Code en la carpeta del repo y pega esto tal cual:

```
Vamos a aplicar mi workflow en este repo (reglas en ~/.claude/CLAUDE.md, detalle en ~/ai-coding-workflow/PLAYBOOK.md). Este chat es solo diagnóstico: no cambies nada todavía. Usa el scout para leer.

1. Dime en qué caso está el repo, con los números que lo prueban:
   A) nuevo o casi vacío
   B) tiene código pero no AGENTS.md
   C) tiene AGENTS.md o CLAUDE.md pesados (más de ~150 líneas o ~10 KB), o restos de otro workflow (skills locales en .claude/skills, verify.md o reviews de cosas cerradas en docs/)
   D) ya está al día
   Números: tokens con que arrancó este chat (usage del primer turno en ~/.claude/projects/), bytes y líneas de AGENTS.md y CLAUDE.md (raíz y anidados), skills locales, y si hay hook de git o CI.
2. Busca el repo en el mapa de ~/.claude/personal.md. Si no está, pregúntame solo lo que yo sé: de quién es, si tiene usuarios reales, quién más lo toca y quién mergea. Con mis respuestas, agrega la fila al mapa.
3. Dime cómo vas a manejar git aquí (PR o directo a main) según lo que encontraste.
4. Propón el siguiente paso con tu recomendación: A) /scope si es un producto nuevo, o arrancar directo; B) /audit para escribir el AGENTS.md; C) la guía ~/ai-coding-workflow/docs/guias/limpiar-un-repo.md; D) nada, a trabajar.
```

Qué esperar: un mensaje corto con el caso, los números, una o dos preguntas y una recomendación.
Si responde con un informe largo o cambia archivos, el workflow no cargó: revisa que
`~/.claude/CLAUDE.md` exista y se vea en `/memory`.

## Chat 2: según el caso

| Caso | Qué haces | Queda escrito |
|---|---|---|
| A. Nuevo | Si es un producto con varias piezas: `/scope`. Si es algo chico: pide lo primero y ya | `docs/scope/`, o nada |
| B. Sin `AGENTS.md` | `/audit`. Lee el código y escribe las convenciones que todas las skills leen después | `AGENTS.md` + `CLAUDE.md` puntero |
| C. Pesado o con restos | [Limpiar un repo](limpiar-un-repo.md): foto, plan y ejecución, foto después | `docs/reviews/`, un `AGENTS.md` corto |
| D. Al día | Nada. A trabajar | — |

Un `AGENTS.md` corto importa más de lo que parece: se relee en **cada turno** de **cada chat**. El
PLAYBOOK tiene las mediciones.

## Desde ahí: el día a día

Pide normal, sin nombrar el modo ni la skill. El agente dice en qué modo lo ve y confirma en una
pregunta.

| Pides | Modo | Lo que debes ver |
|---|---|---|
| "El botón de guardar se ve cortado en el celular" | Tiro al piso | Arreglo, evidencia según el cambio (una captura o "míralo tú"), commit |
| "El login falla con correos con mayúscula" | Tiro al piso (bug) | Causa en una línea, fix, salida de los tests o del typecheck, commit |
| "Quiero que los clientes puedan exportar sus pedidos" | Planear y crear | Preguntas de negocio, un plan de una página en `docs/specs/`, tu OK, construcción, evidencia contra el plan, commit |
| "¿Supabase o Postgres propio?" | Planear y crear | Opciones en llano con recomendación. `/architect` solo si la decisión es grande de verdad |

Tres reglas que hacen que funcione:
- **Un plan aprobado no crece.** Lo que salga en el camino va a una lista "después".
- **Evidencia, no "listo".** Se da por bueno con la salida de un comando, un test o una captura.
- **Al cerrar, commit.** `/sync` solo si el cambio tocó convenciones o el scope, y alrededor del merge.

## Señales de que algo anda mal

| Señal | Qué hacer |
|---|---|
| Lo corregiste dos veces por lo mismo | `/clear` y un pedido mejor escrito. No sigas en ese chat |
| Te sugiere skills que el cambio no necesita | Dile que no, y anótalo (abajo) |
| Aviso de "no hay AGENTS.md" en cada chat | Caso B pendiente: corre `/audit` |
| Te pregunta cosas técnicas sin recomendación | Pídele la recomendación, y anótalo |
| Vas a cerrar y lo importante no está en archivos | `/handoff` antes de cerrar |

## Anotar lo que estorba

Al final de un chat donde algo molestó o salió muy bien, pega:

```
Agrega una línea a ~/ai-coding-workflow/docs/mejoras.md, sección "Observado", con este formato:
`- <fecha> · <repo> · <modo> · <qué pasó en una oración> · <qué cambiaría, o "nada, solo anotar">`.
Lo que pasó: <cuéntalo en tus palabras>. Commit en ese repo.
```

Si no eres el dueño de este workflow, mejor abre un
[issue](https://github.com/sebastiansequeirab-rgb/ai-coding-workflow/issues/new/choose): así me llega.

## Quedó aplicado cuando

- [ ] El repo está en el mapa de `~/.claude/personal.md`.
- [ ] Hay un `AGENTS.md` corto (o el repo es nuevo y todavía no hace falta).
- [ ] El chat arranca sin avisos del hook, o solo con los que esperas.
- [ ] Un pedido chico salió en un solo chat, con modo declarado, evidencia y commit.
