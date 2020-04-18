String userName = "cooldesktop";



String cardText = "";

int[] lastAttackRoll = new int[3];
int[] lastDefenseRoll = new int[2];
PImage img;
PImage map;
// 2B: Shared drawing canvas (Client)
int tacticalMoveFrom =-1;
int tacticalMoveTo =-1;
import processing.net.*; 
String[] playerNames = new String[3];
Client c; 
String input;
int data[]; 
String[] sdata;
//boolean canClick = true;
String gamePhase = "pending";
boolean comboPlaced = false;
int lastTacticalMoveTo=-1;
boolean joined = false;
int clientId;
int[] tileassignment = new int[42];
boolean tileInfoPending = false;

int imgSize=1227*628;
int numberOfPlayers = 3;
int totalTiles=42;
int tilesPerPlayer=14;
int troopNumTxtSize = 13;
int placeableTroops = 21;
boolean conqueredSomething = false;
IntList cards = new IntList();
IntList[] playerTiles = {
  new IntList(),
  new IntList(),
  new IntList()
};

boolean hasCombo = false;

color[] teamColors = {
  color( 255,50,50 ),
  color( 50,255,50 ),
  color( 50,50,255 )
};

int[] troopsOnTile = new int[42];

int attackingCountry = -1;
int attackTarget = -1;

int attackingDice=0;
int defendingDice=0;

int availableDice = 0;
int numberOfDiceChosen =0;

boolean isTurnToPlay = false;
String turnPhase = "";
String battlePhase="";
boolean choiceMade = false;
boolean canContinue = false;
int attacker =0;
int defender =0;
boolean tacticalTargetConfirmed =false;
int attackerTileDamage = 0;
int  defenderTileDamage =0;

void setup() { 
  
  size(1227,748);
  img = loadImage("Risk_game_map.png");
  map = loadImage("Risk_game_map.png");
  image(map, 0, 0, width,height-120);
  delay(1000);
  frameRate(10); // Slow it down a little
  // Connect to the server’s IP address and port­
  c = new Client(this, "127.0.0.1", 12345); // Replace with your server’s IP and port
  c.write("joined "+userName+"\n"); // joined
} 

void draw() {         
 
  runGame();
  // Receive data from server
  if (c.available() > 0) { 
    input = c.readString(); 
    input = input.substring(0,input.indexOf("\n"));  // Only up to the newline
    data = int(split(input, ' '));  // Split values into an array
    sdata = splitTokens(input," ");
    println(input);
    dataIn();
  } 
}

