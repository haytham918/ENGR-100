//Objective of current file is to create button grid with 
//interactive image background to show positioning of items.

//Later iterations will have stored data be retrieved from the 
//storage_cell class, but for now is only a toggle system.

import processing.serial.*;
Serial infoPort;
//Reuse concepts from wirelessTest1 but make as image, not background
PImage gridBackground;

int[] numCells = new int[2];
StorageCell[][] gridCells;
int[] cellSize = new int[2];
int[] gridTL = new int[2];
int[] gridBR = new int[2];
int[] gridSize = new int[2];


int[] mouseGridRegion = new int[2];
int[] prevGridRegion = new int[2];
//Gets modulo for mouse position in x and y coords
int[] positionRounding = new int[2];
boolean overGrid = false;

void setup(){
  size(362, 562);
  noCursor();
  strokeWeight(5);
  gridBackground = loadImage("backgroundChess55.png");
  
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
  prevGridRegion[0] = -1;
  prevGridRegion[1] = -1;
  gridBackground.resize(gridSize[0],gridSize[1]);
  
  background(255);
  image(gridBackground, gridTL[0], gridTL[1]);
  //infoPort = new Serial(this, "/dev/cu.usbmodem146301", 9600);
}

void draw(){

  //Updates 10 times a second
  //frameRate(10);
  
  //Make condition for when mouse is outside grid...
  
  stroke(204, 102, 0);
  point(mouseX, mouseY);
  
  overGrid = mouseWithinGrid();
  if(overGrid){
    
    //Update current coordinate position.
    positionRounding[0] = mouseX % 50;
    positionRounding[1] = mouseY % 50;
    
    mouseGridRegion[0] = (mouseX - positionRounding[0] - 50)/50;
    mouseGridRegion[1] = (mouseY - positionRounding[1] - 50)/50;
    
    //First ensure that pointer was not in same position
    //Either x or y coord must be different
    if((prevGridRegion[0] != mouseGridRegion[0]) || (prevGridRegion[1] != mouseGridRegion[1])){
      updateCellRegion(mouseGridRegion[0], mouseGridRegion[1]);
      
      //To ensure neither x or y of prev region are outside bounds
      if((prevGridRegion[0] != -1) && (prevGridRegion[1] != -1)){
        updateCellRegion(prevGridRegion[0], prevGridRegion[1]);
      }
    }
    
    
    //Update previous grid region to now be current grid region (for next loop)
    prevGridRegion[0] = mouseGridRegion[0];
    prevGridRegion[1] = mouseGridRegion[1];
    
  } else {
    mouseGridRegion[0] = -1;
    mouseGridRegion[1] = -1;
    
    if((prevGridRegion[0] != -1) && (prevGridRegion[1] != -1)){
      updateCellRegion(prevGridRegion[0], prevGridRegion[1]);
      prevGridRegion[0] = -1;
      prevGridRegion[1] = -1;
    }
    //Set prevGridRegion to -1 -1 as well.
  }
  //rect((mouseGridRegion[0]+1)*50, (mouseGridRegion[1]+1)*50, 50, 50)
  delay(100);
}

boolean mouseWithinGrid(){
  if((mouseX < gridTL[0]) || (mouseX > gridBR[0]))
    return false;
  else if((mouseY < gridTL[1]) || (mouseY > gridBR[1]))
    return false;
  else
    return true;
}

public void updateCellRegion(int x, int y){
    gridCells[x][y].changeHoveringState();
    gridCells[x][y].updateCellVisual();
}
