
void dataIn(){
  
  if(!gameStarted){
     if(match(sdata[0],"joined")!=null){
   players.append( sdata[1] );
   int index = players.size()-1;
   s.write( "1 "+index+"\n");
   delay(10);
   println("newplayer "+index+"\n");
   }
  }
  
  else {
    
    if(gamePhase=="initial troop assignment"){
      
       //  ********************** INITIAL TROOP PLACEMENT / MAP SETUP *************************
      if(data[0]==2){ 
        // REMOVE UNITS
        if(data[1]==0){
         if(troopsOnTile[data[2]]>1){
           troopsOnTile[data[2]]--;
           placeableTroops[data[3]]++;
           s.write("troops "+data[2]+" "+troopsOnTile[data[2]]+"\n");
         }
       }
       // ADD UNITS
       else if(data[1]==1){
         if(placeableTroops[data[3]]>0){
           troopsOnTile[data[2]]++;
           placeableTroops[data[3]]--;
           s.write("troops "+data[2]+" "+troopsOnTile[data[2]]+"\n");
         }
       }
       // SIGNAL PLAYER READY
       else if(data[1]==2){
         switch(data[2]){
           case 0: player1InitDone = true; println("done"); break;
           case 1: player2InitDone = true; break;
           case 2: player3InitDone = true; break;
         }
       }
       // SIGNAL PLAYER NOT READY
       else if(data[1]==3){
         switch(data[2]){
           case 0: player1InitDone = false; break;
           case 1: player2InitDone = false; break;
           case 2: player3InitDone = false; break;
         }
        }
       }
      }
      

   
   // (the game)
    else if(gamePhase=="game"){
      
     
     //******************  TROOP PLACEMENT PHASE (ON TURN START) *************
    if(turnPhase=="troop placement phase"){
     
      // COMBO REQUEST 
      if(match(sdata[0],"comborequest")!=null){
        delay(1);
        placeableTroops[whoseTurn]+=comboValues[comboMarker];
        // answer combo amount
        s.write("comboamount "+comboValues[comboMarker]+"\n");
        comboMarker= (comboMarker+1)%comboValues.length;
      }
      
      // TROOP PLACEMENT 
      if(data[0]==3){
        
        // REMOVE UNITS
        if(data[1]==0){
         if(troopsOnTile[data[2]]>troopsOnTurnStart[data[2]]){
           troopsOnTile[data[2]]--;
           placeableTroops[data[3]]++;
           s.write("troops "+data[2]+" "+troopsOnTile[data[2]]+"\n");
         }
       }
       // ADD UNITS
       else if(data[1]==1){
         if(placeableTroops[data[3]]>0){
           troopsOnTile[data[2]]++;
           placeableTroops[data[3]]--;
           s.write("troops "+data[2]+" "+troopsOnTile[data[2]]+"\n");
         }
       }
       // R FOR READY
       if(data[1]==2){
         troopsPlaced = true;
         delay(100);
         s.write("choicephasestart\n");
         turnPhase="choice phase";
       }
     }
   }
   
   
   
      // ******************* CHOICE PHASE ****************************
     if(turnPhase=="choice phase"){
       
       // BATTLE START TRIGGER
       if(data[0]==4){
        turnPhase="battle phase"; 
        battlePhase="attackerchoice";
        attackingCountry = data[1];
        defendingCountry = data[2];
        attacker = getTileOwner(data[1]);
        defender = getTileOwner(data[2]);
        s.write("battlestart "+data[1]+" "+data[2]+"\n");
       }
       
       
     } //  choice phase end.
     
     
     
     //**************************  BATTLE PHASE  *******************************
     else if(turnPhase=="battle phase"){
       
       // (BATTLE PHASE) RETURN TO CHOICE PHASE
       if(match(sdata[0],"returntochoicephase")!=null){
         turnPhase="choice phase";
         s.write("backtochoice\n");
       }
       
       // (BATTLE PHASE) PRESS ENTER TO CONTINUE BATTLE
       if(match(sdata[0],"continuebattle")!=null){
         turnPhase="battle phase";
         battlePhase="attackerchoice";
         s.write("battlestart "+attackingCountry+" "+defendingCountry+"\n");
       }
        
       // (BATTLE PHASE) DURING ATTACKER'S CHOICE PHASE
       if(battlePhase=="attackerchoice"){
         
         // ATTACKER PICKED A NUMBER OF DICE
         if(match(sdata[0],"dicepick")!=null){
           attackerDicePick = data[2];
           s.write("attackdice "+data[2]+"\n");
           battlePhase="defenderchoice";
         }
       }
       
       // (BATTLE PHASE) DURING DEFENDER'S CHOICE PHASE 
       else if(battlePhase=="defenderchoice"){
         
         // DEFENDER PICKED A NUMBER OF DICE
         if(match(sdata[0],"dicepick")!=null){
           defenderDicePick = data[2];
           // START DICE BATTLE
           diceBattle();
           battlePhase="result phase";
         }
       }
       
       // (BATTLE PHASE) DURING RESULT PHASE
       else if(battlePhase=="result phase"){
         
         // IF TERRITORY CONQUERED 
         if(match(sdata[0],"conquest")!=null){
          
          battlePhase="conquest phase"; 
          // update troops
          troopsOnTile[attackingCountry]--;
          troopsOnTile[defendingCountry]=1;
         // update player tile list
          int index =-1;
         for(int i=0; i<playerTiles[defender].size(); i++){
          if(playerTiles[defender].get(i)==defendingCountry) index=i;
         }
         playerTiles[defender].remove(index);
         playerTiles[attacker].append(defendingCountry);
         }
       }
       
       // (BATTLE PHASE) CONQUEST PHASE (TROOP PLACEMENT)
       else if(battlePhase=="conquest phase"){
         
         // ADD TROOPS (upon conquest)
         if(match(sdata[0],"moretroops")!=null){
           if(troopsOnTile[attackingCountry]>1){
            troopsOnTile[attackingCountry]--;
            troopsOnTile[defendingCountry]++;
            s.write("addtonewtile\n");
           }
         }
         
         // REMOVE TROOPS (upon conquest)
         else if(match(sdata[0],"lesstroops")!=null){
           if(troopsOnTile[defendingCountry]>1){
             troopsOnTile[attackingCountry]++;
            troopsOnTile[defendingCountry]--;
             s.write("removefromnewtile\n");
           }
         }
       }
       
       
     } //  battle phase end. 
     
          /// *********************** TACTICAL MOVE *****************************
     
      // TURN IS OVER -> TACTICAL MOVE START
      if(match(sdata[0],"turnisover")!=null){
        delay(10);
        s.write("tacticalmove\n");
       }
      
     
      
      // TACTICAL PHASE: ADD UNITS
      else if(match(sdata[0],"tacticaladd")!=null){
        if(troopsOnTile[data[1]]>1){
         troopsOnTile[data[1]]--;
         troopsOnTile[data[2]]++;
         s.write("tacticalchange "+data[1]+" "+troopsOnTile[data[1]]+" "+data[2]+" "+troopsOnTile[data[2]]+"\n");
        }  
       }
       
       // TACTICAL PHASE: REMOVE UNITS 
       else if(match(sdata[0],"tacticalremove")!=null){
         if(troopsOnTile[data[2]]>1){
         troopsOnTile[data[1]]++;
         troopsOnTile[data[2]]--;
         s.write("tacticalchange "+data[1]+" "+troopsOnTile[data[1]]+" "+data[2]+" "+troopsOnTile[data[2]]+"\n");
         }  
       }
       
       
       // *********************** START NEXT TURN ****************************
        // TACTICAL PHASE OVER -> NEXT TURN START
      else if(match(sdata[0],"tacticalphaseover")!=null){
        delay(10);
        turn=(turn+1)%3;
        setupTurn(turnOrder.get(turn),cardPlayer);
       }
    }
  }
}