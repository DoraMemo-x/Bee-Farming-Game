static final int BEE_RADIUS = 11;

static final float[] beeFlightSpeed = {0.7, 1.0, 1.35, 1.7, 1.85, 2.3, 2.8};
static final float[] beeHoneyPickingSpeed = {/*30*/10, 14, 21, 35, 60, 84, 105}; //gram per frame as unit, processing runs at 60FPS; not balanced
static final float[] beeHoneyCapacity = {5000, 15000, 25000, 50000, 100000, 200000, 400000}; //in gram
static final String[] beeName = {"Honee", "Milkee", "Harvee", "Lovee", "Joycee", "Happee", "Jumbee"};
color[] beeColour = {color(255, 100, 0, 200), color(255, 150, 0, 200), color(255, 200, 0, 200), color(255, 255, 0, 200), color(200, 250, 0, 200), color(200, 200, 0, 200), color(200, 150, 0, 200)};
static final float[] guardianFlightSpeed = {1.52, 2.32, 3.0};
static int[] guardianSenseArea = {250, 325, 400};
static final String[] guardianName = {"Guardian", "Super Guardian", "Royal Guardian"};

static final float[] hornetFlightSpeed = {1.3, 2.3, 2.8};
//int beeMoveTimer = 0;
int beesCount = 0;

class Bee {
  String name = "missingname"; //used to identify which type the bee is

  PVector location; 
  float radius;
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

  boolean nextStage = false;

