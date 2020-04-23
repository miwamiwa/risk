


void displayCards(){
  int x=440;
  int y=height-300;
  int w=120;
  int h=100;
 fill(245);
 rect(x-5,y-5,w+10,h+10);
 fill(24);
 textSize(15);
 textLeading(15);
 text("cards:\n"+cardText,x,y,w,h);
}



// getcard()
//
// add a card to this player's card list 
void getCard( int card ){
  cards.append(card);
  println("new card "+card);
  cardText = "";
  for(int i=0; i<cards.size(); i++){
    if(i!=0) cardText+=", ";
   switch(cards.get(i)){ 
    case 0: cardText+= "infantry"; break;
    case 1: cardText+= "horse"; break;
    case 2: cardText+= "canon"; break;
    case 3: cardText+= "wild card"; break;
    }
  }
  cardText+=".";
  displayCards();
}