public class Shape {
  private int x_velocity;
  private int y_velocity;
  private int x_center;
  private int y_center;
  
  public Shape() {
  }
  
  public Shape(int vx, int vy, int x, int y, int r) {
    x_velocity = vx;
    y_velocity = vy;
    x_center = x;
    y_center = y;
  }
  
  public int getLeft() {
    return x_center + x_velocity;
  }
  
  public int getRight() {
    return x_center + x_velocity;
  }
  
  public int getBottom() {
    return y_center + y_velocity;
  }
  
  public int getTop() {
    return y_center + y_velocity;
  }
  
  public void augment() {
    fill(0, 0, 200);
    rect(x_center + x_velocity, y_center + y_velocity, 3, 3);

  }
}
