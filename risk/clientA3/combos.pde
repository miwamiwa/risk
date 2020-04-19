void pressKeyToSelectCombo(StringList inputlist){
  if(!comboPlaced&&keyPressed&&!choiceMade&&(key=='0'||key=='1'||key=='2'||key=='3'||key=='4'||key=='5'||key=='6'||key=='7'||key=='8'||key=='9')){
        int thekey =key-48;
    String message = "comborequest\n";
    comboPlaced = true;
    int[] cardlist = int(splitTokens( inputlist.get(thekey),"," ));
    choiceMade = true;
     int[] index = new int[3];
    for(int i=0; i<3; i++){
     
     for(int j=0; j<cards.size(); j++){
      if(cards.get(j)== cardlist[i]){
        index[i]=j;
      }
     }
     
     cards.remove(index[i]);
    }
    
    cardText = "";
  for(int i=0; i<cards.size(); i++){
   switch(cards.get(i)){ 
    case 0: cardText+= "infantry "; break;
    case 1: cardText+= "horse "; break;
    case 2: cardText+= "canon "; break;
    case 3: cardText+= "wild card "; break;
    }
  }
  displayCards();
    c.write(message);
  }
}


StringList getAvailableCombos(){
 StringList combos = new StringList();
 if(hasCombo(0,0,0,cards)){ combos.append("infantry,infantry,infantry"); }
 if(hasCombo(1,1,1,cards)) combos.append("horse,horse,horse");
 if(hasCombo(2,2,2,cards)) combos.append("canon,canon,canon");
 if(hasCombo(0,1,2,cards)) combos.append("infantry,horse,canon");
 if(hasCombo(0,0,3,cards)) combos.append("infantry,infantry,wildcard");
 if(hasCombo(0,3,3,cards)) combos.append("infantry,wildcard,wildcard");
 if(hasCombo(3,3,3,cards)) combos.append("wildcard,wildcard,wildcard");
 if(hasCombo(1,1,3,cards)) combos.append("horse,horse,wildcard");
 if(hasCombo(1,3,3,cards)) combos.append("horse,wildcard,wildcard");
 if(hasCombo(2,2,3,cards)) combos.append("canon,canon,wildcard");
 if(hasCombo(2,3,3,cards)) combos.append("canon,wildcard,wildcard");
 if(hasCombo(0,1,3,cards)) combos.append("infantry,horse,wildcard");
 if(hasCombo(0,2,3,cards)) combos.append("infantry,canon,wildcard");
 if(hasCombo(1,2,3,cards)) combos.append("horse,canon,wildcard");
 return combos;
}

boolean hasCombo(int i1, int i2, int i3, IntList input){
  
  boolean result=false;
  if(!input.hasValue(i1)||!input.hasValue(i2)||!input.hasValue(i3)) return false;
  
  int index1 =-1;
  for(int i=0; i<input.size(); i++){
   if(input.get(i)==i1) index1=i; 
  }
  
  int index2 =-1;
  for(int i=0; i<input.size(); i++){
   if(input.get(i)==i2&&i!=index1) index2=i; 
  }
  
  int index3 =-1;
  for(int i=0; i<input.size(); i++){
   if(input.get(i)==i3&&i!=index2&&i!=index1) index3=i; 
  }
  
  if(index1!=-1&&index2!=-1&&index3!=-1) result = true;
  return result;
}