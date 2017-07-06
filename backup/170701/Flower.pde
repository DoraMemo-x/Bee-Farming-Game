static final int FLOWER_DETECT_RADIUS = 100;
static final int FLOWER_VISIBLE_RADIUS = 10;

class Flower { 
  PVector f;
  int minHoneyKg = 1, maxHoneyKg = 3;
  //float honeyGram = ((int)random(minHoneyKg, maxHoneyKg))*1000;
  float honeyGram = 0; //by default
  float flowerSize = map(honeyGram/1000, forestHoneyRng[forestType][0], forestHoneyRng[forestType][1]+1, 10, 20);
  int pedalAmount = int(random(5, 10));
  boolean flowerBusyStatus = false;
  long spawnAnimationTimer;

  int colorR = int(random(255)), colorG = int(random(255)), colorB = int(random(255));
  color stamenColor = color(colorR/1.5, colorG/1.5, colorB/1.5);
  color pedalColor = color(colorR, colorG, colorB);

  Flower(float x, float y, int _minHoneyKg, int _maxHoneyKg) { 
    f = new PVector(x, y); //x,y coordinate

    minHoneyKg = _minHoneyKg;
    maxHoneyKg = _maxHoneyKg;

    honeyGram = ((int)random(minHoneyKg, maxHoneyKg+1))*1000;
    
    spawnAnimationTimer = gameMillis;
  } 

  float angleOffset = random(PI);
  void showFlower() {
    flowerSize = map(honeyGram/1000, forestHoneyRng[forestType][0], forestHoneyRng[forestType][1]+1, 10, 20) * constrain(float(int(gameMillis-100-spawnAnimationTimer))/500, 0, 1);
    if (flowerSize <= 5) flowerSize = 5; //sometimes when the honey drops too low, the mapped value will be negative; flower too small cant see

    fill(200, 200, 200, 50);
    if (debug) {
      noStroke();
      ellipse(f.x, f.y, FLOWER_DETECT_RADIUS, FLOWER_DETECT_RADIUS);
    }

    //flower pedals
    strokeWeight(flowerSize);
    stroke(pedalColor, 200);
    pushMatrix();
    translate(f.x, f.y);
    rotate(angleOffset);
    for (int i = 0; i < pedalAmount; i++) {
      rotate(TWO_PI/pedalAmount);
      line(0, 0, flowerSize, 0);
    }
    popMatrix();

    //flower center
    fill(stamenColor, 200);
    strokeWeight(0);
    ellipse(f.x, f.y, flowerSize, flowerSize);
    //ellipse(f.x, f.y, FLOWER_VISIBLE_RADIUS, FLOWER_VISIBLE_RADIUS);


    fill(150);
    textSize(10);
    textAlign(CENTER);
    //text(honeyGram+"g", f.x, f.y-20);
    text(ceil(honeyGram/1000)+"kg", f.x, f.y-20); //used to be f.y-8

    if (f.x < 10 || f.x > width-10 || f.y < 30 || f.y > height-10) println(f.x, f.y);
  }

  float getHoneyGram() {
    return honeyGram;
  }

  void updateHoneyGram(float newHoneyGram) {
    honeyGram = newHoneyGram;
  }

  PVector getLocation() { 
    return f;
  }

  int getPedalAmount() {
    return pedalAmount;
  }

  color[] getStamenPedalColor() {
    color temp[] = new color[2];
    temp[0] = stamenColor;
    temp[1] = pedalColor;
    return temp;
  }
}

long flowerTimer = 0; //to make things more difficult, the flowers can disappear after a certain time
void createFlower() {
  float nextFlowerTime = 6000; //default
  if (forestType <= 4) nextFlowerTime = (0.0053*pow(flowers.size(), 3) - 0.12*pow(flowers.size(), 2) + 1.4667*flowers.size() )*1000;
  else if (forestType == 5 || forestType == 6) nextFlowerTime = (0.0033*pow(flowers.size(), 3)-0.06*pow(flowers.size(), 2)+0.9167*flowers.size() )*1000;
  else nextFlowerTime = (0.0033*pow(flowers.size(), 3)-0.07*pow(flowers.size(), 2)+0.9667*flowers.size() )*1000;
  if (debug) {
    fill(0);
    textSize(12);
    textAlign(LEFT);
    text("Next flower in: " + (int)((nextFlowerTime+flowerTimer)-gameMillis), 20, height-8);
  }
  if (gameMillis - flowerTimer > nextFlowerTime) {
    flowers.add(new Flower(10+random(width-20), 40+random(height-40-50), forestHoneyRng[forestType][0], forestHoneyRng[forestType][1]));
    flowerTimer = gameMillis;
  }
}