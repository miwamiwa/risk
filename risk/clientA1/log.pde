int logTxtSize=14;

String startLogText="type something and press enter to send!";
String logBuffer=startLogText;
int logOffset=0;
int logViewMax=17;
void showLog(){
  
  noStroke();
  int x=10;
  int y=365;
  int w=190;
  int h=335;
  fill(60);
  rect(x-5,y-20,w+10,h+10);
  rect(x-5,y+h-50,w+60,45);
  textSize(logTxtSize+4);
  
  textLeading(logTxtSize+4);
  if(logBuffer==startLogText) fill(185);
  else fill(245);
  text(logBuffer,x,y+h-46, w+50,55);
 // fill(245);
  for(int i=0; i<logViewMax; i++){
    if(logData[i+33+logOffset].indexOf("says")!=-1) fill(145);
    else fill(245);
   text(logData[i+33],x,y+i*(logTxtSize+4)); 
  }
}

//int lastKeyPress=0;
void logInput(){
  
 // println(logBuffer);
 if(keyPressed&&key==8&&frameCount%2==0){
     // println("backspace");
      int l = logBuffer.length()-1;
      if(l>=0){
        logBuffer = logBuffer.substring( 0, l ); 
      }
    }
  showLog();
  
}


void keyPressed(){
    
    if(key==32||key==33||(key>=35&&key<=122)){
      if(logBuffer==startLogText) logBuffer="";
      logBuffer+=char(key);
    }
    else if(key==ENTER&&logBuffer!=startLogText){
     // println("ENTER");
     
     sendLogBuffer();
     logBuffer=startLogText;
    }
}


void sendLogBuffer(){
  if(!choiceMade){
   choiceMade = true;
   c.write("chat "+clientId+" "+logBuffer+"\n");
  }
}

void sortLogAndAdd( String input, int source ){
  String sourceName ="anonymous";
   if(source<3) sourceName = playerNames[ source ];
   newLog(sourceName+" says:");
   
  String[] words = input.split(" ");
  
  int charcount=0;
  String currentline="";
  int maxchar=19;
  println("words: "+words.length);
  for(int i=0; i<words.length; i++){
    int chars = words[i].length()+1;
    String w = words[i]+" ";
    if( chars+charcount>maxchar ){
      newLog(currentline);
      println(currentline);
      currentline=w;
      charcount=chars;
    }
    else{
      charcount+=chars;
      currentline+=w;
    }
  }
  newLog(currentline);
  newLog("");
}

void newLog( String input ){
 
    int totalLength = logData.length;
 for(int i=0; i<totalLength; i++){
  if(i<totalLength-1) logData[i] = logData[i+1];
  else logData[i] = input;
 }
  
  
}
