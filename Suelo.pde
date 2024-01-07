class Suelo {
  FBox suelo;
  float posY = height;
  float altoSuelo = 50;

  Suelo(FWorld world) {
    suelo = new FBox(width, altoSuelo);
    suelo.setPosition(width/2, posY);
    suelo.setStatic(true);
    suelo.setFill(80, 80, 80);
    suelo.setNoStroke();
    suelo.setName("suelo");
    world.add(suelo);
  }
}
