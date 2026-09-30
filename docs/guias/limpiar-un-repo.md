# Guía: limpiar un repo del ciclo viejo

Tres chats en el repo a limpiar: foto, plan y ejecución, foto después. Probada el 2026-09-27 en
Proyecto C (arranque de 52,168 a 44,916) y en Proyecto D. Se repite tal cual en cada repo.

## Contra qué se mide

| Qué | Meta "pro" |
|---|---|
| Arranque del chat | piso de Claude Code (~28k) + ~3k del repo |
| `AGENTS.md` raíz | ≤150 líneas, solo convenciones. Nada de estado (deploys, avances, notas de sesión) |
| `AGENTS.md` anidados | solo donde hay reglas propias de esa carpeta, cortos |
| Skills en `.claude/skills` del repo | solo las que el stack usa de verdad (revisar `skillUsage` en `~/.claude.json`) |
| `docs/` | lo vivo. Sin `verify.md` de specs ya Accepted, sin reviews de misiones cerradas |

Política fija: **se borra lo muerto, se queda lo vivo; git guarda la historia.** El CI, husky y
los hooks del repo no se tocan en esta limpieza.

## Chat 1: la foto

```
Quiero una foto del estado de este repo ANTES de acomodarlo al workflow nuevo, para comparar después. No cambies nada. Usa el scout para leer.

Escribe docs/reviews/NNNN-foto-antes-workflow-nuevo.md (siguiente número libre) y pégame el mismo contenido aquí, en este formato exacto, solo números y rutas:

## Foto: <repo>, <fecha>
- Contexto al arrancar este chat: <usage del primer turno, en ~/.claude/projects/>
- AGENTS.md raíz: <bytes> / <líneas>. Anidados: <ruta: bytes / líneas>
- Skills locales en .claude/skills: <nombre: bytes>, y cuáles se han usado según skillUsage en ~/.claude.json
- docs/specs: <n> (Proposed / In Progress / Accepted / Assumed / Superseded) · docs/reviews: <n> · verify.md: <n> · docs/scope: <n> · sueltos en docs/: <n>
- .claude/settings.local.json y hooks locales: <claves o "no existe">
- Sin commitear: <n> · último commit: <hash fecha mensaje>
- CI o gates que corren solos: <lista con dónde, o "ninguno">

Cierra con una línea: qué es lo más pesado de arrancar y por qué. Commit de la foto: directo si no hay hook; si lo hay, rama, PR y merge tú.
```

## Chat 2: plan y ejecución

```
Modo planear y crear. Lee docs/reviews/NNNN-foto-antes-workflow-nuevo.md. Política: se borra lo muerto, se queda lo vivo; git guarda la historia. CI, husky y hooks no se tocan.

Usa el scout y escribe docs/specs/NNNN-limpieza-workflow-viejo.md, una página:
1. AGENTS.md raíz: qué líneas son convenciones vivas (meta 150 líneas) y qué es estado viejo, y a dónde va cada bloque (CHANGELOG, docs/, o fuera).
2. Los anidados: mismo criterio. Cuáles se parten, funden o borran.
3. Skills locales con cero uso: borrar (si son symlinks, revisa la carpeta origen).
4. verify.md, reviews, scopes y docs sueltos: lista de borrar / quedar con razón de tres palabras.
5. Cómo sabremos que quedó: tamaño final de cada AGENTS.md, conteo de skills y docs, y meta de arranque.

Máximo 15 líneas en el chat: el plan va al archivo. No toques nada hasta que apruebe.
```

Se lee el plan, se aprueba (o se corrige), y el mismo chat ejecuta: rama, PR y merge los hace él.
Si se desvía del plan, tiene que decirlo.

## Chat 3: la foto después

```
Mide el contexto al arrancar este chat (usage del primer turno, en ~/.claude/projects/) y compáralo con el número de docs/reviews/NNNN-foto-antes-workflow-nuevo.md. Escribe docs/reviews/NNNN-foto-despues-workflow-nuevo.md con el mismo formato de la foto anterior más una línea de diferencia. Commit (directo, o rama/PR/merge si hay hook). Dime solo: número nuevo, diferencia, y qué sigue pesando más.
```

## Ejemplos reales, 2026-09-27

| Repo | Arranque antes | Después | AGENTS.md raíz | Qué más |
|---|---|---|---|---|
| Proyecto C | 52,168 | 44,916 | 369 → 150 líneas | 11 verify, 7 reviews fuera |
| Proyecto D | 33,759 | 28,702 | 318 → 160 líneas; `supabase/` 521 → 209 | 7 skills locales sin uso, 16 verify fuera |
| Proyecto E (2026-09-28) | 65,994 | 36,171 | `CLAUDE.md` 901 → 10 líneas; `AGENTS.md` 201 → 138 | la regla de BD de producción se importa entera a propósito (~4k) |

### Proyecto C, detalle

| | Antes | Después |
|---|---|---|
| Arranque | 52,168 | 44,916 |
| AGENTS.md raíz | 27 KB / 369 líneas | 10 KB / 150 líneas |
| Anidados (7) | 93 KB | 90 KB (pendiente `(api)`, 32 KB) |
| verify.md | 16 | 5 |
| Reviews | 11 | 4 |

Lo que se aprendió ahí: los anidados casi no bajan en el primer pase porque casi todo es contenido
vivo; el raíz sí, porque acumula estado. Y el "CI que corre a cada rato" era `.github/workflows`
disparado por cada push del ciclo viejo, no algo raro.
