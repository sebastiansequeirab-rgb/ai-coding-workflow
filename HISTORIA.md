# Historia del workflow

Cómo llegó a ser lo que es: qué probé, qué sirvió, qué no y con qué evidencia. De aquí en adelante,
cada cambio queda en el historial de git y en [`docs/mejoras.md`](docs/mejoras.md) ("Hecho" o
"Descartado"). Las versiones anteriores a la publicación se cuentan aquí porque su historial de git
es privado: tiene datos de clientes. Los proyectos reales aparecen como Proyecto A, B, C...

## v0: el ciclo de 10 fases (agosto 2026)

**Qué era.** Las skills de [JS Mastery](https://github.com/jsmastery-pro/skills) en orden fijo
(`/scope → /audit → /architect → /develop → /check verify → /test → /check review → /document →
/sync`). Encima le puse reglas propias: "un chat = una misión", "chat bajo 100k tokens", "/sync nunca
se salta".

**Cómo lo aprendí.** Con lecciones interactivas: un quiz de 12 escenarios y un simulador de misión
completa. Siguen en [`aprendizaje/archivo/`](aprendizaje/archivo/) y se abren directo en el
navegador. Registros [0001](aprendizaje/learning-records/0001-arranque-del-entrenamiento.md) y
[0003](aprendizaje/learning-records/0003-simulador-de-mision-completa.md).

**Qué sirvió:** que el estado viva en archivos (scope, specs, `AGENTS.md`). En campo se veía:
checklists vivas que cualquier chat podía retomar
([registro 0002](aprendizaje/learning-records/0002-revision-en-campo-proyectos-a-y-b.md)).

## v1: control del ciclo (1 al 2 de septiembre)

**El problema.** Los rituales de apertura y cierre se cumplían en un proyecto y en otro no.

**Qué probé:**
- Hooks que empujaban a ubicar cada pedido en el ciclo ([spec 0001](docs/specs/0001-control-del-ciclo-en-todos-los-repos.md)).
- Una skill `/ciclo` que arrancaba cada misión ([spec 0002](docs/specs/0002-skill-ciclo.md)),
  verificada en sesiones headless ([review 0002](docs/reviews/0002-verify-skill-ciclo.md)).
- Una brújula (`/brujula`) para saber en qué fase estaba.

**Lo que midió la realidad** ([registro 0004](aprendizaje/learning-records/0004-dos-chats-medidos-en-proyecto-b.md)):
el ciclo se seguía, pero el contexto no. Un chat llegó a 258,900 tokens con la regla de 100k.
El `AGENTS.md` de 47 KB hacía que cada chat arrancara con ~73k tokens antes del primer mensaje.

## v2: se tira el ciclo (27 de septiembre)

**Por qué.** Una entrevista de 26 preguntas
([registro 0005](aprendizaje/learning-records/0005-entrevista-por-que-el-ciclo-viejo-frena.md)).
El ciclo era bueno pero lento: un bug visual se partía en 10 chats, `/architect` me hacía preguntas
técnicas que no entendía, y los planes derivaban. Lo que me empujaba no era la máquina: eran mis
propias reglas y los hooks.

**Qué quedó:**
- JS Mastery literal: sin orden obligatorio, las skills son sugerencias.
- **Dos modos.** Tiro al piso: directo, commit y evidencia según el cambio. Planear y crear:
  diálogo, un plan de una página, construir.
- Las decisiones técnicas llegan como propuesta con recomendación, en lenguaje llano.
- Los hooks solo avisan, y callan si todo está normal.
- **Arranque liviano: de 60,049 a 28,020 tokens (−53%).** La palanca grande fue negar dos
  herramientas que no uso (detalle y mediciones en [PLAYBOOK](PLAYBOOK.md#arranque-liviano-2026-09-27)).
- Una guía para limpiar repos del ciclo viejo, probada en tres proyectos
  ([`docs/guias/limpiar-un-repo.md`](docs/guias/limpiar-un-repo.md)).

## v3: guía oficial de Opus 5.5 (28 de septiembre)

Revisé la guía de prompts de Anthropic para Opus 5.5 contra mis instrucciones. Salieron dos reglas:
- **No pararse antes de tiempo:** con el plan aprobado, sigue sin preguntar "¿sigo?".
- **Frontend:** una lista con nombre de los patrones "de plantilla" a evitar.

## v4: publicado (30 de septiembre)

El workflow pasa a este repo público, con instalador ([spec 0005](docs/specs/0005-publicar-el-workflow.md)).
Lo personal (idioma, clientes, mapa de repos) sale a `~/.claude/personal.md`, que no se publica.

## Lo que no sirvió

| Qué | Por qué se fue | Evidencia |
|---|---|---|
| "Chat bajo 100k" y "un chat = una misión" | Partían un bug en 10 chats. Además no se cumplían: un chat llegó a 258k | registros 0004 y 0005 |
| Orden obligatorio de las 10 fases | Convertía un cambio de minutos en una misión de horas | registro 0005 |
| `/brujula` y `/ciclo` (skills propias) | Casi no las usé, y empujaban al ciclo completo | registro 0005, specs 0001 y 0002 |
| Hooks que ordenaban qué skill correr | Presión sin valor; ahora solo avisan, y callan si todo está normal | spec 0001 (Superseded) |
| `/check verify` en cada cambio | Inútil en bugs visuales; ahora solo con criterios de aceptación escritos | registro 0005 |
| `/sync` al cierre de cada chat | Ahora va alrededor del merge. Sigue sin podar, pendiente abierto | spec 0003 (Superseded) |
| `AGENTS.md` gordos (47 a 150 KB) | Se comían el contexto en cada turno. Ahora se mantienen cortos y anidados | registro 0004, guía de limpieza |
| Guardar el mensaje de arranque | No hace falta: el estado ya está en los archivos | [ADR 0001](docs/adr/0001-el-mensaje-de-arranque-no-se-guarda.md) |
| Varias skills de terceros (tdd, teach, diagnosing-bugs...) | No aportaban a los dos modos. Set mínimo | PLAYBOOK, "Inventario de skills" |
