// doodles()
//
// lets the user doodle over the ocean. woop. 
// mouse coordinates are recorded every 2 frames, then they are sent to everyone when a set of 5 lines was drawn, 
// or when the mouse is released, which ever happens first. 

// NEXT STEP would prolly be to convert all the messaging to strings for server performance!

void doodles() {

  // if mouse if pressed, not over a country or a button or the flag or anything else I can think of
  if (mousePressed == true&&!buttonclicked&&!drawWheel) {
    if (getTile()==-1&&flagSelection==-1&&!drawFlag) {

      // if there is no "last mouse position"
      // record dmouseX,Y (replaces pmouseX,Y and records every x frames instead of every frame)
      // dmouseX,Y gets reset in mouseReleased()!! (main script file)
      if (dmouseX==-1) {
        dmouseX=mouseX;
        dmouseY=mouseY;
      } else if (frameCount%2==0) {
        drawing = true;
        // draw client-side line
        stroke(255);
        line(dmouseX, dmouseY, mouseX, mouseY); 
        
        // add to doodles array
        for (int i=doodleCount; i<doodleCount+5; i+=5) {
          doodleBuffer[i] =dmouseX;
          doodleBuffer[i+1]=dmouseY;
          doodleBuffer[i+2]=mouseX;
          doodleBuffer[i+3]=mouseY;
        }
        doodleCount+=4;
        dmouseX=mouseX;
        dmouseY=mouseY;
        // if maximum array size reached
        if (doodleCount==20) {
          String message="";
          // pick all values
          for (int i=0; i<20; i++) {
            message+=doodleBuffer[i]+" ";
          }
          // send message and reset doodle count
          c.write("draw "+message+"\n");
          doodleCount=0;
        }
      }
    } 
    else drawing = false; // if something is going on that's not drawing, mark drawing as not happening. 
  }
  // when mouse is released, send over any remaining doodle data.
  else if (mousePressed==false) {
    drawing = false;
    if (doodleCount>0) {
      String message="";
      // pick values only up to the current doodleCount value
      for (int i=0; i<doodleCount; i++) {
        message+=doodleBuffer[i]+" ";
      }
      // send message and reset doodle count
      c.write("draw "+message+"\n");
      doodleCount=0;
    }
  }
}
