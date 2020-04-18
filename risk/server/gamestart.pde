// checkforeveryoneandstart()
//
// wait for all the players to show up then start the game

void checkForEveryoneAndStart(){
  if(players.size()==1){
    
    players.append("playertwoooo");
    players.append("playerhreet");
   gameStarted = true; 
  delay(1000);
  
   gamePhase="initial troop assignment";
   println("gameload");
   s.write("gameload "+players.get(0)+" "+players.get(1)+" "+players.get(2)+" ");
   assignTiles();
 } 
}

// troopplacementisdone()
//
// determine order and start the first turn

void troopPlacementIsDone(){
  
 gamePhase="game";
  
  placeableTroops[0] =0;
  placeableTroops[1] =0;
  placeableTroops[2] =0;
   
  turnOrder.append(0);
  turnOrder.append(1);
  turnOrder.append(2);
  turnOrder.shuffle();

  s.write("gamestart\n");
  setupTurn( turnOrder.get(0),-1); // CHANGE THIS LATER PLS PLS
  
}