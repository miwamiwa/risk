int flagX=800;
int flagY=340;
int flagW=15;
int flagH=12;
int totalFlagPixels = flagW*flagH;
int flagGridSize=10;
boolean drawFlag = false;
int[] flagGrids = new int[3*flagW*flagH];
int colorsPerFlag =3;
color startColor1 = color(200,80,80);
color startColor2 = color(80,200,80);
color startColor3 = color(80,80,200);
boolean flagLoaded = false;
int flagSelection=-1;
int colorSelection =0;

String[] flags = new String[3]; 

color[] flagColors = {
 startColor1,
 startColor2,
 startColor3,
 
 startColor2,
 startColor3,
 startColor1,
 
 startColor3,
 startColor2,
 startColor1
};

int brushSize=1;

void loadFlagGrid(){
  
 // fill(60);
 // text(
//  "flag: press z,x,c to pick color.\nclick to paint\nbrushsize: a,s\nupdate map: q",
 // flagX+5,flagY+flagH*flagGridSize+10);
  //int assignedColor = 0;
  for(int k=0; k<3; k++){
    for(int i=0; i<flagH; i++){
   for(int j=0; j<flagW; j++){

      flagGrids[ k*flagH*flagW + i*flagW + j ] = k*3;
     // if(k==0) println( flagGrids[ k*flagH*flagW + i*flagW + j ] );
   }
  }
 }
 
 println(flagGrids);
}

