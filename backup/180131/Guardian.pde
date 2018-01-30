static final float GUARDIAN_RADIUS = 8;
static final float[] guardianFlightSpeed = {1.37, 1.65, 1.825, 1.65, 1.4, 1.5, 2.5, 1.5};
static int[] guardianSenseArea = {100, 150, 250, 60, 25, 1000, 0, 125};
 static final String[] guardianName = {"Guardian", "Super Guardian"/*, "Trained Guardian"*/};
static final String[] upgradedGuardianName = {"Royal Guardian", "Baiting Guardian", "Hunting Guardian", "Computer Guardian", "Ranged Guardian", "Bouncer Guardian"};
static final float[][] upgradeGuardianCost = {{75000, 1}, {65000, 1}, {100000, 1}, {11500000, 2}, {75000, 1}, {70000, 0.5}}; //money, week
static final String[][] upgradedGuardianDescription = {
  {"|b"+upgradedGuardianName[0], "|i$"+nfc(int(upgradeGuardianCost[0][0])) + ", " + nf(upgradeGuardianCost[0][1]) + (upgradeGuardianCost[0][1] > 1 ? " weeks" : " week"), "", "|rEnhancements:", "- Increased Flight Speed", "- Increased Sensing Area"}, 
  {"|b"+upgradedGuardianName[1], "|i$"+nfc(int(upgradeGuardianCost[1][0])) + ", " + nf(upgradeGuardianCost[1][1]) + (upgradeGuardianCost[1][1] > 1 ? " weeks" : " week"), "", "|rAbility:", "  Appears as a normal bee (Does not collect honey).", "  However, when an enemy is close by,", "  it would counterattack.", "", "Drawback:", "- Decreased Sensing Area"}, 
  {"|b"+upgradedGuardianName[2], "|i$"+nfc(int(upgradeGuardianCost[2][0])) + ", " + nf(upgradeGuardianCost[2][1]) + (upgradeGuardianCost[2][1] > 1 ? " weeks" : " week"), "", "|rCooldown Ability " + char(34) + "Hunter's Aura" + char(34) + ":", "- Enlarge its AOE area gradually, fully extending it after 1.5s", "- Slows down enemies in its enlarged area", "- When active, the guardian itself cannot move.", "", "Drawback:", "  Normally extremely small sensing area", "  with a mediocre flight speed."}, 
  {"|b"+upgradedGuardianName[3], "|i$"+nfc(int(upgradeGuardianCost[3][0])) + ", " + nf(upgradeGuardianCost[3][1]) + (upgradeGuardianCost[3][1] > 1 ? " weeks" : " week"), "", "|rAbility:", "- Calculates the shortest path to catch an enemy.", "- Player has to target the enemy.", "", "Drawback:", "- Decreased Flight Speed"}, 
  {"|b"+upgradedGuardianName[4], "|i$"+nfc(int(upgradeGuardianCost[4][0])) + ", " + nf(upgradeGuardianCost[4][1]) + (upgradeGuardianCost[4][1] > 1 ? " weeks" : " week"), "", "|rEnhancements:", "- Impressive Flight Speed", "", "Cooldown Ability " + char(34) + "SNIPE!" + char(34) + ":", "- Armed with a projectile sting.", "- Has to reload for every 2 shots.", "- Player controls where the sting lands, not the guardian itself."}, 
  {"|b"+upgradedGuardianName[5], "|i$"+nfc(int(upgradeGuardianCost[5][0])) + ", " + nf(upgradeGuardianCost[5][1]) + (upgradeGuardianCost[5][1] > 1 ? " weeks" : " week"), "", "|rAbility:", "- Sticks next to 1 selected bee to protect it.", "- If the guardian is assigned a new bee target,", "   it will kill the previous bee that it was protecting.", "- Killing one enemy will reset the guardian's target.", "", "Drawback:", "- Decreased Flight Speed"}
};
color[] guardianColour = {color(186, 186, 255), color(136, 136, 255), color(86, 86, 255), beeColour[0], color(124, 70, 10), color(-1), color(113, 100, 86), color(0)};

class Guardian {
  PVector location = new PVector(width/2, height/2); 
  int guardianType = -1; //this is the index of array
  float radius = GUARDIAN_RADIUS;
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

  //baiting guardian specific: flowers
  boolean insideFlower;

  int flower_pedalAmount;
  color flower_stamenColor;
  color flower_pedalColor;

  long insideFlowerTimer = 0;
  /////

  boolean CDAbility = false;
  int CDAInitiateTimer = 0; //hold for how long before activating the ability
  int CDATimer = 0; //Cooldown Ability Timer (how long can the ability last)
  int CDACooldown = 8000; //Cooldown Ability cooldown (ms)

  boolean hyperSelectedStatus = false;
  int stingAmount = 2;
  int stingTier = 1;

  //int targetBeeID[] = {-1, -1};
  int targetBeeID = -1;
  float targetBeeDistinctID = -1;

  boolean nextStage = false;

