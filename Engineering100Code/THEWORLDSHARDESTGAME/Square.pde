public class Square {
  private int x_velocity;
  private int y_velocity;
  private int x_center;
  private int y_center;
  private int sl;  
  public Square(int vx, int vy, int x, int y, int sl) {
    x_velocity = vx;
    y_velocity = vy;
    x_center = x;
    y_center = y;
    this.sl = sl;
  }
  
  public int getLeft() {
    return x_center + x_velocity + 7 - sl / 2;
  }
  
  public int getRight() {
    return x_center + x_velocity + 7 + sl/2;
  }
  
  public int getBottom() {
    return y_center + y_velocity + 7 + sl/2;
  }
  
  public int getTop() {
    return y_center + y_velocity + 7 - sl/2;
  }
  
  public void augment() {
    fill(255, 0, 0);
    shapeMode(CENTER);
    square(x_center + x_velocity, y_center + y_velocity, sl);

  }
  
  public boolean checkCollision(Shape other) {
    boolean noXOverlap = getRight() < other.getLeft() || getLeft() > other.getRight();
    boolean noYOverlap = getBottom() < other.getTop() || getTop() > other.getBottom();
    if (noXOverlap || noYOverlap) {
      return false;
    }
    return true;
  }
  
  public boolean checkCollision(Rectangle other) {
    boolean noXOverlap = getRight() < other.getLeft() || getLeft() > other.getRight();
    boolean noYOverlap = getBottom() < other.getTop() || getTop() > other.getBottom();
    if (noXOverlap || noYOverlap) {
      return false;
    }
    return true;
  }
}
