class Partida {
  int vidas;
  int puntaje;
  float tiempoInicio;
  int puntajeFinalPartida;
  int dineroFinal;
  float tiempoActual;
  int puntajeAnterior;
  int plata;
  boolean reducirGravedad = false;
  float tiempoReduccionGravedad = 0;
  float duracionReduccionGravedad = 15.0;
  int nivel = 1;
  PImage imagenPerdiste;

  Partida() {
    vidas = 5;
    puntaje = 0;
    tiempoInicio = millis() / 1000.0;
    imagenPerdiste = loadImage("data/fondos/perdiste.png");
  }

  void iniciarNuevaPartida() {
    vidas = 5;
    puntaje = 0;
    plata = 0;
    tiempoInicio = millis() / 1000.0;
    tiempoActual = millis() / 1000.0;
    intervaloCreacionPala = 1.5;
    cantidadDeRebotes = 1;
    nivel = 1;
    personaje.direccion = 0;
    personaje.resetPosition();
    cantidadParaVacaciones = 150000;
  }

  void aumentarPuntaje() {
    if (estado == "juego") {
      tiempoActual = millis() / 1000.0;
      puntaje = int((tiempoActual - tiempoInicio) * 100);
    }
  }

  void aumentarPlata()
  {
    plata += 10000;
  }

  void dibujarPuntajes() {
    fill(0, 200);
    textSize(24);
    text("Vidas: " + vidas, 100, 60);
    text("Puntaje: " + puntaje, 300, 60);
    text("Nivel: " + nivel, 600, 60);
    text("Plata: $" + plata, 800, 60);
  }

  void sumarVida(int cantidad) {
    if (vidas >= 5)
    {
      vidas = 5;
    } else
    {
      vidas += cantidad;
    }
  }

  void restarVida() {
    vidas--;
    if (vidas <= 0) {
      vidas  = 0;
      finalizarPartida();
    }
  }

  void finalizarPartida() {
    estado = "reinicio";
    puntajeFinalPartida = puntaje; // guarda el ultimo puntaje
    dineroFinal = plata; // guarda la cantidad de plata juntada

    for (Pala p : palas) {    // elmina todas las palas
      world.remove(p.getPala());
    }
    for (Plata pl : platas) {  // elmina todas la plata
      world.remove(pl.getPlata());
    }
    for (Proyecto pr : proyectos) {  // elmina todas los proyectos
      world.remove(pr.getProyecto());
    }
    palas.clear();  // vacia todos los arrays
    platas.clear();
    proyectos.clear();
  }

  int mostrarPuntajeFinalPartida() {
    return puntajeFinalPartida;
  }

  void aumentarNivel()
  {
    nivel++;
  }

  void mostrarMensajeReinicio() {
    estado = "reinicio";
    modoTrabajando = false;
    estaColisionandoConPala = false;
    push();
    noStroke();
    fill(0, 100);
    rect(0, 0, 1280, 720);
    pop();
    fill(255);
    textSize(28);
    image(imagenPerdiste, 0, 0);
    text("Puntaje: " + puntajeFinalPartida, 420, height / 2);
    text("Plata juntada: $" + dineroFinal, 358, height / 2 + 100);
  }
}
