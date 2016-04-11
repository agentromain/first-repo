Ball ball;
boolean isShift = false;

void settings() {
  size(windowSize, windowSize, P3D);
}

void setup() {
  banner = createGraphics(bannerWidth, bannerHeight, P2D);
  topView = createGraphics(topViewEdge, topViewEdge, P2D);
  scoreboard = createGraphics(scoreboardWidth, scoreboardHeight, P2D);
  cylinderPositions = new ArrayList() ;
  ball = new Ball();
  initCylinder(cylinderRadius, cylinderResolution);
  noStroke();
  points = 0;
  lastPoints = 0;
}


//==========================MAIN-DRAW==========================
void draw() {
  
  environmentSetup();
  pushMatrix(); //PUSH 1 (prendre en compte le translate initial pour avoir (0,0,0) au milieu de l'écran

  modeSelection();  
  boxSetup();
  pushMatrix(); //PUSH 2 (prendre en compte le translate pour que les objets soient posés sur la plaque et pas + haut ni + bas)

  ball.display();
  drawCylinders();

  popMatrix(); //POP 1
  popMatrix(); //POP 2
  
  noLights();
  drawAllData();
  image(banner, -windowSize/2, windowSize*3/10);
  image(topView, -windowSize/2 + 10 , windowSize*3/10 + 10 );
  image(scoreboard, -windowSize/2 + topViewEdge + 30, windowSize*3/10 + 5 );
}


//=======================AUXILIAIRY METHODS=======================


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



/* Méthode qui renvoie un boolean qui indique si le cylindre centré en x,y est ENTIEREMENT dans la plaque
*/
boolean isInside(float x ,float y ){
  return x >= -side/2.0 + cylinderRadius && x <= side/2.0 - cylinderRadius   && y >= -side/2.0 + cylinderRadius && y <= side/2.0 - cylinderRadius;
}



/* Méthode qui renvoie true s'il est possible de créer un cylindre en (x,y) sans empiéter sur un cylindre qui existe déjà */
boolean availablePlace(float x, float y, ArrayList<PVector> cylinderPositions) {
  boolean ok = true;
  int i = 0;
  float distance = 0;

  while (ok && i < cylinderPositions.size()) {
    distance = sqrt((x-cylinderPositions.get(i).x)*(x-cylinderPositions.get(i).x) + (y-cylinderPositions.get(i).y)*(y-cylinderPositions.get(i).y)); // sqrt [(x-x0)^2 + (y-y0)^2]
    ok &=  distance >=  2*cylinderRadius;  
    i++;
  }

  return ok;
}



/* Méthode qui gère la sélection du mode SHIFT ou du mode normal
*/
void modeSelection() {

  if (isShift) {
    rotateX(-PI/2.0);
    pushMatrix();
    translate(0, -(radius+0.5*boxHeight), 0);
    if(isInside(mouseX-width/2.0,mouseY-height/2.0)){
      drawUniqueCylinder(mouseX-width/2.0, mouseY-height/2.0);
    }
    popMatrix();
  } else {
    rotateX(rotX);
    rotateZ(rotZ);
    ball.update();
  }
}


//=======================INTERACTIVE METHODS=======================

void mouseDragged() {
  if ( abs((float)(mouseY-posY)) > abs((float)(mouseX-posX))) {
    rotX = tilt(rotX, mouseY < posY);
    posY = mouseY;
  } else {
    rotZ = tilt(rotZ, mouseX > posX);
    posX = mouseX;
  }
}


void keyPressed() {
  if (key == CODED) 
    if (keyCode == SHIFT) 
      isShift = true; 
}


void keyReleased() {
  if (key == CODED) 
    if (keyCode == SHIFT)
      isShift = false;
}


void mouseWheel(MouseEvent event) {
  speed -= event.getCount();
  speed = min(speed, 100);
  speed = max(speed, 1);
}


void mouseClicked() {
  if (isShift) {
    float x = mouseX-width/2.0;
    float y = mouseY-height/2.0;
    
    boolean notOnTheBall = ((ball.location.x - x)*(ball.location.x - x) + (ball.location.z - y)*(ball.location.z - y) >= (radius+cylinderRadius)*(radius+cylinderRadius));

    if (notOnTheBall && isInside(x,y) && availablePlace(x, y, cylinderPositions) ) 
        cylinderPositions.add(new PVector(x, y));  
  }
}



//==========================SETUP METHODS==========================



/* Méthode qui gère les paramètres de base de la plaque*/
void boxSetup() {
  fill(0, 0, 255);
  box(side, boxHeight, side);
  translate(0, -(radius+0.5*boxHeight), 0);
}



/*Méthode qui met en place les éléments de l'environnement
*/
void environmentSetup() {
  background(255, 255, 255);
  directionalLight(255, 255, 255, 0, 1, 0);
  ambientLight(102, 102, 102);
  translate(width/2.0, height/2.0, 0);
}