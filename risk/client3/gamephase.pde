void runGamePhase(){
 
  drawTroops();
  
 if(isTurnToPlay){
   
  switch(turnPhase){
    
    case "combo placement":  
    
      StringList combos = getAvailableCombos();
      String combostring = "";
      for(int i=0; i<combos.size(); i++){
       combostring+=i+": "+combos.get(i)+". "; 
      }
      
      if(keyPressed&&(key=='r'||key=='R')){
        turnPhase = "reinforcement phase";
      }
      
      infoRect("Select a combo from the list (press 0,1,2..). PRESS R to return.");
      textSize(15);
      textLeading(15);
      text("\n"+combostring,410,height-95,600,120);
      pressKeyToSelectCombo(combos);
      
     break;
    
    case "reinforcement phase":
         // refresh troop numbers
      String combotxt = "\nPRESS ENTER to view and play available combos";
      if(comboPlaced) combotxt="\nyou can't place any more combos this turn";
      addRemoveTroopsOnClick(3); 
      infoRect(
        "your turn. PLACE TROOPS! "+placeableTroops+ " dudes left."
        +"\nLEFT-CLICK on a country to add, RIGHT-CLICK to remove."
        +"\nPRESS R for ready (continue to battle phase)"
        + combotxt
      ); 
      if(enterPressed()&&!comboPlaced) turnPhase="combo placement";
      pressRforReady(3);
      
    break;
    
    case "choice phase": 
    
    pressEtoEndTurn();
    String endtxt = "\nPRESS E to end turn (+ tactical move) (can't undo).";
    if(conqueredSomething) endtxt = "\nPRESS E to draw a card and end you turn (+ tactical move)";
    else endtxt += "\nYou must conquer at least 1 territory to draw a card";
    if(attackingCountry==-1){
      
      infoRect( "battle phase.\nCLICK to select a country to attack from." +endtxt );
     // goBackButton();
       // pressBforBack();
      if(mousePressed&&mouseButton==LEFT){
      int tile = getTile();
    //  println("tile "+tile);
      if(tile!=-1){
        if(isUserTile(tile)&&troopsOnTile[tile]>1){
         attackingCountry = tile;
        }
      }
    }
    }
    else if(attackTarget==-1){
     // setTileColor(color(125),attackingCountry);
      int atkdice = getAvailableDice("attacking");
      infoRect(
      "attack which country with "+territoryNames[attackingCountry]+"? CLICK to select."
      +"\nMaximum number of dice: "+atkdice
      +"\nPRESS B to go back one step"  +endtxt 
      );
     // goBackButton();
     pressBforBack();
     
      if(mousePressed&&mouseButton==LEFT){
        
      int tile = getTile();
      if(tile!=-1){
        boolean usertile = isUserTile(tile);
        if(isNeighbourTile(attackingCountry,tile)&&!usertile){
         attackTarget = tile;
        } 
        else if(usertile&&troopsOnTile[tile]>1){
         attackingCountry = tile;
        }
      }
      
    }
    }
    else if(attackTarget!=-1){
      
     // setTileColor(color(125),attackingCountry);
    //  setTileColor(color(125),attackTarget);
      int atkdice = getAvailableDice("attacking");
      int defdice = getAvailableDice("defending");
     // goBackButton();
     pressBforBack();
     if(attackTarget>=0&&attackingCountry>=0)
      infoRect(
        "PRESS ENTER to attack "+territoryNames[attackTarget]+" from "+territoryNames[attackingCountry]
        +"\nattacking country can roll "+atkdice+"dice. "
        +"\ndefending country can roll "+defdice+". "
        +"\nPRESS B to go back"
      );
      if(enterPressed()){
        // ready to attack
        setTileColor(teamColors[clientId],attackingCountry);
        setTileColor(teamColors[getTileOwner(attackTarget)],attackTarget);
        println("ready to attack!!");
        c.write("4 "+attackingCountry+" "+attackTarget+"\n");
      }
  }
      
    break;
    
    case "tactical move phase": 
    
    String tacticalText="tactical move! PRESS R to cancel selection.\nPRESS B to skip (end turn).";
    String nextline = "";
    if(!tacticalTargetConfirmed){
      if(tacticalMoveFrom==-1) nextline = "\nCLICK to select first country";
      else if (tacticalMoveTo==-1) nextline = "\nCLICK to select neighbouring country"
      +"\n1st country: "+territoryNames[tacticalMoveFrom];
      else nextline = "\nPRESS ENTERR to confirm country selection (can't undo), \nor CLICK to select another neighbour of the 2nd country"
      +"\n1st country: "+territoryNames[tacticalMoveFrom]+". 2nd country: "+territoryNames[tacticalMoveTo];
    }
    else {
      tacticalText = "tactical move! PRESS B or ENTER to end turn.";
      nextline="\nRIGHT CLICK to add to first country, LEFT CLICK to add to second country"
      +"\n1st country: "+territoryNames[tacticalMoveFrom]+". 2nd country: "+territoryNames[tacticalMoveTo];
    }
    
     if(enterPressed()&&tacticalMoveFrom!=-1&&tacticalMoveTo!=-1&&!tacticalTargetConfirmed){
       tacticalTargetConfirmed=true;
       delay(200);
     } // press enter to confirm country selection, then
     else if(enterPressed()&&!choiceMade){
       choiceMade = true;
       c.write("tacticalphaseover\n"); // press enter to finish turn
     }
     
     if(keyPressed&&(key=='b'||key=='B')&&!choiceMade){
       choiceMade = true;
       c.write("tacticalphaseover\n");
     }
     
     if(keyPressed&&(key=='r'||key=='R')){ // press r to go back a step
       if(tacticalTargetConfirmed) tacticalTargetConfirmed=false;
       else if(tacticalMoveTo!=-1) tacticalMoveTo=-1;
       else if(tacticalMoveFrom!=-1) tacticalMoveFrom=-1;
     }
     
     tacticalText+=nextline;
     infoRect(tacticalText);
     if(tacticalTargetConfirmed){
       if(mousePressed&&!choiceMade){
         choiceMade = true;
        if(mouseButton==LEFT){
          delay(20);
          c.write("tacticaladd "+tacticalMoveFrom+" "+tacticalMoveTo+"\n");
        }
        else if(mouseButton==RIGHT){
          delay(20);
          c.write("tacticalremove "+tacticalMoveFrom+" "+tacticalMoveTo+"\n");
        }
       }
     }
     else {
       
    if(mousePressed){
      int targetTile=-1;
      targetTile = getTile();
      if(targetTile!=-1){
      if(tacticalMoveFrom==-1){
      if(isUserTile(targetTile)){
        tacticalMoveFrom=targetTile;
      }
    }
    else {
      if(tacticalMoveTo==-1){
        if(isUserTile(targetTile)&&isNeighbourTile(tacticalMoveFrom,targetTile)){
          tacticalMoveTo=targetTile;
          lastTacticalMoveTo = targetTile;
        }
      }
      else{
        if(
        targetTile!=tacticalMoveFrom
        &&isUserTile(targetTile)
        &&isNeighbourTile(lastTacticalMoveTo,targetTile)
        ){
          tacticalMoveTo=targetTile;
          lastTacticalMoveTo=targetTile;
        }
      }
    }
    }
    }
     }
    
    
    
    
    break;
    
    case "attack phase": 
    //   println("attackphase");
       
       if(battlePhase=="attackerchoice"){
     //    println("attackerchoice");
         if(availableDice>0) pressNumToPickDice('1');
         if(availableDice>1) pressNumToPickDice('2');
         if(availableDice>2) pressNumToPickDice('3');
         
         infoRect(
         "pick a number of dice to roll (press 1,2,3)"
         + "\nmax available dice: "+availableDice
         );
       }
       else if(battlePhase=="defenderchoice"){
      
         infoRect("defender is picking his dice");
       }
       else if(battlePhase=="result phase"){
         String continueTxt = "not enough troops to continue."
         + "\nPRESS R to return to fight selection";
         
         if(canContinue) continueTxt = ". \nPRESS ENTER to continue fighting"
         + "\nPRESS R to return to fight selection";
         
         String results = "";
         String atkDiceString = "";
         String defDiceString = "";
         for(int i=0; i<3; i++){
          if(lastAttackRoll[i]!=-1) atkDiceString+=lastAttackRoll[i]+" ";
         }
         for(int i=0; i<2; i++){
         if(lastDefenseRoll[i]!=-1)  defDiceString+=lastDefenseRoll[i]+" ";
         }
         results = "attack rolls: "+atkDiceString+". defense rolls: "+defDiceString+". "
         +"\n defense dudes lost: "+defenderTileDamage+". own dudes lost: "+attackerTileDamage
         +continueTxt;
         
         infoRect(results);
         pressRforReturn();
         if(enterPressed()&&canContinue){
          c.write("continuebattle\n"); 
         }
       }
        else if(battlePhase=="conquer phase"){
          
          if(mousePressed&&mouseButton==LEFT){
           c.write("moretroops\n");
           delay(20);
          }
          else if(mousePressed&&mouseButton==RIGHT){
           c.write("lesstroops\n");
           delay(20);
          }
           infoRect(
          "LEFT CLICK to add dudes to your new territory, "+territoryNames[attackTarget]
          +"\nRIGHT CLICK to remove dudes."
          +"\nPRESS R to confirm troop movement."
          );
          pressRforReturn();
         
          
        }
    break;
    
   // case "card phase": break; not a phase: on turn end
   // you just get a notifications that says you got a card or not
   // ..should make separate card menu instead
  }
 }
 else {
   // IF NOT YOUR TURN TO PLAY 
   if(turnPhase=="reinforcement phase"){
     drawTroops();  
   }
   if(turnPhase=="defense phase"){
     
     if(battlePhase=="attackerchoice"){
         infoRect(
         "you're under attack! waiting on attacker."
         +"\nattacking country: "+territoryNames[attackingCountry]
         +". defending country: "+territoryNames[attackTarget]
         );
       }
     else if(battlePhase=="defenderchoice"){
         if(availableDice>0) pressNumToPickDice('1');
         if(availableDice>1) pressNumToPickDice('2');
         if(availableDice>2) pressNumToPickDice('3');
         
         infoRect(
         "defend "+territoryNames[attackTarget]+" against "+territoryNames[attackingCountry]+"!"
         + "\npick a number of dice to roll (press 1,2,3)"
         + "\nmax available dice: "+availableDice
         + "\nattacker chose to roll"+attackingDice+" dice/die"
         );
       }
       else if(battlePhase=="result phase"){
         String results = "";
         String atkDiceString = "";
         String defDiceString = "";
         for(int i=0; i<3; i++){
           atkDiceString+=lastAttackRoll[i]+" ";
         }
         for(int i=0; i<2; i++){
           defDiceString+=lastDefenseRoll[i]+" ";
         }
         results = "attack rolls: "+atkDiceString+"; defense rolls: "+defDiceString+". "
         +"\n dudes lost: "+defenderTileDamage+". enemy dudes lost: "+attackerTileDamage
         +"\nwaiting for attacker to continue";
         
         infoRect(results);
       }
       else if(battlePhase=="conquer phase"){
         infoRect("you lost the fight! attacker is moving in.");
        }
       
   }
   else if(turnPhase=="viewbattle phase"){
     
     if(battlePhase=="attackerchoice"){
         infoRect("attacker must pick a number of dice");
       }
       else if(battlePhase=="defenderchoice"){
         infoRect("defender must pick a number of dice");
       }
       else if(battlePhase=="result phase"){
         String results = "";
         String atkDiceString = "";
         String defDiceString = "";
         for(int i=0; i<3; i++){
           atkDiceString+=lastAttackRoll[i]+" ";
         }
         for(int i=0; i<2; i++){
           defDiceString+=lastDefenseRoll[i]+" ";
         }
         results = "attack rolls: "+atkDiceString+"; defense rolls: "+defDiceString+". "
         +"\n defender dudes lost: "+defenderTileDamage+". attacker dudes lost: "+attackerTileDamage
         +"\nwaiting for attacker to continue";
         
         infoRect(results);
       }
       else if(battlePhase=="conquer phase"){
         infoRect("attacker won!");
        }
     else infoRect("game is running. \nthere's a battle happening. not you tho."); 
   }
   else {
     infoRect("game is running. not ur turn tho"); 
   }
   
 }
}