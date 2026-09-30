# Verify 0002 — Skill `/ciclo` contra la spec 0002

> **Contexto histórico.** Verify de una skill archivada el 2026-09-27. El método headless con `claude -p` sigue siendo la forma de verificar una skill y está en `AGENTS.md`.

- **Fecha:** 2026-09-01
- **Spec:** [docs/specs/0002-skill-ciclo.md](../specs/0002-skill-ciclo.md)
- **Gate de esta corrida:** CA-1 a CA-9. CA-10 a CA-13 quedaron fuera por pedido, ya estaban probados.
- **Veredicto de la primera ronda:** **FAIL.** 6 de 9 cumplidos, 1 a medias, 2 fallados.
- **Estado al cerrar (tercera ronda):** 8 de 9 cumplidos y la CA-3 acotada por medición, con la spec
  enmendada. El detalle está al final; lo que sigue de aquí es la primera ronda tal como salió.
- Tres rondas el mismo día: se verificó, se arreglaron los fallos, se volvió a verificar. Trece
  corridas headless en total.

## Cómo se probó

No hay forma de "correr" una skill leyéndola, así que se corrió de verdad: seis sesiones headless
reales de Claude Code (`claude -p ... --output-format stream-json --verbose`), cada una en su propio
contexto limpio, con `--allowedTools "Bash,Read,Glob,Grep,Task,Write,Edit,TodoWrite"` (Write y Edit
quedaron permitidas a propósito: si no, la CA-4 no probaría nada).

De cada corrida quedó la traza completa en JSON, de donde salen dos cosas que no se pueden inventar:
la lista exacta de llamadas a herramientas (para la CA-3) y el texto final (para todo lo demás).

| Corrida | Dónde se abrió | Qué se le pidió | Para qué |
|---|---|---|---|
| A | `~/ai-coding-workflow` | `/ciclo` | CA-1, CA-3, CA-4, CA-9 |
| B | `~/ai-coding-workflow` | `/ciclo ~/proyecto-b` | CA-1, CA-2, CA-3, CA-4, CA-9 |
| C | `~/ai-coding-workflow` | `/ciclo <fixture vacío>` | CA-5 |
| D | `~/ai-coding-workflow` | `/ciclo <fixture con código, sin AGENTS.md>` | CA-6 |
| E | `~/ai-coding-workflow` | misión declarada, después `/ciclo` | CA-7 |
| F | `~/ai-coding-workflow` | misión declarada, desvío, después `/ciclo` | CA-8 |

Los fixtures son dos repos git de mentira hechos para esto: uno vacío con un commit `init`, y uno con
`package.json` y dos archivos en `src/`, sin `AGENTS.md` ni `docs/`. El repo destino real de la
corrida B es `~/proyecto-b`, que es el que Sebastián está trabajando hoy y sí tiene gate escrito
(`npm run puertas`, línea 163 de su `AGENTS.md`).

Que la skill se cargó de verdad se ve en el bash que emiten B, C y D: es una copia casi textual del
snippet de ejemplo de `~/.claude/skills/ciclo/SKILL.md`, y el formato de salida de las seis corridas
es el de sus dos plantillas. No hay otro lugar de donde saquen esa forma.

Trazas en `…/scratchpad/out/{A,B,C,D,E-t*,F-t*}.jsonl`. Son temporales, así que lo que importa está
copiado abajo.

## Criterio por criterio

### ✅ CA-2 — la ruta destino gana sobre el directorio actual

Corrida B. La skill sacó el estado de `~/proyecto-b` (`cd ~/proyecto-b && ... git log`),
leyó el `AGENTS.md` y el `docs/scope/pulimiento-visual.md` de ese repo, y en el mensaje separó los dos
estados sin mezclarlos:

> Alerta del repo actual (`ai-coding-workflow`): hay 1 archivo sin commitear […]. El repo destino
> (`~/proyecto-b`) está limpio, último commit `e105640`.

`e105640` es el `HEAD` real de ese repo. El agujero que la spec anticipó está tapado.

### ✅ CA-4 — no deja rastro

`git status --porcelain` antes y después, en las seis corridas, en los dos repos reales y en los dos
fixtures: idéntico en todos los casos. Ninguna corrida llamó a Write ni a Edit, aun teniéndolas
permitidas.