void dataIn(){
  //println(dataIn);
  choiceMade = false;
  if(gamePhase=="pending"){
     //received player id on join 
  if(data[0]==1&&!joined){
   joined=true; 
   clientId = data[1];
   println("player id is "+clientId);
  }
  //received signal for game load 
  if(match(sdata[0],"gameload")!=null){
    tileInfoPending = true;
    println("pending");
  }
   // received tile info on game load 
    if(tileInfoPending){
  initGame();
  }
  }
  else if(gamePhase=="initial troop assignment"){
    
   if(match(sdata[0],"troops")!=null){
     updateReinforcementsFromServer();
   }
   else if(match(sdata[0],"gamestart")!=null){
     gamePhase = "game";
     placeableTroops = 0;
   }
  }
  // GAME PHASE SERVER INPUTS 
  else if(gamePhase=="game"){
    
    if(match(sdata[0],"turnstart")!=null){
      turnStart(data[1]);
    }
    
    else if(match(sdata[0],"troops")!=null){
      updateReinforcementsFromServer();
    }
    
    else if(match(sdata[0],"attackphasestart")!=null){
      turnPhase="attack phase";
    }
    
    else if(match(sdata[0],"tacticalchange")!=null){
      troopsOnTile[data[1]]=data[2];
      troopsOnTile[data[3]]=data[4];
    }
    
    else if(match(sdata[0],"choicephasestart")!=null){
      turnPhase="choice phase";
      attackingCountry=-1;
      attackTarget = -1;
      playerReady = false;
      readyTxt = "READY";
    }
    
    else if(match(sdata[0],"battlestart")!=null){
      
      println("battle start");
      battlePhase="attackerchoice";
      attackingCountry = data[1];
      attackTarget = data[2];
      attacker = getTileOwner( data[1] );
      defender = getTileOwner( data[2] );
      
      if(isUserTile(data[1])) startAttackPhase();
      else if(isUserTile(data[2])) startDefensePhase();
      else turnPhase="viewbattle phase";
    }
    
    else if(match(sdata[0],"attackdice")!=null){
      
      attackingDice = data[1];
      battlePhase="defenderchoice";
      println("defender start");
      if(turnPhase=="defense phase") availableDice = getAvailableDice("defending");
    }
    
    else if(match(sdata[0],"battleresult")!=null){
      
      int atkDiceNum = data[1];
      int defDiceNum = data[2];
      
      int[] atkDiceList = new int[ atkDiceNum ];
      int startindex =3;
      int counter=0;
      for(int i=startindex; i<startindex+atkDiceNum; i++){
       atkDiceList[counter]=data[i];
       counter++;
      }
      counter=0;
      startindex+=atkDiceNum;
      int[] defDiceList = new int[ defDiceNum ];
      for(int i=startindex; i<startindex+defDiceNum; i++){
       defDiceList[counter]=data[i];
       counter++;
      }
      
      for(int i=0; i<3; i++){
       if(i<atkDiceList.length) lastAttackRoll[i]=atkDiceList[i];
       else lastAttackRoll[i]=-1;
      }
      
      for(int i=0; i<2; i++){
       if(i<defDiceList.length) lastDefenseRoll[i]=defDiceList[i];
       else lastDefenseRoll[i]=-1;
      }
      
      startindex+=defDiceNum;
      attackerTileDamage = data[startindex];
      defenderTileDamage = data[startindex+1];
      
      troopsOnTile[ attackingCountry ] -= attackerTileDamage;
      troopsOnTile[ attackTarget ] -= defenderTileDamage;
      
      battlePhase = "result phase";
      
      if(troopsOnTile[attackTarget]>0){
        if(troopsOnTile[attackingCountry]>1) canContinue = true;
      else canContinue = false;
      }
      else {
        println("conquest!");
         //territory conquered
         battlePhase="conquer phase";
         conqueredSomething = true;
         c.write("conquest\n");
         troopsOnTile[attackingCountry]--;
         troopsOnTile[attackTarget]=1;
         println("set color: "+teamColors[clientId]);
         println("target: "+attackTarget);
         setTileColor( teamColors[attacker], attackTarget );
         updatePixels();
         int index =-1;
         for(int i=0; i<playerTiles[defender].size(); i++){
          if(playerTiles[defender].get(i)==attackTarget) index=i;
         }
         
         playerTiles[defender].remove(index);
         playerTiles[attacker].append(attackTarget);
      }
      
    }
    
    else if(match(sdata[0],"backtochoice")!=null){
      turnPhase="choice phase";
    }
    
    else if(match(sdata[0],"addtonewtile")!=null){
      troopsOnTile[attackingCountry]--;
      troopsOnTile[attackTarget]++;
    }
    
    else if(match(sdata[0],"removefromnewtile")!=null){
      troopsOnTile[attackingCountry]++;
      troopsOnTile[attackTarget]--;
    }
    else if(match(sdata[0],"comboamount")!=null){
      if(turnPhase=="combo placement"){
        placeableTroops+=data[1];
        turnPhase="reinforcement phase";
      }
    }
    
    else if(match(sdata[0],"tacticalmove")!=null){
     turnPhase="tactical move phase";
     tacticalMoveFrom =-1;
     tacticalTargetConfirmed = false;
     tacticalMoveTo =-1;
    }
  }
}

void runGame(){
  
 if(gamePhase!="pending"){
  
  drawPlayerInfo();
  if(gamePhase=="initial troop assignment") runTroopAssignmentPhase();
  else if(gamePhase=="game"){
   displayCards();
   runGamePhase(); 
  }
 }
}

void updateReinforcementsFromServer(){
  
  int lastnum = troopsOnTile[data[1]];
  //update number of troops
  troopsOnTile[ data[1] ]=data[2];
   
  // if that was your tile, update your number of reinforcements left
   if (isUserTile(data[1])){   
   int diff = troopsOnTile[data[1]]-lastnum;
   placeableTroops -= diff;
   }
}

void turnStart(int input){
  
  turnPhase = "reinforcement phase";
  comboPlaced = false;
  println(input+"'s turn");
  
  if(data[3]==1){
    if(data[4]==clientId)
   getCard(data[5]); 
  }
 if(input==clientId){
  isTurnToPlay = true; 
  placeableTroops= data[2];
 }
 else isTurnToPlay = false;
}



// getcard()
//
// add a card to this player's card list 
void getCard( int card ){
  cards.append(card);
  println("new card "+card);
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
}




void displayCards(){
 fill(245);
 rect(10,10,400,35);
 fill(24);
 textSize(15);
 textLeading(15);
 text("cards: "+cardText,10,10,400,40);
}

void startAttackPhase(){
 turnPhase="attack phase"; 
 availableDice = getAvailableDice("attacking");
 println("attack start");
}

int getAvailableDice(String atkdef){
  int result=0;
  switch(atkdef){
   case "attacking": 
   result = troopsOnTile[attackingCountry]-1;
 if(result>3) result = 3;
   break;
   case "defending":
   result = troopsOnTile[attackTarget];
 if(result>2) result = 2;
   break;
  }
  
  return result;
}

