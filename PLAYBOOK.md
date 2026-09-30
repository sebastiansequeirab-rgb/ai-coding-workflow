# PLAYBOOK — Mi workflow de AI coding

> Columna vertebral: **JS Mastery Engineering Workflow** (9 skills), tal como lo define su repo.
> Regla suprema: **el estado vive en los archivos del repo, nunca en el chat.**
> Última revisión: 2026-09-28 (guía de prompts de Opus 5.5, ver "Qué modelo uso"). Antes, 2026-09-27: Se quitó todo lo que yo le había puesto encima al ciclo de JS Mastery
> y que lo volvía lento (orden obligatorio, "un chat = una misión", "chat bajo 100k", "/sync nunca
> se salta", ruteo automático a skills). Evidencia: `aprendizaje/learning-records/0004` y `0005`.
> Historia completa, con lo que no sirvió: [HISTORIA.md](HISTORIA.md). Instalar: [README](README.md).
> Fuente contra la que se copió: [jsmastery-pro/skills](https://github.com/jsmastery-pro/skills), commit `43b69e4` (2026-08-07).

## La regla que cambia todo (JS Mastery, literal)

**No hay playbook obligatorio. Se corre solo lo que el cambio necesita, en el orden que le sirva.**
Las skills son sugerencias, nunca compuertas. `done` lo declaro yo. Lo único que el workflow pide
es que una decisión de peso quede escrita (una spec), y hasta eso se avisa, no se bloquea.

## Cómo decidimos juntos

No soy programador de carrera. Las decisiones técnicas las razona el agente y me las propone en mi
idioma: opciones, recomendación y por qué, en pocas líneas. Dialogamos y escojo. Nunca una pregunta
técnica seca ni un menú sin recomendación. Lo que solo yo sé (usuario, negocio, preferencias) sí
me lo pregunta. Esto salió de la entrevista del 2026-09-27: `/architect` me hacía preguntas
técnicas profundas que no entendía.

## Dos modos de trabajo

Mi semana es mitad y mitad: cambios "tiro al piso" que me mandan a hacer rápido, y trabajo de
planear, dialogar y crear. El agente analiza el pedido, dice en qué modo lo ve, confirma conmigo
en una pregunta corta, y arranca.

| | Tiro al piso | Planear y crear |
|---|---|---|
| Cuándo | Bug, ajuste visual, texto, diff de una oración, "hazlo rápido" | Feature, varias piezas, "vamos a pensarlo" |
| Antes de tocar código | Nada | Diálogo con propuestas → plan corto de una página en `docs/specs/` (qué, qué no, cómo sabremos que quedó) → lo apruebo |
| Skills | Ninguna (`/debug` si el bug es raro) | `/architect` solo ante una decisión grande de verdad (BD, proveedor, stack). `/develop` si lo pido |
| Evidencia | Según el cambio: visual chico → lo veo yo; varios visuales → una captura al final; lógica → chequeos del repo (tests, typecheck) con su salida | Contra el "cómo sabremos que quedó" del plan |
| Cierre | Commit | Commit, y `/sync` solo si tocó convenciones o el scope |

Un plan aprobado no crece: lo nuevo va a una lista "después". Si un tiro al piso resulta grande,
el agente lo dice y cambiamos de modo. En la pregunta de confirmar el modo también dice quién
verifica (yo o él). Tiro al piso también por negocio: demo con el cliente ese día o "para ya" del
jefe (entrevista de perfil).

Las profundidades de JS Mastery (Prototype, Alpha, Beta, GA) las fija `/scope` por proyecto y
siguen valiendo para un producto nuevo. Para el día a día, los dos modos de arriba bastan.

`/check verify` solo tiene sentido con criterios de aceptación escritos. `/sync` va alrededor del
merge, no al cierre de cada chat.

## El flujo completo de JS Mastery, cuando hace falta entero

```
idea → /scope → /audit → /architect → /develop → /check verify → /test → /check review → /document → /sync
```

Qué escribe cada uno y quién lo puede tocar:

| Archivo | Lo crea | Lo cambia |
|---|---|---|
| `AGENTS.md` (+ `CLAUDE.md` puntero) | `/audit` | `/sync` |
| `docs/scope/` | `/scope` | `/develop` lo avanza, `/scope` y `/sync` lo reconcilian |
| `docs/specs/` | `/architect` | `/develop` mueve solo la línea de estado |
| `docs/reviews/` | `/check` | nadie más |

Guía completa, en inglés y sin adornos: `docs/workflow-guide.md` del repo de JS Mastery.

## Reglas de contexto

1. **Un chat se cierra cuando termina el trabajo o cuando el agente se pone tonto.** No por un
   número de tokens. Un bug es un solo chat aunque pese 300k. La señal de "tonto" es la regla de
   las dos correcciones: si lo corregí dos veces por lo mismo, `/clear` y un prompt mejor.
2. **Al cerrar, lo que importa ya está en archivos.** Si no lo está, `/handoff` antes de cerrar.
3. **Leer muchos archivos es trabajo del `scout`**, no del chat principal. Está instalado como
   subagente global (`~/.claude/agents/scout.md`, de JS Mastery, corre en Haiku, solo lee y
   devuelve un mapa de 1 a 2k tokens). El `researcher` hace lo mismo con la web.
4. **Un plan aprobado no crece.** Lo que aparezca a mitad de camino va a una lista "después" y se
   sigue con el plan. Plan mode solo cuando el cambio toca varios archivos que no conozco.
5. **El `AGENTS.md` raíz se mantiene corto.** Lo específico de un área va anidado en su carpeta.
   Lo puntual que me sirvió una vez va a la memoria automática de Claude Code, no al AGENTS.md.
   `/sync` suma líneas; podar es trabajo mío o de `/audit`.

## Mi memoria también envejece (2026-09-01)

Lo que yo afirmo de memoria vale menos que lo que dice el archivo. Antes de escribir una versión,
un commit, un estado o qué se subió a dónde, lo abro. El agente verifica contra el repo lo que yo
le doy de memoria y me dice cuál es el real. Al escribir un estado en un documento, anotar contra
qué se comprobó.

## Evidencia, nunca "listo"

Ningún paso se da por bueno con una afirmación del agente. Se da por bueno con la salida del test,
el comando que corrió y lo que devolvió, o una captura. Esta es la única regla del ciclo viejo que
se queda entera, porque ya me sale sola (registro 0004) y no cuesta tiempo.

## Reglas de la entrevista de perfil (2026-09-27)

Salieron de una entrevista de 14 bloques conmigo (el registro es privado: tiene datos de clientes).
Están condensadas en `global/CLAUDE.md`; lo que es solo mío (idioma, clientes, mapa de repos) vive en
`~/.claude/personal.md`, fuera de este repo.

- **Cómo me habla:** español venezolano con tuteo, resultado primero, 8 líneas por mensaje (15 como
  mucho), una línea de "qué hice y por qué" en cada entrega, términos en inglés con explicación
  corta la primera vez. Si sale algo nuevo que me va a volver a salir, ofrece "¿te lo explico?" en
  una línea, sin repetirlo por lo mismo.
- **Idioma de lo que produce:** el de cada repo. En uno nuevo, docs, commits y textos de la app en
  español, nombres de código en inglés. Lo que lee un cliente es borrador que envío yo.
- **Límites duros:** gastar dinero, nunca. Con mi OK: borrar datos, pagos, mensajes a clientes,
  secretos y `.env`. Base de datos de producción y migraciones: con OK solo donde hay usuarios
  reales (lo dice el mapa de repos de `personal.md`). Un repo con protocolo propio manda sobre esto.
- **Git:** el agente lo lleva entero. Repos míos: commit y push a main, o rama/PR/merge si hay hook
  o CI; si el CI falla, no mergea. Repos de equipo o de cliente: la rama y quién mergea se confirman al arrancar
  cada tarea, nunca push directo a main sin que lo diga.
- **Deploy:** repos míos, despliega solo. Repos de equipo, verifica y pregunta "¿subo?". Los que tienen
  protocolo propio los corre quien diga el protocolo. La evidencia es la URL o el build y una línea de qué mirar.
- **Quién verifica:** se dice en la misma pregunta que confirma el modo. Primero que no rompa nada,
  después que se vea bien.
- **Bugs:** si al reporte le falta algo para reproducirlo, me pregunta antes. Lo que el código o los
  logs responden, lo averigua solo. Entrega: causa en una línea, fix y evidencia.
- **Memoria automática:** solo preferencias, correcciones y trucos. Nunca datos de clientes,
  credenciales ni cifras de negocio. Al guardar avisa en media línea.

## Qué modelo uso (verificado contra la doc oficial el 2026-09-27)

Pago Max, no API: lo que gasto es **cupo de uso**, no dólares. Un modelo más caro por token come
cupo más rápido, y un arranque de chat pesado se relee en cada turno y también lo come.

| Modelo | Para qué | Esfuerzo |
|---|---|---|
| **Opus 5.5** (`claude-opus-5-5`, default) | Todo el trabajo normal, los dos modos. Anthropic: en `medium` rinde igual o mejor que Opus 5 en `high`. | `medium` |
| **Fable 5.1** (`claude-fable-5-1`) | Solo cuando Opus 5.5 se queda corto: decisión dura de "planear y crear", tarea agéntica de horas, análisis pesado. Come cupo 2.5× más rápido. Se cambia con `/model` dentro del chat. | `high` |
| **Haiku 4.5** | Subagentes `scout` y `researcher` (lectura y búsqueda). Ya vienen así. | bajo |

Lo que cambió con Opus 5.5 y hay que saber: el pensamiento ya no se puede apagar (se controla
con esfuerzo), y su esfuerzo default bajó a `medium`. Fable 5.1 igual: pensamiento siempre
encendido. Sigue valiendo: no pedir doble verificación, output style `Concise`, regla de alcance.

El agente decide modelo y esfuerzo por su cuenta (entrevista de perfil). No puede cambiar el modelo del
chat principal, pero sí el de cada subagente: si la tarea de Fable se puede delegar, lanza un
subagente en Fable; si no, pide `/model` en una línea con el porqué. `high` en Opus para bug
difícil o plan con muchas piezas.

Fuentes: platform.claude.com/docs/en/models/opus-5-5/overview · .../models/fable-5-1/overview ·
.../about-claude/models/choosing-a-model · .../build-with-claude/effort ·
code.claude.com/docs/en/settings-reference.

### Cómo pedirle a Opus 5.5 (guía oficial, revisada el 2026-09-28)

Fuente: platform.claude.com/docs/es/build-with-claude/prompt-engineering/prompting-claude-opus-5-5.
Comparada contra `~/.claude/CLAUDE.md`, las skills y `settings.json`. Ya se cumplía: esfuerzo
`medium` fijo, ninguna instrucción de "piensa con cuidado" (buscado con grep en CLAUDE.md, skills,
agents y hooks), texto pegado marcado (lo hace Claude Code). Lo de la API (`max_tokens`,
`display`, presupuesto de tiempo) no aplica en Claude Code. Se agregaron dos cosas:

- **Paradas antes de tiempo.** La guía: Opus 5.5 "responde bien a instrucciones que nombran los
  tipos específicos de detención prematura" y un final de turno solo con texto es "un informe y no
  prueba de que la tarea está terminada". Regla: con el modo confirmado o el plan aprobado, avisa
  y sigue sin pedir permiso; para solo ante decisiones mías o límites duros; no da por terminado
  nada con un comando o subagente todavía corriendo.
- **Diseño de frontend.** "Evita un aspecto genérico de IA" solo cambia un estilo por otro; sirve
  nombrar los patrones exactos a evitar. La lista es **global** (hago frontend en muchos repos) y
  vive en `~/.claude/CLAUDE.md`: los cinco defaults que nombra la guía (fondo crema, cursivas de
  acento en títulos, "01/02/03", monospace, botones píldora). Si un repo tiene su diseño, manda
  ese. La lista crece: lo que salga con cara de plantilla se suma (la guía pide iterar así).

Descartado a propósito: "da por cerrada una respuesta anterior". La guía dice no usarla en tareas
agénticas porque el modelo deja de señalar errores previos.

## Arranque liviano (2026-09-27)

Este chat arrancó con **60,049 tokens** antes del primer mensaje (medido en el transcript). Mis
archivos eran ~4k; el resto, conectores de claude.ai (Vercel, Gmail, Drive, Notion, Supabase…)
y dos plugins sincronizados que nunca instalé. Apagados en `settings.json` con
`disableClaudeAiConnectors: true` y `syncClaudeAiPlugins: false` (fuente:
code.claude.com/docs/en/managed-mcp y .../plugins/loading). Se prenden por proyecto si hacen
falta. **Medido el 2026-09-27** en el chat siguiente (Proyecto C, sesión `6b592add`, campo
`usage` del primer turno del transcript): **52,168 tokens** (26,588 de cache creado + 25,578 de
cache leído + 2), o sea ~7.9k menos (-13%). Lo que queda: el prompt de sistema y las herramientas
integradas de Claude Code (lo más grande, no se toca), el `AGENTS.md` de Proyecto C (27 KB, ~7k
tokens), `~/.claude/CLAUDE.md` (7 KB, ~2k) y la lista de ~40 skills (JS Mastery, firecrawl ×8,
`anthropic-skills:*` ×13).

**Tercera medición, Proyecto C ya limpio** (AGENTS.md raíz de 27 KB a 10 KB, PR #106; foto en
`Proyecto C/docs/reviews/0003`): **44,916 tokens**, -14% más. Total desde el arranque original:
**-25%**. El piso de ~40k es el prompt de sistema y las herramientas de Claude Code; lo que queda
en mis manos son ~2,600 del AGENTS.md y ~1,900 del CLAUDE.md global. La única palanca que falta
es la lista de skills (firecrawl ×8 sobre todo), 1-2k.

**Cuarta pasada (2026-09-27):** apagadas 21 skills bundled de Claude Code que
no uso (Word, PowerPoint, Excel, PDF, morning, navegadores, computer-use,
artifacts, dataviz, loop, schedule, atajos, importar memoria, crear skills) con `skillOverrides`
en `settings.json` (fuente: code.claude.com/docs/en/skills). Chrome ya no carga por defecto
(`claudeInChromeDefaultEnabled: false` en `~/.claude.json`; se prende por sesión con
`claude --chrome`). WebStorm eliminado de Proyecto C (el `.mcp.json` no estaba en git). Playwright
se queda en Proyecto F: solo carga ahí y sirve para probar la web. La regla de qué herramienta usar
para qué (scout, researcher, firecrawl, Chrome, Playwright) está en `~/.claude/CLAUDE.md`.
Marketplace `karpathy-skills` quitado. **Medido el 2026-09-27** (Proyecto C, sesión `072a5b18`,
campo `usage` del primer turno del transcript): **47,268 tokens** (47,266 de cache creado + 2),
**+2,352 (+5%) sobre los 44,916**. Las skills sí se fueron (docx, pptx y morning ya no están en la
lista), pero subió igual: `~/.claude/CLAUDE.md` pasó de 7 KB a 8.5 KB (~+400, la regla de
herramientas) y el resto no lo sé con certeza; lo probable es que las herramientas integradas de
Claude Code crecieran (en esta sesión aparecen Artifact y Workflow con descripciones largas), que
no dependen de mí. El piso quedó en ~45-47k.

**Quinta pasada, la que más pesó (2026-09-27):** `permissions.deny` con el nombre pelado de una
herramienta la saca del contexto (doc: code.claude.com/docs/en/permissions, dicho para `Bash`; no
documentado para las de fábrica, así que se probó). Negadas `Artifact`, `ArtifactComments`,
`ArtifactData`, `Workflow` y `NotebookEdit`, que no uso. **Medido** (Proyecto C, sesión
`12f64b81`, primer turno): **28,020 tokens**, −19,248 (−41%) sobre los 47,268. Artifact y Workflow
ya no aparecen en la lista de herramientas. Solo esas dos descripciones eran casi la mitad del
arranque.

| Pasada | Arranque | Qué se quitó |
|---|---|---|
| 0 | 60,049 | — |
| 1 | 52,168 | conectores de claude.ai, plugins sincronizados |
| 2 | 44,916 | AGENTS.md de Proyecto C de 27 a 10 KB |
| 3 | 47,268 | 21 skills bundled (subió por la regla de herramientas y ruido) |
| 4 | **28,020** | Artifact, Workflow, NotebookEdit negadas |

**Total: −53%.** Lo que queda es el prompt de sistema y las herramientas base de Claude Code, más
~4.5k míos (AGENTS.md del repo y CLAUDE.md global). Si algún día necesito Artifact, se quita del
`deny` y vuelve.

Para chats largos, lo que dice la doc: el auto-compact viene activo, y **un plan guardado en
un `.md` se reinyecta después de cada compactación**. Por eso el plan corto en archivo del modo
"planear y crear" es lo que sobrevive; el chat no.

## Guía global

Todo sale de `global/` en este repo y lo pone `install.sh` en `~/.claude/`:

- **`CLAUDE.md`**: cómo hablarme y las reglas de arriba, condensadas. Carga en todo repo. Al final
  importa `~/.claude/personal.md`, que es de cada quien y no se publica.
- **`agents/`**: `scout` y `researcher`, bajados del repo de JS Mastery al instalar.
- **Hooks** (`~/.claude/hooks/`): tres, todos avisan y ninguno bloquea. `arranque-repo` avisa al
  abrir solo si hay algo raro (código sin AGENTS.md, archivos sin commitear), `aviso-agents` avisa si se toca código sin
  AGENTS.md, `recordar-sync` recuerda `/sync` solo si hay 3+ archivos de trabajo sin commitear.
- **`settings.json`**: se mezcla con el que ya tengas: modelo y esfuerzo, output style `Concise`,
  conectores apagados, herramientas negadas (ver "Arranque liviano") y los tres hooks.
- **Mi caso:** instalo con `--link`, así `CLAUDE.md` y los hooks son enlaces a este repo y hay una
  sola fuente de verdad. `~/.claude/` sigue siendo un repo git privado con lo personal.

## Inventario de skills (actualizado 2026-09-27)

- **JS Mastery (9):** scope, audit, architect, develop, check, test, document, sync, debug.
  Idénticas al repo, verificado con `diff -rq` el 2026-09-27.
- **Pocock (5), herramientas sueltas:** grill-me, grilling (la canónica según
  skills.sh, verificado el 2026-09-27), domain-modeling, prototype, handoff.
- **Mías (1):** `whatsapp`, mensajes con mi voz listos para copiar. Privada por ahora: tiene ejemplos
  de clientes.
- **Firecrawl (8):** firecrawl y sus variantes search, scrape, crawl, map, download, interact, agent.
- **Archivadas el 2026-09-27** en `~/.claude/skills-archive/`: `brujula` y `ciclo`. Eran mías,
  casi no las usaba, y empujaban al ciclo completo. Junto a tres skills de portales de clientes.
  Y en la entrevista de perfil: grill-with-docs, diagnosing-bugs, teach, tdd, setup-pre-commit,
  git-guardrails-claude-code.
- **Mantenimiento:** cada ~1 mes `npx skills@latest update -g -y` y revisar con `npx skills ls -g`.

## Pendientes

Viven en `docs/mejoras.md`, sección "Pendientes", con su evidencia y estado. Aquí no se repiten.

## Referencias

- [JS Mastery Skills](https://jsmastery.com/skills) · [repo](https://github.com/jsmastery-pro/skills)
- [Matt Pocock, skills](https://github.com/mattpocock/skills)
- [obra/superpowers](https://github.com/obra/superpowers)

## Cómo se mejora este workflow

No se mejora leyendo: se mejora trabajando una semana y anotando lo que estorba. La lista viva de mejoras es
`docs/mejoras.md` (qué observar, pendientes con evidencia, ideas, hecho). Cualquier chat, en
cualquier repo, le agrega una línea con el mensaje de "Cómo se alimenta". El viernes, un chat aquí
revisa lo observado (y los issues de GitHub) y aplica lo aprobado al PLAYBOOK y a `global/CLAUDE.md`.
Lo que se probó y no sirvió va a "Descartado", con su porqué: el historial muestra también lo que falló.
Cada versión nueva suma una línea a `HISTORIA.md` y un GitHub Release. Guías repetibles en
`docs/guias/`: limpiar un repo del ciclo viejo, probar el workflow. Si una semana pasa sin nada
observado, el workflow está bien y no se toca.
