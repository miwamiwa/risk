void doodles(){
 
  if (mousePressed == true&&!buttonclicked&&released) {
    if(getTile()==-1&&flagSelection==-1&&!drawFlag){
      released = false;
      drawing = true;
      // Draw our line
    // Send mouse coords to other person
    stroke(255);
    line(pmouseX, pmouseY, mouseX, mouseY); 
    c.write("draw "+pmouseX + " " + pmouseY + " " + mouseX + " " + mouseY + "\n");
    }
    else drawing = false;
    
  }
  
  else if(mousePressed==false) drawing = false;
}