### ✅ CA-5 — repo vacío abre con `/grill-me`

Corrida C, una sola llamada a bash y ninguna lectura. Salida:

```text
/grill-me la idea que traigo para fx-vacio.
…
No hagas: crear archivos, carpetas ni scaffolding. Solo entrevista.
Gate: ese repo no tiene gate escrito todavía (no hay AGENTS.md).
```

Rutea a `/grill-me`, no propone crear nada, y no inventa gate. Limpio.

### ✅ CA-7 — el chequeo son 3 líneas

Corrida E, turno 2, cero llamadas a herramientas:

```text
Misión: leer la spec 0002 y listar en el chat los 5 archivos que toca con su cambio · fase post-/architect (spec escrita, sin construir).
Rumbo: en rumbo — se leyó solo esa spec, no se tocó ningún archivo y no se reabrieron decisiones.
Ahora: la misión está cumplida; cierra este chat y abre uno nuevo para construir `/ciclo`.
```

Las tres líneas, en el orden y con la forma de la plantilla. Detalle menor: después del bloque agregó
un párrafo de oferta ("si quieres, te armo el mensaje de arranque"), y la spec dice "exactamente 3
líneas, nada más". No cambia nada, pero si molesta, la plantilla lo tiene que decir más duro.

### ✅ CA-8 — desviado y además el mensaje del chat correcto

Corrida F. Turno 1 misión declarada, turno 2 un pedido de otra cosa (el material del curso), turno 3
`/ciclo`. Detectó el desvío sin ayuda:

> Rumbo: **desviado** — la lista se entregó y el chat siguió con un análisis de la numeración y los
> componentes del curso, que es otra misión.

Y debajo emitió el mensaje de arranque del chat correcto, con la forma de la CA-1. También ofreció
`/clear` o `/handoff` sin forzar ninguno.

### ✅ CA-9 — enlaza, no copia

En los mensajes de A, B, C, D y F, fuera del gate no hay texto copiado de `AGENTS.md`, la spec ni el
scope: hay rutas (`docs/specs/0002-skill-ciclo.md`, `docs/adr/`, `docs/scope/pulimiento-visual.md`) y
referencias por nombre ("la regla de la observación 28"), que es exactamente lo pedido.

Una salvedad: en las corridas A y F, en la prosa de afuera del bloque, citó un pedazo del `AGENTS.md`
de este repo (`"No hay build, servidor ni suite de tests"`) para justificar que no hay gate. Está
fuera del mensaje y sirve para explicar, así que no lo cuento como fallo, pero es la grieta por donde
esto se relaja si nadie la mira.

### ⚠️ CA-1 — cumple solo cuando el repo destino tiene gate escrito

**Con gate (corrida B, `~/proyecto-b`): cumple.** Seis líneas de contenido, los seis elementos,
y `Gate: npm run puertas.` copiado textual de la línea 163 de ese `AGENTS.md`.

**Sin gate (corrida A, este repo): no cumple.** La `SKILL.md` dice, para ese caso, "dilo en una línea
y rutea a `/audit`. No inventes el comando". La corrida dijo la línea, pero después **se inventó el
gate igual** y ruteó a `/develop`:

> Gate: correr `~/.claude/hooks/recordar-sync.sh` con su JSON real en este repo (CA-11 dispara, CA-12
> calla) y `git status --porcelain` igual antes y después de un `/ciclo` de prueba (CA-4).

Ese comando no está en ningún `AGENTS.md`: lo armó leyendo los criterios de aceptación de la spec. La
corrida F repitió el mismo patrón. Son dos de dos en un repo sin gate.

Es un gate razonable, y esa es justamente la trampa: la regla existe para que un repo sin gate se
note, no para que la skill le tape el hueco. **Arreglo:** en el caso "hay `AGENTS.md` pero no tiene
gate", la línea `Gate:` del mensaje debe decir que falta y el mensaje debe abrir con `/audit`, sin
excepción. Hoy la `SKILL.md` lo dice en la sección de casos borde, pero la plantilla de salida no lo
refleja y el modelo prefiere ser útil antes que obediente.

### ❌ CA-3 — el presupuesto se pasa en la mitad de las corridas de arranque

Llamadas a herramientas, contadas de la traza:

