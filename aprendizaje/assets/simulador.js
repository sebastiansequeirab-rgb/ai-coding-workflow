/* Motor de simulación de misión — componente reutilizable del curso.
   Hermano de quiz.js: donde el quiz entrena RECONOCIMIENTO (situación → skill),
   el simulador entrena EJECUCIÓN ENCADENADA (una misión de punta a punta, con
   estado del repo que se acumula escena a escena).

   Uso:
     renderSimulador(document.querySelector('#sim'), mision, opciones)

   mision = {
     repoInicial: {
       archivos: ["README.md", "apps/api/"],   // strings, se muestran como árbol
       chat: 1,                                 // número de chat abierto
       tokens: 6,                               // miles de tokens del chat
       fase: "Llegada"
     },
     escenas: [{
       titulo: "Día 1: el repo ajeno",
       situacion: "texto de la situación",
       opciones: [{ texto: "/audit — ...", consecuencia: "qué pasa si eliges esto" }],
       correcta: 0,                             // índice en opciones
       porque: "explicación del playbook al acertar",
       doble: true,                             // trampa deliberada: vale doble
       efecto: {                                // se aplica al acertar
         agrega: ["AGENTS.md"], quita: ["CLAUDE.md viejo"],
         tokens: 40, fase: "Contexto", chatNuevo: false
       }
     }]
   }

   opciones = { alTerminar: (resultado) => {} }   // {puntos, puntosMax, limpias, total, trampas}

   Comportamiento pedagógico deliberado:
   - Elegir mal NO avanza: muestra la consecuencia real (el modo de fallo que se
     activa) y te deja volver a intentar. La misión se termina sí o sí = victoria tangible.
   - El puntaje mide cuántas escenas resolviste A LA PRIMERA. Las trampas valen doble.
   - Las opciones se barajan; ninguna pista de formato ni de longitud.
*/

