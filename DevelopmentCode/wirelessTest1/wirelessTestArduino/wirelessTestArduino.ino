const int ledPin = 13;

void setup() {
  // put your setup code here, to run once:
  pinMode(ledPin, OUTPUT);
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
  if(Serial.available() > 0){
     char ledPinState = Serial.read();
     Serial.print(ledPinState);
     if(ledPinState == '1'){
      digitalWrite(ledPin, HIGH);
     }
     if(ledPinState == '0'){
      digitalWrite(ledPin, LOW);
     }
  }
}
