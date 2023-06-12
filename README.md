# Gantry Robot

## Description
This is the code for the Gantry Robot in a warehouse setting including the User Interface and Arduino Codes for Movement. Here, we will describe the User-Interface as it simulates the movement of the Gantry Robot.

--- Haytham Tang
## Set-Up
**Processing**: Make sure you have [Processing](https://processing.org/download) installed.

**Arduino**: Make sure you have [Arduino](https://support.arduino.cc/hc/en-us/articles/360019833020-Download-and-install-Arduino-IDE) installed

**Repo**: Clone the Repo into your local directory by running
```
git clone https://github.com/haytham918/Gantry-Robot.git
```
## Run
### Interface
After you have set up the repo in your local directory. Follow the following direction to run the User-Interface:

```Open Processing``` -> ```Open Sketch``` -> ```/DevelopmentCode/storageGridTest/storageGridTest.pde``` -> Press the ```Play``` button to start.

Now, you should see a screen with a 5x5 board and three modes for you to pick: Reallocation, Retrieval, Storage.

**Reallocation:** If you pick the reallocation mode, you will be prompted to pick the "from-position", where the object you are trying to reallocate is at originally. Every time after you pick a location, you will be prompted to confirm your choice by interacting with the confirmation message shown on the screen. The "from-position" is highlighted blue. After you confirm "yes", you will then be prompted to select a different location as the destination of the reallocated object. The "destination-position" is highlighted green. Once again, you will be prompted to confirm your choice.

**Retrieval:** In the retrieval mode, you will retrieve an object from a position. In this case, you will only choose the "from-position" for the object you want to retrieve from. By default, the object will be moved to the origin(bottom-left grid), which is highlighted white.

**Storage:** If you pick the storage mode, you will stroe an object at a particular position. You will only choose the "destination-position" for the object you want to store the object. By default, the object will start from the origin(bottom-left grid), which is highlighted white.

## Demo
Checkout the [Demonstration Video](https://youtu.be/w0IdrNhn2UM) that describes the whole mechanism of the robot and also the guidelines for the user-interface.

## Contact
Yunxuan "Haytham" Tang — [yunxuant@umich.edu](mailto:yunxuant@umich.edu)
