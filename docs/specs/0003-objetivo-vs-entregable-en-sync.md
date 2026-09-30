# 0003. Objetivo contra entregable: qué entra como fuente en `/sync`

> **Superseded 2026-09-27**: `/sync` ya no cierra cada chat, va alrededor del merge (`PLAYBOOK.md`). El problema de fondo, qué toma `/sync` como fuente y que nunca poda, sigue abierto en `docs/mejoras.md`.

**Fecha**: 2026-09-01
**Estado**: Superseded (2026-09-27)

## Summary

Hoy `/sync` decide qué archivo mirar por la extensión, y bota `*.md` completo. En un repo donde
los documentos son el producto, eso deja la lista de fuentes vacía y `/sync` se va sin hacer nada.
La decisión es cambiar el criterio: ya no importa la extensión, importa el rol del archivo. Se bota
lo que `/sync` escribe o lee como objetivo (los `AGENTS.md`, el scope, las specs, los reviews, los
ADR), y entra todo lo demás. Aparte, la parada temprana se parte en dos, porque hoy apaga también
la reconciliación, que nunca necesitó archivos de código.

## Context

> ⚠️ Nota sobre la premisa: el pedido llamó a esto "el hueco de `/sync` en repos de markdown", y son
> dos huecos, no uno. El segundo no tiene nada que ver con markdown: la parada del paso 1 apaga la
> reconciliación en cualquier repo cuyo cambio sea solo de documentos y tests, incluido uno de
> código. La spec arregla los dos porque comparten la misma línea de `SKILL.md`.

`/sync` corre en dos mitades. Una lee el cambio y ajusta los `AGENTS.md` para que las convenciones
durables sigan siendo ciertas. La otra reconcilia: mueve el estado de las specs, tilda subtareas del
scope contra la evidencia del repo, limpia punteros huérfanos. La primera necesita mirar archivos
que enseñen algo. La segunda no: mira el repo tal como quedó.

El paso 1 de `~/.claude/skills/sync/SKILL.md` arma la lista de fuentes botando, entre otras cosas,
`AGENTS.md` a cualquier nivel, `docs/**` y `*.md` completo. Después dice: *"If no source files and
no dependency manifest changes remain, stop, nothing to sync. Do not spawn."* Esa parada apaga la
corrida entera, las dos mitades.

Y `agent-prompt.md`, línea 158, dice lo contrario para la segunda mitad: *"Step 1's source file
filtering (dropping `*.test.*`, `docs/**`) governs what you sync AGENTS.md from; it does not limit
reconciliation."* Los dos archivos de la misma skill se contradicen, y gana el que corre primero.

Las dos consecuencias se ven en este repo, donde el entregable es markdown. El commit `6d1e329`
tocó solo `docs/specs/0002-skill-ciclo.md`: con la regla escrita, `/sync` ahí debía decir "nada que
sincronizar" y salir sin reconciliar nada. Y ningún cambio a `PLAYBOOK.md`, `CONTEXT.md`,
`README.md` o a las lecciones de `aprendizaje/` puede jamás actualizar un `AGENTS.md`, porque
ninguno llega a la lista de fuentes.

El costo de no decidir esto: en este repo `/sync` es decorativo. Se corre, no falla, y no
reconcilia. El estado que dice vivir en los archivos se queda envejeciendo mientras el comando que
debía refrescarlo reporta éxito.

## Requirements

**Historias**:

- Como dueño de un repo cuyo entregable son documentos, quiero que `/sync` lea mis `.md` como
  fuente, para que las convenciones que escribo lleguen al `AGENTS.md` sin que yo las copie a mano.
- Como dueño de cualquier repo, quiero que la reconciliación corra aunque el cambio no traiga
  código, para que el estado de las specs y del scope no dependa de la extensión de lo que toqué.
- Como el que construye la skill, quiero que `SKILL.md` diga qué pasa con los archivos que no entran
  como fuente, para no tener que adivinar si "botado" significa ignorado o significa otra cosa.

**Criterios de aceptación**:

