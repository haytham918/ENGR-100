public class Circle2 extends Shape {
  private int x_velocity;
  private int y_velocity;
  private int x_center;
  private int y_center;
  private int r;
  
  public Circle2(int vx, int vy, int x, int y, int r) {
    x_velocity = vx;
    y_velocity = vy;
    x_center = x;
    y_center = y;
    this.r = r;
  }
  
  public int getLeft() {
    return x_center + x_velocity - r/2;
  }
  
  public int getRight() {
    return x_center + x_velocity + r/2;
  }
  
  public int getBottom() {
    return y_center + y_velocity + r/2;
  }
  
  public int getTop() {
    return y_center + y_velocity - r/2;
  }
  
  public void augment() {
    fill(0, 0, 200); shapeMode(CENTER);
    circle(x_center + x_velocity, y_center + y_velocity, r);

  }
}
