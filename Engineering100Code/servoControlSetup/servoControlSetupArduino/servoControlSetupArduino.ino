#include <Servo.h>
Servo servoVertical;
Servo servoHorizontal;

const int servoVerticalPin = 8;
int verticalAngle = 0;
int turningLeft = 1;
//When positive 1, angle increases to left.
//When negative 1, angle decreases to right.
const int servoHorizontalPin = 7;
int horizontalAngle = 0;
int turningUp = 1;
//When positive 1, angle increases upward.
//When negative 1, angle decreases downward.
boolean continueOperating = true;

void setup() {
  // put your setup code here, to run once:
  servoVertical.attach(servoVerticalPin);
  servoVertical.write(verticalAngle);
  servoHorizontal.attach(servoHorizontalPin);
  servoHorizontal.write(horizontalAngle);
  Serial.begin(9600);
}


//Note, due to configuration of how the servos work,
//Rotation does not occur when in the bottom or the right for
//the respective vertical and horizontal motors.

//This is due to how the servo configurations do not align
//with the angles of 0 to 180.
//Rather, the origin lies at 90, so subtracting from the angle
//does not work in a typical manner.

//As a proof of concept and trial phase, the main benefit of this 
//work is to show interactivity and identify servo compatibility.

//Next stage is to send larger packets of data through processing
//to provide scalable movement to the servos, which can be done easily.




void loop() {
    if(Serial.available() > 0){
       char mouseState = Serial.read();
       //Set based on click. When clicked, toggle operation.
       if(mouseState == '0'){
          if(continueOperating)
            continueOperating = false;
          else
            continueOperating = true;
       }else if(continueOperating){
         if(mouseState == '1'){ //Top Left
            turningLeft = 1;
            turningUp = 1;
         }else if(mouseState == '2'){ //Bottom Left
            turningLeft = 1;
            turningUp = -1;
         }else if(mouseState == '3'){ //Top Right
            turningLeft = -1;
            turningUp = 1;
         }else if(mouseState == '4'){ //Bottom Right
            turningLeft = -1;
            turningUp = -1;
         }else{ //Error message, so do nothing
            turningLeft = 0;
            turningUp = 0;
         }
         
         if((turningLeft != 0) && (turningUp != 0)){ 
           if(abs(verticalAngle + 15*turningUp) < 180){
              verticalAngle += 15*turningUp;
              servoVertical.write(verticalAngle);
           }else{
              verticalAngle = 0;
              servoVertical.write(verticalAngle);
           }
           
           if(abs(horizontalAngle + 15*turningLeft) < 180){
              horizontalAngle += 15*turningLeft;
              servoHorizontal.write(horizontalAngle);
           }else{
              horizontalAngle = 0;
              servoHorizontal.write(horizontalAngle);
           }
         } else {
            horizontalAngle = 0;
            servoHorizontal.write(horizontalAngle);
            verticalAngle = 0;
            servoVertical.write(verticalAngle);
         }
       }
    }
}
