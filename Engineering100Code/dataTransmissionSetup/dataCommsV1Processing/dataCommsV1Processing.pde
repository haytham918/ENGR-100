import processing.serial.*;
Serial infoPort;

int[] numCells = new int[2];
StorageCell[][] gridCells;
int[] gridTL = new int[2];
int[] gridBR = new int[2];

int[] gridSize = new int[2];
int[] cellSize = new int[2];
//Measured in cm
double[] gridScale = new double[2];
double[] cellScale = new double[2];

int[] currentClickedCell = new int[2];
int[] newClickedCell = new int[2];

int[] mouseGridRegion = new int[2];
//Gets modulo for mouse position in x and y coords
int[] positionRounding = new int[2];
boolean overGrid = false;
boolean previousClickClearedRegion = true;
boolean previousClickRegionValid = true;
boolean sameRegionClicked = false;

//For data transmission
char[] special_chars = new char[8];

int max_message_length = 32;
char[] message_sent = new char[max_message_length];
String message_string;

char[] response_expected_char = new char[max_message_length];
String response_expected_string;

boolean awaiting_response = false;
boolean response_began = false;
boolean response_corrupted = false;
char[] response_given_char = new char[max_message_length];
String response_given_string;
boolean response_accurate = true;
int response_counter = -1;

void setup(){
  size(362, 562);
  
  gridSize[0] = 260;
  gridSize[1] = 260;
  
  gridScale[0] = 40;
  gridScale[1] = 40;
  
  numCells[0] = 5;
  numCells[1] = 5;
  
  cellSize[0] = 52;
  cellSize[1] = 52;
  
  cellScale[0] = gridScale[0]/numCells[0];
  cellScale[1] = gridScale[1]/numCells[1];
  
  gridTL[0] = 52;
  gridTL[1] = 52;
  
  gridBR[0] = (gridTL[0]+gridSize[0]);
  gridBR[1] = (gridTL[1]+gridSize[1]);
  
  currentClickedCell[0] = -1;
  currentClickedCell[1] = -1;
  newClickedCell[0] = -1;
  newClickedCell[1] = -1;
  
  //Instantiate all the grid cells
  gridCells = new StorageCell[5][5];
  for(int rows = 0; rows < numCells[0]; rows++){
    for(int cols = 0; cols < numCells[1]; cols++){
      int cellTLX = (gridTL[0] + ((rows)*cellSize[0]));
      int cellTLY = (gridTL[1] + ((cols)*cellSize[1]));
      gridCells[rows][cols] = new StorageCell(cellTLX, cellTLY, cellSize[0], cellSize[0], cellScale[0], cellScale[1], "centimeters");
    }
  }
  
  special_chars[0] = (char)(2); //Start of Text
  special_chars[1] = (char)(3); //End of Text
  special_chars[2] = (char)(5); //Enquiry for status
  special_chars[3] = (char)(6); //Acknowledge, affirmative response
  special_chars[4] = (char)(7); //Bell to control alarm/attention
  special_chars[5] = (char)(10); //Line Feed to make new line
  special_chars[6] = (char)(23); //End of data block for segments
  special_chars[7] = (char)(24); //Cancel by saying data is is error 
  //or otherwise should be disregarded
  infoPort = new Serial(this, "/dev/cu.usbmodem146301", 9600);
}

void draw(){
  
  if(!awaiting_response){
    //Refreshes background as white
    background(255);
    
    //Update look for all cells
    //Refreshes cell states
    for(int rows = 0; rows < numCells[0]; rows++){
      for(int cols = 0; cols < numCells[1]; cols++){
        updateCellVisual(rows,cols);
      }
    }
    
    //Gets cell-region values for mouse location
    overGrid = mouseWithinGrid();
    if(mousePressed == true){
      
      //Will update newClickedCell to grid location or -1, -1
      updateClickData(overGrid);
      
      if(overGrid){
              
        //If previous click left with no cell toggled on
        previousClickClearedRegion = ((currentClickedCell[0] == -1) && (currentClickedCell[1] == -1));
        
        //If new click is on same region as old click
        //Note that it only activates the else if condition assuming that the previous click was not outside the region
        //since otherwise the first if condition activates instead.
        sameRegionClicked = ((currentClickedCell[0] == newClickedCell[0]) && (currentClickedCell[1] == newClickedCell[1]));
      
        if(previousClickClearedRegion){
          openRegionClick();
          clickTransmissionData(true);
        } else if(sameRegionClicked){
          sameRegionClick();
          clickTransmissionData(false);
        } else {
          newCellRegionClick();
          clickTransmissionData(true);
        }
        
      } else {
        previousClickRegionValid = ((currentClickedCell[0] != -1) && (currentClickedCell[1] != -1));
        
        if(previousClickRegionValid){
          //To toggle that selection off
          sameRegionClick();
        } else {
          //Do nothing.
        }
        //If the current clicked cell is -1 -1, do nothing
        clickTransmissionData(false);
      }
      
      print("New Cell is = (");
      print(currentClickedCell[0]);
      print(", ");
      print(currentClickedCell[1]);
      println(")");
      delay(100);
      
      message_string = new String(message_sent, 0, 6);
      infoPort.write(message_string);
      println("Sent out code: " + message_string);
      message_string = modifyToExpectedResponse(message_string);
      response_expected_string = message_string;
      println("Expecting response code: " + response_expected_string);
      awaiting_response = true;
      response_began = false;
      response_corrupted = false;
      response_counter = -1;
      println();
    }
  } else {
    
    //Clears all characters in buffer
    //infoPort.clear();
    if(infoPort.available() > 0){
      int new_val = infoPort.read();
      char new_char = (char)(new_val);
      //If new char recieved and message is not already corrupted
      
      if(!response_corrupted){
        response_counter++;
        if(!response_began){ //If response message has not yet started
          response_given_char = new char[max_message_length];
          if(new_char != special_chars[0]){
            //char must be corrupted since stx is not first char recieved.
            response_corrupted = true;
          } else {
            //Add character to string and notify that array started populating
            response_given_char[response_counter] = new_char;
            response_began = true;
          }
        } else if(new_char == special_chars[1]){
          //Terminating symbol has been recieved.
          response_given_char[response_counter] = new_char;
          response_given_string = new String(response_given_char, 0, response_counter);
          
          //Make comparison and print results
          response_matches_expected();
          awaiting_response = false;
          
        } else {
          //Continue populating array with characters.
          response_given_char[response_counter] = new_char;
        }
        
      } else {
        //Do not use new chars, and notify that response corrupted.
        //Until STX is recieved, do nothing
        if(new_char == special_chars[0]){
            //char must be corrupted since stx is not first char recieved.
            response_corrupted = false;
            response_given_char[0] = new_char;
            response_began = true;
        } else {
            println("response is corrupted, awaiting new STX");
        }
      }
      
    }
  }
}







