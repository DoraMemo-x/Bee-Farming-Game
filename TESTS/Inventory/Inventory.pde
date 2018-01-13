ArrayList<Bee> inventoryBees = new ArrayList<Bee>();
Bee selectedInventoryBee;
boolean[] isBeeDead = new boolean[20];

int beeInvSelected = -1;
int beeInvSlot = 0;

int beehiveTier = 1;
static final int[] beehiveSize = {5, 10, 15, 20};

Button beeInvUp;
Button beeInvDown;

void setup() {
  size(800, 600);

  float blockSize = (650 - 10*2 - 10*5)/5;

  beeInvUp = new Button("", 20 + (blockSize+10)*3.7, 70 + (blockSize+10)*2 + 10, blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize), blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize), 180, 180, 180, 180, 180, 180);
  beeInvDown = new Button("", 20 + (blockSize+10)*4.35, 70 + (blockSize+10)*2 + 10, blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize), blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize), 180, 180, 180, 180, 180, 180);
  //println(blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize));

  noStroke();
  fill(180);
  for (int y = 0; y < 2; y++) {
    for (int x = 0; x < 5; x++) {
      rect(20 + (blockSize+10)*x, 70 + (blockSize+10)*y, blockSize, blockSize, 5, 5, 5, 5);

      int beeType = (int)random(beeName.length);
      inventoryBees.add(new Bee(beeType));
      inventoryBees.get(inventoryBees.size()-1).updateMoveTheta(HALF_PI);
      inventoryBees.get(inventoryBees.size()-1).updateForShop(true);
      inventoryBees.get(inventoryBees.size()-1).updateLocation(20 + blockSize/2 + (blockSize+10)*x, 70 + blockSize/2 + (blockSize+10)*y);

      if (beeType <= 1) isBeeDead[inventoryBees.size()-1] = true;
      else isBeeDead[inventoryBees.size()-1] = false;
    }
  }
}

