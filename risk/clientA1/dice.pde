void displayDiceChoiceButtons(){
 if(availableDice>0){
           if( button(buttonx1,640,"Roll 1",20,color(#FFFFFF),color(#000000), false) )
           pressNumToPickDice('1');
         }
         if(availableDice>1){
           if( button(buttonx2,640,"Roll 2",20,color(#FFFFFF),color(#000000), false) )
           pressNumToPickDice('2');
         }
         if(availableDice>2){
           if( button(buttonx2,640,"Roll 3",20,color(#FFFFFF),color(#000000), false) )
           pressNumToPickDice('3');
         } 
}
