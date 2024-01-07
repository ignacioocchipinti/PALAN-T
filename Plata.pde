class Plata {
  FBox plata;
  PImage plata_img;
  int colisionesPersonaje = 0;
  boolean desactivado = false;


  Plata (FWorld world) {

    plata_img = loadImage("data/plata/plata.png");
    plata_img.resize(40, 40);
    plata = new FBox(40, 40);
    plata.attachImage(plata_img);
    plata.setPosition(random(50, 950), 40);
    plata.setNoStroke();
    plata.setName("plata");

    world.add(plata);
  }

  boolean desactivar() {
    
    plata.setName("plata_desactivado");
    desactivado = true;
    world.remove(plata);
    return desactivado;
  }

  FBox getPlata() {
    return plata;
  }
}