//x0 650 ; y50 ~530
void draw() {
  background(210);

  float blockSize = (650 - 10*2 - 10*5)/5;

  fill(120);
  textAlign(LEFT);
  textSize(12);
  text("Viewing " + (beeInvSlot+1) + " - " + (beeInvSlot+10) + " bees", 25, 70 + (blockSize+10)*2 + 20);

  if (beeInvSlot == 0) beeInvUp.updateGreyOut(true);
  else beeInvUp.updateGreyOut(false);
  beeInvUp.Draw();
  noStroke();
  fill(120);
  beginShape();
  vertex(20 + (blockSize+10)*3.7   +   blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize)/2, 70 + (blockSize+10)*2 + 10   +   blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize)*0.4);
  vertex(20 + (blockSize+10)*3.7   +   blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize)*0.35, 70 + (blockSize+10)*2 + 10   +   blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize)*0.6);
  vertex(20 + (blockSize+10)*3.7   +   blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize)*0.65, 70 + (blockSize+10)*2 + 10   +   blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize)*0.6);
  endShape();
  beeInvDown.Draw();
  noStroke();
  fill(120);
  beginShape();
  vertex(20 + (blockSize+10)*4.35   +   blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize)/2, 70 + (blockSize+10)*2 + 10   +   blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize)*0.6);
  vertex(20 + (blockSize+10)*4.35   +   blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize)*0.35, 70 + (blockSize+10)*2 + 10   +   blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize)*0.4);
  vertex(20 + (blockSize+10)*4.35   +   blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize)*0.65, 70 + (blockSize+10)*2 + 10   +   blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize)*0.4);
  endShape();

  int counter = 0;
  noStroke();
  for (int y = 0; y < 2; y++) {
    for (int x = 0; x < 5; x++) {
      if (beeInvSelected != counter+beeInvSlot) fill(180);
      else fill(255, 255, 150);
      //block
      rect(20 + (blockSize+10)*x, 70 + (blockSize+10)*y, blockSize, blockSize, 5, 5, 5, 5);

      if (counter+beeInvSlot >= beehiveSize[beehiveTier]) {
        //lock
        pushMatrix();

        translate(20 + (blockSize+10)*x + blockSize/2, 70 + (blockSize+10)*y + blockSize/2   + 10);

        fill(60);
        rect(-30, -15, 60, 40);
        rect(-23, -30, 10, 30);
        rect(13, -30, 10, 30);
        arc(0, -30, (23+13+10), (23+13+10), PI, TWO_PI, OPEN);
        fill(180);
        arc(0, -30, (13+10+3), (13+10+3), PI, TWO_PI, OPEN);


        fill(255);
        ellipse(0, 0, 10, 10);
        beginShape();
        vertex(-5, 15);
        vertex( 5, 15);
        vertex(1.5, 0);
        vertex(-1.5, 0);
        endShape();

        popMatrix();
      }

      counter++;
    }
  }

  for (int i = beeInvSlot; i < min(10 + beeInvSlot, inventoryBees.size()); i++) {
    Bee b = inventoryBees.get(i);
    b.showBee();
  }

  counter = 0;
  for (int y = 0; y < 2; y++) {
    for (int x = 0; x < 5; x++) {
      if (isBeeDead[counter + beeInvSlot]) {
        fill(255, 0, 0, 60);
        rectMode(CORNERS);
        pushMatrix();
        translate(20 + (blockSize+10)*x, 70 + (blockSize+10)*y);
        beginShape();
        vertex(0, blockSize*0.5);
        vertex(0, blockSize*0.65);
        vertex(blockSize, blockSize*0.5);
        vertex(blockSize, blockSize*0.35);
        endShape();

        rotate(-radians(9));
        textSize(20);
        textAlign(CENTER);
        fill(200);
        text("D E    A D", blockSize*0.43, blockSize*0.64);
        fill(0);
        text("D E    A D", blockSize*0.42, blockSize*0.63);
        popMatrix();
        rectMode(CORNER);
      }
      counter++;
    }
  }
  
  //selected a bee in inventory
  if (beeInvSelected != -1) {
    fill(180);
    rect(20, 70 + (blockSize+10)*2.3, (blockSize+10)*3.5, blockSize*1.8, 5, 5, 5, 5);
    
    selectedInventoryBee.showBee();
    
    fill(60);
    textAlign(LEFT);
    textSize(12);
    text("Name:" + selectedInventoryBee.getBeeName(), 20 + (blockSize+10)*1.1, 70 + (blockSize+10)*2.3 + 20);
  }
}

void keyPressed() {
  if (key == 'p' || key == 'P') println(mouseX, mouseY);
  if (key == 's' || key == 'S') {
    int beeType = (int)random(beeName.length);
    inventoryBees.add(new Bee(beeType));
    inventoryBees.get(inventoryBees.size()-1).updateMoveTheta(HALF_PI);
    inventoryBees.get(inventoryBees.size()-1).updateForShop(true);

    if (beeType <= 1) isBeeDead[inventoryBees.size()-1] = true;
    else isBeeDead[inventoryBees.size()-1] = false;

    println(inventoryBees.size());
  }
  switch (key) {
  case '1':
    beehiveTier = 0;
    break;
  case '2':
    beehiveTier = 1;
    break;
  case '3':
    beehiveTier = 2;
    break;
  case '4':
    beehiveTier = 3;
    break;
  }
  println("beehive tier: " + beehiveTier);
}

