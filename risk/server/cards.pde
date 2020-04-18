
void addCard(int player, int card){
  playerCards[player].append(card);
}


int pickACard(){
  int cardPick=-1;
 if(cardAwarded){
          if(deck.size()>0){
            cardPick = deck.get(0);
            deck.remove(0);
          }
          else {
            deck = newDeck();
            cardPick = deck.get(0);
            deck.remove(0);
          }
        }
        else cardPick =-1;
   return cardPick;
}