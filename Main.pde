import fisica.*;
import processing.sound.*;
import gab.opencv.*;
import processing.video.*;
import java.awt.Rectangle;

// --------------------------------------------------------------------- variables del mundo y partida
FWorld world;
Fondo fondo;
Partida partida;
String estado = "inicio";
PFont fuente;
Suelo suelo;
String path_fondo_inicio = "data/fondos/img_inicio.png";
String path_fondo_juego = "data/fondos/img_juego4.png";
String path_fondo_vacaciones = "data/fondos/img_playa.png";
int ultimoMultiplo1000 = 0;
int cantidadDeRebotes = 1;
int gravedad = 400;
int cantidadParaVacaciones;
boolean estaColisionandoConPala = false;

// --------------------------------------------------------------------- variables de sonido
SoundFile intro_audio;
SoundFile juego_audio;
SoundFile grito;
SoundFile dinero;
SoundFile a_laburar;
SoundFile miami;

// --------------------------------------------------------------------- decalaracion de variables de personaje
Personaje personaje;
boolean modoTrabajando = false;
float tiempoInicioTrabajo = 0;
int duracionTrabajo = 2000;
boolean isMoving = false;
int direccionMovimiento;
float xAnterior;
float ultimaPosicionPersonaje;


// --------------------------------------------------------------------- decalaracion de variables de pala
ArrayList<Pala> palas = new ArrayList<Pala>();
float ultimaPalaCreada = 0;
float intervaloCreacionPala = 1.3;
float ultimoValorIntervaloCreacionPala;

// --------------------------------------------------------------------- declaracion de variables de plata
Plata plata;
ArrayList<Plata> platas = new ArrayList<Plata>();
float ultimaAparicionPlata = 0;
float intervaloCreacionPlata = 3000;

// --------------------------------------------------------------------- declaracion de variables de vacaciones
float tiempoInicioVacaciones = 0;
int duracionVacaciones = 10000;
boolean modoVacaciones = false;

// --------------------------------------------------------------------- decalaracion de variables de proyecto
ArrayList<Proyecto> proyectos = new ArrayList<Proyecto>();
float ultimoProyectoCreado = 0;
float intervaloCreacionProyecto = intervaloCreacionPala * 3 + 0.3;

// --------------------------------------------------------------------- decalaracion de variables de captura
float xCapturaCamara;
Capture camara;
OpenCV opencv;
Rectangle elRectangulo;
int anchoCaptura, altoCaptura;
ArrayList <Contour> contornos;
float x;
float personajeVelocityX = width/2;
boolean ladoIzquierdo = false;
boolean ladoDerecho = false;
boolean modoCalibracion = true;
int umbral;
int umbralSeleccionado;
PImage resultado;
int direccion;
float posicionXBlob;
float xCap, yCap;
PImage rectCapturaL;
PImage rectCapturaR;



void setup()
{
  size(1000, 720);

  // --------------------------------------------------------------------- inicialización de variables de mundo y partida
  Fisica.init(this);
  world = new FWorld();
  world.setEdges();
  world.setGravity(0, gravedad);
  fondo = new Fondo(world);
  suelo = new Suelo(world);
  personaje = new Personaje(world);
  partida = new Partida();
  fondo.setPathFondo(path_fondo_inicio);
  noStroke();


  // --------------------------------------------------------------------- inicialización de variables de sonido
  intro_audio = new SoundFile(this, "data/sounds/ambiente/olvidalo_y_volverá_por_mas.mp3");
  intro_audio.amp(0.5);
  intro_audio.loop();
  juego_audio = new SoundFile(this, "data/sounds/ambiente/patria_al_hombro.mp3");
  miami = new SoundFile(this, "data/sounds/acciones/miami.mp3");
  dinero = new SoundFile(this, "data/sounds/acciones/plata.mp3");
  a_laburar = new SoundFile(this, "data/sounds/acciones/a_laburar.mp3");
  grito = new SoundFile(this, "data/sounds/acciones/grito.mp3");
  grito.amp(0.3);

  // --------------------------------------------------------------------- inicialización de assets general
  fuente = createFont("Minecraft.ttf", 32);
  textFont(fuente);

  // --------------------------------------------------------------------- inicialización de variables de captura
  String[] listaCamaras = Capture.list();
  printArray(listaCamaras);
  int cualCamara = 0;
  camara = new Capture( this, listaCamaras[ cualCamara ] );
  camara.start();
  anchoCaptura = 640;
  altoCaptura = 480;
  rectCapturaL = loadImage("data/fondos/rectCapturaL.png");
  rectCapturaR = loadImage("data/fondos/rectCapturaR.png");
  opencv = new OpenCV(this, anchoCaptura, altoCaptura);
}

