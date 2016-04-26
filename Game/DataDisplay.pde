
// The different add-on surfaces for score visualization
PGraphics banner; // The background banner, the base of all data visualization
PGraphics topView; // The mini-map visualization
PGraphics scoreboard; // The score visualization
PGraphics barChart; // The chart visualization
int [] squareNeeded = new int[bufferSize];
boolean playerBegan = false;





//====================MAIN DATA DISPLAY METHOD====================


/* Méthode qui affiches TOUTES les informations complémentaires
 */
void drawAllData() {

  banner.beginDraw();

  drawTopView();
  drawScore();
  drawChart();
  drawScrollBar();
  banner.background(229, 225, 174);


  banner.endDraw();
}

//====================AUXILIAIRY METHODs====================



/* Méthode qui dessine la topView du jeu 
 */
void drawTopView() {
  topView.beginDraw();
  topView.background(#3965D1);
  topView.pushMatrix();

  //Adapt the axis system
  topView.translate(topViewEdge/2.0, topViewEdge/2.0);
  topView.scale(topViewEdge/side);

  //Draw the ball
  topView.fill(#FF1803);
  topView.ellipse((ball.location.x), (ball.location.z), 2*radius, 2*radius);

  //Draw the cylinders 
  topView.fill(0xFADD95);  
  for (PVector pos : cylinderPositions) {
    topView.ellipse(pos.x, pos.y, 2*cylinderRadius, 2*cylinderRadius);
  }

  topView.popMatrix();
  topView.endDraw();
}



/* Méthode qui affiche le cadre contenant le score et la vitesse
 */
void drawScore() {
  scoreboard.beginDraw();
  scoreboard.background(229, 225, 174);
  scoreboard.stroke(255, 255, 255);

  //White rectangle
  scoreboard.strokeWeight(5);
  scoreboard.line(0, 0, 0, scoreboardHeight);
  scoreboard.line(0, scoreboardHeight, scoreboardWidth, scoreboardHeight);
  scoreboard.line(scoreboardWidth, scoreboardHeight, scoreboardWidth, 0);
  scoreboard.line(scoreboardWidth, 0, 0, 0);

  //Text
  scoreboard.textFont(loadFont("Candara-18.vlw"), 13);
  scoreboard.fill(0, 0, 0);
  scoreboard.text("Total Score :\n" + points, 10, 20);
  scoreboard.text("Velocity :\n" + ball.velocity.mag(), 10, 60);
  scoreboard.text("Last Score :\n" + lastPoints, 10, 100);
  scoreboard.endDraw();
}

/* Méthode qui affiche la surface d'affichage des points en fonction du temps
 */
void drawChart() {
  barChart.beginDraw();
  barChart.background(240, 235, 200);

  if (playerBegan) {

    //Pour toutes les tranches de 5 secondes déjà écoulées
    for (int i = currentIndex; i < currentIndex + bufferSize; ++i) {

      //Pour chaque carré nécessaire à la représentation du score de ces 5 secondes
      for (int j = 0; j < squareNeeded[i % bufferSize]; ++j) {

        //On affiche le carré décalé de (littleSqSize * i) en x et de (chartHeight - j*littleSqSize) en y

        int sqSize = max ((int) (2 * littleSqSize * hs.getPos()), 1) ;
        barChart.stroke(255);
        barChart.fill(#3965D1);
        barChart.rect(sqSize*(i%bufferSize + loopNumber*bufferSize), chartHeight-j*sqSize, sqSize, sqSize);
      }
    }
  }
  barChart.endDraw();
}


void drawScrollBar() {
  background(255);
  hs.update();
  hs.display();
}