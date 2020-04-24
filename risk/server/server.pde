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
int cardPlayer=-1;
int attackerDicePick =0;
int defenderDicePick =0;

int attackingCountry=0;
int defendingCountry=0;
int attacker =0;
int defender =0;
IntList deck = new IntList();
boolean player1InitDone = false;
boolean player2InitDone = false;
boolean player3InitDone = false;

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


String[] flags = new String[3];

// setup()
//
// called on app start 

void setup() { 
  
  deck = newDeck();
  
  size(450, 255);
  background(204);
  stroke(0);
  frameRate(5); // Slow it down a little
  s = new Server(this, 12345);  // Start a simple server on a port
  
  turnOrder.append(0);
  turnOrder.append(1);
  turnOrder.append(2);
  turnOrder.shuffle();
} 

// draw()
//
// main loop 

void draw() { 
  
 if(keyPressed&&key=='q') s.write("choicereset\n");
  
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
    println("server input: " +input);
    int index = input.indexOf("\n");
    if(index==-1){
     input+="\n";
     println("MESSAGE INPUT MISSING END TAG!!! MESSAGE: "+input);
     fill(200,0,200);
     textSize(100);
     text("ERROR ON MESSAGE "+input.indexOf("\n"),0,0);
    }
    input = input.substring(0, index);  // Only up to the newline
    data = int(split(input, ' ')); // number array
    sdata = splitTokens(input); // text array
    dataIn();// do stuff with data input
  }
}





int getBaseReinforcements(int player){
 int reinforcements =0;
 int territories=0;
  territories = playerTiles[player].size();
 reinforcements = floor(territories/3);
 if(reinforcements<3) reinforcements=3;
 return reinforcements;
}




int getTileOwner(int tile){
 int result = -1;
 if(playerTiles[0].hasValue(tile)) result =0;
 else if(playerTiles[1].hasValue(tile)) result =1;
 else if(playerTiles[2].hasValue(tile)) result =2;
 return result;
}
