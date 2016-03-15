class Mover {
  final float gravityConstant = 0.1;
  PVector gravityForce = new PVector(0, gravityConstant);
  PVector friction;
  
  PVector location;
  PVector velocity;
  Mover() {
    location = new PVector(0, 0, 0);
    velocity = new PVector(0, 0, 0);
  }

  void update() {
    manageForces();
    location.add(velocity);
    velocity.add(gravityForce).add(friction);
  }

  void display() {
    pushMatrix();
    stroke(0);
    strokeWeight(2);
    fill(127);
    translate(location.x, 0, -location.z);
    
    fill(255,0,0);
    sphere(10);
    popMatrix();
  }

  void checkEdges() {
    if ((location.x >= side/2 && velocity.x > 0) || (location.x <= -side/2 && velocity.x < 0)) {
      velocity.x *= -0.2;
    }
    if ((location.z >= side/2 && velocity.z > 0) || (location.z <= -side/2 && velocity.z < 0)) {
      velocity.z *= -0.2;
    }
  }

  void manageForces() {
    gravityForce.x = sin(rotZ) * gravityConstant;
    gravityForce.z = sin(rotX) * gravityConstant;
    float normalForce = 1;
    float mu = 0.01;
    float frictionMagnitude = normalForce * mu;
    friction = velocity.copy();
    friction.mult(-1);
    friction.normalize();
    friction.mult(frictionMagnitude);
  }
}