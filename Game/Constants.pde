//============GAME==============

//Nécessaires pour mouseDragged
double posY = mouseY;
double posX = mouseX;

//Paramètres de la plaque
final float side  = 500;
final float boxHeight = 10;

//Rayon de la sphère
final float radius = 20;

//Paramètres Caméra
int cameraSize = 900;

//Angles de rotation
float rotX = 0;
float rotZ = 0;

//Vitesse à laquelle les rotations de la plaque s'effectuent autour des axes
int speed = 54;


//============BALL==============


//Constante de gravité
final float gravityConstant = 0.4;

//Coefficient de rebonds
final float reboundCoef = 0.4;

//Constantes de force
final float normalForce = 1;
final float mu = 0.01;
final float frictionMagnitude = normalForce * mu;