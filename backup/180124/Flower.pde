static final int FLOWER_DETECT_RADIUS = 100;
static final int FLOWER_VISIBLE_RADIUS = 10;

class Flower { 
  PVector f;
  int minHoneyKg = 1, maxHoneyKg = 3;
  //float honeyGram = ((int)random(minHoneyKg, maxHoneyKg))*1000;
  float honeyGram = 0; //by default
  float flowerSize = map(honeyGram/1000, forestHoneyRng[forestType][0], forestHoneyRng[forestType][1]+1, FLOWER_VISIBLE_RADIUS, FLOWER_VISIBLE_RADIUS*2);
  int pedalAmount = int(random(5, 10));
  int stamenTier = 0; //0-D 1-C 2-B 3-A 4-S 5-SS
  //boolean flowerBusyStatus = false;
  long spawnAnimationTimer;

  boolean forTraining = false;
  boolean forShop = false;

  int colorR = int(random(255)), colorG = int(random(255)), colorB = int(random(255));
  color stamenColor = color(colorR/1.5, colorG/1.5, colorB/1.5);
  color pedalColor = color(colorR, colorG, colorB);

  Flower(float x, float y, int _minHoneyKg, int _maxHoneyKg) {
    while (dist(x, y, width/2, height/2) < 35) { //too close to beehive
      x = 10+random(width-20); 
      y = 40+random(height-40-50);
    }
    f = new PVector(x, y); //x,y coordinate

    minHoneyKg = _minHoneyKg;
    maxHoneyKg = _maxHoneyKg;

    honeyGram = ((int)random(minHoneyKg, maxHoneyKg+1))*1000;

    int closeToEdge = 0;
    if (x < 60) closeToEdge++;
    if (x > width-60) closeToEdge++;
    //note: 90 for y because there are top and bottom stat bars
    if (y < 90) closeToEdge++;
    if (y > height-90) closeToEdge++;
    if (closeToEdge == 1) honeyGram *= random(1, 1.25);
    else if (closeToEdge >= 2) honeyGram *= random(1.25, 1.75);
    

    spawnAnimationTimer = gameMillis;
  }

  void updateForTraining(boolean _ft) {
    forTraining = _ft;
  }

  void updateForShop(boolean _fs) {
    forShop = _fs;
  }

  void transferFlower(float _honeyGram, int _pedalAmount, color[] _stamenPedalColor, float _angleOffset) {
    honeyGram = _honeyGram;
    pedalAmount = _pedalAmount;
    stamenColor = _stamenPedalColor[0];
    pedalColor = _stamenPedalColor[1];
    angleOffset = _angleOffset;
  }

  void updateRGB(int R, int G, int B) {
    colorR = R;
    colorG = G;
    colorB = B;
    stamenColor = color(colorR/1.5, colorG/1.5, colorB/1.5);
    pedalColor = color(colorR, colorG, colorB);
  }