- **AC-1**: con un cambio que toca solo archivos objetivo (por ejemplo solo
  `docs/specs/0002-skill-ciclo.md`), `/sync` no responde "nada que sincronizar". Salta la mitad de
  `AGENTS.md`, lo dice en el reporte, y corre igual la reconciliación de specs, scope y huérfanos.
- **AC-2**: con un cambio que toca un `.md` entregable (por ejemplo `PLAYBOOK.md` o una lección de
  `aprendizaje/`), ese archivo aparece en `CHANGED_FILES` y su diff se lee para decidir si algún
  `AGENTS.md` cambia.
- **AC-3**: nunca entran como fuente, a ningún nivel: `AGENTS.md`, `CLAUDE.md`, la carpeta de specs,
  la de scope, la de reviews, la de ADR, la caché de agentes, `aprendizaje/PROXIMA-SESION.md`,
  `test-preferences.json`, los archivos de lock y lo generado.
- **AC-4**: `SKILL.md` dice explícitamente, para cada grupo que no entra como fuente, para qué sí se
  usa: objetivo que se edita, contexto que se lee, o evidencia para reconciliar. No basta con
  listar lo que se bota.
- **AC-5**: la parada de verdad ocurre solo cuando el conjunto de archivos cambiados está vacío.
- **AC-6**: un área nueva de solo documentos, con todos sus archivos en estado `A`, dispara la
  creación del `AGENTS.md` anidado con las mismas condiciones que un área de código.
- **AC-7**: la regla nombra la base de artefactos que exista en el repo (`docs/` o `.workflow/`), no
  la cadena literal `docs/`.
- **AC-8**: en un repo de código, un cambio que toca solo `README.md` corre `/sync` completo y
  termina sin editar ningún archivo. Entrar como fuente no significa dejar rastro.
- **AC-9**: después del cambio, la frase de `agent-prompt.md` línea 158 sigue siendo cierta contra
  `SKILL.md`. Las dos mitades de la skill dicen lo mismo.
- **AC-10**: `PLAYBOOK.md` dice qué cuenta como fuente para `/sync`, porque la regla del repo manda
  que un cambio al ciclo pase primero por ahí.

## Options considered

### Opción 1: la regla de objetivo contra entregable

El criterio deja de ser la extensión y pasa a ser el rol del archivo dentro del ciclo. Se bota lo
que `/sync` escribe o consulta como objetivo, más los tests, los lock y lo generado. Entra todo lo
demás, sea `.md`, `.html`, `.js` o lo que sea. Una sola regla, sin configuración por repo.

**A favor**:
- Arregla el repo de documentos y el de código con la misma frase.
- La lista de objetivos ya existe: son las carpetas que el ciclo tiene numeradas.
- Un repo nuevo funciona bien sin declarar nada.

**En contra**:
- En un repo de código, tocar el `README.md` ahora dispara una corrida completa en vez de una
  salida temprana. Cuesta tokens que antes no se gastaban.
- La lista de objetivos hay que mantenerla: si el ciclo agrega una carpeta de artefactos, hay que
  sumarla ahí o se leerá como entregable.

### Opción 2: declarar la fuente en el `AGENTS.md` de cada repo

Cada repo escribe una línea que dice qué cuenta como fuente ahí. `/sync` la lee y, si no existe,
usa el filtro de hoy.

**A favor**:
- Control fino por repo, incluidos los casos raros que ninguna regla general acierta.
- No cambia el comportamiento de ningún repo existente.

**En contra**:
- Un repo sin la línea sigue roto, y el que más la necesita es justo el que no sabe que existe.
- Mete una pieza de configuración nueva que hay que documentar, recordar y mantener sincronizada.
- `/audit` tendría que aprender a escribirla, así que el cambio se derrama a otra skill.

### Opción 3: detectar el repo de documentos

Si el repo no tiene archivos de código, `/sync` trata los `.md` como fuente.

**A favor**:
- Cero configuración y cero cambios para un repo de código puro.

