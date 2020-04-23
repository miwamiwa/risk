
 
 void returnToChoicePhase(){
   if(!choiceMade){
     choiceMade = true;
     turnPhase = "choice phase";
     c.write("returntochoicephase\n");
     attackingCountry=-1;
     attackTarget=-1;
   }
   // signal server to return to turnphase = choicephase;
 }
 
 
 // signal that player is ready during initial troop placement phase
 void signalReady(int phase){
   
   if(!choiceMade){
     choiceMade=true;
     if(!playerReady){
       playerReady = true;
       c.write(phase+" 2 "+clientId+"\n");// ready message
     }
     else {
       playerReady = false;
       c.write(phase+" 3 "+clientId+"\n");// not ready message
     }
   }
 }
 
 
void pressBforBack(){
  if(keyPressed && ( key == 'b' || key == 'B' )){
    if(attackTarget!=-1) attackTarget=-1;
     else attackingCountry = -1;
  }
}

void cancelCountrySelection(){
 if(attackTarget!=-1) attackTarget=-1;
      else attackingCountry = -1;  
}

// add/remove troops during pre-game placement or pre-turn placement
void addRemoveTroopsOnClick(int phase){
   // println(hasClicked,buttonclicked);
  if(hasClicked&&!buttonclicked){
    
    if(mouseButton==LEFT){
      int tile = getTile();
      if(tile!=-1){
        if(isUserTile(tile)){
         c.write(phase+" 1 "+tile+" "+clientId+"\n"); // 2 means phase 2, 1 means add
        println("troop request. phase: "+phase+". command: 1 (add). tile: "+tile+". player: "+clientId+". Current pTroops: "+placeableTroops+". current troop amount: "+troopsOnTile[tile]);
        }
      }
    }
    
    else if(mouseButton==RIGHT){
      int tile = getTile();
      if(tile!=-1){
        if(isUserTile(tile)){
          c.write(phase+" 0 "+tile+" "+clientId+"\n");
         println("troop request. phase: "+phase+". command: 0 (remove). tile: "+tile+". player: "+clientId+". Current pTroops: "+placeableTroops+". current troop amount: "+troopsOnTile[tile]);
        }
      }
    } 
  }
 
  }




void pressNumToPickDice(char num){
  if(!choiceMade){
    choiceMade = true;
   c.write("dicepick "+clientId+" "+num+"\n"); 
  }
}