  float angleOffset = random(PI);
  void showFlower() {
    if (forShop == false) {
      //flower spawn animation
      if (tutorialMinorStep < 100) flowerSize = map(honeyGram/1000, minHoneyKg, maxHoneyKg+1, 10, 20) * constrain(float(int(gameMillis-100-spawnAnimationTimer))/500, 0, 1);
      else if (forTraining == false) flowerSize = map(honeyGram/1000, forestHoneyRng[forestType][0], forestHoneyRng[forestType][1]+1, 10, 20) * constrain(float(int(gameMillis-100-spawnAnimationTimer))/500, 0, 1);
      else flowerSize = 15 * constrain(float(int(gameMillis-100-spawnAnimationTimer))/500, 0, 1);
      if (flowerSize < 5 && constrain(float(int(gameMillis-100-spawnAnimationTimer))/500, 0, 1) == 1) flowerSize = 5; //sometimes when the honey drops too low, the mapped value will be negative; flower too small cant see
      if (flowerSize < 0) flowerSize = 1;
    } else {
      float blockSize = (650 - 10*2 - 10*5)/5;
      float minimapLUx = 20 + blockSize*0.1, minimapLUy = 70 + (blockSize+10)*2.4;
      float minimapW = (blockSize+10)*3.3 - 135, minimapH = ((blockSize+10)*3.3 - 135) * ((600-30-40.0) / 800.0); //30 top, 40 bottom
      flowerSize = map(honeyGram/1000, forestHoneyRng[forestType][0], forestHoneyRng[forestType][1]+1, 10, 20) * (minimapW / width);
      if (flowerSize < 5 * (minimapW / width)) flowerSize = 5 * (minimapW / width); //sometimes when the honey drops too low, the mapped value will be negative; flower too small cant see
      if (flowerSize < 0) flowerSize = 1;
    }

    fill(200, 200, 200, 50);
    //if (debug) {
    //  noStroke();
    //  ellipse(f.x, f.y, FLOWER_DETECT_RADIUS, FLOWER_DETECT_RADIUS);
    //}
    //if (flowerSize < 5) println(flowerSize);
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


    fill(stamenColor);
    textSize(10);
    textAlign(CENTER);
    //text(honeyGram+"g", f.x, f.y-20);
    if (forTraining == false && forShop == false) text(ceil(honeyGram/1000)+"kg", f.x, f.y-20); //used to be f.y-8

    //if (f.x < 10 || f.x > width-10 || f.y < 30 || f.y > height-10) println(f.x, f.y);
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

  float getAngleOffset() {
    return angleOffset;
  }
}

long flowerTimer = 0; //to make things more difficult, the flowers can disappear after a certain time
void createFlower() {
  float nextFlowerTime = 6000; //default
  //if (forestType <= 4) nextFlowerTime = (0.0053*pow(flowers.size(), 3) - 0.12*pow(flowers.size(), 2) + 1.4667*flowers.size() )*1000;
  //else if (forestType == 5 || forestType == 6) nextFlowerTime = (0.0033*pow(flowers.size(), 3)-0.06*pow(flowers.size(), 2)+0.9167*flowers.size() )*1000;
  //else nextFlowerTime = (0.0033*pow(flowers.size(), 3)-0.07*pow(flowers.size(), 2)+0.9667*flowers.size() )*1000;

  float factFlowerN = flowers.size() / 1.5;
  float factBeeAtt = 0, factBeeAttDeduct = 0;
  for (Bee b : bees) {
    int beeType = b.getBeeType();
    float relaHoneySpeed = (beeHoneyPickingSpeed[beeType] / beeHoneyPickingSpeed[0]); //smaller
    float relaHoneyCap = (beeHoneyCapacity[beeType] / beeHoneyCapacity[0]);
    //factBeeAtt += sqrt(relaHoneySpeed) + log(relaHoneyCap);
    float increSpawnRateVal = 1/( sqrt(relaHoneySpeed) + log(relaHoneyCap)/log(10));
    float log10 = log(increSpawnRateVal)/log(10);
    float sum = increSpawnRateVal + log10/2;
    float determVal;
    if (sum > 0) determVal = 1/sum;
    else {
      determVal = log(abs(sum))/log(10);
      determVal = abs(1/pow(determVal, 5));
      determVal = pow(determVal, 0.25)*24;
    }
    determVal = log(10/determVal)/log(10); 
    if (determVal > 0) factBeeAtt += pow(determVal,-1); //see graph excel. x^-1
    else {
      if (determVal < -0.5) factBeeAttDeduct += determVal*2;
      else if (determVal < -0.3) factBeeAttDeduct += determVal*1.5;
      else factBeeAttDeduct += determVal*1;

      //println( sqrt(relaHoneySpeed), log(relaHoneyCap)/log(10), increSpawnRateVal, log10, sum, determVal, b.getBeeName());
    }
  }
  if (factBeeAtt == 0) factBeeAtt = 0 + factBeeAttDeduct;
  else factBeeAtt = 7*(1/factBeeAtt) + factBeeAttDeduct;



  float factEnemyPresent = -(hornets.size() + fireflies.size()*1.5);
  //if (factEnemyPresent != 0) factEnemyPresent = 1/factEnemyPresent;

  float factForestHoney = 2*log(forestHoneyRng[forestType][0] + (forestHoneyRng[forestType][1]-forestHoneyRng[forestType][0])/2);

  float x = factFlowerN + factBeeAtt + factEnemyPresent + factForestHoney;
  if (x < 5.858) nextFlowerTime = 0.0799*pow(x, 1.9871)*1000;
  else nextFlowerTime = (1.0915*x-3.714)*1000;
  
  if (Float.isNaN(nextFlowerTime)) nextFlowerTime = 100; //if x < 0, returns NaN

  if (factFlowerN <= bees.size()) { // if there are not enough flowers
    //check for delay time
    float delayTime = 0;
    for (Bee b : bees) {
      int beeType = b.getBeeType();
      float relaHoneySpeed = (beeHoneyPickingSpeed[beeType] / beeHoneyPickingSpeed[0]); //smaller
      float relaHoneyCap = (beeHoneyCapacity[beeType] / beeHoneyCapacity[0]);
      float beePropProduct = relaHoneySpeed * relaHoneyCap;
      float forestHoneyMean = 2*forestHoneyRng[forestType][0] + (forestHoneyRng[forestType][1]-forestHoneyRng[forestType][0])/2;
      if (beePropProduct > forestHoneyMean) {
        //doesn't belong in that forest
        float quotient = beePropProduct / forestHoneyMean;
        delayTime += 1000*(log(quotient)/log(10));
      } else continue;
    }

    if (debug) println("DELAY TIME TRIGGERED: " + delayTime + "ms");
    nextFlowerTime += delayTime;
  }

  if (debug) {
    fill(0);
    textSize(12);
    textAlign(LEFT);
    text("Next flower in: " + (int)((nextFlowerTime+flowerTimer)-gameMillis) + " (" + nextFlowerTime + ")", 20, height-8);

    println();
    println("DEBUG LINE: FLOWER SPAWN RATE FACTORS");
    println("Flower #: " + factFlowerN);
    println("Bee Attributes: " + factBeeAtt);
    println("Is Enemy Present: " + factEnemyPresent);
    println("Forest Honey Range: " + factForestHoney);
    println("Resultant Factor = " + x + " (" + nextFlowerTime + "ms)");
    println();
  }
  if (gameMillis - flowerTimer > nextFlowerTime) {
    flowers.add(new Flower(10+random(width-20), 40+random(height-40-50), forestHoneyRng[forestType][0], forestHoneyRng[forestType][1]));
    if (flowers.size() <= 5 && random(flowers.size()) < 2.5) flowers.add(new Flower(10+random(width-20), 40+random(height-40-50), forestHoneyRng[forestType][0], forestHoneyRng[forestType][1]));
    flowerTimer = gameMillis;
  }
}