**En contra**:
- Falla en el caso mixto, que es el común. Este repo tiene 2 archivos `.js` y 21 `.md`: la
  heurística lo clasificaría como repo de código y el hueco quedaría igual.
- Un umbral por conteo de archivos es una regla que hay que explicar y que nadie va a recordar.

### Opción 4: arreglar solo la parada temprana

Dejar el filtro tal cual y hacer que la falta de fuente no apague la reconciliación.

**A favor**:
- El cambio más pequeño posible, y resuelve la contradicción entre los dos archivos.

**En contra**:
- Deja la mitad de `AGENTS.md` muerta en un repo de documentos: ningún `.md` podría nunca enseñarle
  una convención al `AGENTS.md`. Arregla el síntoma barato y deja el caro.

## Decision

**Opción elegida**: Opción 1, la regla de objetivo contra entregable, junto con la partición de la
parada temprana que la Opción 4 proponía sola.

`/sync` deja de filtrar por extensión. Filtra por rol: se bota lo que la skill escribe o consulta
como objetivo, entra todo lo demás, y la falta de fuente apaga solo la mitad de `AGENTS.md`.

**Skills de implementación**: ninguna skill de comunidad aplica. Lo que se toca son dos archivos de
markdown de una skill del ciclo.

## Rationale

La contradicción entre `SKILL.md` y `agent-prompt.md` línea 158 es la pista de que el filtro y la
parada nunca debieron ser lo mismo. La línea 158 ya tenía la distinción correcta escrita, pero
vivía en el archivo que se lee de último. Partir la parada no es una mejora nueva: es hacer que la
skill haga lo que su propio texto ya dice.

Sobre el filtro, la Opción 2 y la Opción 3 comparten el defecto que las descarta: dejan el repo roto
por defecto. La 2 exige que el dueño sepa que hay una línea que escribir, y la 3 se equivoca justo
en el caso mixto, que es el de este repo (2 archivos de código contra 21 de documentos). La Opción 1
no depende de que nadie declare nada ni de que un conteo acierte, porque la lista de objetivos ya
está fijada por el ciclo: son las carpetas numeradas que las skills se reparten.

El costo que sí acepto es el de la contra de la Opción 1: en un repo de código, tocar el `README.md`
ahora arranca una corrida completa. Lo asumo porque `agent-prompt.md` ya trae el freno adecuado,
*"Default to doing nothing... a `NOTHING_TO_SYNC` run is a normal, good outcome"*. El costo es de
tokens, no de ruido en los archivos, y el AC-8 lo fija como criterio.

`aprendizaje/PROXIMA-SESION.md` sale nombrado en la lista de objetivos aunque no sea una carpeta del
ciclo, porque es estado que se reescribe entero al cerrar cada sesión. Su propio
`aprendizaje/AGENTS.md` ya advierte que envejece. Un archivo así no enseña convenciones durables:
cada cambio suyo es un reemplazo, no una evolución.

## Diseño del cambio

**Qué entra como fuente**: todo archivo del cambio que no esté en la tabla de abajo. No hay lista de
extensiones permitidas, y esa es la idea: `.md`, `.html`, `.css`, `.js`, `.py` y cualquier otra
entran por igual.

**Qué no entra, y para qué sí se usa**:

