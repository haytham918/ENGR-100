boolean new_message_processing = false;

char message_recieved_char[3];
String message_recieved_string;

char response_sent[3];
String response_string;

void setup()
{
	// Declare pins as Outputs
  Serial.begin(9600);
}

void loop()
{
  while(!new_message_processing){
    if(Serial.available() > 0){
      //Note, does not include '\0'
      message_recieved_string = Serial.readStringUntil('\0');
      message_recieved_string.toCharArray(message_recieved_char, 3);
      new_message_processing = true;
      
      Serial.flush();
    }
  }

  for(int index = 0; index < 3; index++){
    response_sent[index] = (char)(message_recieved_char[index] + 1);
  }

  
  Serial.println(response_string);

}
