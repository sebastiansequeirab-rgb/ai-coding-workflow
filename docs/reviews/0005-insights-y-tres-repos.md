# 0005. Review: el workflow contra el uso real y tres repos de apps

- **Fecha:** 2026-10-02
- **Contra:** el informe `/insights` del 2026-10-02 (169 sesiones analizadas, 50 con análisis
  detallado), una muestra de transcripciones, `~/.claude/settings.json` y los hooks, y tres repos
  de apps revisados en solo lectura: Proyecto C, Proyecto G y Proyecto H (G y H son nuevos en esta
  numeración). Los informes de cada repo viven en ese repo, porque nombran al cliente.
- **Método:** cuatro subagentes en paralelo, uno por repo y uno para el workflow. De los 50
  análisis detallados, 34 son del 27 sep en adelante, ya con el workflow nuevo.

## Resultado en una línea

Las reglas de comunicación del workflow nuevo se cumplen. Lo que falla está debajo de ellas: la
capa de permisos, los comandos que el agente devuelve y la verificación de pantallas móviles.

## Cómo se trabaja de verdad

- 37 de 50 sesiones mezclan varias tareas. El código es menos de un cuarto de los objetivos: el
  resto es operación y git, comunicación, specs y explicaciones.
- Hay un patrón que no está escrito en ningún lado: corridas largas sin supervisión, lanzadas con
  `claude --model fable --permission-mode auto "Lee docs/proximo-chat.md y ejecútalo."`. El
  `docs/proximo-chat.md` del repo hace de plan y de estado al mismo tiempo.

## Lo escrito contra lo que pasa

| Regla escrita | Lo que pasa | Evidencia |
|---|---|---|
| "BD de producción: en repos sin usuarios reales decides tú" | El clasificador del modo `auto` la bloquea igual. Un "hazlo" genérico no cuenta como permiso: tiene que describir la acción exacta | Sesiones `4b91bcaa`, `9f5e048d`, `0555f697`; doc oficial `code.claude.com/docs/en/auto-mode-config` (verificada por subagente) |
| "Git lo llevas tú entero" | Merge, invitar colaborador y proteger main quedaron bloqueados | `dbadc740`, `53af8621` |
| Handoff con `/handoff` | Esa skill escribe en la carpeta temporal y no se dispara sola. En la práctica se usa `docs/proximo-chat.md` dentro del repo | `~/.claude/skills/handoff/SKILL.md` |
| "Observado" se alimenta desde los chats | Está vacío, aunque esta semana hubo al menos tres fricciones que merecían una línea | `docs/mejoras.md` |
| Declarar el modo, preguntas de a una con recomendación | Se cumple | Transcripciones `3ca2b0ae`, `a9445e99`, `8a89698d` |

## Fricciones

**Ya resueltas por la versión 2026-09-30:** el trabajo partido en 11 a 20 chats, specs marcadas
"Accepted" sin verificar, mensajes largos o con emojis, trabajo pateado al "próximo chat".

**Siguen vivas:**

1. El modo `auto` bloquea lo que las reglas aprueban. No hay `autoMode.environment` ni reglas
   `allow` en `~/.claude/settings.json`.
2. Los comandos que el agente devuelve fallan: `!` en zsh que hizo que un seed no corriera sin
   avisar, la carpeta equivocada, `eas` sin instalar, un deploy que republica un build viejo
   (`9f5e048d`, `cd2b519e`, `93477b9f`).
3. Pantallas dadas por listas después de probarlas solo en web, que fallan en el iPhone o en Expo
   Go (`3ca2b0ae`, `a07bfb68`, `b6742fec`).
4. Pedidos entendidos con la forma equivocada: demo en vez de producción, un repo en vez de todos
   (`8a89698d`, `8f70ff90`).
5. Datos de prueba que quedan en bases reales (`cd2b519e`, `d504df3e`).

## Lo que muestran los tres repos

- **Sin CI, los chequeos mienten.** En Proyecto H, un test e2e falla y la spec dice "tests en
  verde". Proyecto C tiene CI y su estado declarado coincide con el real.
- **Planes que crecen:** una spec de Proyecto H sumó 9 cambios después de aprobada, en vez de abrir
  una nueva.
- **Review hecho por el mismo modelo** que escribió el código, y 12 PRs encadenados sin review ni
  merge (Proyecto H).
- **La fricción 2 confirmada en el código:** el script de deploy de Proyecto C publica la consola
  sin reconstruirla.
- **Permisos de repo demasiado anchos:** `Bash(npm run *)` en el `settings.local.json` de Proyecto
  C, que también deja correr el deploy y el anonimizado de la base sin preguntar.
- **Restos del ciclo viejo en Proyecto C:** voseo, una regla "una cosa a la vez, y parar" que choca
  con "no te pares antes de tiempo", y specs con el formato viejo mezcladas con las nuevas.
- Los tres tienen hallazgos de seguridad de severidad alta o media. Van en el informe de cada repo.

## Sugerencias del informe de insights, evaluadas

| Sugerencia | Veredicto | Por qué |
|---|---|---|
| Bloque "Production actions" en CLAUDE.md | No | El bloqueo es del clasificador, no del agente; una regla escrita no lo destraba. Además, choca con el repo con usuarios reales |
| Pre-autorizar comandos en settings | Sí | Es la palanca real de la fricción 1 |
| "Comandos que corro yo" | Sí | Fricción 2, sin riesgo |
| Reafirmar la forma del pedido antes de una spec | Sí | Fricción 4, cuesta una línea |
| "Verificación antes de listo" para UI móvil | Sí, pero por repo | La profundidad de verificación la decide el cambio, no una regla global |
| Skill `/handoff` nueva | Ajustar la que existe | Ya existe; falta alinearla con `docs/proximo-chat.md` |
| Hook de typecheck en cada edición | No | Los hooks solo avisan (decisión del 27 sep), es lento en un monorepo y los bugs vivos son visuales |
| MCP de Postgres y GitHub | No | Suma tokens al arranque y `gh` ya funciona; el problema era el permiso |
| Operaciones programadas en el repo con usuarios reales | No | Esos scripts los corre el mantenedor, por regla |
| Agentes en paralelo por pieza | Después | El merge encadenado ya es el punto frágil |
| Screenshots en el simulador del iPhone | Probar | Esfuerzo medio, impacto alto en la fricción 3 |

## Propuestas, ordenadas por impacto y esfuerzo

1. Configurar el modo `auto` (`/auto-mode-setup` o `autoMode.environment`) y sumar reglas `allow`
   angostas por repo.
2. Regla para los comandos que el agente devuelve: carpeta, sin `!`, `npx` en vez de herramientas
   globales, reconstruir antes de publicar, y verificar el resultado después.
3. En planear y crear, la primera línea también dice qué es (producción o demo, para qué entorno).
4. En los repos Expo, una línea en su AGENTS.md: un cambio visual dice en qué plataformas se probó.
5. Que el PLAYBOOK diga lo que ya se hace: `docs/proximo-chat.md` como handoff y las corridas
   largas en Fable.
6. Alimentar el ajuste del viernes con `/insights`.
7. Datos de prueba solo en una base o rama de desarrollo, y se borran al terminar (AGENTS.md de cada
   repo).

## Lo que no se cambia

Los dos modos, las preguntas de a una con recomendación, el arranque liviano, los hooks que solo
avisan, la skill de mensajes, las specs numeradas y que los scripts de producción del repo con
usuarios reales los corra el mantenedor.
