# Spec 0002 — Skill `/ciclo`

> **Superseded 2026-09-27** por `PLAYBOOK.md` (registro `aprendizaje/learning-records/0005`): `/ciclo` archivada en `~/.claude/skills-archive/`. Ya no hay misión por chat que arrancar ni rumbo que chequear. Se conserva como historia.

- **Fecha:** 2026-09-01
- **Estado:** Construida y verificada el 2026-09-01. Los 5 archivos de la tabla existen (comprobado
  archivo por archivo, no de memoria). El gate CA-1 a CA-9 pasó 8 de 9, con la CA-3 del camino del
  subagente acotada por medición y enmendada abajo: `docs/reviews/0002-verify-skill-ciclo.md`.
  CA-10 a CA-13 se probaron en la sesión de construcción.
- **Decisión de:** Sebastián. Las 13 decisiones se cerraron con `/grill-with-docs` el 2026-09-01 y
  están en `aprendizaje/PROXIMA-SESION.md`, sección A. Esta spec no las rediscute: las traduce a algo
  construible.
- **Vocabulario:** `CONTEXT.md`. Misión, rumbo, gate, mensaje de arranque y repo destino significan
  aquí exactamente lo que dice ese archivo.

## Problema

Dos modos de fallo del ciclo no tienen skill que los mate:

1. **Abrir un chat nuevo cuesta trabajo manual.** El 1 de septiembre se armaron tres mensajes de
   arranque a mano. Los tres desde un repo que no era el repo destino, y los tres redescubriendo
   estado que ya estaba escrito en archivos.
2. **Un chat se desvía y nadie lo nota a tiempo.** La regla de las dos correcciones dice que la
   salida es `/clear` con un mensaje mejor, pero nadie mide el rumbo hasta que ya se perdió el chat.

`/brujula` no cubre ninguno de los dos: diagnostica el repo, no el chat, y todas sus referencias
son relativas al directorio actual (verificado leyendo su `SKILL.md`: si le pasas una ruta la trata
como situación descrita, comportamiento indefinido).

## Decisión

Una skill global, `/ciclo`, con **dos modos y el mismo cerebro**:

| Modo | Cuándo | Salida |
|---|---|---|
| **Arranque** | Al empezar. `/ciclo` o `/ciclo ~/repo-destino` | El mensaje de arranque del chat nuevo, ~6 líneas |
| **Chequeo** | A mitad de chat, con una misión ya declarada | 3 líneas: misión+fase / rumbo / ahora |

Cómo elige el modo (derivado, no viene de las 13): si en este chat ya hay una misión declarada
(hubo un mensaje de arranque o trabajo encaminado hacia un resultado nombrado), es **chequeo**; si
no, es **arranque**. Un argumento de ruta fuerza arranque. Si queda ambiguo, pregunta una línea.

### El mensaje de arranque

**Se repite literal** (solo lo que no vive en ningún archivo):

1. La skill con la que se abre (`/develop …`, `/grill-me …`, la que toque).
2. La misión en una oración.
3. Qué NO hacer.
4. El comando del gate, **copiado textual del `AGENTS.md` del repo destino**.
5. Dónde queda el resultado (ruta del archivo).
6. En qué modo abrir: repo destino y si conviene plan mode.

**Se enlaza, nunca se copia:** el estado del repo (lo inyecta el hook `ciclo-arranque.sh` al abrir),
las reglas del repo (`AGENTS.md`), la spec (`docs/specs/NNNN-*.md`) y el scope.

No emite comando de shell listo para pegar. Emite la línea de "en qué modo abrir" (decisión 10).

### Presupuesto de exploración (tope duro)

**1 comando bash compuesto + máximo 3 lecturas de archivo.** Las tres lecturas, en este orden de
prioridad: `AGENTS.md` del repo destino (de ahí sale el gate), el archivo de scope o la spec de la
feature pendiente, y el tercero según lo que falte. Sin subagente, salvo el único caso de la
decisión 7: repo destino desconocido, con código y sin `AGENTS.md`.

### El agujero de la ruta destino