void draw()
{
  personaje.mover(devolverCaptura());
  if (modoTrabajando)
  {
    personaje.updateAnimation("lento");
  } else if (estaColisionandoConPala)
  {
    personaje.updateAnimation("colision");
  } else if (!modoTrabajando && !estaColisionandoConPala)
  {
    personaje.updateAnimation("normal");
  }

  // --------------------------------------------------------------------- estado juego
  if (estado == "juego")
  {

    // --------------------------------------------------------- modo vacaciones
    if (modoVacaciones)
    {
      for (Pala p : palas)
      {
        p.desactivarColisionesConSuelo();
      }

      for (Proyecto pr : proyectos)
      {
        pr.desactivarColisionesConSuelo();
      }
      intervaloCreacionPlata = 1500;
      float tiempoActualVacaciones = millis();
      if (tiempoActualVacaciones - tiempoInicioVacaciones >= duracionVacaciones) {
        modoVacaciones = false;
        fondo.setPathFondo(path_fondo_juego);
      }
    } else
    {
      intervaloCreacionPlata = 3000;
    }

    // --------------------------------------------------------- modo trabajando
    if (modoTrabajando)
    {
      float tiempoActualTrabajando = millis();
      if (tiempoActualTrabajando - tiempoInicioTrabajo >= duracionTrabajo) {
        // El tiempo ha transcurrido, desactiva el modoVacaciones
        modoTrabajando = false;
      }
    }

    if (!modoCalibracion)
    {
      partida.aumentarPuntaje();

      // --------------------------------------------------------- creación de palas
      float tiempoActualPala = millis() / 1000.0;
      if (tiempoActualPala - ultimaPalaCreada >= intervaloCreacionPala && !modoVacaciones) {
        Pala nuevaPala = new Pala(world, personaje.getPosXPersonaje());
        palas.add(nuevaPala);
        ultimaPalaCreada = tiempoActualPala;
      }

      // --------------------------------------------------------- creación de proyectos
      float tiempoActualProyecto = millis() / 1000;
      if (tiempoActualProyecto - ultimoProyectoCreado >= intervaloCreacionProyecto && !modoVacaciones) {
        Proyecto proyecto = new Proyecto(world, personaje.getPosXPersonaje());
        proyectos.add(proyecto);
        ultimoProyectoCreado = tiempoActualProyecto;
      }

      // --------------------------------------------------------- creación de plata
      float tiempoActualPlata = millis();
      if (tiempoActualPlata - ultimaAparicionPlata >= intervaloCreacionPlata) {
        plata = new Plata(world);
        platas.add(plata);
        ultimaAparicionPlata = tiempoActualPlata;
      }
    }
  }

  world.step();
  world.draw();
  partida.dibujarPuntajes();

  push();
  fill(0, 100);
  noStroke();
  if (devolverCaptura() == -1)
  {
    image(rectCapturaL, -25, 0, 50, height);
  } else if (devolverCaptura() == 1)
  {
    image(rectCapturaR, width-25, 0, 50, height);
  }
  pop();


  if (modoCalibracion)
  {
    push();
    image(camara, 0, 0, 640, 480);
    stroke(255, 0, 0);
    fill(0, 255, 0);
    for (Contour esteContorno : contornos) {

      esteContorno.draw();
      if ( elRectangulo.width > 50 ) {
        line( xCap, 0, xCap, 480 );
        line( 0, yCap, 640, yCap );
      }
    }
    fill(255, 0, 0);
    text(umbral, width/2 + 90, 460);
    textSize(12);
    text("Usar mouse X para calibrar umbral", 30, 460);
    pop();
  }


  // --------------------------------------------------------------------- estado inicio
  if (estado == "inicio")
  {
    if (personaje.getPosXPersonaje() >= 927 && !modoCalibracion)
    {
      estado = "juego";
      partida.iniciarNuevaPartida();
      fondo.setPathFondo(path_fondo_juego);
      intro_audio.stop();
      juego_audio.loop();
      partida.puntaje = 0;
    }
  }

  // --------------------------------------------------------------------- estado reinicio
  if (estado == "reinicio")
  {
    partida.mostrarMensajeReinicio();
    if (personaje.getPosXPersonaje() >= 927 && !modoCalibracion)
    {
      estado = "juego";
      juego_audio.loop();
      partida.puntaje = 0;
      partida.iniciarNuevaPartida();
      partida.aumentarPuntaje();
    }
  }
}
