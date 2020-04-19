String userName = "chucky";


int playingPlayer =-1;
String cardText = "";


boolean playerReady = false;
String readyTxt = "READY";
color buttoncolor = color(120,120,250);

int[] lastAttackRoll = new int[3];
int[] lastDefenseRoll = new int[3];
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

int comboMarker = 0;

void setup() { 
  
  size(1227,748);
  img = loadImage("Risk_game_map.png");
  map = loadImage("Risk_game_map.png");
  image(map, 0, 0, width,height-120);
  delay(1000);
  frameRate(5); // Slow it down a little
  // Connect to the server’s IP address and port­
  c = new Client(this, "192.168.0.175", 12345); // Replace with your server’s IP and port
  c.write("joined "+userName+"\n"); // joined
  
  for(int i=0; i<8; i++){
   getCard( floor( random(4) ));
  }
  
} 
//boolean yo=false;
boolean drawing = false;
void draw() {         
 
  runGame();
  
  if (mousePressed == true) {
    if(getTile()==-1){
      drawing = true;
      // Draw our line
    // Send mouse coords to other person
    stroke(255);
    line(pmouseX, pmouseY, mouseX, mouseY); 
    c.write("draw "+pmouseX + " " + pmouseY + " " + mouseX + " " + mouseY + "\n");
    }
    else drawing = false;
    
  }
  
  if(mousePressed==false) drawing = false;
  
  // Receive data from server
  if (c.available() > 0) { 
    input = c.readString(); 
    int index = input.indexOf("\n");
    if(index==-1){
     input+="\n";
     println("MESSAGE INPUT MISSING END TAG!!! MESSAGE: "+input);
    }
    input = input.substring(0,input.indexOf("\n"));  // Only up to the newline
    data = int(split(input, ' '));  // Split values into an array
    sdata = splitTokens(input," ");
    println(input);
    dataIn();
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




void startAttackPhase(){
 turnPhase="attack phase"; 
 availableDice = getAvailableDice("attacking");
}

void startDefensePhase(){
 turnPhase="defense phase"; 
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