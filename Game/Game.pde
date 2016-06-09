Ball ball;
boolean isShift = false;

int loopNumber = 0;
int bufferSize = 500; //The number of scores that are displayed at the same time
double [] scoreUntilNow = new double[bufferSize];

int previousSecond = 0;
int currentIndex = 0; //Used to remember scores in scoreUntilNow,  and the associated amount of "little square" in squareNeeded
HScrollbar hs;
PFont police;
ImageProcessing imgproc;

void settings() {
  size(windowSize, windowSize, P3D);
}

void setup() {
  imgproc = new ImageProcessing();
  String []args = {"Image processing window"};
  PApplet.runSketch(args, imgproc);

  police = loadFont("Candara-18.vlw");
  banner = createGraphics(bannerWidth, bannerHeight, P2D);
  topView = createGraphics(topViewEdge, topViewEdge, P2D);
  scoreboard = createGraphics(scoreboardWidth, scoreboardHeight, P2D);
  barChart = createGraphics(chartWidth, chartHeight, P2D);

  cylinderPositions = new ArrayList() ;
  ball = new Ball();
  initCylinder(cylinderRadius, cylinderResolution);
  noStroke();
  points = 0;
  lastPoints = 0;
  hs = new HScrollbar( -windowSize/2 + topViewEdge + scoreboardWidth + 40, windowSize*3/10 + 13 + chartHeight, chartWidth, bannerHeight - chartHeight - 20);
}


//==========================MAIN-DRAW==========================
void draw() {

  environmentSetup();
  pushMatrix(); //PUSH 1 (prendre en compte le translate initial pour avoir (0,0,0) au milieu de l'écran
  PVector rot = imgproc.getRotation();
  rotX = rot.x;
  rotZ = rot.y;
  rotX = Math.min(rotX, (float) Math.PI/3);
  rotX = Math.max(rotX, (float) -Math.PI/3);
  rotZ = Math.min(rotZ, (float) Math.PI/3);
  rotZ = Math.max(rotZ, (float) -Math.PI/3);
  modeSelection();  
  boxSetup();
  pushMatrix(); //PUSH 2 (prendre en compte le translate pour que les objets soient posés sur la plaque et pas + haut ni + bas)

  ball.display();
  drawCylinders();

  popMatrix(); //POP 1
  popMatrix(); //POP 2

  operations_for_scoreChart();

  noLights();

  image(banner, -windowSize/2, windowSize*3/10);
  image(topView, -windowSize/2 + 10, windowSize*3/10 + 10 );
  image(scoreboard, -windowSize/2 + topViewEdge + 30, windowSize*3/10 + 5 );
  image(barChart, -windowSize/2 + topViewEdge + scoreboardWidth + 40, windowSize*3/10 + 5);
  drawAllData();
}


//=======================AUXILIAIRY METHODS=======================

/*
Méthode qui effectue les operations suivantes :
 -A chaque passage on met à jour le score dans scoreUntilNow à l'index currentIndex
 -Toutes les 5 secondes, on stocke (dans squareNeeded) le nombre de carrés nécessaires à la représentation du score des 5 dernières secondes.
 Ensuite on augmente l'index pour analyse les 5 secondes d'après.
 */
void operations_for_scoreChart() {

  if (second()% frequency == 0 && second() != previousSecond) {

    //Calculate how many squares are needed to represent the score
    int sqNumber = (int)(points) / representedValue;
    squareNeeded[currentIndex] = sqNumber; //register this number in the array

    previousSecond = second();
    loopNumber += (currentIndex+1 >= bufferSize ? 1 : 0);
    currentIndex = (currentIndex + 1)  % bufferSize;
  }

  playerBegan |= (points != 0);
  currentIndex = (playerBegan ? currentIndex : 0);

  scoreUntilNow[currentIndex] = points;
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



/* Méthode qui renvoie un boolean qui indique si le cylindre centré en x,y est ENTIEREMENT dans la plaque
 */
boolean isInside(float x, float y ) {
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
    if (isInside(mouseX-width/2.0, mouseY-height/2.0)) {
      drawUniqueCylinder(mouseX-width/2.0, mouseY-height/2.0);
    }
    popMatrix();
  } else {
    PVector rot = imgproc.getRotation();
    rotateX(rot.x);
    rotateZ(-rot.z);
    ball.update();
  }
}


//=======================INTERACTIVE METHODS=======================

void mouseDragged() {
  if (mouseY  < windowSize/2 + windowSize*0.3 && !hs.locked) {

    if ( abs((float)(mouseY-posY)) > abs((float)(mouseX-posX))) {
      rotX = tilt(rotX, mouseY < posY);
      posY = mouseY;
    } else {
      rotZ = tilt(rotZ, mouseX > posX);
      posX = mouseX;
    }
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

    if (notOnTheBall && isInside(x, y) && availablePlace(x, y, cylinderPositions) ) 
      cylinderPositions.add(new PVector(x, y));
  }
}



//==========================SETUP METHODS==========================



/* Méthode qui gère les paramètres de base de la plaque*/
void boxSetup() {
  fill(#3158B9);
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