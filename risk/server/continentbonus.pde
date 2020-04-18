
int getContinentsBonus(int player){
  int continentBonus =0;
 IntList countries = new IntList();
 countries=playerTiles[player]; 

 
 if(
 countries.hasValue(0)
 && countries.hasValue(1)
 && countries.hasValue(2)
 && countries.hasValue(3)
 && countries.hasValue(4)
 && countries.hasValue(5)
 && countries.hasValue(6)
 && countries.hasValue(7)
 && countries.hasValue(8)
 ) continentBonus +=5; // has North America
 
 if(
 countries.hasValue(9)
 && countries.hasValue(10)
 && countries.hasValue(11)
 && countries.hasValue(12)
 ) continentBonus +=2; // has South America
 
  if(
 countries.hasValue(13)
 && countries.hasValue(14)
 && countries.hasValue(15)
 && countries.hasValue(16)
 && countries.hasValue(17)
 && countries.hasValue(18)
 ) continentBonus +=3; // has Africa
 
 if(
 countries.hasValue(19)
 && countries.hasValue(20)
&& countries.hasValue(21)
&& countries.hasValue(22)
&& countries.hasValue(23)
&& countries.hasValue(24)
&& countries.hasValue(25)
 ) continentBonus +=5; // has Europe
 
  if(
 countries.hasValue(26)
 && countries.hasValue(27)
&& countries.hasValue(28)
&& countries.hasValue(29)
&& countries.hasValue(30)
&& countries.hasValue(31)
&& countries.hasValue(32)
&& countries.hasValue(33)
&& countries.hasValue(34)
&& countries.hasValue(35)
&& countries.hasValue(36)
&& countries.hasValue(37)
 ) continentBonus +=7; // has Asia
 
  if(
 countries.hasValue(38)
 && countries.hasValue(39)
&& countries.hasValue(40)
&& countries.hasValue(41)
 ) continentBonus +=2; // has Oceania
 
 
 return continentBonus;
}