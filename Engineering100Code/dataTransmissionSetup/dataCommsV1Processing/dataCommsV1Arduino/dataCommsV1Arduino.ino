#include <string.h>
#include <stdint.h>

const int rows = 5;
const int cols = 5;
const int row_scale = 8; //Scale to be num of revs per cell vertically
const int col_scale = 8; //Scale to be num of revs per cell horizontally

//When transmitting numbers over serial, need to add 64 to vals to prevent
//confusion with control chars. Thus, store as uint8_t, 
//and add 64 later to convert

//int = 1 is open
//int = 2 is closed
//If int > 2, then changed state
//int = 3 is changed to open
//int = 4 is changed to closed
uint8_t cell_status[rows][cols];

int num_cells = rows*cols;
const int max_name_length = 16;
char[num_cells][max_name_length];


boolean is_idle;
boolean new_message_processing;
boolean corrupted_message;
boolean completed_message;

const int max_message_length = 32;
char message_recieved_char[max_message_length];
int message_recieved_counter;

char response_sent[max_message_length];
String response_string;

char special_chars[8];
char recieved_char;

const char allowed_idle_id_chars[6] = {'S', 'P', 'R', 'C', 'G', 'A'};
const char allowed_active_id_chars[2] = {'E', 'A'};

//S is swap
//P is place
//R is retrieve
//C is cell changes (manual)
//G is grid state
//A is operation state
//E is emergency stop

char action_type;




void notify_state(boolean isOpenForData);
boolean length_matches_command_format(char command_type, int end_index);
bool command_suitable_for_mode(char recieved_char);
void process_message_step(char recieved_char);
void corrupt_message_clear();
void setup_starting_command(char action);
void op_state_query(); //'A' command


void setup(){
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
  new_message_processing = false;
  corrupted_message = false;
  is_idle = true;
  completed_message = false;
  //is_action_modifying = false;
  message_recieved_counter = 0;
  
}

void loop()
{
    if(Serial.available() > 0){
      recieved_char = Serial.read();
      process_message_step(recieved_char);
      
      if(completed_message){

        action_type =  message_recieved_char[1];
        
        //Calculation steps occur now.
        //Since we already know if the command is suitable for the mode
        //and that the command length is appropriate, 
        //we can execute the command directly via a function.
        
        //At the end of this phase, turn completed_message off
        //We also reset the counter for message recieved, 
        //clear the array itself after data transplanting
        //and so on.
      }
     
   }

   //Modify in some way based on the command given.
   if(!is_idle && !new_message_processing){
      //here is where we do the steps for physical gantry motion
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



boolean length_matches_command_format(char command_type, int end_index){
  int len_array = end_index+1;
  
  if((command_type == 'A') && (len_array == 3)){
    return true;
  } else if((command_type == 'E') && (len_array == 3)){
    return true;
  } else if((command_type == 'R') && ((len_array == 8) || (len_array == 20))){
    return true;
  } else if((command_type == 'P') && (len_array == 20)){
    return true;
  } else if((command_type == 'S') && (len_array == 8)){
    return true;
  } else if((command_type == 'C') && (len_array == 3)){
    return true;
  } else if((command_type == 'G') && (len_array == 3)){
    return true;
  } else {
    return false;
  }
}

bool command_suitable_for_mode(char recieved_char){
  //If not suitable, the message is corrupted.
  
  if(is_idle){
    //Idle mode can be 'S', 'P', 'R', 'C', 'G', 'A'
    //Aka if the recieved character is not in the array of allowed chars
    
    if (strpbrk(allowed_idle_id_chars, recieved_char) == 0){
      return false;
    } else {
      return true;
    }
    
  } else {
    //Active mode can be 'E', 'A'
    //Aka if the recieved character is not in the array of allowed chars
    
    if (strpbrk(allowed_active_id_chars, recieved_char) == 0){
      return false;
    } else {
      return true;
    }
    
  }
  
}

void process_message_step(char recieved_char){
      //If character is STX
    if(recieved_char == special_chars[0]){

      //If message has not started yet
      if(!new_message_processing){
        message_recieved_char[message_recieved_counter] = recieved_char;
        message_recieved_counter = 0;
        new_message_processing = true;
        corrupted_message = false;
        
      } else {
        //If STX appears and the sequence has already started,
        //It is corrupted.
        //At this point, message_processing is false
        //And it does not get added.
        corrupted_message = true;
        
      }
    } else if(!corrupted_message){
      //If the message has started and it is not corrupted
      message_recieved_counter++;
      message_recieved_char[message_recieved_counter] = recieved_char;

      //If is the second character, it is command type
      if(message_recieved_counter == 1){
        //Check all types of possible messages
        //and declare corrupted if not suitable
        //So first differentiate by OPmode
        if(!command_suitable_for_mode(recieved_char)){
          //If the command is unsuitable, then the command is corrupted.
          corrupted_message = true;
        }
        
      }else{
        //If already passed 2nd character and ETX is found,
        //compare the lengths to the expected lengths of the
        //type of command it is.
        if(recieved_char == special_chars[1]){
          if(length_matches_command_format(recieved_char, message_recieved_counter)){
            //If gotten to this point, then the program should begin to run
            //and move the gantry.
            if(is_idle){
              is_idle = false;
            }
            
            new_message_processing = false;
          } else {
            //If the length is wrong, then the command is corrupted.
            corrupted_message = true;
          }
        }
      }
    }

    if(corrupted_message && new_message_processing){
      corrupt_message_clear();
    }
}


//Resets collected char data
void corrupt_message_clear(){
    //Declare that a new message is not being processed

    //Note that corrupted messages
    //include commands given in unsuitable OP states.
    message_recieved_counter = 0;
    new_message_processing = false;
    memset( message_recieved_char, '\0' , max_message_length );
}


//Need function for origin return



//Need function for calculating
//From idle conditions.
void setup_starting_command(char action){
  if(action == 'A'){
    //Requesting data of opstatus
    //No setup required
    continue();
  }else if(action == 'G'){
    //Requesting data on full grid occupancy
    //
  }else if(action == 'C'){
    //Informing manual change to cell
    
  }else if(action == 'S'){
    //Requesting movement of two parts
    
  }else if(action == 'P'){
    //Requesting storage of one part
    
  }else if(action == 'R'){
    //Requesting retrieval of one part
    
  }else if(action == 'E'){
    //Requesting emergency stop
    
  }else{
    //ERROR
  }
  

}


//Function for 'A' command
void op_state_query(){
  Serial.print(special_chars[0]);
  if(is_idle){
    Serial.print('I');
  } else {
    Serial.print('A');
  }
  Serial.println(special_chars[1]);
}
