class Pala {
  FBox pala;
  PImage pala_img;
  PImage pala_desactivada_img;
  int colisionesConSuelo = 0;
  float posXPersonaje;
  float posXPala;

  Pala(FWorld world, float posPersonaje) {
    // Initialize the pala
    posXPersonaje = posPersonaje;
    posXPala = random(0, 1);
    if (posXPala < 0.25) {
      float random1 = random(posXPersonaje - 80, posXPersonaje + 80);
      posXPala = random1;
    } else {
      posXPala = random(30, 970);
    }
    pala_desactivada_img = loadImage("data/pala/pala_desactivada.png");
    pala_desactivada_img.resize(30, 90);
    pala_img = loadImage("data/pala/pala.png");
    pala_img.resize(30, 90);
    pala = new FBox(10, 60);
    pala.attachImage(pala_img);
    pala.setPosition(posXPala, 40);
    pala.setNoStroke();
    pala.setFill(200, 200, 0);
    pala.setName("pala");
    pala.setRestitution(0.8);
    float anguloRotacion = random(-PI / 4, PI / 4);
    pala.setRotation(anguloRotacion);

    world.add(pala);
  }

  void incrementarColisionesSuelo() {
    colisionesConSuelo++;
  }

  int getColisionesConSuelo() {
    return colisionesConSuelo;
  }

  void desactivarColisionesConSuelo() {
    pala.setSensor(true);
    pala.setName("pala_desactivada");
    pala.attachImage(pala_desactivada_img);
  }



  FBox getPala() {
    return pala;
  }
}
