//diceRoll()
//
// returns a number from 1 to 6
int diceRoll(){
 int result=ceil(random(6));
 return result;
}


void diceBattle(){
  
  // start a result message
  String resultmessage = "battleresult ";
  IntList attackRolls = new IntList();
  IntList defenseRolls = new IntList();    
  //dice pick = number of dice
  resultmessage += attackerDicePick+" ";
  resultmessage += defenderDicePick+" ";
           
   // roll dice and append values to intlists attackRolls and defenseRolls
   // aswell ass add to result message
  for(int i=0; i<attackerDicePick; i++){
    int roll = diceRoll();
    attackRolls.append( roll ); 
    resultmessage += roll+" ";
   }
           
  for(int i=0; i<defenderDicePick; i++){
    int roll = diceRoll();
    defenseRolls.append( roll ); 
    resultmessage += roll+" ";
   }
  
  // get attacker's first and second highest rolls
  int firstA =-1;
  int secondA=-1;
  int valA=0;
  for(int i=0; i<attackRolls.size(); i++){
    valA = attackRolls.get(i);
    if(valA>firstA){
      secondA=firstA;
      firstA=valA;
    }
    else if(valA>secondA) secondA=valA;
  }
  
  // get defender's first and second highest rolls
  int firstB =-1;
  int secondB=-1;
  int valB=0;
  for(int i=0; i<defenseRolls.size(); i++){
    valB = defenseRolls.get(i);
    if(valB>firstB){
      secondB=firstB;
      firstB=valB;
    }
    else if(valB>secondB) secondB=valB;
  }
  
  int attackingTileDamage =0;
  int defendingTileDamage =0;
  
  // compare first rolls 
  if(firstA>firstB) defendingTileDamage+=1;
  else attackingTileDamage+=1;
  
  // compare second rolls if both rolled second rolls
  if(secondB!=-1&&secondA!=-1){
    if(secondA>secondB) defendingTileDamage+=1;
  else attackingTileDamage+=1;
  }
    
    println("first A: "+firstA);
    println("second A: "+secondA);
    println(attackRolls.size());
    
    println("first B: "+firstB);
    println("second B: "+secondB);
    println(defenseRolls.size());
  // award card 
  if(troopsOnTile[defendingCountry] - defendingTileDamage>=0){
    cardAwarded = true; 
    }
    
    // send server message
  resultmessage += attackingTileDamage+" "+defendingTileDamage+"\n";
    s.write(resultmessage);
}