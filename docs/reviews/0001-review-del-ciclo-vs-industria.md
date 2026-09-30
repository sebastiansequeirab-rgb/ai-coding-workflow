# Review 0001 — El ciclo contra el estado del arte (septiembre 2026)

> **Contexto histórico.** Escrito para el ciclo viejo; el veredicto "el orden es correcto" y "un chat = una misión" quedaron atrás el 2026-09-27 (registro `aprendizaje/learning-records/0005`). Los 5 refuerzos siguen valiendo, y "Opus 5" hoy es Opus 5.5.

- **Fecha:** 2026-09-01
- **Objeto revisado:** el ciclo del [PLAYBOOK](../../PLAYBOOK.md), contra fuentes primarias de la industria
- **Veredicto:** el orden es correcto. No hay que cambiarlo. Faltan 5 refuerzos.

## Fuentes usadas

Primarias (documentación oficial y research, no blogs):

- [Best practices for Claude Code](https://code.claude.com/docs/en/best-practices) — Anthropic
- [How Claude Code is used in practice](https://www.anthropic.com/research/claude-code-expertise) — Anthropic Research
- [Prompting Claude Opus 5](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-opus-5) — Anthropic
- [Output styles](https://code.claude.com/docs/en/output-styles) — Anthropic

Secundarias (consenso de industria, con datos):

- [How Coding Agents Fail Their Users](https://arxiv.org/pdf/2605.29442) — análisis de 20.574 sesiones reales
- [SlopCodeBench](https://arxiv.org/pdf/2603.24755) — degradación de agentes en tareas largas
- [AGENTS.md field guide 2026](https://www.iuriio.com/blog/posts/2026/05/agents-md-field-guide-2026) y [spec 2026](https://www.morphllm.com/agents-md-guide)
- [Spec-driven development 2026](https://dev.to/krlz/spec-driven-development-in-2026-what-it-is-the-tooling-and-how-teams-actually-use-it-2fk2)

## Lo que ya tienes alineado con el consenso

| Tu práctica | Qué dice la industria | Fuente |
|---|---|---|
| `/grill-me` antes de todo | Anthropic recomienda literalmente: "haz que Claude te entreviste, escribe la spec, **después abre sesión nueva** para ejecutar". Es tu ciclo, palabra por palabra. | Best practices, "Let Claude interview you" |
| `AGENTS.md` gordo + `CLAUDE.md` fino | AGENTS.md es el estándar de facto: lo lee Claude Code, Codex, Cursor, Copilot, Gemini CLI, Devin. Pasó a la Linux Foundation. 28+ herramientas, 60.000+ repos. Tu patrón es el portable. | AGENTS.md field guide |
| `/check verify` sobre la app real | "Dale a Claude una verificación que pueda correr" y "que muestre evidencia en vez de afirmar que funcionó". Es el antídoto documentado contra la alucinación. | Best practices, "Give Claude a way to verify" |
| `/check review` con modelo fresco | "Un contexto fresco mejora el review porque Claude no está sesgado a favor del código que acaba de escribir." Idéntico a tu razón. | Best practices, "adversarial review step" |
| Un chat = una misión, `/clear` como caso normal | El hallazgo #1 de 2026: el *context rot* se mide a los 20-30 turnos y se acelera pasando de 40. **79% de las fallas vienen de especificación y coordinación, no de capacidad del modelo.** | SlopCodeBench, análisis de 20.574 sesiones |
| Hooks como guardarraíl (montados hoy) | "Usa hooks para acciones que deben pasar siempre, sin excepción. A diferencia de CLAUDE.md, que es un consejo, los hooks son determinísticos." | Best practices, "Set up hooks" |
| El estado vive en los archivos | La spec es el artefacto más apalancado que produce un humano cuando el agente escribe el código. | Spec-driven development 2026 |

Conclusión de esta tabla: tu ciclo no es una interpretación personal. Coincide punto por punto
con lo que Anthropic documenta y con lo que la investigación mide. **El orden se queda como está.**

## Los 5 refuerzos que faltan

### 1. Plan mode nativo, antes de `/develop`

Anthropic pone el *plan mode* (`Shift+Tab`) como el mecanismo central de "explorar antes de
codear". Es gratis, es nativo y es la única barrera que impide físicamente que el agente edite
antes de entender. Tu ciclo lo cubre con skills, pero no lo usa.

**Acción:** para cualquier cambio que toque varios archivos, entrar en plan mode antes de `/develop`.
Si el diff cabe en una oración, sáltalo (la propia doc lo dice: planear tiene costo).

### 2. La spec necesita criterios verificables y un "fuera de alcance"

Es el refuerzo de mayor impacto. Anthropic: *"las specs más útiles son autocontenidas: nombran
los archivos e interfaces involucrados, dicen qué está fuera de alcance, y terminan con un paso
de verificación de punta a punta"*. Los reportes de GitHub y AWS miden **3–10× más éxito al primer
intento** en tareas no triviales cuando la spec tiene criterios en forma comprobable
(notación EARS: `CUANDO [condición] EL SISTEMA DEBE [comportamiento]`).

**Acción:** `/architect` no cierra una spec sin: archivos que toca, qué queda fuera, y criterios
de aceptación redactados como los va a probar `/check verify`.

### 3. La regla de las dos correcciones

Anthropic: *"si corregiste a Claude más de dos veces por lo mismo en una sesión, el contexto está
contaminado con intentos fallidos. `/clear` y arranca de nuevo con un prompt mejor."*
Tu playbook tiene reglas de contexto por fase, pero no este disparador, que es el más frecuente.

**Acción:** agregarlo a las reglas de contexto. Dos correcciones sobre lo mismo = `/clear`.

### 4. Investigación amplia siempre a subagente

*"Como el contexto es tu limitación fundamental, usa subagentes para mantener la investigación
fuera de él."* En tu playbook el subagente aparece como cuarta opción al cerrar una fase.
Debería ser regla activa durante el trabajo, no una salida de emergencia.

**Acción:** toda exploración que vaya a leer muchos archivos ("¿cómo funciona X aquí?") sale a
subagente. El chat principal se reserva para decidir y construir.

### 5. Evidencia, no afirmación

*"Que Claude muestre evidencia en vez de afirmar que funcionó: la salida del test, el comando que
corrió y lo que devolvió, o una captura. Revisar la evidencia es más rápido que volver a verificar
tú mismo."* Y el modo de fallo que lo hace necesario está nombrado en la misma doc:
*"the trust-then-verify gap"* — el agente produce algo que se ve bien y no cubre los bordes.

**Acción:** ningún paso se da por bueno con un "listo". Se da por bueno con evidencia pegada.

## Qué modelo en qué fase

Contexto: trabajas casi siempre con **Opus 5**, y a veces con **Fable 5**.

| | Opus 5 | Fable 5 |
|---|---|---|
| Precio (entrada / salida por millón) | $5 / $25 | $10 / $50 — **el doble** |
| SWE-bench Verified | 96,0 % | 95,0 % |
| Frontier-Bench v0.1 | 43,3 % | 33,7 % |

**Opus 5 gana en las dos pruebas de código y cuesta la mitad.** Para todo tu ciclo —grill, scope,
architect, develop, verify, test, review, document, sync— Opus 5 es la elección correcta, no un
recorte de presupuesto. Fable 5 conviene solo donde Opus 5 se estanca: razonamiento muy duro o
investigación autónoma larga. Pagar el doble por Fable en trabajo de código es pagar más por menos.

Fuentes: [DataCamp](https://www.datacamp.com/blog/claude-opus-5-vs-claude-fable-5),
[Evolink](https://evolink.ai/blog/claude-opus-5-vs-claude-fable-5),
[BenchLM](https://benchlm.ai/compare/claude-fable-vs-claude-opus-5).

### Lo que sí hay que ajustar por usar Opus 5

De la [guía oficial de prompting de Opus 5](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-opus-5):

1. **No pidas doble verificación.** Opus 5 ya se autoverifica. Las instrucciones de "revisa otra vez"
   causan sobre-verificación y queman tokens sin mejorar el resultado. Se revisó: tus skills y el
   PLAYBOOK están limpios de eso.
2. **El `effortLevel` no acorta la respuesta**, solo controla cuánto piensa. Para acortar hay que
   pedirlo explícito (por eso se activó el output style `Concise`).
3. **Opus 5 delega a subagentes con facilidad.** Eso juega a favor del refuerzo 4, pero cuesta:
   delega solo trabajo grande y de verdad paralelo, nunca para verificar su propio trabajo.
4. **Opus 5 tiende a agrandar el alcance** y a agregar pasos que no pediste. Ya está contenido con
   la regla de alcance en tu `CLAUDE.md` global.
5. **No apagues el pensamiento.** Con thinking apagado el modelo a veces escribe llamadas de
   herramienta como texto plano o filtra etiquetas XML internas. Para bajar costo, usa menos
   esfuerzo, no menos pensamiento.

**Nota de honestidad:** circula en blogs que Opus 5 alucina algo más que Opus 4.8, citando el
system card. No pude verificarlo en fuente primaria, así que no lo uso como base de ninguna
recomendación. Lo de "evidencia en vez de afirmación" se sostiene solo con la doc oficial.

## Lo que NO hay que cambiar (y por qué, para que no vuelva la duda)

- **`/audit` en la posición 4 de la lista.** Se ve raro, pero es correcto: en proyecto nuevo el
  audit va después del scaffold (que lea el proyecto real, no uno vacío) y en repo existente va
  primero. Tu tabla de puntos de entrada ya lo resuelve.
- **`/document` antes de `/sync`.** Correcto: `/document` escribe desde el diff real, `/sync`
  reconcilia el repo. En ese orden.
- **Prototipo sin verificación.** Correcto, *siempre que* prototipo signifique código que se bota.
  Si el prototipo va a producción, ya no es prototipo y necesita el ciclo completo.

## Dato de la investigación de Anthropic que te aplica directo

Los usuarios expertos no se distinguen por saber más de programación. Se distinguen por
**cuánto delegan por instrucción** y por **qué le piden verificar al agente**. Las sesiones
expertas encadenan el doble de acciones y producen cinco veces más salida por instrucción.
Y el dato que te toca de cerca: *"el éxito lo determina el conocimiento del dominio, no las
credenciales de programador. Las diez ocupaciones más grandes del estudio caen a menos de siete
puntos de los ingenieros de software en tasa de éxito verificada."*

Traducido: tu formación, que no es de programador, no es una desventaja en esto. La ventaja está
en delegar tareas más grandes y en pedir verificación, que es exactamente lo que entrena tu ciclo.
