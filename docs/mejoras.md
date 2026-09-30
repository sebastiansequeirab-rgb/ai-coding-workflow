# Mejoras del workflow

El backlog vivo. Se alimenta desde los chats de trabajo (ver "Cómo se alimenta" abajo) y se
revisa en el chat de ajuste de cada viernes. Lo decidido pasa al `PLAYBOOK.md` y a
`~/.claude/CLAUDE.md`; aquí queda el rastro con su evidencia.

## Por observar esta semana (28 sep – 2 oct 2026)

Los cuatro criterios de la prueba, en cada chat de trabajo real:

1. ¿Declaró el modo en la primera línea y confirmó antes de arrancar?
2. ¿Las respuestas cupieron en 8 líneas, 15 como mucho?
3. ¿Las decisiones técnicas llegaron como propuesta en mi idioma, con recomendación, sin pregunta
   técnica seca?
4. ¿Hizo git solo (commit, y rama/PR/merge donde hay hook o CI) sin que yo pensara en ramas?

Lo que falle se anota en "Observado" con repo, fecha y una línea.

## Observado

_(vacío al 2026-09-30; aquí van las líneas que llegan desde los chats y desde los issues de GitHub)_

## Pendientes

| Desde | Qué | Evidencia | Estado |
|---|---|---|---|
| 2026-10-27 | Firecrawl: si en un mes no se usó ni una vez, archivar las 8 skills con `mv ~/.claude/skills/firecrawl* ~/.claude/skills-archive/` (pesan 1-2k por arranque) | `PLAYBOOK.md`, "Arranque liviano" | esperar la fecha |
| 2026-09-27 | `/sync` sigue sumando líneas sin podar y no captura aprendizajes puntuales. La spec 0003 quedó Superseded pero el problema sigue | `docs/specs/0003`, registro 0005 | idea: podar es trabajo de `/audit` o mío; lo puntual va a memoria |

## Ideas sin decidir

- Una lección nueva en `aprendizaje/lessons/` para los dos modos, usando los motores de `assets/`.
  Solo si después de una semana hace falta entrenar el reflejo.
- Micro-lección "qué evidencia pedir según el cambio" (typecheck, tests, captura). Hueco visto el
  2026-09-01 (no sabía qué es TDD) y el 2026-09-27 (registro 0005).
- Superpowers (`obra/superpowers`): sigue fuera. Dos metodologías a la vez es la confusión que se
  vino a eliminar.

## Hecho

