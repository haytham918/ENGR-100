public class StorageCellGrid {
  private StorageCell[][] gridCells;
  private int[] grid_size = {262, 262};
  private int[] num_cells = {5, 5};
  private int[] cell_size = new int[2];
  private int[] gTopLeft_coords = {50, 50};
  private int[] gBotRight_coords = new int[2];
  private int[] prevGridRegion = {-1, -1};
  
  public StorageCellGrid() {
  }
  
  public void init_grid_cells() {
    cell_size = new int[2];
    cell_size[0] = grid_size[0]/num_cells[0];
    cell_size[1] = grid_size[1]/num_cells[1];
    gBotRight_coords = new int[2];
    gBotRight_coords[0] = gTopLeft_coords[0] + 262;
    gBotRight_coords[1] = gTopLeft_coords[1] + 262;
    gridCells = new StorageCell[cell_size[0]][cell_size[1]];
   for(int rows = 0; rows < num_cells[0]; rows++){
    for(int cols = 0; cols < num_cells[1]; cols++){
      gridCells[rows][cols] = new StorageCell(gTopLeft_coords[0] + cell_size[0]*rows, gTopLeft_coords[1] + cell_size[1]*cols, cell_size[0], cell_size[1]); // xpos, ypos, xlen, ylen
      }
    }
  }
  
  public int[] get_gTopLeft_coords() {
    return gTopLeft_coords;
  }
  
  public int[] get_grid_size() {
    return grid_size;
  }
  
  public int[] get_prevGridReg() {
    return prevGridRegion;
  }
  
  boolean mouseWithinGrid(){
    if((mouseX < gTopLeft_coords[0]) || (mouseX > gBotRight_coords[0]))
      return false;
    else if((mouseY < gTopLeft_coords[1]) || (mouseY > gBotRight_coords[1]))
      return false;
    else
      return true;
  }

public void updateCellRegion(int x, int y){
    gridCells[x][y].changeHoveringState();
    gridCells[x][y].updateCellVisual();
}
  
}
