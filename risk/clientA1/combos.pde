// selectCombo()
//
// find and remove user's cards after they've chosen a combo.
// update uer's cards list and display.
// sends combo message to server (which will then return combo amount)
void selectCombo(StringList inputlist, int pick){
  
  // wait for server response to continue
  if(!choiceMade){
    choiceMade = true;
    // prevent placing other combos on this turn
    comboPlaced = true;
    // get current card list
    int[] cardlist = int(splitTokens( inputlist.get(pick),"," ));
    // find and remove combo cards
    int[] index = new int[3];
    for(int i=0; i<3; i++){
     for(int j=0; j<cards.size(); j++){
      if(cards.get(j)== cardlist[i]){
        index[i]=j;
      }
     }
     cards.remove(index[i]);
    }
    // reset card display
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
    // send combo request to server
    c.write("comborequest\n");
    // continue to reinforcement phase
    turnPhase = "reinforcement phase";
  }
}

// getavailablecombos()
//
// returns a list of available combos by comparing cards with a list of all possible combos.
StringList getAvailableCombos(){
 StringList combos = new StringList();
 if(hasCombo(0,0,0,cards)) combos.append("infantry,infantry,infantry"); 
 if(hasCombo(1,1,1,cards)) combos.append("horse,horse,horse");
 if(hasCombo(2,2,2,cards)) combos.append("canon,canon,canon");
 if(hasCombo(0,1,2,cards)) combos.append("infantry,horse,canon");
 if(hasCombo(0,0,3,cards)) combos.append("infantry,infantry,wildcard");
 if(hasCombo(0,3,3,cards)) combos.append("infantry,wildcard,wildcard");
 if(hasCombo(1,1,3,cards)) combos.append("horse,horse,wildcard");
 if(hasCombo(1,3,3,cards)) combos.append("horse,wildcard,wildcard");
 if(hasCombo(2,2,3,cards)) combos.append("canon,canon,wildcard");
 if(hasCombo(2,3,3,cards)) combos.append("canon,wildcard,wildcard");
 if(hasCombo(0,1,3,cards)) combos.append("infantry,horse,wildcard");
 if(hasCombo(0,2,3,cards)) combos.append("infantry,canon,wildcard");
 if(hasCombo(1,2,3,cards)) combos.append("horse,canon,wildcard");
 return combos;
}


// hascombo()
//
// checks if the user has a specific combo in hand
// i1,i2 and i3 are the combo cards. 
// input list is the user's hand
boolean hasCombo(int i1, int i2, int i3, IntList input){
  
  boolean result=false;
  
  boolean missingOne = !input.hasValue(i1)||!input.hasValue(i2)||!input.hasValue(i3);
  if(missingOne) return false;
  
  // once a card is found, save its array position to avoid
  // repeating it afterwards
  int index1 =-1;
  for(int i=0; i<input.size(); i++){
   if(input.get(i)==i1) index1=i; 
  }
  
  // find second card
  int index2 =-1;
  for(int i=0; i<input.size(); i++){
    // avoid repeats
   if(input.get(i)==i2&&i!=index1) index2=i; 
  }
  
  // find third card
  int index3 =-1;
  for(int i=0; i<input.size(); i++){
    // avoid repeats
   if(input.get(i)==i3&&i!=index2&&i!=index1) index3=i; 
  }
  
  if(index1!=-1&&index2!=-1&&index3!=-1) result = true;
  return result;
}