function renderSimulador(raiz, mision, opciones) {
  opciones = opciones || {};

  var st = {
    i: 0,
    orden: null,
    erradas: [],
    limpia: true,
    limpias: 0,
    puntos: 0,
    trampas: [],
    repo: {
      archivos: mision.repoInicial.archivos.slice(),
      chat: mision.repoInicial.chat,
      tokens: mision.repoInicial.tokens,
      fase: mision.repoInicial.fase
    },
    nuevos: []
  };

  var puntosMax = mision.escenas.reduce(function (a, e) { return a + (e.doble ? 2 : 1); }, 0);

  function el(tag, clase, texto) {
    var n = document.createElement(tag);
    if (clase) n.className = clase;
    if (texto != null) n.textContent = texto;
    return n;
  }

  function barajar(arr) {
    var a = arr.slice();
    for (var i = a.length - 1; i > 0; i--) {
      var j = Math.floor(Math.random() * (i + 1));
      var t = a[i]; a[i] = a[j]; a[j] = t;
    }
    return a;
  }

  /* ---------- HUD: el estado del repo, siempre a la vista ---------- */

  function pintarHud() {
    var hud = el('aside', 'sim-hud');

    var head = el('div', 'sim-hud-head');
    head.appendChild(el('span', 'sim-hud-title', 'Estado del repo'));
    head.appendChild(el('span', 'sim-chip', st.repo.fase));
    hud.appendChild(head);

    var lista = el('ul', 'sim-files');
    st.repo.archivos.forEach(function (f) {
      var li = el('li', 'sim-file' + (st.nuevos.indexOf(f) >= 0 ? ' nuevo' : ''), f);
      lista.appendChild(li);
    });
    hud.appendChild(lista);

    var meta = el('div', 'sim-meta');
    meta.appendChild(el('span', null, 'Chat #' + st.repo.chat));
    meta.appendChild(el('span', null, st.repo.tokens + 'k / ~100k tokens'));
    hud.appendChild(meta);

    var med = el('div', 'sim-meter' + (st.repo.tokens >= 80 ? ' alto' : ''));
    var fill = el('div', 'sim-meter-fill');
    fill.style.width = Math.min(100, st.repo.tokens) + '%';
    med.appendChild(fill);
    hud.appendChild(med);

    return hud;
  }

  function aplicarEfecto(ef) {
    if (!ef) return;
    if (ef.quita) {
      ef.quita.forEach(function (f) {
        var k = st.repo.archivos.indexOf(f);
        if (k >= 0) st.repo.archivos.splice(k, 1);
      });
    }
    st.nuevos = ef.agrega ? ef.agrega.slice() : [];
    if (ef.agrega) {
      ef.agrega.forEach(function (f) {
        if (st.repo.archivos.indexOf(f) < 0) st.repo.archivos.push(f);
      });
    }
    if (ef.chatNuevo) st.repo.chat++;
    if (typeof ef.tokens === 'number') st.repo.tokens = ef.tokens;
    if (ef.fase) st.repo.fase = ef.fase;
  }

  /* ---------- Escena ---------- */

  function pintar() {
    raiz.innerHTML = '';
    var esc = mision.escenas[st.i];
    if (!st.orden) st.orden = barajar(esc.opciones.map(function (_, i) { return i; }));

    raiz.appendChild(pintarHud());

    var cuerpo = el('div', 'sim-body');

    cuerpo.appendChild(el('div', 'quiz-progress',
      'Paso ' + (st.i + 1) + ' de ' + mision.escenas.length + (esc.doble ? ' · vale doble' : '')));

    var bar = el('div', 'quiz-bar');
    var fill = el('div', 'quiz-bar-fill');
    fill.style.width = (st.i / mision.escenas.length * 100) + '%';
    bar.appendChild(fill);
    cuerpo.appendChild(bar);

    cuerpo.appendChild(el('h3', 'sim-title', esc.titulo));
    cuerpo.appendChild(el('div', 'quiz-scenario', esc.situacion));

    var cont = el('div', 'quiz-options');
    var botones = [];
    st.orden.forEach(function (iOp) {
      var b = el('button', 'quiz-option', esc.opciones[iOp].texto);
      if (st.erradas.indexOf(iOp) >= 0) {
        b.disabled = true;
        b.classList.add('wrong');
      } else {
        b.addEventListener('click', function () { responder(iOp, botones, esc); });
      }
      cont.appendChild(b);
      botones.push(b);
    });
    cuerpo.appendChild(cont);
    raiz.appendChild(cuerpo);
    return cuerpo;
  }

  function responder(iOp, botones, esc) {
    var cuerpo = raiz.querySelector('.sim-body');
    botones.forEach(function (b) { b.disabled = true; });

    if (iOp === esc.correcta) {
      botones[st.orden.indexOf(iOp)].classList.add('correct');
      if (st.limpia) {
        st.limpias++;
        st.puntos += esc.doble ? 2 : 1;
      }
      if (esc.doble) st.trampas.push({ titulo: esc.titulo, limpia: st.limpia });

      var fb = el('div', 'quiz-feedback ok');
      fb.appendChild(el('strong', null, '✓ ' + esc.opciones[esc.correcta].texto));
      fb.appendChild(document.createTextNode(esc.porque));
      cuerpo.appendChild(fb);

      aplicarEfecto(esc.efecto);

      var btn = el('button', 'quiz-next',
        st.i + 1 < mision.escenas.length ? 'Seguir la misión →' : 'Cerrar la misión');
      btn.addEventListener('click', function () {
        st.i++;
        st.orden = null;
        st.erradas = [];
        st.limpia = true;
        if (st.i < mision.escenas.length) pintar();
        else pintarFinal();
      });
      cuerpo.appendChild(btn);
      btn.focus();
      return;
    }

    /* Falló: consecuencia + reintento. La misión no avanza hasta hacerlo bien. */
    st.limpia = false;
    st.erradas.push(iOp);
    botones[st.orden.indexOf(iOp)].classList.add('wrong');

    var fbm = el('div', 'quiz-feedback bad');
    fbm.appendChild(el('strong', null, '✗ ' + esc.opciones[iOp].texto));
    fbm.appendChild(document.createTextNode(esc.opciones[iOp].consecuencia));
    cuerpo.appendChild(fbm);

    var reintentar = el('button', 'quiz-next', 'Volver a decidir');
    reintentar.addEventListener('click', pintar);
    cuerpo.appendChild(reintentar);
    reintentar.focus();
  }

  /* ---------- Cierre de misión ---------- */

  function pintarFinal() {
    raiz.innerHTML = '';
    raiz.appendChild(pintarHud());

    var cuerpo = el('div', 'sim-body');
    var res = el('div', 'quiz-result');
    res.appendChild(el('div', 'quiz-progress', 'Misión cerrada'));
    res.appendChild(el('div', 'quiz-score', st.puntos + ' / ' + puntosMax));
    res.appendChild(el('div', 'quiz-verdict',
      st.limpias + ' de ' + mision.escenas.length + ' pasos resueltos a la primera.'));

    /* El veredicto mira DOS cosas, no solo el puntaje: si fallaste las trampas
       (rituales de borde) o si fallaste el medio del ciclo. Son huecos distintos
       y el consejo tiene que ser distinto. */
    var ratio = st.puntos / puntosMax;
    var trampasOk = st.trampas.filter(function (x) { return x.limpia; }).length;
    var todasLasTrampas = st.trampas.length > 0 && trampasOk === st.trampas.length;
    var veredicto;
    if (ratio === 1) {
      veredicto = 'Misión impecable: ni una trampa, ni un desvío. El ciclo ya te sale solo. Lo que queda es hacerlo en un repo real sin abrir nada.';
    } else if (todasLasTrampas) {
      veredicto = 'Las ' + trampasOk + ' trampas limpias: los rituales de apertura y cierre ya los tienes. ' +
        'Lo que se te escapó está en el medio del ciclo. Fíjate cuáles pasos te costaron: ahí está el hueco, no en los bordes.';
    } else if (ratio >= 0.8) {
      veredicto = 'Misión sólida. Mira cuál trampa te comió: ese es el ritual que todavía no viaja solo entre proyectos.';
    } else if (ratio >= 0.55) {
      veredicto = 'Misión completada, con tropiezos. El orden lo tienes; falta afinar. Repítela mañana, no hoy: el espacio entre intentos es lo que fija.';
    } else {
      veredicto = 'Completaste la misión, que era el objetivo. El puntaje bajo dice dónde mirar: lee el debrief y repite en 48 horas.';
    }
    res.appendChild(el('div', 'quiz-verdict', veredicto));

    if (st.trampas.length) {
      var t = el('div', 'sim-trampas');
      t.appendChild(el('div', 'quiz-progress', 'Las trampas'));
      var ul = el('ul', 'sim-files');
      st.trampas.forEach(function (tr) {
        ul.appendChild(el('li', 'sim-file ' + (tr.limpia ? 'ok' : 'fail'),
          (tr.limpia ? '✓ ' : '✗ ') + tr.titulo));
      });
      t.appendChild(ul);
      res.appendChild(t);
    }

    res.appendChild(el('p', 'sim-reporte',
      'Dile esto al agente: "misión ' + st.puntos + '/' + puntosMax +
      ', trampas ' + trampasOk + '/' + st.trampas.length +
      '" y cuáles pasos fallaste. Lo registra en tu learning record.'));

    var otra = el('button', 'quiz-next', 'Correr la misión de nuevo');
    otra.addEventListener('click', function () {
      st = {
        i: 0, orden: null, erradas: [], limpia: true, limpias: 0, puntos: 0, trampas: [],
        repo: {
          archivos: mision.repoInicial.archivos.slice(),
          chat: mision.repoInicial.chat,
          tokens: mision.repoInicial.tokens,
          fase: mision.repoInicial.fase
        },
        nuevos: []
      };
      pintar();
    });
    res.appendChild(otra);

    cuerpo.appendChild(res);
    raiz.appendChild(cuerpo);

    if (opciones.alTerminar) {
      opciones.alTerminar({
        puntos: st.puntos, puntosMax: puntosMax,
        limpias: st.limpias, total: mision.escenas.length,
        trampas: st.trampas
      });
    }
  }

  pintar();
}
