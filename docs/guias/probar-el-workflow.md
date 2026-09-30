# Guía: probar el workflow en una semana real

No se verifica leyendo. Se verifica trabajando y anotando lo que estorba.

## Lunes 28 de septiembre: tres chats de prueba, tareas reales chicas

Uno por modo, en el repo donde toque trabajar ese día:

1. **Tiro al piso**: un ajuste visual o un texto. Pedirlo sin decir el modo, a ver si lo adivina.
2. **Planear y crear**: una feature chica. Debe salir un plan de una página en `docs/specs/` antes
   de tocar código, y debe construir en el mismo chat.
3. **Un bug**: describirlo y nada más. Debe ir a `/debug` o directo, sin scope ni spec.

En cada uno, mirar los cuatro criterios de `docs/mejoras.md` ("Por observar esta semana"). Lo que
falle, se anota con el mensaje de "Cómo se alimenta".

## Durante la semana

Cada chat donde algo moleste o salga muy bien: el mismo mensaje de "Cómo se alimenta", al final.
Una línea, sin drama.

## Viernes 2 de octubre: chat de ajuste

Aquí, en `ai-coding-workflow`:

```
Lee docs/mejoras.md, sección Observado. Propón qué cambiar en el PLAYBOOK y en ~/.claude/CLAUDE.md, una cosa a la vez con tu recomendación, y aplica lo que apruebe. Lo aplicado pasa a Hecho con su evidencia. Commit en los dos repos.
```

Si la sección Observado está vacía después de una semana de trabajo real, el workflow está bien y
no se toca. No se mejora por mejorar.
