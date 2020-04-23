// displaydicechoicebuttons()
//
// display one, two or three buttons depending on what the user can play. 
void displayDiceChoiceButtons() {
  if (availableDice>0) {
    if ( button(buttonx1, buttony, "Roll 1", 20, color(#FFFFFF), color(#000000), false) )
      pressNumToPickDice('1');
  }
  if (availableDice>1) {
    if ( button(buttonx2, buttony, "Roll 2", 20, color(#FFFFFF), color(#000000), false) )
      pressNumToPickDice('2');
  }
  if (availableDice>2) {
    if ( button(buttonx3, buttony, "Roll 3", 20, color(#FFFFFF), color(#000000), false) )
      pressNumToPickDice('3');
  }
}