void mouseReleased() {
  int counter = 0;
  float blockSize = (650 - 10*2 - 10*5)/5;
  //beeInvSelected = -1;
  for (int y = 0; y < 2; y++) {
    for (int x = 0; x < 5; x++) {
      if (counter+beeInvSlot < inventoryBees.size() && mouseX > 20 + (blockSize+10)*x && mouseX < 20 + (blockSize+10)*x + blockSize && mouseY > 70 + (blockSize+10)*y && mouseY < 70 + (blockSize+10)*y + blockSize) {
        beeInvSelected = counter + beeInvSlot;
        
        //update the big showcase bee to the one selected
        selectedInventoryBee = new Bee(inventoryBees.get(beeInvSelected).getBeeType());
        selectedInventoryBee.updateMoveTheta(HALF_PI);
        selectedInventoryBee.updateForShop(true);
        selectedInventoryBee.updateLocation(20 + blockSize/2, 70 + (blockSize+10)*2.3 + blockSize*0.9);
        
        rect(20, 70 + (blockSize+10)*2.3, (blockSize+10)*3.5, blockSize*1.8, 5, 5, 5, 5);
        break;
      } /* else beeInvSelected = -1; */
      counter++;
    }
    //if (beeInvSelected != -1) break;
  }

  println(beeInvSelected);

  counter = 0;
  if (beeInvUp.MouseClicked()) {
    beeInvSlot-=5;

    for (int y = 0; y < 2; y++) {
      for (int x = 0; x < 5; x++) {
        if (inventoryBees.size() > beeInvSlot+counter) {
          inventoryBees.get(beeInvSlot+counter).updateLocation(20 + blockSize/2 + (blockSize+10)*x, 70 + blockSize/2 + (blockSize+10)*y);
          counter++;
        } else break;
      }
    }
  }

  counter = 0;
  if (beeInvDown.MouseClicked()) {
    beeInvSlot+=5;

    for (int y = 0; y < 2; y++) {
      for (int x = 0; x < 5; x++) {
        println(inventoryBees.size(), beeInvSlot, counter);
        if (inventoryBees.size() > beeInvSlot+counter) {
          inventoryBees.get(beeInvSlot+counter).updateLocation(20 + blockSize/2 + (blockSize+10)*x, 70 + blockSize/2 + (blockSize+10)*y);
          counter++;
        } else break;
      }
    }
  }
}







static final int BEE_DIAMETER = 12;

static final float[] beeFlightSpeed = {0.8, 0.95, 1.1, 1.4, 1.7, 1.9, 2.8};
static final float[] beeHoneyPickingSpeed = {/*30*/10, 14, 21, 35, 60, 84, 105}; //gram per frame as unit, processing runs at 60FPS; not balanced
static final float[] beeHoneyCapacity = {5000, 15000, 25000, 50000, 100000, 200000, 400000}; //in gram
 static final String[] beeName = {"Honee", "Milkee", "Harvee", "Lovee", "Joycee", "Happee"/*, "Jumbee"*/};
color[] beeColour = {color(255, 125, 0), color(255, 150, 0), color(255, 175, 0), color(255, 255, 0), color(225, 250, 0), color(200, 225, 0), color(200, 150, 0)};

int beesCount = 0;

class Bee {
  float distinctID = random(1);

  String name = "missingname"; //used to identify which type the bee is
  int beeType = -1;

  PVector location; 
  float diameter = BEE_DIAMETER, radius;
  float speed;
  //  float xDir = 1, yDir = 1;
  float moveTheta = radians(random(360));
  boolean beeTimeoutMove = true;
  long beeMoveTimer = 0;
  //float moveTheta;
  float flowerX, flowerY;
  boolean insideFlower;
  boolean beeSelectedStatus = false;
  float currHoneyCap = 0, maxHoneyCap;
  boolean beeFull = false, reachedBeehive = false;
  float honeyPickingSpeed = 0;
  String beeTarget = "None"; //"Flower", "Beehive", ("Ready to move")

  boolean forShop = false;
  boolean forTraining = false;

  boolean nextStage = false;

  Bee(int _beeType) {
    beeType = _beeType;
    location = new PVector(width/2, height/2); //x,y coordinate
    radius = diameter/2;
    name = beeName[_beeType];
    speed = beeFlightSpeed[_beeType];
    maxHoneyCap = beeHoneyCapacity[_beeType];
    honeyPickingSpeed = beeHoneyPickingSpeed[_beeType];
  } 

  void updateLocation(float x, float y) {
    location = new PVector(x, y);
  }

