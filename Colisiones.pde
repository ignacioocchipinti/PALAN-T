void contactStarted(FContact collision) { //<>//
  FBody cuerpo1 = collision.getBody1();
  FBody cuerpo2 = collision.getBody2();

  if (cuerpo1 != null && cuerpo2 != null) {
    String nombre1 = cuerpo1.getName();
    String nombre2 = cuerpo2.getName();

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////// COLISION PERSONAJE Y PALA
    if (nombre1 != null && nombre2 != null) {
      if ((nombre1.equals("personaje") && nombre2.equals("pala")) ||
        (nombre1.equals("pala") && nombre2.equals("personaje"))) {
        estaColisionandoConPala = true;
        grito.play();
        partida.restarVida();
        for (Pala p : palas) {
          if (p.getPala() == cuerpo1 || p.getPala() == cuerpo2) {
            p.desactivarColisionesConSuelo();
          }
        }
      } else {
        estaColisionandoConPala = false;
      }

      //////////////////////////////////////////////////////////////////////////////////////////////////////////////////// COLISION PERSONAJE Y PROYECTO
      if ((nombre1.equals("personaje") && nombre2.equals("proyecto")) ||
        (nombre1.equals("proyecto") && nombre2.equals("personaje"))) {
        a_laburar.play();
        ultimaPosicionPersonaje = personaje.getPosXPersonaje();
        tiempoInicioTrabajo = millis();
        modoTrabajando = true;
        for (Proyecto pr : proyectos) {
          if (pr.getProyecto() == cuerpo1 || pr.getProyecto() == cuerpo2) {
            pr.desactivarColisionesConSuelo();
          }
        }
      }

      //////////////////////////////////////////////////////////////////////////////////////////////////////////////////// COLISION SUELO Y PALA
      if ((nombre1.equals("pala") && nombre2.equals("suelo")) ||
        (nombre1.equals("suelo") && nombre2.equals("pala"))) {
        for (Pala p : palas) {
          if (p.getPala() == cuerpo1 || p.getPala() == cuerpo2) {
            p.incrementarColisionesSuelo();
            if (p.getColisionesConSuelo() > cantidadDeRebotes) {
              p.desactivarColisionesConSuelo();
            }
          }
        }
      }

      //////////////////////////////////////////////////////////////////////////////////////////////////////////////////// COLISION SUELO Y PROYECTO
      if ((nombre1.equals("proyecto") && nombre2.equals("suelo")) ||
        (nombre1.equals("suelo") && nombre2.equals("proyecto"))) {
        for (Proyecto pr : proyectos) {
          if (pr.getProyecto() == cuerpo1 || pr.getProyecto() == cuerpo2) {
            pr.incrementarColisionesSuelo();
            if (pr.getColisionesConSuelo() > cantidadDeRebotes) {
              pr.desactivarColisionesConSuelo();
            }
          }
        }
      }

      //////////////////////////////////////////////////////////////////////////////////////////////////////////////////// COLISION PERSONAJE Y PLATA
      if ((nombre1.equals("plata") && nombre2.equals("personaje")) ||
        (nombre1.equals("personaje") && nombre2.equals("plata"))) {
        dinero.play();
        for (Plata p : platas) {
          if (p.getPlata() == cuerpo1 || p.getPlata() == cuerpo2) {
            p.desactivar();
            partida.aumentarPlata();
            if (partida.plata == cantidadParaVacaciones)
            {
              modoVacaciones = true;
              fondo.setPathFondo(path_fondo_vacaciones);
              tiempoInicioVacaciones = millis();  // Registra el tiempo de inicio de modoVacaciones
              miami.play();
              partida.sumarVida(2);
              cantidadParaVacaciones += 200000;
              cantidadDeRebotes++;
              intervaloCreacionPala -= 0.3;
              partida.nivel++;
              if (intervaloCreacionPala <= 0.5 && cantidadDeRebotes == 3)
              {
                cantidadDeRebotes = 3;
                intervaloCreacionPala = 0.5;
              }
            }
          }
        }
      }



      if (intervaloCreacionPala <= 0.5 && cantidadDeRebotes == 3 && intervaloCreacionPlata == 1000)
      {
        cantidadDeRebotes = 3;
        intervaloCreacionPala = 0.5;
        intervaloCreacionPlata = 1000;
      }
    }
  }
}
