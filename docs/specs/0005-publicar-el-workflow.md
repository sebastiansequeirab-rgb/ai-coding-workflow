# 0005. Publicar el workflow como repo público, instalable y con historia

- **Fecha:** 2026-09-30
- **Estado:** Aprobado y construido (evidencia en `docs/reviews/0004-foto-publicacion.md`)

## Contexto

Sebastián quiere que su workflow sea público: que otra persona lo clone, lo instale en su Claude Code
o lo lea para aprender, y le dé feedback. También quiere que **su propio repo de trabajo sea ese repo
público**, con un historial que se pueda seguir: qué mejoró, qué no sirvió y por qué.

Lo que hay hoy (revisado el 2026-09-30):
- `~/ai-coding-workflow` (51 commits) y `~/.claude` (12 commits) no tienen remote.
- Los dos tienen datos de clientes en archivos **y en el historial**: `docs/repos.md` (bases de
  datos, servidores, clientes), los learning records 0002–0006, las reglas de la empresa y de un repo con usuarios reales,
  y `skills-archive/portal-*` (correos reales e IDs de Supabase). Por eso el historial actual no se
  puede publicar.
- `settings.json` tiene los hooks con rutas absolutas con el usuario de la Mac, que fallan en otra
  máquina. No tiene secretos.
- Las skills de terceros (JS Mastery, Pocock, Firecrawl) se instalan con `npx`. No se copian.

## Enfoque: dos capas

1. **Capa pública (repo nuevo `ai-coding-workflow`, público en GitHub, historial nuevo):** el
   workflow genérico, el instalador, la historia redactada y las guías. Aquí trabaja Sebastián
   desde ahora.
2. **Capa personal (privada):** `~/.claude`, que sigue siendo un repo local sin remote. Guarda
   `personal.md` (sobre mí, reglas de clientes), `repos.md` y la lista de términos
   prohibidos. El `CLAUDE.md` global la importa con `@~/.claude/personal.md`.
3. **Archivo:** el repo actual se mueve a `~/ai-coding-workflow-archivo` y se sube a GitHub como
   **privado**, con su historial completo. Nada se pierde.

## Estructura del repo público

```
README.md            qué es, para quién, instalar en 1 comando, o solo leer; resumen en inglés arriba
PLAYBOOK.md          genérico: los dos modos, reglas, modelos, arranque liviano (sin clientes)
HISTORIA.md          línea de tiempo por versión: qué se probó, qué no sirvió, con qué evidencia
                     (sale de los learning records 0001–0006 y de mejoras "Hecho", redactada)
CONTEXT.md, AGENTS.md, CLAUDE.md
global/              lo que se instala en ~/.claude
  CLAUDE.md          el CLAUDE.md global sin datos personales, con la sección "Sobre ti" como plantilla
  settings.json      la parte del workflow: deny, skillOverrides, hooks con $HOME, Concise, esfuerzo
  hooks/*.sh         los 3 hooks, sin rutas ni nombres propios
  agents/            scout, researcher
install.sh           instala; ver abajo
uninstall.sh         restaura el respaldo
docs/                specs, reviews, adr, guías y mejoras.md, redactados ("cliente A", "repo con usuarios reales")
aprendizaje/         motores de lecciones, recursos y learning records redactados
.github/             plantillas de issue (feedback, "lo probé y…", idea); Discussions activado
scripts/revisar-privacidad.sh   busca en lo que se va a commitear la lista privada de términos
LICENSE              MIT (solo para lo tuyo; las skills de terceros mantienen su licencia)
```

Fuera del público: `docs/repos.md`, el learning record 0006 (el perfil), `app/`, `skills-archive/portal-*`
y la skill `whatsapp` (tiene tu voz y ejemplos de clientes; queda en la lista "después").

## install.sh

- Revisa que existan `claude`, `jq`, `npx` y `git`.
- Respalda `~/.claude/{CLAUDE.md,settings.json,hooks,agents}` en `~/.claude/backups/workflow-FECHA/`.
- Instala las skills de terceros con los comandos `npx` del README actual. Firecrawl va opcional con
  `--con-firecrawl`, porque pide API key. Antes se confirma cuál es el nombre real del repo de JS
  Mastery: el README dice `jsmastery-pro/skills` y el lock `JavaScript-Mastery-Pro/skills`.
- Copia hooks y agents. Mezcla `settings.json` con `jq` sin pisar lo que ya tiene la persona. No
  activa `skipDangerousModePermissionPrompt` ni `ccstatusline`; el README los menciona como opcionales.
- `CLAUDE.md`: si no existe, lo copia. Si existe, no lo pisa: agrega una línea de import al del workflow.
- `--link` (para Sebastián): en vez de copiar, crea enlaces al repo. Así, cambiar el repo cambia su
  configuración, y queda una sola fuente de verdad.
- `--dry-run`: muestra lo que haría sin tocar nada.

## Historial desde ahora

- El commit inicial del repo nuevo se etiqueta `v2026-09-28`, la versión vigente. Las versiones
  viejas se cuentan en `HISTORIA.md`, porque el historial viejo es privado.
- Cada cambio al workflow lleva su commit y su línea en `mejoras.md`: "Hecho" o **"Descartado"**
  (sección nueva, para lo que no sirvió), con su evidencia. Cada versión se publica como
  GitHub Release.
- Se actualizan las rutas de `~/.claude/CLAUDE.md`, `AGENTS.md` y `PLAYBOOK.md` que apuntan a
  `docs/repos.md`, para que apunten a `~/.claude/repos.md`.
- `scripts/revisar-privacidad.sh` corre como pre-commit en el repo público. Así un nombre de
  cliente no se cuela.

## Pasos

1. Mover el repo actual a `~/ai-coding-workflow-archivo` y subirlo a GitHub como privado.
2. Crear el repo nuevo en `~/ai-coding-workflow` y copiar y redactar el contenido (el grueso del trabajo).
3. Crear la capa personal en `~/.claude` (`personal.md`, `repos.md`, lista de términos) y commitear ahí.
4. Escribir `install.sh` y `uninstall.sh`, los hooks con `$HOME` y el pre-commit.
5. Verificar (ver abajo). Crear el repo en GitHub como **privado**, pasar el chequeo de privacidad
   ahí, y recién entonces cambiarlo a **público**. Activar Discussions y crear el Release.
6. Correr `install.sh --link` en tu máquina y comprobar que tu Claude Code sigue igual.

## Cómo sabremos que quedó

- `revisar-privacidad.sh` sobre el repo público y todo su historial: 0 coincidencias. Busca los
  nombres de clientes y personas, rutas con el usuario, nombres de bases de datos, IDs y correos.
- `install.sh --dry-run` y luego `install.sh` con `HOME` falso en el scratchpad:
  - quedan los archivos esperados;
  - `jq` valida `settings.json`;
  - los hooks corren sin error en un repo de prueba.
- Con un `settings.json` previo de mentira, lo que ya tenía la persona se conserva. `uninstall.sh`
  lo deja como estaba.
- En tu máquina, después de `--link`:
  - un `claude -p` en un repo sin AGENTS.md dispara el aviso de arranque;
  - el `CLAUDE.md` global sigue cargando tus reglas personales (vía `personal.md`).
- La URL pública abre con README y Release.

## Qué no se hace

- No se reescribe el historial viejo, no se publican las skills de terceros ni `whatsapp`, y no se
  traduce todo al inglés (solo el resumen del README).

## Después (no entra en este plan)

- La skill `whatsapp` como plantilla anónima.
- El README entero en inglés, si llega feedback de gente que no habla español.
