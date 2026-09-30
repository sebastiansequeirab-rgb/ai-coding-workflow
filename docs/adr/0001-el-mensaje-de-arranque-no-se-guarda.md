# El mensaje de arranque se imprime, no se guarda

> **Contexto histórico.** Decisión tomada para `/ciclo`, archivada el 2026-09-27. El principio (un mensaje de arranque es vehículo, no estado) sigue valiendo.

**Estado:** aceptado · 1 de septiembre de 2026 · decidido al diseñar la skill `/ciclo`

La regla suprema de este workflow es que el estado vive en los archivos, nunca en el chat. Aun así,
`/ciclo` imprime el mensaje de arranque en pantalla y no lo escribe en ningún archivo. Parece una
violación de la regla y no lo es: un mensaje de arranque no es estado, es un vehículo de un solo uso
que carga la misión hasta el chat nuevo y ahí se agota. Lo durable —la misión, la fase, qué quedó
trabado— pertenece al repo destino y llega ahí por `/sync`, no por un archivo de prompts.

## La alternativa que descartamos

Guardar cada mensaje en un archivo, por consistencia con la regla. La evidencia en contra estaba en
casa: `aprendizaje/PROXIMA-SESION.md` es exactamente ese archivo, y el propio
`aprendizaje/AGENTS.md` ya advierte que "se reescribe al cerrar cada sesión. Si quedó viejo, la
sesión siguiente arranca con el brief equivocado". Un archivo de prompts se convierte en un cuarto
lugar donde el estado se pudre, compitiendo con `AGENTS.md`, `docs/scope/` y `docs/specs/`.

## Consecuencia

Si no copias el mensaje, se pierde, y eso está bien: regenerarlo cuesta un comando bash y tres
lecturas. Regenerarlo es además más seguro que recuperarlo, porque el estado del repo pudo cambiar
desde que se imprimió.
