// 2A: Shared drawing canvas (Server)

import processing.net.*;
StringList players = new StringList();
Server s; 
Client c;
int[] comboValues = {
  2,4,7,10,13,17,21,25,30
};
int whoseTurn = 0;
int comboMarker = 0;
String input;
int data[];
String[] sdata;
boolean gameStarted = false;
String gamePhase="pending";
int numberOfPlayers = 3;
int totalTiles=42;
int tilesPerPlayer=14;
int[] troopsOnTile = new int[42];
String turnPhase = "";
String battlePhase = "";
int[] troopsOnTurnStart = new int[42];
boolean troopsPlaced = false;
boolean cardAwarded = false;
int cardType =0;

int attackerDicePick =0;
int defenderDicePick =0;

int attackingCountry=0;
int defendingCountry=0;
int attacker =0;
int defender =0;
IntList deck = new IntList();
boolean player1InitDone = false;
boolean player2InitDone = true;
boolean player3InitDone = true;

int[] placeableTroops = {21,21,21};
IntList[] playerTiles = {
  new IntList(),
  new IntList(),
  new IntList()
};


IntList[] playerCards = {
 new IntList(),
 new IntList(),
 new IntList()
};

IntList turnOrder = new IntList();
int turn =0;

// setup()
//
// called on app start 

void setup() { 
  
  deck = newDeck();
  
  size(450, 255);
  background(204);
  stroke(0);
  frameRate(10); // Slow it down a little
  s = new Server(this, 12345);  // Start a simple server on a port
} 

// draw()
//
// main loop 

void draw() { 
  
 if(!gameStarted) checkForEveryoneAndStart();
 else if(gamePhase =="initial troop assignment"){
         if(player1InitDone&&player2InitDone&&player3InitDone){
            troopPlacementIsDone();
           }
          }
 
  // Receive data from client
  c = s.available();
  if (c != null) {
    input = c.readString(); 
    input = input.substring(0, input.indexOf("\n"));  // Only up to the newline
    data = int(split(input, ' ')); // number array
    sdata = splitTokens(input); // text array
    dataIn();// do stuff with data input
  }
}


// checkforeveryoneandstart()
//
// wait for all the players to show up then start the game

void checkForEveryoneAndStart(){
  if(players.size()==2){
    
    players.append("playertwoooo");
    players.append("playerhreet");
   gameStarted = true; 
   gamePhase="initial troop assignment";
   println("gameload");
   s.write("gameload "+players.get(0)+" "+players.get(1)+" "+players.get(2)+" ");
   assignTiles();
 } 
}

// troopplacementisdone()
//
// determine order and start the first turn

void troopPlacementIsDone(){
  
 gamePhase="game";
  
  placeableTroops[0] =0;
  placeableTroops[1] =0;
  placeableTroops[2] =0;
   
  turnOrder.append(0);
  turnOrder.append(1);
  turnOrder.append(2);
  turnOrder.shuffle();

  s.write("gamestart\n");
  setupTurn(0,-1); // CHANGE THIS LATER PLS PLS
}

