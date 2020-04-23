int wheelx=779;

int wheely=469;
int wheelSize=90;
float wheelratio = 150/wheelSize;
color wheelColor;
boolean drawWheel = false;
void colorWheel(){
  drawWheel = false;
  image(wheel,wheelx,wheely,wheelSize,wheelSize);
  fill(wheelColor);
  rect(wheelx+100,wheely,30,30,5);
 if(mousePressed){
   if(mouseX>wheelx&&mouseX<wheelx+wheelSize&&mouseY>wheely&&mouseY<wheely+wheelSize){
     drawWheel = true;
     int x=floor(wheelratio*(mouseX-wheelx));
     int y=floor(wheelratio*(mouseY-wheely));
    color cW = wheel.get(x,y);
    String p = str( clientId*3+colorSelection );
    float r =  floor(red(cW));
    float g =  floor(green(cW));
    float b =  floor(blue(cW));
    wheelColor = color(r,g,b );
    flagColors[clientId*3+colorSelection] = color(r,g,b);
    flagLoaded = false;
  //  c.write("newcolor "+p+" "+r+" "+g+" "+b+" \n");
    println("wheel value",r,g,b);
    println("mouse pos",x,y);
   }
 }
 
}