void startDefensePhase(){
 turnPhase="defense phase"; 
// availableDice = getAvailableDice("defending");
println("defense phase!");
}


void pressEtoEndTurn(){
 if(keyPressed&&(key=='e'||key=='E')){
  c.write("turnisover\n"); 
 }
}

void pressKeyToSelectCombo(StringList inputlist){
  if(!comboPlaced&&keyPressed&&!choiceMade&&(key=='0'||key=='1'||key=='2'||key=='3'||key=='4'||key=='5'||key=='6'||key=='7'||key=='8'||key=='9')){
        int thekey =key-48;
    String message = "comborequest\n";
    comboPlaced = true;
    int[] cardlist = int(splitTokens( inputlist.get(thekey),"," ));
    choiceMade = true;
     int[] index = new int[3];
    for(int i=0; i<3; i++){
     
     for(int j=0; j<cards.size(); j++){
      if(cards.get(j)== cardlist[i]){
        index[i]=j;
      }
     }
     
     cards.remove(index[i]);
    }
    
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
    c.write(message);
  }
}

void pressNumToPickDice(char num){
  if(keyPressed&&key==num&&!choiceMade){
    choiceMade = true;
   c.write("dicepick "+clientId+" "+num+"\n"); 
  }
}


void runTroopAssignmentPhase(){
  
   drawTroops(); // refresh troop numbers
   String readystring = "NOT ";
   if(playerReady) readystring = "";
   infoRect(
     "troop placement phase! You have "+placeableTroops+ " dudes left to place."
     +"\nLEFT-CLICK on a country to add, RIGHT-CLICK to remove."
     +"\nPRESS R to say you're ready (PRESS R again to cancel)."
     +"\ngame starts when everyone is ready. you are currently marked as "+readystring+"ready"
   );
   
    pressRforReady(2);
    addRemoveTroopsOnClick(2); 
}

void addRemoveTroopsOnClick(int phase){
 if(mousePressed&&mouseButton==LEFT){
      int tile = getTile();
    //  println("tile "+tile);
      if(tile!=-1){
        if(isUserTile(tile)){
         // println("2 1 "+tile);
         c.write(phase+" 1 "+tile+" "+clientId+"\n"); // 2 means phase 2, 1 means add
       //  setTileColor(color(225),tile);
        // delay(5);
        }
      }
    }
    
    else if(mousePressed&&mouseButton==RIGHT){
      int tile = getTile();
      if(tile!=-1){
        if(isUserTile(tile)){
         // println("2 0 "+tile);
         c.write(phase+" 0 "+tile+" "+clientId+"\n"); // 2 means phase 2, 0 means remove
       //  setTileColor(color(225),tile);
         //delay(5);
        }
      }
    } 
}

boolean playerReady = false;
String readyTxt = "READY";
color buttoncolor = color(120,120,250);

void pressBforBack(){
  if(keyPressed && ( key == 'b' || key == 'B' )){
    if(attackTarget!=-1) attackTarget=-1;
     else attackingCountry = -1;
  }
}

 
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



void infoRect(String input){
  fill(245);
    rect(400,height-180,770,120);
      fill(45);
      textSize(20);
      textLeading(20);
  text(input,410,height-155);
    
}
void drawPlayerInfo(){
  fill(225);
  rect(15,370,200,200);
  textSize(24);
  fill(teamColors[0]);
  text(playerNames[0], 20, 400);
  
  fill(teamColors[1]);
  text(playerNames[1], 20, 450);
  
  fill(teamColors[2]);
  text(playerNames[2], 20, 500); 
  
  textSize(22);
  
  fill(teamColors[0]);
  text("countries: "+playerTiles[0].size(), 20, 425);
  
  fill(teamColors[1]);
  text("countries: "+playerTiles[1].size(), 20, 475);
  
  fill(teamColors[2]);
  text("countries: "+playerTiles[2].size(), 20, 525); 
  

}


void initGame(){
    
  
   for(int i=0; i<42; i++){
   troopsOnTile[i] = 1; 
  }
  
   for(int i=0; i<42; i++){
    tileassignment[i] = data[i+4]; 
   }
   
    loadPixels();
  
  for(int i=0; i<tilesPerPlayer*3; i+=3){
    int tile1 = tileassignment[i];
    int tile2 = tileassignment[i+1];
    int tile3 = tileassignment[i+2];
    playerTiles[0].append( tile1 );
    playerTiles[1].append( tile2 );
    playerTiles[2].append( tile3 );
   setTileColor( teamColors[0], tile1);
   setTileColor( teamColors[1], tile2);
   setTileColor( teamColors[2], tile3);
   //delay(1);
  // println(i);
  }
  
  playerNames[0]= sdata[1];
  playerNames[1] = sdata[2];
  playerNames[2] = sdata[3];
  //println(playerNames);
  
  updatePixels();
  // print("tiles: ");
 //  println(tileassignment);
 gamePhase="initial troop assignment";
 tileInfoPending = false;
 
 delay(50);
}

