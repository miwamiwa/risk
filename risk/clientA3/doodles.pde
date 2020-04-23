
void doodles(){
 
  if (mousePressed == true&&!buttonclicked&&!drawWheel) {
    if(getTile()==-1&&flagSelection==-1&&!drawFlag){
      if(dmouseX==-1){
       dmouseX=mouseX;
       dmouseY=mouseY;
      }
      else if(frameCount%2==0){
         released = false;
      drawing = true;
      // Draw our line
    // Send mouse coords to other person
    stroke(255);
    line(dmouseX, dmouseY, mouseX, mouseY); 
    
    for(int i=doodleCount; i<doodleCount+5; i+=5){
     doodleBuffer[i] =dmouseX;
     doodleBuffer[i+1]=dmouseY;
     doodleBuffer[i+2]=mouseX;
     doodleBuffer[i+3]=mouseY;
    }
    doodleCount+=4;
    dmouseX=mouseX;
    dmouseY=mouseY;
    if(doodleCount==20){
     String message="";
     for(int i=0; i<20; i++){
      message+=doodleBuffer[i]+" "; 
     }
     c.write("draw "+message+"\n");
     println("draw mess sent "+message+"\n");
     doodleCount=0;
    }
      }
     
   // c.write("draw "+pmouseX + " " + pmouseY + " " + mouseX + " " + mouseY + "\n");
    }
    else drawing = false;
    
  }
  
  else if(mousePressed==false){
    drawing = false;
    if(doodleCount>0){
          String message="";
     for(int i=0; i<doodleCount; i++){
      message+=doodleBuffer[i]+" "; 
     }
     println("draw mess sent2 "+message+"\n");
     c.write("draw "+message+"\n");
     doodleCount=0;
    }
   // doodleCount=0;
      // send and reset doodle buffer
  
     
     
  }
}