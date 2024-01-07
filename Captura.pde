int devolverCaptura()
{
  if ( camara.available() ) {
    //leo el nuevo fotograma
    camara.read();

    //ingreso la imagen a la tubería de OpenCV
    opencv.loadImage( camara );

    //int umbral = 245;
    if (modoCalibracion)
    {
      umbral = int( map( mouseX, 0, width, 0, 255 ));
    } else
    {
      umbral = umbralSeleccionado;
    }
    //le aplica un umbral bitonal
    opencv.threshold( umbral );
    resultado = opencv.getOutput();

    //le pido que busque contornos en la imagen
    contornos = opencv.findContours();


    //image( resultado, 640, 0, width/2, height);
    for (Contour esteContorno : contornos) {
      //le pido al Blob que me devuelva el "bounding box"
      elRectangulo = esteContorno.getBoundingBox();
      float xCap = elRectangulo.x + elRectangulo.width/2;
      float yCap = elRectangulo.y + elRectangulo.height/2;
      posicionXBlob = map(xCap, 0, 640, width, 0);
    }
  }

  float linea1 = width/3;
  float linea2 = width - width/3;

  direccion = 0;

  if (posicionXBlob < linea1)
  {
    direccion = -1;
  } else if (posicionXBlob > linea2)
  {
    direccion = 1;
  } else if (posicionXBlob > linea1 && posicionXBlob < linea2)
  {  
    direccion = 0;
  }
  
  return direccion;
}
