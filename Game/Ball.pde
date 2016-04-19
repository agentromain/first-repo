class Ball {

  private PVector gravityForce = new PVector(0, 0, 0);
  private PVector friction;
  private PVector location;
  private PVector velocity;

  Ball() {
    location = new PVector(0, 0, 0);
    velocity = new PVector(0, 0, 0);
  }


  void update() {
    manageForces();
    velocity.add(gravityForce).add(friction);
    location.add(velocity);
    checkCylinderCollisions();
    checkEdges();
    if(points < 0){
      points = 0;
    }
  }


  void display() {
    pushMatrix();
    noStroke();
    translate(location.x, 0, location.z);
    fill(180, 0, 0);
    sphereDetail(60);
    sphere(radius);  
    popMatrix();
  }


  /*
  Méthode qui modifie la vitesse de la balle dans une direction, si la balle a atteint 
   le bord dans cette direction. Mets à jour le score en cas de collision.
   */
  void checkEdges() {
    boolean b = false;
    float vel = velocity.mag();
    
    //Bord droit
    if (location.x + radius > side/2.0 && velocity.x > 0) {
      b = true;
      velocity.x *= -reboundCoef ;
      location.x = side/2.0 -radius;
      
      //Bord gauche
    } else if (location.x - radius< -side/2.0 && velocity.x < 0) {
      b = true;
      velocity.x *= -reboundCoef ;
      location.x = -side/2.0 +radius;
    }

    //Bord du bas
    if (location.z + radius > side/2.0 && velocity.z > 0) {
      b = true;
      velocity.z *= -reboundCoef ;
      location.z = side/2.0 -radius;
      
      //Bord du haut
    } else if (location.z - radius < -side/2.0 && velocity.z < 0) {
      b = true;
      velocity.z *= -reboundCoef ;
      location.z = -side/2.0 +radius;
    }
    
    //Update Points
    if (b) {
      lastPoints = -3*vel*gravityConstant;
      if (vel >= 0.5) {
        points += lastPoints;
      } else {
        lastPoints = 0;
      }
    }
  }


  /* Méthode qui détecte  gère les rebonds de la balle contre les cylindres. Mets à jour le score.
   */
  void checkCylinderCollisions() {

    for (PVector cylindre : cylinderPositions) {
      PVector cylPos = new PVector(cylindre.x, 0, cylindre.y);
      PVector normal = location.copy().sub(cylPos);
      
      //Collision
      if (normal.mag() <= radius + cylinderRadius && normal.dot(velocity) <= 0) {
        
        //Update Points
        lastPoints = velocity.mag();
        if (lastPoints >= 0.5) {
          points += 3*lastPoints*(1-gravityConstant);
        } else {
          lastPoints = 0;
        }
        
        //Handle rebound
        normal.normalize();
        location = normal.copy().mult(radius + cylinderRadius).add(cylPos);
        velocity.sub(normal.mult(2*velocity.dot(normal))).mult(reboundCoef);
      }
      
      location.add(velocity);
    }
  }


  /* Méthode qui met à jour les forces s'exerçant sur la boule
   */
  void manageForces() {    
    gravityForce.x = sin(rotZ) * gravityConstant;
    gravityForce.z = -sin(rotX) * gravityConstant; 
    friction = velocity.copy().mult(-1).normalize().mult(frictionMagnitude);
  }
}