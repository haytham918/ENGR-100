
//Variant Draft of StorageCell
//Removed hover functionality, added click functionality


public class StorageCell{
  private int[] cornerCoords = new int[2];
  private int cellWidth;
  private int cellHeight;
  private double measureWidth;
  private double measureHeight;
  private String unitType;
  
  private int[] selectionColor = new int[3];
  private boolean selectionToggle;
  
  private int tintIndex;
  
  public StorageCell(int xCoord, int yCoord, int w, int h, double wRL, double hRL, String units){
    cornerCoords[0] = xCoord;
    cornerCoords[1] = yCoord;
    cellWidth = w;
    cellHeight = h;
    measureWidth = wRL;
    measureHeight = hRL;
    unitType = units;
    
    //For more advanced version
    //selectionState = 0;
    
    //RGB values, in that order
    //made gray to start off
    selectionColor[0] = 102;
    selectionColor[1] = 153;
    selectionColor[2] = 204;
    
    //Is selected?
    selectionToggle = false;
    //Start off at ten opacity.
    tintIndex = 50;
  }
  
  public void changeClickedState(){
    if(selectionToggle){
      //The button has been deselected
      
      //Set button back to gray
      selectionColor[0] = 102;
      selectionColor[1] = 153;
      selectionColor[2] = 204;
      
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
  
  public void updateClickStatus(){
    changeClickedState();
  }
  
  public void updateCellVisual(){
    fill(selectionColor[0], selectionColor[1], selectionColor[2]);
    tint(tintIndex);
    rect(cornerCoords[0], cornerCoords[1], cellWidth, cellHeight);
  }
  
}