  Bee(float x, float y, int _radius, String _name) {
    location = new PVector(x, y); //x,y coordinate
    radius = _radius;
    name = _name;
    for (int i = 0; i < beeName.length; i++) {
      if (name.equals(beeName[i])) {
        speed = beeFlightSpeed[i];
        maxHoneyCap = beeHoneyCapacity[i];
        honeyPickingSpeed = beeHoneyPickingSpeed[i];
      }
    }
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

  void resetRadius() {
    radius = BEE_RADIUS;
  }

  void transferFlowerPedalAmount(int _flower_pedalAmount) {
    flower_pedalAmount = _flower_pedalAmount;
  }

  void transferFlowerColors(color[] __fColors) {
    flower_stamenColor = __fColors[0];
    flower_pedalColor = __fColors[1];
  }

  int flower_pedalAmount;
  color flower_stamenColor;
  color flower_pedalColor;
  void showBee() {
    for (int i = 0; i < beeFlightSpeed.length; i++) {
      if (speed == beeFlightSpeed[i]) fill(beeColour[i]);
      else if (speed == 3) fill(255, 255, 150);
    }    
    stroke(0); 
    strokeWeight(2); 
    //ellipse(location.x, location.y, radius, radius);
    pushMatrix();
    translate(location.x, location.y);
    rotate(-moveTheta);
    line(0, 0, -radius*1.7/2, 0); //sting of the bee
    ellipse(0, 0, radius*1.5, radius);

    //sclera (white part of the eye)
    strokeWeight(1);
    fill(255);
    ellipse(radius*0.7, radius*0.35, radius*0.8, radius*0.8);
    ellipse(radius*0.7, -radius*0.35, radius*0.8, radius*0.8);

    //eyeballs (black)
    noStroke();
    fill(50);
    ellipse(radius*0.7, radius*0.35, radius*0.3, radius*0.3);
    ellipse(radius*0.7, -radius*0.35, radius*0.3, radius*0.3);

    //bigger wings
    fill(200, 200, 200, 150);
    pushMatrix();
    translate(0, radius*0.8);
    rotate(radians(60));
    ellipse(0, 0, radius*1.5, radius);
    popMatrix();
    pushMatrix();
    translate(0, -radius*0.8);
    rotate(-radians(60));
    ellipse(0, 0, radius*1.5, radius);
    popMatrix();

    //smaller wings
    pushMatrix();
    translate(-5, radius*0.8);
    rotate(radians(50));
    ellipse(0, 0, radius*1.2, radius);
    popMatrix();
    pushMatrix();
    translate(-5, -radius*0.8);
    rotate(-radians(50));
    ellipse(0, 0, radius*1.2, radius);
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
    textSize(10);
    textAlign(CENTER);
    //text(currHoneyCap+"g", location.x, location.y-30);
    text(floor((currHoneyCap)/1000)+"kg", location.x, location.y-31); //used to be -8
  }


  boolean shouldBeeMove = true;
  int flowerID = -1;
  //go towards the flower, stop at the middle of the flower,
  //until capacity full / no more honey, 
  //then leave the flower.
  int stuckFrames = 0;
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
    if ((floor((currHoneyCap)/1000) > 0 && hypotenuse < 2) || (roundOver && hypotenuse < 2)) {
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
          println("BEE: solved stuck RIGHT");
          location.x -= 3;
        }
      } else if (location.x - radius <= 0) {
        stuckFrames += 1;
        //println(location.x, location.y);
        if (stuckFrames >= 30) {
          println("BEE: solved stuck LEFT");
          location.x += 3;
        }
      } else if (location.y + radius >= height-40) {
        stuckFrames += 1;
        //println(location.x, location.y);
        if (stuckFrames >= 30) {
          println("BEE: solved stuck DOWN");
          location.y -= 3;
        }
      } else if (location.y - radius <= 30) {
        stuckFrames += 1;
        //println(location.x, location.y);
        if (stuckFrames >= 30) {
          println("BEE: solved stuck UP");
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
    //    println("going towards beehive");

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
      if (radius > 0) radius -= 0.5; 
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
        if (radius < BEE_RADIUS) radius += 0.5;
        else {
          //        location.x += random(1, 2);
          //        location.y += random(1, 2);
          honeyKg += floor((currHoneyCap)/1000);
          honeyKg = constrain(honeyKg, 0, honeyPotCapKg[honeyPotTier]);
          reachedBeehive = false;
          currHoneyCap -= floor((currHoneyCap)/1000)*1000;
          shouldBeeMove = true;
        }
      } else {
        if (radius > 0) radius -= 0.5;
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
}



class Hornet {
  PVector location; 
  float radius = 5;
  float speed;
  float moveTheta = radians(random(360));
  boolean killFatigue = false;
  long lastKillMillis;

  Hornet(float _speed) {
    speed = _speed;

    if (random(1) > 0.5) {
      location = new PVector(random(width), random(1) > 0.5 ? 30 : height-30);
    } else {
      location = new PVector(random(1) > 0.5 ? 0 : width, random(height));
    }
  } 

  void showHornet() {
    if (speed == hornetFlightSpeed[0]) fill(255, 137, 137);
    else if (speed == hornetFlightSpeed[1]) fill(193, 59, 59);
    else if (speed == hornetFlightSpeed[2]) fill(152, 0, 0);
    stroke(0); 
    strokeWeight(2);
    ellipse(location.x, location.y, radius, radius);
  }


  //logic ref in notebook, not implemented yet
  void move() {
    if (gameMillis - lastKillMillis < 4000) killFatigue = true;
    else killFatigue = false;

    //DETERMINE CLOSEST BEE <START>
    float shortestDistance = distance_between_two_points(0, width, 0, height); //set supposedly shortest distance to be the longest so that it is certain that there will be a shorter distance
    int closestBeeID = -1;
    for (int b = bees.size ()-1; b >= 0; b--) {
      Bee _bee = bees.get(b);

      float bx = _bee.getLocation().x;
      float by = _bee.getLocation().y;

      float hypotenuse = distance_between_two_points(location.x, bx, location.y, by);

      if (hypotenuse < shortestDistance) {
        shortestDistance = hypotenuse;
        closestBeeID = b;
      }
    }

    if (closestBeeID != -1) {
      Bee b = bees.get(closestBeeID);
      float bx = b.getLocation().x;
      float by = b.getLocation().y;
      if (debug) {
        //display a red line that represents which bee is the hornet going for
        stroke(200, 0, 0, 100);
        strokeWeight(1);
        line(location.x, location.y, bx, by);
      }

      float detX = bx - location.x;
      float detY = by - location.y;
      float hypotenuse = distance_between_two_points(location.x, bx, location.y, by);
      if (hypotenuse < (invincibleBees ? 0 : 1.5)) {
        lastKillMillis = gameMillis;
        bees.remove(b);
      }
      float _thetaRad = asin(abs(by - location.y) / hypotenuse);
      moveTheta = returnRealTheta(_thetaRad, detX, detY);
      //DETERMINE CLOSEST BEE <END>
    }

    float moveX =   (killFatigue ? 1 : 0.6) * speed*cos(moveTheta);
    float moveY = - (killFatigue ? 1 : 0.6) * speed*sin(moveTheta);

    location = new PVector(location.x+moveX, location.y+moveY); //the actual moving code
  }

  PVector getLocation() { 
    return location;
  }

  float getMoveTheta() {
    return moveTheta;
  }
}




class Guardian {
  PVector location = new PVector(width/2, height/2); 
  int guardianType = -1; //this is the index of array
  float radius = 8;
  float angleOffset = 0;
  float speed;
  boolean guardianTimeoutMove = true;
  long guardianMoveTimer = 0;
  boolean guardianSelectedStatus = false;
  boolean shouldGuardianMove = true; //the only time a guardian shouldn't move is when the round ends and the guardian starts to retreat to the beehive
  String name = "missingNameG"; //default name for guardians if not specified
  String guardianTarget = "None"; //"None", "Hornet"
  float moveTheta = radians(random(360));
  int stuckFrames = 0;

  Guardian(String _name) {
    name = _name;
    for (int i = 0; i < guardianName.length; i++) {
      if (name.equals(guardianName[i])) {
        guardianType = i;
        speed = guardianFlightSpeed[i];
      }
    }
  }

  void updateMoveTheta(float _theta) {
    moveTheta = _theta;
  }

  void updateGuardianTimeoutMove(boolean newGuardianTimeoutMove) {
    guardianTimeoutMove = newGuardianTimeoutMove;
  }

  void updateGuardianMoveTimer(long newGuardianMoveTimer) {
    guardianMoveTimer = newGuardianMoveTimer;
  }

  void updateGuardianSelectedStatus(boolean _guardianSelectedStatus) {
    guardianSelectedStatus = _guardianSelectedStatus;
  }

  void updateGuardianTarget(String _guardianTarget) {
    guardianTarget = _guardianTarget;
  }

  void showGuardian() {
    if (speed == guardianFlightSpeed[0]) fill(186, 186, 255);
    else if (speed == guardianFlightSpeed[1]) fill(136, 136, 255);
    else if (speed == guardianFlightSpeed[2]) fill(86, 86, 255);
    stroke(0);
    strokeWeight(2);
    pushMatrix();
    translate(location.x, location.y);
    rotate(radians(angleOffset));
    polygon(0, 0, radius, 5);
    popMatrix();

    if (guardianSelectedStatus) {
      fill(0, 186, 255);
      textSize(12);
      textAlign(CENTER);
      text("Ready to move!", location.x, location.y+20);
    } else if (guardianTarget.equals("Hornet")) {
      fill(0, 186, 255);
      textSize(12);
      textAlign(CENTER);
      text("Hornet", location.x, location.y+20);
    }

    if (debug) {
      noStroke();
      fill(0, 0, 100, 70);
      ellipse(location.x, location.y, guardianSenseArea[guardianType]*2, guardianSenseArea[guardianType]*2);
    }

    if (angleOffset >= 360) angleOffset -= 360;
    else if (guardianTarget.equals("Hornet")) angleOffset += 2;
    else angleOffset += 0.5;
  }

  void goTowardsBeeHive() {
    shouldGuardianMove = true;

    float detX = (width/2) - location.x;
    float detY = (height/2) - location.y;
    float hypotenuse = distance_between_two_points(location.x, (width/2), location.y, (height/2));
    float _thetaRad = asin(abs((height/2) - location.y) / hypotenuse);
    moveTheta = returnRealTheta(_thetaRad, detX, detY);
  }

  void move() {
    float shortestDistance = distance_between_two_points(0, width, 0, height); //set supposedly shortest distance to be the longest so that it is certain that there will be a shorter distance
    int closestHornetID = -1;

    for (int h = hornets.size ()-1; h >= 0; h--) {
      Hornet _hornet = hornets.get(h);

      float hx = _hornet.getLocation().x;
      float hy = _hornet.getLocation().y;
      float hypotenuse = distance_between_two_points(hx, location.x, hy, location.y);

      if (hypotenuse > guardianSenseArea[guardianType]) continue;
      else {
        if (hypotenuse < shortestDistance) {
          shortestDistance = hypotenuse;
          closestHornetID = h;
        }
      }
    }

    if (closestHornetID != -1) {
      guardianTarget = "Hornet";

      Hornet h = hornets.get(closestHornetID);
      float hx = h.getLocation().x;
      float hy = h.getLocation().y;
      if (debug) {
        //display a blue line that represents which hornet is the guardian going for
        stroke(0, 0, 200, 100);
        strokeWeight(1);
        line(location.x, location.y, hx, hy);
      }

      float detX = hx - location.x;
      float detY = hy - location.y;
      float hypotenuse = distance_between_two_points(location.x, hx, location.y, hy);
      if (hypotenuse < 1.5) {
        hornets.remove(h);
      }
      float _thetaRad = asin(abs(hy - location.y) / hypotenuse);
      moveTheta = returnRealTheta(_thetaRad, detX, detY);
    } else guardianTarget = "None"; //reset the target

    if (guardianTimeoutMove) {
      //fill(0);
      //textAlign(LEFT);
      //textSize(12);
      //text("Timeout Move: "+(gameMillis-beeMoveTimer), 20, 50);
      if (gameMillis - guardianMoveTimer > 8000) {
        guardianMoveTimer = gameMillis;
        moveTheta = radians(random(360)); //go in a random angle
      }
    }

    if (roundOver == false) {
      if (location.x + radius >= width) {
        stuckFrames += 1;
        println(location.x, location.y);
        if (stuckFrames >= 30) {
          println("GUARDIAN: solved stuck RIGHT");
          location.x -= 3;
        }
      } else if (location.x - radius <= 0) {
        stuckFrames += 1;
        println(location.x, location.y);
        if (stuckFrames >= 30) {
          println("GUARDIAN: solved stuck LEFT");
          location.x += 3;
        }
      } else if (location.y + radius >= height-40) {
        stuckFrames += 1;
        println(location.x, location.y);
        if (stuckFrames >= 30) {
          println("GUARDIAN: solved stuck DOWN");
          location.y -= 3;
        }
      } else if (location.y - radius <= 30) {
        stuckFrames += 1;
        println(location.x, location.y);
        if (stuckFrames >= 30) {
          println("GUARDIAN: solved stuck UP");
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

    if (roundOver) {
      //if (radius > 0) radius -= 0.5; 
      //else {
      //nextStage = true;
      //}
    }


    float moveX = speed*cos(moveTheta);
    float moveY = -speed*sin(moveTheta);




    location = new PVector(location.x+moveX, location.y+moveY); //the actual moving code
  }

  String getGuardianName() {
    return name;
  }

  PVector getLocation() { 
    return location;
  }

  boolean getGuardianSelectedStatus() {
    return guardianSelectedStatus;
  }

  float getMoveTheta() {
    return moveTheta;
  }
}

long hornetTimer = 0;
void spawnHornet() {
  refreshHornetSpawnRndVal();

  float factorX = bees.size() + guardians.size()*2 + flowers.size()*0.75 /*+ HSRV*/;
  if (forestType >= 6) {
    float nextHornetTime = (200/pow(factorX, 0.2)-77) *1000;
    if (nextHornetTime < 10000) nextHornetTime = 10000; //lower constrain
    println(bees.size(), guardians.size(), flowers.size(), factorX, "=", nextHornetTime);
    //if (debug) {
    fill(0);
    textSize(12);
    textAlign(LEFT);
    text("Next hornet in: " + (int)((nextHornetTime+hornetTimer)-gameMillis), 20, height-36);
    //}
    if (gameMillis - hornetTimer > nextHornetTime) {
      hornets.add(new Hornet(hornetFlightSpeed[0]));
      hornetTimer = gameMillis;
    }
  }
}

float getNextHSRV = 10000; //HornetSpawnRndVal
float HSRV = random(10);
void refreshHornetSpawnRndVal() {
  if (gameMillis - getNextHSRV >= 0) {
    getNextHSRV += 10000;
    HSRV = random(10);
  }
}