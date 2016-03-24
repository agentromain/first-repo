class Ball {
  
  private PVector gravityForce = new PVector(0, 0,0);
  private PVector friction;
  private PVector location;
  private PVector velocity;
  private PVector prevV;
  private PVector prevL;
  
  Ball() {
    location = new PVector(0, 0, 0);
    velocity = new PVector(0, 0, 0);
  }


  void update() {
    
    checkEdges();
    for(PVector pos : posCyls){
      checkCylinderCollision(pos);
    }
    location.add(velocity);
    manageForces();
    velocity.add(gravityForce).add(friction);
    
  }

  void display() {
    pushMatrix();
    noStroke();
    translate(location.x, 0, location.z);
    //couleur balle
    fill(180,0,0);
    sphereDetail(60);
    sphere(radius);
    
    popMatrix();
  }
  
  

/*
Méthode qui modifie la vitesse de la balle dans une direction, si la balle a atteint 
le bord dans cette direction.
*/
  void checkEdges() {
    if (location.x + radius > side/2.0 && velocity.x > 0) {
      velocity.x *= -reboundCoef ;
      location.x = side/2.0 -radius;
    } else if (location.x - radius< -side/2.0 && velocity.x < 0) {
      velocity.x *= -reboundCoef ;
      location.x = -side/2.0 +radius;
    }
    if (location.z + radius > side/2.0 && velocity.z > 0) {
      velocity.z *= -reboundCoef ;
      location.z = side/2.0 -radius;
    } else if (location.z - radius < -side/2.0 && velocity.z < 0) {
      velocity.z *= -reboundCoef ;
      location.z = -side/2.0 +radius;
    }
  }
  
  
  void checkCylinderCollision(PVector cylindre){
    PVector distance = new PVector(cylindre.x -location.x, cylindre.y - location.z);
    
    if(distance.mag() <= radius + cylinderBaseSize +5 && distance.dot(velocity) >=0 ){
      println("rebond");
      PVector normal = new PVector(location.x - cylindre.x, -location.z - cylindre.y);
      normal = normal.normalize();//.mult(-1);
      velocity.sub(normal.mult(2*velocity.dot(normal))).mult(-1);
    }
    
  }
  
  float distance(PVector centre){
    float x = location.x - centre.x;
    float y = -location.z - centre.y;
    return sqrt( x*x + y*y);
  }
  
  void manageForces() {    
    gravityForce.x = sin(rotZ) * gravityConstant;
    gravityForce.z = -sin(rotX) * gravityConstant;
  
    friction = velocity.copy();
    friction.mult(-1);
    friction.normalize();
    friction.mult(frictionMagnitude);
  }
}