void makeFlag(){
  
  flagSelection =clickFlag();
  
  
  if( button(916,342+flagH*10+10,"SEND",20,color(#333333),color(#FFFFFF), false) ){
    sendMap();
  }
  
  if( button(880,375+flagH*10+10,"1",20,flagColors[clientId*3],color(#FFFFFF), false) ){
    colorSelection =0;
    wheelColor = flagColors[ clientId*3+0 ];
  }
  if( button(910,375+flagH*10+10,"2",20,flagColors[clientId*3+1],color(#FFFFFF), false) ){
    colorSelection=1;
    wheelColor = flagColors[ clientId*3+1 ];
  }
  if( button(940,375+flagH*10+10,"3",20,flagColors[clientId*3+2],color(#FFFFFF), false) ){
    colorSelection=2;
    wheelColor = flagColors[ clientId*3+2 ];
  }
  
  if( button(880,405+flagH*10+10,"b",20,color(#333333),color(#FFFFFF), false) ){
    brushSize=0;
  }
  if( button(910,405+flagH*10+10,"B",20,color(#333333),color(#FFFFFF), false) ){
    brushSize=1;
  }
  
  if(!flagLoaded&&clientId!=-1){
    
    noStroke();
    flagLoaded = true;
     //fill(250);
   //  println("id "+clientId);
  
  //rect(flagX,flagY,flagW*flagGridSize,flagH*flagGridSize);
  for(int i=0; i<flagH; i++){
    for(int j=0; j<flagW; j++){
        int result=clientId*flagW*flagH + i*flagW + j;
       // println("result "+result);
       //  println("num "+flagGrids[result]);
         
     fill(  flagColors [ flagGrids[result] ]) ;
     rect( 
     flagX + j*flagGridSize,
     flagY + i*flagGridSize,
     flagGridSize,
     flagGridSize
     );
    }
  }
    
  }
 
}





void newFlagPixel(int index){
  int selection = colorSelection + clientId*3;
  flagGrids[clientId*flagW*flagH+index] = selection;
  int i=floor(index/flagW);
  int j=index%flagW;
  
  fill(flagColors[selection]);
  rect( 
     flagX + j*flagGridSize,
     flagY + i*flagGridSize,
     flagGridSize,
     flagGridSize
     );
}







int clickFlag(){
  int result=-1;
  if(mousePressed&&!buttonclicked){
    if(
  mouseX>flagX&&mouseX<flagX+flagW*flagGridSize
  && mouseY>flagY &&mouseY<flagY+flagH*flagGridSize
  ){
   int gridY = floor( (mouseY-flagY)/flagGridSize );
   int gridX = floor( (mouseX-flagX)/flagGridSize );
   result = gridY*flagW + gridX;
  // flagLoaded=false;
   drawFlag = true;
   newFlagPixel(result);
   
   if(brushSize>0){
     if(gridX-1>0) newFlagPixel(result-1);
     if(gridX+1<flagW) newFlagPixel(result+1);
     if(gridY-1>0) newFlagPixel(result-flagW);
     if(gridY+1<flagH) newFlagPixel(result+flagW);
   } 
   println("clicked flag grid no "+result);
 }
 
  }
  
return result; 
}



// sendmap()
//
// triggered when SEND button is pressed.
void sendMap(){
 
  String resultString = "";
  
  // temporarily save flag data
  int[] flag = new int[totalFlagPixels];
  // get start index of user's flag data in the larger flags array
  int startval = clientId*totalFlagPixels;
  // the color of the last pixel checked
  int currentval = -1;
  
  // what's the max number of same consecutive pixels to group together
  int maxCount = 20;
  int listLength =0;
  
  // get results in list form
  IntList colors = new IntList();
  IntList counts = new IntList();
  for(int i=startval; i<startval+totalFlagPixels; i++){
    
    int pixval = flagGrids[i] - clientId*3;
    if( pixval != currentval ){
      
      currentval = pixval;
      colors.append(currentval);
      counts.append(0);
      listLength++;
    }
    else{
     int val = counts.get(listLength-1);
     if(val<maxCount-1)
      counts.set(listLength-1,val+1);
     
     else{
      colors.append(currentval);
      counts.append(0);
      listLength++;
     }
    }
  }
  
  // convert lists to string
  int[] resultArray = new int[ listLength ];
  for(int i=0; i<listLength; i++){
   int number = colors.get(i)*maxCount + counts.get(i);
  // if(number<10) resultString+=0;
   resultArray[i]=number;
   resultString += char(number+48);
  }
  println("red1");
  println(int(red(flagColors[clientId*3])));
  String finalMessage = "newflag "+clientId
  +" " +int(red(flagColors[clientId*3]))  +" "+int(green(flagColors[clientId*3]))  +" "+int(blue(flagColors[clientId*3]))
  +" " +int(red(flagColors[clientId*3+1]))+" "+int(green(flagColors[clientId*3+1]))+" "+int(blue(flagColors[clientId*3+1]))
  +" " +int(red(flagColors[clientId*3+2]))+" "+int(green(flagColors[clientId*3+2]))+" "+int(blue(flagColors[clientId*3+2]))
  +" " +resultString+"\n";
 
println( "SENDING : "+finalMessage );
  c.write(finalMessage);
}



int[] unpackedList = new int[totalFlagPixels];





void drawFlagString( String input, int player ){
  
  println("unpacking flag");
  int counter =0;
  for(int i=0; i<input.length(); i++){
    
   // String num = str();
    int val = int( input.charAt(i) )-48;
    
    int res = 0;
   // println("raw val "+val);
    if(val-40>=0) {
      res=2;
      val=val-40;
    }
    else if(val-20>=0) {
      res=1;
      val = val-20;
    }
   // else {}
    // println("val "+val+" res: "+res);
     res = res+player*3;
    unpackedList[counter] = res;
    counter++;
    
    for(int j=0; j< val; j++){
   //  println(res);
     //println(input.charAt(i));
      unpackedList[counter] = res;
      counter++;
    }
  }
  
  
  println("list");
  println(unpackedList);
  for(int i=0; i<flagH; i++){
    for(int j=0; j<flagW; j++){
      
        int result= i*flagW + j;
      //  println("resultindex: "+result);
        flagGrids[ result + player*totalFlagPixels] = unpackedList[result];
      //   println("color picked "+unpackedList[result]);
   //  fill(  flagColors [ unpackedList[result]+player*3 ]) ;
    // rect( 
  //   100 + j*flagGridSize,
  //   100 + i*flagGridSize,
  //   flagGridSize,
   //  flagGridSize
   //  );
    }
  }
  
    loadPixels();
  println("gotmap");
  if(clientId!=-1){
   for(int i=0; i<playerTiles[player].size(); i++){
     
    println("setit");
     setTileColor(player,playerTiles[player].get(i));
   }
  }
  
  updatePixels();
  
}
