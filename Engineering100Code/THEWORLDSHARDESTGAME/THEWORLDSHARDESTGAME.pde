void setup() {
  size(1000, 720);
  background(50, 100, 200);
}
int x_velocity = 0;
int y_velocity = 0;
int x_velocity2 = 0;
int x_velocity3 = 0;
int y_velocity3 = 0;
int count = 0;
int fails = 0;
boolean coin_collected = false;
boolean coin1_collected = false;

Shape[] carray = new Shape[16];

Rectangle[] rarray = new Rectangle[17];



public void draw() {
  rarray[0] = new Rectangle(0, 0, 0, 0, 1000, 40);
  rarray[1] = new Rectangle(0, 0, 240, 40, 760, 40);
  rarray[2] = new Rectangle(0, 0, 400, 80, (1000 - 400), 200);
  rarray[3] = new Rectangle(0, 0, 440, 280, 120, 40);
  rarray[4] = new Rectangle(0, 0, 400, 320, 80, 40);
  rarray[5] = new Rectangle(0, 0, 600, 280, (1000 - 600), 40);
  rarray[6] = new Rectangle(0, 0, 640, 320, (1000 - 640), 80);
  rarray[7] = new Rectangle(0, 0, 640, 400, 40, 80);
  rarray[8] = new Rectangle(0, 0, 640, 480, 80, 160);
  rarray[9] = new Rectangle(0, 0, 840, 400, (1000 - 840), 80);
  rarray[10] = new Rectangle(0, 0, 800, 480, (1000 - 800), 240);
  rarray[11] = new Rectangle(0, 0, 0, 680, 1000, 40);
  rarray[12] = new Rectangle(0, 0, 0, 480, 560, 200);
  rarray[13] = new Rectangle(0, 0, 0, 440, 480, 40);
  rarray[14] = new Rectangle(0, 0, 0, 200, 320, 240);
  rarray[15] = new Rectangle(0, 0, 240, 160, 80, 40);
  rarray[16] = new Rectangle(0, 0, 0, 40, 160, 160);
  for (int i = 0; i < 17; i++) {
    rarray[i].augment();
  }
  background(50, 100, 200);
  fill(255, 255, 255);
  beginShape();
  vertex(160, 40);
  vertex(240, 40);
  vertex(240, 80);
  vertex(400, 80);
  vertex(400, 280);
  vertex(440, 280);
  vertex(440, 320);
  vertex(400, 320);
  vertex(400, 360);
  vertex(480, 360);
  vertex(480, 320);
  vertex(560, 320);
  vertex(560, 280);
  vertex(600, 280);
  vertex(600, 320);
  vertex(640, 320);
  vertex(640, 620);
  vertex(720, 620);
  vertex(720, 480);
  vertex(680, 480);
  vertex(680, 400);
  vertex(840, 400);
  vertex(840, 480);
  vertex(800, 480);
  vertex(800, 680);
  vertex(560, 680);
  vertex(560, 480);
  vertex(480, 480);
  vertex(480, 440);
  vertex(320, 440);
  vertex(320, 160);
  vertex(240, 160);
  vertex(240, 200);
  vertex(160, 200);
  endShape(CLOSE);

  Rectangle r1 = new Rectangle(0, 0, 160, 40, 80, 160);
  r1.augment();
  Rectangle r = new Rectangle(0, 0, 680, 400, 160, 80);
  r.augment();

  Circle3 c = new Circle3(0, 0, 420, 300, 10);
  Circle3 c1 = new Circle3(0, 0, 580, 300, 10);

  carray[0] = new Circle(x_velocity, y_velocity, 280, 100, 10);
  carray[1] = new Circle2(x_velocity2, 0, 340, 220, 10);
  carray[2] = new Circle2(x_velocity2, 0, 340, 340, 10);
  carray[3] = new Circle2(x_velocity2 * 3, 0, 500, 340, 10);
  carray[4] = new Circle2(x_velocity2 * 3, 0, 500, 460, 10);
  carray[5] = new Circle2(0, 0, 580, 500, 10);
  carray[6] = new Circle2(0, 0, 580, 540, 10);
  carray[7] = new Circle2(0, 0, 580, 580, 10);
  carray[8] = new Circle2(0, 0, 580, 620, 10);
  carray[9] = new Circle2(0, 0, 620, 500, 10);
  carray[10] = new Circle2(0, 0, 620, 540, 10);
  carray[11] = new Circle2(0, 0, 620, 580, 10);
  carray[12] = new Circle2(0, 0, 620, 620, 10);
  carray[13] = new Circle2(x_velocity2 * -1, 0, 780, 540, 10);
  carray[14] = new Circle2(x_velocity2, 0, 740, 580, 10);
  carray[15] = new Circle2(x_velocity2 * -1, 0, 780, 620, 10);

  textSize(30);
  fill(200, 200, 30);
  text("Collect all the coins and get to the end!", 10, 30);

  textSize(50);
  fill(255, 255, 255);
  text("Fails: " + fails, 800, 60);

  for (int i = 0; i < 16; i++) {
    carray[i].augment();
  }


  if (count >= 0 && count < 20) {
    x_velocity += -1;
    y_velocity += 1;
  } else if (count >= 20 && count < 40) {
    x_velocity += 1;
    y_velocity += 1;
  } else if (count >= 40 && count < 60) {
    x_velocity += 1;
    y_velocity += -1;
  } else if (count >= 60 && count < 80) {
    x_velocity += -1;
    y_velocity += -1;
  } else {
    count = 0;
    x_velocity = 0;
    y_velocity = 0;
  }
  count++;


  if (count >= 0 && count < 40) {
    x_velocity2++;
  } else if (count >= 40 && count < 80) {
    x_velocity2--;
  } else {
    x_velocity2 = 0;
  }

  Square s = new Square((int) (x_velocity3 * 1.5), (int) (y_velocity3 * 1.5), 200, 120, 15);
  s.augment();
  if (keyPressed) {
    if (keyCode == UP) {
      y_velocity3--;
    } 
    if (keyCode == DOWN) {
      y_velocity3++;
    } 
    if (keyCode == RIGHT) {
      x_velocity3++;
    } 
    if (keyCode == LEFT) {
      x_velocity3--;
    }
  }
  for (int i = 0; i < 16; i++) {
    if (s.checkCollision(carray[i])) {
      x_velocity3 = 0;
      y_velocity3 = 0;
      fails++;
      coin_collected = false;
      coin1_collected = false;
    }
  }

  if (s.checkCollision(c) || coin_collected) {
    coin_collected = true;
  } else {
    c.augment();
  }
  if (s.checkCollision(c1) || coin1_collected) {
    coin1_collected = true;
  } else {
    c1.augment();
  }

  for (int i = 0; i < 17; i++) {
    if (s.checkCollision(rarray[i])) {
      if (keyPressed) {
        if (keyCode == UP) {
          y_velocity3 += 2;
        } 
        if (keyCode == DOWN) {
          y_velocity3 -= 2;
        } 
        if (keyCode == RIGHT) {
          x_velocity3 -= 2;
        } 
        if (keyCode == LEFT) {
          x_velocity3 += 2;
        }
      }
    }
  }

  if (s.checkCollision(r) && coin_collected && coin1_collected) {
    background(0, 0, 0);
    textSize(50);
    fill(255, 255, 255);
    text("\t\t\tYou won?\n\t\t\tjust kidding that level was easy", 50, 300);
    if (second() == 0) {
      while (second() != 0) {
      }
    } else if (second() == 15) {
      while (second() != 15) {
      }
    } else if (second() == 30) {
      while (second() != 30) {
      }
    } else if (second() == 45) {
      while (second() != 45) {
      }
    }
  }
}
