void shift(){
 rotateX(-PI/2.0);
}

void mouseClicked(){
  if(isShift){
    posCyls.add(new PVector(mouseX,mouseY));
  }
  
}