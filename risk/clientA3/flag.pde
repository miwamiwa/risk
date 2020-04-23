int flagX=800;
int flagY=370;
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
int colorSelection =1;

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
  
  fill(60);
  text(
  "flag: press z,x,c to pick color.\nclick to paint\nbrushsize: a,s\nupdate map: q",
  flagX+5,flagY+flagH*flagGridSize+10);
  int assignedColor = 0;
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
  
  if(keyPressed)
  {
   switch(key){
    case 'z': colorSelection = 0; break;
    case 'x': colorSelection = 1; break;
    case 'c': colorSelection = 2; break;
    case 'a': brushSize=0; break;
    case 's': brushSize=1; break;
    case 'q': sendMap(); break;
   }
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
  if(mousePressed&&!buttonclicked&&released){
    if(
  mouseX>flagX&&mouseX<flagX+flagW*flagGridSize
  && mouseY>flagY &&mouseY<flagY+flagH*flagGridSize
  ){
   int gridY = floor( (mouseY-flagY)/flagGridSize );
   int gridX = floor( (mouseX-flagX)/flagGridSize );
   result = gridY*flagW + gridX;
  // flagLoaded=false;
   drawFlag = true;
   released = false;
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
void sendMap(){
 

  
  String resultString = "";
  int[] flag = new int[totalFlagPixels];
  int startval = clientId*totalFlagPixels;
  int maxExtraCount=20;
  int currentval = -1;
  int extraCount =  0;
  
  IntList colors = new IntList();
  IntList counts = new IntList();
  int maxCount = 20;
  int listLength =0;
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
  
  int[] resultArray = new int[ listLength ];
  
  for(int i=0; i<listLength; i++){
   int number = colors.get(i)*maxCount + counts.get(i);
  // if(number<10) resultString+=0;
   resultArray[i]=number;
   resultString += char(number+48);
  }
  
 // println("result string: "+resultString);
 // println("items "+resultString.length()/2 );
 // flags[clientId]=resultString;
//  drawFlagString( flagString );
println("sending : "+resultString);
println(resultArray);
  c.write("newflag "+clientId+" "+resultString+"\n");
}



int[] unpackedList = new int[totalFlagPixels];





void drawFlagString( String input, int player ){
  
  
  int counter =0;
  for(int i=0; i<input.length(); i++){
    
   // String num = str();
    int val = int( input.charAt(i) )-48;
    
    int res = 0;
    println("raw val "+val);
    if(val-40>=0) {
      res=2;
      val=val-40;
    }
    else if(val-20>=0) {
      res=1;
      val = val-20;
    }
   // else {}
     println("val "+val+" res: "+res);
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
  println("sendmap");
  if(clientId!=-1){
   for(int i=0; i<playerTiles[player].size(); i++){
 //    println("setit");
     setTileColor(player,playerTiles[player].get(i));
   }
  }
  
  updatePixels();
  
}
