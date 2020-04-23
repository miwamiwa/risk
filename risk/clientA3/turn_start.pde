void turnStart(int input){
  
  
  playingPlayer = data[1];
  playerReady = false;
  turnPhase = "reinforcement phase";
  comboPlaced = false;
  
  println(input+"'s turn");
  
  if(data[3]==1){
    if(data[4]==clientId)
   getCard(data[5]); 
  }
  
 if(input==clientId){
  isTurnToPlay = true; 
  placeableTroops= data[2];
 }
 else isTurnToPlay = false;
}
