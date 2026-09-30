# 0004 — Dos chats medidos en Proyecto B: el ciclo se sigue, el contexto no

> **Nota del 2026-09-27:** la regla de 100k y los hooks que aquí se evalúan son del ciclo viejo, ya archivado. Las mediciones, el método para sacarlas del transcript y el caso del `scout` siguen vigentes; el AGENTS.md de 47 KB sigue pendiente en `docs/mejoras.md`.

- **Fecha:** 2026-09-02
- **Estado:** histórico; ver la nota de arriba

## Qué se midió y cómo

Las dos transcripciones más recientes de `~/proyecto-b`, leídas de
`~/.claude/projects/-Users-yo-proyecto-b/`:

| Archivo | Qué es | Ventana |
|---|---|---|
| `49ac70c5-6e12-4a4f-ae1d-24a7ceb0dd2b.jsonl` | El chat cerrado | 1 sep 21:27 → 2 sep 14:10 |
| `167b411f-938b-4665-85b2-17e4af565adc.jsonl` | El chat recién abierto | 2 sep 14:10 → 14:13 |

Método, para poder repetirlo: cada línea del `.jsonl` es un evento. De los eventos
`type: assistant` se lee `message.usage`, y el contexto de ese turno es
`input_tokens + cache_read_input_tokens + cache_creation_input_tokens`. Las llamadas a
herramientas salen de los bloques `tool_use` del mismo evento. Los mensajes de Sebastián
salen de los eventos `type: user` con texto.

## Los números

| | Chat cerrado | Chat nuevo (un solo mensaje) |
|---|---|---|
| Turnos de Opus 5 | 180 | 45 |
| Llamadas a Bash | 87 | 32 |
| Subagentes | 0 | 0 |
| Contexto al arrancar | 72,811 | 72,947 |
| Contexto pico | **258,900** | **146,953** |
| Cache read total | 31.0M | 4.9M |
| Output | 200,405 | 22,629 |

Partido por día, el chat cerrado:

| Tramo | Turnos | Cache read | Promedio por turno |
|---|---|---|---|
| Noche del 1 sep | 127 | 18.8M | 148,159 |
| Día siguiente, 2 sep | 55 | 12.2M | **221,491** |

## Lo que ya domina (evidencia, no opinión)

1. **El mensaje de arranque del chat nuevo es el mejor que ha escrito.** Trae misión, qué no
   tocar ("la fase 0 ya está construida y no se toca"), qué cambió desde ayer (mi compañero de backend desplegó,
   cae la AC-15), dónde vive el plan, y la advertencia de que esa observación no tiene fila en
   `docs/scope/`. Lo armó sin que nadie se lo pidiera.
2. **Verifica con evidencia, no con "listo".** A las 21:34:03 corrió *"Prove the gate bites,
   then restore"*: rompió a propósito para probar que la puerta muerde, y después restauró.
   `npm run puertas` corrió varias veces, incluso después de mergear los seis commits de mi compañero de backend.
3. **Los dos chats abren con una skill**, no a mano. `/develop` en los dos casos.
4. **`/sync` corrió de verdad**, con tres ediciones quirúrgicas al `AGENTS.md` y su commit.
5. **Empuja calidad en la salida al cliente**: "hazlo más resumido, que de verdad lo lea".

## Los cuatro huecos, ordenados por lo que costaron

1. **El chat nunca se cerró.** La regla propia es chat bajo 100k. Llegó a 258,900, unas 2.6
   veces. Lo caro no es el pico: a las 21:51 iba en 209k, paró, y a las 13:55 del día siguiente
   **reanudó el mismo chat** en vez de hacer `/clear`. Esos 55 turnos corrieron a 221k promedio,
   12.2M de cache read en un solo día. En un chat nuevo hubieran corrido cerca de 90k. Es
   aproximadamente la mitad del gasto total del chat, en la parte más fácil de evitar.
2. **Cuatro misiones en un chat.** Arrancó como `/develop` tareas 1 y 2 de la fase 0. Terminó
   arreglando el PDF del reporte al cliente, actualizando el índice de pedidos a mi compañero de backend,
   mergeando sus seis commits, instalando una dependencia, levantando Metro y cerrando los
   pedidos 12 y 13. La desviación fue declarada en voz alta a las 21:46: *"Vamos a hacer de un
   horario este chat"*. Lo rescatable: los commits sí quedaron separados.
