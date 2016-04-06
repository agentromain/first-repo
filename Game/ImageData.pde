void drawData() {
  imgData.beginDraw();

  imgData.background(229, 225, 174);
  drawTV();
  drawScore();
  imgData.endDraw();
}

void drawTV() {
  imgTopView.beginDraw();
  imgTopView.background(#3965D1);
  imgTopView.pushMatrix();
  imgTopView.translate(imgTVEdge/2.0,imgTVEdge/2.0);
  imgTopView.scale(imgTVEdge/side);
  imgTopView.fill(#FF1803);
  imgTopView.ellipse((ball.location.x), (ball.location.z), 2*radius, 2*radius);
  imgTopView.fill(#FADD95);
  
  for(PVector pos : cylinderPositions){
    imgTopView.ellipse(pos.x, pos.y , 2*cylinderRadius, 2*cylinderRadius);
  }
  imgTopView.popMatrix();
  imgTopView.endDraw();
}

void drawScore(){
  scoreboard.beginDraw();
  scoreboard.stroke(255,255,255);
  scoreboard.strokeWeight(5);
  scoreboard.line(0,0, 0, scoreboardHeight);
  scoreboard.line(0,scoreboardHeight, scoreboardWidth, scoreboardHeight);
  scoreboard.line(scoreboardWidth,scoreboardHeight, scoreboardWidth, 0);
  scoreboard.line(scoreboardWidth,0, 0, 0);
  scoreboard.textFont(loadFont("Candara-18.vlw"));
  scoreboard.fill(0,0,0);
  scoreboard.text("Score\n coucou",10,50);
  scoreboard.endDraw();
}