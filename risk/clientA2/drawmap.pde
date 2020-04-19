void drawTroops(){
  
  for(int i=0; i<troopNumLocations.length; i+=2){
    fill(255);
  rect(troopNumLocations[i],troopNumLocations[i+1],troopNumTxtSize+25,troopNumTxtSize+5);
  fill(0);
  textSize(troopNumTxtSize);
  text(troopsOnTile[i/2],troopNumLocations[i]+10,troopNumLocations[i+1]+troopNumTxtSize);
  }
}

void setTileColor( color col, int index ){
   index = index*3;
  for(int i=0; i<628; i++){
    for(int j=0; j<1227; j++){
      color px = img.get(j,i);
   if( red( px )== hues[index] && green( px )==hues[index+1] && blue( px  )==hues[index+2]){
     
   pixels[i*width+j] = col; 
   }
    }
  }
}