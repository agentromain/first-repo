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
    checkEdges();
  }

  void display() {
    pushMatrix();
    noStroke();
    translate(location.x, 0, -location.z);
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
  
  

  void manageForces() {    
    gravityForce.x = sin(rotZ) * gravityConstant;
    gravityForce.z = sin(rotX) * gravityConstant;
  
    friction = velocity.copy();
    friction.mult(-1);
    friction.normalize();
    friction.mult(frictionMagnitude);
  }
}