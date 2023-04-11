const int ledPinLeft = 13;
const int ledPinMiddle = 11;
const int ledPinRight = 10;

void setup() {
  // put your setup code here, to run once:
  pinMode(ledPinLeft, OUTPUT);
  pinMode(ledPinMiddle, OUTPUT);
  pinMode(ledPinRight, OUTPUT);
  Serial.begin(9600);
}


// If sent '1', left.
// '2', middle.
// '3', right.
void loop() {
  // put your main code here, to run repeatedly:
  if(Serial.available() > 0){
     char ledPinState = Serial.read();
     if(ledPinState == '1'){
      digitalWrite(ledPinLeft, HIGH);
      digitalWrite(ledPinMiddle, LOW);
      digitalWrite(ledPinRight, LOW);
     } else if(ledPinState == '2'){
      digitalWrite(ledPinLeft, LOW);
      digitalWrite(ledPinMiddle, HIGH);
      digitalWrite(ledPinRight, LOW);
     } else if(ledPinState == '3'){
      digitalWrite(ledPinLeft, LOW);
      digitalWrite(ledPinMiddle, LOW);
      digitalWrite(ledPinRight, HIGH);
     } 
  }
}
