static final int BEE_DIAMETER = 12;

static final float[] beeFlightSpeed = {0.8, 0.95, 1.1, 1.4, 1.7, 1.9, 0.35, 1.8, 1.2, 1.4};
static final float[] beeHoneyPickingSpeed = {/*30*/10, 14, 21, 35, 60, 84, 0, 28, 40, 28}; //gram per frame as unit, processing runs at 60FPS; not balanced
static final float[] beeHoneyCapacity = {5000, 15000, 25000, 50000, 100000, 200000, 0, 80000, 75000, 125000}; //in gram
static final String[] beeName = {"Honee", "Milkee", "Harvee", "Lovee", "Joycee", "Happee"};
color[] beeColour = {color(255, 125, 0), color(255, 150, 0), color(255, 175, 0), color(255, 255, 0), color(225, 250, 0), color(200, 225, 0), color(250, 255, 190), color(255, 205, 148), color(0, 150, 0), color(200, 100, 0)};
color undeadColour = color(65, 94, 60);
static final String[] upgradedBeeName = {"Priest Bee", "Undead Bee", "Gardening Bee", "RushB"};
static final float[] upgradeBeeCost = {80000, 60000, 100000, 80000}; //money
static final String[][] upgradedBeeDescription = {
  {"|b"+upgradedBeeName[0], "|i$"+nfc(int(upgradeBeeCost[0])), "", "|rAttributes:", "- Unable to gather honey.", "- Moves incredibly slowly.", "", "|rAbility "+ char(34) + "" + char(1505)+""+char(1492)+""+char(1503)+""+char(1499)+char(1492)+""+char(1501)+""+char(1496)+""+char(1506)+""+char(1495)+""+char(1506)+""+char(1502)+""+char(1508)+""+char(1499)+"" + char(34)+":", "- Revives A Dead Bee", "  * Reviving time depends on the tier."}, //1498=A 
  {"|b"+upgradedBeeName[1], "|i$"+nfc(int(upgradeBeeCost[1])), "", "|rAttribute: Has two lives.", "- First Life:", "  Moves very quickly but gathers honey slowly", "- Second Life:", "  Moves significantly slower but gathers honey much quicker;", "  However, its capacity becomes smaller"}, 
  {"|b"+upgradedBeeName[2], "|i$"+nfc(int(upgradeBeeCost[2])), "", "|rResource Ability " + char(34) + "Nature's Path" + char(34) + ":", "  Stores 20% of its gathered honey,", "  Charges a toggleable ability for", "  planting flowers in the path it moves in.", "", "  * Honey amount depends on the tier.", "Drawback:", "- Mediocre flight speed"}, 
  {"|b"+upgradedBeeName[3], "|i$"+nfc(int(upgradeBeeCost[3])), "", "|rCooldown Ability " + char(34) + "Adrenaline" + char(34) + ":", "  Increases its flight speed", "  and honey pick-up speed for the duration.", "", "Drawback:", "- Normally mediocre honey pick-up speed"}, 
};

