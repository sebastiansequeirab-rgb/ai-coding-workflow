# Lo personal (vive solo en tu máquina, en ~/.claude/personal.md)

El instalador copia esta plantilla a `~/.claude/personal.md` si no existe, y nunca la pisa.
El `CLAUDE.md` del workflow la importa al final. Llénala; lo que no apliques, bórralo.

## Idioma

- Háblame en <idioma y registro: ej. "español neutro, tuteo" o "English, casual">.
- En un repo nuevo, docs, commits y textos de la app en <idioma>.

## Sobre mí

<Qué haces, qué tanto sabes de código, cómo prefieres que te expliquen. Una o dos líneas.
Ejemplo: "No soy programador de carrera: explícame en concepto y consecuencia, no con código.">

## Mapa de repos

Qué repos tienen usuarios reales (piden OK para base de datos de producción), cuáles son de
equipo o de cliente (rama y merge se confirman al arrancar) y cuáles tienen protocolo propio.

| Repo | Dueño | Usuarios reales | Regla de git |
|---|---|---|---|
| `~/mi-app` | yo | no | commit y push a main |