//True if within grid, false if not
boolean mouseWithinGrid(){
  if((mouseX < gridTL[0]) || (mouseX > gridBR[0]))
    return false;
  else if((mouseY < gridTL[1]) || (mouseY > gridBR[1]))
    return false;
  else
    return true;
}

public void updateCellClick(int x, int y){
  gridCells[x][y].updateClickStatus();
}

public void updateCellVisual(int x, int y){
  gridCells[x][y].updateCellVisual();
}

public void updateClickData(boolean withinGrid){
  if(withinGrid){
    positionRounding[0] = mouseX % 50;
    positionRounding[1] = mouseY % 50;

    mouseGridRegion[0] = floor((mouseX-50)/52);
    mouseGridRegion[1] = floor((mouseY-50)/52);
    
    newClickedCell[0] = mouseGridRegion[0];
    newClickedCell[1] = mouseGridRegion[1];
  } else {
    newClickedCell[0] = -1;
    newClickedCell[1] = -1;
  }
    
}

public void openRegionClick(){
    //If the current clicked cell is -1 -1, update
    //to new cell and update new clicked cell.
    //Also works if just initialized code.
    
    currentClickedCell[0] = newClickedCell[0];
    currentClickedCell[1] = newClickedCell[1];
    updateCellClick(currentClickedCell[0], currentClickedCell[1]);
}

public void sameRegionClick(){
    //If clicked on same cell that was previously clicked,
    //toggle the cell to off and set currentcell to -1 -1.
    
    //Same function is used if selecting outside grid
    //when previous click toggled cell on.
    
    updateCellClick(currentClickedCell[0], currentClickedCell[1]);
    currentClickedCell[0] = -1;
    currentClickedCell[1] = -1;
}

public void newCellRegionClick(){
    //If the clicked on cell is a new cell, toggle the current
    //cell to off, toggle the new cell to on,
    //and replace the current cell with the new cell
    
    updateCellClick(currentClickedCell[0], currentClickedCell[1]);
    updateCellClick(newClickedCell[0], newClickedCell[1]);
    currentClickedCell[0] = newClickedCell[0];
    currentClickedCell[1] = newClickedCell[1];
}

public void clickTransmissionData(boolean validCell){
  message_sent[0] = special_chars[0]; //STX
  
  if(validCell){
      //Bounded within grid regions
      message_sent[1] = 'B';
      int row = newClickedCell[0];
      int col = newClickedCell[1];
      message_sent[2] = (char)(row + '0');
      message_sent[3] = (char)(col + '0');
  } else {
      //Not bounded within grid regions
      message_sent[1] = 'U';
      message_sent[2] = '0';
      message_sent[3] = '0';
  }
  
  //Terminator for char array, ETX
  message_sent[4] = special_chars[1];
}

public String modifyToExpectedResponse(String messageString){
    //To show modification of chars
    int string_length = messageString.length(); //Ex. 1) "abcde" is 5
    char[] mod_string_chars = messageString.toCharArray();
    //Ex. 1 part 2) So make for loop go from 0 to 4 inclusive
    for(int index = 0; index < (string_length-1); index++){
      char char_val = mod_string_chars[index];
      //If character is not STX or ETX
      if((char_val != special_chars[0]) && (char_val != special_chars[1])){
        int shift_val = (int)(char_val) + 1;
        mod_string_chars[index] = (char)(shift_val);
      }
    }
    
    String modified_string = new String(mod_string_chars);
    
    return modified_string;
}

public void response_matches_expected(){
  response_accurate = response_given_string.equals(response_expected_string);
  print(response_given_string + " is ");
  if(!response_accurate){
    print("not ");
  }
  println("equal to " + response_expected_string);
  println();
}