void drawTroops(){
  
  for(int i=0; i<troopNumLocations.length; i+=2){
    fill(255);
  rect(troopNumLocations[i],troopNumLocations[i+1],troopNumTxtSize+25,troopNumTxtSize+5);
  fill(0);
  textSize(troopNumTxtSize);
  text(troopsOnTile[i/2],troopNumLocations[i]+10,troopNumLocations[i+1]+troopNumTxtSize);
  }
}

void setTileColor( color col, int index ){
   index = index*3;
  for(int i=0; i<628; i++){
    for(int j=0; j<1227; j++){
      color px = img.get(j,i);
   if( red( px )== hues[index] && green( px )==hues[index+1] && blue( px  )==hues[index+2]){
     
   pixels[i*width+j] = col; 
   }
    }
  }
}

int getTile(){
  
   color c = img.get(mouseX,mouseY);
    // println( red(c) + "," + green(c)+ "," + blue(c)+"," );
 int hueIndex = -1;
 
  for(int i=0;i<hues.length; i+=3){
    if( red(c)==hues[i] && green(c)==hues[i+1] && blue(c)==hues[i+2] ){
       // println(i/3);
    hueIndex = i/3;
    }
  }
 return hueIndex;
}

boolean isUserTile( int tile ){
 boolean result = false;
 
 if(clientId==0){
   if(playerTiles[0].hasValue(tile)==true) result=true;
 }
 else if(clientId==1){
   if(playerTiles[1].hasValue(tile)==true) result=true;
 }
 else if(clientId==2){
   if(playerTiles[2].hasValue(tile)==true) result=true;
 }
 return result;
}


boolean isNeighbourTile (int tile,int potentialneighbour){
   boolean result = false;
  if(tile!=-1){
    int index = tile*6;
  
  if( 
  neighbourTiles[index]==potentialneighbour
  || neighbourTiles[index+1]==potentialneighbour
  || neighbourTiles[index+2]==potentialneighbour
  || neighbourTiles[index+3]==potentialneighbour
  || neighbourTiles[index+4]==potentialneighbour
  || neighbourTiles[index+5]==potentialneighbour
  ){
    result = true;
  }
  }
  
 return result;
}

int getTileOwner(int tile){
 int result = -1;
 if(playerTiles[0].hasValue(tile)) result =0;
 else if(playerTiles[1].hasValue(tile)) result =1;
 else if(playerTiles[2].hasValue(tile)) result =2;
 return result;
}

StringList getAvailableCombos(){
 StringList combos = new StringList();
 if(hasCombo(0,0,0,cards)){ combos.append("infantry,infantry,infantry"); }
 if(hasCombo(1,1,1,cards)) combos.append("horse,horse,horse");
 if(hasCombo(2,2,2,cards)) combos.append("canon,canon,canon");
 if(hasCombo(0,1,2,cards)) combos.append("infantry,horse,canon");
 if(hasCombo(0,0,3,cards)) combos.append("infantry,infantry,wildcard");
 if(hasCombo(0,3,3,cards)) combos.append("infantry,wildcard,wildcard");
 if(hasCombo(3,3,3,cards)) combos.append("wildcard,wildcard,wildcard");
 if(hasCombo(1,1,3,cards)) combos.append("horse,horse,wildcard");
 if(hasCombo(1,3,3,cards)) combos.append("horse,wildcard,wildcard");
 if(hasCombo(2,2,3,cards)) combos.append("canon,canon,wildcard");
 if(hasCombo(2,3,3,cards)) combos.append("canon,wildcard,wildcard");
 if(hasCombo(0,1,3,cards)) combos.append("infantry,horse,wildcard");
 if(hasCombo(0,2,3,cards)) combos.append("infantry,canon,wildcard");
 if(hasCombo(1,2,3,cards)) combos.append("horse,canon,wildcard");
 return combos;
}

boolean hasCombo(int i1, int i2, int i3, IntList input){
  
  boolean result=false;
  if(!input.hasValue(i1)||!input.hasValue(i2)||!input.hasValue(i3)) return false;
  
  int index1 =-1;
  for(int i=0; i<input.size(); i++){
   if(input.get(i)==i1) index1=i; 
  }
  
  int index2 =-1;
  for(int i=0; i<input.size(); i++){
   if(input.get(i)==i2&&i!=index1) index2=i; 
  }
  
  int index3 =-1;
  for(int i=0; i<input.size(); i++){
   if(input.get(i)==i3&&i!=index2&&i!=index1) index3=i; 
  }
  
  if(index1!=-1&&index2!=-1&&index3!=-1) result = true;
  return result;
}