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
    for(PVector pos : posCyls){
      checkCylinderCollision(pos);
    }
    println(location.z);
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
  
  if(distance.mag() <= radius + cylinderBaseSize && distance.dot(velocity) >=0 ){
    
    
    PVector normal = new PVector(location.x - cylindre.x, -location.z - cylindre.y).normalize();
       
    if (velocity.mag() >= 1){
      velocity.sub(normal.mult(2*velocity.dot(normal))).mult(-reboundCoef);

    }else{
            
      PVector horizontal = new PVector (1,0);
      float cosHorizontal = horizontal.dot(normal); // A.B = |A|*|B|*cos(AOB);
      boolean blocked = false; //Indique si la boule est bloquée (pour la coodonnée x et/ou z) entre un bord et un cylindre

      while(distance.mag() < radius + cylinderBaseSize && blocked){
        
        if (location.x < side - radius){
          location.x = 2*normal.x * cosHorizontal;
          blocked |= true;
        }
        if (location.z < side - radius){
          location.z = -2*normal.y * (1-cosHorizontal*cosHorizontal);
          blocked |= true;
        }
                
        //Mise à jour des variables pour la prochaine itération
        distance.x = cylindre.x -location.x;
        distance.y = cylindre.y - location.z;
        normal.x = location.x - cylindre.x;
        normal.y = location.z - cylindre.y;
        normal = normal.normalize();
      }
    }
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