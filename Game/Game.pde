double posy = mouseY;
double posx = mouseX;
float rotx = 0;
float rotz = 0;
int vitesse = 20;
void settings(){
  size(500,500,P3D);
  
}
void setup(){
  noStroke();
  
}
void draw(){
  background(255,255,255);
  lights();
  stroke(0,0,0);
  translate(300,300,0);
  rotateX(rotx);
  rotateZ(rotz);
  box(200,10,200);
}
void mouseDragged(){
  if(mouseY > posy){
    rotx -= PI/vitesse;
    rotx = Math.max(rotx, -PI/3);
  }else if(mouseY < posy){
    rotx += PI/vitesse;
    rotx = Math.min(rotx, PI/3);
  }
  if(mouseX > posx){
    rotz += PI/vitesse;
    rotz = Math.min(rotz, PI/3);
  }else if(mouseX < posx){
    rotz -= PI/vitesse;
    rotz = Math.max(rotz, -PI/3);
  }
  //println("z = "+rotz);
  //println("x = "+rotx);
  posx = mouseX;
  posy = mouseY;
}
void mouseWheel(MouseEvent event){
  vitesse += -10*event.getCount();
  vitesse = max(20,vitesse);
  println("vit =", vitesse);
}