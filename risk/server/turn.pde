void setupTurn( int player,int lastPlayer ){
  
  
  whoseTurn=player;
  int cardPick = -1;
  String cardString = " 0";
  if(lastPlayer!=-1){
    cardPick = pickACard();
    
    if(cardPick!=-1){
     addCard(cardPlayer,cardPick); 
     cardString = " 1 "+lastPlayer+" "+cardPick;
    }
  }
  cardAwarded = false;
  cardPlayer = player;
  println(cardAwarded);
  println(cardPick);
  println(lastPlayer);
  println(cardPlayer);
  
  turnPhase = "troop placement phase";
  int reinforcements = getBaseReinforcements(player)+getContinentsBonus(player);
  placeableTroops[player] = reinforcements;
  troopsPlaced = false;
  for(int i=0; i<42; i++){
   troopsOnTurnStart[i] = troopsOnTile[i]; 
  }
 // s.write
 delay(1000);
 println("start turn");
 s.write("turnstart "+player+" "+placeableTroops[player]+cardString+"\n");
 println("turnstart "+player+" "+placeableTroops[player]+cardString+"\n");
}