  void updateBeeTimeoutMove(boolean newBeeTimeoutMove) {
    beeTimeoutMove = newBeeTimeoutMove;
  }

  void updateBeeMoveTimer(long newBeeMoveTimer) {
    beeMoveTimer = newBeeMoveTimer;
  }

  void updateInsideFlower(boolean newInsideFlower) {
    insideFlower = newInsideFlower;
  }

  void updateMoveTheta(float _theta) {
    moveTheta = _theta;
  }

  void updateFlowerLocation(float _flowerX, float _flowerY) {
    flowerX = _flowerX;
    flowerY = _flowerY;
  }

  void increaseHoneyCap(float honeyCapIncrement) {
    currHoneyCap += honeyCapIncrement;
  }

  void updateHoneyCap(float newHoneyCap) {
    currHoneyCap = newHoneyCap;
  }

  void updateShouldBeeMove(boolean _shouldBeeMove) {
    shouldBeeMove = _shouldBeeMove;
  }

  void updateBeeSelectedStatus(boolean _beeSelectedStatus) {
    beeSelectedStatus = _beeSelectedStatus;
  }

  void updateNextStage(boolean _nextStage) {
    nextStage = _nextStage;
  }

  void updateBeeTarget(String _beeTarget) {
    beeTarget = _beeTarget;
  }

  void resetDiameter() {
    diameter = BEE_DIAMETER;
  }

  void transferFlowerPedalAmount(int _flower_pedalAmount) {
    flower_pedalAmount = _flower_pedalAmount;
  }

  void transferFlowerColors(color[] __fColors) {
    flower_stamenColor = __fColors[0];
    flower_pedalColor = __fColors[1];
  }

  void updateForShop(boolean _forShop) {
    forShop = _forShop;
  }

  void updateForTraining(boolean _ft) {
    forTraining = _ft;
  }

