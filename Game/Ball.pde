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
    velocity.add(gravityForce).add(friction);
    location.add(velocity);
    checkCylinderCollisions();
    checkEdges();
    
    normVelocity = sqrt(velocity.x*velocity.x + velocity.y*velocity.y + velocity.z*velocity.z);
  }
  

  void display() {
    pushMatrix();
    noStroke();
    translate(location.x, 0, location.z);
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
    
    //Bord droit
    if (location.x + radius > side/2.0 && velocity.x > 0) {
      velocity.x *= -reboundCoef ;
      location.x = side/2.0 -radius;
      
      lastPoints = points;
      points -= normVelocity;
    
    //Bord gauche
    } else if (location.x - radius< -side/2.0 && velocity.x < 0) {
      velocity.x *= -reboundCoef ;
      location.x = -side/2.0 +radius;
      
      lastPoints = points;
      points -= normVelocity;
    }
    
    //Bord du bas
    if (location.z + radius > side/2.0 && velocity.z > 0) {
      velocity.z *= -reboundCoef ;
      location.z = side/2.0 -radius;
      
      lastPoints = points;
      points -= normVelocity;
    
    //Bord du haut
    } else if (location.z - radius < -side/2.0 && velocity.z < 0) {
      velocity.z *= -reboundCoef ;
      location.z = -side/2.0 +radius;
      
      lastPoints = points;
      points -= normVelocity;
    }
  }
  
  
  /* Méthode qui détecte  gère les rebonds de la balle contre les cylindres
  */
  void checkCylinderCollisions(){
    
    for(PVector cylindre : cylinderPositions){
      PVector cylPos = new PVector(cylindre.x,0,cylindre.y);
      PVector normal = location.copy().sub(cylPos);
      if(normal.mag() <= radius + cylinderRadius && normal.dot(velocity) <= 0){
         normal.normalize();
         location = normal.copy().mult(radius + cylinderRadius).add(cylPos);
         velocity.sub(normal.mult(2*velocity.dot(normal))).mult(reboundCoef);
         
         lastPoints = points;
         points += normVelocity;
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