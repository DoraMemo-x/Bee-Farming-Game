static final int BEE_DIAMETER = 12;

static final float[] beeFlightSpeed = {0.8, 0.95, 1.1, 1.4, 1.7, 1.9, 2.8};
static final float[] beeHoneyPickingSpeed = {/*30*/10, 14, 21, 35, 60, 84, 105}; //gram per frame as unit, processing runs at 60FPS; not balanced
static final float[] beeHoneyCapacity = {5000, 15000, 25000, 50000, 100000, 200000, 400000}; //in gram
 static final String[] beeName = {"Honee", "Milkee", "Harvee", "Lovee", "Joycee", "Happee"/*, "Jumbee"*/};
color[] beeColour = {color(255, 125, 0), color(255, 150, 0), color(255, 175, 0), color(255, 255, 0), color(225, 250, 0), color(200, 225, 0), color(200, 150, 0)};

//int beeMoveTimer = 0;
int beesCount = 0;

class Bee {
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

  int flower_pedalAmount;
  color flower_stamenColor;
  color flower_pedalColor;
  void showBee() {
    radius = diameter /2; 

    for (int i = 0; i < beeFlightSpeed.length; i++) {
      if (speed == beeFlightSpeed[i]) fill(beeColour[i]);
      else if (speed == 3) fill(255, 255, 150);
    }    
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
    } else {
      //Situation "None"

      //fill(200, 0, 200);
      //textSize(10);
      //textAlign(CENTER);
      //text(beeTarget, location.x, location.y+35);
    }


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
    
    if (forShop == false) {
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
  void move() {
    if (currHoneyCap < maxHoneyCap) beeFull = false;
    else beeFull = true;

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

    if (beeTimeoutMove) {
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
      }
      if (location.y + radius >= height-40 || location.y - radius <= 30) {
        float thetaD = degrees(moveTheta);
        thetaD = 360-thetaD;
        moveTheta = radians(thetaD);
      }
    }
    float moveX = speed*cos(moveTheta);
    float moveY = -speed*sin(moveTheta);




    if (shouldBeeMove) location = new PVector(location.x+moveX, location.y+moveY); //the actual moving code
  }

  void goTowardsBeeHive() {
    beeTarget = "Beehive";
    beeTimeoutMove = true;

    shouldBeeMove = true;

    float detX = (width/2) - location.x;
    float detY = (height/2) - location.y;
    float hypotenuse = distance_between_two_points(location.x, (width/2), location.y, (height/2));
    float _thetaRad = asin(abs((height/2) - location.y) / hypotenuse);
    moveTheta = returnRealTheta(_thetaRad, detX, detY);
  }

  long DHADelay = 0; //DumpHoneyAnimation
  void dumpHoneyAnimation() {
    shouldBeeMove = false;

    if (roundOver) {
      if (diameter > 0) diameter -= 0.5; 
      else {
        honeyKg += floor((currHoneyCap)/1000);
        honeyKg = constrain(honeyKg, 0, honeyPotCapKg[honeyPotTier]);
        reachedBeehive = false;
        currHoneyCap = 0;
        nextStage = true;
        moveTheta = radians(random(360));
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
}