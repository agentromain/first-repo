Ball ball;

void settings() {
  size(windowSize, windowSize,P3D); 
}

void setup() {
  posCyls = new ArrayList() ;
  ball = new Ball();
  initCylinder(cylinderBaseSize , cylinderHeight , cylinderResolution);
  noStroke();
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
  background(255, 255, 255);
  //lumiere
  directionalLight(255, 255, 255, 0, 1, 0);
  ambientLight(102, 102, 102);
  
  
  translate(width/2.0,height/2.0,0);
  pushMatrix();
  //couleur plaque
  if(isShift){
    shift();
  }else{
    game();
  }
  fill(0, 0, 255);
  stroke(0,0,0);
  box(side, boxHeight, side);
  ball.display();
  
  for(PVector pos : posCyls){
    //println("xy " + pos.x + " ," + pos.y);
    drawCylinder(pos.x,pos.y);
  }
  popMatrix();
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

void keyPressed(){
  if(key == CODED){
    if(keyCode == SHIFT){
      isShift = true;
    }
  }
}

void keyReleased(){
  if(key == CODED){
    if(keyCode == SHIFT){
      isShift = false;
    }
  }
}

void mouseWheel(MouseEvent event) {
  speed -= event.getCount();
  speed = min(speed, 100);
  speed = max(speed, 1);
  println(speed);
}