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









char special_chars[8];
char recieved_char;

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
