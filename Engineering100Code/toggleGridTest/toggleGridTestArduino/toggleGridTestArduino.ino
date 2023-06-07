const int ledTL = 13;
const int ledTR = 11;
const int ledBL = 10;
const int ledBR = 9;

void setup() {
  // put your setup code here, to run once:
  pinMode(ledTL, OUTPUT);
  pinMode(ledTR, OUTPUT);
  pinMode(ledBL, OUTPUT);
  pinMode(ledBR, OUTPUT);
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
     if(ledPinState == '1'){
      digitalWrite(ledTL, HIGH);
      digitalWrite(ledTR, LOW);
     }else if(ledPinState == '2'){
      digitalWrite(ledTL, LOW);
      digitalWrite(ledTR, HIGH);
     }
     if(ledPinState == '3'){
      digitalWrite(ledBL, HIGH);
      digitalWrite(ledBR, LOW);
     }else if(ledPinState == '4'){
      digitalWrite(ledBL, LOW);
      digitalWrite(ledBR, HIGH);
     } 
  }
}
