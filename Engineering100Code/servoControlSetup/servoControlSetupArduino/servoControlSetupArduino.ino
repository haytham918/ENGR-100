#include <Servo.h>
Servo servoVertical;
Servo servoHorizontal;

const int servoVerticalPin = 8;
const int servoHorizontalPin = 7;

void setup() {
  // put your setup code here, to run once:
  servoVerical.attach(servoVerticalPin);
  servoHorizontal.attach(servoHorizontalPin);
  Serial.begin(9600);
}


// If sent '1', left.
// '2', middle.
// '3', right.
void loop() {
  // put your main code here, to run repeatedly:
  digitalWrite(ledTL, LOW);
  digitalWrite(ledTR, LOW);
  digitalWrite(ledBL, LOW);
  digitalWrite(ledBR, LOW);
  if(Serial.available() > 0){
     char ledPinState = Serial.read();
     
     if(ledPinState == '1'){ //Up
      digitalWrite(ledTL, HIGH);
      digitalWrite(ledTR, LOW);
     }else if(ledPinState == '2'){ //Down
      digitalWrite(ledTL, LOW);
      digitalWrite(ledTR, HIGH);
     }
     
     if(ledPinState == '3'){ //Left
      digitalWrite(ledBL, HIGH);
      digitalWrite(ledBR, LOW);
     }else if(ledPinState == '4'){ //Right
      digitalWrite(ledBL, LOW);
      digitalWrite(ledBR, HIGH);
     } 
  }
}
