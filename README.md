# ai-coding-workflow

Mi workflow para programar con Claude Code, tal como lo uso todos los días: las reglas, un
instalador y la historia de cómo llegó a ser así (lo que sirvió y lo que no, con evidencia).

> **In English:** my day-to-day workflow for Claude Code, in Spanish. Two working modes ("quick
> fix" and "plan and build") on top of the [JS Mastery skills](https://github.com/jsmastery-pro/skills),
> a lean startup context (60k → 28k tokens), and hooks that only warn. `./install.sh` merges it into
> your `~/.claude` without overwriting anything, and `./uninstall.sh` restores it. Feedback in
> English is welcome in Issues.

## La idea en 30 segundos

- **El estado vive en los archivos del repo, nunca en el chat.** Si algo se decidió, hay un archivo que lo dice.
- **Dos modos.** *Tiro al piso* (bug, ajuste, texto): directo, evidencia y commit. *Planear y crear*
  (feature): diálogo, un plan de una página en `docs/specs/`, construir.
- **Las skills son sugerencias, no compuertas.** Se corre solo lo que el cambio necesita.
- **Arranque liviano.** Cada chat empieza con la mitad de tokens, porque se apaga lo que no uso.
- **El agente propone, yo decido.** Decisiones técnicas en lenguaje llano, siempre con recomendación.

Todo el detalle está en [PLAYBOOK.md](PLAYBOOK.md), y cómo se llegó aquí en [HISTORIA.md](HISTORIA.md).

## Instalar

Requiere [Claude Code](https://code.claude.com), `jq`, `git`, `curl` y Node.js (por `npx`).

```bash
git clone https://github.com/sebastiansequeirab-rgb/ai-coding-workflow ~/ai-coding-workflow
cd ~/ai-coding-workflow
./install.sh --dry-run   # muestra qué haría, sin tocar nada
./install.sh
```

Después, llena `~/.claude/personal.md`: tu idioma, quién eres y cuáles de tus repos tienen usuarios
reales. Es tuyo y el instalador nunca lo pisa.

| Qué | Dónde queda | Qué hace |
|---|---|---|
| `global/CLAUDE.md` | `~/.claude/CLAUDE.md` | Las reglas: cómo hablar, los dos modos, límites, git, modelos. Si ya tienes uno, no se pisa: se importa desde el tuyo |
| `global/settings.json` | se mezcla con tu `~/.claude/settings.json` | Opus 5.5 en `medium`, output style Concise, conectores y herramientas que no uso apagados, los hooks. Lo que ya tenías gana |
| `global/hooks/` | `~/.claude/hooks/` | Tres avisos (nunca bloquean): repo sin `AGENTS.md`, archivos sin commitear, recordar `/sync` |
| Subagentes `scout` y `researcher` | `~/.claude/agents/` | Bajados de JS Mastery: leen el repo o la web y devuelven un resumen corto |
| Skills | `~/.claude/skills/` | Las 9 de [JS Mastery](https://github.com/jsmastery-pro/skills) y 5 de [Matt Pocock](https://github.com/mattpocock/skills), desde su fuente. `--con-firecrawl` suma [Firecrawl](https://github.com/firecrawl/cli) (pide API key) |

Antes de tocar nada, respalda en `~/.claude/backups/`. Para deshacer: `./uninstall.sh`. Deja todo
como estaba, salvo las skills; esas se quitan con `npx skills remove -g <nombre>`.

**Dos cosas que conviene saber:** las reglas están escritas en primera persona y en español, como
si tú le hablaras a Claude, así que cámbialas a tu gusto. Y el `CLAUDE.md` apunta a
`~/ai-coding-workflow/PLAYBOOK.md`, por eso conviene clonar en esa ruta.

## Solo quiero aprender

Sin instalar nada, en este orden:

1. [PLAYBOOK.md](PLAYBOOK.md): el workflow y el porqué de cada regla.
2. [HISTORIA.md](HISTORIA.md): de un ciclo de 10 fases que frenaba a dos modos. Incluye lo que no sirvió.
3. [PLAYBOOK, "Arranque liviano"](PLAYBOOK.md#arranque-liviano-2026-09-27): cómo bajar a la mitad
   los tokens con que arranca cada chat, medido paso a paso.
4. [docs/guias/](docs/guias/): cómo limpiar un repo con un `AGENTS.md` gordo, y cómo probar el workflow.
5. [aprendizaje/](aprendizaje/): registros de cada sesión y lecciones interactivas. Se abren en el
   navegador, sin instalar nada.

## Feedback

Me sirve cualquier cosa: "lo probé y esto estorbó", "esta regla no la entiendo", "yo lo hago así".
Abre un [issue](https://github.com/sebastiansequeirab-rgb/ai-coding-workflow/issues/new/choose) o escribe en [Discussions](https://github.com/sebastiansequeirab-rgb/ai-coding-workflow/discussions). Cada semana
reviso lo que llega en [docs/mejoras.md](docs/mejoras.md), y lo que cambia queda en el historial.

## Créditos y licencia

Construido sobre [JS Mastery Skills](https://github.com/jsmastery-pro/skills) y
[Matt Pocock Skills](https://github.com/mattpocock/skills), las dos con licencia MIT. Se instalan
desde su fuente y no se copian aquí. Lo de este repo: [MIT](LICENSE).
