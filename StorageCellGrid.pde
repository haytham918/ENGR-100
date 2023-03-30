public class StorageCellGrid {
  private int[] GUI_size = {362, 562};
  private StorageCell[][] gridCells;
  private int[] grid_size = {262, 262};
  private int[] wimage_size = {280, 100};
  private int[] num_cells = {5, 5};
  private int[] cell_size = new int[2];
  private int[] gTopLeft_coords = {50, 50};
  private int[] gBotRight_coords = new int[2];
  private int[] prevGridRegion = {-1, -1};
  private int[] fromPosition= new int[2];
  private int[] destPosition = new int[2];
  private String image = "backgroundChess55.png";
  private String wimage = "whiteImage.png";
  //private int 
  private boolean withGrid = false;
  private boolean pickFrom = true;
  private boolean pickedFrom = false;
  private boolean pickDest = false;
  private boolean pickedDest = false;
  private PImage bground;
  private PImage whiteCovering;
  
ReallocationState realloc = ReallocationState.Initialize;
RetrievalState retrieval = RetrievalState.Initialize;
StoringState storing = StoringState.Initialize;
ModeState mode = ModeState.Unknown;

  public StorageCellGrid() {
  }

  public void init_grid_cells() {
    bground = loadImage(image);
    bground.resize(grid_size[0], grid_size[1]);
    whiteCovering = loadImage(wimage);
    whiteCovering.resize(wimage_size[0], wimage_size[1]);
    cell_size = new int[2];
    cell_size[0] = grid_size[0]/num_cells[0];
    cell_size[1] = grid_size[1]/num_cells[1];
    gBotRight_coords = new int[2];
    gBotRight_coords[0] = gTopLeft_coords[0] + grid_size[0];
    gBotRight_coords[1] = gTopLeft_coords[1] + grid_size[1];
    gridCells = new StorageCell[cell_size[0]][cell_size[1]];
    for (int rows = 0; rows < num_cells[0]; rows++) {
      for (int cols = 0; cols < num_cells[1]; cols++) {
        gridCells[rows][cols] = new StorageCell(gTopLeft_coords[0] + cell_size[0]*rows, gTopLeft_coords[1] + cell_size[1]*cols, cell_size[0], cell_size[1]); // xpos, ypos, xlen, ylen
      }
    }
  }

  public void set_gTopLeft_coords(int x, int y) {
    gTopLeft_coords[0] = x;
    gTopLeft_coords[1] = y;
  }

  public int[] get_gTopLeft_coords() {
    return gTopLeft_coords;
  }

  public void set_grid_size(int x, int y) {
    grid_size[0] = x;
    grid_size[1] = y;
  }

  public int[] get_grid_size() {
    return grid_size;
  }

  public int[] get_prevGridReg() {
    return prevGridRegion;
  }

  public void set_numcells(int x, int y) {
    num_cells[0] = x;
    num_cells[1] = y;
  }

  public void set_GUIsize(int x, int y) {
    GUI_size[0] = x;
    GUI_size[1] = y;
  }

  public int[] get_GUIsize() {
    return GUI_size;
  }

  public void set_image(String str) {
    image = str;
  }

  public String get_image() {
    return image;
  }
  
  public PImage get_pimage() {
    return bground;
  }

  boolean mouseWithinGrid() {
    if ((mouseX < gTopLeft_coords[0]) || (mouseX > gBotRight_coords[0]))
      return false;
    else if ((mouseY < gTopLeft_coords[1]) || (mouseY > gBotRight_coords[1]))
      return false;
    else
      return true;
  }

 confirmationState clickedYes()
{
  
    if(mousePressed && mouseX >= 250 && mouseX <= 315 && mouseY >= 380 && mouseY <= 405)
      return confirmationState.No;
    if(mousePressed && mouseX >= 45 && mouseX <= 105 && mouseY >= 380 && mouseY <= 405)
      return confirmationState.Yes;
      
    return confirmationState.Unknown;
}

  public void clearEverything()
  {
    for (int rows = 0; rows < num_cells[0]; rows++) {
      for (int cols = 0; cols < num_cells[1]; cols++) {
        gridCells[rows][cols].setToggleDefault();
      }
      background(255);
      image(bground, gTopLeft_coords[0], gTopLeft_coords[1]);
      tint(50);
      pickedFrom = false;
      pickFrom = true;
    }
  }



  public void updateFromRegion(int x, int y) {
    int indexRow = ((x-12) / 50) - 1;
    int indexCol = ((y-12) / 50) - 1;
    fromPosition[0] = indexRow;
    fromPosition[1] = indexCol;
    gridCells[indexRow][indexCol].changeFromState();
  }

  public void updateDestRegion(int x, int y) {
    int indexRow = ((x-12) / 50) - 1;
    int indexCol = ((y-12) / 50) - 1;
    destPosition[0] = indexRow;
    destPosition[1] = indexCol;
    gridCells[indexRow][indexCol].changeDestState();
  }

  public void runSimulation() {
      //Updates 10 times a second
  //frameRate(10);
   if(mode == ModeState.Unknown)
   {
     mode = modeSelection();
   }
  //Make condition for when mouse is outside grid...
  stroke(204, 102, 0);
  withGrid = mouseWithinGrid();
  if(mode == ModeState.Reallocation)
  {
     ReallocationMode();
  }
  if(mode == ModeState.Retrieval)
  {
    RetrievalMode();
  }
  if(mode == ModeState.Storing)
  {
    StoringMode();
  }
  delay(80);
  }
  
  
  
  public ModeState modeSelection(){
    fill(70,70,70);
    textSize(21);
    text("Select the mode", 110, 360);
    fill(235, 227, 174);
    rect(30, 420, 90, 25);
    fill(235, 227, 174);
    rect(250, 420, 90, 25);
    fill(235, 227, 174);
    rect(140, 420, 90, 25);
    fill(43, 123, 168);
    textSize(15);
    text("Reallocation", 36, 438);
    text("Storing", 275, 438);
    text("Retrieval", 158, 438);
    
    if(mousePressed && mouseX >= 30 && mouseX <= 120 && mouseY >= 420 && mouseY <= 445)
    {
       System.out.println("Reallocation Mode Selected");
        tint(255);
        image(whiteCovering, 10, 330);
        fill(70,70,70);
        textSize(23);
        text("Pick From Position", 95, 350);
       return ModeState.Reallocation;
    }
    if(mousePressed && mouseX >= 140 && mouseX <= 230 && mouseY >= 420 && mouseY <= 445)
    {
       System.out.println("Retrieval Mode Selected");
      background(255);
      image(bground, gTopLeft_coords[0], gTopLeft_coords[1]);
      tint(50);
       fillOrigin();
       fill(70,70,70);
        textSize(23);
        text("Pick Retrieval Position", 80, 350);
       return ModeState.Retrieval;
    }
    if(mousePressed && mouseX >= 250 && mouseX <= 340 && mouseY >= 420 && mouseY <= 445)
    {
      
       System.out.println("Storing Mode Selected");
       background(255);
      image(bground, gTopLeft_coords[0], gTopLeft_coords[1]);
      tint(50);
       fillOrigin();
        fill(70,70,70);
        textSize(23);
        text("Pick Storing Position", 85, 350);
       return ModeState.Storing;
    }
    return ModeState.Unknown;
}

public void fillOrigin()
{
   fill(255, 255, 255);
   int originX = 52;
   int originY = 258;
   rect(originX, originY, 50, 50);
   gridCells[0][4].setToggleTrue();
  
}

public void ReallocationMode()
{

if(withGrid && mousePressed)
  {
    if(realloc == ReallocationState.Initialize)
    {
       updateFromRegion(mouseX, mouseY);
    }
    else if(realloc == ReallocationState.PickedFrom)
    {
      updateDestRegion(mouseX, mouseY);
    }

  }
  else if(realloc == ReallocationState.Initialize)
  {
      confirmationState confirm = clickedYes();
      if(confirm == confirmationState.No)
      {
        clearEverything();
        realloc = ReallocationState.Initialize;
        fill(70,70,70);
        textSize(23);
        text("Pick From Position", 95, 350);
      }
      else if(confirm == confirmationState.Yes)
      {
         System.out.println("Now Choose the Destination");
         realloc = ReallocationState.PickedFrom;
         tint(255);
         image(whiteCovering, 10, 330);
         fill(70,70,70);
         textSize(23);
         text("Pick Destination Position", 65, 350);
      }
  }
  else if(realloc == ReallocationState.PickedFrom)
  {
      confirmationState confirm = clickedYes();
      if(confirm == confirmationState.No)
      {
         clearEverything();
         realloc = ReallocationState.PickedFrom;
         gridCells[fromPosition[0]][fromPosition[1]].setToggleTrue();
         gridCells[fromPosition[0]][fromPosition[1]].updateCellVisual();
         fill(70,70,70);
         textSize(23);
         text("Pick Destination Position", 65, 350);
      }
      else if(confirm == confirmationState.Yes)
      {
         realloc = ReallocationState.PickedDest;
         tint(255);
         image(whiteCovering, 35, 330);
      }
  }
}

public void RetrievalMode()
{
  if(withGrid && mousePressed)
  {
     if(retrieval == RetrievalState.Initialize)
     {
        updateDestRegion(mouseX, mouseY);
     }
  }
  else if(retrieval == RetrievalState.Initialize)
  {
      confirmationState confirm = clickedYes();
      if(confirm == confirmationState.No)
      {
        clearEverything();
        fill(70,70,70);
        textSize(23);
        text("Pick Retrieval Position", 80, 350);
        fillOrigin();
      }
      else if(confirm == confirmationState.Yes)
      {
         
         retrieval = RetrievalState.PickedRetrievalPos;
         tint(255);
         image(whiteCovering, 10, 330);
      }
  }
}

public void StoringMode()
{
  if(withGrid && mousePressed)
  {
     if(storing == StoringState.Initialize)
     {
        updateFromRegion(mouseX, mouseY);
     }
  }
  else if(storing == StoringState.Initialize)
  {
      confirmationState confirm = clickedYes();
      if(confirm == confirmationState.No)
      {
        clearEverything();
        fill(70,70,70);
        textSize(23);
        text("Pick Storing Position", 85, 350);
        fillOrigin();
      }
      else if(confirm == confirmationState.Yes)
      {
         storing = StoringState.PickedStoringPos;
         tint(255);
         image(whiteCovering, 10, 330);
      }
  }
  
}
public void createConfirmation()
{
    tint(255);
    image(whiteCovering, 10, 330);
    fill(85);
    textSize(23);
    text("Confirm the Position?", 85, 350);
    fill(203, 208, 178);
    rect(45, 380, 60, 25);
    fill(209, 208, 178);
    rect(250, 380, 60, 25);
    fill(45);
    textSize(20);
    text("YES", 60, 400);
    textSize(20);
    text("NO", 270, 400);
  
}
  
}
