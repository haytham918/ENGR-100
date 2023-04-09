//OP states:
/*
SETUP:
Retrieve EEPROM data, store contents in 2d arrays
-Names of the items (store as encrypted String)
-Occupation state of cells (2 is origin, 1 is full, 0 in empty)
Should be stored as string and int using Struct format.

Note that Arduino UNO has 1024 bytes worth of storage space...
May need an SD card, talk with Derrick.
https://forum.arduino.cc/t/storing-names-and-numbers-to-keep-after-powerdown/322420/2
*/

//SETUP PRESETS
const int row_number = 5;
const int col_number = 5;
const int cell_width = 8; //In cm, going across columns
const int cell_height = 8; //In cm, going across rows

boolean idle_stage = true;
//https://hackingmajenkoblog.wordpress.com/2016/02/04/the-evils-of-arduino-strings/
//const char* cellOccupation[row_number][col_number];
char*[,]  cell_occu;

boolean receiving_stage = false;
boolean calculating_stage = false;
boolean executing_stage = false;
boolean exec_backtracking = false;



float current_x;
float current_y;
int step_stage = 0;
int final_stage = 2;
double steps_claw[6];
double steps_xy[6][4];

boolean new_message_processing;

const int max_message_length = 32;
char message_recieved_char[max_message_length];
int message_recived_counter = 0;

char response_sent[max_message_length];
String response_string;

char special_chars[8];
char recieved_char;

void notify_state(boolean isOpenForData);

void setup()
{
	// Declare pins as Outputs
  Serial.begin(9600);
  special_chars[0] = (char)(2); //Start of Text
  special_chars[1] = (char)(3); //End of Text
  special_chars[2] = (char)(5); //Enquiry for status
  special_chars[3] = (char)(6); //Acknowledge, affirmative response
  special_chars[4] = (char)(7); //Bell to control alarm/attention
  special_chars[5] = (char)(10); //Line Feed to make new line
  special_chars[6] = (char)(23); //End of data block for segments
  special_chars[7] = (char)(24); //Cancel by saying data is is error 
  //or otherwise should be disregarded
  
  Serial.flush();
  //new_message_processing = false;

  //Retrieve data from EEPROM.
  //If EEPROM struct "updated_indicator" 
  //has it's boolean variable initialized == false;
  //Then make request to computer to initialize data.
  
}

void loop()
{
    if(Serial.available() > 0){
      recieved_char = Serial.read();
    }
}

void notify_state(boolean isOpenForData){
  char state_message[5]; 
  state_message[0] = special_chars[0];
  state_message[1] = (char)(64);
  state_message[2] = special_chars[2];
  if(isOpenForData){
    state_message[3] = 'T';
  } else {
    state_message[3] = 'F';
  }
  state_message[4] = special_chars[1];
  //Message is ['STX', '@', 'ENQ', 'T' or 'F', 'ETX'];
  //True is open, False is closed
  
  Serial.println(state_message);
}


  
//  //Clear the buffer and notify computer that it is
//  //primed to recieve new messages
//  notify_state(true);
//  Serial.flush();
//  
//  //Reset state to look for a new message
//  new_message_processing = false;
//  message_recived_counter = 0;
//
//  //While a new message has not been found,
//  //scan for incoming data
//  while(!new_message_processing){
//    if(Serial.available() > 0){
//      message_recived_counter++;
//      //Assuming that first char sent is STX
//      //For start of transmission
//      char new_byte = Serial.read();
//
//      //For now, assume the message_recieved counter is less than 32
//      //Since if it is equal or greater than 32, it would be storing to
//      //Out of bounds index in array
//      message_recieved_char[message_recived_counter-1] = new_byte;
//      //If ETX found, stop reading new data
//      if(new_byte == special_chars[1]){
//        new_message_processing = true;
//      }
//    }
//  }
//  //At this point, the full message sent over, including '\0'
//
//  //Notify computer that it is
//  //closed off to new messages
//  notify_state(true);
//  
//  //Wait a small amount of time before clearning buffer
//  delay(15);
//  Serial.flush();
//
//  //Go through all items in the array and modify them to shift up 1
//  //If special char found, do not modify
//  for(int index = 0; index < message_recived_counter; index++){
//    if(message_recieved_char[index] == special_chars[0]){
//      //Do not modify STX
//      response_sent[index] = message_recieved_char[index];
//    } else if (message_recieved_char[index] == special_chars[0]){
//      //Do not modify ETX
//      response_sent[index] = message_recieved_char[index];
//    } else {
//      response_sent[index] = (char)(message_recieved_char[index] + 1);
//    }
//  }
//
//  Serial.println(response_string);
