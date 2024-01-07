class Personaje {
  FBox personaje;
  float velocityX;
  float x, y;
  int direccion = 0;
  int vidas = 5;
  int frameIndex = 0;
  int frameChangeInterval;
  PImage[] leftImages = new PImage[6];
  PImage[] rightImages = new PImage[6];
  PImage[] leftImages_pala = new PImage[6];
  PImage[] rightImages_pala = new PImage[6];
  PImage[] leftImages_proyecto = new PImage[6];
  PImage[] rightImages_proyecto = new PImage[6];
  PImage staticImage;
  PImage staticImage_pala;
  PImage staticImage_proyecto;

  Personaje(FWorld world) {
    x = width / 2;
    y = height - 100;

    for (int i = 0; i < 6; i++) {
      leftImages[i] = loadImage("data/personaje/normal/left" + i + ".png");
      rightImages[i] = loadImage("data/personaje/normal/right" + i + ".png");
      leftImages_pala[i] = loadImage("data/personaje/colision_pala/left" + i + ".png");
      rightImages_pala[i] = loadImage("data/personaje/colision_pala/right" + i + ".png");
      leftImages_proyecto[i] = loadImage("data/personaje/colision_proyecto/left" + i + ".png");
      rightImages_proyecto[i] = loadImage("data/personaje/colision_proyecto/right" + i + ".png");
      leftImages_pala[i].resize(68, 177);
      rightImages_pala[i].resize(68, 177);
      leftImages_proyecto[i].resize(68, 177);
      rightImages_proyecto[i].resize(68, 177);
      leftImages[i].resize(68, 177);
      rightImages[i].resize(68, 177);
    }
    staticImage = loadImage("data/personaje/normal/static.png");
    staticImage_pala = loadImage("data/personaje/colision_pala/static.png");
    staticImage_proyecto = loadImage("data/personaje/colision_proyecto/static.png");
    staticImage.resize(68, 177);
    staticImage_pala.resize(68, 177);
    staticImage_proyecto.resize(68, 177);

    if (modoTrabajando)
    {
      frameChangeInterval = 8;
    } else
    {
      frameChangeInterval = 6;
    }

    personaje = new FBox(78, 187);
    personaje.setStatic(false);
    personaje.setPosition(x, y);
    personaje.setNoStroke();
    personaje.setFill(0);
    personaje.setName("personaje");

    world.add(personaje);
  }

  void mover(float dir)
  {
    if (dir == 0)
    {
      velocityX = 0;
      direccion = 0;
    } else if (dir == -1)
    {
      direccion = -1;
      if (!modoTrabajando)
      {
        velocityX = -400;
      } else
      {
        velocityX = -100;
      }
    } else if (dir == 1)
    {
      direccion = 1;
      if (!modoTrabajando)
      {
        velocityX = 400;
      } else
      {
        velocityX = 100;
      }
    }

    personaje.setVelocity(velocityX, 0);
  }


  void updateAnimation(String estadoAnimacion) {
    if (estadoAnimacion == "lento")
    {
      if (direccion == 0) {
        personaje.attachImage(staticImage_proyecto);
      } else {
        if (frameCount % frameChangeInterval == 0) {
          frameIndex = (frameIndex + 1) % 6;
        }
        // Dibuja la imagen del personaje
        if (direccion == -1) {
          personaje.attachImage(leftImages_proyecto[frameIndex]);
        } else if (direccion == 1) {
          personaje.attachImage(rightImages_proyecto[frameIndex]);
        }
      }
    } else if (estadoAnimacion == "normal")
    {
      if (direccion == 0) {
        personaje.attachImage(staticImage);
      } else {
        if (frameCount % frameChangeInterval == 0) {
          frameIndex = (frameIndex + 1) % 6;
        }
        // Dibuja la imagen del personaje
        if (direccion == -1) {
          personaje.attachImage(leftImages[frameIndex]);
        } else if (direccion == 1) {
          personaje.attachImage(rightImages[frameIndex]);
        }
      }
    } else if (estadoAnimacion == "colision")
    {
      if (direccion == 0) {
        personaje.attachImage(staticImage_pala);
      } else {
        if (frameCount % frameChangeInterval == 0) {
          frameIndex = (frameIndex + 1) % 6;
        }
        // Dibuja la imagen del personaje
        if (direccion == -1) {
          personaje.attachImage(leftImages_pala[frameIndex]);
        } else if (direccion == 1) {
          personaje.attachImage(rightImages_pala[frameIndex]);
        }
      }
    }
  }

  void resetPosition()
  {
    x = width/2;
    personaje.setPosition(x, y);
  }


  void setPosX(float xCaptura)
  {
    x = xCaptura;
    personaje.setPosition(x, y);
  }

  float getPosXPersonaje() {
    float posXPersonaje = personaje.getX();

    return posXPersonaje;
  }
}
