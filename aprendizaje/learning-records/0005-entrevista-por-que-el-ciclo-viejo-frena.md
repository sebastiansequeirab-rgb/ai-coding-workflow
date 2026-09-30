# 0005 — Entrevista: por qué el ciclo viejo frena, y la decisión de empezar de cero

- **Fecha:** 2026-09-27
- **Estado:** activo. Abre la carpeta `aprendizaje/jsm-workflow/`.

## Qué dijo Sebastián (cuatro preguntas, en sus palabras resumidas)

**El ciclo es bueno pero demasiado lento: convierte tareas sencillas en misiones de horas.**

1. **Dónde se va el tiempo.**
   - `AGENTS.md` pesados: arrancaba con ~15% del contexto ocupado solo por eso (coincide con el
     registro 0004: 47 KB de AGENTS.md en Proyecto B, ~73k tokens antes del primer mensaje).
   - Un bug visual que antes cabía en un chat lo partía en 10 chats. `/check verify` fue lo más
     inútil de todo el proceso para ese tipo de tarea.
   - Los planes de misión con varios puntos derivaban ("drift asqueroso"): el agente se iba por
     donde fuera y siempre alargaba el plan.
   - El CI de git se tarda y corría a cada rato. No sabe de dónde salió. **Pendiente rastrear.**
   - `/brujula` casi no la usó. `/ciclo` tampoco.
2. **Quién lo empujó a partir el bug en 10 chats:** las reglas del PLAYBOOK ("chat bajo 100k",
   "un chat = una misión") **y** los hooks y las sugerencias del agente. No el contexto real: la
   máquina aguantaba. El ciclo frenaba cuando no hacía falta.
3. **Qué conservar al migrar:** nada a priori. Empezar de cero con el workflow del tutorial de
   JavaScript Mastery y ver qué sobrevive.
4. **Qué hacer con lo global mientras aprende:** que al estar en la carpeta nueva el agente sepa
   que el ciclo es la manera vieja.

## Segundo bloque de la entrevista (preguntas 5 a 10)

5. **Qué lo interrumpía:** `/architect` le hacía preguntas técnicas profundas que no entendía (no
   es programador de carrera, sí tiene experiencia con agentes). Y `/architect`, `/scope` y
   `/develop` pedían "mil vainas" para cosas que antes mataba rápido, o las alargaban en miles
   de chats.
6. **Decisiones técnicas:** quiere que el agente razone y le proponga, en su idioma, no técnico,
   y dialogar para escoger. Siempre con recomendación.
7. **Su semana:** mitad y mitad. Cambios "tiro al piso" que le mandan a hacer rápido, y trabajo
   con planeación, diálogo y creación.
8. **Cómo se elige el modo:** el agente analiza, propone el modo, confirma con él, y arranca.
9. **Qué queda escrito antes de construir (modo planear):** un plan corto de una página en un
   archivo (qué, qué no, cómo sabremos que quedó). Ni spec completa ni nada.
10. **Evidencia (modo tiro al piso):** la elige el agente según el cambio. Visual chico → lo ve
    él; varios visuales → una captura al final, no diez; lógica → chequeos del repo con su
    salida. Se le explicó qué son typecheck y tests, no lo tenía claro.

