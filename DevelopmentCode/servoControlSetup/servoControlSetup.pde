import processing.serial.*;

Serial infoPort;
//PImage appBackground;
int[] mouseCoords = new int[2];
boolean movementOn = false;

void setup(){
  size(375, 380);
  //appBackground = loadImage("backgroundChess55.png");
  infoPort = new Serial(this, "/dev/cu.usbmodem146301", 9600);
}

void draw(){
  mouseCoords[0] = mouseX;
  mouseCoords[1] = mouseY;
  //background(appBackground);
  if(mousePressed && (!movementOn)){
      infoPort.write('0');
      movementOn = true;
      print("Active");
  }else if(mousePressed && (movementOn)){
      infoPort.write('0');
      movementOn = false;
      print("Inactive");
      delay(100);
  }
  if(movementOn){
    if(mouseCoords[0] <= 188){ //Left
      print("Left");
      if(mouseCoords[1] <= 190){ //Up
        print("Up");
        infoPort.write('1');
      } else { //Down
        //print("Down");
        infoPort.write('2');
      } 
    } else { //Right
      //print("Right");
      if(mouseCoords[1] <= 190){//Up
        //print("Up");
        infoPort.write('3');
      } else { //Down
        //print("Down");
        infoPort.write('4');
      } 
    } 
    delay(100);
  }
}
