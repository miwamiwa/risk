
int getTile(){
  
   color c = img.get(mouseX,mouseY);
    // println( red(c) + "," + green(c)+ "," + blue(c)+"," );
 int hueIndex = -1;
 
  for(int i=0;i<hues.length; i+=3){
    if( red(c)==hues[i] && green(c)==hues[i+1] && blue(c)==hues[i+2] ){
       // println(i/3);
    hueIndex = i/3;
    }
  }
 return hueIndex;
}

boolean isUserTile( int tile ){
 boolean result = false;
 
 if(clientId==0){
   if(playerTiles[0].hasValue(tile)==true) result=true;
 }
 else if(clientId==1){
   if(playerTiles[1].hasValue(tile)==true) result=true;
 }
 else if(clientId==2){
   if(playerTiles[2].hasValue(tile)==true) result=true;
 }
 return result;
}

boolean isNeighbourTile (int tile,int potentialneighbour){
   boolean result = false;
  if(tile!=-1){
    int index = tile*6;
  
  if( 
  neighbourTiles[index]==potentialneighbour
  || neighbourTiles[index+1]==potentialneighbour
  || neighbourTiles[index+2]==potentialneighbour
  || neighbourTiles[index+3]==potentialneighbour
  || neighbourTiles[index+4]==potentialneighbour
  || neighbourTiles[index+5]==potentialneighbour
  ){
    result = true;
  }
  }
  
 return result;
}

int getTileOwner(int tile){
 int result = -1;
 if(playerTiles[0].hasValue(tile)) result =0;
 else if(playerTiles[1].hasValue(tile)) result =1;
 else if(playerTiles[2].hasValue(tile)) result =2;
 return result;
}