PImage img_fondo;

class Fondo {
  FBox fondo;

  Fondo(FWorld world) {
    fondo = new FBox(width, 5);
    fondo.setPosition(width/2, height/2);
    fondo.setStatic(true);
    fondo.setName("fondo");
    fondo.setSensor(true);
    textSize(24);
    world.add(fondo);
  }

  void setPathFondo(String path)
  {
    img_fondo = loadImage(path);
    img_fondo.resize(1000, 720);
    fondo.attachImage(img_fondo);
  }
}
