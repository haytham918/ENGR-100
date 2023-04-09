#include "Arduino.h"
#include <EEPROM.h>

struct StorageCell {
  char occupation_state; //C is closed, O is open, Z is origin
  
  //If occupation state is open or origin, no name.
  char[16] item_name;
  
  uint8_t x_coord;
  uint8_t y_coord;
};

void setup() {
  // put your setup code here, to run once:

}

void loop() {
  // put your main code here, to run repeatedly:

}