void dataIn(){
  
  if(!gameStarted){
     if(match(sdata[0],"joined")!=null){
   players.append( sdata[1] );
   int index = players.size()-1;
   s.write( "1 "+index+"\n");
   println("newplayer "+index+"\n");
   }
  }
  
  else {
    
    if(gamePhase=="initial troop assignment"||(gamePhase=="game"&&turnPhase=="troop placement phase")){
     
      if(match(sdata[0],"comborequest")!=null){
        delay(1);
        placeableTroops[whoseTurn]+=comboValues[comboMarker];
        s.write("comboamount "+comboValues[comboMarker]+"\n");
        comboMarker= (comboMarker+1)%comboValues.length;
      
      }
      if(data[0]==3){  // troop placement at start of a turn
        if(data[1]==0){
         if(troopsOnTile[data[2]]>troopsOnTurnStart[data[2]]){
           troopsOnTile[data[2]]--;
           placeableTroops[data[3]]++;
           s.write("troops "+data[2]+" "+troopsOnTile[data[2]]+"\n");
         }
         
       }
       else if(data[1]==1){
         if(placeableTroops[data[3]]>0){
           troopsOnTile[data[2]]++;
           placeableTroops[data[3]]--;
           s.write("troops "+data[2]+" "+troopsOnTile[data[2]]+"\n");
         }
         
       }
       else if(data[1]==2){
         troopsPlaced = true;
         delay(100);
         s.write("choicephasestart\n");
         turnPhase="choice phase";
       }
      }
      
      if(data[0]==2){ // data relevant to initial troop assign phase 
      //println("YO");
        if(data[1]==0){
         if(troopsOnTile[data[2]]>1){
           troopsOnTile[data[2]]--;
           placeableTroops[data[3]]++;
           s.write("troops "+data[2]+" "+troopsOnTile[data[2]]+"\n");
         }
         
       }
       else if(data[1]==1){
         if(placeableTroops[data[3]]>0){
           troopsOnTile[data[2]]++;
           placeableTroops[data[3]]--;
           s.write("troops "+data[2]+" "+troopsOnTile[data[2]]+"\n");
         }
         
       }
       else if(data[1]==2){
         switch(data[2]){
           case 0: player1InitDone = true; println("done"); break;
           case 1: player2InitDone = true; break;
           case 2: player3InitDone = true; break;
         }
       }
       else if(data[1]==3){
         switch(data[2]){
           case 0: player1InitDone = false; break;
           case 1: player2InitDone = false; break;
           case 2: player3InitDone = false; break;
         }
       }
        
      }
       
    }
    else if(gamePhase=="game"){
      
      if(match(sdata[0],"turnisover")!=null){
        
        delay(10);
        s.write("tacticalmove\n");
  
      }
      if(match(sdata[0],"tacticalphaseover")!=null){
        
        delay(10);
        // CHANGE THIS LATER
       setupTurn(1,0);
      }
      
      if(match(sdata[0],"tacticaladd")!=null){
        if(troopsOnTile[data[1]]>1){
         troopsOnTile[data[1]]--;
         troopsOnTile[data[2]]++;
         s.write("tacticalchange "+data[1]+" "+troopsOnTile[data[1]]+" "+data[2]+" "+troopsOnTile[data[2]]+"\n");
        }  
     }
       
       if(match(sdata[0],"tacticalremove")!=null){
         if(troopsOnTile[data[2]]>1){
         troopsOnTile[data[1]]++;
         troopsOnTile[data[2]]--;
         s.write("tacticalchange "+data[1]+" "+troopsOnTile[data[1]]+" "+data[2]+" "+troopsOnTile[data[2]]+"\n");
         }  
     }
      
     if(turnPhase=="choice phase"){
       if(data[0]==4){
        turnPhase="battle phase"; 
        battlePhase="attackerchoice";
        attackingCountry = data[1];
        defendingCountry = data[2];
        attacker = getTileOwner(data[1]);
        defender = getTileOwner(data[2]);
        s.write("battlestart "+data[1]+" "+data[2]+"\n");
       }
     }
     else if(turnPhase=="battle phase"){
       
       if(match(sdata[0],"returntochoicephase")!=null){
         turnPhase="choice phase";
         s.write("backtochoice\n");
       }
       
       if(match(sdata[0],"continuebattle")!=null){
         turnPhase="battle phase";
         battlePhase="attackerchoice";
         s.write("battlestart "+attackingCountry+" "+defendingCountry+"\n");
       }
       
       
       
       if(battlePhase=="attackerchoice"){
         
         if(match(sdata[0],"dicepick")!=null){
           attackerDicePick = data[2];
           s.write("attackdice "+data[2]+"\n");
           battlePhase="defenderchoice";
         }
       }
       
       else if(battlePhase=="defenderchoice"){
         
         if(match(sdata[0],"dicepick")!=null){
           
           defenderDicePick = data[2];
           String resultmessage = "battleresult ";
           
           // ROLL DICE
           IntList attackRolls = new IntList();
           IntList defenseRolls = new IntList();
           
           resultmessage += attackerDicePick+" ";
           resultmessage += defenderDicePick+" ";
           
           for(int i=0; i<attackerDicePick; i++){
             int roll = diceRoll();
            attackRolls.append( roll ); 
            resultmessage += roll+" ";
           }
           
           for(int i=0; i<defenderDicePick; i++){
             int roll = diceRoll();
            defenseRolls.append( roll ); 
            resultmessage += roll+" ";
           }
           
           // GET RESULTS
           int highAttack = getHighestRoll(attackRolls);
           int highDefense = getHighestRoll(defenseRolls);
           
           int attackingTileDamage =0;
           int defendingTileDamage =0;
            
            if(highAttack>highDefense) defendingTileDamage+=1;
            else attackingTileDamage+=1;
             
           if(defenderDicePick==2){
             int secondHighAttack = getSecondHighestRoll(attackRolls,highAttack);
             int secondHighDefense = getSecondHighestRoll(defenseRolls,highDefense);
            if(secondHighAttack>secondHighDefense) defendingTileDamage+=1;
            else attackingTileDamage+=1;
           }
           
           resultmessage += attackingTileDamage+" "+defendingTileDamage+"\n";
           if(troopsOnTile[defendingCountry] - defendingTileDamage>=0){
            cardAwarded = true; 
           }
           s.write(resultmessage);
           println(resultmessage);
           // resultmessage structure: 
             //battleresult 
             //atkDiceNum 
             //defDiceNum 
             //atkDiceList (1-3items, length=atkDiceNum) 
             //defkDiceList (1-2items, length=defDiceNum) 
             //atkTileDamageTaken 
             //defTileDamageTaken
          
           battlePhase="result phase";
         }
       }
       else if(battlePhase=="result phase"){
         if(match(sdata[0],"conquest")!=null){
          battlePhase="conquest phase"; 
          troopsOnTile[attackingCountry]--;
         troopsOnTile[defendingCountry]=1;
         
         int index =-1;
         for(int i=0; i<playerTiles[defender].size(); i++){
          if(playerTiles[defender].get(i)==defendingCountry) index=i;
         }
         
         playerTiles[defender].remove(index);
         playerTiles[attacker].append(defendingCountry);
         }
       }
       else if(battlePhase=="conquest phase"){
         
         if(match(sdata[0],"moretroops")!=null){
           if(troopsOnTile[attackingCountry]>1){
            troopsOnTile[attackingCountry]--;
            troopsOnTile[defendingCountry]++;
            s.write("addtonewtile\n");
           }
         }
         else if(match(sdata[0],"lesstroops")!=null){
           if(troopsOnTile[defendingCountry]>1){
             troopsOnTile[attackingCountry]++;
            troopsOnTile[defendingCountry]--;
             s.write("removefromnewtile\n");
           }
         }
       }
     }
    }
  }
}