  int flower_pedalAmount;
  color flower_stamenColor;
  color flower_pedalColor;
  void showBee() {
    radius = diameter /2; 

    for (int i = 0; i < beeFlightSpeed.length; i++) {
      if (speed == beeFlightSpeed[i]) fill(beeColour[i]);
      else if (speed == 3) fill(255, 255, 150);
    }
    if (beeType <= 1) fill(int((hue(beeColour[beeType]) + saturation(beeColour[beeType]) + brightness(beeColour[beeType])) / 3));
    stroke(0); 
    strokeWeight(2); 

    //body
    pushMatrix();
    translate(location.x, location.y);
    rotate(-moveTheta);
    line(0, 0, -diameter*1.7/2, 0); //sting of the bee
    ellipse(0, 0, diameter*1.5, diameter);

    //"zebra lines" on body (Body Pattern. Upgraded bees have special patterns)
    noStroke();
    fill(0);
    switch (beeType) {
    case 0:
    case 3:
      // *** center bar line ***
      beginShape();
      arc(0, 0, diameter*1.5, diameter, HALF_PI*3-radians(15), HALF_PI*3+radians(5));
      arc(0, 0, diameter*1.5, diameter, HALF_PI-radians(5), HALF_PI+radians(15));
      endShape();
      rect(-radius*1.5*cos(radians(75)), -radius*sin(radians(75)), radius*1.5*cos(radians(75)) *1.35, radius*sin(radians(75)) *2);

      // *** offset bar line(s) ***
      //     *** MOST LEFT ***
      arc(0, 0, diameter*1.5, diameter, radians(115), radians(135), CHORD);
      beginShape();
      vertex(-1.5*radius*cos(radians(45)), radius*sin(radians(45)));
      vertex(-1.5*radius*cos(radians(65)), radius*sin(radians(65)));
      vertex(-1.5*radius*cos(radians(65)), radius*sin(radians(45)));
      endShape();
      arc(0, 0, diameter*1.5, diameter, radians(180+45), radians(180+65), CHORD);
      beginShape();
      vertex(-1.5*radius*cos(radians(45)), -radius*sin(radians(45)));
      vertex(-1.5*radius*cos(radians(65)), -radius*sin(radians(65)));
      vertex(-1.5*radius*cos(radians(65)), -radius*sin(radians(45)));
      endShape();
      rect(-1.5*radius*cos(radians(45)), -radius*sin(radians(45)), 1.5*radius*cos(radians(45))-1.5*radius*cos(radians(65)), 2*radius*sin(radians(45)));
      break;

    case 1:
    case 4:
      // *** offset bar line(s) ***
      //     *** MOST LEFT ***
      int a = 120, b = 135;
      arc(0, 0, diameter*1.5, diameter, radians(a), radians(b), CHORD);
      beginShape();
      vertex(-1.5*radius*cos(radians(180-b)), radius*sin(radians(180-b)));
      vertex(-1.5*radius*cos(radians(180-a)), radius*sin(radians(180-a)));
      vertex(-1.5*radius*cos(radians(180-a)), radius*sin(radians(180-b)));
      endShape();
      arc(0, 0, diameter*1.5, diameter, radians(180+180-b), radians(180+180-a), CHORD);
      beginShape();
      vertex(-1.5*radius*cos(radians(180-b)), -radius*sin(radians(180-b)));
      vertex(-1.5*radius*cos(radians(180-a)), -radius*sin(radians(180-a)));
      vertex(-1.5*radius*cos(radians(180-a)), -radius*sin(radians(180-b)));
      endShape();
      rect(-1.5*radius*cos(radians(180-b)), -radius*sin(radians(180-b)), 1.5*radius*cos(radians(180-b))-1.5*radius*cos(radians(180-a)), 2*radius*sin(radians(180-b)));

      //    *** CENTER ***
      a = 95;
      b = 110;
      arc(0, 0, diameter*1.5, diameter, radians(a), radians(b), CHORD);
      beginShape();
      vertex(-1.5*radius*cos(radians(180-b)), radius*sin(radians(180-b)));
      vertex(-1.5*radius*cos(radians(180-a)), radius*sin(radians(180-a)));
      vertex(-1.5*radius*cos(radians(180-a)), radius*sin(radians(180-b)));
      endShape();
      arc(0, 0, diameter*1.5, diameter, radians(180+180-b), radians(180+180-a), CHORD);
      beginShape();
      vertex(-1.5*radius*cos(radians(180-b)), -radius*sin(radians(180-b)));
      vertex(-1.5*radius*cos(radians(180-a)), -radius*sin(radians(180-a)));
      vertex(-1.5*radius*cos(radians(180-a)), -radius*sin(radians(180-b)));
      endShape();
      rect(-1.5*radius*cos(radians(180-b)), -radius*sin(radians(180-b)), 1.5*radius*cos(radians(180-b))-1.5*radius*cos(radians(180-a)), 2*radius*sin(radians(180-b)));

      //    ** RIGHT **
      a = 75;
      b = 85;
      arc(0, 0, diameter*1.5, diameter, radians(a), radians(b), CHORD);
      beginShape();
      vertex(1.5*radius*cos(radians(a)), radius*sin(radians(a)));
      vertex(1.5*radius*cos(radians(b)), radius*sin(radians(b)));
      vertex(1.5*radius*cos(radians(b)), radius*sin(radians(a)));
      endShape();
      arc(0, 0, diameter*1.5, diameter, radians(180+180-b), radians(180+180-a), CHORD);
      beginShape();
      vertex(1.5*radius*cos(radians(a)), -radius*sin(radians(a)));
      vertex(1.5*radius*cos(radians(b)), -radius*sin(radians(b)));
      vertex(1.5*radius*cos(radians(b)), -radius*sin(radians(a)));
      endShape();
      rect(1.5*radius*cos(radians(b)), -radius*sin(radians(a)), 1.5*radius*cos(radians(a))-1.5*radius*cos(radians(b)), 2*radius*sin(radians(a)));

      break;

    case 2:
    case 5:
      // *** offset bar line(s) ***
      //     *** MOST LEFT ***
      a = 127;
      b = 136;
      arc(0, 0, diameter*1.5, diameter, radians(a), radians(b), CHORD);
      beginShape();
      vertex(-1.5*radius*cos(radians(180-b)), radius*sin(radians(180-b)));
      vertex(-1.5*radius*cos(radians(180-a)), radius*sin(radians(180-a)));
      vertex(-1.5*radius*cos(radians(180-a)), radius*sin(radians(180-b)));
      endShape();
      arc(0, 0, diameter*1.5, diameter, radians(180+180-b), radians(180+180-a), CHORD);
      beginShape();
      vertex(-1.5*radius*cos(radians(180-b)), -radius*sin(radians(180-b)));
      vertex(-1.5*radius*cos(radians(180-a)), -radius*sin(radians(180-a)));
      vertex(-1.5*radius*cos(radians(180-a)), -radius*sin(radians(180-b)));
      endShape();
      rect(-1.5*radius*cos(radians(180-b)), -radius*sin(radians(180-b)), 1.5*radius*cos(radians(180-b))-1.5*radius*cos(radians(180-a)), 2*radius*sin(radians(180-b)));

      //    *** LEFT ***
      a = 111;
      b = 119;
      arc(0, 0, diameter*1.5, diameter, radians(a), radians(b), CHORD);
      beginShape();
      vertex(-1.5*radius*cos(radians(180-b)), radius*sin(radians(180-b)));
      vertex(-1.5*radius*cos(radians(180-a)), radius*sin(radians(180-a)));
      vertex(-1.5*radius*cos(radians(180-a)), radius*sin(radians(180-b)));
      endShape();
      arc(0, 0, diameter*1.5, diameter, radians(180+180-b), radians(180+180-a), CHORD);
      beginShape();
      vertex(-1.5*radius*cos(radians(180-b)), -radius*sin(radians(180-b)));
      vertex(-1.5*radius*cos(radians(180-a)), -radius*sin(radians(180-a)));
      vertex(-1.5*radius*cos(radians(180-a)), -radius*sin(radians(180-b)));
      endShape();
      rect(-1.5*radius*cos(radians(180-b)), -radius*sin(radians(180-b)), 1.5*radius*cos(radians(180-b))-1.5*radius*cos(radians(180-a)), 2*radius*sin(radians(180-b)));

      //    ** RIGHT **
      a = 95;
      b = 103;
      arc(0, 0, diameter*1.5, diameter, radians(a), radians(b), CHORD);
      beginShape();
      vertex(-1.5*radius*cos(radians(180-b)), radius*sin(radians(180-b)));
      vertex(-1.5*radius*cos(radians(180-a)), radius*sin(radians(180-a)));
      vertex(-1.5*radius*cos(radians(180-a)), radius*sin(radians(180-b)));
      endShape();
      arc(0, 0, diameter*1.5, diameter, radians(180+180-b), radians(180+180-a), CHORD);
      beginShape();
      vertex(-1.5*radius*cos(radians(180-b)), -radius*sin(radians(180-b)));
      vertex(-1.5*radius*cos(radians(180-a)), -radius*sin(radians(180-a)));
      vertex(-1.5*radius*cos(radians(180-a)), -radius*sin(radians(180-b)));
      endShape();
      rect(-1.5*radius*cos(radians(180-b)), -radius*sin(radians(180-b)), 1.5*radius*cos(radians(180-b))-1.5*radius*cos(radians(180-a)), 2*radius*sin(radians(180-b)));

      //    ** MOST RIGHT **
      a = 79;
      b = 87;
      arc(0, 0, diameter*1.5, diameter, radians(a), radians(b), CHORD);
      beginShape();
      vertex(1.5*radius*cos(radians(a)), radius*sin(radians(a)));
      vertex(1.5*radius*cos(radians(b)), radius*sin(radians(b)));
      vertex(1.5*radius*cos(radians(b)), radius*sin(radians(a)));
      endShape();
      arc(0, 0, diameter*1.5, diameter, radians(180+180-b), radians(180+180-a), CHORD);
      beginShape();
      vertex(1.5*radius*cos(radians(a)), -radius*sin(radians(a)));
      vertex(1.5*radius*cos(radians(b)), -radius*sin(radians(b)));
      vertex(1.5*radius*cos(radians(b)), -radius*sin(radians(a)));
      endShape();
      rect(1.5*radius*cos(radians(b)), -radius*sin(radians(a)), 1.5*radius*cos(radians(a))-1.5*radius*cos(radians(b)), 2*radius*sin(radians(a)));
      break;
    }

    //sclera (white part of the eye)
    stroke(0);
    strokeWeight(1);
    fill(255);
    ellipse(diameter*0.65, diameter*0.35, diameter*0.65, diameter*0.65);
    ellipse(diameter*0.65, -diameter*0.35, diameter*0.65, diameter*0.65);

    //eyeballs (black)
    if (beeType <= 1) {
      //noStroke();
      stroke(50);
      strokeWeight(1.5);
      line(diameter*0.65 - diameter*0.2, diameter*0.35 + diameter*0.2, diameter*0.65 + diameter*0.2, diameter*0.35 - diameter*0.2);
      line(diameter*0.65 + diameter*0.2, diameter*0.35 + diameter*0.2, diameter*0.65 - diameter*0.2, diameter*0.35 - diameter*0.2);
      line(diameter*0.65 - diameter*0.2, -diameter*0.35 + diameter*0.2, diameter*0.65 + diameter*0.2, -diameter*0.35 - diameter*0.2);
      line(diameter*0.65 + diameter*0.2, -diameter*0.35 + diameter*0.2, diameter*0.65 - diameter*0.2, -diameter*0.35 - diameter*0.2);
      noStroke();
    } else {
      noStroke();
      fill(50);
      ellipse(diameter*0.65, diameter*0.35, diameter*0.25, diameter*0.25);
      ellipse(diameter*0.65, -diameter*0.35, diameter*0.25, diameter*0.25);
    }

    //bigger wings
    fill(200, 200, 200, 150);
    pushMatrix();
    translate(0, diameter*1);
    rotate(radians(60));
    ellipse(0, 0, diameter*1.5, diameter);
    popMatrix();
    pushMatrix();
    translate(0, -diameter*1);
    rotate(-radians(60));
    ellipse(0, 0, diameter*1.5, diameter);
    popMatrix();

    //smaller wings
    pushMatrix();
    translate(-5, diameter*0.8);
    rotate(radians(50));
    ellipse(0, 0, diameter*1.2, diameter);
    popMatrix();
    pushMatrix();
    translate(-5, -diameter*0.8);
    rotate(-radians(50));
    ellipse(0, 0, diameter*1.2, diameter);
    popMatrix();



    popMatrix();
    //noStroke();
    //fill(50, 50, 50, 100);
    //rect(location.x-20, location.y-41, 80, 10, 5);
    //  if (currHoneyCap == maxHoneyCap) fill(255, 50, 50);
    //    else {
    //      for (int i = 0; i < beeFlightSpeed.length; i++) {
    //        if (speed == beeFlightSpeed[i]) fill(beeColour[i]);
    //        else if (speed == 3) fill(255, 255, 150);
    //      }
    //    }
    if (currHoneyCap == maxHoneyCap) fill(255, 50, 50);
    else fill(150);

    if (forShop == false && forTraining == false) {
      textSize(10);
      textAlign(CENTER);
      //text(currHoneyCap+"g", location.x, location.y-30);
      text(floor((currHoneyCap)/1000)+"kg", location.x, location.y-31); //used to be -8
    }
  }


