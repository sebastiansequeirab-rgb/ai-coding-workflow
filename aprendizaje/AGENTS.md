# aprendizaje

## Overview

Lo que Sebastián va aprendiendo sobre su workflow: los registros de cada sesión que cambió algo,
las fuentes de confianza y los motores para lecciones interactivas. Desde el 2026-09-27 la meta no
es memorizar un ciclo sino usar los dos modos del `PLAYBOOK.md` y afinarlos con evidencia
(`../docs/mejoras.md`). Lo que falta por hacer vive ahí, no aquí.

## Key files

| Archivo | Guarda |
|---|---|
| `learning-records/NNNN-*.md` | Qué se decidió y qué se aprendió en cada sesión. Numerados, no se borran |
| `RESOURCES.md` | Fuentes de confianza, con nivel de confianza anotado |
| `assets/` | Los motores (quiz, simulador, css) para lecciones nuevas |
| `archivo/` | Lecciones y referencias del ciclo viejo, archivadas el 2026-09-27. No se usan |

Si hace falta una lección nueva, va en `lessons/NNNN-*.html` (la carpeta no existe todavía; la
siguiente es 0003, porque 0001 y 0002 están en `archivo/`).

## Conventions

- **Reusar antes de crear.** Antes de escribir una lección, leer `assets/`. Si algo se va a
  necesitar dos veces, va a `assets/` como componente, nunca copiado dentro de una lección.
- **Toda lección enlaza `assets/style.css`.**
- La numeración de `lessons/` y de `learning-records/` avanza sola, van desacopladas y nunca se
  reusa un número.
- Las lecciones son cortas y dejan una victoria concreta. Sebastián se satura leyendo de más.

## Gotchas

- **Un veredicto agregado miente cuando mide dos habilidades distintas.** Le pasó al simulador:
  daba consejo por puntaje total y le dijo "te faltan los rituales" a alguien que sacó las tres
  trampas limpias. Si un puntaje suma cosas distintas, el mensaje final tiene que mirar las partes.
- Los motores de `assets/` se prueban sin navegador, con un DOM falso en node (ver commit
  `848d3b7`). Conviene correr las dos corridas extremas, la perfecta y la que falla todo, porque
  el puntaje y el mensaje final solo se rompen en los bordes.
- En los quiz y simuladores, las opciones se barajan y se escriben con largo parecido a propósito:
  cualquier diferencia de formato es una pista que arruina la práctica.

## Related specs

- [learning-records/0005](learning-records/0005-entrevista-por-que-el-ciclo-viejo-frena.md): la entrevista que cambió el workflow. Material de partida de cualquier lección nueva.
- learning-records/0006: la entrevista de perfil. Privado (tiene datos personales y de clientes), no está en este repo.

_Drafted by /audit from the repo, worth a quick human pass. Edit freely: once a line stops matching this draft, later runs treat it as curated and will flag rather than overwrite it._
