# 0003 — Simulador de misión completa (lección 0002)

- **Fecha:** 2026-09-01
- **Estado:** activo — corrida 1 registrada (9/15, trampas 3/3)

## Contexto

La [revisión en campo](0002-revision-en-campo-proyectos-a-y-b.md) movió la zona de desarrollo próximo:
Sebastián ya no está en "reconocer qué skill toca" (lección 0001) sino en **consistencia entre
proyectos** — que los rituales se disparen solos en cualquier repo, no solo donde nacieron.

## Decisión de diseño de esta sesión

Lección 0002 = [simulador de misión completa](../archivo/lessons/0002-mision-completa.html): un brownfield
ficticio (`~/stock-planta`, monorepo pnpm en producción, feature de alertas de stock mínimo) y
12 decisiones encadenadas de la llegada al cierre.

Tres cambios deliberados respecto de la lección 0001:

1. **De reconocimiento a ejecución encadenada.** Las opciones ya no son solo skills: varias son
   pares *skill + archivo que queda escrito* (`/scope → docs/scope/…` vs `/architect → docs/specs/…`).
   La heurística "¿qué archivo queda escrito?" pasa de andamiaje explicado a criterio exigido.
2. **Fallar no avanza.** Elegir mal muestra la consecuencia concreta (qué modo de fallo se activa)
   y devuelve a la misma decisión. La misión siempre se termina → la victoria es tangible por
   diseño, y el puntaje mide solo cuántos pasos salieron a la primera.
3. **Estado del repo visible.** Un HUD persistente muestra los archivos que se van escribiendo,
   el número de chat y los tokens acumulados. Hacer visible "el estado vive en los archivos" es
   la mitad de la lección; además la escena de frontera de fase (84k tokens, todo escrito → `/clear`)
   solo se contesta bien mirando el panel.

### Las tres trampas (valen doble, 15 puntos posibles sobre 12 escenas)

| # | Escena | Hueco del registro 0002 |
|---|---|---|
| 1 | "Día 1 — el repo ajeno": hay `CLAUDE.md` de configuración, no hay `AGENTS.md` | Proyecto A sin `/audit` |
| 10 | "El informe": dónde vive el resultado de `/check verify` | informes sueltos en `docs/` en Proyecto B |
| 12 | "El cierre": PR mergeado, viernes 19:40 | Proyecto A con 0 commits `/sync:` |

La escena 2 (monorepo → `AGENTS.md` anidado por workspace) refuerza la trampa 1 con el caso concreto
de Proyecto A, y las escenas 6 (frontera de fase) y 11 (orden `test → review → document`) cubren las dos
partes del ciclo que menos había practicado.

## Componentes nuevos en el workspace

- `assets/simulador.js` — motor de misión ramificada reutilizable (hermano de `quiz.js`):
  estado de repo acumulativo, consecuencias por opción incorrecta, reintento, trampas de doble valor.
  Verificado headless en las dos corridas extremas (0/15 y 15/15).
- Estilos del simulador agregados a `assets/style.css` (reusa todo lo del quiz; solo el HUD es nuevo).
- `reference/checklist-de-mision.html` — la referencia imprimible: apertura, ciclo con archivo por
  fase, fronteras de contexto, cierre. Pensada para el monitor, no para la pantalla.

## Insight no obvio a preservar

Los tres huecos reales no son de conocimiento: son **rituales de borde**. Están en la puerta de
entrada y en la de salida de la misión, justo donde el impulso de "ya está, arranquemos" y el de
"listo, terminé" los empujan afuera. Por eso viajan mal entre proyectos: en Proyecto B se hacen, en
Proyecto A no. La consecuencia pedagógica es que no se arreglan explicándolos otra vez, sino
practicando aperturas y cierres — que es exactamente lo que el simulador repite.

## Resultado — primera corrida (2026-09-01)

**9 / 15 puntos · trampas 3 / 3 limpias.**

Lectura del puntaje: las 3 trampas dobles valen 6 puntos, así que de las 9 escenas simples
solo 3 salieron a la primera. **Seis pasos del medio del ciclo fallaron.**

### Esto da vuelta el diagnóstico del registro 0002

El registro anterior decía que el hueco eran los rituales de borde (audit al llegar, sync al
cerrar, informes en `docs/reviews/`). En la simulación **los tres salieron limpios**: los
reconoció apenas los vio. La hipótesis nueva es que esos huecos no son de conocimiento sino de
disparo: sabe que hay que hacerlos, no los ejecuta bajo presión de un proyecto real. Eso se
arregla en campo (Proyecto A), no con más lecciones.

El hueco real que destapó la simulación está **en el medio del ciclo**: las escenas simples.
Candidatas fuertes (a confirmar con él, no reportó cuáles falló):

- Escena 3: `/grill-with-docs` vs `/grill-me` en repo ya documentado.
- Escena 5: decisión técnica → `/architect`, no dejársela al agente en `/develop`.
- Escena 6: frontera de fase con todo escrito → `/clear` (no `/handoff`).
- Escena 7: `/tdd` **dentro** de `/develop`, solo para lógica delicada.
- Escena 11: orden `test → check review → document`.

Confirmado en el chat: **no sabía qué era TDD**. Eso vuelve casi segura la falla de la escena 7
y refuerza que el hueco es de contenido del ciclo, no de rituales.

### Corrección al simulador que esto obligó

El veredicto final solo miraba el puntaje, así que le dijo *"lo que falta son los rituales de
apertura y cierre"* justo a alguien que sacó las 3 trampas limpias. Se corrigió `assets/simulador.js`:
ahora el veredicto distingue el caso "trampas limpias + medio flojo" y manda a mirar el medio.
Lección de diseño: **un veredicto agregado miente cuando hay dos habilidades distintas medidas
en el mismo puntaje.**

## Próximos pasos

1. **Preguntarle cuáles pasos falló.** Sin ese dato el diagnóstico del medio del ciclo es
   conjetura. Es lo primero de la próxima sesión.
2. **Repetir el simulador en 48 h** (2026-09-03), no el mismo día: la segunda corrida sobre las
   mismas trampas es la que mide retención, no fluidez.
3. Aplicación real que cierra el círculo: correr `/audit` en Proyecto A (raíz + workspaces) y cerrar
   la próxima misión ahí con `/sync`. Eso convierte la lección en evidencia.
4. Decisión pendiente suya: adoptar `docs/reviews/` o constituir la variante en el PLAYBOOK.
