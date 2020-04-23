
void infoRect(String input){
  fill(245);
    rect(400,height-180,770,120);
      fill(45);
      textSize(20);
      textLeading(20);
  text(input,410,height-155);
    
}
void drawPlayerInfo(){
  
  int x=20;
  int y=600;
  
  fill(225);
  rect(x-5,y-30,200,160);
  textSize(24);
  fill(teamColors[0]);
  text(playerNames[0], x, y);
  
  fill(teamColors[1]);
  text(playerNames[1], x, y+50);
  
  fill(teamColors[2]);
  text(playerNames[2], x, y+100); 
  
  textSize(22);
  
  fill(teamColors[0]);
  text("countries: "+playerTiles[0].size(), x, y+25);
  
  fill(teamColors[1]);
  text("countries: "+playerTiles[1].size(), x, y+75);
  
  fill(teamColors[2]);
  text("countries: "+playerTiles[2].size(), x, y+125); 

}
