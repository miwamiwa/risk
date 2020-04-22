void dataIn(){
  
  if(match(sdata[0],"drawit")!=null){
    stroke(0);
    line(data[1], data[2], data[3], data[4]); 
  }
  
  else if(match(sdata[0],"flagupdate")!=null){
   // int player = int( sdata
   flags[data[1]]=sdata[2];
  // println("flagupdate : "+sdata[2]);
  
   drawFlagString( sdata[2],data[1] );
  }
  
  // reset choiceMade 
  choiceMade = false;
  
  // WHILE GAME NOT YET STARTED 
  if(gamePhase=="pending"){
    
     // RECEIVE PLAYER ID
  if(data[0]==1&&!joined){
   joined=true; 
   clientId = data[1];
  }
  
   // RECEIVE TERRITORY DISTRIBUTION
  if(match(sdata[0],"gameload")!=null){
    tileInfoPending = true;
    initGame();
   }
  }
  
  // WHILE GAME IS RUNNING
  
  // (PRE GAME) TROOP ASSIGNMENT PHASE
  else if(gamePhase=="initial troop assignment"){
    
    // (PRE GAME) UPDATE NUMBER OF TROOPS ON GIVEN TILE
   if(match(sdata[0],"troops")!=null){
     updateReinforcementsFromServer();
   }
   // (PRE GAME) END TROOP ASSIGNMENT PHASE
   else if(match(sdata[0],"gamestart")!=null){
     gamePhase = "game";
     placeableTroops = 0;
   }
  }
  
  
  // GAME PHASE 
  else if(gamePhase=="game"){
    
    // (GAME PHASE) TRIGGER NEW TURN 
    if(match(sdata[0],"turnstart")!=null){
      turnStart(data[1]);
    }
    
        // RECEIVE COMBO AMOUNT
    else if(match(sdata[0],"comboamount")!=null){
      if(turnPhase=="combo placement"&&!comboPlaced){
        // award placeable troops if player is in combo phase
        placeableTroops+=data[1];
        comboPlaced = true;
        turnPhase="reinforcement phase";
      }
      // update combo marker for all players
      comboMarker++;
    }
    
    // REINFORCE TROOPS ON TURN START
    else if(match(sdata[0],"troops")!=null){
      updateReinforcementsFromServer();
    }
    
    
    // START CHOICE PHASE (REINFORCE TROOPS OVER)
    else if(match(sdata[0],"choicephasestart")!=null){
      turnPhase="choice phase";
      attackingCountry=-1;
      attackTarget = -1;
      playerReady = false;
      readyTxt = "READY";
    }
    
     // START BATTLE (TRIGGER ATTACKER'S CHOICE PHASE)
    else if(match(sdata[0],"battlestart")!=null){
      // start first battle phase
      battlePhase="attackerchoice";
      // define attacker, defender, and countries involved.
      attackingCountry = data[1];
      attackTarget = data[2];
      attacker = getTileOwner( data[1] );
      defender = getTileOwner( data[2] );
      // start the right TURNPHASE
      if(isUserTile(data[1])) startAttackPhase();
      else if(isUserTile(data[2])) startDefensePhase();
      else turnPhase="viewbattle phase";
    }
    
    // GOT ATTACKER'S CHOICE (TRIGGER DEFENDER'S CHOICE PHASE)
    else if(match(sdata[0],"attackdice")!=null){
      attackingDice = data[1];
      battlePhase="defenderchoice";
      // define defender's available dice
      if(turnPhase=="defense phase") availableDice = getAvailableDice("defending");
    }
    
    // GOT BATTLE RESULT
    else if(match(sdata[0],"battleresult")!=null){
     
      // unpack battle results
      int[] atkDiceList = new int[ 3 ];
      int[] defDiceList = new int[ 3 ];
      int atkNum = data[1];
      int defNum = data[2];
      for(int i=0;i<3; i++){
        if(i<atkNum) lastAttackRoll[i] = data[3+i];
        else lastAttackRoll[i]=-1;
        if(i<defNum) lastDefenseRoll[i] = data[3+atkNum+i];
        else lastDefenseRoll[i]=-1;
      }
      int dmgI = atkNum+defNum+3;
      // define and apply damage to each tile.
      attackerTileDamage = data[dmgI];
      defenderTileDamage = data[dmgI+1];
      troopsOnTile[ attackingCountry ] -= attackerTileDamage;
      troopsOnTile[ attackTarget ] -= defenderTileDamage;
      
      // trigger result phase
      battlePhase = "result phase";
      
      // check if attacker has won
      if(troopsOnTile[attackTarget]>0){
        // if not, check if fight can continue
        if(troopsOnTile[attackingCountry]>1) canContinue = true;
        else canContinue = false;
      } 
      // if attacker has won:
      else {
         // trigger conquer phase
         battlePhase="conquer phase";
         // card awarded
         conqueredSomething = true;
         c.write("conquest\n");
         // update troops on tile
         troopsOnTile[attackingCountry]--;
         troopsOnTile[attackTarget]=1;
         // update tile color
         loadPixels();
         setTileColor( attacker, attackTarget );
         updatePixels();
         // update player territories arrays
         int index =-1;
         for(int i=0; i<playerTiles[defender].size(); i++){
          if(playerTiles[defender].get(i)==attackTarget) index=i;
         }
         
         playerTiles[defender].remove(index);
         playerTiles[attacker].append(attackTarget);
      }
    }
    
    
    // TRIGGER RETURN TO CHOICE MODE (AFTER FIGHT OR TO FINISH TROOP MOVE ON CONQUEST)
    else if(match(sdata[0],"backtochoice")!=null){
      turnPhase="choice phase";
    }
    
    // ADD TROOPS ON CONQUEST
    else if(match(sdata[0],"addtonewtile")!=null){
      troopsOnTile[attackingCountry]--;
      troopsOnTile[attackTarget]++;
    }
    
    // REMOVE TROOPS ON CONQUEST
    else if(match(sdata[0],"removefromnewtile")!=null){
      troopsOnTile[attackingCountry]++;
      troopsOnTile[attackTarget]--;
    }
    

    
    // TRIGGER TACTICAL MOVE PHASE
    else if(match(sdata[0],"tacticalmove")!=null){
     turnPhase="tactical move phase";
     tacticalMoveFrom =-1;
     tacticalTargetConfirmed = false;
     tacticalMoveTo =-1;
    }
    
        // UPDATE TROOPS ON TACTICAL MOVE TILES
    else if(match(sdata[0],"tacticalchange")!=null){
      troopsOnTile[data[1]]=data[2];
      troopsOnTile[data[3]]=data[4];
    }
    
    
  }
}