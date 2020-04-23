int wheelx=779;
int wheely=469;
int wheelSize=90;
float wheelratio = 150.0/wheelSize;
color wheelColor;
boolean drawWheel = false;

// colorwheel()
//
// displays the color wheel and checks for mouse clicks. 
void colorWheel(){
  
  drawWheel = false;
  // display wheel
  image(wheel,wheelx,wheely,wheelSize,wheelSize);
  fill(wheelColor);
  // display swatch
  rect(wheelx+100,wheely,30,30,5);
  
  // check for mouse interaction 
 if(mousePressed){
   // if wheel clicked
   if(mouseX>wheelx&&mouseX<wheelx+wheelSize&&mouseY>wheely&&mouseY<wheely+wheelSize){
     // prevent other mouse clicks on this frame
     drawWheel = true;
     // get color at mouse X,Y
    int x=floor(wheelratio*(mouseX-wheelx));
    int y=floor(wheelratio*(mouseY-wheely));
    color cW = wheel.get(x,y);
    int r =  floor(red(cW));
    int g =  floor(green(cW));
    int b =  floor(blue(cW));
    
    // set swatch color
    wheelColor = color(r,g,b );
    // set selected color 
    flagColors[clientId*3+colorSelection] = color(r,g,b);
    // reload flag
    flagLoaded = false;
    println("wheel value",r,g,b);
    println("mouse pos",x,y);
   }
 }
}
