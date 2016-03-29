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
    checkEdges();
    checkCylinderCollisions();
    location.add(velocity);
    manageForces();
    velocity.add(gravityForce).add(friction);   
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
    
    //Bord gauche
    } else if (location.x - radius< -side/2.0 && velocity.x < 0) {
      velocity.x *= -reboundCoef ;
      location.x = -side/2.0 +radius;
    }
    
    //Bord du bas
    if (location.z + radius > side/2.0 && velocity.z > 0) {
      velocity.z *= -reboundCoef ;
      location.z = side/2.0 -radius;
    
    //Bord du haut
    } else if (location.z - radius < -side/2.0 && velocity.z < 0) {
      velocity.z *= -reboundCoef ;
      location.z = -side/2.0 +radius;
    }
  }
  
  
  /* Méthode qui détecte  gère les rebonds de la balle contre les cylindres
  */
  void checkCylinderCollisions(){
    
    for(PVector cylindre : cylinderPositions){
      
      PVector distance = new PVector(cylindre.x -location.x, cylindre.y - location.z);
      if(distance.mag() <= radius + cylinderRadius && distance.dot(velocity) >=0){       
        PVector normal = new PVector(location.x - cylindre.x, -location.z - cylindre.y).normalize();  
        
        if (velocity.mag() >= 0.5){
          velocity.sub(normal.mult(2*velocity.dot(normal))).mult(-reboundCoef);
        }
       else{
           PVector tangent = new PVector (-normal.y, normal.x);
           velocity.x = tangent.x;
           velocity.z = tangent.y;
        }
      }
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