class Proyecto {
  FBox proyecto;
  PImage proyecto_img;
  PImage proyecto_desactivada_img;
  int colisionesConSuelo = 0;
  float posXPersonaje;
  float posXproyecto;

  Proyecto(FWorld world, float posPersonaje) {
    // Initialize the proyecto
    posXPersonaje = posPersonaje;
    posXproyecto = random(0, 1);
    if (posXproyecto < 0.25) {
      float random1 = random(posXPersonaje - 40, posXPersonaje + 40);
      posXproyecto = random1;
    } else {
      posXproyecto = random(60, 940);
    }
    proyecto_desactivada_img = loadImage("data/proyecto/proyecto_desactivado.png");
    proyecto_desactivada_img.resize(60, 40);
    proyecto_img = loadImage("data/proyecto/proyecto.png");
    proyecto_img.resize(60, 40);
    proyecto = new FBox(60, 40);
    proyecto.attachImage(proyecto_img);
    proyecto.setPosition(posXproyecto, 40);
    proyecto.setNoStroke();
    proyecto.setFill(200, 200, 0);
    proyecto.setName("proyecto");
    proyecto.setRestitution(0.8);
    float anguloRotacion = random(-PI / 4, PI / 4);
    proyecto.setRotation(anguloRotacion);

    world.add(proyecto);
  }

  void incrementarColisionesSuelo() {
    colisionesConSuelo++;
  }

  int getColisionesConSuelo() {
    return colisionesConSuelo;
  }

  void desactivarColisionesConSuelo() {
    proyecto.setSensor(true);
    proyecto.setName("proyecto_desactivada");
    proyecto.attachImage(proyecto_desactivada_img);
  }


  FBox getProyecto() {
    return proyecto;
  }
}
