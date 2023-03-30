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
boolean uninitializedGridSelections = true;

int msg_length = 4;
char[] message_sent = new char[msg_length];
String message_string;

char[] response_expected_char = new char[msg_length-1];
String response_expected_string;

boolean awaiting_response = false;
char[] response_given_char = new char[msg_length-1];;
String response_given_string;
boolean response_accurate = true;

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
  
  infoPort = new Serial(this, "/dev/cu.usbmodem146301", 9600);
}

void draw(){
  
  if(!awaiting_response){
    background(255);
    
    //Update look for all cells
    for(int rows = 0; rows < numCells[0]; rows++){
      for(int cols = 0; cols < numCells[1]; cols++){
        updateCellVisual(rows,cols);
      }
    }
    
    //Gets cell-region values for mouse location
    overGrid = mouseWithinGrid();
    
    if(mousePressed == true){
      if(overGrid){
        
        //Update current coordinate position.
        positionRounding[0] = mouseX % 50;
        positionRounding[1] = mouseY % 50;
  
        mouseGridRegion[0] = floor((mouseX-50)/52);
        mouseGridRegion[1] = floor((mouseY-50)/52);
        
        newClickedCell[0] = mouseGridRegion[0];
        newClickedCell[1] = mouseGridRegion[1];
  
        if(uninitializedGridSelections){
          //If no previous cell has been chosen.
          currentClickedCell[0] = newClickedCell[0];
          currentClickedCell[1] = newClickedCell[1];
          updateCellClick(currentClickedCell[0], currentClickedCell[1]);
          uninitializedGridSelections = false;
        }else if((currentClickedCell[0] == -1) && (currentClickedCell[1] == -1)){
          //If the current clicked cell is -1 -1, update
          //to new cell and update new clicked cell
          
          currentClickedCell = newClickedCell;
          updateCellClick(currentClickedCell[0], currentClickedCell[1]);
        } else if((currentClickedCell[0] == newClickedCell[0]) && (currentClickedCell[1] == newClickedCell[1])){
          //If clicked on same cell that was previously clicked,
          //toggle the cell to off and set currentcell to -1 -1.
          
          updateCellClick(currentClickedCell[0], currentClickedCell[1]);
          currentClickedCell[0] = -1;
          currentClickedCell[1] = -1;
          uninitializedGridSelections = true;
        } else {
          //If the clicked on cell is a new cell, toggle the current
          //cell to off, toggle the new cell to on,
          //and replace the current cell with the new cell
          
          updateCellClick(currentClickedCell[0], currentClickedCell[1]);
          updateCellClick(newClickedCell[0], newClickedCell[1]);
          currentClickedCell[0] = newClickedCell[0];
          currentClickedCell[1] = newClickedCell[1];
        }
        
        //Bounded within grid regions
        message_sent[0] = 'B';
        message_sent[1] = (char)(currentClickedCell[0]);
        message_sent[2] = (char)(currentClickedCell[1]);
      } else {
        
        newClickedCell[0] = -1;
        newClickedCell[1] = -1;
        
        if((currentClickedCell[0] != -1) && (currentClickedCell[1] != -1)){
          //If the current clicked cell is a real index, toggle off
          //and replace with -1 -1
          updateCellClick(currentClickedCell[0], currentClickedCell[1]);
          currentClickedCell[0] = -1;
          currentClickedCell[1] = -1;
          uninitializedGridSelections = true;
        }
        //If the current clicked cell is -1 -1, do nothing
        
        //Not bounded within grid regions
        message_sent[0] = 'U';
        message_sent[1] = '0';
        message_sent[2] = '0';
      }
      
      print("New Cell is = (");
      print(currentClickedCell[0]);
      print(", ");
      print(currentClickedCell[1]);
      println(")");
      println();
      delay(100);
      
      //Terminator for char array
      message_sent[3] = '\0';
      message_string = new String(message_sent);
      infoPort.write(message_string);
      awaiting_response = true;
      
      //Gets 1st to 3rd chars in message, to ignore terminator
      for(int index = 0; index < response_expected_char.length; index++){
        response_expected_char[index] = (char)(message_sent[index] + 1);
      }
      response_expected_string = new String(response_expected_char);
      println("Expected string : " + response_expected_string);
    }
  } else {
      while(awaiting_response){
        if(infoPort.available() > 0){
          response_given_string = infoPort.readStringUntil('\0');
          response_given_char = response_given_string.toCharArray();
          
          //Clears all characters in buffer
          infoPort.clear();
          
          //Goes through all items in array.
          for(int index = 0; index < response_given_char.length; index++){
            response_given_char[index] = (char)(response_given_char[index] + 1);
          }
          response_given_string = new String(response_given_char);
          
          awaiting_response = false;
        }
      }
      
      response_accurate = response_given_string.equals(response_expected_string);
      println(response_given_string + " is:");
      if(!response_accurate){
        print("NOT ");
      }
      println("EQUAL TO " + response_expected_string);
      println();
  }
}

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