| Grupo | Ejemplos en este repo | Por qué no es fuente | Para qué se usa igual |
|---|---|---|---|
| Los `AGENTS.md` y sus punteros `CLAUDE.md`, a cualquier nivel | `AGENTS.md`, `aprendizaje/AGENTS.md`, `CLAUDE.md` | Son lo que `/sync` escribe. Leerlos como fuente sería sincronizar un archivo consigo mismo | Objetivo que se edita, y contexto que se lee entero para no repetir ni pisar prosa curada |
| La carpeta de specs | `docs/specs/` | Es objetivo de otra skill. `/sync` solo mueve la línea de estado | Objetivo de la línea `**Status**:`, y candidato a marcarse obsoleto |
| La carpeta de scope | `docs/scope/` (aquí no existe todavía) | Es objetivo. `/sync` tilda subtareas y mueve el estado de la feature | Objetivo de la reconciliación, y fuente del estado que las specs espejan |
| La carpeta de reviews | `docs/reviews/` | Es salida de `/check`, no convención durable | Evidencia: la existencia de un review tilda la subtarea de revisión |
| La carpeta de ADR | `docs/adr/` | Es la decisión ya registrada, no un cambio que enseñe algo nuevo | Contexto, si hace falta entender por qué una convención es como es |
| La caché de agentes | `docs/.agent-cache/` | Es caché, no contenido | Nada. Se ignora |
| Estado que se reescribe entero cada sesión | `aprendizaje/PROXIMA-SESION.md` | Cada cambio es un reemplazo completo, no una convención que evoluciona | Nada. Se ignora |
| Tests | `*.test.*`, `*.spec.*`, `__tests__/` | Un test no es una convención durable del área | Evidencia: su existencia tilda la subtarea de pruebas |
| Lock, generados y preferencias | `test-preferences.json`, archivos de lock | No los escribe una persona | Un lock es señal para descubrir herramientas, nunca se pasa su contenido |
| Borrados (estado `D`) | cualquiera | No hay contenido que leer | Lista aparte: manejan la limpieza de punteros huérfanos |
| Manifiestos de dependencias | aquí no hay ninguno | Son configuración, no convención | Lista aparte: disparan el descubrimiento de skills y MCP |

Las carpetas se nombran contra la base de artefactos que exista en el repo, `docs/` o `.workflow/`,
nunca contra la cadena literal `docs/` (AC-7).

Lo que queda de `docs/` y no es una de esas carpetas, por ejemplo un `docs/conventions.md`, **sí
entra como fuente**. Es un documento escrito a mano que puede enseñar una convención, y ninguna
skill lo trata como objetivo.

**Las dos paradas**:

| Situación | Hoy | Después |
|---|---|---|
| Cero archivos cambiados | para | para (única parada real) |
| Hay cambios, ninguno es fuente | para, no corre nada | salta la mitad de `AGENTS.md`, lo dice en el reporte, y reconcilia |
| Hay fuente | corre completo | corre completo |

**De dónde sale cada valor que la skill necesita**:

| Valor | Fuente |
|---|---|
| La lista de grupos que no son fuente | Escrita literal en el paso 1 de `SKILL.md`. No se deriva de nada |
| La base de artefactos (`docs/` o `.workflow/`) | Cuál de las dos carpetas existe en el repo |
| Si un área es nueva | Todos sus archivos con estado `A` en `CHANGED_FILES`, la regla que ya existe |
| Si la mitad de `AGENTS.md` se saltó | Si la lista de fuentes quedó vacía después del filtro |

**Invariantes**:

- Ningún archivo está en las dos listas a la vez. Objetivo y entregable se excluyen.
- La reconciliación no depende nunca del filtro de fuente. Es lo que ya dice `agent-prompt.md` 158.
- La corrida sigue siendo idempotente: correrla dos veces seguidas no cambia nada la segunda vez.

**Escenarios de prueba**, contra el método que fija el `AGENTS.md` de este repo (sesión headless por
escenario, contexto limpio, la traza JSON como evidencia):

- Camino feliz: se toca `PLAYBOOK.md` y nada más. `PLAYBOOK.md` aparece en la lista de fuentes y la
  corrida evalúa si `AGENTS.md` cambia. Verifica **AC-2**.
- Solo objetivos: se toca solo un archivo de `docs/specs/`. La corrida no dice "nada que
  sincronizar", reporta que saltó la mitad de `AGENTS.md`, y reconcilia. Verifica **AC-1**, **AC-5**.
- Contra el ruido: en un repo de código de mentira en el scratchpad, se toca solo `README.md`. La
  corrida termina sin editar ni un archivo. Verifica **AC-8**.
- Área nueva: se agrega una carpeta de documentos con todos sus archivos nuevos. Se crea el
  `AGENTS.md` anidado y el puntero en el de raíz. Verifica **AC-6**.

## Build plan

