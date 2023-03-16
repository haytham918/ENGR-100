
//Basic draft of storage cell class.
//Will act as button and visual indicator of availability for
//storage space. Need to consider storage space in long term.
public class StorageCell{
  private int[] cornerCoords = new int[2];
  private int cellWidth;
  private int cellHeight;
  
  //private int selectionState;
  //private int previousState;
  
  private int[] selectionColor = new int[3];
  private boolean selectionToggle;
  
  
  private boolean hoveringToggle;
  private int tintIndex;
  
  //private string[] storageItemData;
  //Update later when adding case scenarios
  
  //Shouldn't be possible, needs some coordinate location...
  //Dont need a base case for the class anyway I dont think...
  //public StorageCell(){
  //  //Empty cell in other words
  //  cornerCoords[0] = 0;
  //  cornerCoords[1] = 0;
  //  cellWidth = 0;
  //  cellHeight = 0;
    
  //  selectionState = 0;
  //  selectionColor = 0;
  //  selectionToggle = 0;
  //}

  public StorageCell(int xCoord, int yCoord, int w, int h){
    cornerCoords[0] = xCoord;
    cornerCoords[1] = yCoord;
    cellWidth = w;
    cellHeight = h;
    
    //For more advanced version
    //selectionState = 0;
    
    //RGB values, in that order
    //made gray to start off
    selectionColor[0] = 102;
    selectionColor[1] = 153;
    selectionColor[2] = 204;
    
    //Is selected?
    selectionToggle = false;
    hoveringToggle = false;
    //Start off at ten opacity.
    tintIndex = 50;
    updateCellVisual();
  }
  
  public void changeHoveringState(){
    if(hoveringToggle){
      //Has left region, no longer hovering over
      
      //If not selected, return color to gray
      if(!selectionToggle){
        selectionColor[0] = 102;
        selectionColor[1] = 153;
        selectionColor[2] = 204;
      }

      hoveringToggle = false;
      tintIndex -= 77;
    } else {
      //Has entered region, currently hovering over
      
      //If not already selected, update color to reflect hovering
      if(!selectionToggle){
        selectionColor[0] = 255;
        selectionColor[1] = 87;
        selectionColor[2] = 51;
      }
      hoveringToggle = true;
      tintIndex += 77;
    }
  }
  
  public void changeClickedState(){
    if(selectionToggle){
      //The button has been deselected
      
      //Set button back to hovering color
      selectionColor[0] = 255;
      selectionColor[1] = 87;
      selectionColor[2] = 51;
      
      selectionToggle = false;
      tintIndex -= 127;
    } else {
      //The button has been selected
      
      //Set button to selected color
      selectionColor[0] = 57;
      selectionColor[1] = 255;
      selectionColor[2] = 20;
      
      selectionToggle = true;
      tintIndex += 127;
    }
  }
  
  //Modes are 0, 1, 2, 3
  //Leave for later...
  //public void modeChanged(){
  
  //}
  
  public void updateCellVisual(){
    rect(cornerCoords[0], cornerCoords[1], cellWidth, cellHeight);
    fill(selectionColor[0], selectionColor[1], selectionColor[2]);
    tint(tintIndex);
  }
  
}
