static final float[] hornetFlightSpeed = {1.25, 1.5/*, 2.8*/};

class Hornet {
  PVector location; 
  float radius = 5;
  float speed;
  float moveTheta = radians(random(360));
  boolean killFatigue = false; //5s
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
    strokeWeight(1.5);
    if (killFatigue) ellipse(location.x, location.y, radius*(6500-(gameMillis-lastKillMillis))/1500, radius*(6500-(gameMillis-lastKillMillis))/1500);
    else ellipse(location.x, location.y, radius, radius);
  }


  //logic ref in notebook, not implemented yet
  void move() {
    if (gameMillis - lastKillMillis < 5000) killFatigue = true;
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
      if (hypotenuse < (killFatigue || invincibleBees ? 0 : 1.5)) {
        lastKillMillis = gameMillis;
        bees.remove(b);
      }
      float _thetaRad = asin(abs(by - location.y) / hypotenuse);
      moveTheta = returnRealTheta(_thetaRad, detX, detY);
      //DETERMINE CLOSEST BEE <END>
    }

    float moveX =   (killFatigue ? 0.6 : 1) * speed*cos(moveTheta);
    float moveY = - (killFatigue ? 0.6 : 1) * speed*sin(moveTheta);

    location = new PVector(location.x+moveX, location.y+moveY); //the actual moving code
  }

  PVector getLocation() { 
    return location;
  }

  float getMoveTheta() {
    return moveTheta;
  }
}