El `AGENTS.md` de este repo tiene `## Build approach` en `<TBD, lo define /scope>`, así que no hay
estrategia declarada. Asumo rebanadas de punta a punta: cada paso deja la skill corriendo y
verificable, no medio cambiada.

1. Reescribir el filtro del paso 1 de `SKILL.md`: cambiar la lista de extensiones por la tabla de
   grupos que no son fuente, nombrando la base de artefactos en vez de `docs/` literal. Cumple
   **AC-2**, **AC-3**, **AC-7**.
2. En esa misma tabla, escribir para cada grupo para qué sí se usa. Cumple **AC-4**.
3. Partir la parada: la falta de fuente salta la mitad de `AGENTS.md` y lo anota en el reporte; la
   única parada real es el conjunto vacío. Cumple **AC-1**, **AC-5**, **AC-8**.
4. Revisar que la regla de área nueva hable de "archivos del área", no de "archivos de código", para
   que un área de documentos la dispare igual. Cumple **AC-6**.
5. Repasar `agent-prompt.md` y la tabla Boundaries de `SKILL.md` para que ninguna frase quede
   contradiciendo lo nuevo, empezando por la línea 158. Cumple **AC-9**.
6. Correr los cuatro escenarios de prueba en sesiones headless separadas y dejar el resultado en
   `docs/reviews/`. Cubre **AC-1** a **AC-8**.
7. Anotar en `PLAYBOOK.md` qué cuenta como fuente para `/sync`, según la regla del repo de que un
   cambio al ciclo va primero ahí. `~/.claude/CLAUDE.md` y `/brujula` no se tocan: los dos hablan
   de cuándo usar `/sync`, no de cómo filtra por dentro. Cumple **AC-10**.

## Consequences

**A favor**:

- `/sync` deja de ser decorativo en este repo. La reconciliación corre y los `.md` del entregable
  pueden actualizar los `AGENTS.md`.
- La contradicción entre los dos archivos de la skill se cierra. Un solo criterio, escrito en el
  archivo que se lee primero.
- La regla es una sola para todos los repos. No hay modo especial que recordar ni configuración que
  se pueda olvidar.

**En contra**:

- En un repo de código, un cambio que solo toca documentación ahora corre `/sync` completo en vez de
  salir temprano. Cuesta tokens. El AC-8 fija que no debe costar ediciones.
- La lista de grupos objetivo hay que mantenerla a mano. Si el ciclo agrega una carpeta de
  artefactos y nadie la suma, esa carpeta empieza a leerse como entregable.
- `/sync` ahora lee prosa larga (el `PLAYBOOK.md` son 18 KB). El riesgo es que anote en el
  `AGENTS.md` un resumen de lo que el documento dice en vez de una convención durable. El freno
  existe, es la regla de "default to doing nothing", pero depende del criterio del agente.

**Neutro**:

- Se revierte con un commit. No hay datos que migrar ni estado que transformar, son dos archivos de
  markdown.
- El cambio es a la skill global de `~/.claude/skills/sync/`, así que aplica de una vez a todos los
  repos, no solo a este.

## Follow-up

- [ ] `/architect` tiene el mismo hueco por otra vía: su pre vuelo cuenta archivos fuente por
      extensión (`.ts`, `.tsx`, `.js`, `.py`, `.go`, `.rs`, `.java`) y en este repo devolvió 2. Ese
      conteo decide si se lanza un subagente a leer código y si el modo ENHANCEMENT se detiene.
      Merece su propia spec.
- [ ] Ninguna skill del ciclo ve los cambios a `~/.claude/skills/`, porque esa carpeta está fuera
      del git de todos los repos y el conjunto de cambios se arma con `git diff`. La skill `/ciclo`
      se construyó ahí y `/sync` no vio ni una línea. Es un hueco más grande que este.
- [ ] Este repo no tiene `docs/scope/`, así que la mitad de la reconciliación que este cambio
      revive no tiene nada que reconciliar todavía. Correr `/scope` cuando haya trabajo que planear.
- [ ] `AGENTS.md` sigue con `## Build approach` en `<TBD, lo define /scope>`.
