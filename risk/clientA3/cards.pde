


void displayCards(){
 fill(245);
 rect(10,10,400,35);
 fill(24);
 textSize(15);
 textLeading(15);
 text("cards: "+cardText,10,10,400,40);
}



// getcard()
//
// add a card to this player's card list 
void getCard( int card ){
  cards.append(card);
  println("new card "+card);
  cardText = "";
  for(int i=0; i<cards.size(); i++){
   switch(cards.get(i)){ 
    case 0: cardText+= "infantry "; break;
    case 1: cardText+= "horse "; break;
    case 2: cardText+= "canon "; break;
    case 3: cardText+= "wild card "; break;
    }
  }
  displayCards();
}
