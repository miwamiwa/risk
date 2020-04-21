 
 boolean enterPressed(){
  return (keyPressed && ( key == ENTER || key == RETURN ));
 }
 
 
 
 void pressRforReturn(){
   if(keyPressed&&(key=='r'||key=='R')&&!choiceMade){
     choiceMade = true;
     turnPhase = "choice phase";
     c.write("returntochoicephase\n");
     attackingCountry=-1;
     attackTarget=-1;
   }
   // signal server to return to turnphase = choicephase;
 }
 
 
 
 void pressRforReady(int phase){
   if(keyPressed && ( key == 'r' || key == 'R' )&&!choiceMade){
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

// add/remove troops during pre-game placement or pre-turn placement
void addRemoveTroopsOnClick(int phase){
 if(mousePressed&&mouseButton==LEFT){
      int tile = getTile();
      if(tile!=-1){
        if(isUserTile(tile)){
         c.write(phase+" 1 "+tile+" "+clientId+"\n"); // 2 means phase 2, 1 means add
        println("troop request. phase: "+phase+". command: 1 (add). tile: "+tile+". player: "+clientId+". Current pTroops: "+placeableTroops+". current troop amount: "+troopsOnTile[tile]);
        }
      }
    }
    
    else if(mousePressed&&mouseButton==RIGHT){
      int tile = getTile();
      if(tile!=-1){
        if(isUserTile(tile)){
          c.write(phase+" 0 "+tile+" "+clientId+"\n");
         println("troop request. phase: "+phase+". command: 0 (remove). tile: "+tile+". player: "+clientId+". Current pTroops: "+placeableTroops+". current troop amount: "+troopsOnTile[tile]);
        }
      }
    } 
  }




void pressNumToPickDice(char num){
  if(keyPressed&&key==num&&!choiceMade){
    choiceMade = true;
   c.write("dicepick "+clientId+" "+num+"\n"); 
  }
}



void pressEtoEndTurn(){
 if(keyPressed&&(key=='e'||key=='E')){
  c.write("turnisover\n"); 
 }
}