boolean button (int x, int y, String title, int fontsize,color bgColor, color txtColor, boolean flashing){
  boolean clicked = false;
  
  
  textSize(fontsize);
  int w = int(textWidth(title))+10;
  int h = fontsize+5;
  
  // check if mouse pressed

   if(mouseX>x&&mouseX<x+w&&mouseY>y&&mouseY<y+h){
     bgColor = #cccccc;
     // assign return value
       if(hasClicked){
     buttonclicked = true;
     clicked = true;
     color c1 = txtColor;
     color c2 = bgColor;
     txtColor=c2;
     bgColor=c1;
   }
  }
  // flash if needed
  else if(flashing){
    if(frameCount%20<10){
      txtColor = bgColor;
      bgColor = #FF0000;
    }
  }
  
  // display button
  fill(bgColor);
  rect(x,y,w,h);
  fill(txtColor);
  text(title,5+x,y+fontsize);
  
  return clicked;
}