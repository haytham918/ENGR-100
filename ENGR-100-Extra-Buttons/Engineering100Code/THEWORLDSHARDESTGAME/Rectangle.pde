public class Rectangle{
  private int x_velocity;
  private int y_velocity;
  private int x_center;
  private int y_center;
  private int w;
  private int h;
  
  public Rectangle(int vx, int vy, int x, int y, int w, int h) {
    x_velocity = vx;
    y_velocity = vy;
    x_center = x;
    y_center = y;
    this.w = w;
    this.h = h;
  }
  
  public int getLeft() {
    return x_center;
  }
  
  public int getRight() {
    return x_center + x_velocity + w;
  }
  
  public int getBottom() {
    return y_center + y_velocity + h;
  }
  
  public int getTop() {
    return y_center;
  }
  
  public void augment() {
    fill(20, 200, 80);
    shapeMode(CENTER);
    rect(x_center + x_velocity, y_center + y_velocity, w, h);

  }
}
