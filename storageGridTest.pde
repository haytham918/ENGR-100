//Objective of current file is to create button grid with 
//interactive image background to show positioning of items.

//Later iterations will have stored data be retrieved from the 
//storage_cell class, but for now is only a toggle system.

import processing.serial.*;
Serial infoPort;
//Reuse concepts from wirelessTest1 but make as image, not background
PImage bground;

StorageCellGrid s = new StorageCellGrid();

int[] mouseGridRegion = new int[2];
//Gets modulo for mouse position in x and y coords
int[] positionRounding = new int[2];
boolean overGrid = false;



void setup(){
  size(362, 562);
  noCursor();
  strokeWeight(5);
  bground = loadImage("backgroundChess55.png");
  s.init_grid_cells();
  bground.resize(s.get_grid_size()[0],s.get_grid_size()[1]);
  background(255);
  image(bground, s.get_gTopLeft_coords()[0], s.get_gTopLeft_coords()[1]);
  //infoPort = new Serial(this, "/dev/cu.usbmodem146301", 9600);
}

void draw(){
  //Updates 10 times a second
  //frameRate(10);
  
  //Make condition f
  print(s.get_prevGridReg()[0]);
  print(s.get_prevGridReg()[1]);
  
  overGrid = s.mouseWithinGrid();
  if(overGrid){
    
    //Update current coordinate position.
    positionRounding[0] = mouseX % 50;
    positionRounding[1] = mouseY % 50;
    
    mouseGridRegion[0] = (mouseX - positionRounding[0] - 50)/50;
    mouseGridRegion[1] = (mouseY - positionRounding[1] - 50)/50;
    
    //First ensure that pointer was not in same position
    //Either x or y coord must be different
    if((s.get_prevGridReg()[0] != mouseGridRegion[0]) || (s.get_prevGridReg()[1] != mouseGridRegion[1])){
      s.updateCellRegion(mouseGridRegion[0], mouseGridRegion[1]);
      
      //To ensure neither x or y of prev region are outside bounds
      if((s.get_prevGridReg()[0] != -1) && (s.get_prevGridReg()[1] != -1)){
        s.updateCellRegion(s.get_prevGridReg()[0], s.get_prevGridReg()[1]);
      }
    }
    
    
    //Update previous grid region to now be current grid region (for next loop)
    s.get_prevGridReg()[0] = mouseGridRegion[0];
    s.get_prevGridReg()[1] = mouseGridRegion[1];
    
  } else {
    mouseGridRegion[0] = -1;
    mouseGridRegion[1] = -1;
    
    if((s.get_prevGridReg()[0 ] != -1) && (s.get_prevGridReg()[1] != -1)){
      s.updateCellRegion(s.get_prevGridReg()[0], s.get_prevGridReg()[1]);
      s.get_prevGridReg()[0] = -1;
      s.get_prevGridReg()[1] = -1;
    }
    //Set prevGridRegion to -1 -1 as well.
  }
  //rect((mouseGridRegion[0]+1)*50, (mouseGridRegion[1]+1)*50, 50, 50)
  delay(100);
}
