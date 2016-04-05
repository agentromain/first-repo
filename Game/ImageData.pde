void drawData(){
  imgData.beginDraw();
  
  imgData.background(229, 225, 174);
  
  drawTV();
  imgData.fill(255, 0, 0);
  imgData.rect(0,0, 10, 10);
  //imgData.image(imgTopView, 10, imgTVEdge+10);
  
  imgData.endDraw();
}

void drawTV(){
  imgTopView.beginDraw();

  imgTopView.background(0, 0, 0);

  imgTopView.endDraw();

}