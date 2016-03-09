//Nécessaires pour mouseDragged
double posY = mouseY;
double posX = mouseX;

//Nécessaires pour tilt
float rotX = 0;
float rotZ = 0;

//Vitesse à laquelle les rotations s'effectuent autour des axes
int vitesse = 50;

void settings(){
  size(700,700,P3D);
}


void setup(){
  noStroke();
}


void draw(){
  /* 
  Caméra :
    Les 3 premiers arguments indiquent que l'oeil est placé en (0,0,500)
    Les 3 suivants indiquent que l'on regarde le point (0,0,0)
    Les 3 derniers indiquent que parmi (x,y,z) = (0,1,0), c'est y l'axe vertical
    
    Attention le repère est non droit
  
    Les axes sont disposés comme suit :
        - X pointe à droite
        - Y pointe en bas
        - Z sort du plan
  */
  camera(0, 0, 700, 0, 0, 0, 0, 1, 0);
  background(255,255,255);
  lights();
  translate(0,0,0);
  stroke(0,0,0);
  rotateX(rotX);
  rotateZ(rotZ);
  box(500,10,500);

}


/*
Méthode qui va pencher la planche selon les axes X et Z.
Arguments :
  L'angle float à modifier (en pratique rotX ou rotZ)
  Un boolean définissant s'il faut augmenter l'angle (true) ou le diminuer (false)
Return :
  Un nouvel angle float un peu augmenté ou diminué.
*/
float tilt(float angle, boolean augmenter){
  
  float nouvelAngle = angle;  
  if (augmenter){
    nouvelAngle += PI*vitesse/2000;
    nouvelAngle = Math.min(nouvelAngle, PI/3);
  }else{
    nouvelAngle -= PI*vitesse/2000;
    nouvelAngle = Math.max(nouvelAngle, -PI/3);
  }
  return nouvelAngle;  
}


void mouseDragged(){
  
  if ( abs((float)(mouseY-posY)) > abs((float)(mouseX-posX))){
    rotX = tilt(rotX, mouseY < posY);
    posY = mouseY;
  }else{
    rotZ = tilt(rotZ, mouseX > posX);
    posX = mouseX;
  }  
}


void mouseWheel(MouseEvent event){
  vitesse += -event.getCount();
  vitesse = min(vitesse, 100);
  vitesse = max(vitesse, 1);
  println(vitesse);
}