int getHighestRoll( IntList rolls){
  int highest =0;
    for(int i=0; i<rolls.size(); i++){
      int val = rolls.get(i);
      if( val>highest ) highest = val;
    }
  return highest;
}

int getSecondHighestRoll( IntList rolls, int highest){
 int secondHighest =0;
 boolean valIgnored = false;
 for(int i=0; i<rolls.size(); i++){
  int val=rolls.get(i);
  
  if(val==highest&&!valIgnored) valIgnored = true;
  else secondHighest = val;
  
 }
  return secondHighest;
}


//diceRoll()
//
// returns a number from 1 to 6
int diceRoll(){
 int result=ceil(random(6));
 return result;
}



void setupTurn( int player,int lastPlayer ){
  
  
  whoseTurn=player;
  int cardPick = -1;
  String cardString = " 0";
  if(lastPlayer!=-1){
    cardPick = pickACard();
    if(cardPick!=-1){
     addCard(lastPlayer,cardPick); 
     cardString = " 1 "+lastPlayer+" "+cardPick;
    }
  }
  cardAwarded = false;
  
  
  turnPhase = "troop placement phase";
  int reinforcements = getBaseReinforcements(player)+getContinentsBonus(player);
  placeableTroops[player] = reinforcements;
  troopsPlaced = false;
  for(int i=0; i<42; i++){
   troopsOnTurnStart[i] = troopsOnTile[i]; 
  }
 // s.write
 delay(1000);
 println("start turn");
 s.write("turnstart "+player+" "+placeableTroops[player]+cardString+"\n");
}

