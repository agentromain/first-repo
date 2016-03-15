class Ball {
  
  private PVector gravityForce = new PVector(0, 0,0);
  private PVector friction;
  private PVector location;
  private PVector velocity;
  
  Ball() {
    location = new PVector(0, 0, 0);
    velocity = new PVector(0, 0, 0);
  }


  void update() {
    manageForces();
    location.add(velocity);
    velocity.add(gravityForce).add(friction);
  }

  void display() {
    lights();
    stroke(150,0,0);
    translate(location.x, 0, -location.z);
    fill(180,180);
    sphere(radius);    
  }
  
  void setVelXZ(float velX, float velZ){
    velocity.x = velX;
    velocity.z = velZ;
  }
  
  PVector getLoc(){
   return location; 
  }
  PVector getVel(){
   return velocity; 
  }
  
  

/*
Méthode qui modifie la vitesse de la balle dans une direction, si la balle a atteint 
le bord dans cette direction.
  Arguments :
    Une coordonnée de la location de la balle (x ou z)
    Une coordonnée de la vitesse de la balle (x ou z)
  Return :
    La coordonnée de la vitesse de la balle multipliée par -coefficientRebond (la balle part 
    dans l'autre sens) dans le cas où celle ci touche le bord dans cette direction.
*/
  float checkEdges(float l, float v) { 
    if (( l >= side/2 && v > 0) || (l <= -side/2 && v < 0)) {
      v *= -reboundCoef;
    }  
    float finalVelocity = v;  
    return finalVelocity;    
  }
  
  

  void manageForces() {    
    gravityForce.x = sin(rotZ) * gravityConstant;
    gravityForce.z = sin(rotX) * gravityConstant;
  
    friction = velocity.copy();
    friction.mult(-1);
    friction.normalize();
    friction.mult(frictionMagnitude);
  }
}