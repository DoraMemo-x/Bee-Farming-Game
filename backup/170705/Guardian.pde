static final float[] guardianFlightSpeed = {1.52, 2.32, 3.0};
static int[] guardianSenseArea = {250, 325, 400};
static final String[] guardianName = {"Guardian", "Super Guardian", "Trained Guardian"};
static final String[] upgradedGuardianName = {"Royal Guardian", "Baiting Guardian", "Hunting Guardian", "Computer Guardian", "Ranged Guardian", "Bouncer Guardian"};
static final float[][] upgradeGuardianCost = {{100000, 1}, {80000, 1}, {125000, 1}, {150000, 2}, {100000, 0.5}, {75000, 0.5}}; //money, week
static final String[][] upgradedGuardianDescription = {
  {"|b"+upgradedGuardianName[0], "|i$"+nfc(int(upgradeGuardianCost[0][0])) + ", " + nf(upgradeGuardianCost[0][1]) + (upgradeGuardianCost[0][1] > 1 ? " weeks" : " week"), "", "|rEnhancements:", "- Increased Flight Speed", "- Increased Sensing Area"}, 
  {"|b"+upgradedGuardianName[1], "|i$"+nfc(int(upgradeGuardianCost[1][0])) + ", " + nf(upgradeGuardianCost[1][1]) + (upgradeGuardianCost[1][1] > 1 ? " weeks" : " week"), "", "|rAbility:", "  Appears as a normal bee (Does not collect honey).", "  However, when an enemy is close by,", "  it would counterattack.", "", "Drawback:", "- Decreased Sensing Area"}, 
  {"|b"+upgradedGuardianName[2], "|i$"+nfc(int(upgradeGuardianCost[2][0])) + ", " + nf(upgradeGuardianCost[2][1]) + (upgradeGuardianCost[2][1] > 1 ? " weeks" : " week"), "", "|rCooldown Ability:", "  Slows down enemies in their effective area.", "", "Drawback:", "  When the ability is active,", "  their sensing area would contract to their effective area as well."}, 
  {"|b"+upgradedGuardianName[3], "|i$"+nfc(int(upgradeGuardianCost[3][0])) + ", " + nf(upgradeGuardianCost[3][1]) + (upgradeGuardianCost[3][1] > 1 ? " weeks" : " week"), "", "|rAbility:", "- Calculates the shortest path to catch an enemy.", "- Player has to target the enemy.", "", "Drawback:", "- Decreased Flight Speed"}, 
  {"|b"+upgradedGuardianName[4], "|i$"+nfc(int(upgradeGuardianCost[4][0])) + ", " + nf(upgradeGuardianCost[4][1]) + (upgradeGuardianCost[4][1] > 1 ? " weeks" : " week"), "", "|rCooldown Ability:", "- Armed with a projectile sting ability.", "- Has to reload for every 2 shots.", "- Player controls where the sting lands, not the guardian itself."}, 
  {"|b"+upgradedGuardianName[5], "|i$"+nfc(int(upgradeGuardianCost[5][0])) + ", " + nf(upgradeGuardianCost[5][1]) + (upgradeGuardianCost[5][1] > 1 ? " weeks" : " week"), "", "|rAbility:", "- Sticks next to 1 selected bee to protect it.", "- If the guardian is assigned a new target,", "   it will kill the previous target.", "- Killing one enemy will reset the guardian's target.", "", "Drawback:", "- Decreased Flight Speed"}
};


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
  boolean nextStage = false;

  Guardian(String _name) {
    name = _name;
    for (int i = 0; i < guardianName.length; i++) {
      if (name.equals(guardianName[i])) {
        guardianType = i;
        speed = guardianFlightSpeed[i];
      }
    }
    for (int i = 0; i < upgradedGuardianName.length; i++) {
      if (name.equals(upgradedGuardianName[i])) {
        guardianType = i+guardianName.length-1;
        speed = guardianFlightSpeed[guardianType];
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

    if (roundOver) { //when roundOver, guardian goes towards beehive too
      float hypotenuse = distance_between_two_points(location.x, (width/2), location.y, (height/2));
      if (hypotenuse < 2) {
        if (radius > 0) radius -= 0.5; 
        else nextStage = true;
      }
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
  
  boolean getNextStage() {
    return nextStage;
  }

  float getMoveTheta() {
    return moveTheta;
  }
}

class TrainingGuardian {
  PVector location = new PVector(width/2, height/2); 
  int guardianType = -1; //this is the index of array
  float radius = 8;
  float angleOffset = 0;
  float speed = guardianFlightSpeed[1]; //all the training guardians possess the properties of "Super Guardian"
  boolean guardianTimeoutMove = true;
  long guardianMoveTimer = 0;
  boolean guardianSelectedStatus = false;
  boolean shouldGuardianMove = true; 
  String name = "missingNameGT"; //default name for guardians if not specified
  String guardianTarget = "None"; //"None", 0:"Firefly"
  float moveTheta = radians(random(360));
  int objectiveID = -1; //default selected none
  int stuckFrames = 0;

  TrainingGuardian(int type) {
    name = upgradedGuardianName[type];

    guardianType = type;
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
    fill(136, 136, 255);
    stroke(0);
    strokeWeight(2);
    pushMatrix();
    translate(location.x, location.y);
    rotate(radians(angleOffset));
    polygon(0, 0, radius, 5);
    popMatrix();

    fill(0, 186, 255);
    textSize(12);
    textAlign(CENTER);
    if (guardianSelectedStatus) text("Ready to move!", location.x, location.y+20);
    else if (guardianTarget.equals("Firefly")) text("Firefly", location.x, location.y+20);


    //if (debug) {
    //  noStroke();
    //  fill(0, 0, 100, 50);
    //  ellipse(location.x, location.y, guardianSenseArea[1]*2, guardianSenseArea[1]*2);
    //}

    if (angleOffset >= 360) angleOffset -= 360;
    else if (guardianTarget.equals("Firefly")) angleOffset += 2;
    else angleOffset += 0.5;
  }

  void selectTarget(int _objectiveID) {
    switch (guardianType) {
    case 0: //Royal Guardian
      guardianTarget = "Firefly";
      objectiveID = _objectiveID;
      break;
    }
  }

  void move() {
    switch (guardianType) {
    case 0: //Royal Guardian
      if (objectiveID != -1) {
        Firefly ff = trainingFireflies.get(objectiveID);
        float ffx = ff.getLocation().x;
        float ffy = ff.getLocation().y;
        if (debug) {
          //display a blue line that represents which hornet is the guardian going for
          stroke(0, 0, 200, 100);
          strokeWeight(1);
          line(location.x, location.y, ffx, ffy);
        }
        float detX = ffx - location.x;
        float detY = ffy - location.y;
        float hypotenuse = distance_between_two_points(location.x, ffx, location.y, ffy);
        if (hypotenuse < 1.5) {
          trainingFireflies.remove(ff);
          guardianTarget = "None";
          objectiveID = -1;
        }
        float _thetaRad = asin(abs(ffy - location.y) / hypotenuse);
        moveTheta = returnRealTheta(_thetaRad, detX, detY);
      } else guardianTarget = "None"; //reset the target
      break;
    }

    if (guardianTimeoutMove) {
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
          println("T. GUARDIAN: solved stuck RIGHT");
          location.x -= 3;
        }
      } else if (location.x - radius <= 0) {
        stuckFrames += 1;
        println(location.x, location.y);
        if (stuckFrames >= 30) {
          println("T. GUARDIAN: solved stuck LEFT");
          location.x += 3;
        }
      } else if (location.y + radius >= height) {
        stuckFrames += 1;
        println(location.x, location.y);
        if (stuckFrames >= 30) {
          println("T. GUARDIAN: solved stuck DOWN");
          location.y -= 3;
        }
      } else if (location.y - radius <= 30) {
        stuckFrames += 1;
        println(location.x, location.y);
        if (stuckFrames >= 30) {
          println("T. GUARDIAN: solved stuck UP");
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
      if (location.y + radius >= height || location.y - radius <= 30) {
        float thetaD = degrees(moveTheta);
        thetaD = 360-thetaD;
        moveTheta = radians(thetaD);
      }
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