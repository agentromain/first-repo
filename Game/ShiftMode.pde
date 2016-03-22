void shift(){
 rotateX(-PI/2.0);
}

void mouseClicked(){
  if(isShift){
    float x = mouseX-width/2.0;
    float y = mouseY-height/2.0;
    if(x >= -side/2.0  && x <= side/2.0   && y >= -side/2.0  && y <= side/2.0 ){
      posCyls.add(new PVector(x,y));
    }
    
  }
  
}