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
  for (int i = 0; i < x.length; i++) {
    openCylinder.vertex(x[i], y[i], 0);
    openCylinder.vertex(x[i], y[i], height);
    bottomCylinder.vertex(x[i], y[i], 0);
    topCylinder.vertex(x[i], y[i], height);
  }
  openCylinder.endShape();
  topCylinder.endShape();
  bottomCylinder.endShape();
}

void drawCylinder(){
  shape(openCylinder);
  shape(topCylinder);
  shape(bottomCylinder);
}