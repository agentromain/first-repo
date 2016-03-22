void initCylinder(float height, float base, int res) {
  float angle;
  float[] x = new float[res + 1];
  float[] y = new float[res + 1];
  //get the x and y position on a circle for all the sides
  for (int i = 0; i < x.length; i++) {
    angle = (TWO_PI / res) * i;
    x[i] = sin(angle) * base;
    y[i] = cos(angle) * base;
  }
  
  openCylinder = new PShape();
  topCylinder = new PShape();
  bottomCylinder = new PShape();
  
  openCylinder = createShape();
  topCylinder = createShape();
  bottomCylinder = createShape();
  openCylinder.beginShape(QUAD_STRIP);
  topCylinder.beginShape(TRIANGLE_FAN);
  bottomCylinder.beginShape(TRIANGLE_FAN);
  //draw the border of the cylinder
  bottomCylinder.vertex(0,0,0);
  topCylinder.vertex(0,-height,0);
  for (int i = 0; i < x.length; i++) {
    openCylinder.vertex(x[i], 0 , y[i]);
    openCylinder.vertex(x[i] , -height,y[i]);
    bottomCylinder.vertex(x[i],0, y[i]);
    topCylinder.vertex(x[i], -height,y[i]);
  }
  openCylinder.endShape();
  topCylinder.endShape();
  bottomCylinder.endShape();
}

void drawCylinder(float x , float z){
  pushMatrix();
  translate(x,0,z);
  translate(0, -(0.5*boxHeight), 0);
  shape(openCylinder);
  shape(topCylinder);
  shape(bottomCylinder);
  popMatrix();
}