El hook `SessionStart` inyecta el estado del **directorio actual**. Cuando corres
`/ciclo ~/otro-repo`, ese bloque es del repo equivocado. La skill debe ignorarlo y sacar el estado
del destino con su comando bash. Es la razón principal de que el presupuesto incluya un bash.

## Archivos que toca (5)

| Archivo | Cambio | Tamaño |
|---|---|---|
| `~/.claude/skills/ciclo/SKILL.md` | Nuevo. Frontmatter (`name`, `description` con los disparadores) + los dos modos + el presupuesto + las dos plantillas de salida | ~70 líneas, del porte de `brujula/SKILL.md` (71) |
| `~/.claude/skills/brujula/SKILL.md` | Una línea al final de "Formato de salida": tras señalar la fase, ofrecer `/ciclo` para llevarse el mensaje del chat nuevo | 1 línea |
| `~/.claude/CLAUDE.md` | Una línea en "Tu rol como agente": si el chat se desvía de la misión, sugerir `/ciclo` | 1 línea |
| `~/.claude/hooks/recordar-sync.sh` | La regex de `tocados` suma `md\|mdx\|markdown`; el texto del aviso deja de decir "archivos de código" y dice "archivos de trabajo". Umbral (3) y throttle (1500 s) sin tocar | 2 líneas |
| `PLAYBOOK.md` | Fila en el cheatsheet; bullet en "Guía global impregnada en todos los repos"; inventario de 29 a 30 globales y Propias de 1 a 2 | 4 líneas |

Orden de construcción: `PLAYBOOK.md` primero, porque la regla del repo dice que un cambio al ciclo
va primero ahí. Después la skill, después los tres enganches.

## Fuera de alcance

- **No escribe ningún archivo.** El mensaje se imprime en el chat y se copia. Nada a disco: el
  mensaje es vehículo, no estado (decisión 5).
- **No absorbe ni duplica a `/brujula`.** No repite su tabla de fases ni su diagnóstico completo; se
  llaman entre sí (decisión 3).
- **No emite `cd X && claude`** ni ningún comando de shell.
- **No crea carpetas ni scaffolding**, y no corre por su cuenta la skill que recomienda. Con una idea
  de cero entrega el mensaje para `/grill-me` y nada más (decisión 9).
- **No toca `settings.json`, `ciclo-arranque.sh` ni `aviso-agents.sh`.**
- **No mide tokens del chat ni fuerza `/clear`.** Ofrece; Sebastián decide.
- **No migra ni borra `aprendizaje/PROXIMA-SESION.md`.** Ese archivo se seca solo cuando `/ciclo`
  funcione; retirarlo es otra misión.
- **No se construye en la sesión de esta spec.** Aquí solo se escribe la spec.

## Criterios de aceptación

**CA-1** — CUANDO se corre `/ciclo` sin argumento en un repo con `AGENTS.md`, EL SISTEMA DEBE
imprimir un mensaje de arranque de 6 líneas o menos que contenga los seis elementos de "El mensaje
de arranque", con el comando del gate copiado textual del `AGENTS.md` de ese repo.

> **Enmienda del 2026-09-01 (decisión de Sebastián, tras el verify 0002).** Se copia **el comando
> pelado**, no la oración que lo rodea en el `AGENTS.md`. Y un repo sin gate son dos casos, no uno:
> **hueco por omisión** (el `AGENTS.md` no dice nada) → el mensaje abre con `/audit`; **ausencia
> declarada** (el `AGENTS.md` dice que no hay build ni suite, como este repo) → no es un hueco y no
> se rutea a `/audit`: se dice que el repo lo declara y se sigue con la skill que toque.

**CA-2** — CUANDO se corre `/ciclo ~/otro-repo`, EL SISTEMA DEBE sacar el estado de `~/otro-repo` y
no del directorio actual, e ignorar el bloque "ESTADO DEL REPO" que inyectó el hook.

**CA-3** — CUANDO `/ciclo` arma un mensaje, EL SISTEMA DEBE usar como máximo 1 comando bash
compuesto y 3 lecturas de archivo. Comprobable contando las llamadas a herramientas de la corrida.

