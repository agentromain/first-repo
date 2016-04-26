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
final float reboundCoef = 0.2;

//Constantes de force
final float normalForce = 1;
final float mu = 0.01;
final float frictionMagnitude = normalForce * mu;

//===============Cylinder===========

final float cylinderRadius = 40*scale;
final float cylinderHeight = 100*scale;
final int cylinderResolution = 40;

//============Images==============

 final int bannerWidth = windowSize;
 final int bannerHeight = windowSize/5; //Hauteur du bandeau
 final int topViewEdge = bannerHeight - 20; //Côté du carré de TopView
 final int scoreboardHeight = bannerHeight - 10;
 final int scoreboardWidth = bannerHeight - 40;
 final int chartHeight = bannerHeight - 40;
 final int chartWidth = bannerWidth - topViewEdge - scoreboardWidth - 50;
  int littleSqSize = 5;

 
 //============Jeu==============
 
 float points = 0;
 float lastPoints = 0;
 int representedValue = 2; //Valeur que représente un carré du scoreChart
 int frequency = 1; //Temps (seconde) avant chaque mise à jour du scoreChart ( ATTENTION 1 <= frequency <= 10)

 

 