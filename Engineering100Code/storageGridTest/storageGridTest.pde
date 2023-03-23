//Objective of current file is to create button grid with 
//interactive image background to show positioning of items.

//Later iterations will have stored data be retrieved from the 
//storage_cell class, but for now is only a toggle system.

import processing.serial.*;
Serial infoPort;
//Reuse concepts from wirelessTest1 but make as image, not background
PImage gridBackground;
PImage whiteCovering;

int[] numCells = new int[2];
StorageCell[][] gridCells;
int[] cellSize = new int[2];
int[] gridTL = new int[2];
int[] gridBR = new int[2];
int[] gridSize = new int[2];

int[] fromPosition= new int[2];
int[] destPosition = new int[2];

boolean withGrid = false;

enum ModeState{
   Unknown,
   Reallocation,
   Retrieval,
   Storing
}

enum ReallocationState {
   Initialize,
   PickedFrom,
   PickedDest
}

enum RetrievalState {
   Initialize,
   PickedRetrievalPos
}

enum StoringState {
   Initialize,
   PickedStoringPos
}

enum confirmationState {
   Yes,
   No,
   Unknown 
}

ReallocationState realloc = ReallocationState.Initialize;
RetrievalState retrieval = RetrievalState.Initialize;
StoringState storing = StoringState.Initialize;
ModeState mode = ModeState.Unknown;

void setup(){
  size(362, 562);
  cursor(HAND);
  strokeWeight(5);
   
  gridBackground = loadImage("backgroundChess55.png");
  whiteCovering = loadImage("whiteImage.png");
  whiteCovering.resize(280, 100);
  gridSize[0] = 262;
  gridSize[1] = 262;
  
  numCells[0] = 5;
  numCells[1] = 5;
  
  cellSize[0] = (gridSize[0]/numCells[0]);
  cellSize[1] = (gridSize[1]/numCells[1]);
  
  gridTL[0] = 50;
  gridTL[1] = 50;
  
  gridBR[0] = (gridTL[0]+gridSize[0]);
  gridBR[1] = (gridTL[1]+gridSize[1]);
  
  //Instantiate all the grid cells
  gridCells = new StorageCell[(numCells[0])][(numCells[1])];
  for(int rows = 0; rows < numCells[0]; rows++){
    for(int cols = 0; cols < numCells[1]; cols++){
      int cellTLX = (gridTL[0] + (cellSize[0]*rows));
      int cellTLY = (gridTL[1] + (cellSize[1]*cols));
      gridCells[rows][cols] = new StorageCell(cellTLX, cellTLY, cellSize[0], cellSize[1]);
    }
  }
  gridBackground.resize(gridSize[0],gridSize[1]);
  
  background(255);
  image(gridBackground, gridTL[0], gridTL[1]);
  modeSelection();
  fillOrigin();
  //infoPort = new Serial(this, "/dev/cu.usbmodem146301", 9600);
}

void draw(){

  //Updates 10 times a second
  //frameRate(10);
  
  //Make condition for when mouse is outside grid...
  
  stroke(204, 102, 0);
  withGrid = mouseWithinGrid();
  if(mode == ModeState.Reallocation)
     ReallocationMode();
  
  delay(80);
}

boolean mouseWithinGrid(){
  if((mouseX < gridTL[0]) || (mouseX > gridBR[0]))
    return false;
  else if((mouseY < gridTL[1]) || (mouseY > gridBR[1]))
    return false;
  else
    return true;
}

confirmationState clickedYes()
{
  
    if(mousePressed && mouseX >= 250 && mouseX <= 315 && mouseY >= 380 && mouseY <= 405)
      return confirmationState.No;
    if(mousePressed && mouseX >= 45 && mouseX <= 105 && mouseY >= 380 && mouseY <= 405)
      return confirmationState.Yes;
      
    return confirmationState.Unknown;
}

public void clearEverything()
{
    for(int rows = 0; rows < numCells[0]; rows++){
      for(int cols = 0; cols < numCells[1]; cols++){
      gridCells[rows][cols].setToggleDefault();
    }
    background(255);
    image(gridBackground, gridTL[0], gridTL[1]);
    tint(50);
    
  }
  
}

public void createConfirmation()
{
    fill(85);
    textSize(23);
    text("Confirm the Position?", 85, 350);
    fill(203, 208, 178);
    rect(45, 380, 60, 25);
    fill(209, 208, 178);
    rect(250, 380, 60, 25);
    fill(45);
    textSize(20);
    text("YES", 60, 400);
    textSize(20);
    text("NO", 270, 400);
  
}



public void updateFromRegion(int x, int y){
    int indexRow = ((x-12) / 50) - 1;
    int indexCol = ((y-12) / 50) - 1;
    fromPosition[0] = indexRow;
    fromPosition[1] = indexCol;
    gridCells[indexRow][indexCol].changeFromState();
    
}

public void updateDestRegion(int x, int y){
    int indexRow = ((x-12) / 50) - 1;
    int indexCol = ((y-12) / 50) - 1;
    destPosition[0] = indexRow;
    destPosition[1] = indexCol;
    gridCells[indexRow][indexCol].changeDestState();
  
}

public ModeState modeSelection(){
    fill(55);
    textSize(23);
    text("Select the mode", 100, 350);
    fill(235, 227, 174);
    rect(30, 380, 90, 25);
    fill(235, 227, 174);
    rect(250, 380, 90, 25);
    fill(235, 227, 174);
    rect(140, 380, 90, 25);
    fill(193, 11, 230);
    textSize(15);
    text("Reallocation", 36, 398);
    text("Storing", 275, 398);
    text("Retrieval", 158, 398);
    return ModeState.Unknown;
}

public void fillOrigin()
{
   fill(255, 255, 255);
   int originX = 52;
   int originY = 258;
   rect(originX, originY, 50, 50);
  
}

public void ReallocationMode()
{

if(withGrid && mousePressed)
  {
    if(realloc == ReallocationState.Initialize)
    {
       updateFromRegion(mouseX, mouseY);
    }
    else if(realloc == ReallocationState.PickedFrom)
    {
      updateDestRegion(mouseX, mouseY);
    }

  }
  else if(realloc == ReallocationState.Initialize)
  {
      confirmationState confirm = clickedYes();
      if(confirm == confirmationState.No)
      {
         clearEverything();
         realloc = ReallocationState.Initialize;
         System.out.println("Please pick a position");
      }
      else if(confirm == confirmationState.Yes)
      {
         System.out.println("Now Choose the Destination");
         realloc = ReallocationState.PickedFrom;
         tint(255);
         image(whiteCovering, 35, 330);
      }
  }
  else if(realloc == ReallocationState.PickedFrom)
  {
      confirmationState confirm = clickedYes();
      if(confirm == confirmationState.No)
      {
         clearEverything();
         realloc = ReallocationState.PickedFrom;
         gridCells[fromPosition[0]][fromPosition[1]].setToggleTrue();
         gridCells[fromPosition[0]][fromPosition[1]].updateCellVisual();
         System.out.println("Please pick a position");
      }
      else if(confirm == confirmationState.Yes)
      {
         realloc = ReallocationState.PickedDest;
         tint(255);
         image(whiteCovering, 35, 330);
      }
  }
}

public void RetrievalMode()
{
  
}
