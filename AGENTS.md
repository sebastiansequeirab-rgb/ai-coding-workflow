# ai-coding-workflow

Repo **público** donde vive y se mejora el workflow de AI coding de Sebastián: el manual, la
evidencia de por qué es así, la lista de mejoras y un instalador para usarlo en `~/.claude`. `PLAYBOOK.md` es la fuente de verdad: ante
cualquier duda sobre el workflow, gana ese archivo. Versión actual: 2026-09-30 (publicado, con instalador), sin ciclo
obligatorio, dos modos (tiro al piso / planear y crear), ajustado a la guía de prompts de Opus 5.5.

## Stack

- **Contenido**: Markdown (documentación, specs, registros de aprendizaje)
- **Lecciones**: HTML, CSS y JavaScript sin frameworks ni build, se abren directo en el navegador
- **Instalador**: bash (`install.sh`, `uninstall.sh`), requiere `jq`, `git`, `curl` y `npx`
- **Sin manifiesto ni dependencias**: no hay `package.json`
- **Package manager**: ninguno

## Commands

No hay build, servidor ni suite de tests. Las lecciones se abren directo en el navegador con `open`.

```bash
./install.sh --dry-run            # qué haría, sin tocar nada
./install.sh --link               # el mantenedor: CLAUDE.md y hooks enlazados a este repo
scripts/revisar-privacidad.sh --todo   # términos privados en archivos e historial: debe dar "limpio"
git config core.hooksPath .githooks    # activa el pre-commit de privacidad (una vez por clon)
```

El instalador se prueba con `HOME` falso en un directorio temporal (`HOME=$tmp ./install.sh`):
vacío, con `settings.json` y `CLAUDE.md` previos, reinstalación y `uninstall.sh`, que debe dejar
los archivos idénticos (`shasum`).

**Una skill se verifica corriéndola, no leyéndola.** El método está probado en
`docs/reviews/0002-verify-skill-ciclo.md`: sesiones headless de Claude Code, una por escenario, cada
una en contexto limpio.

```bash
claude -p "/la-skill <argumentos>" --output-format stream-json --verbose \
  --allowedTools "Bash,Read,Glob,Grep,Task,Write,Edit,TodoWrite"
```

De la traza JSON salen las dos evidencias que no se pueden inventar: la lista exacta de llamadas a
herramientas (para criterios de presupuesto) y el texto final. Se dejan Write y Edit permitidas a
propósito: si no, un criterio de "no toca el repo" no prueba nada. Para casos borde, repos git de
mentira en el scratchpad; para el modo chequeo, varios turnos con `--session-id` y `-r`.

## Specs

En `docs/specs/`, formato `docs/specs/NNNN-titulo.md` (también los planes cortos del modo "planear
y crear"). Verificaciones, reviews y fotos van a `docs/reviews/`, mismo formato. Las decisiones
difíciles de revertir van a `docs/adr/`, misma numeración. Las del ciclo viejo llevan una línea
`Superseded` o `Contexto histórico` al inicio y no se borran.

## Rules

- **Es público.** Nada de clientes, personas, rutas con usuario ni cifras de negocio. Los proyectos
  reales se nombran Proyecto A, B, C... (A y B del ciclo viejo, C a F de la limpieza). Lo personal
  vive en `~/.claude/personal.md` y `~/.claude/personal/`, fuera de aquí. El pre-commit lo revisa.
- **Un cambio al workflow va a `global/`** (lo que se instala) y al `PLAYBOOK.md`, y se anota en
  `docs/mejoras.md` ("Hecho" o "Descartado") con su evidencia. Si cambia de versión, línea en
  `HISTORIA.md` y un GitHub Release.
- **El estado vive en los archivos, nunca en el chat.** Si algo se decidió, hay un archivo que lo dice.
- **Español venezolano con tuteo**, en documentos, lecciones y mensajes. Nada de voseo.
- Las afirmaciones van con fuente oficial, no con blogs. Lo no verificado se marca como tal.
- Un documento nuevo se numera siguiendo el último de su carpeta. Nunca se reusa un número.

## Mapa del repo

| Carpeta | Qué guarda |
|---|---|
| `PLAYBOOK.md` | El workflow. Fuente de verdad. |
| `docs/mejoras.md` | Lista viva de mejoras: qué observar, pendientes con evidencia, ideas, hecho. |
| `HISTORIA.md` | Cómo llegó a ser: versiones, qué no sirvió, con evidencia. |
| `global/` | Lo que `install.sh` pone en `~/.claude`: CLAUDE.md, settings.json, hooks, plantilla de personal.md. |
| `scripts/`, `.githooks/` | Chequeo de privacidad y su pre-commit. |
| `docs/guias/` | Procedimientos repetibles: limpiar un repo del ciclo viejo, probar el workflow. |
| `aprendizaje/` | Registros por sesión, recursos y los motores de lecciones. Tiene su propio AGENTS.md. Lo del ciclo viejo en `archivo/`. |

## Agent skills

Las skills viven **globales** en `~/.claude/skills/`, no en el repo (no hay carpeta
`.claude/` aquí). Los subagentes `scout` y `researcher` de JS Mastery, en `~/.claude/agents/`.
Inventario y mantenimiento: `PLAYBOOK.md`, "Inventario de skills".
Regla: set mínimo, si una skill no aporta al workflow se saca (archivada en `~/.claude/skills-archive/`, privado).

## Context files

- [CONTEXT.md](CONTEXT.md): el vocabulario del workflow (modo, tiro al piso, planear y crear, plan corto, evidencia, arranque, piso, foto). Si un documento usa otra palabra para algo que ya está ahí, el documento está mal.
- [aprendizaje/AGENTS.md](aprendizaje/AGENTS.md): convenciones del material didáctico (numeración, motores reutilizables, cómo se prueban).

_Drafted by /audit from the repo, worth a quick human pass. Edit freely: once a line stops matching this draft, later runs treat it as curated and will flag rather than overwrite it._
