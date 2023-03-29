

// Define pin connections & motor's steps per revolution
const int dirPin = 6;
const int stepPin = 3;
const int en = 8;
const int stepsPerRevolution = 200;
//blue to blue
//black and blue inside
//brown closest to z

void setup()
{
	// Declare pins as Outputs
   Serial.begin(9600);
  pinMode(en, OUTPUT);
	pinMode(stepPin, OUTPUT);
	pinMode(dirPin, OUTPUT);
  digitalWrite(en, LOW);   
  digitalWrite(dirPin, LOW);
}

void loop()
{
digitalWrite(stepPin, HIGH); 
delay(5);
digitalWrite(stepPin, LOW);
delay(5);
digitalWrite(stepPin, HIGH); 
delay(5);
digitalWrite(stepPin, LOW);
Serial.print("it is working\n");
// 	// Set motor direction clockwise
// 	digitalWrite(dirPin, HIGH);

// 	// Spin motor slowly
// 	for(int x = 0; x < stepsPerRevolution; x++)
// 	{
// 		digitalWrite(stepPin, HIGH);
// 		delayMicroseconds(2000);
// 		digitalWrite(stepPin, LOW);
// 		delayMicroseconds(2000);
// 	}
// 	delay(1000); // Wait a second
	
// 	// Set motor direction counterclockwise
// 	digitalWrite(dirPin, LOW);

// 	// Spin motor quickly
// 	for(int x = 0; x < stepsPerRevolution; x++)
// 	{
// 		digitalWrite(stepPin, HIGH);
// 		delayMicroseconds(1000);
// 		digitalWrite(stepPin, LOW);
// 		delayMicroseconds(1000);
// 	}
// 	delay(1000); // Wait a second
}
