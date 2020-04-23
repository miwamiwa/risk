
void infoRect(String input){
  fill(245);
    rect(400,height-180,770,120);
      fill(45);
      textSize(18);
      textLeading(20);
  text(input,410,height-155);
    
}

void flashyText(String input, int x, int y, int size, color textColor, color flashColor,boolean on){
  fill(textColor);
  textSize(size);
  if(frameCount%16>7&&on){
    fill(flashColor);
  }
  text(input,x,y);
}
void drawPlayerInfo(){
  
  int x=600;
  int y=20;
  
  
  
  fill(225);
  rect(x-5,y-15,600,20);
  textSize(15);
  fill(#cc4444);
  text("P1: "+playerNames[turnOrder[0]]+". Territories: "+playerTiles[turnOrder[0]].size(), x, y);
  
  fill(#22bb22);
  text("P2: "+playerNames[turnOrder[1]]+". Territories: "+playerTiles[turnOrder[1]].size(), x+200, y);
  
  fill(#4444cc);
  text("P3: "+playerNames[turnOrder[2]]+". Territories: "+playerTiles[turnOrder[2]].size(), x+400, y);
  


}