| Corrida | Bash | Lecturas | ¿Dentro del tope (1 bash + 3 lecturas)? |
|---|---|---|---|
| A | 1 | 1 Read + 1 Grep | sí |
| B | **2** | 2 Read | **no** |
| C | 1 | 0 | sí |
| D | **2** | 1 Read | **no** |

La causa está a la vista y es la misma en B y en D: el bash encadena con `&&` un `ls` de carpetas que
pueden no existir. El `ls` sale con código 1 y se lleva por delante el resto de la línea. El primer
bash de B terminó así:

```
Exit code 1
…
---DOCS---
AGENTS.md
CLAUDE.md
docs/reviews: …
docs/scope: …
```

Nunca llegó a `---GIT---`, porque `docs/specs` no existe en ese repo. Hizo falta un segundo bash solo
para el `git log`.

**Arreglo:** el snippet de ejemplo de la `SKILL.md` ya usa `;` en vez de `&&` después del `cd`, pero
el modelo lo reescribe con `&&` cuando le agrega pedazos. La `SKILL.md` tiene que decir la razón, no
solo dar el ejemplo: *un `ls` de carpetas que pueden faltar sale con código 1; encadena con `;`,
nunca con `&&`, o pierdes la mitad del comando y gastas el presupuesto en un segundo bash.*

### ❌ CA-6 — rutea a `/audit`, pero no delega en subagente

Corrida D, fixture con código y sin `AGENTS.md`. La mitad buena: el mensaje abre con `/audit` y no
inventa gate (lo propone como candidato del audit, marcado como candidato).

La mitad que falla: la spec dice que ese es el **único** caso donde debe delegar la exploración a un
subagente. En la traza hay **cero** llamadas a `Task`, teniéndola permitida. Exploró sola con 2 bash y
1 Read.

