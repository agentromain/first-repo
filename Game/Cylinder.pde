// Initialisation des 3 composantes du cylindre
PShape openCylinder ;
PShape topCylinder ;
PShape bottomCylinder ;
ArrayList<PVector> cylinderPositions ;


/* Méthode qui crée un cylindre (constructeur) */
void initCylinder(float base, int res) {

  float angle;
  float[] x = new float[res + 1];
  float[] y = new float[res + 1];

  for (int i = 0; i < x.length; i++) {
    angle = (TWO_PI / res) * i;
    x[i] = sin(angle) * base;
    y[i] = cos(angle) * base;
  }
  
  noStroke();
  fill(#D8CC8C);
  openCylinder = createShape();
  topCylinder = createShape();
  bottomCylinder = createShape();

  openCylinder.beginShape(QUAD_STRIP);
  topCylinder.beginShape(TRIANGLE_FAN);
  bottomCylinder.beginShape(TRIANGLE_FAN);

  drawEdges(x, y);

  openCylinder.endShape();
  topCylinder.endShape();
  bottomCylinder.endShape();
}



/* Méthode qui dessine les bords d'un cylindre */
void drawEdges(float x [], float y []) {

  bottomCylinder.vertex(0, 0, 0);
  topCylinder.vertex(0, -cylinderHeight, 0);

  for (int i = 0; i < x.length; i++) {
    openCylinder.vertex(x[i], 0, y[i]);
    openCylinder.vertex(x[i], -cylinderHeight, y[i]);
    bottomCylinder.vertex(x[i], 0, y[i]); //disque du bas
    topCylinder.vertex(x[i], -cylinderHeight, y[i]);//disque du haut
  }
}



/* Méthode qui dessine tous les cylindre de la liste
*/
void drawCylinders() {
  for (PVector pos : cylinderPositions)   
     drawUniqueCylinder(pos.x, pos.y);
}



/* Méthode qui dessine un cylindre à l'emplacement donné par x et y
*/
void drawUniqueCylinder(float x, float y){
    pushMatrix();
    translate(0, (radius+0.5*boxHeight), 0);
    translate(x, 0, y);
    shape(openCylinder);
    shape(topCylinder);
    shape(bottomCylinder);
    popMatrix(); 
}