  boolean shouldBeeMove = true;
  int flowerID = -1;
  //go towards the flower, stop at the middle of the flower,
  //until capacity full / no more honey, 
  //then leave the flower.
  int stuckFrames = 0;
  boolean dumpingHoney = false;

  int getBeeType() {
    return beeType;
  }

  float getSpeed() {
    return speed;
  }

  boolean getNextStage() {
    return nextStage;
  }

  boolean getBeeSelectedStatus() {
    return beeSelectedStatus;
  }

  boolean getBeeTimeoutMove() {
    return beeTimeoutMove;
  }

  float getHoneyPickingSpeed() {
    return honeyPickingSpeed;
  }

  float getCurrHoneyCap() {
    return currHoneyCap;
  }

  float getMaxHoneyCap() {
    return maxHoneyCap;
  }

  boolean getInsideFlower() {
    return insideFlower;
  }

  PVector getLocation() { 
    return location;
  }

  String getBeeName() {
    return name;
  }

  String getBeeTarget() {
    return beeTarget;
  }

  int getPedalAmount() {
    return flower_pedalAmount;
  }

  color[] getFlowerColors() {
    color[] temp = new color[2];
    temp[0] = flower_stamenColor;
    temp[1] = flower_pedalColor;
    return temp;
  }

  float getDiameter() {
    return diameter;
  }

