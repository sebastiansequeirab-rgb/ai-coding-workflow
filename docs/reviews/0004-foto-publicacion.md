# 0004. Foto: publicación del workflow

- **Fecha:** 2026-09-30
- **Contra:** los criterios de "Cómo sabremos que quedó" de la [spec 0005](../specs/0005-publicar-el-workflow.md)

| Criterio | Resultado | Cómo se comprobó |
|---|---|---|
| Cero términos privados en el repo y su historial | Cumple | `scripts/revisar-privacidad.sh --todo` → "limpio". Lista privada de 32 términos, más un barrido aparte de correos, rutas `/Users/`, llaves `sk-`/`ghp_` y dominios enlazados (todos públicos) |
| `--dry-run` no toca nada | Cumple | `HOME` falso vacío: 1 entrada antes y después |
| Instalación en limpio | Cumple | `HOME` falso: `CLAUDE.md`, `settings.json` (válido con `jq`), 3 hooks, 2 agentes, `personal.md`. Con `npx`: 14 skills instaladas |
| Conserva lo que ya tenía la persona | Cumple | `settings.json` previo con `model`, `deny`, `allow` y hook propio: se conservan todos, se suman los del workflow; `CLAUDE.md` propio intacto más una línea de import |
| Reinstalar no duplica | Cumple | Segunda corrida: 4 hooks (1 propio y 3 del workflow), 1 sola línea de import |
| `uninstall.sh` deja todo como estaba | Cumple | `shasum` de `CLAUDE.md` y `settings.json` idénticos al original, también después de instalar dos veces (antes fallaba; se corrigió guardando el respaldo de la primera instalación) |
| Los hooks corren | Cumple | Repo de prueba sin `AGENTS.md`: los tres avisan con el texto esperado |
| En la máquina del mantenedor, después de `--link` | Cumple | `claude -p` desde `~` responde con las reglas de `personal.md` (empresa, dialecto, 8 líneas). `claude -p` en el repo de prueba copia el aviso del hook de arranque. `settings.json` sin cambios (ya tenía todo) |
| Enlaces internos | Cumple | Script sobre todos los `.md` y `.html`: 0 rotos. Se arreglaron 16 que venían rotos desde que las lecciones pasaron a `archivo/` |