long hornetTimer = 0;
void spawnHornet() {
  //refreshHornetSpawnRndVal();

  float factorX = bees.size() + guardians.size()*2 + flowers.size()*0.75 /*+ HSRV*/;
  if (forestType >= 6) {
    float nextHornetTime = (200/pow(factorX, 0.2)-77) *1000;
    if (nextHornetTime < 10000) nextHornetTime = 10000; //lower constrain
    println(bees.size(), guardians.size(), flowers.size(), factorX, "=", nextHornetTime);
    if (debug) {
      fill(0);
      textSize(12);
      textAlign(LEFT);
      text("Next hornet in: " + (int)((nextHornetTime+hornetTimer)-gameMillis), 20, height-36);
    }
    if (gameMillis - hornetTimer > nextHornetTime) {
      float enemyTypeDet = random(forestType);
      if (enemyTypeDet > 4) {
        fireflies.add(new Firefly(false));
        hornetTimer = gameMillis;
      } else {
        hornets.add(new Hornet(hornetFlightSpeed[(enemyTypeDet > 1 ? 1 : 0)]));
        hornetTimer = gameMillis;
      }
    }
  } else if (forestType == 5) {
    float nextHornetTime = (200/pow(factorX, 0.2)-77) *1000;
    if (nextHornetTime < 10000) nextHornetTime = 10000; //lower constrain
    println(bees.size(), guardians.size(), flowers.size(), factorX, "=", nextHornetTime);
    if (debug) {
      fill(0);
      textSize(12);
      textAlign(LEFT);
      text("Next hornet in: " + (int)((nextHornetTime+hornetTimer)-gameMillis), 20, height-36);
    }
    if (gameMillis - hornetTimer > nextHornetTime) {
      hornets.add(new Hornet(hornetFlightSpeed[(random(forestType) > 4 ? 1 : 0)]));
      hornetTimer = gameMillis;
    }
  } else if (forestType == 4) {
    float nextHornetTime = (200/pow(factorX, 0.2)-77) *1000;
    if (nextHornetTime < 10000) nextHornetTime = 10000; //lower constrain
    println(bees.size(), guardians.size(), flowers.size(), factorX, "=", nextHornetTime);
    if (debug) {
      fill(0);
      textSize(12);
      textAlign(LEFT);
      text("Next hornet in: " + (int)((nextHornetTime+hornetTimer)-gameMillis), 20, height-36);
    }
    if (gameMillis - hornetTimer > nextHornetTime) {
      hornets.add(new Hornet(hornetFlightSpeed[0]));
      hornetTimer = gameMillis;
    }
  } else if (forestType == 3) { // 1 hornet
    float nextHornetTime = ROUND_TIME/2 + random(ROUND_TIME/2);
    if (debug) {
      fill(0);
      textSize(12);
      textAlign(LEFT);
      text("Next hornet in: " + (int)((nextHornetTime+hornetTimer)-gameMillis), 20, height-36);
    }
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



class Firefly {
  PVector location; 
  float radius = 6;
  float speed = 1.6;
  float moveTheta = radians(random(360));
  boolean forTraining = false;
  PGraphics pg;
  boolean killFatigue = false; //5s
  long fireflyMoveTimer = 0;
  int fireflyTap = 2;
  boolean targetable = false;
  long lastKillMillis;
  int stuckFrames = 0;

  Firefly(boolean _ft) {
    forTraining = _ft;

    if (random(1) > 0.5) {
      location = new PVector(random(width), random(1) > 0.5 ? 30 : height-30);
    } else {
      location = new PVector(random(1) > 0.5 ? 0 : width, random(height));
    }
  } 

  void minusFireflyTap() {
    if (fireflyTap != 0) fireflyTap--;
  }

  void updateFireflyMoveTimer(long _t) {
    fireflyMoveTimer = _t;
  }

  void showFirefly() {
    float glowValue = abs(sin(radians(gameMillis/7))); // divide more = slower (lower frequency)
    pg = createGraphics((int)radius*4, (int)radius*4);
    //white glow outline
    pg.beginDraw();
    pg.smooth();
    pg.background(255, 0);
    pg.noStroke();
    if (killFatigue) pg.fill(255, 220, 220);
    else pg.fill(255);
    pg.ellipse(radius*2, radius*2, map(glowValue, 0, 1, 60/6-3, 60/6), map(glowValue, 0, 1, 60/6-3, 60/6));
    pg.filter(BLUR, 12/6);
    pg.endDraw();
    image(pg, location.x-radius*2, location.y-radius*2);
    //green thin line
    pg.beginDraw();
    if (killFatigue) pg.fill(209, 86, 55);
    else pg.fill(173, 209, 53);
    pg.ellipse(radius*2, radius*2, map(glowValue, 0, 1, 62/6-3, 62/6), map(glowValue, 0, 1, 62/6-3, 62/6));
    pg.filter(BLUR, 2/6);
    pg.endDraw();
    image(pg, location.x-radius*2, location.y-radius*2);
    //green light (minor glow)
    pg.beginDraw();
    if (killFatigue) pg.fill(240, 40, 0);
    else pg.fill(219, 241, 0);
    pg.ellipse(radius*2, radius*2, map(glowValue, 0, 1, 55/6-3, 55/6), map(glowValue, 0, 1, 55/6-3, 55/6));
    pg.filter(BLUR, 4/6);
    pg.endDraw();
    image(pg, location.x-radius*2, location.y-radius*2);
    //main yellow light glow
    pg.beginDraw();
    if (killFatigue) pg.fill(252, 184, 82);
    else pg.fill(254, 252, 80);
    pg.ellipse(radius*2, radius*2, map(glowValue, 0, 1, 50/6-3, 50/6), map(glowValue, 0, 1, 50/6-3, 50/6));
    pg.filter(BLUR, 4/6);
    pg.endDraw();
    image(pg, location.x-radius*2, location.y-radius*2);
    //center white shine
    pg.beginDraw();
    pg.fill(255);
    pg.ellipse(radius*2, radius*2, map(glowValue, 0, 1, 0, 12/6), map(glowValue, 0, 1, 0, 12/6));
    pg.filter(BLUR, 4/6);
    pg.endDraw();
    image(pg, location.x-radius*2, location.y-radius*2);

    if (forTraining) {
      if (targetable) {
        fill(100);
        textSize(10);
        textAlign(CENTER);
        text("Targetable", location.x, location.y-15);
      } else {
        //text(fireflyTap + (fireflyTap > 1 ? " taps" : " tap"), location.x, location.y-15);
        strokeWeight(1);
        stroke(100);
        noFill();
        rect(location.x-20, location.y-25, 40, 10); //the "frame" of the hp bar
        if (fireflyTap > 1) fill(100, 255, 100);
        else fill(255, 100, 100);
        noStroke();
        rect(location.x-19.5, location.y-24.5, map(fireflyTap, 1, 2, 39/2, 39), 9);
        println(fireflyTap);
      }
    }
  }

  void move() {
    if (forTraining == false) {
      if (gameMillis - lastKillMillis < 5000) killFatigue = true;
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
        if (hypotenuse < (killFatigue || invincibleBees ? 0 : 1.5)) {
          lastKillMillis = gameMillis;
          bees.remove(b);
        }
        float _thetaRad = asin(abs(by - location.y) / hypotenuse);
        moveTheta = returnRealTheta(_thetaRad, detX, detY);
        //DETERMINE CLOSEST BEE <END>

        for (Guardian g : guardians) {
          float gx = g.getLocation().x;
          float gy = g.getLocation().y;
          float gHypotenuse = distance_between_two_points(gx, location.x, gy, location.y);
          if (g.getGuardianName().equals(guardianName[0]) == false && g.getGuardianName().equals(guardianName[1]) == false && gHypotenuse < 30) {
            moveTheta = g.getMoveTheta() + (random(1) > 0.5 ? 1 : -1) * radians(random(30)); //still radians
          }
        }
      }
    } else { //forTraining = true
      if (fireflyTap == 0) targetable = true;
      if (gameMillis - fireflyMoveTimer > 6000) {
        if (fireflyTap < 2 && targetable == false) fireflyTap++;
        fireflyMoveTimer = gameMillis;
        moveTheta = radians(random(360)); //go in a random angle
      }

      float gx = trainingGuardian.getLocation().x;
      float gy = trainingGuardian.getLocation().y;
      float gHypotenuse = distance_between_two_points(gx, location.x, gy, location.y);
      if (gHypotenuse < 50) {
        fireflyMoveTimer = gameMillis;
        //moveTheta = trainingGuardian.getMoveTheta() + radians(random(30)); //still radians
      }
    }



    if (roundOver == false) {
      if (location.x + radius >= width) {
        stuckFrames += 1;
        println(location.x, location.y);
        if (stuckFrames >= 30) {
          if (forTraining) println("T. FIREFLY: solved stuck RIGHT");
          else println("FIREFLY: solved stuck RIGHT");
          location.x -= 3;
        }
      } else if (location.x - radius <= 0) {
        stuckFrames += 1;
        println(location.x, location.y);
        if (stuckFrames >= 30) {
          if (forTraining) println("T. FIREFLY: solved stuck LEFT");
          else println("FIREFLY: solved stuck LEFT");
          location.x += 3;
        }
      } else if (location.y + radius >= (forTraining ? height : height-40)) {
        stuckFrames += 1;
        println(location.x, location.y);
        if (stuckFrames >= 30) {
          if (forTraining) println("T. FIREFLY: solved stuck DOWN");
          else println("FIREFLY: solved stuck DOWN");
          location.y -= 3;
        }
      } else if (location.y - radius <= 30) {
        stuckFrames += 1;
        println(location.x, location.y);
        if (stuckFrames >= 30) {
          if (forTraining) println("T. FIREFLY: solved stuck UP");
          else println("FIREFLY: solved stuck UP");
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
      if (location.y + radius >= (forTraining ? height : height-40) || location.y - radius <= 30) {
        float thetaD = degrees(moveTheta);
        thetaD = 360-thetaD;
        moveTheta = radians(thetaD);
      }
    }

    float moveX =   (killFatigue ? 0.7 : 1) * speed*cos(moveTheta);
    float moveY = - (killFatigue ? 0.7 : 1) * speed*sin(moveTheta);

    location = new PVector(location.x+moveX, location.y+moveY); //the actual moving code
  }

  int getFireflyTap() {
    return fireflyTap;
  }

  PVector getLocation() { 
    return location;
  }

  float getMoveTheta() {
    return moveTheta;
  }
}