#include "Arduino.h"
#include <EEPROM.h>
#include <stdint.h>

struct StorageCell{
  char occupation_state; //C is closed, O is open, Z is origin
  
  //If occupation state is open or origin, no name.
  char item_name[17];
  
};

struct GridInfo{
  const double xy_range; //in meters
  const double z_range; //in meters
  //const int circuit_count = 4; // 1-2 is x and y motors, 3 is z motor, 4 is claw.
  const double cell_size; //in meters
  const double dropper_rad; //in meters
  const int xy_unit_motor_rev; //per 0.01 meters
  const int z_unit_motor_rev; //per 0.01 meters
  boolean confirmed_addresses;
  uint8_t address_map[25];
};

void setup() {
  // put your setup code here, to run once:

  
  
  int address_basic = 10;
  GridInfo initializedData = {0.32, 0.60, 0.06, 0.04, 5, 5, false};
  EEPROM.put(address_basic, initializedData);

}

void loop() {
  // put your main code here, to run repeatedly:

}
//
//uint8_t[25] firstRoundData(&initializedData){
//  uint8_t address_map[25];
//  StorageCell currentCell = {'Z', ""};
//  std::uint8_t identifier = std::hash<StorageCell>()(0);
//  address_map[0] = 
//  for(int i = 1; i < 25; i++){
//    StorageCell 
//  }
//  
//  
//}