3. **Cero subagentes en los dos chats.** El chat nuevo lleva 32 llamadas de pura lectura (leer
   `vendedor.php` en dos partes, listar componentes, buscar el modal, probar la API viva) y por
   eso ya va en 147k con un solo mensaje. Ese es el caso exacto del scout, que devuelve un mapa
   compacto y deja limpio el hilo principal. El refuerzo 5 del PLAYBOOK lo dice y no se aplicó.
4. **Falta el eslabón de verificación.** De `/develop` pasó directo a `/sync`, sin
   `/check verify` ni `/test`. `docs/reviews/` de ese repo tiene un solo archivo, del 1 de
   septiembre. Puede estar bien si esa observación va a nivel prototipo, pero **el nivel no está
   escrito en ningún archivo**: la spec 0001 de ese repo no tiene fila en `docs/scope/`. Los
   gates de npm cubren tipos, glosario y paridad; no cubren que el botón Conectar cumpla su AC.

## El piso fijo que nadie estaba mirando

Los dos chats arrancan en ~73k **antes de escribir una línea**. Una parte es propia y se puede
bajar: el `AGENTS.md` raíz de Proyecto B pesa **47,281 bytes**, unos 13k tokens que viajan
en cada turno. En 180 turnos son cerca de 2.3M de cache read por ese archivo solo. La regla de
`/sync` dice *"keep root AGENTS.md short and globally relevant; area specific detail belongs in a
nested doc"*, y el repo ya tiene `app/AGENTS.md`, así que el patrón para partirlo existe.

## Lo que Sebastián decidió al ver esto (2 de septiembre)

Estas tres restricciones cierran la pregunta que la spec 0001 dejó abierta
(*"reevaluar en dos semanas qué avisos se ignoraron; esos son candidatos a bloqueo"*):

1. **Nada pasa a bloqueo.** La guía tiene que ser obvia, no interrumpir el trabajo.
2. **La prioridad es Proyecto B**, no todos los repos a la vez.
3. **Es para él solo.** Que mi compañero de backend no lo siga está bien.

## Lo que ya existe y está desaprovechado

- **La línea de estado.** `~/.claude/settings.json` ya corre `ccstatusline`, refrescando cada 10
  segundos. Una línea de estado es exactamente "obvio sin interrumpir": está siempre a la vista y
  no para el trabajo nunca. Hoy no muestra nada del ciclo. El contexto es calculable desde el
  transcript (así salieron los 258,900 de arriba) y el resto sale de git. **Pendiente de
  comprobar:** qué muestra `ccstatusline` hoy y si se configura o se reemplaza.
- **El archivo privado.** `Proyecto B/.claude/settings.local.json` ya existe y git no lo
  rastrea: lo ignora `~/.config/git/ignore` con la regla `**/.claude/settings.local.json`
  (comprobado con `git check-ignore -v`). Es el sitio correcto para algo que mi compañero de backend no debe ver.
- **Los hooks no cubren esto.** Los tres de la spec 0001 (`ciclo-arranque`, `aviso-agents`,
  `recordar-sync`) cubren apertura y cierre. Los cuatro huecos de arriba pasan en el medio, y
  ninguno de los tres mira el tamaño del contexto.

## Corregido en el momento

`Proyecto B/.claude/settings.local.json` tenía `"outputStyle": "default"`, que anulaba el
`Concise` global solo en ese repo desde el 31 de agosto. La spec 0001 cuenta el output style como
la capa intermedia de control, y en el repo más importante estaba apagada. Se quitó la línea para
que herede del global y haya una sola fuente de verdad.

## Próximos pasos

1. `/architect` actualizando `docs/specs/0001-control-del-ciclo-en-todos-los-repos.md`, con este
   registro como evidencia. Decisión a tomar: qué muestra la línea de estado, con qué umbrales de
   contexto, y si `ccstatusline` sirve o se reemplaza.
2. Antes de diseñar, comprobar qué muestra `ccstatusline` hoy. Es una herramienta de terceros y
   nadie la ha leído.
3. Pendiente aparte, en Proyecto B: partir el `AGENTS.md` de 47 KB con `/audit`, y declarar
   el nivel de workflow de la observación 26 para que se sepa si `/check verify` toca o no.
