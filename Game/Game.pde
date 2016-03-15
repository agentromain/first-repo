//Nécessaires pour mouseDragged
double posY = mouseY;
double posX = mouseX;

float side  = 500;
float boxHeight = 10;

//Nécessaires pour tilt
float rotX = 0;
float rotZ = 0;

//Vitesse à laquelle les rotations s'effectuent autour des axes
int vitesse = 54;

Mover ball;

void settings() {
  size(900, 900, P3D);
}

void setup() {
  noStroke();
  ball = new Mover();
}

void draw() {
  /* 
   Caméra :
   Les 3 premiers arguments indiquent que l'oeil est placé en (0,-50,1200)
   Les 3 suivants indiquent que l'on regarde le point (0,0,0)
   Les 3 derniers indiquent que parmi (x,y,z) = (0,1,0), c'est y l'axe vertical
   
   Attention le repère est non droit
   
   Les axes sont disposés comme suit :
   - X pointe à droite
   - Y pointe en bas
   - Z sort du plan
   */
  camera(0, -50, 1200, 0, 0, 0, 0, 1, 0);
  background(255, 255, 255);
  lights();
  fill(0, 200, 50);
  stroke(0, 0, 0);
  rotateX(rotX);
  rotateZ(rotZ);
  box(side, boxHeight, side);

  
  translate(0, -15, 0);
  ball.display();
  ball.update();
  ball.checkEdges();
}


/*
Méthode qui va pencher la planche selon les axes X et Z.
 Arguments :
 L'angle float à modifier (en pratique rotX ou rotZ)
 Un boolean définissant s'il faut augmenter l'angle (true) ou le diminuer (false)
 Return :
 Un nouvel angle float un peu augmenté ou diminué.
 */
float tilt(float angle, boolean augmenter) {

  float nouvelAngle = angle;  
  if (augmenter) {
    nouvelAngle += PI*vitesse/2000;
    nouvelAngle = Math.min(nouvelAngle, PI/3);
  } else {
    nouvelAngle -= PI*vitesse/2000;
    nouvelAngle = Math.max(nouvelAngle, -PI/3);
  }
  return nouvelAngle;
}


void mouseDragged() {

  //La condition regarde dans quelle direction la souris a le + bougé et effectue une seule rotation : celle qui va dans ce sens.
  //Cela évite de partir en diagonale comme le feraient des appels consécutifs à tilt(X) puis tilt(Z)
  if ( abs((float)(mouseY-posY)) > abs((float)(mouseX-posX))) {
    rotX = tilt(rotX, mouseY < posY);
    posY = mouseY;
  } else {
    rotZ = tilt(rotZ, mouseX > posX);
    posX = mouseX;
  }
}


void mouseWheel(MouseEvent event) {
  vitesse -= event.getCount();
  vitesse = min(vitesse, 100);
  vitesse = max(vitesse, 1);
  println(vitesse);
}