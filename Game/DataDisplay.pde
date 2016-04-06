
// The different add-on surfaces for score visualization
 PGraphics banner; // The background banner, the base of all data visualization
 PGraphics topView; // 
 PGraphics scoreboard;
 PGraphics img4;
 
 

//====================MAIN DATA DISPLAY METHOD====================


/* Méthode qui affiches TOUTES les informations complémentaires
*/
void drawAllData() {
  banner.beginDraw();
  banner.background(229, 225, 174);
  drawTopView();
  drawScore();
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
  topView.translate(topViewEdge/2.0,topViewEdge/2.0);
  topView.scale(topViewEdge/side);
  
  //Draw the ball
  topView.fill(#FF1803);
  topView.ellipse((ball.location.x), (ball.location.z), 2*radius, 2*radius);
  
  //Draw the cylinders 
  topView.fill(0xFADD95);  
  for(PVector pos : cylinderPositions){
    topView.ellipse(pos.x, pos.y , 2*cylinderRadius, 2*cylinderRadius);
  }
  
  topView.popMatrix();
  topView.endDraw();
}



/* Méthode qui affiche le cadre contenant le score et la vitesse
*/
void drawScore(){
  scoreboard.beginDraw();
  scoreboard.stroke(255,255,255);
    
  //White rectangle
  scoreboard.strokeWeight(5);
  scoreboard.line(0,0, 0, scoreboardHeight);
  scoreboard.line(0,scoreboardHeight, scoreboardWidth, scoreboardHeight);
  scoreboard.line(scoreboardWidth,scoreboardHeight, scoreboardWidth, 0);
  scoreboard.line(scoreboardWidth,0, 0, 0);
  
  //Text
  scoreboard.textFont(loadFont("Candara-18.vlw"));
  scoreboard.fill(0,0,0);
  scoreboard.text("Score\n coucou",10,50);
  scoreboard.endDraw();
}