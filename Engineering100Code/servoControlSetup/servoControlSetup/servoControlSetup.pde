import processing.serial.*;

Serial infoPort;
//PImage appBackground;
int[] mouseCoords = new int[2];
void setup(){
  size(375, 380);
  //appBackground = loadImage("backgroundChess55.png");
  infoPort = new Serial(this, "/dev/cu.usbmodem146301", 9600);
}

void draw(){
  mouseCoords[0] = mouseX;
  mouseCoords[1] = mouseY;
  //background(appBackground);
  
  if(mouseCoords[0] < 188){
    infoPort.write('1');
  } else {
    infoPort.write('2');
  } 
  
  if(mouseCoords[1] < 190){
    infoPort.write('3');
  } else {
    infoPort.write('4');
  } 
  delay(100);
}
