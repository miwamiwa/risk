String[] territoryNames = {
  "Alaska",
  "Alberta",
  "Central America",
  "Eastern United States",
  "Greenland",
  "Northwest Territories",
  "Ontario",
  "Quebec",
  "Western United States",
  "Argentina",
  "Brazil",
  "Peru",
  "Venezuela",
  
  "Congo",
  "East Africa",
  "Egypt",
  "Madagascar",
  "North Africa",
  "South Africa",
  
  "Great Britain",
  "Iceland",
  "Northern Europe",
  "Scandinavia",
  "Southern Europe",
  "Ukraine",
  "Western Europe",
  
  "Afghanistan",
  "China",
  "India",
  "Irkutsk",
  "Japan",
  "Kamchatka",
  "Middle East",
  "Mongolia",
  "Siam",
  "Siberia",
  "Ural",
  "Yakutsk",
  "Eastern Australia",
  "Indonesia",
  "New Guinea",
  "Western Australia"
};



float[] hues = {

255.0,106.0,0.0,
255.0,255.0,0.0,
255.0,255.0,128.0,
128.0,128.0,0.0,
153.0,127.0,0.0,
206.0,172.0,0.0,
182.0,255.0,0.0,
216.0,139.0,15.0,
80.0,80.0,39.0,
255.0,0.0,0.0,
128.0,64.0,64.0,
128.0,0.0,0.0,
255.0,128.0,128.0,
255.0,216.0,0.0,
255.0,128.0,0.0,
128.0,64.0,0.0,
174.0,87.0,0.0,
255.0,145.0,91.0,
183.0,95.0,47.0,
0.0,64.0,128.0,
137.0,86.0,255.0,
0.0,0.0,255.0,
0.0,128.0,255.0,
55.0,91.0,198.0,
0.0,0.0,128.0,
71.0,117.0,255.0,
128.0,255.0,128.0,
0.0,128.0,64.0,
0.0,128.0,128.0,
128.0,255.0,0.0,
3.0,25.0,18.0,
10.0,73.0,52.0,
0.0,128.0,0.0,
0.0,64.0,0.0,
10.0,150.0,40.0,
25.0,181.0,129.0,
35.0,255.0,181.0,
15.0,112.0,80.0,
64.0,0.0,64.0,
128.0,0.0,255.0,
255.0,0.0,255.0,
128.0,0.0,64.0,
};

int[] troopNumLocations = {
  71,71,
  130,112,
  122,247,
  197,183,
 417,36,
  165,66,
217,118,
290,115,
110,170,

  283,503,
323,408,
266,429,
254,328,

626,358,
703,322,
628,234,
733,445,
536,275,
632,449,
503,120,
475,82,
588,123,
596,79,
623,160,
670,112,
540,160,
 786,156,
936,205,
856,251,
938,114,
1101,189,
1057,72,
702,207,
944,153,
963,284,
847,71,
779,90,

944,69,
1124,477,
1001,357,
1120,387,
1027,481,
};

int[] neighbourTiles = { 
  //NA 1=0
  31,1,5, -1,-1,-1,//0(NA1)
  0,5,6,8,   -1,-1,//1(NA2)
  3,8,12, -1,-1,-1,//2(NA3)
  2,8,6,7,   -1,-1,//3(NA4)
  20,7,6,5,  -1,-1,//4(NA5)
  0,1,6,  -1,-1,-1,//5(NA6)
  5,4,7,1,8,3,     //6(NA7)
  3,6,4,  -1,-1,-1,//7(NA8)
  1,6,3,2,   -1,-1,//8(NA9)
  //SA 1=9
  10,11, -1,-1,-1,-1,//9(SA1)
  9,11,12,17,  -1,-1,//10(SA2)
  9,10,12,  -1,-1,-1,//11(SA3)
  10,11,2,  -1,-1,-1,//12(SA4)
  //AF 1=13
  14,17,18, -1,-1,-1, //13(AF1)
  13,15,16,17,18,32,  //14(AF2)
  14,17,32,23, -1,-1, //15(AF3)
  14,18, -1,-1,-1,-1, //16(AF4)
  13,14,15,10,25,-1,  //17(AF5)
  13,14,16, -1,-1,-1, //18(AF6)
  //EU 1=19
  20,21,22,25, -1,-1, //19(EU1)
  19,22,4,  -1,-1,-1, //20(EU2)
  19,22,23,24,25, -1, //21(EU3)
  19,20,21,24, -1,-1, //22(EU4)
  21,24,25,32,15, -1, //23(EU5)
  21,22,23,26,32,36,  //24(EU6)
  19,21,23,17, -1,-1, //25(EU7)
  //AS 1=26
  27,28,32,36,24, -1,//26(AS1)
  26,28,33,34,35,36, //27(AS2)
  26,27,32,34, -1,-1,//28(AS3)
  31,33,35,37, -1,-1,//29(AS4)
  31,33, -1,-1,-1,-1,//30(AS5)
  0,29,30,33,37,  -1,//31(AS6)
  26,28,14,15,23,24, //32(AS7)
  27,29,30,31,35, -1,//33(AS8)
  27,28,39, -1,-1,-1,//34(AS9)
  27,29,33,36,37, -1,//35(AS10)
  26,27,35,24, -1,-1,//36(AS11)
  29,31,35, -1,-1,-1,//37(AS12)
  //OC 1=38
  40,41, -1,-1,-1,-1,//38(oc1)
  40,41,34, -1,-1,-1,//39(oc2)
  38,39,41, -1,-1,-1,//40(oc3)
  38,39,40, -1,-1,-1,//41(oc4)
};