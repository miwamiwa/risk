void drawTroops(){
  
  for(int i=0; i<troopNumLocations.length; i+=2){
    fill(255);
  rect(troopNumLocations[i],troopNumLocations[i+1],troopNumTxtSize+10,troopNumTxtSize+5);
  fill(0);
  textSize(troopNumTxtSize);
  int offset=5;
  int units = troopsOnTile[i/2];
  if(units>9) offset=0;
  text( units ,troopNumLocations[i]+3+offset,troopNumLocations[i+1]+troopNumTxtSize);
  }
}

void setTileColor( int p, int index ){
   index = index*3;
  for(int i=0; i<628; i++){
    for(int j=0; j<1227; j++){
      color px = img.get(j,i);
   if( red( px )== hues[index] && green( px )==hues[index+1] && blue( px  )==hues[index+2]){
     
     int gridX = floor(j/texturePixelSize)%flagW;
     int gridY = floor(i/texturePixelSize)%flagH;
     color pick = flagGrids[ p*flagW*flagH + gridY*flagW + gridX  ];
    
   pixels[i*width+j] = flagColors[ pick ]; 
   }
    }
  }
}
