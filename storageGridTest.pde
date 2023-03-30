//Objective of current file is to create button grid with 
//interactive image background to show positioning of items.

//Later iterations will have stored data be retrieved from the 
//storage_cell class, but for now is only a toggle system.

import processing.serial.*;
Serial infoPort;
//Reuse concepts from wirelessTest1 but make as image, not background


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

StorageCellGrid s = new StorageCellGrid();


void settings() {
  size(s.get_GUIsize()[0], s.get_GUIsize()[1]);
}
void setup(){
  cursor(HAND);
  strokeWeight(5);
  //PImage bground = loadImage(s.get_image());
  s.init_grid_cells();
  //bground.resize(s.get_grid_size()[0],s.get_grid_size()[1]);
  s.clearEverything();
  //background(255);
  //image(s.get_pimage(), s.get_gTopLeft_coords()[0], s.get_gTopLeft_coords()[1]);
  //infoPort = new Serial(this, "/dev/cu.usbmodem146301", 9600);
}

void draw(){
  //Updates 10 times a second
  //frameRate(10);
  
  //Make condition f
  //Updates 10 times a second
  //frameRate(10);
  
  //Make condition for when mouse is outside grid...
  
  stroke(204, 102, 0);
  s.runSimulation();
}
