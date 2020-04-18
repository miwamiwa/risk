void assignTiles(){
  
  // initializa troops on each tile
  for(int i=0; i<42; i++){
   troopsOnTile[i] = 1; 
  }
  
  // assign random tiles to each player 
  IntList assignments = new IntList();
  for(int i=0; i<42; i++){
   assignments.append( i ); 
  }
 // int shuffleseed=3;
//  for(int i=0; i<shuffleseed; i++){
     assignments.shuffle();
//  }
 
  println(assignments);
  String assignmentstring = "";
   for(int i=0; i<assignments.size(); i++){
     assignmentstring += str(assignments.get(i))+" ";
  }
  assignmentstring=assignmentstring.trim();
  assignmentstring+="\n";
  s.write(assignmentstring);
  
  for(int i=0; i<tilesPerPlayer*3; i+=3){
    int tile1 = assignments.get(i);
    int tile2 = assignments.get(i+1);
    int tile3 = assignments.get(i+2);
    playerTiles[0].append( tile1 );
    playerTiles[1].append( tile2 );
    playerTiles[2].append( tile3 );

  }
}


IntList newDeck(){
 IntList result = new IntList();
 for(int i=0; i<14; i++){
  result.append(0); // infantry
 }
 
 for(int i=0; i<14; i++){
  result.append(1); // horse
 }
 
 for(int i=0; i<14; i++){
  result.append(2); // canon
 }
 
 for(int i=0; i<2; i++){
  result.append(3); // wildcard
 }
 
 result.shuffle();
 return result;
}