> **Enmienda del 2026-09-01 (decisión de Sebastián, tras el verify 0002).** En el camino de la CA-6,
> el único con subagente, el tope es **4 bash y el subagente**. El subagente corre en segundo plano y
> le deja el turno libre al modelo; tres intentos de cerrarlo por texto no lo bajaron. El número está
> calibrado sobre cuatro corridas (3, 3, 4 y 4 bash), no pedido: si en campo aparece una quinta que
> lo pase, se sube con esa evidencia, no por sensación. Detalle en
> `docs/reviews/0002-verify-skill-ciclo.md`, segunda y tercera ronda. El tope original (1 bash + 3
> lecturas) sigue en pie para todos los demás caminos.

**CA-4** — CUANDO `/ciclo` termina en cualquiera de sus dos modos, EL SISTEMA DEBE dejar
`git status --porcelain` igual que antes de correr.

**CA-5** — CUANDO el repo destino está vacío o casi (sin `AGENTS.md`, sin `docs/`, sin código), EL
SISTEMA DEBE entregar el mensaje de arranque para `/grill-me` y no debe proponer crear carpetas ni
archivos.

**CA-6** — CUANDO el repo destino tiene código y no tiene `AGENTS.md`, EL SISTEMA DEBE delegar la
exploración a un subagente (único caso permitido) y el mensaje resultante debe rutear a `/audit`.

**CA-7** — CUANDO se invoca `/ciclo` a mitad de un chat con una misión ya declarada, EL SISTEMA DEBE
imprimir exactamente 3 líneas: misión y fase, rumbo (solo "en rumbo" o "desviado"), y qué hacer ahora.

**CA-8** — CUANDO el chequeo da "desviado", EL SISTEMA DEBE ofrecer además el mensaje de arranque del
chat correcto, con la misma forma de la CA-1.

**CA-9** — CUANDO el mensaje se imprime, EL SISTEMA DEBE enlazar y no copiar el contenido de
`AGENTS.md`, la spec y el scope. Única excepción: el comando del gate. Comprobable leyendo el mensaje:
fuera del gate no hay texto copiado de esos archivos.

**CA-10** — CUANDO `/brujula` termina su diagnóstico, EL SISTEMA DEBE ofrecer `/ciclo` como paso
siguiente para llevarse el mensaje del chat nuevo.

**CA-11** — CUANDO hay 3 o más archivos sin commitear contando `.md` además de código y pasaron 25
minutos desde el último aviso, EL SISTEMA DEBE (hook `recordar-sync.sh`) emitir el recordatorio de
`/sync`. Comprobable corriendo el hook con su entrada JSON real en este repo, que es de markdown y
hoy nunca lo dispara.

**CA-12** — CUANDO `recordar-sync.sh` corre con menos de 3 archivos tocados, o dentro de la ventana
de throttle, EL SISTEMA DEBE callar. Es la no regresión del cambio de la CA-11.

**CA-13** — CUANDO se lee `PLAYBOOK.md`, EL SISTEMA DEBE mostrar `/ciclo` en el cheatsheet, en la
sección de guía global y en el inventario, con el conteo actualizado a 30 globales y Propias en 2.

## Riesgos y consecuencias

- **El mensaje vale lo que valga el `AGENTS.md` del destino.** Si el repo no tiene gate escrito,
  `/ciclo` no puede inventarlo: debe decir que falta y rutear a `/audit`.
- **Contar `.md` en el hook lo hace más ruidoso en repos de documentación** (este). El throttle de 25
  minutos es lo único que lo contiene. Si molesta, el ajuste es subir el umbral de 3, no volver atrás.
- **El presupuesto de 3 lecturas es una apuesta.** Si en campo se queda corto de forma repetida, se
  sube con evidencia (qué mensaje salió flojo y qué archivo faltó), no por sensación.

## Pendiente después de construir

- Cerrar con `/sync`. No hay `/scope` de por medio: es un entregable único.
- Cuando `/ciclo` funcione, evaluar retirar la sección A de `aprendizaje/PROXIMA-SESION.md`.