  float getDistinctID() {
    return distinctID;
  }
}

class Button {
  String label;
  float x;    // top left corner x position
  float y;    // top left corner y position
  float w;    // width of button
  float h;    // height of button
  int fillR = 251, fillG = 200, fillB = 55;
  color fillColour = color(fillR, fillG, fillB);
  int lFillR = constrain(fillR+15, 0, 255), lFillG = constrain(fillG+15, 0, 255), lFillB = constrain(fillB+15, 0, 255);
  int strokeR = 119, strokeG = 94, strokeB = 26;

  Button(String labelB, float xpos, float ypos, float widthB, float heightB, int _fillR, int _fillG, int _fillB, int _strokeR, int _strokeG, int _strokeB) {
    label = labelB;
    x = xpos;
    y = ypos;
    w = widthB;
    h = heightB;
    if (fillR > 0 && fillG > 0 && fillB > 0) {
      fillR = _fillR;
      fillG = _fillG;
      fillB = _fillB;
      lFillR = constrain(fillR+15, 0, 255);
      lFillG = constrain(fillG+15, 0, 255);
      lFillB = constrain(fillB+15, 0, 255);
    }
    if (strokeR > 0 && strokeG > 0 && strokeB > 0) {
      strokeR = _strokeR;
      strokeG = _strokeG;
      strokeB = _strokeB;
    }
  }

