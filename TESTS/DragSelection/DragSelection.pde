PVector[] objects = new PVector[15];
boolean[] selected = new boolean[15];
void setup() {
  size(800, 800);
  strokeWeight(2);
  for (int i = 0; i < objects.length; i++) {
    objects[i] = new PVector(50+random(width-100), 50+random(height-100));
    selected[i] = false;
  }
}

void draw() {
  background(220);
  noStroke();
  for (int i = 0; i < objects.length; i++) {
    if (!selected[i]) fill(255, 150, 35);
    else fill(50, 200, 50);
    ellipse(objects[i].x, objects[i].y, 5, 5);
  }
  if (setCorner) {
    rectMode(CORNERS);
    fill(175, 255, 175, 75);
    noStroke();
    rect(cornerCords.x, cornerCords.y, mouseX, mouseY);
    rectMode(CORNER);

    float lowerX = min(cornerCords.x, mouseX);
    float lowerY = min(cornerCords.y, mouseY);
    float upperX = max(cornerCords.x, mouseX);
    float upperY = max(cornerCords.y, mouseY);
    stroke(30, 30, 30, 200);
    float xDots = (upperX - lowerX)/10;
    float yDots = (upperY - lowerY)/10;
    for (int i = 0; i < xDots; i++) {
      float x = lerp(lowerX, upperX, i/xDots);
      point(x, lowerY);
      point(x, upperY);
    }
    for (int j = 0; j < yDots; j++) {
      float y = lerp(lowerY, upperY, j/yDots);
      point(lowerX, y);
      point(upperX, y);
    }

    for (int i = 0; i < objects.length; i++) {
      if (objects[i].x > lowerX && objects[i].x < upperX && objects[i].y > lowerY && objects[i].y < upperY) {
        selected[i] = true;
      } else selected[i] = false;
    }
  }
}

boolean setCorner = false;
PVector cornerCords = new PVector(0, 0);
void mousePressed() {
  if (setCorner == false) cornerCords = new PVector(mouseX, mouseY);
  setCorner = true;
}

void mouseReleased() {
  setCorner = false;
  //for (int i = 0; i < selected.length; i++) {
  //  selected[i] = false;
  //}
}