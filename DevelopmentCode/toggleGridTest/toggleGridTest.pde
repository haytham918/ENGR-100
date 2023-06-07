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
  
  if(mouseCoords[0] < 125){
    infoPort.write('1');
    delay(100);
  } else if(mouseCoords[0] > 250){
    infoPort.write('3');
    delay(100);
  } else {
    infoPort.write('2');
    delay(100);
  }
}
