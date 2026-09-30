# 0002 — Revisión en campo: el workflow aplicado en Proyecto A y Proyecto B

- **Fecha:** 2026-08-31
- **Estado:** activo — insumo directo de la próxima sesión (la guía interactiva)

## Qué se revisó

Tres repos reales donde Sebastián aplicó el ciclo entre el 28 y el 31 de agosto:
`~/proyecto-a` (monorepo pnpm), `~/proyecto-b` (app + web) y `~/proyecto-b-backoffice`.

## Lo que ya domina (evidencia en archivos, no en opinión)

1. **El estado vive en los archivos — internalizado de verdad.** La joya es
   `Proyecto B/docs/scope/pulimiento-visual.md`: checklist viva pantalla por pantalla,
   nacida del mensajito de arranque que armamos aquí, con estado por commit (`✅ 2ebcf5f`),
   gates de verificación (`npm run puertas`, `vista --solo=NN`), regla de paridad web/app
   citando su propio ADR 0003, y hasta un ⛔ de "no desplegar". Retomable desde cualquier chat.
2. **`/sync` como ritual de cierre en Proyecto B:** 4 commits `/sync:` en el log
   (ej. `d5bcfdf`, `eb7f419`). El repo se reconcilia al cerrar misiones.
3. **Modelado de dominio a nivel avanzado:** ~21 ADRs por repo con títulos narrativos
   ("la portada la manda el catálogo"), `CONTEXT.md` gordos (188–318 líneas),
   y el patrón correcto de `CLAUDE.md` fino (1 línea) apuntando a `AGENTS.md` gordo (518 líneas).
4. **Adaptación a monorepo en Proyecto A:** `docs/scope/` particionado por workspace
   (`_root/`, `consumidor/`, `local/`, `sitio/`) y specs con `index/rationale/verify`
   (`docs/specs/_root/0001-design-system-de-proyecto-a/`). Eso es el playbook aplicado con criterio propio.

## Los tres huecos encontrados (material para la guía interactiva)

1. **Proyecto A no tiene `AGENTS.md`.** Su `CLAUDE.md` raíz es configuración de skills
   (issue tracker, triage), no el contexto de repo que `/audit` genera y todas las skills leen.
   El playbook además pide `AGENTS.md` anidado por workspace en monorepos. → Falta `/audit` ahí.
2. **Proyecto A tiene 0 commits de `/sync`** (Proyecto B tiene 4). El ritual de cierre no viajó
   entre proyectos: se aplica donde se aprendió, no todavía como reflejo universal.
3. **Los resultados de verificación no viven en `docs/reviews/`:** en Proyecto B están como
   docs sueltos en `docs/` (`verificacion-completa-ago-2026.md`, `auditoria-las-40-31-08.md`).
   Funciona, pero la convención del ciclo (check → `docs/reviews/`) no se está siguiendo —
   decidir si se adopta la convención o se constituye la variante en el PLAYBOOK.

## Actualización de la zona de desarrollo próximo

Superó hace rato el nivel "reconocer qué skill toca" (lección 0001). Su frontera real hoy:
**consistencia entre proyectos** — que los rituales (audit al llegar, sync al cerrar,
reviews en su lugar) se disparen solos en CUALQUIER repo, no solo donde nacieron.
La guía interactiva debe entrenar misiones completas de punta a punta con esos tres huecos
como trampas deliberadas.

## Próximos pasos

1. Sesión próxima (chat nuevo): construir la **guía interactiva** — ver `../PROXIMA-SESION.md`.
2. En Proyecto A, cuando toque: correr `/audit` (raíz + workspaces) y cerrar la próxima misión con `/sync`.
3. Decisión pendiente de Sebastián: ¿`docs/reviews/` como manda el ciclo, o constituir su variante?