  boolean demo = false;

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
        guardianType = i+guardianName.length;
        speed = guardianFlightSpeed[guardianType];
      }
    }
  }

  void updateIsDemo(boolean _d) {
    demo = _d;
  }

  void updateLocation(float x, float y) {
    location = new PVector(x, y);
  }

  void updateRadius(float _radius) {
    radius = _radius;
  }

  void resetRadius() {
    radius = GUARDIAN_RADIUS;
  }

  void updateMoveTheta(float _theta) {
    moveTheta = _theta;
  }

  void updateShouldGuardianMove(boolean _shouldGuardianMove) {
    shouldGuardianMove = _shouldGuardianMove;
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

  void updateNextStage(boolean _nextStage) {
    nextStage = _nextStage;
  }

  //baiting guardian specific: flowers
  void updateInsideFlowerTimer(long _t) {
    insideFlowerTimer = _t;
  }  

  void updateInsideFlower(boolean newInsideFlower) {
    insideFlower = newInsideFlower;
  }

  void transferFlowerPedalAmount(int _flower_pedalAmount) {
    flower_pedalAmount = _flower_pedalAmount;
  }

  void transferFlowerColors(color[] __fColors) {
    flower_stamenColor = __fColors[0];
    flower_pedalColor = __fColors[1];
  }
  /////

  //ranged guardian specific
  void updateStingTier(int _st) {
    stingTier = _st;
  }

  void updateStingAmount(int _sa) {
    stingAmount = _sa;
  }
  /////

  //ability specific
  void updateCDAInitiateTimer(int _t) {
    CDAInitiateTimer = _t;
  }

  void updateCDAbility(boolean _a) {
    CDAbility = _a;
  }

  void updateHyperSelectedStatus(boolean _s) {
    hyperSelectedStatus = _s;
  }
  //

  void showGuardian() {
    fill(guardianColour[guardianType]);
    pushMatrix();
    translate(location.x, location.y);
    rotate(radians(angleOffset));
    switch (guardianType) {
    case 6: //ranged guardian
      pushMatrix();
      scale(radius / GUARDIAN_RADIUS);
      strokeWeight(2);
      stroke(50);
      if (stingAmount == 2) {
        line(-3, 0, -3, 12);
        line(+3, 0, +3, 12);
      } else if (stingAmount == 1) {
        line(0, 0, 0, 12);
      }
      popMatrix();
      break;
    }
    stroke(0);
    float blockSize = (650 - 10*2 - 10*5)/5;
    float minimapW = (blockSize+10)*3.3 - 135;
    if (radius != GUARDIAN_RADIUS * (minimapW / width)) strokeWeight(2);
    else strokeWeight(1);
    rotate(HALF_PI);
    polygon(0, 0, radius, 5);
    popMatrix();



    if (demo) {
      fill(139, 245, 255);
      textSize(12);
      textAlign(CENTER);
      text(name, location.x, location.y-20);
    }



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
    } else if (guardianTarget.equals("Flower")) {
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
    } else if (guardianTarget.equals("Beehive")) {
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
    } else if (guardianTarget.equals("Bee")) {
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

      float _diameter = BEE_DIAMETER*0.7;
      float _radius = BEE_DIAMETER /2; 

      fill(beeColour[bees.get(targetBeeID).getBeeType()]);

      stroke(0); 
      strokeWeight(2); 

      //body
      pushMatrix();
      translate(location.x, location.y+35);
      rotate(-moveTheta);
      line(0, 0, -_diameter*1.7/2, 0); //sting of the bee
      ellipse(0, 0, _diameter*1.5, _diameter);

      //"zebra lines" on body (Body Pattern. Upgraded bees have special patterns)
      noStroke();
      fill(0);
      switch (bees.get(targetBeeID).getBeeType()) {
      case 0:
      case 3:
        // *** center bar line ***
        beginShape();
        arc(0, 0, _diameter*1.5, _diameter, HALF_PI*3-radians(15), HALF_PI*3+radians(5));
        arc(0, 0, _diameter*1.5, _diameter, HALF_PI-radians(5), HALF_PI+radians(15));
        endShape();
        rect(-_radius*1.5*cos(radians(75)), -_radius*sin(radians(75)), _radius*1.5*cos(radians(75)) *1.35, _radius*sin(radians(75)) *2);

        // *** offset bar line(s) ***
        //     *** MOST LEFT ***
        arc(0, 0, _diameter*1.5, _diameter, radians(115), radians(135), CHORD);
        beginShape();
        vertex(-1.5*_radius*cos(radians(45)), _radius*sin(radians(45)));
        vertex(-1.5*_radius*cos(radians(65)), _radius*sin(radians(65)));
        vertex(-1.5*_radius*cos(radians(65)), _radius*sin(radians(45)));
        endShape();
        arc(0, 0, _diameter*1.5, _diameter, radians(180+45), radians(180+65), CHORD);
        beginShape();
        vertex(-1.5*_radius*cos(radians(45)), -_radius*sin(radians(45)));
        vertex(-1.5*_radius*cos(radians(65)), -_radius*sin(radians(65)));
        vertex(-1.5*_radius*cos(radians(65)), -_radius*sin(radians(45)));
        endShape();
        rect(-1.5*_radius*cos(radians(45)), -_radius*sin(radians(45)), 1.5*_radius*cos(radians(45))-1.5*_radius*cos(radians(65)), 2*_radius*sin(radians(45)));
        break;

      case 1:
      case 4:
        // *** offset bar line(s) ***
        //     *** MOST LEFT ***
        int a = 120, b = 135;
        arc(0, 0, _diameter*1.5, _diameter, radians(a), radians(b), CHORD);
        beginShape();
        vertex(-1.5*_radius*cos(radians(180-b)), _radius*sin(radians(180-b)));
        vertex(-1.5*_radius*cos(radians(180-a)), _radius*sin(radians(180-a)));
        vertex(-1.5*_radius*cos(radians(180-a)), _radius*sin(radians(180-b)));
        endShape();
        arc(0, 0, _diameter*1.5, _diameter, radians(180+180-b), radians(180+180-a), CHORD);
        beginShape();
        vertex(-1.5*_radius*cos(radians(180-b)), -_radius*sin(radians(180-b)));
        vertex(-1.5*_radius*cos(radians(180-a)), -_radius*sin(radians(180-a)));
        vertex(-1.5*_radius*cos(radians(180-a)), -_radius*sin(radians(180-b)));
        endShape();
        rect(-1.5*_radius*cos(radians(180-b)), -_radius*sin(radians(180-b)), 1.5*_radius*cos(radians(180-b))-1.5*_radius*cos(radians(180-a)), 2*_radius*sin(radians(180-b)));

        //    *** CENTER ***
        a = 95;
        b = 110;
        arc(0, 0, _diameter*1.5, _diameter, radians(a), radians(b), CHORD);
        beginShape();
        vertex(-1.5*_radius*cos(radians(180-b)), _radius*sin(radians(180-b)));
        vertex(-1.5*_radius*cos(radians(180-a)), _radius*sin(radians(180-a)));
        vertex(-1.5*_radius*cos(radians(180-a)), _radius*sin(radians(180-b)));
        endShape();
        arc(0, 0, _diameter*1.5, _diameter, radians(180+180-b), radians(180+180-a), CHORD);
        beginShape();
        vertex(-1.5*_radius*cos(radians(180-b)), -_radius*sin(radians(180-b)));
        vertex(-1.5*_radius*cos(radians(180-a)), -_radius*sin(radians(180-a)));
        vertex(-1.5*_radius*cos(radians(180-a)), -_radius*sin(radians(180-b)));
        endShape();
        rect(-1.5*_radius*cos(radians(180-b)), -_radius*sin(radians(180-b)), 1.5*_radius*cos(radians(180-b))-1.5*_radius*cos(radians(180-a)), 2*_radius*sin(radians(180-b)));

        //    ** RIGHT **
        a = 75;
        b = 85;
        arc(0, 0, _diameter*1.5, _diameter, radians(a), radians(b), CHORD);
        beginShape();
        vertex(1.5*_radius*cos(radians(a)), _radius*sin(radians(a)));
        vertex(1.5*_radius*cos(radians(b)), _radius*sin(radians(b)));
        vertex(1.5*_radius*cos(radians(b)), _radius*sin(radians(a)));
        endShape();
        arc(0, 0, _diameter*1.5, _diameter, radians(180+180-b), radians(180+180-a), CHORD);
        beginShape();
        vertex(1.5*_radius*cos(radians(a)), -_radius*sin(radians(a)));
        vertex(1.5*_radius*cos(radians(b)), -_radius*sin(radians(b)));
        vertex(1.5*_radius*cos(radians(b)), -_radius*sin(radians(a)));
        endShape();
        rect(1.5*_radius*cos(radians(b)), -_radius*sin(radians(a)), 1.5*_radius*cos(radians(a))-1.5*_radius*cos(radians(b)), 2*_radius*sin(radians(a)));

        break;

      case 2:
      case 5:
        // *** offset bar line(s) ***
        //     *** MOST LEFT ***
        a = 127;
        b = 136;
        arc(0, 0, _diameter*1.5, _diameter, radians(a), radians(b), CHORD);
        beginShape();
        vertex(-1.5*_radius*cos(radians(180-b)), _radius*sin(radians(180-b)));
        vertex(-1.5*_radius*cos(radians(180-a)), _radius*sin(radians(180-a)));
        vertex(-1.5*_radius*cos(radians(180-a)), _radius*sin(radians(180-b)));
        endShape();
        arc(0, 0, _diameter*1.5, _diameter, radians(180+180-b), radians(180+180-a), CHORD);
        beginShape();
        vertex(-1.5*_radius*cos(radians(180-b)), -_radius*sin(radians(180-b)));
        vertex(-1.5*_radius*cos(radians(180-a)), -_radius*sin(radians(180-a)));
        vertex(-1.5*_radius*cos(radians(180-a)), -_radius*sin(radians(180-b)));
        endShape();
        rect(-1.5*_radius*cos(radians(180-b)), -_radius*sin(radians(180-b)), 1.5*_radius*cos(radians(180-b))-1.5*_radius*cos(radians(180-a)), 2*_radius*sin(radians(180-b)));

        //    *** LEFT ***
        a = 111;
        b = 119;
        arc(0, 0, _diameter*1.5, _diameter, radians(a), radians(b), CHORD);
        beginShape();
        vertex(-1.5*_radius*cos(radians(180-b)), _radius*sin(radians(180-b)));
        vertex(-1.5*_radius*cos(radians(180-a)), _radius*sin(radians(180-a)));
        vertex(-1.5*_radius*cos(radians(180-a)), _radius*sin(radians(180-b)));
        endShape();
        arc(0, 0, _diameter*1.5, _diameter, radians(180+180-b), radians(180+180-a), CHORD);
        beginShape();
        vertex(-1.5*_radius*cos(radians(180-b)), -_radius*sin(radians(180-b)));
        vertex(-1.5*_radius*cos(radians(180-a)), -_radius*sin(radians(180-a)));
        vertex(-1.5*_radius*cos(radians(180-a)), -_radius*sin(radians(180-b)));
        endShape();
        rect(-1.5*_radius*cos(radians(180-b)), -_radius*sin(radians(180-b)), 1.5*_radius*cos(radians(180-b))-1.5*_radius*cos(radians(180-a)), 2*_radius*sin(radians(180-b)));

        //    ** RIGHT **
        a = 95;
        b = 103;
        arc(0, 0, _diameter*1.5, _diameter, radians(a), radians(b), CHORD);
        beginShape();
        vertex(-1.5*_radius*cos(radians(180-b)), _radius*sin(radians(180-b)));
        vertex(-1.5*_radius*cos(radians(180-a)), _radius*sin(radians(180-a)));
        vertex(-1.5*_radius*cos(radians(180-a)), _radius*sin(radians(180-b)));
        endShape();
        arc(0, 0, _diameter*1.5, _diameter, radians(180+180-b), radians(180+180-a), CHORD);
        beginShape();
        vertex(-1.5*_radius*cos(radians(180-b)), -_radius*sin(radians(180-b)));
        vertex(-1.5*_radius*cos(radians(180-a)), -_radius*sin(radians(180-a)));
        vertex(-1.5*_radius*cos(radians(180-a)), -_radius*sin(radians(180-b)));
        endShape();
        rect(-1.5*_radius*cos(radians(180-b)), -_radius*sin(radians(180-b)), 1.5*_radius*cos(radians(180-b))-1.5*_radius*cos(radians(180-a)), 2*_radius*sin(radians(180-b)));

        //    ** MOST RIGHT **
        a = 79;
        b = 87;
        arc(0, 0, _diameter*1.5, _diameter, radians(a), radians(b), CHORD);
        beginShape();
        vertex(1.5*_radius*cos(radians(a)), _radius*sin(radians(a)));
        vertex(1.5*_radius*cos(radians(b)), _radius*sin(radians(b)));
        vertex(1.5*_radius*cos(radians(b)), _radius*sin(radians(a)));
        endShape();
        arc(0, 0, _diameter*1.5, _diameter, radians(180+180-b), radians(180+180-a), CHORD);
        beginShape();
        vertex(1.5*_radius*cos(radians(a)), -_radius*sin(radians(a)));
        vertex(1.5*_radius*cos(radians(b)), -_radius*sin(radians(b)));
        vertex(1.5*_radius*cos(radians(b)), -_radius*sin(radians(a)));
        endShape();
        rect(1.5*_radius*cos(radians(b)), -_radius*sin(radians(a)), 1.5*_radius*cos(radians(a))-1.5*_radius*cos(radians(b)), 2*_radius*sin(radians(a)));
        break;
      }

      //sclera (white part of the eye)
      stroke(0);
      strokeWeight(1);
      fill(255);
      ellipse(_diameter*0.65, _diameter*0.35, _diameter*0.65, _diameter*0.65);
      ellipse(_diameter*0.65, -_diameter*0.35, _diameter*0.65, _diameter*0.65);

      //eyeballs (black)
      noStroke();
      fill(50);
      ellipse(_diameter*0.65, _diameter*0.35, _diameter*0.25, _diameter*0.25);
      ellipse(_diameter*0.65, -_diameter*0.35, _diameter*0.25, _diameter*0.25);

      //bigger wings
      fill(200, 200, 200, 150);
      pushMatrix();
      translate(0, _diameter*1);
      rotate(radians(60));
      ellipse(0, 0, _diameter*1.5, _diameter);
      popMatrix();
      pushMatrix();
      translate(0, -_diameter*1);
      rotate(-radians(60));
      ellipse(0, 0, _diameter*1.5, _diameter);
      popMatrix();

      //smaller wings
      pushMatrix();
      translate(-5, _diameter*0.8);
      rotate(radians(50));
      ellipse(0, 0, _diameter*1.2, _diameter);
      popMatrix();
      pushMatrix();
      translate(-5, -_diameter*0.8);
      rotate(-radians(50));
      ellipse(0, 0, _diameter*1.2, _diameter);
      popMatrix();



      popMatrix();
    } else if (CDAbility && guardianType == 4) {
      fill(124, 70, 10);
      textSize(10);
      textAlign(CENTER);
      text("HUNTER'S AURA", location.x, location.y-15);
    } else if (hyperSelectedStatus && guardianType == 6) {
      fill(113, 100, 86);
      textSize(10);
      textAlign(CENTER);
      text("SNIPE! Ready", location.x, location.y-15);
    } else if (hyperSelectedStatus && guardianType == 7) {
      fill(25);
      textSize(8);
      textAlign(CENTER);
      text("Choose a bee", location.x, location.y-22);
      text("to protect.", location.x, location.y-12);
    } else {
      //Situation "None"

      //fill(200, 0, 200);
      //textSize(10);
      //textAlign(CENTER);
      //text(beeTarget, location.x, location.y+35);
    }

    if (shouldGuardianMove) { //if the guardian is in forest (i.e. not as inv display / minimap)
      if (guardianType == 4 && CDAbility == false) { //hunting guardian
        strokeWeight(1);
        stroke(50);
        noFill();
        rect(location.x+12, location.y-10, 6, 20);

        rectMode(CORNERS);
        noStroke();
        if (CDACooldown == 0) fill(12, 124, 13);  
        else fill(guardianColour[guardianType]);

        rect(location.x+12.25, map(CDACooldown, 8000, 0, location.y+10, location.y-10), location.x+17.75, location.y+9.75);
        rectMode(CORNER);

        fill(255);
        textSize(8);
        if (CDACooldown >0) text(ceil(float(CDACooldown)/1000), location.x, location.y+2);
        //if (CDACooldown >0) println(CDACooldown, float(CDACooldown)/1000, ceil(float(CDACooldown)/1000));
      } else if (guardianType == 6 && stingAmount < 2) {
        strokeWeight(1);
        stroke(50);
        noFill();
        rect(location.x+12, location.y-10, 6, 20);

        rectMode(CORNERS);
        noStroke();
        fill(guardianColour[guardianType]);
        ;
        rect(location.x+12.25, map(CDACooldown, 3500, 0, location.y+10, location.y-10), location.x+17.75, location.y+9.75);
        rectMode(CORNER);
      }
    }

    //if (debug) { //display guardian sensing area
    //  noStroke();
    //  fill(0, 0, 100, 70);
    //  ellipse(location.x, location.y, guardianSenseArea[guardianType]*2, guardianSenseArea[guardianType]*2);
    //}

    if (angleOffset >= 360) angleOffset -= 360;
    else if (guardianTarget.equals("Hornet")) angleOffset += 2;
    else if (guardianType == 4 && CDAbility) angleOffset += 5;
    else angleOffset += 0.5;
  }

  void goTowardsBeeHive() {
    // the only time that guardians go towards beehive is during end round period.
    // that means initialize everything of guardian when this runs.
    shouldGuardianMove = true;

    guardianTarget = "None";

    insideFlower = false;

    flower_pedalAmount = 0;
    flower_stamenColor = color(0);
    flower_pedalColor = color(0);

    insideFlowerTimer = 4501;

    CDAbility = false;
    CDACooldown = 8000; //8 seconds cooldown

    hyperSelectedStatus = false;
    stingAmount = 2;

    targetBeeID = -1;
    targetBeeDistinctID = -1;

    speed = guardianFlightSpeed[guardianType]; //return to normal speed
    moveTheta = calcMoveTheta(width/2, height/2, location.x, location.y);
  }

  void move() {
    speed = guardianFlightSpeed[guardianType] * (60/frameRate); //speed correction

    if (!CDAbility) {
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

    //if guardian is not targetless, then it can perform timeoutmove
    if (guardianTarget != "None") guardianTimeoutMove = false;
    else guardianTimeoutMove = true;

    float shortestDistance = distance_between_two_points(0, width, 0, height); //set supposedly shortest distance to be the longest so that it is certain that there will be a shorter distance
    int closestHornetID = -1;

    if (guardianTarget.equals("Firefly") == false) {
      if (demo) {
        for (int h = demoHornet.size ()-1; h >= 0; h--) {
          Hornet _hornet = demoHornet.get(h);

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
          shouldGuardianMove = true;

          Hornet h = demoHornet.get(closestHornetID);
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
            demoHornet.remove(h);
            if (guardianType == 7) {
              targetBeeID = -1;
              hyperSelectedStatus = false;
              CDAbility = false;
            }
          }
          float _thetaRad = asin(abs(hy - location.y) / hypotenuse);
          moveTheta = returnRealTheta(_thetaRad, detX, detY);
        } else if (guardianTarget.equals("Flower") == false && guardianTarget.equals("Bee") == false /* and all other possible targets */) guardianTarget = "None"; //reset the target
      } else {
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
          shouldGuardianMove = true;

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
            if (guardianType == 7) {
              targetBeeID = -1;
              hyperSelectedStatus = false;
              CDAbility = false;
            }
          }
          float _thetaRad = asin(abs(hy - location.y) / hypotenuse);
          moveTheta = returnRealTheta(_thetaRad, detX, detY);
        } else if (guardianTarget.equals("Flower") == false && guardianTarget.equals("Bee") == false /* and all other possible targets */) guardianTarget = "None"; //reset the target
      }
    }

    if (guardianType >= 2 && guardianTarget.equals("Hornet") == false && guardianTarget.equals("Flower") == false && guardianTarget.equals("Bee") == false) {

      int closestFireflyID = -1;
      for (int ff = fireflies.size ()-1; ff >= 0; ff--) {
        Firefly _firefly = fireflies.get(ff);

        float ffx = _firefly.getLocation().x;
        float ffy = _firefly.getLocation().y;
        float hypotenuse = distance_between_two_points(ffx, location.x, ffy, location.y);

        if (hypotenuse > guardianSenseArea[guardianType]) continue;
        else {
          if (hypotenuse < shortestDistance) {
            shortestDistance = hypotenuse;
            closestFireflyID = ff;
          }
        }
      }

      if (closestFireflyID != -1) {
        guardianTarget = "Firefly";
        shouldGuardianMove = true;

        Firefly ff = fireflies.get(closestFireflyID);
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
          fireflies.remove(ff);
          if (guardianType == 7) {
            targetBeeID = -1;
            hyperSelectedStatus = false;
            CDAbility = false;
          }
        }
        float _thetaRad = asin(abs(ffy - location.y) / hypotenuse);
        moveTheta = returnRealTheta(_thetaRad, detX, detY);
      } else if (guardianTarget.equals("Flower") == false && guardianTarget.equals("Bee") == false /* and all other possible targets */) guardianTarget = "None"; //reset the target
    }

    if (guardianType == 3 && roundOver == false) { //baiting guardian mechanic 
      println("guardian target " + guardianTarget);

      if (guardianTarget.equals("Flower")) {
        shouldGuardianMove = true;
        insideFlowerTimer = 4501; //so that it can move out of the previous flower

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

        if (fx == 0 && fy == 0) {
          //the guardian's flower target has been removed before reaching it
          guardianTarget = "None";
          guardianTimeoutMove = true;
          guardianMoveTimer = gameMillis;
        } else {
          float hypo = distance_between_two_points(location.x, fx, location.y, fy);

          if (hypo < 2.5) {
            guardianTarget = "None"; //move to the code below
            shouldGuardianMove = false;
            insideFlowerTimer = 0;
            guardianTimeoutMove = true;
          }
        }
      } else if (guardianTarget.equals("None")) { //beeFull == false (that means "go in the flower" for bees)
        boolean hasFlowerTarget = false;

        for (int f = flowers.size ()-1; f >= 0; f--) {
          Flower _flower = flowers.get(f);
          float fx = _flower.getLocation().x;
          float fy = _flower.getLocation().y;

          float hypotenuse = distance_between_two_points(location.x, fx, location.y, fy);


          if (hypotenuse <= 2.5 && insideFlowerTimer < 4500) { //"Pick honey"
            insideFlower = true;
            shouldGuardianMove = false; //"if bee is picking honey, do not move"
            guardianMoveTimer = gameMillis;

            hasFlowerTarget = true;
            break;
          } else if (hypotenuse <= 55 && insideFlowerTimer < 4500 && insideFlower == false) { //"go in flower. hypotenuse < flower radius + bee radius" *** RUNS ONLY ONCE! THIS IS FOR ASSIGNING THE MOVETHETA
            insideFlower = true;
            moveTheta = calcMoveTheta(fx, fy, location.x, location.y);

            hasFlowerTarget = true;
            break;
          } else if (hypotenuse <= 55 && insideFlowerTimer >= 4500) {
            insideFlower = true;
            shouldGuardianMove = true;
            guardianTimeoutMove = true;

            hasFlowerTarget = true;
            break;
          } else {
            //println("out of flower's range");
          }
        }

        //println(hasFlowerTarget);

        if (hasFlowerTarget == false) { //not in any flower
          shouldGuardianMove = true;
          insideFlower = false;
          insideFlowerTimer = 0;
        }
      }

      //println(insideFlower, insideFlowerTimer);

      if (insideFlower) {
        insideFlowerTimer += (timeMillis-pMillis);
      }
    } else if (guardianType == 4 && roundOver == false) { //hunting guardian (beacon)
      float mouseDistance = distance_between_two_points(location.x, mouseX, location.y, mouseY);
      if (CDACooldown == 0 && mousePressed && mouseDistance < 20) {
        CDAInitiateTimer += timeMillis-pMillis;
      } else CDAInitiateTimer = 0;

      if (CDAInitiateTimer >= 500) CDAbility = true; //held for 0.5s, activate
      else if (CDATimer >= 7000) { //activated for 7s, stop
        CDACooldown = 8000;
        shouldGuardianMove = true;
        speed = guardianFlightSpeed[guardianType];

        CDAbility = false;
        CDATimer = 0;
      }

      if (CDAbility) {
        guardianSelectedStatus = false;

        CDATimer += int(timeMillis-pMillis);

        if (CDATimer <= 1500) speed = map(CDATimer, 0, 1500, guardianFlightSpeed[guardianType], 0); //gradually slow down
        else shouldGuardianMove = false;
        noStroke();
        fill(124, 70, 10, 15);
        if (CDATimer <= 1500) ellipse(location.x, location.y, map(CDATimer, 0, 1500, guardianSenseArea[guardianType], 600), map(CDATimer, 0, 1500, guardianSenseArea[guardianType], 600));
        else ellipse(location.x, location.y, 600, 600);
      } else {
        CDACooldown -= int(timeMillis-pMillis);
        CDACooldown = constrain(CDACooldown, 0, 8000);
      }

      for (Hornet h : hornets) {
        float hx = h.getLocation().x, hy = h.getLocation().y;
        float hypotenuse = distance_between_two_points(location.x, hx, location.y, hy);

        if (hypotenuse <= constrain(map(CDATimer, 0, 1500, guardianSenseArea[guardianType], 300), guardianSenseArea[guardianType], 300)) {
          h.updateSpeed(hornetFlightSpeed[h.getHornetType()]/2);
        } else h.resetSpeed();
      }

      for (Firefly ff : fireflies) {
        float ffx = ff.getLocation().x, ffy = ff.getLocation().y;
        float hypotenuse = distance_between_two_points(location.x, ffx, location.y, ffy);

        if (hypotenuse <= constrain(map(CDATimer, 0, 1500, guardianSenseArea[guardianType], 300), guardianSenseArea[guardianType], 300)) {
          ff.updateSpeed(1.6/2);
        } else ff.resetSpeed();
      }
    } else if (guardianType == 5) { //computer
    } else if (guardianType == 6) { //ranged guardian
      if (hyperSelectedStatus) {
        if (mousePressed) {
          float shootTheta = calcMoveTheta(mouseX, mouseY, location.x, location.y);
          projectiles.add(new ProjectileWeapon(0, projectileSpeed[0]*(1+(stingTier-1)*0.3), location.x, location.y, shootTheta, false));
          stingAmount--;
          hyperSelectedStatus = false;
        }
      }

      if (stingAmount < 2) {
        CDACooldown -= int(timeMillis-pMillis);
        CDACooldown = constrain(CDACooldown, 0, 3500);
      }

      if (CDACooldown == 0) {
        CDACooldown = 3500;
        stingAmount++;
      }
    } else if (guardianType == 7) { //bouncer guardian
      //for debug
      //textAlign(CENTER);
      //textSize(10);
      //fill(0);
      //text(targetBeeID, location.x, location.y+20);
      //text(hyperSelectedStatus + " " + CDAbility, location.x, location.y+32);

      while (targetBeeID == bees.size()) targetBeeID--;

      if (guardianTarget.equals("Hornet") == false && guardianTarget.equals("Firefly") == false /* and all other enemy targets */) { //not chasing enemy
        if (hyperSelectedStatus && guardianTarget.equals("Bee") == false) { 
          if (beesSelectedCurr > 0) {
            for (int i = bees.size()-1; i >= 0; i--) {
              Bee b = bees.get(i);

              if (b.getBeeSelectedStatus()) {
                b.updateBeeSelectedStatus(false);
                hyperSelectedStatus = false; //de-activate the hyper (ability to choose target)                

                if (targetBeeID != i) {
                  guardianTarget = "Bee";
                  if (targetBeeID != -1 && CDAbility) { //the guardian previously had a PROTECTING target 
                    bees.get(targetBeeID).updateIsAlive(false); //kill that previous target first
                    CDAbility = false;
                    targetBeeID = i;
                  } else targetBeeID = i;
                } else { //selected the same target 
                  if (CDAbility) hyperSelectedStatus = false; //the same target it was PROTECTING
                  else {
                    guardianTarget = "Bee";
                    targetBeeID = i;
                  }
                }
                break;
              }
            }
          }
        }

        if (guardianTarget.equals("Bee") && 
          guardianTarget.equals("Hornet") == false && 
          guardianTarget.equals("Firefly") == false && 
          guardianTarget.equals("Flower") == false &&
          CDAbility == false) {
          //approach next to the bee.

          shouldGuardianMove = true;
          speed = guardianFlightSpeed[guardianType]; //return to normal speed

          Bee b = bees.get(targetBeeID);
          float bx=b.getLocation().x, by=b.getLocation().y;

          float hypotenuse = distance_between_two_points(location.x, bx, location.y, by);
          if (hypotenuse < 1.5) {
            //confirm target
            targetBeeDistinctID = b.getDistinctID();
            guardianTarget = "None";
            hyperSelectedStatus = false;
            CDAbility = true;
          }
          moveTheta = calcMoveTheta(bx, by, location.x, location.y);
        }

        if (CDAbility && bees.size() > 0) {
          //if (guardianTarget.equals("Bee")) {
          ////if the bee has a target, but assigned a new target
          ////then kill the previous target (move to the target's center first)

          ////Bee b = bees.get(targetBeeID[0]);
          ////float bx=b.getLocation().x, by=b.getLocation().y;
          ////if (bx < width-25) bx = bx+18;
          ////else bx = bx-18;
          ////if (by > 30+30) by = by-18;
          ////else by = by+18;

          ////float hypotenuse = distance_between_two_points(location.x, bx, location.y, by);
          ////if (hypotenuse < 1.5) {
          //bees.get(targetBeeID[0]).updateIsAlive(false);
          //CDAbility = false;
          ////below 2 lines: precautions before when updateIsAlive wasnt a thing yet
          ////if (targetBeeID[0] < targetBeeID[1]) targetBeeID[0] = targetBeeID[1]-1;
          ////else targetBeeID[0] = targetBeeID[1];
          //targetBeeID[0] = targetBeeID[1];
          ////}
          //} else {
          Bee b = bees.get(targetBeeID);
          if (targetBeeDistinctID == b.getDistinctID()) { //check if the bee is still the same bee (changes if the bee is sold / killed)
            speed = b.getSpeed(); //update speed to match the current bee's speed (move with the bee) so that it doesnt spaze out

            float bx=b.getLocation().x, by=b.getLocation().y;
            if (bx < width-30) bx = bx+18;
            else bx = bx-18;
            if (by > 30+30) by = by-18;
            else by = by+18;

            moveTheta = calcMoveTheta(bx, by, location.x, location.y);
          } else {
            targetBeeID = -1;
            targetBeeDistinctID = -1;
            hyperSelectedStatus = false;
            CDAbility = false;
          }
          //}
        }
      } else { //it has enemy target
        speed = guardianFlightSpeed[guardianType]; //return to normal speed
      }
    }

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
          println("GUARDIAN (" + name + ") : solved stuck RIGHT");
          location.x -= 3;
        }
      } else if (location.x - radius <= 0) {
        stuckFrames += 1;
        println(location.x, location.y);
        if (stuckFrames >= 30) {
          println("GUARDIAN (" + name + ") : solved stuck LEFT");
          location.x += 3;
        }
      } else if (location.y + radius >= height-40) {
        stuckFrames += 1;
        println(location.x, location.y);
        if (stuckFrames >= 30) {
          println("GUARDIAN (" + name + ") : solved stuck DOWN");
          location.y -= 3;
        }
      } else if (location.y - radius <= 30) {
        stuckFrames += 1;
        println(location.x, location.y);
        if (stuckFrames >= 30) {
          println("GUARDIAN (" + name + ") : solved stuck UP");
          location.y += 3;
        }
      } else {
        stuckFrames = 0;
      }

      float maxX, minX, maxY, minY;
      if (demo) {
        minX = 220;
        maxX = 220+width/2;
        minY = 70;
        maxY = 70+height/1.75;
      } else {
        maxX = width;
        minX = 0;
        maxY = height-40;
        minY = 30;
      }
      if (location.x + radius >= maxX || location.x - radius <= minX) {
        float thetaD = degrees(moveTheta);
        if (thetaD >= 0 && thetaD < 180) {
          thetaD = 180-thetaD;
        } else {
          thetaD = 180 + (360-thetaD);
        }
        moveTheta = radians(thetaD);
      }
      if (location.y + radius >= maxY || location.y - radius <= minY) {
        float thetaD = degrees(moveTheta);
        thetaD = 360-thetaD;
        moveTheta = radians(thetaD);
      }
    }

    if (roundOver) { //when roundOver, guardian goes towards beehive too
      targetBeeID = -1;
      hyperSelectedStatus = false;
      CDAbility = false;
      guardianTarget = "None";

      float hypotenuse = distance_between_two_points(location.x, (width/2), location.y, (height/2));
      if (hypotenuse < 2) {
        if (radius > 0) radius -= 0.5; 
        else nextStage = true;
      }
    }


    float moveX = speed*cos(moveTheta);
    float moveY = -speed*sin(moveTheta);




    if (shouldGuardianMove) location = new PVector(location.x+moveX, location.y+moveY); //the actual moving code
  }

  float getAngleOffset() {
    return angleOffset;
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

  int getGuardianType() {
    return guardianType;
  }

  String getGuardianTarget() {
    return guardianTarget;
  }

  //baiting guardian specific: flowers
  boolean getInsideFlower() {
    return insideFlower;
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
  //////////////
  int getCDACooldown() {
    return CDACooldown;
  }

  boolean getCDAbility() {
    return CDAbility;
  }

  //ranged guardian
  boolean getHyperSelectedStatus() {
    return hyperSelectedStatus;
  }

  int getStingAmount() {
    return stingAmount;
  }

  int getStingTier() {
    return stingTier;
  }
  /////
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

  boolean nextToObjective = false;

  //ranged guardian training course
  int bulletTimer = 0;
  int bulletAmmo = 0;
  int stingCooldown = 10000;
  boolean shootSting = false;
  boolean confirmShoot = false;
  //boolean stingReady = false;
  /////

  TrainingGuardian(int type) {
    name = upgradedGuardianName[type];

    guardianType = type;

    bulletTimer = 0;
  }

  boolean demo = false;
  void updateIsDemo(boolean _d) {
    demo = _d;
    location = new PVector(width/2, height/2+10);
  }

  void updateShouldGuardianMove(boolean _sgm) {
    shouldGuardianMove = _sgm;
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

  void updateSpeed(float _s) {
    speed = _s;
  }

  void updateShootSting(boolean _b) {
    shootSting = _b;
  }

  void showGuardian() {
    if (nextToObjective) fill(250, 150, 250);
    else fill(136, 136, 255);
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
    else if (guardianTarget.equals("None") == false) text(guardianTarget, location.x, location.y+20);



    //if (debug) {
    //  noStroke();
    //  fill(0, 0, 100, 50);
    //  ellipse(location.x, location.y, guardianSenseArea[1]*2, guardianSenseArea[1]*2);
    //}

    if (angleOffset >= 360) angleOffset -= 360;
    else if (angleOffset <= -360) angleOffset += 360;

    if (guardianTarget.equals("Firefly")) angleOffset += 2;
    else angleOffset += 0.5;

    if (guardianType == 4) { //ranged guardian
      fill(136, 136, 255);
      textSize(9);
      textAlign(CENTER);
      PFont lineFont = createFont("Lucida Sans Demibold", 9);
      textFont(lineFont);
      if (bulletAmmo < 100) {
        text(str(bulletAmmo).substring(0, 1), location.x-2.5, location.y-15);
        text(str(bulletAmmo).substring(1), location.x+2.5, location.y-15);
      } else if (bulletAmmo < 1000) {
        text(str(bulletAmmo).substring(0, 1), location.x-5, location.y-15);
        text(str(bulletAmmo).substring(1, 2), location.x, location.y-15);
        text(str(bulletAmmo).substring(2), location.x+5, location.y-15);
      } else {
        text(str(bulletAmmo).substring(0, 1), location.x-7.5, location.y-15);
        text(str(bulletAmmo).substring(1, 2), location.x-2.5, location.y-15);
        text(str(bulletAmmo).substring(2, 3), location.x+2.5, location.y-15);
        text(str(bulletAmmo).substring(3), location.x+7.5, location.y-15);
      }
      lineFont = createFont("Lucida Sans Regular", 9);
      textFont(lineFont);

      if (shootSting) {
        text("Press a location to shoot", location.x, location.y+15);
      }
    }
  }

  void selectTarget(int _objectiveID) {
    switch (guardianType) {
    case 0: //Royal Guardian
      guardianTarget = "Firefly";
      objectiveID = _objectiveID;
      break;

    case 1: //Baiting Guardian
      guardianTarget = "Flower";
      objectiveID = _objectiveID;
      break;
    }
  }

  void move() {
    speed = guardianFlightSpeed[1] * (60/frameRate); //speed correction

    if (demo) {
      switch (guardianType) {
      case 0: //Royal Guardian
        if (objectiveID != -1) {
          Firefly ff = demoFirefly.get(objectiveID);
          float ffx = ff.getLocation().x;
          float ffy = ff.getLocation().y;
          if (debug) {
            //display a blue line that represents which firefly is the guardian going for
            stroke(0, 0, 200, 100);
            strokeWeight(1);
            line(location.x, location.y, ffx, ffy);
          }
          float detX = ffx - location.x;
          float detY = ffy - location.y;
          float hypotenuse = distance_between_two_points(location.x, ffx, location.y, ffy);
          if (hypotenuse < 1.5) {
            demoFirefly.remove(ff);
            guardianTarget = "None";
            objectiveID = -1;
          }
          float _thetaRad = asin(abs(ffy - location.y) / hypotenuse);
          moveTheta = returnRealTheta(_thetaRad, detX, detY);
        } else guardianTarget = "None"; //reset the target
        break;

      case 1: //Baiting Guardian
        if (objectiveID != -1) {
          Flower tf = demoFlower.get(objectiveID);
          float tfx = tf.getLocation().x;
          float tfy = tf.getLocation().y;

          float detX = tfx - location.x;
          float detY = tfy - location.y;
          float hypotenuse = distance_between_two_points(location.x, tfx, location.y, tfy);
          if (hypotenuse < 1.5) {
            speed -= 0.025;
            if (speed < 0.8) speed = 0.8;

            demoChargeBar += 1000;

            demoFlower.remove(objectiveID);
            demoFlower.add(new Flower(0, 0, 5, 5)); //if too close to beehive, it auto re-calculates location
            demoFlower.get(demoFlower.size()-1).updateLocation(220+width/4 + random(-100, 100), 30+(height/1.75)/2 + 20 + random(-100, 100));
            demoFlower.get(demoFlower.size()-1).updateIsDemo(true);
            demoFlower.get(demoFlower.size()-1).updateForTraining(true);

            guardianTarget = "None";
            objectiveID = -1;
            guardianTimeoutMove = true;
          } else nextToObjective = false;
          float _thetaRad = asin(abs(tfy - location.y) / hypotenuse);
          moveTheta = returnRealTheta(_thetaRad, detX, detY);
        } else guardianTarget = "None"; //reset the flower target

        for (Flower tf : demoFlower) {
          float tfx = tf.getLocation().x;
          float tfy = tf.getLocation().y;

          float hypotenuse = dist(tfx, tfy, location.x, location.y);

          if (debug) { //display the flower's effective range
            noStroke();
            ellipse(location.x, location.y, 35, 35);
          }

          if (hypotenuse < 35) {
            demoChargeBar += timePassed;
            angleOffset -= 2.5;
            nextToObjective = true;
            break; //break out of "for", or the objective time is gonna accumulate on a scale of how many flowers are nearby, AND the guardian won't turn colour unless it's the last flower in the ArrayList
          } else nextToObjective = false;
        }
        break;

      case 2: //hunting guardian
        //println(frameCount + " / SPEED: "+speed + " ; LOCATION: "+location);
        break;

      case 3:
        break;

      case 4: //ranged guardian
        println(bulletAmmo);

        for (int _p = pomegranate.size()-1; _p >= 0; _p--) {
          ItemSpawn p = pomegranate.get(_p);
          float px = p.getLocation().x;
          float py = p.getLocation().y;

          float hypotenuse = distance_between_two_points(location.x, px, location.y, py);
          if (hypotenuse < 25) {
            bulletAmmo += p.getItemReward();
            pomegranate.remove(_p);
            break;
          }
        }

        bulletTimer += int(timeMillis-pMillis);
        if (bulletTimer > 125) {
          if (bulletAmmo > 0) {
            projectiles.add(new ProjectileWeapon(1, 0, location.x, location.y, moveTheta, true));
            bulletTimer = 0;
            bulletAmmo--;
          }
        }

        if (stingCooldown > 0) {
          stingCooldown -= int(timeMillis-pMillis);
          stingCooldown = constrain(stingCooldown, 0, 10000);
        }

        if (shootSting && bulletAmmo > 0) {
          if (mousePressed == false && confirmShoot == false) confirmShoot = true;

          float mouseDistanceToCancel = distance_between_two_points(width-160, mouseX, height-32.5, mouseY);
          if (mouseDistanceToCancel <= 35 && mousePressed) {
            confirmShoot = false;
            shootSting = false;
            stingCooldown = 10000;
            ignoreGTClick = true;
          } else if (confirmShoot && mousePressed) {
            float shootTheta = calcMoveTheta(mouseX, mouseY, location.x, location.y);
            for (float i = -radians(30); i <= radians(30); i+= radians(5)) {
              projectiles.add(new ProjectileWeapon(random(1) > 0.95 ? 0 : 1, 0, location.x, location.y, shootTheta+i, true));
              bulletAmmo--;
              if (bulletAmmo == 0) break;
            }
            //println(projectiles.size());
            shootSting = false;
            stingCooldown = 10000;
            ignoreGTClick = true;
          }
        }
        break;

      case 5: //bouncer guardian
        float shortestDistance = distance_between_two_points(0, width, 0, height); //set supposedly shortest distance to be the longest so that it is certain that there will be a shorter distance
        int closestHornetID = -1;

        for (int h = GTHornets.size ()-1; h >= 0; h--) {
          Hornet _hornet = GTHornets.get(h);

          float hx = _hornet.getLocation().x;
          float hy = _hornet.getLocation().y;
          float hypotenuse = distance_between_two_points(hx, location.x, hy, location.y);

          if (hypotenuse > guardianSenseArea[1]) continue;
          else {
            if (hypotenuse < shortestDistance) {
              shortestDistance = hypotenuse;
              closestHornetID = h;
            }
          }
        }

        if (closestHornetID != -1) {
          guardianTarget = "Hornet";

          Hornet h = GTHornets.get(closestHornetID);
          float hx = h.getLocation().x;
          float hy = h.getLocation().y;
          if (debug) {
            //display a blue line that represents which hornet is the guardian going for
            stroke(0, 0, 200, 100);
            strokeWeight(1);
            line(location.x, location.y, hx, hy);
          }

          float hypotenuse = distance_between_two_points(location.x, hx, location.y, hy);
          if (hypotenuse < 1.5) {
            GTHornets.remove(h);
          }
          moveTheta = calcMoveTheta(hx, hy, location.x, location.y);
        } else guardianTarget = "None"; //reset the target
        break;
      }
    } else {
      switch (guardianType) {
      case 0: //Royal Guardian
        if (objectiveID != -1) {
          Firefly ff = GTFireflies.get(objectiveID);
          float ffx = ff.getLocation().x;
          float ffy = ff.getLocation().y;
          if (debug) {
            //display a blue line that represents which firefly is the guardian going for
            stroke(0, 0, 200, 100);
            strokeWeight(1);
            line(location.x, location.y, ffx, ffy);
          }
          float detX = ffx - location.x;
          float detY = ffy - location.y;
          float hypotenuse = distance_between_two_points(location.x, ffx, location.y, ffy);
          if (hypotenuse < 1.5) {
            GTFireflies.remove(ff);
            guardianTarget = "None";
            objectiveID = -1;
          }
          float _thetaRad = asin(abs(ffy - location.y) / hypotenuse);
          moveTheta = returnRealTheta(_thetaRad, detX, detY);
        } else guardianTarget = "None"; //reset the target
        break;

      case 1: //Baiting Guardian
        if (objectiveID != -1) {
          Flower tf = GTFlowers.get(objectiveID);
          float tfx = tf.getLocation().x;
          float tfy = tf.getLocation().y;

          float detX = tfx - location.x;
          float detY = tfy - location.y;
          float hypotenuse = distance_between_two_points(location.x, tfx, location.y, tfy);
          if (hypotenuse < 1.5) {
            speed -= 0.025;
            if (speed < 0.8) speed = 0.8;

            GTObjectiveTime += 2000;

            GTFlowers.remove(objectiveID);
            GTFlowers.add(new Flower(10+random(width-20), 40+random(height-40-50), 0, 0));
            GTFlowers.get(GTFlowers.size()-1).updateForTraining(true);

            guardianTarget = "None";
            objectiveID = -1;
            guardianTimeoutMove = true;
          } else nextToObjective = false;
          float _thetaRad = asin(abs(tfy - location.y) / hypotenuse);
          moveTheta = returnRealTheta(_thetaRad, detX, detY);
        } else guardianTarget = "None"; //reset the flower target

        for (Flower tf : GTFlowers) {
          float tfx = tf.getLocation().x;
          float tfy = tf.getLocation().y;

          float hypotenuse = distance_between_two_points(location.x, tfx, location.y, tfy);

          if (debug) { //display the flower's effective range
            noStroke();
            ellipse(location.x, location.y, 60, 60);
          }

          if (hypotenuse < 60) {
            GTObjectiveTime += (timeMillis-pMillis);
            angleOffset -= 2.5;
            nextToObjective = true;
            break; //break out of "for", or the objective time is gonna accumulate on a scale of how many flowers are nearby, AND the guardian won't turn colour unless it's the last flower in the ArrayList
          } else nextToObjective = false;
        }
        break;

      case 2: //hunting guardian
        //println(frameCount + " / SPEED: "+speed + " ; LOCATION: "+location);
        break;

      case 3:
        break;

      case 4: //ranged guardian
        println(bulletAmmo);

        for (int _p = pomegranate.size()-1; _p >= 0; _p--) {
          ItemSpawn p = pomegranate.get(_p);
          float px = p.getLocation().x;
          float py = p.getLocation().y;

          float hypotenuse = distance_between_two_points(location.x, px, location.y, py);
          if (hypotenuse < 25) {
            bulletAmmo += p.getItemReward();
            pomegranate.remove(_p);
            break;
          }
        }

        bulletTimer += int(timeMillis-pMillis);
        if (bulletTimer > 125) {
          if (bulletAmmo > 0) {
            projectiles.add(new ProjectileWeapon(1, 0, location.x, location.y, moveTheta, true));
            bulletTimer = 0;
            bulletAmmo--;
          }
        }

        if (stingCooldown > 0) {
          stingCooldown -= int(timeMillis-pMillis);
          stingCooldown = constrain(stingCooldown, 0, 10000);
        }

        if (shootSting && bulletAmmo > 0) {
          if (mousePressed == false && confirmShoot == false) confirmShoot = true;

          float mouseDistanceToCancel = distance_between_two_points(width-160, mouseX, height-32.5, mouseY);
          if (mouseDistanceToCancel <= 35 && mousePressed) {
            confirmShoot = false;
            shootSting = false;
            stingCooldown = 10000;
            ignoreGTClick = true;
          } else if (confirmShoot && mousePressed) {
            float shootTheta = calcMoveTheta(mouseX, mouseY, location.x, location.y);
            for (float i = -radians(30); i <= radians(30); i+= radians(5)) {
              projectiles.add(new ProjectileWeapon(random(1) > 0.95 ? 0 : 1, 0, location.x, location.y, shootTheta+i, true));
              bulletAmmo--;
              if (bulletAmmo == 0) break;
            }
            //println(projectiles.size());
            shootSting = false;
            stingCooldown = 10000;
            ignoreGTClick = true;
          }
        }
        break;

      case 5: //bouncer guardian
        float shortestDistance = distance_between_two_points(0, width, 0, height); //set supposedly shortest distance to be the longest so that it is certain that there will be a shorter distance
        int closestHornetID = -1;

        for (int h = GTHornets.size ()-1; h >= 0; h--) {
          Hornet _hornet = GTHornets.get(h);

          float hx = _hornet.getLocation().x;
          float hy = _hornet.getLocation().y;
          float hypotenuse = distance_between_two_points(hx, location.x, hy, location.y);

          if (hypotenuse > guardianSenseArea[1]) continue;
          else {
            if (hypotenuse < shortestDistance) {
              shortestDistance = hypotenuse;
              closestHornetID = h;
            }
          }
        }

        if (closestHornetID != -1) {
          guardianTarget = "Hornet";

          Hornet h = GTHornets.get(closestHornetID);
          float hx = h.getLocation().x;
          float hy = h.getLocation().y;
          if (debug) {
            //display a blue line that represents which hornet is the guardian going for
            stroke(0, 0, 200, 100);
            strokeWeight(1);
            line(location.x, location.y, hx, hy);
          }

          float hypotenuse = distance_between_two_points(location.x, hx, location.y, hy);
          if (hypotenuse < 1.5) {
            GTHornets.remove(h);
          }
          moveTheta = calcMoveTheta(hx, hy, location.x, location.y);
        } else guardianTarget = "None"; //reset the target
        break;
      }
    }

    if (guardianTimeoutMove) {
      if (gameMillis - guardianMoveTimer > 8000) {
        guardianMoveTimer = gameMillis;
        moveTheta = radians(random(360)); //go in a random angle
      }
    }

    float maxX, minX, maxY, minY;
    if (demo) {
      minX = 220;
      maxX = 220+width/2;
      minY = 70;
      maxY = 70+height/1.75;
    } else {
      maxX = width;
      minX = 0;
      maxY = height;
      minY = 30;
    }
    if (roundOver == false) {
      if (location.x + radius >= maxX) {
        stuckFrames += 1;
        println(location.x, location.y);
        if (stuckFrames >= 30) {
          println("T. GUARDIAN: solved stuck RIGHT");
          location.x -= 3;
        }
      } else if (location.x - radius <= minX) {
        stuckFrames += 1;
        println(location.x, location.y);
        if (stuckFrames >= 30) {
          println("T. GUARDIAN: solved stuck LEFT");
          location.x += 3;
        }
      } else if (location.y + radius >= maxY) {
        stuckFrames += 1;
        println(location.x, location.y);
        if (stuckFrames >= 30) {
          println("T. GUARDIAN: solved stuck DOWN");
          location.y -= 3;
        }
      } else if (location.y - radius <= minY) {
        stuckFrames += 1;
        println(location.x, location.y);
        if (stuckFrames >= 30) {
          println("T. GUARDIAN: solved stuck UP");
          location.y += 3;
        }
      } else {
        stuckFrames = 0;
      }


      if (location.x + radius >= maxX || location.x - radius <= minX) {
        float thetaD = degrees(moveTheta);
        if (thetaD >= 0 && thetaD < 180) {
          thetaD = 180-thetaD;
        } else {
          thetaD = 180 + (360-thetaD);
        }
        moveTheta = radians(thetaD);
      }
      if (location.y + radius >= maxY || location.y - radius <= minY) {
        float thetaD = degrees(moveTheta);
        thetaD = 360-thetaD;
        moveTheta = radians(thetaD);
      }
    }

    float moveX = speed*cos(moveTheta);
    float moveY = -speed*sin(moveTheta);



    if (shouldGuardianMove) location = new PVector(location.x+moveX, location.y+moveY); //the actual moving code
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

  float getSpeed() {
    return speed;
  }

  int getStingCooldown() {
    return stingCooldown;
  }

  boolean getShootSting() {
    return shootSting;
  }
}