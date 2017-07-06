static final int BEE_RADIUS = 11;

static final float[] beeFlightSpeed = {0.7, 0.85, 1.0, 1.3, 1.6, 1.8, 2.8};
static final float[] beeHoneyPickingSpeed = {/*30*/10, 14, 21, 35, 60, 84, 105}; //gram per frame as unit, processing runs at 60FPS; not balanced
static final float[] beeHoneyCapacity = {5000, 15000, 25000, 50000, 100000, 200000, 400000}; //in gram
static final String[] beeName = {"Honee", "Milkee", "Harvee", "Lovee", "Joycee", "Happee"/*, "Jumbee"*/};
color[] beeColour = {color(255, 100, 0, 200), color(255, 150, 0, 200), color(255, 200, 0, 200), color(255, 255, 0, 200), color(200, 250, 0, 200), color(200, 200, 0, 200), color(200, 150, 0, 200)};

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
          reachedBeehive = false;
          shouldBeeMove = true;
          dumpingHoney = false;
        }
      } else {
        if (radius == BEE_RADIUS) {
          dumpingHoney = true;
          honeyKg += floor((currHoneyCap)/1000);
          honeyKg = constrain(honeyKg, 0, honeyPotCapKg[honeyPotTier]);
          currHoneyCap -= floor((currHoneyCap)/1000)*1000;
          radius -= 0.5;
        } else if (radius > 0) radius -= 0.5;
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