void runGamePhase(){
 
  drawTroops();
  
  // ********* IF THIS IS IS PLAYER'S TURN
 if(isTurnToPlay){
   
  switch(turnPhase){
    
    // ********************* COMBO PLACEMENT PHASE **********
    case "combo placement":  
    
      // display combo list
      StringList combos = getAvailableCombos();
      String combostring = "";
      for(int i=0; i<combos.size(); i++){
       combostring+=i+": "+combos.get(i)+". "; 
      }
      infoRect("Select a combo from the list (press 0,1,2..). PRESS R to return.");
      textSize(15);
      textLeading(15);
      text("\n"+combostring,410,height-95,600,120);
      
      // Combo placement phase controls: 
      // - Press r to return to reinforcement phase
      if(keyPressed&&(key=='r'||key=='R')){
        turnPhase = "reinforcement phase";
      }
      // - Press number keys to select a combo
      pressKeyToSelectCombo(combos);
      
     break; 
    
    // *************** ******** REINFORCEMENT PHASE **************
    case "reinforcement phase":
      
      // display instructions
      String combotxt = "\nPRESS ENTER to view and play available combos";
      if(comboPlaced) combotxt="\nyou can't place any more combos this turn";
      infoRect(
        "your turn. PLACE TROOPS! "+placeableTroops+ " dudes left."
        +"\nLEFT-CLICK on a country to add, RIGHT-CLICK to remove."
        +"\nPRESS R for ready (continue to battle phase)"
        + combotxt
      ); 
      
      // Reinforcement phase controls:
      // - click to add/remove units
      addRemoveTroopsOnClick(3); 
      // - press enter to start combo placement phase
      if(enterPressed()&&!comboPlaced) turnPhase="combo placement";
      // - press r to start CHOICE PHASE
      pressRforReady(3);
      
    break;
    
    // ************************** CHOICE PHASE *********************
    case "choice phase": 
    
    // press E at any time during choice phase to end turn.
    pressEtoEndTurn(); 
    
    // setup end text
    String endtxt = "\nPRESS E to end turn (+ tactical move) (can't undo).";
    if(conqueredSomething) endtxt = "\nPRESS E to draw a card and end you turn (+ tactical move)";
    else endtxt += "\nYou must conquer at least 1 territory to draw a card";
    
    // attacking country not yet selected
    if(attackingCountry==-1){
      // display instructions
      infoRect( "battle phase.\nCLICK to select a country to attack from." +endtxt );
      // select attacking country
      if(mousePressed&&mouseButton==LEFT&&!drawing){
        int tile = getTile();
        if(tile!=-1){
          // select if tile is owned by user and has more than 1 unit
          if(isUserTile(tile)&&troopsOnTile[tile]>1){
           attackingCountry = tile;
          }
        }
      }
    }
    
    // if attacking country is chosen
    else if(attackTarget==-1){
      
      // display instructions
      int atkdice = getAvailableDice("attacking");
      infoRect(
      "attack which country with "+territoryNames[attackingCountry]+"? CLICK to select."
      +"\nMaximum number of dice: "+atkdice
      +"\nPRESS B to go back one step"  +endtxt 
      );
      
      // Controls:
      // press b to go back to selecting attacking country
     pressBforBack();
     // select country to attack
      if(mousePressed&&mouseButton==LEFT&&!drawing){
      int tile = getTile();
      if(tile!=-1){
        boolean usertile = isUserTile(tile);
        if(isNeighbourTile(attackingCountry,tile)&&!usertile){
         attackTarget = tile;
        }
        // or select a different country to attack from
        else if(usertile&&troopsOnTile[tile]>1){
         attackingCountry = tile;
        }
      }
    }
   }
   // if both attacking country and target are selected
    else if(attackTarget!=-1){
      
      // display instructions
      int atkdice = getAvailableDice("attacking");
      int defdice = getAvailableDice("defending");
      infoRect(
        "PRESS ENTER to attack "+territoryNames[attackTarget]+" from "+territoryNames[attackingCountry]
        +"\nattacking country can roll "+atkdice+"dice. "
        +"\ndefending country can roll "+defdice+". "
        +"\nPRESS B to go back"
      );
      
      // controls:
      // press b to go back to selecting country to attack
      pressBforBack();
      // press enter to start fight
      if(enterPressed()){
        // ready to attack
        setTileColor(teamColors[clientId],attackingCountry);
        setTileColor(teamColors[getTileOwner(attackTarget)],attackTarget);
        println("ready to attack!!");
        c.write("4 "+attackingCountry+" "+attackTarget+"\n");
      }
  }
    break;
    
    // ********************** TACTICAL MOVE PHASE **************************
    case "tactical move phase": 
    
    // update instructions
    String tacticalText="tactical move! PRESS R to cancel selection.\nPRESS B to skip (end turn).";
    String nextline = "";
    if(!tacticalTargetConfirmed){
      if(tacticalMoveFrom==-1) nextline = "\nCLICK to select first country";
      else if (tacticalMoveTo==-1) nextline = "\nCLICK to select neighbouring country"
      +"\n1st country: "+territoryNames[tacticalMoveFrom];
      else nextline = "\nPRESS ENTER to confirm country selection (can't undo), \nor CLICK to select another neighbour of the 2nd country"
      +"\n1st country: "+territoryNames[tacticalMoveFrom]+". 2nd country: "+territoryNames[tacticalMoveTo];
    }
    else {
      tacticalText = "tactical move! PRESS B to confirm (END TURN).";
      nextline="\nRIGHT CLICK to add to first country, LEFT CLICK to add to second country"
      +"\n1st country: "+territoryNames[tacticalMoveFrom]+". 2nd country: "+territoryNames[tacticalMoveTo];
    }
    tacticalText+=nextline;
     infoRect(tacticalText);
      
      
      // Tactical move phase controls: 
      
      // if tactical move targets selected:
      // - press Enter to confirm targets (proceed to tactical move)
     if(enterPressed()&&tacticalMoveFrom!=-1&&tacticalMoveTo!=-1&&!tacticalTargetConfirmed){
       tacticalTargetConfirmed=true;
       delay(200);
     } 
     // - press B to end tactical phase (trigger next turn)
     if(keyPressed&&(key=='b'||key=='B')&&!choiceMade){
       choiceMade = true;
       c.write("tacticalphaseover\n");
     }
     
     // - press r to go back a step
     if(keyPressed&&(key=='r'||key=='R')){ 
       if(tacticalTargetConfirmed) tacticalTargetConfirmed=false;
       else if(tacticalMoveTo!=-1) tacticalMoveTo=-1;
       else if(tacticalMoveFrom!=-1) tacticalMoveFrom=-1;
     }
     
     // once tactical targets are confirmed,
     // - left/right click to add/remove troops
     if(tacticalTargetConfirmed){
       if(mousePressed&&!choiceMade&&!drawing){
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
     // if tactical targets not yet selected, 
     // select targets on mouse press
     else {
       
    if(mousePressed&&!drawing){
      int targetTile=-1;
      targetTile = getTile();
      if(targetTile!=-1){
        
        // select first tile
      if(tacticalMoveFrom==-1){
      if(isUserTile(targetTile)){
        tacticalMoveFrom=targetTile;
      }
    }
    else {
      // select second tile
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
          // select neighbour of second tile
          tacticalMoveTo=targetTile;
          lastTacticalMoveTo=targetTile;
        }
      }
    }
    }
    }
     } break;
    
    
    // ************************ ATTACKING PLAYER'S BATTLE PHASES: *******************
    
    case "attack phase": 
       
       // (ATK BATTLE PHASE) ATTACKER DICE CHOICE PHASE
       if(battlePhase=="attackerchoice"){
         
         // display instructions
         infoRect(
         "pick a number of dice to roll (press 1,2,3)"
         + "\nmax available dice: "+availableDice
         );
         
         // Attacker's dice choice controls (press 1, 2 or 3)
         if(availableDice>0) pressNumToPickDice('1');
         if(availableDice>1) pressNumToPickDice('2');
         if(availableDice>2) pressNumToPickDice('3');
       }
       
       // (ATK BATTLE PHASE) DEFENDER DICE CHOICE PHASE
       // attacker waits while defender choses his dice.
       else if(battlePhase=="defenderchoice"){
          
         // display instructions 
         infoRect("defender is picking his dice");
       }
       
       // (ATK BATTLE PHASE) RESULT PHASE
       else if(battlePhase=="result phase"){
         
         // display instructions
         String results = formatResults("attacker");
         String instru = "\nNot enough units to continue. PRESS R to end battle.";
         if(canContinue) instru="\nPRESS ENTER to continue battle. PRESS R to end battle.";
         infoRect(results+instru);
         
         // (atk battle phase) result phase controls:
         // press r to return to choice phase 
         pressRforReturn();
         // press enter to continue battle
         if(enterPressed()&&canContinue){
          c.write("continuebattle\n"); 
         }
       }
       
       // (ATK BATTLE PHASE) CONQUER PHASE ( = RESULT PHASE if attacker won)
        else if(battlePhase=="conquer phase"){
          
          // display insructions
          
          String results = formatResults("attacker");
         
           infoRect(
           results+
           "\nYOU WIN! LEFT/RIGHT CLICK to add/remove dudes to/from your new territory."
           +"\nPRESS R to confirm placement (continue)"
          );
          
          // controls
          // click to add/remove troops on belligerent tiles
          if(mousePressed&&!choiceMade&&!drawing){
           if(mouseButton==LEFT){
            choiceMade = true;
            c.write("moretroops\n");
           }
          else if(mouseButton==RIGHT){
            choiceMade= true;
            c.write("lesstroops\n");
           }
          }
          // press r to return to choice phase
          pressRforReturn();
 
        }
    break;
  }
 }
 
 
 // IF NOT YOUR TURN TO PLAY 
 else {
  
   // *********************** DEFENDER'S BATTLE PHASES ***************************
   if(turnPhase=="defense phase"){
     
     // DEFENDER'S ATK CHOICE PHASE
     if(battlePhase=="attackerchoice"){
       
       // display instructions
         infoRect( fightingPlayers("defender")+"\nPlease wait. " );
       }
       
       // DEFENDER'S DEF CHOICE PHASE
     else if(battlePhase=="defenderchoice"){
       
       // display instructions
         infoRect(
         fightingPlayers("defender")
         + "\npick a number of dice to roll (press 1,2,3)"
         + "\nmax available dice: "+availableDice
         + "\nattacker chose to roll"+attackingDice+" dice/die"
         );
         
         // Controls: press 0,1,2 to pick dice.
         if(availableDice>0) pressNumToPickDice('1');
         if(availableDice>1) pressNumToPickDice('2');
         if(availableDice>2) pressNumToPickDice('3');
       }
       
       // DEFENDER'S RESULT PHASE 
       else if(battlePhase=="result phase"){
         
         // display instructions 
         String results = formatResults("defender") +"\nPlease wait.";
         infoRect(results);
       }
       
       // DEFENDER'S CONQUER PHASE
       else if(battlePhase=="conquer phase"){
         String results = formatResults("defender")+"\nYou lost! \nAttacker is moving in. PLease wait. ";
         infoRect(results);
        }
       
   }
   
   // ************************ SPECTATOR'S BATTLE PHASES ********************************
   else if(turnPhase=="viewbattle phase"){
     
     // SPECTATOR'S ATK CHOICE PHASE
     if(battlePhase=="attackerchoice"){
       // display comments
         infoRect(fightingPlayers("spectator")+"\nAttacker is chosing his dice.");
       }
       
       // SPECTATOR'S DEF CHOICE PHASE
       else if(battlePhase=="defenderchoice"){
         // display comments
         infoRect(fightingPlayers("spectator")+"\nDefender is chosing his dice.");
       }
       
       // SPECTATOR'S RESULT PHASE
       else if(battlePhase=="result phase"){
         String results = formatResults("spectator");
         infoRect(results);
       }
       
       // SPECTATOR'S CONQUER PHASE
       else if(battlePhase=="conquer phase"){
         String results = formatResults("spectator");
         infoRect(results+"\n"+playerNames[attacker]+" won! Migrating troops.");
        }
     else infoRect(fightingPlayers("spectator")+". Yer not involved."); 
   }
   
   // IF NOT BATTLE PHASE AND THIS PLAYER ISN'T PLAYING:
   else {
     if(playingPlayer!=-1)
     infoRect("game is running. It's "+playerNames[playingPlayer]+"'s turn"); 
   }
 }
}

String formatResults(String who){
  
   String results = "";
   String atkDiceString = "";
   String defDiceString = "";
   String a=playerNames[attacker] + " rolls ";
   String d=playerNames[defender] + " rolls ";
   switch(who){
    case "attacker": a="YOU roll "; break;
    case "defender": d="YOU roll "; break;
   }
   for(int i=0; i<3; i++){
    if(lastAttackRoll[i]!=-1) atkDiceString+=lastAttackRoll[i]+" ";
   }
   for(int i=0; i<2; i++){
   if(lastDefenseRoll[i]!=-1)  defDiceString+=lastDefenseRoll[i]+" ";
   }
   results = fightingPlayers(who)
   +"\n"+a+atkDiceString+"... Units lost: "+attackerTileDamage+". "
   +"\n"+d+defDiceString+"... Units lost: "+defenderTileDamage+". ";
         
   return results;
}

String fightingPlayers(String who){
  String a=playerNames[attacker];
  String d=playerNames[defender];
  String v="attacks";
  switch(who){
    case "attacker": a="YOU"; break;
    case "defender": d="YOU"; break;
  }
  return territoryNames[attackingCountry]+" ("+a+") "+v+" "+territoryNames[attackTarget]+" ("+d+"). ";
}