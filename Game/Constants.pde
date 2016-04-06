final float scale = 0.5;

//============GAME==============

//Nécessaires pour mouseDragged
double posY = mouseY;
double posX = mouseX;

//Paramètres de la plaque
final float side  = 500*scale;
final float boxHeight = 10*scale;


//Paramètres Fenêtre
int windowSize = 700;

//Angles de rotation
float rotX = 0;
float rotZ = 0;

//Vitesse à laquelle les rotations de la plaque s'effectuent autour des axes
int speed = 54;


//============BALL==============

//Rayon de la sphère
final float radius = 20*scale;

//Constante de gravité
final float gravityConstant = 0.2;

//Coefficient de rebonds
final float reboundCoef = 0.6;

//Constantes de force
final float normalForce = 1;
final float mu = 0.01;
final float frictionMagnitude = normalForce * mu;

//===============Cylinder===========

final float cylinderRadius = 40*scale;
final float cylinderHeight = 100*scale;
final int cylinderResolution = 40;

//============Images==============

 PGraphics imgData;
 final int imgDataWidth = windowSize;
 final int imgDataHeight = windowSize/5;
 PGraphics imgTopView;
 final int imgTVEdge = imgDataHeight - 20;
 PGraphics scoreboard;
 final int scoreboardHeight = imgDataHeight -10;
 final int scoreboardWidth = imgDataHeight -40;
 PGraphics img4;
 
 //
 