| Fecha | Cambio | Evidencia |
|---|---|---|
| 2026-09-27 | Entrevista de 26 preguntas: por qué el ciclo viejo frenaba | `aprendizaje/learning-records/0005` |
| 2026-09-27 | Workflow copiado a JS Mastery: sin ciclo obligatorio, skills como sugerencias | `PLAYBOOK.md`, `~/.claude/CLAUDE.md` (commit `cf95e62` en `~/.claude`) |
| 2026-09-27 | Dos modos: tiro al piso / planear y crear. Plan corto en archivo | `~/.claude/CLAUDE.md`, "Dos modos de trabajo" |
| 2026-09-27 | Decisiones técnicas como propuesta en su idioma; mensajes de 8-15 líneas; términos en inglés con paréntesis | `~/.claude/CLAUDE.md`, "Cómo hablarme" |
| 2026-09-27 | `/brujula` y `/ciclo` archivadas; hooks solo informan; `scout` y `researcher` instalados | `~/.claude/skills-archive/`, `~/.claude/agents/` |
| 2026-09-27 | Opus 5.5 `medium` por defecto, Fable 5.1 `high` a pedido, Haiku en subagentes | `~/.claude/settings.json`; doc verificada en `PLAYBOOK.md`, "Qué modelo uso" |
| 2026-09-27 | Git entero en manos del agente (rama, PR, merge donde hay hook o CI) | `~/.claude/CLAUDE.md`, "Autonomía y memoria" |
| 2026-09-27 | Arranque de 60,049 a 28,020 tokens (−53%) en cinco pasadas; la grande fue negar Artifact y Workflow | `PLAYBOOK.md`, "Arranque liviano" |
| 2026-09-27 | Regla de qué herramienta para qué (scout, researcher, Firecrawl, Chrome, Playwright) | `~/.claude/CLAUDE.md` |
| 2026-09-27 | Proyecto C limpio: AGENTS.md raíz de 27 a 10 KB, arranque de 52k a 45k | Proyecto C PR #106, `docs/reviews/0003` |
| 2026-09-27 | Este repo actualizado al workflow nuevo: ciclo viejo archivado, guías y este backlog | commit `886066c` |
| 2026-09-27 | Proyecto D limpio: AGENTS.md raíz de 318 a 160 líneas, `supabase/` de 521 a 209, 7 skills fuera, 16 verify.md fuera; arranque de 33,759 a 28,702 (−15%, bajo la meta de 31k) | Proyecto D PR #1 y #2, `docs/reviews/0001` y `0002` de ese repo |
| 2026-09-27 | Entrevista de perfil (14 bloques): trabajo, repos, nivel técnico, límites duros, deploy, modelos, memoria | registro privado; `global/CLAUDE.md` y `~/.claude/personal.md` |
| 2026-09-27 | Skill `/whatsapp` con su voz; 6 skills archivadas; `grilling` confirmada como la canónica | `~/.claude/skills/whatsapp/` (privada), `~/.claude/skills-archive/` |
| 2026-09-27 | Limpieza a fondo de este repo: reglas de la entrevista al PLAYBOOK, 4 archivos muertos fuera, referencias a skills archivadas quitadas | `docs/specs/0004`, `docs/reviews/0003` |
| 2026-09-27 | Hooks sin el ciclo viejo: fuera el aviso de "no hay commit de /sync", `ciclo-arranque.sh` pasa a `arranque-repo.sh`, `/audit` ya no es "paso de apertura". Probado en dos repos de mentira | commit `b9956d4` en `~/.claude` |
| 2026-09-28 | Proyecto E limpio: `CLAUDE.md` de 901 a 10 líneas (importa la regla de BD entera, a propósito), arranque de 65,994 a 36,171; memoria del repo de 35 entradas a 0 | Proyecto E spec 0001, commits `e9576bb`, `c601291`, `c66230a` |
| 2026-09-28 | Comandos de más de un minuto: avisar cuánto tardan y correrlos en segundo plano. Salió de una memoria de Proyecto E (la espera muda se leía como "se trabó" en demos) | `~/.claude/CLAUDE.md`, "Cómo hablarme" |
| 2026-09-28 | Guía oficial de prompts de Opus 5.5 aplicada: regla de no pararse antes de tiempo y lista global de patrones de frontend a evitar. Lo demás ya se cumplía o es de API | `PLAYBOOK.md`, "Cómo pedirle a Opus 5.5"; `~/.claude/CLAUDE.md`, "Alcance" |
| 2026-09-27 | Línea de estado muestra la carpeta (ya mostraba contexto y uso de sesión) | `~/.config/ccstatusline/settings.json`, render probado |
| 2026-09-30 | Workflow publicado: repo público nuevo con instalador (`install.sh`), lo personal a `~/.claude/personal.md`, pre-commit de privacidad; el historial viejo queda en un repo privado | `docs/specs/0005`, `HISTORIA.md` |
| 2026-09-30 | Guía para aplicar el workflow en un repo, con el mensaje del primer chat (diagnóstico por casos A-D) | `docs/guias/aplicar-en-un-repo.md` |

## Descartado

Lo que se probó y no sirvió, con su porqué. Lo anterior a la publicación está en `HISTORIA.md`,
"Lo que no sirvió".

| Fecha | Qué | Por qué | Evidencia |
|---|---|---|---|

## Cómo se alimenta

Al final de cualquier chat de trabajo donde algo molestó, o donde algo salió especialmente bien,
pega esto (el chat puede estar en cualquier repo):

```
Agrega una línea a ~/ai-coding-workflow/docs/mejoras.md, sección "Observado", con este formato:
`- <fecha> · <repo> · <modo> · <qué pasó en una oración> · <qué cambiaría, o "nada, solo anotar">`.
Lo que pasó: <cuéntalo en tus palabras>. Commit directo en ese repo.
```

**Feedback de otras personas:** llega como issue o discusión en GitHub. El viernes se pasa a
"Observado" con el enlace al issue, y se responde ahí qué pasó con él.

El viernes, chat aquí con: "Lee docs/mejoras.md, sección Observado. Propón qué cambiar en el
PLAYBOOK y en ~/.claude/CLAUDE.md, una cosa a la vez con tu recomendación, y aplica lo que apruebe.
Lo aplicado pasa a Hecho con su evidencia; lo que no sirvió, a Descartado con su porqué."
