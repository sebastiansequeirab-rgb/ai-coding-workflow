/* Motor de quiz de escenarios — componente reutilizable del curso.
   Uso:
     renderQuiz(document.querySelector('#quiz'), escenarios, opcionesGlobales)

   escenario = {
     situacion: "texto del escenario",
     opciones: ["/skill-a", "/skill-b", "/skill-c", "/skill-d"],
     correcta: 2,                       // índice en opciones
     porque: "explicación (del playbook) que se muestra como feedback"
   }

   opcionesGlobales = {
     alTerminar: (resultado) => {}      // opcional; resultado = {aciertos, total, falladas: [escenario]}
   }

   Comportamiento pedagógico deliberado:
   - Feedback inmediato con la explicación SIEMPRE (acierte o falle) → refuerza el porqué.
   - Al terminar, ofrece repasar solo las falladas (práctica de recuperación dirigida).
   - No hay pistas de formato: las opciones se muestran en orden aleatorio por ronda.
*/

function renderQuiz(raiz, escenarios, opcionesGlobales) {
  opcionesGlobales = opcionesGlobales || {};
  var estado = {
    cola: escenarios.slice(),
    indice: 0,
    aciertos: 0,
    falladas: [],
    esRepaso: false
  };

  function barajar(arr) {
    var a = arr.slice();
    for (var i = a.length - 1; i > 0; i--) {
      var j = Math.floor(Math.random() * (i + 1));
      var t = a[i]; a[i] = a[j]; a[j] = t;
    }
    return a;
  }

  function el(tag, clase, texto) {
    var n = document.createElement(tag);
    if (clase) n.className = clase;
    if (texto != null) n.textContent = texto;
    return n;
  }

  function pintarPregunta() {
    raiz.innerHTML = '';
    var esc = estado.cola[estado.indice];

    var prog = el('div', 'quiz-progress',
      (estado.esRepaso ? 'Repaso · ' : '') +
      'Escenario ' + (estado.indice + 1) + ' de ' + estado.cola.length);
    raiz.appendChild(prog);

    var bar = el('div', 'quiz-bar');
    var fill = el('div', 'quiz-bar-fill');
    fill.style.width = (estado.indice / estado.cola.length * 100) + '%';
    bar.appendChild(fill);
    raiz.appendChild(bar);

    raiz.appendChild(el('div', 'quiz-scenario', esc.situacion));

    var cont = el('div', 'quiz-options');
    var indices = barajar(esc.opciones.map(function (_, i) { return i; }));
    var botones = [];

    indices.forEach(function (iOpcion) {
      var b = el('button', 'quiz-option', esc.opciones[iOpcion]);
      b.addEventListener('click', function () { responder(iOpcion, botones, indices, esc); });
      cont.appendChild(b);
      botones.push(b);
    });
    raiz.appendChild(cont);
  }

  function responder(iElegida, botones, indices, esc) {
    var acierto = iElegida === esc.correcta;
    if (acierto) estado.aciertos++;
    else estado.falladas.push(esc);

    botones.forEach(function (b, k) {
      b.disabled = true;
      if (indices[k] === esc.correcta) b.classList.add('correct');
      else if (indices[k] === iElegida) b.classList.add('wrong');
    });

    var fb = el('div', 'quiz-feedback ' + (acierto ? 'ok' : 'bad'));
    var titulo = el('strong', null, acierto
      ? '✓ Correcto: ' + esc.opciones[esc.correcta]
      : '✗ La respuesta era ' + esc.opciones[esc.correcta]);
    fb.appendChild(titulo);
    fb.appendChild(document.createTextNode(esc.porque));
    raiz.appendChild(fb);

    var btn = el('button', 'quiz-next',
      estado.indice + 1 < estado.cola.length ? 'Siguiente →' : 'Ver resultado');
    btn.addEventListener('click', avanzar);
    raiz.appendChild(btn);
    btn.focus();
  }

  function avanzar() {
    estado.indice++;
    if (estado.indice < estado.cola.length) pintarPregunta();
    else pintarResultado();
  }

  function pintarResultado() {
    raiz.innerHTML = '';
    var total = estado.cola.length;
    var res = el('div', 'quiz-result');
    res.appendChild(el('div', 'quiz-progress', estado.esRepaso ? 'Resultado del repaso' : 'Resultado'));
    res.appendChild(el('div', 'quiz-score', estado.aciertos + ' / ' + total));

    var veredicto;
    var ratio = estado.aciertos / total;
    if (ratio === 1) veredicto = 'Impecable. Este mapeo ya es tuyo — el próximo paso es usarlo en un proyecto real sin mirar nada.';
    else if (ratio >= 0.8) veredicto = 'Muy sólido. Repasá las que fallaste ahora mismo: recuperar el error en caliente es lo que lo fija.';
    else if (ratio >= 0.5) veredicto = 'Buen punto de partida. Hacé la ronda de repaso de las falladas antes de cerrar la sesión.';
    else veredicto = 'Normal para una primera vez — el quiz es difícil a propósito. Una pasada por el cheatsheet y ronda de repaso.';
    res.appendChild(el('div', 'quiz-verdict', veredicto));

    if (estado.falladas.length > 0) {
      var btnRepaso = el('button', 'quiz-next', 'Repasar las ' + estado.falladas.length + ' que fallé');
      btnRepaso.addEventListener('click', function () {
        estado = {
          cola: barajar(estado.falladas),
          indice: 0,
          aciertos: 0,
          falladas: [],
          esRepaso: true
        };
        pintarPregunta();
      });
      res.appendChild(btnRepaso);
      res.appendChild(document.createTextNode(' '));
    }

    var btnOtra = el('button', 'quiz-next', 'Repetir todo');
    btnOtra.addEventListener('click', function () {
      estado = { cola: barajar(escenarios), indice: 0, aciertos: 0, falladas: [], esRepaso: false };
      pintarPregunta();
    });
    res.appendChild(btnOtra);

    raiz.appendChild(res);

    if (opcionesGlobales.alTerminar) {
      opcionesGlobales.alTerminar({ aciertos: estado.aciertos, total: total, falladas: estado.falladas });
    }
  }

  pintarPregunta();
}
