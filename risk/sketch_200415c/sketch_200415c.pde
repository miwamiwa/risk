PImage img;
PImage map;
color team1color = color( 255,50,50 );
color team2color = color( 50,255,50 );
color team3color = color( 50,50,255 );


float[] hues = {

255.0,106.0,0.0,
255.0,255.0,0.0,
255.0,255.0,128.0,
128.0,128.0,0.0,
153.0,127.0,0.0,
206.0,172.0,0.0,
182.0,255.0,0.0,
216.0,139.0,15.0,
80.0,80.0,39.0,
255.0,0.0,0.0,
128.0,64.0,64.0,
128.0,0.0,0.0,
255.0,128.0,128.0,
255.0,216.0,0.0,
255.0,128.0,0.0,
128.0,64.0,0.0,
174.0,87.0,0.0,
255.0,145.0,91.0,
183.0,95.0,47.0,
0.0,64.0,128.0,
137.0,86.0,255.0,
0.0,0.0,255.0,
0.0,128.0,255.0,
55.0,91.0,198.0,
0.0,0.0,128.0,
71.0,117.0,255.0,
128.0,255.0,128.0,
0.0,128.0,64.0,
0.0,128.0,128.0,
128.0,255.0,0.0,
3.0,25.0,18.0,
10.0,73.0,52.0,
0.0,128.0,0.0,
0.0,64.0,0.0,
10.0,150.0,40.0,
25.0,181.0,129.0,
35.0,255.0,181.0,
15.0,112.0,80.0,
64.0,0.0,64.0,
128.0,0.0,255.0,
255.0,0.0,255.0,
128.0,0.0,64.0,
};


int imgSize=1227*628;
int numberOfPlayers = 3;
int totalTiles=42;
int tilesPerPlayer=14;
int[] troopsOnTile = new int[42];

IntList player1tiles = new IntList();
IntList player2tiles = new IntList();
IntList player3tiles = new IntList();

int troopNumTxtSize = 13;
int[] troopNumLocations = {
  71,71,
  130,112,
  122,247,
  197,183,
 417,36,
  165,66,
217,118,
290,115,
110,170,

  283,503,
323,408,
266,429,
254,328,

626,358,
703,322,
628,234,
733,445,
536,275,
632,449,
503,120,
475,82,
588,123,
596,79,
623,160,
670,112,
540,160,
 786,156,
936,205,
856,251,
938,114,
1101,189,
1057,72,
702,207,
944,153,
963,284,
779,90,
847,71,
944,69,
1124,477,
1001,357,
1120,387,
1027,481,
};
void setup(){
  
  size(1227,628);
  img = loadImage("Risk_game_map.png");
  map = loadImage("Risk_game_map.png");
  image(map, 0, 0, width,height);
  assignTiles();
}

void draw(){
  for(int i=0; i<troopNumLocations.length; i+=2){
    fill(255);
  rect(troopNumLocations[i],troopNumLocations[i+1],troopNumTxtSize+25,troopNumTxtSize+5);
  fill(0);
  textSize(troopNumTxtSize);
  text("1",troopNumLocations[i]+10,troopNumLocations[i+1]+troopNumTxtSize);
  }
  
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
  assignments.shuffle();
  loadPixels();
  
  for(int i=0; i<tilesPerPlayer*3; i+=3){
    int tile1 = assignments.get(i);
    int tile2 = assignments.get(i+1);
    int tile3 = assignments.get(i+2);
    player1tiles.append( tile1 );
    player2tiles.append( tile2 );
    player3tiles.append( tile3 );
   setTileColor( team1color, tile1);
   setTileColor( team2color, tile2);
   setTileColor( team3color, tile3);
   //delay(1);
   println(i);
  }
  
  updatePixels();
  
}

void mouseClicked() {
  println(mouseX+","+mouseY+",");
 // color c = img.get(mouseX,mouseY);
    // println( red(c) + "," + green(c)+ "," + blue(c)+"," );
// int hueIndex = -1;
 
  //for(int i=0;i<hues.length; i+=3){
  //  if( red(c)==hues[i] && green(c)==hues[i+1] && blue(c)==hues[i+2] ){
  //  println(i/3);
  //  hueIndex = i/3;
  //  }
 // }
  
 /// loadPixels();
  
  // color col = color(random(255),0,0);
   //setTileColor(col,hueIndex);
  // updatePixels();
  
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