static final int[][] beeCDAVar = {{35000, 0}, {0, 0}, {6000, 12000}, {7000, 10000}}; //CDATimer, CDACooldown (note that gardening bee Cooldown is not time, it's honey gram)
//int beeMoveTimer = 0;
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
  boolean isAlive = true;

  boolean forShop = false;
  boolean forTraining = false;

  boolean nextStage = false;

  boolean CDAbility = false; //is the bee using the ability
  int CDATimer = 0; //Cooldown Ability Timer (how long can/does the ability last)
  int CDACooldown = 10000; //Cooldown Ability cooldown (ms)

  int maxDuration = 0, maxCooldown = 0;

  int spTier = 1; //for priest / gardening only

  Bee(int _beeType) {
    beeType = _beeType;
    location = new PVector(width/2, height/2); //x,y coordinate
    radius = diameter/2;
    if (beeType >= beeName.length) {
      int spBeeType = _beeType - beeName.length;
      name = upgradedBeeName[spBeeType];

      if (spBeeType == 0) CDATimer = beeCDAVar[0][0]; //Priest Bee, revive taking duration (35s)
      else if (spBeeType == 2) CDATimer = beeCDAVar[2][0]; //Gardening Bee, spread seed lasting duration
      else if (spBeeType == 3) { //RushB
        //CDATimer = beeCDAVar[3][0]; 
        CDACooldown = 0;
      }
    } else name = beeName[_beeType];
    speed = beeFlightSpeed[_beeType];
    maxHoneyCap = beeHoneyCapacity[_beeType];
    honeyPickingSpeed = beeHoneyPickingSpeed[_beeType];
  } 

  void updateIsAlive(boolean _b) {
    isAlive = _b;
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

    if (beeTarget.equals("Flower")) {
      for (int f = flowers.size ()-1; f >= 0; f--) {
        Flower _flower = flowers.get(f);
        if (flower_pedalAmount == _flower.getPedalAmount() && flower_stamenColor == _flower.getStamenPedalColor()[0]) {
          float fx = _flower.getLocation().x;
          float fy = _flower.getLocation().y;

          distanceRecorded = distance_between_two_points(fx, location.x, fy, location.y);
          distanceCheckTimer = gameMillis;
          initialDistanceCheck = true;
          break;
        }
      }
    } else if (beeTarget.equals("Beehive")) {
      distanceRecorded = distance_between_two_points(width/2, location.x, height/2, location.y);
      distanceCheckTimer = gameMillis;
      initialDistanceCheck = true;
    }
  }

  void resetDiameter() {
    diameter = BEE_DIAMETER;
  }

  void updateDiameter(float _d) {
    diameter = _d;
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

  void updateHyperSelectedStatus(boolean _hss) {
    hyperSelectedStatus = _hss;
  }

  void updateCDAbility(boolean _a) {
    CDAbility = _a;
  }

  void updateTier(int _tier) {
    spTier = _tier;
    if (beeType-beeName.length == 0) {
      if (spTier == 1) maxDuration = beeCDAVar[0][0];
      else if (spTier == 2) maxDuration = int(beeCDAVar[0][0]*0.8);
      else if (spTier == 3) maxDuration = int(beeCDAVar[0][0]*0.5);

      CDATimer = maxDuration;
    } else if (beeType-beeName.length == 2) { //gardening
      if (spTier == 1) {
        maxDuration = beeCDAVar[2][0];
        maxCooldown = beeCDAVar[2][1];
      } else if (spTier == 2) {
        maxDuration = int(beeCDAVar[2][0]*1.05);
        maxCooldown = int(beeCDAVar[2][1]*0.9);
      } else if (spTier == 3) {
        maxDuration = int(beeCDAVar[2][0]*1.175);
        maxCooldown = int(beeCDAVar[2][1]*0.825);
      } else if (spTier == 4) {
        maxDuration = int(beeCDAVar[2][0]*1.4);
        maxCooldown = int(beeCDAVar[2][1]*0.7);
      }
    }
  }

  int flower_pedalAmount;
  color flower_stamenColor;
  color flower_pedalColor;

  //Special Bee Variables
  int txtChangeTimer = 250;
  String appearTxt = "";
  int[] rndLoc = new int[16];
  void showBee() {
    if (isAlive == false && forShop == false) diameter = BEE_DIAMETER / 2; 
    //else if (isAlive && dumpingHoney == false && roundOver == false) diameter = BEE_DIAMETER;

    radius = diameter /2; 

    for (int i = 0; i < beeName.length; i++) {
      if (name.equals(beeName[i])) {
        fill(beeColour[i]);
        break;
      }
    }
    for (int i = 0; i < upgradedBeeName.length; i++) {
      if (name.equals(upgradedBeeName[i])) {
        fill(beeColour[i+beeName.length]);
        if (i == 1 && CDAbility) fill(undeadColour);
        break;
      }
    }
    if (isAlive == false) fill(int((hue(beeColour[beeType]) + saturation(beeColour[beeType]) + brightness(beeColour[beeType])) / 3));
    stroke(0);
    float blockSize = (650 - 10*2 - 10*5)/5;
    float minimapW = (blockSize+10)*3.3 - 135;

    //body
    pushMatrix();
    translate(location.x, location.y);
    rotate(-moveTheta);
    strokeWeight(0.5);
    line(0, 0, -diameter*1.85/2, 0); //sting of the bee
    if (diameter != BEE_DIAMETER * (minimapW / width)) strokeWeight(2);
    else strokeWeight(1);
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
    if (isAlive) {
      noStroke();
      fill(50);
      ellipse(diameter*0.65, diameter*0.35, diameter*0.25, diameter*0.25);
      ellipse(diameter*0.65, -diameter*0.35, diameter*0.25, diameter*0.25);
    } else { //dead
      stroke(50);
      strokeWeight(1.5);
      line(diameter*0.65 - diameter*0.2, diameter*0.35 + diameter*0.2, diameter*0.65 + diameter*0.2, diameter*0.35 - diameter*0.2);
      line(diameter*0.65 + diameter*0.2, diameter*0.35 + diameter*0.2, diameter*0.65 - diameter*0.2, diameter*0.35 - diameter*0.2);
      line(diameter*0.65 - diameter*0.2, -diameter*0.35 + diameter*0.2, diameter*0.65 + diameter*0.2, -diameter*0.35 - diameter*0.2);
      line(diameter*0.65 + diameter*0.2, -diameter*0.35 + diameter*0.2, diameter*0.65 - diameter*0.2, -diameter*0.35 - diameter*0.2);
      noStroke();
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



    if (isAlive && forShop == false) {
      if (beeSelectedStatus) {
        fill(255, 0, 0);
        textSize(12);
        textAlign(CENTER);
        text("Ready to move!", location.x, location.y+25);
      }
      if (beeTarget.equals("Flower")) {
        strokeWeight(1);
        stroke(200);
        fill(255, 255, 255, 150);
        beginShape();
        vertex(location.x, location.y+10);
        vertex(location.x+5, location.y+20);
        vertex(location.x+20, location.y+20);
        vertex(location.x+20, location.y+60);
        vertex(location.x-20, location.y+60);
        vertex(location.x-20, location.y+20);
        vertex(location.x-5, location.y+20);
        vertex(location.x, location.y+10);
        endShape();

        //flower pedals
        strokeWeight(10);
        stroke(flower_pedalColor, 200);
        pushMatrix();
        translate(location.x, location.y+40);
        for (int i = 0; i < flower_pedalAmount; i++) {
          rotate(TWO_PI/flower_pedalAmount);
          line(0, 0, 10 /*flowerSize*/, 0);
        }
        popMatrix();

        //flower center
        fill(flower_stamenColor, 200);
        strokeWeight(0);
        ellipse(location.x, location.y+40, 10, 10);
      } else if (beeTarget.equals("Beehive")) {
        strokeWeight(1);
        stroke(200);
        fill(255, 255, 255, 150);
        beginShape();
        vertex(location.x, location.y+10);
        vertex(location.x+5, location.y+20);
        vertex(location.x+15, location.y+20);
        vertex(location.x+15, location.y+50);
        vertex(location.x-15, location.y+50);
        vertex(location.x-15, location.y+20);
        vertex(location.x-5, location.y+20);
        vertex(location.x, location.y+10);
        endShape();

        stroke(252, 232, 100);
        fill(221, 114, 1);
        polygon(location.x, location.y+35, 9, 6);
      } 

      int spType = beeType - beeName.length;
      switch (spType) {
      case 0: //Priest Bee
        if (beeTarget.equals("Revive")) {
          fill(113, 100, 86);
          textSize(10);
          textAlign(CENTER);
          text("I see the soul that it has inside", location.x, location.y-15);
        } else if (hyperSelectedStatus) {
          fill(113, 100, 86);
          textSize(10);
          textAlign(CENTER);
          text("Where is the dead...", location.x, location.y-15);
        } else if (CDAbility) { //reviving
          txtChangeTimer -= timePassed;
          if (txtChangeTimer < 0) {
            appearTxt = "";
            for (int i = 0; i < int(random(5, 10)); i++) {
              appearTxt += char(1488+int(random(0, 26)));
            }
            txtChangeTimer = 250;
          }

          fill(113, 100, 86);
          textSize(10);
          textAlign(CENTER);
          text(appearTxt, location.x, location.y-15);

          noStroke();
          fill(255, 255, 0, 150);
          arc(location.x, location.y, diameter*3, diameter*3, -HALF_PI, map(CDATimer, 0, maxDuration, -HALF_PI, PI+HALF_PI), PIE);

          moveTheta += radians(1);
        }
        break;

      case 2: //Gardening Bee
        if (CDAbility) {
        } else {
          strokeWeight(1);
          stroke(50);
          noFill();
          rect(location.x+15, location.y-10, 6, 20);

          rectMode(CORNERS);
          noStroke();
          if (CDACooldown == 0) fill(12, 124, 13);
          else fill(beeColour[beeType]);

          //println(CDACooldown);

          rect(location.x+15.25, map(CDACooldown, maxCooldown, 0, location.y+10, location.y-10), location.x+20.75, location.y+9.75);
          rectMode(CORNER);
        }
        break;

      case 3: //RushB
        if (CDAbility) {
          fill(180, 180, 255);
          textSize(16);
          textAlign(CENTER);
          txtChangeTimer -= timePassed;
          if (txtChangeTimer < 0) {
            txtChangeTimer = 250;
            for (int r = 0; r < rndLoc.length; r++) rndLoc[r] = int((random(1)>0.5?1:-1)*random(15));
          }
          for (int i = 0; i < rndLoc.length; i+=2) {
            int rndX = int(rndLoc[i]>0? rndLoc[i]+diameter*0.75 : rndLoc[i]-diameter*0.75);
            int rndY = int(rndLoc[i+1]>0? rndLoc[i+1]+diameter*0.75 : rndLoc[i+1]-diameter*0.75);
            text("↑", location.x+rndX, location.y+rndY + map(txtChangeTimer, 0, 250, 0, 10));
          }
        } else { //not using ability
          strokeWeight(1);
          stroke(50);
          noFill();
          rect(location.x+15, location.y-10, 6, 20);

          rectMode(CORNERS);
          noStroke();
          if (CDACooldown == 0) fill(12, 124, 13);
          else fill(beeColour[beeType]);

          //println(CDACooldown);

          rect(location.x+15.25, map(CDACooldown, beeCDAVar[3][1], 0, location.y+10, location.y-10), location.x+20.75, location.y+9.75);
          rectMode(CORNER);

          //fill(255);
          //textSize(8);
          //if (CDACooldown >0) text(ceil(float(CDACooldown)/1000), location.x, location.y+2);
        }
        break;
      }

      if (currHoneyCap == maxHoneyCap) fill(255, 50, 50);
      else fill(150);

      if (isAlive && forShop == false && forTraining == false && name.equals(upgradedBeeName[0]) == false) {
        textSize(10);
        textAlign(CENTER);
        //text(currHoneyCap+"g", location.x, location.y-41);
        text(floor((currHoneyCap)/1000)+"kg", location.x, location.y-31); //used to be -8
      }
    }
  }

  void resetRevive() {
    hyperSelectedStatus = false;
    shouldBeeMove = true;
    CDATimer = maxDuration;
    CDAbility = false;
    targetBeeDistinctID = -1;
    beeTarget = "None";
  }

  float distanceRecorded;
  long distanceCheckTimer = gameMillis;
  boolean initialDistanceCheck = true;
  boolean shouldBeeMove = true;
  int flowerID = -1;

  int stuckFrames = 0;
  boolean dumpingHoney = false;

  //Priest Bee Specific
  float targetBeeDistinctID = -1;
  //////////
  //Gardening Bee Specific
  float honeyIntake = 0;
  //////////
  boolean hyperSelectedStatus = false;
  void move() {
    int spType = beeType - beeName.length;

    if (isAlive) {
      if (beeType >= beeName.length) { //if it is a special bee (trained bee)

        switch (spType) {
        case 0: //Priest Bee
          if ((beeTarget.equals("Revive") || hyperSelectedStatus) && beeSelectedStatus) { //if the bee is going to revive, but then the player selected it
            resetRevive();
          }


          if (CDAbility) { //if using ability
            if (beeSelectedStatus == false) {
              shouldBeeMove = false;
              CDATimer -= timePassed; //35000ms - timePassed
              if (CDATimer <= 0) { //if the timer is up (35s has passed)
                for (Bee b : bees) {
                  if (targetBeeDistinctID == b.getDistinctID()) {
                    b.updateBeeSelectedStatus(false); //deselect the corpse
                    b.updateDiameter(BEE_DIAMETER); //change diameter back to normal
                    b.updateIsAlive(true); //revive the bee
                    break;
                  }
                }
                resetRevive();
              }
            } else { //if it's reviving, but it's selected again
              //cancel revive. reset everything
              resetRevive();
            }
          }

          if (beeTarget.equals("Revive")) { //if priest is on the way to revive
            for (Bee b : bees) {
              if (targetBeeDistinctID == b.getDistinctID() && distance_between_two_points(location.x, b.getLocation().x, location.y, b.getLocation().y) < 2) { //if priest is close enough to the target corpse
                beeTarget = "None";
                hyperSelectedStatus = false;
                shouldBeeMove = false; //do not move, because reviving
                CDAbility = true; //using ability "REVIVE"
                break;
              }
            }
          }

          if (hyperSelectedStatus && beesSelectedCurr > 0 && beeTarget.equals("Revive") == false) { // if player targeted a revivable bee
            //check which one is the target
            for (Bee b : bees) {
              if (b.getBeeSelectedStatus() && b.getIsAlive() == false) { //if we get the target, (the dead corpse is selected)
                b.updateBeeSelectedStatus(false); //deselect the corpse
                beeTarget = "Revive";
                targetBeeDistinctID = b.getDistinctID(); //assign target ID
                moveTheta = calcMoveTheta(b.getLocation().x, b.getLocation().y, location.x, location.y); //move to target

                break; //break out of for
              }
            }
          }

          if (roundOver && distance_between_two_points(location.x, width/2, location.y, height/2) < 2) dumpHoneyAnimation();
          break;

        case 2: //Gardening Bee

          if (CDATimer >= maxDuration) { //if the timer is up
            CDAbility = false;
            CDATimer = 0;
            beeTimeoutMove = true;
            CDACooldown = maxCooldown;
          }

          if (CDAbility) {
            CDATimer += timePassed; //-= timePassed

            int frequency = 500;
            int forestAvg = (forestHoneyRng[forestType][0]+forestHoneyRng[forestType][1])/2;

            if (forestType == 0) frequency = 350;
            else if (forestAvg < 10) frequency = 500;
            else if (forestAvg < 30) frequency = 1000;
            else frequency = 1500;
            //for the duration
            shouldBeeMove = true;
            beeTimeoutMove = false;
            txtChangeTimer += timePassed; //***** im using txtChangeTimer as the mechanic timer (frequency)
            if (txtChangeTimer >= frequency) { //frequency = once per 500ms (so duration/frequency flowers)
              txtChangeTimer = 0;
              flowers.add(new Flower(location.x, location.y, floor(forestHoneyRng[forestType][0]*sqrt(spTier)), floor(int(forestHoneyRng[forestType][1]*0.75)*sqrt(spTier)) ));
              flowers.get(flowers.size()-1).updateRGB(0, 150, 0);
            }
          } else {
            CDACooldown -= honeyIntake;
            honeyIntake = 0;
            CDACooldown = constrain(CDACooldown, 0, maxCooldown);
          }


          print("Requires: "+maxCooldown);
          println(" ; CDACooldown: "+CDACooldown);
          break;

        case 3: //RushB
          if (CDATimer >= beeCDAVar[3][0]) { //activated for 7s, stop
            CDACooldown = beeCDAVar[3][1];

            CDAbility = false;
            CDATimer = 0;
            speed = beeFlightSpeed[beeType];
            honeyPickingSpeed = beeHoneyPickingSpeed[beeType];
          }

          if (CDAbility) {
            CDATimer += timeMillis-pMillis;

            speed = beeFlightSpeed[beeType]*1.5;
            honeyPickingSpeed = beeHoneyPickingSpeed[beeType]*4;
          } else {
            CDACooldown -= timeMillis-pMillis;
            CDACooldown = constrain(CDACooldown, 0, beeCDAVar[3][1]);
          }
          break;
        }
      }

      if (forTraining == false && !(spType == 2 && CDAbility)) {
        for (int i = resourceAppear.size()-1; i >= 0; i--) {
          ItemSpawn is = resourceAppear.get(i);
          println(distance_between_two_points(location.x, is.getLocation().x, location.y, is.getLocation().y));
          if (distance_between_two_points(location.x, is.getLocation().x, location.y, is.getLocation().y) <= 30) { //if the bee is close to a spawned resource item
            if (inventoryResources.size() < 8) {
              noti.add(new Notification(12, color(50), 20, height-60, resourceName[is.getItemType()]+" has been added to your inventory.", 2500, "Down Corner"));
              inventoryResources.add(new Resource(is.getItemType()));
            } else {
              noti.add(new Notification(12, color(200, 0, 0), 20, height-60, resourceName[is.getItemType()]+" has been discarded due to full inventory.", 2500, "Down Corner"));
            }
            resourceAppear.remove(i);
          }
        }
      }

      if (forTraining == false && spType != 0 && !(spType == 2 && CDAbility)) {
        //bee pick honey mechanic
        //go towards the flower, stop at the middle of the flower,
        //until capacity full / no more honey, 
        //then leave the flower.
        if (currHoneyCap < maxHoneyCap) beeFull = false;
        else beeFull = true;

        if (beeTarget.equals("Flower")) {        
          //Find the selected flower by pedal amount and the colour
          //(Using simply ID won't work because when other flowers are removed their ID would shift too
          float fx = 0;
          float fy = 0;
          for (int f = flowers.size ()-1; f >= 0; f--) {
            Flower _flower = flowers.get(f);
            if (flower_pedalAmount == _flower.getPedalAmount() && flower_stamenColor == _flower.getStamenPedalColor()[0]) {
              fx = _flower.getLocation().x;
              fy = _flower.getLocation().y;
              break;
            }
          }

          if (initialDistanceCheck) {
            //println("PERFORMING INITIAL DISTANCE CHECK.");
            if (gameMillis - distanceCheckTimer > 50) {
              float newDistance = distance_between_two_points(fx, location.x, fy, location.y);
              float supposedFlownDistance = (speed*((float)(gameMillis - distanceCheckTimer)/1000)*frameRate);
              //println(supposedFlownDistance);

              if (newDistance > distanceRecorded || distanceRecorded - newDistance > supposedFlownDistance*1.5 ) { //missed target. re-assign the target
                println(distanceRecorded, newDistance, distanceRecorded - newDistance);
                println(speed + "*((" + gameMillis + " - " + distanceCheckTimer + ")/1000*" + frameRate + "*2 = " + supposedFlownDistance);

                moveTheta = calcMoveTheta(fx, fy, location.x, location.y);
                println(gameMillis, beeTarget, "CHECK FAILED INITIALLY. REASSIGNING TARGET.");
                //fill(255, 0, 255);
                //ellipse(location.x, location.y, 30, 30);
                //frameRate(0.25);
              } else {
                initialDistanceCheck = false;
                println(gameMillis, beeTarget, "CHECK PASSED.");
              }

              distanceRecorded = newDistance;
              distanceCheckTimer = gameMillis;
            }
          } else if (gameMillis - distanceCheckTimer > 500) { //check every 500ms
            float newDistance = distance_between_two_points(fx, location.x, fy, location.y);
            float supposedFlownDistance = (speed*((float)(gameMillis - distanceCheckTimer)/1000)*frameRate);

            if (newDistance > distanceRecorded || distanceRecorded - newDistance > supposedFlownDistance*1.5 ) { //missed target. re-assign the target
              moveTheta = calcMoveTheta(fx, fy, location.x, location.y);
              println(gameMillis, beeTarget, "CHECK FAILED. REASSIGNING TARGET.");
              //fill(255, 0, 255);
              //ellipse(location.x, location.y, 30, 30);
              //frameRate(0.25);
            }

            distanceRecorded = newDistance;
            distanceCheckTimer = gameMillis;
          }

          if (fx == 0 && fy == 0) {
            //the bee's flower target has been removed before it has reached the flower
            beeTarget = "None";
            beeTimeoutMove = true;
            beeMoveTimer = gameMillis;
          } else {
            float hypotenuse = distance_between_two_points(location.x, fx, location.y, fy);
            //float _thetaRad = calcMoveTheta(fx, fy, bx, by);

            if (hypotenuse < 2.0) { //if the bee went close enough to the selected flower's area (how close? used to be 10 but would fly to other flowers)
              beeTarget = "None"; //move on to the code below (i dont know if this would have any bug)
              beeTimeoutMove = true;
            }
          }
        } else if (beeTarget.equals("Beehive")) {
          if (initialDistanceCheck) {
            //println("PERFORMING INITIAL DISTANCE CHECK.");
            if (gameMillis - distanceCheckTimer > 50) {
              float newDistance = distance_between_two_points(width/2, location.x, height/2, location.y);
              float supposedFlownDistance = (speed*((float)(gameMillis - distanceCheckTimer)/1000)*frameRate);
              //println(supposedFlownDistance);

              if (newDistance > distanceRecorded || distanceRecorded - newDistance > supposedFlownDistance*1.5 ) { //missed target. re-assign the target
                println(distanceRecorded, newDistance, distanceRecorded - newDistance);
                println(speed + "*((" + gameMillis + " - " + distanceCheckTimer + ")/1000*" + frameRate + "*2 = " + supposedFlownDistance);

                moveTheta = calcMoveTheta(width/2, height/2, location.x, location.y);
                println(gameMillis, beeTarget, "CHECK FAILED INITIALLY. REASSIGNING TARGET.");
                //fill(255, 0, 255);
                //ellipse(location.x, location.y, 30, 30);
                //frameRate(0.25);
              } else {
                initialDistanceCheck = false;
                println(gameMillis, beeTarget, "CHECK PASSED.");
              }

              distanceRecorded = newDistance;
              distanceCheckTimer = gameMillis;
            }
          } else if (gameMillis - distanceCheckTimer > 500) { //check every 500ms
            float newDistance = distance_between_two_points(width/2, location.x, height/2, location.y);
            float supposedFlownDistance = (speed*((float)(gameMillis - distanceCheckTimer)/1000)*frameRate);

            if (newDistance > distanceRecorded || distanceRecorded - newDistance > supposedFlownDistance*1.5 ) { //missed target. re-assign the target
              moveTheta = calcMoveTheta(width/2, height/2, location.x, location.y);
              println(gameMillis, beeTarget, "CHECK FAILED. REASSIGNING TARGET.");
              //fill(255, 0, 255);
              //ellipse(location.x, location.y, 30, 30);
              //frameRate(0.25);
            }

            distanceRecorded = newDistance;
            distanceCheckTimer = gameMillis;
          }
          //In Bee class. already moving towards beehive
          //this is put here to cancel the "honey picking" action
          beeMoveTimer = gameMillis; //constantly reset the auto-change-direction timer
        } else if (beeFull == false) {
          //check collision by Pythagorus theorem
          for (int f = flowers.size ()-1; f >= 0; f--) {
            Flower _flower = flowers.get(f);
            float fx = _flower.getLocation().x;
            float fy = _flower.getLocation().y;

            float hypotenuse = distance_between_two_points(location.x, fx, location.y, fy);

            if (hypotenuse <= 2.0) { //pick honey
              shouldBeeMove = false; //if bee is picking honey, do not move
              beeMoveTimer = gameMillis;
              //float _beeMaxCap = b.getMaxHoneyCap();
              //float _beeCurrCap = b.getCurrHoneyCap();
              //float _beeHoneyPickingSpeed = b.getHoneyPickingSpeed();
              float _newBeeHoneyCap = currHoneyCap + honeyPickingSpeed;

              if (_newBeeHoneyCap < maxHoneyCap) {
                float _newFlowerHoneyGram = _flower.getHoneyGram() - honeyPickingSpeed;

                // WILL FLOWER STILL HAVE HONEY? <begin>
                if (_newFlowerHoneyGram >= 0) {
                  _flower.updateHoneyGram(_newFlowerHoneyGram);
                  if (spType != 2) currHoneyCap += honeyPickingSpeed;
                  else { //Gardening Bee
                    currHoneyCap += honeyPickingSpeed*0.8;
                    honeyIntake += honeyPickingSpeed*0.2;
                  }
                  if (_newFlowerHoneyGram == 0) {
                    flowers.remove(f);
                    moveAllBees();
                    if (beeFull) goTowardsBeeHive();
                  }
                } else if (abs(_newFlowerHoneyGram) < honeyPickingSpeed) {
                  if (spType != 2) currHoneyCap += honeyPickingSpeed+_newFlowerHoneyGram;  //this is to make up the difference of non-divisible(minusable?) flower honey
                  else { //Gardening Bee
                    currHoneyCap += (honeyPickingSpeed+_newFlowerHoneyGram)*0.8;
                    honeyIntake += (honeyPickingSpeed+_newFlowerHoneyGram)*0.2;
                  }
                  flowers.remove(f);                                                       //after adding that difference just remove the flower like normal
                  moveAllBees();                                                           //flower has been emptied. Bee can move again.
                  if (beeFull) goTowardsBeeHive();
                } else {
                  flowers.remove(f);               //divisible number. remove as normal
                  moveAllBees();                   //flower has been emptied. Bee can move again.
                  if (beeFull) goTowardsBeeHive();
                }
                // WILL FLOWER STILL HAVE HONEY? <close>
              } else { //bee will be full
                float honeyGramPicked = maxHoneyCap - currHoneyCap;
                float _newFlowerHoneyGram = _flower.getHoneyGram() - honeyGramPicked;

                if (_newFlowerHoneyGram > 0) {
                  _flower.updateHoneyGram(_flower.getHoneyGram() - honeyGramPicked);
                  if (spType != 2) currHoneyCap += honeyGramPicked;
                  else { //Gardening Bee
                    currHoneyCap += honeyGramPicked*0.8;
                    honeyIntake += honeyGramPicked*0.2;
                  }
                  if (_newFlowerHoneyGram == 0) {
                    flowers.remove(f);
                    moveAllBees();
                  }
                } else if (abs(_newFlowerHoneyGram) < honeyGramPicked) {
                  if (spType != 2) currHoneyCap += honeyGramPicked + _newFlowerHoneyGram;  //this is to make up the difference of non-divisible(minusable?) flower honey
                  else { //Gardening Bee
                    currHoneyCap += (honeyGramPicked+_newFlowerHoneyGram)*0.8;
                    honeyIntake += (honeyGramPicked+_newFlowerHoneyGram)*0.2;
                  }
                  flowers.remove(f);                                                       //after adding that difference just remove the flower like normal
                  moveAllBees();                                                           //flower has been emptied. Bee can move again.
                } else {
                  flowers.remove(f); //divisible number. remove as normal
                  moveAllBees();     //flower has been emptied. Bee can move again.
                }
                goTowardsBeeHive();
              }
            } else if (hypotenuse <= 55) { //go in flower. hypotenuse < flower radius + bee radius
              //if (b.getBeeTarget().equals("Flower")) {
              //  b.updateBeeTarget("None");
              //  b.updateBeeTimeoutMove(true);
              //}

              insideFlower = true;
              moveTheta = calcMoveTheta(fx, fy, location.x, location.y);
              updateFlowerLocation(fx, fy);
            } else { //tell bee that it is not inside flower
              insideFlower = false;
            }
          }
        } else { //if beeFull
          shouldBeeMove = true;
          //dealt in Bee move()
        }

        //if bee has no target, then it can perform timeoutmove
        if (beeTarget != "None") beeTimeoutMove = false;
        else beeTimeoutMove = true;

        // ENTER BEEHIVE START
        float hypotenuse = distance_between_two_points(location.x, (width/2), location.y, (height/2));
        if (hypotenuse < 2) {
          beeTarget = "None";
          beeTimeoutMove = true;
        }
        if ((floor((currHoneyCap)/1000) > 0 && hypotenuse < 2) || (roundOver && hypotenuse < 2) || dumpingHoney) {
          if (reachedBeehive == false) DHADelay = gameMillis;
          reachedBeehive = true;
          dumpHoneyAnimation(); //placed assigning reachedBeehive = true because inside the function, reachedBeehive might be set to false

          // println("REACHED BEEHIVE.");
        }
        // ENTER BEEHIVE END
      }

      //general moving mechanic (forTraining & !forTraining)
      if (beeType != beeName.length && beeTimeoutMove) {
        //fill(0);
        //textAlign(LEFT);
        //textSize(12);
        //text("Timeout Move: "+(gameMillis-beeMoveTimer), 20, 50);
        if (gameMillis - beeMoveTimer > 5000) {
          beeMoveTimer = gameMillis;
          if (beeFull) {
            //return to beehive
            goTowardsBeeHive();
          } else {
            moveTheta = radians(random(360)); //go in a random angle
          }
        }
      }

      //    if (location.x + radius > width) xDir = -xDir;
      //    if (location.y + radius > height) yDir = -yDir;

      if (roundOver == false) {
        if (location.x + radius >= width) {
          stuckFrames += 1;
          //println(location.x, location.y);
          if (stuckFrames >= 30) {
            println("BEE (" + name + ") : solved stuck RIGHT");
            location.x -= 3;
          }
        } else if (location.x - radius <= 0) {
          stuckFrames += 1;
          //println(location.x, location.y);
          if (stuckFrames >= 30) {
            println("BEE (" + name + ") : solved stuck LEFT");
            location.x += 3;
          }
        } else if (location.y + radius >= height-40) {
          stuckFrames += 1;
          //println(location.x, location.y);
          if (stuckFrames >= 30) {
            println("BEE (" + name + ") : solved stuck DOWN");
            location.y -= 3;
          }
        } else if (location.y - radius <= 30) {
          stuckFrames += 1;
          //println(location.x, location.y);
          if (stuckFrames >= 30) {
            println("BEE (" + name + ") : solved stuck UP");
            location.y += 3;
          }
        } else {
          stuckFrames = 0;
        }


        if (location.x + radius >= width || location.x - radius <= 0) {
          float thetaD = degrees(moveTheta);
          if (thetaD >= 0 && thetaD < 180) {
            thetaD = 180-thetaD;
          } else {
            thetaD = 180 + (360-thetaD);
          }
          moveTheta = radians(thetaD);

          //move once with the new theta first, so as to reduce the chance for bees to get stuck (testing)
          float _moveX = speed*cos(moveTheta);
          float _moveY = -speed*sin(moveTheta);
          location = new PVector(location.x+_moveX, location.y+_moveY);
        }
        if (location.y + radius >= height-40 || location.y - radius <= 30) {
          float thetaD = degrees(moveTheta);
          thetaD = 360-thetaD;
          moveTheta = radians(thetaD);

          //move once with the new theta first, so as to reduce the chance for bees to get stuck (testing)
          float _moveX = speed*cos(moveTheta);
          float _moveY = -speed*sin(moveTheta);
          location = new PVector(location.x+_moveX, location.y+_moveY);
        }
      }
      float moveX = speed*cos(moveTheta);
      float moveY = -speed*sin(moveTheta);




      if (shouldBeeMove) location = new PVector(location.x+moveX, location.y+moveY); //the actual moving code
    } else { //isAlive = false
      switch (spType) {
      case 0: //Priest Bee
        resetRevive();
        break;

      case 1:
        if (CDAbility == false) { //first life dead
          CDAbility = true; //initiate second life
          isAlive = true;
          diameter = BEE_DIAMETER;
          speed = beeFlightSpeed[beeType]*0.3;
          maxHoneyCap = beeHoneyCapacity[beeType]*0.5;
          honeyPickingSpeed = beeHoneyPickingSpeed[beeType]*2;
        }
        break;

      case 3:
        shouldBeeMove = true;
        CDATimer = beeCDAVar[3][0];
        CDACooldown = beeCDAVar[3][1];
        CDAbility = false;
        break;
      }
    }
  }

  void goTowardsBeeHive() {
    if (tutorialMinorStep >= TutorialStatus.Beehive && isAlive) {
      updateBeeTarget("Beehive");
      beeTimeoutMove = true;

      shouldBeeMove = true;

      moveTheta = calcMoveTheta(width/2, height/2, location.x, location.y);
    }
  }

  long DHADelay = 0; //DumpHoneyAnimation
  void dumpHoneyAnimation() {
    shouldBeeMove = false;

    if (roundOver) {
      if (diameter > 0) diameter -= 0.5; 
      else {
        //essentially this is a initialize for when a round is over
        beeTarget = "None";
        honeyKg += floor((currHoneyCap)/1000);
        honeyKg = constrain(honeyKg, 0, honeyPotCapKg[honeyPotTier]);
        reachedBeehive = false;
        currHoneyCap = 0;
        nextStage = true;
        moveTheta = radians(random(360));
        beeSelectedStatus = false;

        int spType = beeType - beeName.length;
        if (spType == 0 || spType >= 2) {
          CDAbility = false;
          CDATimer = beeCDAVar[spType][0];
          CDACooldown = beeCDAVar[spType][1];
          hyperSelectedStatus = false;
        }
      }
    } else {
      if (gameMillis - DHADelay > 800) {
        if (diameter < BEE_DIAMETER) diameter += 0.5;
        else {
          //        location.x += random(1, 2);
          //        location.y += random(1, 2);
          reachedBeehive = false;
          shouldBeeMove = true;
          dumpingHoney = false;
        }
      } else {
        if (diameter == BEE_DIAMETER) {
          dumpingHoney = true;
          honeyKg += floor((currHoneyCap)/1000);
          honeyKg = constrain(honeyKg, 0, honeyPotCapKg[honeyPotTier]);
          currHoneyCap -= floor((currHoneyCap)/1000)*1000;
          diameter -= 0.5;
        } else if (diameter > 0) diameter -= 0.5;
      }
    }
  }

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

  float getMoveTheta() {
    return moveTheta;
  }

  float getDistinctID() {
    return distinctID;
  }

  boolean getIsAlive() {
    return isAlive;
  }

  boolean getHyperSelectedStatus() {
    return hyperSelectedStatus;
  }

  int getTier() {
    return spTier;
  }


  boolean getCDAbility() {
    return CDAbility;
  }
  int getCDACooldown() {
    return CDACooldown;
  }
  float getTargetBeeDistinctID() {
    return targetBeeDistinctID;
  }
}

float[] trainingBeeFlightSpeed = {0, 0, 1.4, 0};
class TrainingBee {
  int trainingType, beeType;
  PVector location;
  float diameter = BEE_DIAMETER, radius;
  float speed;
  float moveTheta = random(TWO_PI);
  boolean isAlive = true;

  boolean isProjection = false; //for Priest Bee

  TrainingBee(int _tType) {
    trainingType = _tType;
    beeType = _tType + beeName.length;
    location = new PVector(width/2, height/2); //x,y coordinate
    radius = diameter/2;
    if (_tType == 2) speed = trainingBeeFlightSpeed[2]*1.25;
    else speed = trainingBeeFlightSpeed[_tType];
  }

  void updateShouldBeeMove(boolean _sbm) {
    shouldBeeMove = _sbm;
  }

  void updateIsProjection(boolean _ip) {
    isProjection = _ip;
  }

  void updateLocation(float x, float y) {
    location = new PVector(x, y);
  }

  void updateMoveTheta(float _theta) {
    moveTheta = _theta;
  }

  void updateIsAlive(boolean _alive) {
    isAlive = _alive;
  }

  void updateBeeMoveTimer(long newBeeMoveTimer) {
    beeMoveTimer = newBeeMoveTimer;
  }

  boolean changeRange = false;
  int changeRangeDuration = 0;
  void changeRangeForDuration(float newRange, int duration) {
    changeRange = true;
    priestRange = newRange;
    changeRangeDuration = duration;
  }

  float priestRange = 160; //diameter range
  void showBee() {
    if (isAlive == false) diameter = BEE_DIAMETER / 2;
    else diameter = BEE_DIAMETER;

    radius = diameter /2;

    switch (trainingType) {
    case 0: //Priest Bee
      if (isProjection == false) {
        stroke(255, 200, 0);
        strokeWeight(1.5);
        fill(255, 255, 0, 100);
        ellipse(location.x, location.y, priestRange, priestRange);
      }
      break;

    case 2: //Gardening Bee

      break;
    }

    if (isAlive == false) fill(int((hue(beeColour[beeType]) + saturation(beeColour[beeType]) + brightness(beeColour[beeType])) / 3));
    else fill(beeColour[beeType]);

    stroke(0);
    strokeWeight(1);

    //body
    pushMatrix();
    translate(location.x, location.y);
    rotate(-moveTheta);
    line(0, 0, -diameter*1.7/2, 0); //sting of the bee
    ellipse(0, 0, diameter*1.5, diameter);

    //(Body Pattern. Upgraded bees have special patterns)
    noStroke();
    fill(0);

    //sclera (white part of the eye)
    stroke(0);
    strokeWeight(1);
    fill(255);
    ellipse(diameter*0.65, diameter*0.35, diameter*0.65, diameter*0.65);
    ellipse(diameter*0.65, -diameter*0.35, diameter*0.65, diameter*0.65);

    //eyeballs (black)
    noStroke();
    fill(50);
    ellipse(diameter*0.65, diameter*0.35, diameter*0.25, diameter*0.25);
    ellipse(diameter*0.65, -diameter*0.35, diameter*0.25, diameter*0.25);


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

    switch (trainingType) {
    case 0: //Priest Bee
      if (isProjection == false) {
        strokeWeight(1);
        stroke(50);
        noFill();
        rect(location.x+15, location.y-10, 6, 20);

        rectMode(CORNERS);
        noStroke();
        fill(0, 150, 0);
        rect(location.x+15.5, map(BTTimer, 0, 5000, location.y+10, location.y-10), location.x+20.75, location.y+9.75);
        rectMode(CORNER);

        if (BTConfirmed) {
          fill(100);
          textAlign(CENTER);
          textSize(10);
          text("Press me to cancel", location.x, location.y+20);
        }
      } else if (isProjection) {
        if (BTConfirmed) {
          fill(0, 200, 0);
          textAlign(CENTER);
          textSize(10);
          text("OK!", location.x+8, location.y-8);
          fill(100);
          text("Press me to cancel", location.x, location.y+20);
        } else {
          fill(200, 0, 0);
          textAlign(CENTER);
          textSize(10);
          text("WHERE?", location.x+8, location.y-8);
        }
      }
      break;

    case 2: //Gardening Bee

      break;
    }
  }

  boolean beeTimeoutMove = true;
  long beeMoveTimer = 0;
  int stuckFrames = 0;
  boolean shouldBeeMove = true;
  void move() {
    if (changeRange) {
      changeRangeDuration -= timePassed;
      if (changeRangeDuration <= 0) {
        changeRangeDuration = 0;
        changeRange = false;
        priestRange = 160;
      }
    }

    if (trainingType != 0 && beeTimeoutMove) {
      if (gameMillis - beeMoveTimer > 8000) {
        beeMoveTimer = gameMillis;
        moveTheta = radians(random(360)); //go in a random angle
      }
    }

    //float shortestDistance = width*2;
    //int shortestId = -1;
    //if (trainingType == 2) {
    //  for (int i = BTPest.size()-1; i >= 0; i--) {
    //    Pest p = BTPest.get(i);
    //    float px = p.getLocation().x, py = p.getLocation().y;
    //    float newDist = dist(px, py, location.x, location.y);
    //    if (newDist < shortestDistance) {
    //      shortestDistance = dist(px, py, location.x, location.y);
    //      shortestId = i;
    //    }
    //  }

    //  if (shortestId != -1) {
    //    Pest targetP = BTPest.get(shortestId);
    //    float px = targetP.getLocation().x, py = targetP.getLocation().y;
    //    float newDist = dist(px, py, location.x, location.y);
    //    if (newDist <= 2) {
    //      BTPest.remove(shortestId);
    //      beeMoveTimer = gameMillis;
    //    } else if (newDist <= 60) { //detection range (radius)
    //      moveTheta = calcMoveTheta(px, py, location.x, location.y);
    //      beeMoveTimer = gameMillis;
    //    }
    //  }
    //}



    if (roundOver == false) {
      if (location.x + radius >= width) {
        stuckFrames += 1;
        //println(location.x, location.y);
        if (stuckFrames >= 30) {
          println("TRAINING BEE : solved stuck RIGHT");
          location.x -= 3;
        }
      } else if (location.x - radius <= 0) {
        stuckFrames += 1;
        //println(location.x, location.y);
        if (stuckFrames >= 30) {
          println("TRAINING BEE : solved stuck LEFT");
          location.x += 3;
        }
      } else if (location.y + radius >= height-40) {
        stuckFrames += 1;
        //println(location.x, location.y);
        if (stuckFrames >= 30) {
          println("TRAINING BEE : solved stuck DOWN");
          location.y -= 3;
        }
      } else if (location.y - radius <= 30) {
        stuckFrames += 1;
        //println(location.x, location.y);
        if (stuckFrames >= 30) {
          println("TRAINING BEE : solved stuck UP");
          location.y += 3;
        }
      } else {
        stuckFrames = 0;
      }


      if (location.x + radius >= width || location.x - radius <= 0) {
        float thetaD = degrees(moveTheta);
        if (thetaD >= 0 && thetaD < 180) {
          thetaD = 180-thetaD;
        } else {
          thetaD = 180 + (360-thetaD);
        }
        moveTheta = radians(thetaD);

        //move once with the new theta first, so as to reduce the chance for bees to get stuck (testing)
        float _moveX = speed*cos(moveTheta);
        float _moveY = -speed*sin(moveTheta);
        location = new PVector(location.x+_moveX, location.y+_moveY);
      }
      if (location.y + radius >= height-40 || location.y - radius <= 30) {
        float thetaD = degrees(moveTheta);
        thetaD = 360-thetaD;
        moveTheta = radians(thetaD);

        //move once with the new theta first, so as to reduce the chance for bees to get stuck (testing)
        float _moveX = speed*cos(moveTheta);
        float _moveY = -speed*sin(moveTheta);
        location = new PVector(location.x+_moveX, location.y+_moveY);
      }
    }
    float moveX = speed*cos(moveTheta);
    float moveY = -speed*sin(moveTheta);




    if (shouldBeeMove) location = new PVector(location.x+moveX, location.y+moveY); //the actual moving code
  }

  PVector getLocation() {
    return location;
  }

  float getPriestRange() {
    return priestRange;
  }

  float getMoveTheta() {
    return moveTheta;
  }

  boolean getIsAlive() {
    return isAlive;
  }

  int getChangeRangeDuration() {
    return changeRangeDuration;
  }
}