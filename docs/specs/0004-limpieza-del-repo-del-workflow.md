# 0004 — Limpieza a fondo del repo del workflow

- **Fecha:** 2026-09-27
- **Estado:** Accepted (aprobado por Sebastián el 2026-09-27)
- **Modo:** planear y crear. Commit directo a main (este repo no tiene hook ni CI).

## Qué encontré

1. **PLAYBOOK contra `~/.claude/CLAUDE.md`.** No se contradicen en lo que ambos dicen; el problema
   es que al PLAYBOOK le falta todo lo de la entrevista de perfil (registro 0006): largo de los
   mensajes, "¿te lo explico?", idioma, límites duros, deploy, git en repos de la empresa, bugs, quién
   verifica, memoria. Hoy la fuente de verdad de esas reglas es CLAUDE.md, al revés de lo que dice
   la regla. Contradicción real, una: "Pendientes conocidos" del PLAYBOOK dice que el `AGENTS.md`
   de Proyecto B pesa 47 KB; `docs/repos.md` y `docs/mejoras.md` dicen 150 KB. Esa sección además
   repite `docs/mejoras.md`.
2. **Referencias vivas a lo archivado.** `README.md:35` instala `teach`, `tdd`, `grill-with-docs`,
   `diagnosing-bugs`, `setup-pre-commit` y `git-guardrails-claude-code`. `aprendizaje/AGENTS.md:5`
   dice "workspace de la skill `/teach`". `aprendizaje/RESOURCES.md:14` lista `tdd` y `teach`.
   `aprendizaje/NOTES.md` y `MISSION.md` son archivos de `/teach` ("notas del profesor", "alumno").
   En specs, reviews, ADR, registros y `archivo/`: se quedan, ya llevan su línea histórica.
3. **`AGENTS.md` raíz** (78 líneas, 4.2 KB, bajo la meta de 150): no nombra `docs/repos.md`;
   el comando `open aprendizaje/archivo/lessons/0002...` abre una lección rota (`archivo/README.md`
   dice que sus rutas a `assets/` ya no resuelven); la nota del commit `848d3b7` repite la de
   `aprendizaje/AGENTS.md`; "si una skill no aporta al ciclo". **`aprendizaje/AGENTS.md`** (53
   líneas): `/teach`, una carpeta `lessons/` que no existe, y un gotcha de `PROXIMA-SESION.md`.
4. **Muerto en `aprendizaje/` y `docs/guias/`:**
   - `PROXIMA-SESION.md`: todo lo que dice está cerrado (Proyecto D, entrevista, esta limpieza) o
     repetido en `docs/mejoras.md` y `docs/guias/probar-el-workflow.md`.
   - `NOTES.md`: las preferencias ya están en `~/.claude/CLAUDE.md`, "lo que cambió" está en el
     registro 0005, y el pendiente de Proyecto E ya lo respondió `docs/repos.md`. Lo único vivo
     (micro-lección "qué evidencia pedir según el cambio") pasa a `docs/mejoras.md`, Ideas.
   - `MISSION.md`: su criterio de éxito es la semana de prueba, ya en `docs/mejoras.md`; dice
     "Proyecto D en curso" y ya está cerrado.
   - `docs/guias/entrevista-de-perfil.md`: la agenda de una entrevista ya hecha. El resultado es
     el registro 0006. No es un procedimiento que se repita.
5. **Palabras fuera de `CONTEXT.md`** (solo en archivos vivos): "misión agéntica de horas"
   (PLAYBOOK, y "misión de horas" en `~/.claude/CLAUDE.md`), "Para misiones largas", "El ciclo
   completo, cuando hace falta entero" como título, "no aparecen en el ciclo", "no parte del
   ciclo", "backlog vivo" (`AGENTS.md`, PLAYBOOK) para `docs/mejoras.md`.

## Qué se hace

1. **PLAYBOOK:** sección nueva "Reglas de la entrevista de perfil (2026-09-27)", corta, con lo del
   punto 1 y fuente registro 0006. "Pendientes conocidos" se reemplaza por una línea a
   `docs/mejoras.md`. Las palabras del punto 5 se cambian ("tarea de horas", "chats largos", "El
   flujo completo de JS Mastery", "no uso", "sueltas", "lista de mejoras").
2. **`~/.claude/CLAUDE.md`:** "misión de horas" → "tarea de horas". Commit en `~/.claude`.
3. **`AGENTS.md` raíz:** sumar `docs/repos.md` al mapa; quitar el `open` roto y la nota repetida
   de `848d3b7`; "al ciclo" → "al workflow"; fila de `aprendizaje/` al día.
4. **`aprendizaje/AGENTS.md`:** reescrito corto: qué es la carpeta hoy (registros, recursos,
   motores de `assets/`, `archivo/`), sin `/teach`. Se quedan los gotchas de los motores.
5. **Borrar:** `aprendizaje/PROXIMA-SESION.md`, `NOTES.md`, `MISSION.md`,
   `docs/guias/entrevista-de-perfil.md`.
6. **`README.md`:** comando de instalación con las 5 de Pocock que sí están (`grill-me`,
   `grilling`, `domain-modeling`, `prototype`, `handoff`, comprobado en `~/.claude/skills/`) y
   `docs/repos.md` en el mapa. **`RESOURCES.md`:** lista de Pocock al día.
7. **`docs/mejoras.md`:** la idea de la micro-lección a Ideas; esta limpieza a Hecho.
8. **Foto después** en `docs/reviews/0003-foto-limpieza-del-repo.md` (antes y después).

## Qué no

- Specs, reviews, ADR, registros y `aprendizaje/archivo/`: no se tocan, aunque nombren lo archivado.
- `assets/`, `app/`, `CONTEXT.md`, `docs/repos.md`: están bien.
- El hook `ciclo-arranque.sh` se queda con su nombre (renombrarlo toca `settings.json`): a Después.
- La sección "Arranque liviano" del PLAYBOOK queda igual: es la evidencia de las pasadas.

## Foto de arranque, antes

Medido el 2026-09-27 con una sesión limpia `claude -p "responde solo: ok"` en este repo, campo
`usage` del primer turno: **23,461 tokens**. `AGENTS.md` raíz 4,232 bytes / 78 líneas;
`aprendizaje/AGENTS.md` 3,269 / 53 (solo carga al tocar esa carpeta). Sin commitear: 0.
Último commit: `e37f9d2`. No se espera una baja grande: lo del repo que carga al arrancar es
solo el `AGENTS.md` raíz (~1.2k tokens). La meta aquí es coherencia, no tokens.

## Cómo sabremos que quedó

- `grep` de `teach|tdd|grill-with-docs|diagnosing|brujula` fuera de specs, reviews, ADR,
  registros y `archivo/`: solo en la lista de archivadas del PLAYBOOK.
- Cada ruta citada en `AGENTS.md`, `aprendizaje/AGENTS.md`, `README.md` y PLAYBOOK existe.
- `AGENTS.md` raíz ≤ 78 líneas y nombra `docs/repos.md`.
- El PLAYBOOK tiene las reglas de la entrevista y no repite pendientes.
- Foto después con la misma medición, y la diferencia.
- Commit aquí y en `~/.claude`.

## Después

- Renombrar el hook `ciclo-arranque` (toca `~/.claude/settings.json`).