  void updateLabel(String _label) {
    label = _label;
  }

  void updateGreyOut(boolean _greyOut) {
    greyOut = _greyOut;
  }

  void updateXY(float _x, float _y) {
    x = _x;
    y = _y;
  }

  void updateSize(float _w, float _h) {
    w = _w;
    h = _h;
  }

  void updateMouseIsOver(boolean _newMIO) {
    mouseIsOver = _newMIO;
  }

  boolean mouseIsOver = false, greyOut = false;
  void Draw() {
    if (greyOut && fillR == 180 && fillG == 180 && fillB == 180) fill(120); //for up down buttons.
    else if (greyOut) fill(saturation(fillColour));
    else if (mouseIsOver) fill(lFillR, lFillG, lFillB);
    else fill(fillR, fillG, fillB);
    stroke(strokeR, strokeG, strokeB);
    strokeWeight(2);
    rect(x, y, w, h, 10);
    textSize(12);
    textAlign(CENTER, CENTER);
    PFont lineFont = createFont("Lucida Sans Regular", 12);
    textFont(lineFont);
    fill(0);
    text(label, x + (w / 2), y + (h / 2)-2);

    if (mouseX > x && mouseX < (x + w) && mouseY > y && mouseY < (y + h)) mouseIsOver = true;
    else mouseIsOver = false;
  }

  boolean MouseClicked() {
    if (mouseX > x && mouseX < (x + w) && mouseY > y && mouseY < (y + h) && greyOut == false) {
      return true;
    } 
    return false;
  }

  boolean getMouseIsOver() {
    if (greyOut) mouseIsOver = false;
    return mouseIsOver;
  }
}