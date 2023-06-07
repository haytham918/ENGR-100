import processing.serial.*;

Serial myPort;
PImage appBackground;
boolean onLED = false;
//Serial.list()[6]
void setup(){
  size(374, 380);
  appBackground = loadImage("backgroundChess55.png");
  myPort = new Serial(this, "/dev/cu.usbmodem145201", 9600);
}

void draw(){
  background(appBackground);

  if(mousePressed && (!onLED)){
      myPort.write('1');
      onLED = true;
      delay(100);
  } else if(mousePressed && (onLED)){
      myPort.write('0');
      onLED = false;
      delay(100);
  }
  print(onLED);
}