int getBaseReinforcements(int player){
 int reinforcements =0;
 int territories=0;
  territories = playerTiles[player].size();

 reinforcements = floor(territories/3);
 return reinforcements;
}



void addCard(int player, int card){
  playerCards[player].append(card);
}


int getContinentsBonus(int player){
  int continentBonus =0;
 IntList countries = new IntList();
 countries=playerTiles[player]; 

 
 if(
 countries.hasValue(0)
 && countries.hasValue(1)
 && countries.hasValue(2)
 && countries.hasValue(3)
 && countries.hasValue(4)
 && countries.hasValue(5)
 && countries.hasValue(6)
 && countries.hasValue(7)
 && countries.hasValue(8)
 ) continentBonus +=5; // has North America
 
 if(
 countries.hasValue(9)
 && countries.hasValue(10)
 && countries.hasValue(11)
 && countries.hasValue(12)
 ) continentBonus +=2; // has South America
 
  if(
 countries.hasValue(13)
 && countries.hasValue(14)
 && countries.hasValue(15)
 && countries.hasValue(16)
 && countries.hasValue(17)
 && countries.hasValue(18)
 ) continentBonus +=3; // has Africa
 
 if(
 countries.hasValue(19)
 && countries.hasValue(20)
&& countries.hasValue(21)
&& countries.hasValue(22)
&& countries.hasValue(23)
&& countries.hasValue(24)
&& countries.hasValue(25)
 ) continentBonus +=5; // has Europe
 
  if(
 countries.hasValue(26)
 && countries.hasValue(27)
&& countries.hasValue(28)
&& countries.hasValue(29)
&& countries.hasValue(30)
&& countries.hasValue(31)
&& countries.hasValue(32)
&& countries.hasValue(33)
&& countries.hasValue(34)
&& countries.hasValue(35)
&& countries.hasValue(36)
&& countries.hasValue(37)
 ) continentBonus +=7; // has Asia
 
  if(
 countries.hasValue(38)
 && countries.hasValue(39)
&& countries.hasValue(40)
&& countries.hasValue(41)
 ) continentBonus +=5; // has Oceania
 
 
 return continentBonus;
}

void assignTiles(){
  
  // initializa troops on each tile
  for(int i=0; i<42; i++){
   troopsOnTile[i] = 1; 
  }
  
  // assign random tiles to each player 
  IntList assignments = new IntList();
  for(int i=0; i<42; i++){
   assignments.append( i ); 
  }
 // int shuffleseed=3;
//  for(int i=0; i<shuffleseed; i++){
     assignments.shuffle();
//  }
 
  println(assignments);
  String assignmentstring = "";
   for(int i=0; i<assignments.size(); i++){
     assignmentstring += str(assignments.get(i))+" ";
  }
  assignmentstring=assignmentstring.trim();
  assignmentstring+="\n";
  s.write(assignmentstring);
  
  for(int i=0; i<tilesPerPlayer*3; i+=3){
    int tile1 = assignments.get(i);
    int tile2 = assignments.get(i+1);
    int tile3 = assignments.get(i+2);
    playerTiles[0].append( tile1 );
    playerTiles[1].append( tile2 );
    playerTiles[2].append( tile3 );

  }
}



IntList newDeck(){
 IntList result = new IntList();
 for(int i=0; i<14; i++){
  result.append(0); // infantry
 }
 
 for(int i=0; i<14; i++){
  result.append(1); // horse
 }
 
 for(int i=0; i<14; i++){
  result.append(2); // canon
 }
 
 for(int i=0; i<2; i++){
  result.append(3); // wildcard
 }
 
 result.shuffle();
 return result;
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

int getTileOwner(int tile){
 int result = -1;
 if(playerTiles[0].hasValue(tile)) result =0;
 else if(playerTiles[1].hasValue(tile)) result =1;
 else if(playerTiles[2].hasValue(tile)) result =2;
 return result;
}