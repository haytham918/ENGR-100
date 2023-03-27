
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
  private boolean selectionToggle = false;
  
  
  private boolean isOccupied;
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
    
    //Is selected?
    selectionToggle = false;
    isOccupied = false;
    //Start off at ten opacity.
    tintIndex = 50;
    tint(tintIndex);
  }
  
  public void setToggleDefault()
  {
     selectionToggle = false;
  }
  
  public void setToggleTrue()
  {
    selectionToggle = true;
  }
  
  public void changeFromState(){
    if(!selectionToggle)
    {
       selectionToggle = true;
       selectionColor[0] = 20;
       selectionColor[1] = 100;
       selectionColor[2] = 120;
       updateCellVisual();
       createConfirmation();
    }
    else 
    {
       System.out.println("Please select another position");

    }
  }
  
  public void changeDestState()
  {
      if(!selectionToggle)
    {
       selectionToggle = true;
       selectionColor[0] = 50;
       selectionColor[1] = 200;
       selectionColor[2] = 110;
       updateCellVisual();
       createConfirmation();
    }
    else 
    {
       System.out.println("Please select another position");
    }
  }
 
  
  public void updateCellVisual(){
    fill(selectionColor[0], selectionColor[1], selectionColor[2]);
    rect(cornerCoords[0], cornerCoords[1], cellWidth, cellHeight);
  }
  
}