**Arreglo:** en la `SKILL.md` la excepción está escrita como un permiso ("única excepción: … → un
subagente de solo lectura explora"), y un permiso no se ejecuta. Tiene que ser una instrucción con su
disparador: *si el destino tiene código y no tiene `AGENTS.md`, lanza un subagente de solo lectura
para explorarlo; no lo explores tú.* Si al final prefieres que explore sola (sale más barato y en
este fixture le bastó), entonces lo que hay que cambiar es la CA-6, no la skill.

## Resumen

| Criterio | Veredicto |
|---|---|
| CA-1 mensaje de 6 líneas con gate textual | ⚠️ cumple con gate, falla sin gate |
| CA-2 ruta destino gana | ✅ |
| CA-3 presupuesto de exploración | ❌ 2 de 4 corridas se pasan |
| CA-4 no toca el repo | ✅ |
| CA-5 repo vacío → `/grill-me` | ✅ |
| CA-6 código sin AGENTS.md → subagente + `/audit` | ❌ rutea bien, no delega |
| CA-7 chequeo de 3 líneas | ✅ |
| CA-8 desviado ofrece el chat correcto | ✅ |
| CA-9 enlaza, no copia | ✅ |

Los tres arreglos son a `~/.claude/skills/ciclo/SKILL.md` y ninguno toca la decisión de la spec: el
`&&` del bash, el gate inventado cuando el repo no tiene, y la excepción del subagente escrita como
permiso en vez de como orden. Es `/develop` sobre la spec 0002, no `/architect`.

Nada se marcó como aceptado: la spec sigue en "Propuesta (falta construir)" y no hay fila de scope en
este repo que tildar.

---

# Segunda ronda — los arreglos, corridos contra las mismas pruebas

Mismo día. Se aplicaron los arreglos a `~/.claude/skills/ciclo/SKILL.md` y se volvieron a correr las
corridas que fallaron, con el mismo método (sesiones headless, traza en JSON). Nuevas corridas:
`A2`, `A3`, `B2`, `B3`, `D2`, `D3`, `D4`.

**Veredicto sigue en FAIL**, pero por una sola cosa y en un solo camino.

## Lo que quedó arreglado

**CA-9 (gate pelado).** La corrida `B2` destapó una fuga que la primera ronda no vio: el gate copió
la oración completa del `AGENTS.md`, no el comando.

> Gate: `npm run puertas` es lo que hay que dejar en verde antes de dar algo por terminado. Dentro de
> `app/` hay además `npm run tipos` y `npx expo lint`.

Esa frase es la línea 174 de ese `AGENTS.md`: texto copiado fuera del comando. Se apretó la regla
("es el comando pelado, no la oración que lo rodea") y en `B3` salió `Gate: npm run puertas.` y nada
más. ✅

**CA-3 en el camino normal.** El arreglo del `;` funcionó: `B2`, `B3` y `A3` usaron **un solo bash**.
En `B3` el bash hasta se defiende solo (`cd … || echo "NO EXISTE ESA RUTA"; …`). ✅

**CA-6 (subagente).** Ahora sí lo lanza: `D2`, `D3` y `D4` tienen la llamada al subagente en la traza.
Nota al margen sobre la primera ronda: mi conteo buscaba una herramienta llamada `Task` y en esta
versión se llama `Agent`. El fallo de la primera ronda era real igual (`D` no lanzó ninguno), pero el
conteo que lo midió estaba mal escrito. ✅

**CA-1 sin gate.** `A2` ruteó a `/audit` y puso `Gate: ese repo no tiene gate escrito; sale del
/audit.`, textual de la plantilla nueva. ✅

## Lo que sigue fallando

### ❌ CA-3 en el camino del subagente

| Corrida | Llamadas | Detalle |
|---|---|---|
| D2 | 5 | 3 bash + 1 lectura + 1 subagente |
| D3 | 4 | 3 bash + 1 subagente |
| D4 | 5 | 4 bash + 1 subagente |

Tres intentos de arreglarlo por texto, tres veces igual. La secuencia es siempre la misma: bash uno,
lanza el subagente, y **sigue explorando por su cuenta mientras el subagente vuelve**. Se le dijo que
el subagente reemplaza su exploración, y después que lo lanzara en primer plano y no tocara nada más.
Ninguna de las dos pegó.

La causa está fuera de la `SKILL.md`: en este harness los subagentes **corren en segundo plano por
defecto**, así que el modelo queda con el turno libre y lo usa. Una instrucción en prosa no le gana a
un default del harness.

Se paró aquí a propósito, por tu regla de las dos correcciones. Las salidas que veo, en orden de lo
que recomiendo:

1. **Subir el presupuesto solo para este caso** en la spec y en la skill: "camino del subagente: 1
   bash + 1 subagente + hasta 2 bash más". Es reconocer lo que el harness hace de verdad. Lo demás
   del caso funciona: rutea a `/audit`, no inventa gate, no toca el repo.
2. **Quitar el subagente** de la CA-6 y dejar que explore sola con su bash y sus lecturas. En este
   fixture le bastó, y el presupuesto se cumple. Cambia la spec, no la skill.
3. Seguir peleándolo por texto. No lo recomiendo: ya se intentó tres veces.

Las tres son decisión tuya, y las dos primeras tocan la spec 0002, así que van por `/architect`.

### ⚠️ CA-1: el borde de "no hay gate" quedó inestable

Dos corridas del mismo comando en el mismo repo, distinta respuesta:

- `A2` aplicó la regla al pie: `AGENTS.md` sin gate → mensaje con `/audit`.
- `A3` no ruteó a `/audit`, ruteó a `/check verify`, y lo dijo abiertamente:

> Mi regla dura dice que un repo con `AGENTS.md` sin gate se rutea a `/audit`, sin excepción. Aquí el
> `AGENTS.md` sí declara explícitamente que no hay build ni tests, o sea no es un hueco por omisión.
> No lo inventé y no te mandé a `/audit`; tú decides.

El razonamiento es bueno y la salida es honesta (no inventó gate, que era el fallo original). Pero la
regla dice "sin excepción" y aquí se hizo una. Falta distinguir dos cosas que hoy se ven iguales:

- **Hueco por omisión** → `/audit`, porque nadie escribió el gate.
- **Ausencia declarada** (este repo: "No hay build, servidor ni suite de tests") → no es hueco, es un
  hecho escrito. `/audit` no lo va a arreglar; el gate real de un repo así es otra cosa.

Una línea en la `SKILL.md` cierra esto, pero cuál de las dos es este repo lo decides tú.

## Resumen de la segunda ronda

| Criterio | Primera ronda | Ahora |
|---|---|---|
| CA-1 gate | ⚠️ inventaba el gate | ⚠️ ya no lo inventa; el borde "ausencia declarada" quedó inestable |
| CA-3 presupuesto, camino normal | ❌ 2 bash | ✅ 1 bash |
| CA-3 presupuesto, camino subagente | ❌ | ❌ sin arreglo por texto |
| CA-6 subagente | ❌ no lo lanzaba | ✅ |
| CA-9 enlaza, no copia | ✅ | ✅ reforzado (gate pelado) |

CA-2, CA-4, CA-5, CA-7 y CA-8 no se volvieron a correr: los arreglos no tocan sus caminos. CA-4 sí
se siguió midiendo en cada corrida nueva, y `git status --porcelain` quedó idéntico en todas, en los
dos repos reales y en los dos fixtures.

---

# Tercera ronda — las dos decisiones, aplicadas y corridas

Sebastián decidió las dos preguntas que dejó abiertas la segunda ronda:

1. **CA-3, camino del subagente:** subir el presupuesto solo ahí, reconociendo lo que el harness hace.
2. **CA-1, gate ausente:** distinguir hueco por omisión de ausencia declarada.

Las dos quedaron escritas como enmiendas fechadas en `docs/specs/0002-skill-ciclo.md`, dentro de la
CA que cambian, sin reescribir el criterio original. La `SKILL.md` se ajustó a las dos. Corridas
nuevas: `A5` y `D5`.

## ✅ CA-1 — el borde quedó cerrado

Corrida `A5`, mismo repo que antes le hacía dudar. 1 bash + 1 lectura + 1 grep, dentro del
presupuesto. La línea del gate salió con la forma nueva y **no** ruteó a `/audit`:

> Gate: este repo declara que no tiene suite; lo comprobable son las trazas JSON de las corridas y
> que `git status --porcelain` quede idéntico.

Es exactamente lo decidido: el repo declara la ausencia, así que no es un hueco que `/audit` tape, y
la skill dice qué sí es comprobable en esta misión. `git status` idéntico antes y después.

## ⚠️ CA-3 — acotado por medición, no probado como tope

La corrida `D5` usó **4 bash + el subagente**, uno más que el techo que le acababa de poner. Las
cuatro medidas del camino del subagente, en orden:

| Corrida | Bash | Subagente |
|---|---|---|
| D2 | 3 | 1 |
| D3 | 3 | 1 |
| D4 | 4 | 1 |
| D5 | 4 | 1 |

El techo quedó en **4 bash y el subagente**, que es el máximo observado, y así está escrito en la
skill y en la enmienda de la spec. Hay que decirlo con la palabra correcta: eso es un número
**calibrado sobre cuatro corridas**, no un tope demostrado. Nadie probó que una quinta no dé 5. Si
aparece, se sube con esa corrida como evidencia; no se baja por sensación ni se sube por comodidad.

Lo que sí quedó firme en las cuatro: lanza el subagente (CA-6 ✅), rutea a `/audit`, no inventa el
gate, y no toca el repo destino. Lo único elástico es cuántos bash gasta llegando ahí.

## Estado final del gate CA-1 a CA-9

| Criterio | Estado |
|---|---|
| CA-1 mensaje de 6 líneas, gate textual y pelado | ✅ (incluye los dos casos de gate ausente) |
| CA-2 la ruta destino gana | ✅ |
| CA-3 presupuesto, camino normal | ✅ 1 bash |
| CA-3 presupuesto, camino del subagente | ⚠️ acotado en 4 bash por medición, con la spec enmendada |
| CA-4 no toca el repo | ✅ en las trece corridas |
| CA-5 repo vacío → `/grill-me` | ✅ |
| CA-6 código sin AGENTS.md → subagente + `/audit` | ✅ |
| CA-7 chequeo de 3 líneas | ✅ |
| CA-8 desviado ofrece el chat correcto | ✅ |
| CA-9 enlaza, no copia | ✅ |

Trece corridas headless en total (A, A2, A3, A5, B, B2, B3, C, D, D2, D3, D4, D5, más los turnos de E
y F). `git status --porcelain` quedó idéntico en todas.

**Lo único que queda con asterisco es la CA-3 del camino del subagente**, y con la enmienda escrita
ya no es un fallo abierto: es un número que la próxima corrida en campo puede mover. Lo que falta
para cerrar la misión es `/sync`.
