# 0001 — Arranque del entrenamiento del workflow

- **Fecha:** 2026-08-28
- **Estado:** activo

## Contexto

Sebastián quiere dominar el ciclo del [PLAYBOOK](../../PLAYBOOK.md) para ejecutarlo sin mirarlo. Próximo proyecto real: `~/proyecto-e`. Ya completó una misión real (2026-08-27: demo con rama, rebrand y APK), así que no parte de cero: conoce las skills por haberlas usado al menos una vez, pero el mapeo situación→skill todavía no es automático.

## Punto de partida (zona de desarrollo próximo estimada)

- **Ya tiene:** noción de que el ciclo existe, experiencia de una misión guiada, el playbook escrito por él mismo.
- **Le falta:** recuperación automática (sin mirar) de: qué skill ante qué situación, el orden del ciclo, los puntos de entrada por tipo de proyecto, y las reglas de contexto.
- **ZDP actual:** reconocimiento con feedback (quiz de escenarios) → el siguiente escalón es recuperación libre (secuenciar el ciclo de memoria, sin opciones).

## Decisión de esta sesión

Lección 1 = [quiz de 12 escenarios](../archivo/lessons/0001-que-skill-cuando.html) (el ciclo de 10 fases + /debug + /handoff como desvíos). Se dejó `/tdd`, `/prototype` y `/diagnosing-bugs` solo como distractores/menciones — entrenarlos como escenarios propios en una lección posterior para no exceder working memory.

## Resultado del quiz

- **Pendiente de registrar** — preguntarle el puntaje y qué escenarios falló; eso decide el repaso de la sesión 2.

## Insight no obvio a preservar

La heurística que desambigua casi todos los escenarios es: **"¿qué archivo queda escrito después de este paso?"** (scope→docs/scope, architect→docs/specs, audit/sync→AGENTS.md, check→docs/reviews). Usarla como andamiaje en lecciones futuras y luego retirarla.

## Próximos pasos

1. Sesión 2: repaso de recuperación de las falladas + secuenciar el ciclo completo de memoria (sin opciones múltiples).
2. Averiguar si Proyecto E es greenfield o brownfield para priorizar el punto de entrada correcto.
3. Lección de reglas de contexto (continuar / clear / handoff / subagente / compact) antes de arrancar Proyecto E.
