Ball ball;

void settings() {
  size(cameraSize, cameraSize,P3D);

}

void setup() {
  ball = new Ball();
}

void draw() {
  /* 
   Caméra :
   Les 3 premiers arguments indiquent que l'oeil est placé en (0,-50,1200)
   Les 3 suivants indiquent que l'on regarde le point (0,0,0)
   Les 3 derniers indiquent que parmi (x,y,z) = (0,1,0), c'est y l'axe vertical
   
   Attention le repère est non droit.   
   Les axes sont disposés comme suit :
   - X pointe à droite
   - Y pointe en bas
   - Z sort du plan
   */
  camera(0, -50, 1200, 0, 0, 0, 0, 1, 0);
  background(255, 255, 255);
    
  fill(100, 100, 100);
  stroke(0, 0, 0);
    
  rotateX(rotX);
  rotateZ(rotZ);
  box(side, boxHeight, side);



  //Affichage et mouvement de la balle
  translate(0, -(radius+0.5*boxHeight), 0);  
  ball.display();
  ball.update();
  
  PVector vel = ball.getVel();
  PVector loc = ball.getLoc();
  
  //On adapte (méthode SET) la valeur de velocityX et/ou de VelocityZ SI la balle atteint l'un des cotés de la plaque
  //(condition présente dans checkEdges)  
  ball.setVelXZ(   ball.checkEdges(loc.x, vel.x),    ball.checkEdges(loc.z, vel.z)  );
  


  
}


/*
Méthode qui va pencher la planche selon les axes X et Z.
 Arguments :
   L'angle float à modifier (en pratique rotX ou rotZ)
   Un boolean définissant s'il faut increase l'angle (true) ou le decrease (false)
 Return :
 Un nouvel angle float un peu augmenté ou diminué.
 */
float tilt(float angle, boolean increase) {

  float newAngle = angle;  
  if (increase) {
    newAngle += PI*speed/2000;
    newAngle = Math.min(newAngle, PI/3);
  } else {
    newAngle -= PI*speed/2000;
    newAngle = Math.max(newAngle, -PI/3);
  }
  return newAngle;
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
  speed -= event.getCount();
  speed = min(speed, 100);
  speed = max(speed, 1);
  println(speed);
}