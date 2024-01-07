void keyPressed()
{
  if (key == 'c' || key == 'C')
  {
    modoCalibracion = !modoCalibracion;
  }
}

void mousePressed()
{
  if (modoCalibracion)
  {
    umbralSeleccionado = umbral;
    modoCalibracion = !modoCalibracion;
  }
}