Todo esto quedó en `~/.claude/CLAUDE.md` (secciones "Cómo decidimos juntos" y "Dos modos de
trabajo") y en el `PLAYBOOK.md`.

## Tercer bloque: lo personal, para las instrucciones globales (preguntas 12 a 19)

12. **Commits:** solos al cerrar un cambio, sin preguntar. Push sigue siendo suyo.
13. **Tareas largas:** un avance de una línea cada tanto y resumen corto al final.
14. **Enseñanza:** una línea de "qué hice y por qué" en cada entrega, en llano.
15. **Largo de mensaje:** 8 líneas normal, 15 si de verdad hace falta. Lo atormentan los mensajes
    largos: no los termina leyendo.
16. **Desacuerdo:** el agente lo dice, propone alternativa con recomendación y espera respuesta.
17. **Términos técnicos:** en inglés, con explicación corta entre paréntesis la primera vez por chat.
18. **Memoria automática:** correcciones y preferencias, más lo esencial que sirvió. Decisión
    tomada: lo del repo al `AGENTS.md`, lo suyo a la memoria, y "lo que sirvió" solo si no se
    deduce del repo y va a volver a importar.
19. **Hook de arranque:** silencio si todo está normal, una línea solo si hay algo raro.

No quiere tocar otros proyectos (Proyecto B) hasta que el workflow esté perfecto aquí.

## Quinto bloque: la prueba en Proyecto C y el merge (preguntas 22 y 23)

Se probó el workflow nuevo en Proyecto C con tres chats: foto antes (`docs/reviews/0002`), plan
de limpieza aprobado, ejecución en rama y PR #106. Resultado: AGENTS.md raíz de 27 KB a 10 KB
(~4,200 tokens menos por turno); anidados casi igual (93 → 90 KB), pendiente el de `(api)`; 11
verify.md, 7 reviews y 1 scope borrados. El CI "que corre a cada rato" resultó ser
`.github/workflows/ci.yml` en cada push a main y PR: el ciclo viejo pusheaba por mini misión.

22. Política de `docs/` viejo: se borra lo muerto, se queda lo vivo; git guarda la historia.
23. Git: el merge lo tenía loco. Regla nueva: el agente hace rama, PR y merge solo en repos con
    hook o CI, y commit directo a main en los que no. Está en `~/.claude/CLAUDE.md`.

## Cuarto bloque: contexto, drift y modelos (preguntas 20 y 21)

Lo que faltaba: drift en misiones largas, contexto que se satura, y arranque lo más liviano
posible. Sebastián no usa la API: paga Max, así que lo que gasta es cupo, no dólares.

- **Medido:** este chat arrancó con 60,049 tokens antes del primer mensaje. Los archivos de
  Sebastián eran ~4k. El resto: conectores de claude.ai y dos plugins sincronizados (`design`,
  `cowork-plugin-management`) que nunca instaló. Ninguno se usa desde la terminal.
- **Hecho:** `disableClaudeAiConnectors: true` y `syncClaudeAiPlugins: false` en `settings.json`
  (verificado en la doc de Claude Code por un subagente). Pendiente medir el próximo arranque.
- **Drift:** la doc confirma que un plan en `.md` se reinyecta tras cada auto-compact. Con eso, el
  plan corto en archivo (pregunta 9), la regla "un plan aprobado no crece" y el `scout` para
  lecturas son la defensa. No se agregó nada más.
- **Modelos:** el PLAYBOOK hablaba de Opus 5 y Fable 5. Un subagente verificó la doc oficial:
  Opus 5.5 (22 sep 2026) en `medium` es el default recomendado por Anthropic; Fable 5.1 solo
  cuando Opus se queda corto; Haiku para subagentes. `settings.json` pasó de `model: opus` a
  `claude-opus-5-5` con esfuerzo por modelo. No existe modo oficial de planear con uno y
  ejecutar con otro: se hace con `/model` a mano.

## Giro a mitad de sesión

El video de JS Mastery resultó ser un tutorial general de Claude Code, no un workflow. Sebastián
cambió el objetivo: **arreglar el ciclo actual para arrancar el lunes 2026-09-28 con él andando**,
copiando a JS Mastery. La carpeta `jsm-workflow/` que se había creado se borró en la misma sesión.

Hallazgo que definió todo: las 9 skills base instaladas son **byte a byte iguales** al repo
`jsmastery-pro/skills` (commit `43b69e4`, `diff -rq` vacío). El problema nunca fueron las skills:
fue lo que se les puso encima (orden obligatorio, "un chat = una misión", "chat bajo 100k",
"/sync nunca se salta", el hook y el CLAUDE.md global ordenando "ubica el pedido en el ciclo y
di qué skill toca"). JS Mastery dice lo contrario: sin playbook obligatorio, corre solo lo que el
cambio necesita, sugerencias nunca compuertas.

## Lo que se hizo con esto

- `PLAYBOOK.md` reescrito alrededor de esa regla, con tabla de "cuánto workflow según el cambio".
- `~/.claude/CLAUDE.md` reescrito: se quitó el ruteo automático a skills, `/brujula`, `/ciclo`,
  "un chat = una misión", "chat bajo 100k" y "recuérdame /sync".
- Hooks: `ciclo-arranque` ya no ordena ubicar el pedido en el ciclo; `recordar-sync` ya no dice
  "nunca se salta". Siguen avisando, ninguno bloquea.
- `scout` y `researcher` de JS Mastery instalados en `~/.claude/agents/` (cubren el hueco de
  "cero subagentes" del registro 0004).
- `brujula` y `ciclo` archivadas en `~/.claude/skills-archive/`.

## Observaciones viendo el tutorial (se van sumando)

1. **2026-09-27, sobre `/sync` y el archivo de contexto.** Sebastián sentía el `CLAUDE.md`
   abandonado. Matiz: en este setup `CLAUDE.md` es solo un puntero a `AGENTS.md`, así que lo que
   el tutorial llama CLAUDE.md es el AGENTS.md. Las dos fallas reales de `/sync`:
   - Solo agrega líneas, nunca poda. El archivo crece sin límite (47 KB en Proyecto B).
   - No captura aprendizajes puntuales ("esto me sirvió y me va a servir después"). Solo mira
     cambios estructurales. Ese tipo de nota no tiene sitio en el ciclo viejo.

## Pendientes

- Rastrear qué dispara el CI de git "a cada rato" (probablemente en Proyecto B, no aquí).
- Al terminar el tutorial: migrar el estilo a `~/.claude/CLAUDE.md`, hooks y skills, y decidir
  qué del ciclo viejo sobrevive. Candidatos que el registro 0004 muestra que ya le salen solos:
  estado en archivos y evidencia antes de "listo". Sebastián no los quiso fijar hoy.
