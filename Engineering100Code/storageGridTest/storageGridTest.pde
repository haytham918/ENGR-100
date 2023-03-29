//RECOGNIZING ZERO PROTOCOL SPECIAL CHARS
//#define NUL 0x00;
//Look into potential methods for interpreting ascii characters 
//for 2 way serial connection.
//DO NOT SHOEHORN INTO ASCII
import processing.serial.*;
Serial infoPort;
//Reuse concepts from wirelessTest1 but make as image, not background
PImage gridBackground;

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

boolean transmittingData = false;
boolean stage1ConfirmationRecieved = false;
boolean resendOnTimer = false;

int transmissionCounter = 0;

byte[] message = new byte[10];

byte[] exception = new byte[1];

char[] confirmChars = new char[8];

//NOTE, REMOVING FUNCTIONALITY OF TOGGLE AND PREVIOUS CELL
void setup(){
  size(362, 562);
  gridBackground = loadImage("backgroundChess55.png");
  exception[0] = 0x00;
  
  confirmChars[0] = 'a';
  confirmChars[1] = 'c';
  confirmChars[2] = 't';
  confirmChars[3] = 'i';
  confirmChars[4] = 'v';
  confirmChars[5] = 'a';
  confirmChars[6] = 't';
  confirmChars[7] = 'e';
  
  message[0] = 0x30;
  message[1] = 0x31;
  message[2] = 0x32;
  message[3] = 0x33;
  message[4] = 0x34;
  message[5] = 0x35;
  message[6] = 0x36;
  message[7] = 0x37;
  message[8] = 0x38;
  message[9] = 0x39;
  
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
      print("(");
      int cellTLX = (gridTL[0] + ((rows)*cellSize[0]));
      int cellTLY = (gridTL[1] + ((cols)*cellSize[1]));
      print(cellTLX);
      print(",");
      print(cellTLY);
      print(") ");
      gridCells[rows][cols] = new StorageCell(cellTLX, cellTLY, cellSize[0], cellSize[0], cellScale[0], cellScale[1], "centimeters");
    }
    println();
  }
  
  gridBackground.resize(gridSize[0],gridSize[1]);
  infoPort = new Serial(this, "/dev/cu.usbmodem146301", 9600);
}

void draw(){
  
  if(!transmittingData){
    background(255);
    image(gridBackground, gridTL[0], gridTL[1]);
    
    //Update look for all cells
    for(int rows = 0; rows < numCells[0]; rows++){
      for(int cols = 0; cols < numCells[1]; cols++){
        updateCellVisual(rows,cols);
      }
    }
    
    //Gets cell-region values for mouse location
    overGrid = mouseWithinGrid();
    
    if(mousePressed == true){
      print("Current Coords are = (");
      print(mouseX);
      print(", ");
      print(mouseY);
      println(")");
      
      print("Current Cell is = (");
      print(currentClickedCell[0]);
      print(", ");
      print(currentClickedCell[1]);
      println(")");
      
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
        
      }
      
      print("New Cell is = (");
      print(currentClickedCell[0]);
      print(", ");
      print(currentClickedCell[1]);
      println(")");
      println();
      delay(100);
      //transmittingData = true;
    }
  }
  //} else {
  ////Data is being transmitted, would execute multiple loops of data sending
  ////and confirming to and from arduino and processing. Stages are as follows:
  //  println();
  //  println();
  //  print("begin transmission:");
    
  ////Stage 1: Send data over to the arduino
  //  //transmittingData = false;
  //  stage1ConfirmationRecieved = false;
  //  //Note, that in this stage, data is not being
  //  //Inital message sent
  //  sendMoveRequest(0);
  //  println("request sent out for move data");
  //  while(!stage1ConfirmationRecieved){
      
  //    //Timer to resend byte
  //    if(!resendOnTimer){
  //      //Want to create a timed function call that activates in 1 second
        
  //      //void sendMoveDataID = setTimeout(function(){
  //      //  sendMoveRequest(0);
  //      //  println("request sent out for move data");
  //      //  resendOnTimer = false;
  //      //  //Will be sent in 1 second
  //      //}, 2000);
  //      resendOnTimer = true;
  //    }
      
  //    //clearTimeout
  //    if(infoPort.find(confirmChars[0]) == true){
  //      stage1ConfirmationRecieved = true;
  //      println("data transmission confirmed!!!!");
  //      //clearTimeout(sendMoveDataID);
  //    }
  //  }
  //}
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

//Note, sends over the same 1-digit item.
//Will be updated to vary based on previous position data 
//and requested position to move to
public void sendMoveRequest(int itemMarker){
  if((itemMarker <= 9) && (itemMarker >= 0)){
    infoPort.write(message[itemMarker]);
  }else{
    infoPort.write(exception[0]);
    print("byte request out of bounds");
  }
}
