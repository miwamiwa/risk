void initGame(){
    
  
   for(int i=0; i<42; i++){
   troopsOnTile[i] = 1; 
  }
  
   for(int i=0; i<42; i++){
    tileassignment[i] = data[i+4]; 
   }
   
    loadPixels();
  
  for(int i=0; i<tilesPerPlayer*3; i+=3){
    int tile1 = tileassignment[i];
    int tile2 = tileassignment[i+1];
    int tile3 = tileassignment[i+2];
    playerTiles[0].append( tile1 );
    playerTiles[1].append( tile2 );
    playerTiles[2].append( tile3 );
   setTileColor( 0, tile1);
   setTileColor( 1, tile2);
   setTileColor( 2, tile3);
   //delay(1);
  // println(i);
  }
  
  playerNames[0]= sdata[1];
  playerNames[1] = sdata[2];
  playerNames[2] = sdata[3];
  //println(playerNames);
  
  updatePixels();
  // print("tiles: ");
 //  println(tileassignment);
 gamePhase="initial troop assignment";
 tileInfoPending = false;
 
 delay(50);
}