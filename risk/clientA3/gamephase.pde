int buttonx1=410;
int buttonx2=490;
int buttonx3=570;
int buttonx4=650;
int buttonx5=730;
int buttonx6=810;
int buttony=657;
// button script:
// if( button(415,640,"test",20,color(#FFFFFF),color(#000000), true) ){println("button click");}

void runGamePhase(){
 
  drawTroops();
  
  // ********* IF THIS IS IS PLAYER'S TURN
 if(isTurnToPlay){
   
  switch(turnPhase){
    
    // ********************* COMBO PLACEMENT PHASE **********
    case "combo placement":  
      
      infoRect("Select a combo from the list.");
      // display combo list
      StringList combos = getAvailableCombos();
      String combostring = "";
      for(int i=0; i<combos.size(); i++){
       
        int x = (i%4)*185;
        int y= floor(i/4) * 30;
       if( button(410 + x,height-145 + y,combos.get(i),14,color(#FFFFFF),color(#000000), false ) ){
        selectCombo(combos,i); 
       }
      }
      
      
     // textSize(15);
     // textLeading(15);
     // text("\n"+combostring,410,height-105,600,120);
      
      // Combo placement phase controls: 
      // - Press r to return to reinforcement phase
      if( button(720,height-175,"Go Back",18,color(#FFFFFF),color(#000000), false ) ){
        turnPhase = "reinforcement phase";
      }
      // - Press number keys to select a combo
          
     break; 
    
    // *************** ******** REINFORCEMENT PHASE **************
    case "reinforcement phase":
      
      // display instructions:
      String combotxt = "\n                                        You can play a combo now if you have one available.";
      if(comboPlaced) combotxt="\nYou can't place any more combos this turn (max 1)";
      if(placeableTroops>0){
        infoRect(
        "Your turn. \n"+placeableTroops+ " dudes left."
        +"\nLEFT-CLICK on a country to add, RIGHT-CLICK to remove."
        +"\nStart Turn when ready."
        + combotxt
      ); 
        flashyText("PLACE DUDES!", 510,height-155,20,#333333,#ffcc00,true);
      }
      else {
        infoRect(
        "Your turn. \nPress start when ready\n\n"
        + combotxt
      ); 
      }
      
      
      
      // Reinforcement phase controls:
      
      // - press button to start combo placement phase
      if( button(buttonx2+50,buttony,"Combos",20,color(#FFFFFF),color(#000000), false) ) turnPhase="combo placement";
      //if(enterPressed()&&!comboPlaced) 
      // - press button to start CHOICE PHASE
      if( button(buttonx1,buttony,"Start Turn",20,color(#FFFFFF),color(#000000), false) ) turnPhase="choice phase";
      // - click to add/remove units
      addRemoveTroopsOnClick(3); 

    break;
    
    // ************************** CHOICE PHASE *********************
    case "choice phase": 
    
    // press button at any time during choice phase to end turn.
    if( button(buttonx6,buttony,"End Turn",20,color(#FFFFFF),color(#000000), false) ) c.write("turnisover\n"); 
    
    // setup end text
    String endtxt = "\nPRESS E to end turn (+ tactical move) (can't undo).";
    if(conqueredSomething) endtxt = "\nPRESS E to draw a card and end you turn (+ tactical move)";
    else endtxt += "\nYou must conquer at least 1 territory to draw a card";
    
    // attacking country not yet selected
    if(attackingCountry==-1){
      // display instructions
      infoRect( "battle phase.\nCLICK to select a country to attack from." +endtxt );
      // select attacking country
      
       if(hasClicked&&mouseButton==LEFT&&!drawing&&!buttonclicked){
        int tile = getTile();
        if(tile!=-1){
          // select if tile is owned by user and has more than 1 unit
          if(isUserTile(tile)&&troopsOnTile[tile]>1){
           attackingCountry = tile;
           released = false;
          }
        }
      }
      
      
    }
    
    // if attacking country is chosen
    else if(attackTarget==-1){
      
      // display instructions
      int atkdice = getAvailableDice("attacking");
      infoRect(
      "Attacking country: "+territoryNames[attackingCountry]
      +". /nSelect neighbour to attack, or another country to attack with."
      +"\n"+atkdice+" dice available."
      );
      
      // Controls:
      // press button to go back to selecting attacking country
     if( button(buttonx2,buttony,"Cancel Selection",20,color(#FFFFFF),color(#000000), false) ) cancelCountrySelection();
     
     // select country to attack
      if(hasClicked&&mouseButton==LEFT&&!drawing&&!buttonclicked){
      int tile = getTile();
      if(tile!=-1){
       // released = false;
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
        "Attacking country: "+territoryNames[attackTarget]+". "+atkdice+" dice available. "
        +"\nDefending country: "+territoryNames[attackingCountry]+". "+defdice+" dice available. "
        +"\n\nStart fight?"
      );
      
      // controls:
      // press button to go back to selecting country to attack
      if( button(buttonx2,buttony,"Cancel Selection",20,color(#FFFFFF),color(#000000), false) ) cancelCountrySelection();
      // press enter to start fight
      if( button(buttonx1,buttony,"Start",20,color(#FFFFFF),color(#000000), true) ){
        // ready to attack
        //setTileColor(clientId,attackingCountry);
        //setTileColor(getTileOwner(attackTarget),attackTarget);
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
      if( button(buttonx1,buttony,"Confirm Selection",20,color(#FFFFFF),color(#000000), false) ){
        if(tacticalMoveFrom!=-1&&tacticalMoveTo!=-1&&!tacticalTargetConfirmed){
       tacticalTargetConfirmed=true;
       delay(100);
     } 
      }
     
     // - press B to end tactical phase (trigger next turn)
     if( button(buttonx6,buttony,"End Turn",20,color(#FFFFFF),color(#000000), false) &&!choiceMade){
       choiceMade = true;
       c.write("tacticalphaseover\n");
     }
     
     // - press r to go back a step
     if( button(buttonx2,buttony,"Cancel Selection",20,color(#FFFFFF),color(#000000), false) ){
       if(tacticalTargetConfirmed) tacticalTargetConfirmed=false;
       else if(tacticalMoveTo!=-1) tacticalMoveTo=-1;
       else if(tacticalMoveFrom!=-1) tacticalMoveFrom=-1;
     }
     
     // once tactical targets are confirmed,
     // - left/right click to add/remove troops
     if(tacticalTargetConfirmed){
       if(hasClicked&&!choiceMade&&!drawing&&!buttonclicked){
         choiceMade = true;
        if(mouseButton==LEFT&&!buttonclicked){
          delay(5);
          c.write("tacticaladd "+tacticalMoveFrom+" "+tacticalMoveTo+"\n");
        }
        else if(mouseButton==RIGHT&&!buttonclicked){
          delay(5);
          c.write("tacticalremove "+tacticalMoveFrom+" "+tacticalMoveTo+"\n");
        }
       }
     }
     // if tactical targets not yet selected, 
     // select targets on mouse press
     else {
       
    if(hasClicked&&!drawing&&!buttonclicked){
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
         "Attacking "+territoryNames[attackTarget]+" ("+playerNames[defender]+") from "+territoryNames[attackingCountry]+". "
         + "\nYou have "+availableDice+" dice available. Defender has "+defDice+"."
         );
         
         flashyText("Select how may dice to use.",410,height-100,20,#000000,#ff4444,true);
         
         // Attacker's dice choice controls (press 1, 2 or 3)
         displayDiceChoiceButtons();
         
       }
       
       // (ATK BATTLE PHASE) DEFENDER DICE CHOICE PHASE
       // attacker waits while defender choses his dice.
       else if(battlePhase=="defenderchoice"){
          
         // display instructions 
         infoRect(
         "Attacking "+territoryNames[attackTarget]+" ("+playerNames[defender]+") from "+territoryNames[attackingCountry]+". "
         +"\nDefender is chosing his dice."
         );
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
         if( button(buttonx1,buttony,"Exit battle",20,color(#FFFFFF),color(#000000), false) )
         returnToChoicePhase();
         // press enter to continue battle
         if(canContinue){
           if( button(buttonx2,buttony,"Continue",20,color(#FFFFFF),color(#000000), false) )
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
          
          // press r to return to choice phase
          if( button(buttonx1,buttony,"Confirm placement",20,color(#FFFFFF),color(#000000), false) ) returnToChoicePhase();
          
          // controls
          // click to add/remove troops on belligerent tiles
          if(hasClicked&&!choiceMade&&!drawing&&!buttonclicked&&released){
            released = false;
           if(mouseButton==LEFT){
            choiceMade = true;
            c.write("moretroops\n");
           }
          else if(mouseButton==RIGHT){
            choiceMade= true;
            c.write("lesstroops\n");
           }
          }
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
         
         // controls:
         displayDiceChoiceButtons();
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