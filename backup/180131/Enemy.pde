static final float[] hornetFlightSpeed = {1.25, 1.5/*, 2.8*/}; //<>//

class Hornet {
  int hornetType = -1;

  PVector location; 
  float radius = 5;
  float speed;
  float moveTheta = radians(random(360));
  boolean killFatigue = false; //5s
  long lastKillMillis;
  int stuckFrames = 0;

  boolean forTraining = false;
  int hornetHp = 1;
  int revealTimer = (int)random(6)*1000;

  boolean demo = false, shouldMove = true;

  Hornet(int _hornetType, boolean _ft) {
    hornetType = _hornetType;
    forTraining = _ft;
    speed = hornetFlightSpeed[_hornetType];

    if (random(1) > 0.5) {
      location = new PVector(2+random(width-4), random(1) > 0.5 ? 25+2 : height-40-2);
    } else {
      location = new PVector(random(1) > 0.5 ? 2 : width-2, 2+random(height-4));
    }

    if (forTraining) {
      if (GTSelected == 4) { //ranged guardian
        hornetHp = (hornetType+1)*4;
      }
    }
  } 

  void updateIsDemo(boolean _d) {
    demo = _d;
  }

  void updateShouldMove(boolean _sm) {
    shouldMove = _sm;
  }

  void updateSpeed(float _s) {
    speed = _s;
  }

  void resetSpeed() {
    speed = hornetFlightSpeed[hornetType];
  }

  void minusHornetHp() {
    if (hornetHp != 0) hornetHp--;
  }

  void updateHornetHp(int _hp) {
    hornetHp = _hp;
  }

  void updateLocation(float x, float y) {
    location = new PVector(x, y);
  }

  void updateMoveTheta(float _mt) {
    moveTheta = _mt;
  }

  void showHornet() {
    if (hornetType == 0) fill(255, 137, 137);
    else if (hornetType == 1) fill(193, 59, 59);
    else if (hornetType == 2) fill(152, 0, 0);
    stroke(0); 
    strokeWeight(1.5);
    if (killFatigue) {
      if (demo) ellipse(location.x, location.y, radius*(6500-(millis()-lastKillMillis))/1500, radius*(6500-(millis()-lastKillMillis))/1500);
      else ellipse(location.x, location.y, radius*(6500-(gameMillis-lastKillMillis))/1500, radius*(6500-(gameMillis-lastKillMillis))/1500);
    } else ellipse(location.x, location.y, radius, radius);

    if (forTraining) {
      if (GTSelected == 4) { //ranged guardian
        rectMode(CORNER);
        strokeWeight(1);
        stroke(100);
        noFill();
        rect(location.x-20, location.y-25, 40, 8); //the "frame" of the hp bar
        fill((hornetHp >= 4*(hornetType+1)/2 ? map(hornetHp-(4*(hornetType+1))/2, 0, (4*(hornetType+1))/2, cos(0), cos(HALF_PI)) : 1)*255, map(hornetHp, 0, (4*(hornetType+1))/2, sin(0), sin(HALF_PI))*255, 0); //R & G is the sin & cos relationship
        noStroke();
        rect(location.x-19.5, location.y-24.5, map(hornetHp, 0, 4*(hornetType+1), 0, 39), 7);
      }
    }
  }


  //logic ref in notebook, not implemented yet
  void move() {
    speed = hornetFlightSpeed[hornetType] * (60/frameRate); //speed correction

    if (forTraining == false) {
      if (gameMillis - lastKillMillis < 5000) killFatigue = true;
      else killFatigue = false;

      //DETERMINE CLOSEST BEE <START>
      float shortestDistance = distance_between_two_points(0, width, 0, height); //set supposedly shortest distance to be the longest so that it is certain that there will be a shorter distance
      int closestBeeID = -1;
      for (int b = bees.size ()-1; b >= 0; b--) {
        Bee _bee = bees.get(b);

        if (_bee.getIsAlive() == false) continue;

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
        if (hypotenuse < (killFatigue || invincibleBees ? 0 : 1.5) && b.getDiameter() == BEE_DIAMETER) {
          lastKillMillis = gameMillis;
          b.updateIsAlive(false);
          //bees.remove(b);
        }
        float _thetaRad = asin(abs(by - location.y) / hypotenuse);
        moveTheta = returnRealTheta(_thetaRad, detX, detY);
        //DETERMINE CLOSEST BEE <END>
      }
    } else { //forTraining == true
      if (demo && millis() - lastKillMillis < 5000) killFatigue = true;
      else if (demo == false && gameMillis - lastKillMillis < 5000) killFatigue = true;
      else killFatigue = false;

      //DETERMINE CLOSEST BEE <START>
      float shortestDistance = distance_between_two_points(0, width, 0, height); //set supposedly shortest distance to be the longest so that it is certain that there will be a shorter distance
      int closestBeeID = -1;
      for (int b = GTBees.size ()-1; b >= 0; b--) {
        Bee _bee = GTBees.get(b);

        float bx = _bee.getLocation().x;
        float by = _bee.getLocation().y;

        float hypotenuse = distance_between_two_points(location.x, bx, location.y, by);

        if (hypotenuse < shortestDistance) {
          shortestDistance = hypotenuse;
          closestBeeID = b;
        }
      }

      if (closestBeeID != -1) {
        Bee b = GTBees.get(closestBeeID);
        float bx = b.getLocation().x;
        float by = b.getLocation().y;
        if (debug) { //display a red line that represents which bee is the hornet going for
          stroke(200, 0, 0, 100);
          strokeWeight(1);
          line(location.x, location.y, bx, by);
        }

        float detX = bx - location.x;
        float detY = by - location.y;
        float hypotenuse = distance_between_two_points(location.x, bx, location.y, by);
        if (hypotenuse < (killFatigue || invincibleBees ? 0 : 1.5)) {
          lastKillMillis = gameMillis;
          GTBees.remove(b);
        }
        float _thetaRad = asin(abs(by - location.y) / hypotenuse);
        moveTheta = returnRealTheta(_thetaRad, detX, detY);
        //DETERMINE CLOSEST BEE <END>
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
      if (forTraining) maxY = height;
      else maxY = height-40;
      minY = 30;
    }
    if (roundOver == false && forTraining) {
      if (location.x + radius >= maxX) {
        stuckFrames += 1;
        println(location.x, location.y);
        if (stuckFrames >= 30) {
          println("T. HORNET: solved stuck RIGHT");
          location.x -= 3;
        }
      } else if (location.x - radius <= minX) {
        stuckFrames += 1;
        println(location.x, location.y);
        if (stuckFrames >= 30) {
          println("T. HORNET: solved stuck LEFT");
          location.x += 3;
        }
      } else if (location.y + radius >= maxY) {
        stuckFrames += 1;
        println(location.x, location.y);
        if (stuckFrames >= 30) {
          println("T. HORNET: solved stuck DOWN");
          location.y -= 3;
        }
      } else if (location.y - radius <= minY) {
        stuckFrames += 1;
        println(location.x, location.y);
        if (stuckFrames >= 30) {
          println("T. HORNET: solved stuck UP");
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

    float moveX =   (killFatigue ? 0.6 : 1) * speed*cos(moveTheta);
    float moveY = - (killFatigue ? 0.6 : 1) * speed*sin(moveTheta);

    if (shouldMove) location = new PVector(location.x+moveX, location.y+moveY); //the actual moving code
  }

  int getHornetHp() {
    return hornetHp;
  }

  PVector getLocation() { 
    return location;
  }

  float getMoveTheta() {
    return moveTheta;
  }

  int getHornetType() {
    return hornetType;
  }
}

long hornetTimer = 0;
void spawnHornet() {
  //refreshHornetSpawnRndVal();

  float factorX = bees.size() + guardians.size()*2 + flowers.size()*0.75 /*+ HSRV*/;
  if (forestType >= 6) {
    float nextHornetTime = (200/pow(factorX, 0.2)-77) *1000;
    if (nextHornetTime < 10000) nextHornetTime = 10000; //lower constrain
    if (debug) {
      println(bees.size(), guardians.size(), flowers.size(), factorX, "=", nextHornetTime);

      fill(0);
      textSize(12);
      textAlign(LEFT);
      text("Next enemy in: " + (int)((nextHornetTime+hornetTimer)-gameMillis), 20, height-36);
    }
    if (gameMillis - hornetTimer > nextHornetTime) {
      float enemyTypeDet = random(forestType);
      if (enemyTypeDet > 4) {
        fireflies.add(new Firefly(false));
        hornetTimer = gameMillis;
      } else {
        hornets.add(new Hornet(enemyTypeDet > 1 ? 1 : 0, false));
        hornetTimer = gameMillis;
      }
    }
  } else if (forestType == 5) {
    float nextHornetTime = (200/pow(factorX, 0.2)-77) *1000;
    if (nextHornetTime < 10000) nextHornetTime = 10000; //lower constrain
    if (debug) {
      println(bees.size(), guardians.size(), flowers.size(), factorX, "=", nextHornetTime);

      fill(0);
      textSize(12);
      textAlign(LEFT);
      text("Next hornet in: " + (int)((nextHornetTime+hornetTimer)-gameMillis), 20, height-36);
    }
    if (gameMillis - hornetTimer > nextHornetTime) {
      hornets.add(new Hornet(random(forestType) > 4 ? 1 : 0, false));
      hornetTimer = gameMillis;
    }
  } else if (forestType == 4) {
    float nextHornetTime = (200/pow(factorX, 0.2)-77) *1000;
    if (nextHornetTime < 10000) nextHornetTime = 10000; //lower constrain
    if (debug) {
      println(bees.size(), guardians.size(), flowers.size(), factorX, "=", nextHornetTime);

      fill(0);
      textSize(12);
      textAlign(LEFT);
      text("Next hornet in: " + (int)((nextHornetTime+hornetTimer)-gameMillis), 20, height-36);
    }
    if (gameMillis - hornetTimer > nextHornetTime) {
      hornets.add(new Hornet(0, false));
      hornetTimer = gameMillis;
    }
  } else if (forestType == 3) { // 1 hornet
    float nextHornetTime = ROUND_TIME/2 + forest3Hornet;
    if (debug) {
      fill(0);
      textSize(12);
      textAlign(LEFT);
      text("Next hornet in: " + (int)((nextHornetTime+hornetTimer)-gameMillis), 20, height-36);
    }
    if (gameMillis - hornetTimer > nextHornetTime) {
      hornets.add(new Hornet(0, false));
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
  int fireflyHp = 2;
  boolean targetable = false;
  long lastKillMillis;
  int stuckFrames = 0;

  boolean demo = false;

  Firefly(boolean _ft) {
    forTraining = _ft;

    if (random(1) > 0.5) {
      location = new PVector(2+random(width-4), random(1) > 0.5 ? 25+2 : height-40-2);
    } else {
      location = new PVector(random(1) > 0.5 ? 2 : width-2, 2+random(height-4));
    }

    if (forTraining) {
      if (GTSelected == 0) { //royal guardian
        fireflyHp = 2;
      } else if (GTSelected == 4) { //ranged guardian
        fireflyHp = 10;
      }
    }
  } 

  void updateIsDemo(boolean _d) {
    demo = _d;
    location = new PVector(width/2, height/2);
  }

  void updateSpeed(float _s) {
    speed = _s;
  }

  void resetSpeed() {
    speed = 1.6;
  }

  void minusFireflyHp() {
    if (fireflyHp != 0) fireflyHp--;
  }

  void updateFireflyHp(int _hp) {
    fireflyHp = _hp;
  }

  void updateFireflyMoveTimer(long _t) {
    fireflyMoveTimer = _t;
  }

  void showFirefly() {
    imageMode(CORNER);
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
      if (GTSelected == 0) {
        if (targetable) {
          fill(100);
          textSize(10);
          textAlign(CENTER);
          text("Targetable", location.x, location.y-15);
        } else {
          rectMode(CORNER);
          //text(fireflyHp + (fireflyHp > 1 ? " taps" : " tap"), location.x, location.y-15);
          strokeWeight(1);
          stroke(100);
          noFill();
          rect(location.x-20, location.y-25, 40, 8); //the "frame" of the hp bar
          if (fireflyHp > 1) fill(100, 255, 100);
          else fill(255, 100, 100);
          noStroke();
          rect(location.x-19.5, location.y-24.5, map(fireflyHp, 1, 2, 39/2, 39), 7);
          //println(fireflyHp);
        }
      } else if (GTSelected == 4) { //ranged guardian
        rectMode(CORNER);

        strokeWeight(1);
        stroke(100);
        noFill();
        rect(location.x-20, location.y-25, 40, 8); //the "frame" of the hp bar
        fill((fireflyHp >= 10/2 ? map(fireflyHp-10/2, 0, 10/2, cos(0), cos(HALF_PI)) : 1)*255, map(fireflyHp, 0, 10/2, sin(0), sin(HALF_PI))*255, 0); //R & G is the sin & cos relationship
        noStroke();
        rect(location.x-19.5, location.y-24.5, map(fireflyHp, 0, 10, 0, 39), 7);
      }
    }
  }

  void move() {
    speed = 1.6 * (60/frameRate); //speed correction

    if (forTraining == false) {
      if (gameMillis - lastKillMillis < 5000) killFatigue = true;
      else killFatigue = false;

      //DETERMINE CLOSEST BEE <START>
      float shortestDistance = distance_between_two_points(0, width, 0, height); //set supposedly shortest distance to be the longest so that it is certain that there will be a shorter distance
      int closestBeeID = -1;
      for (int b = bees.size ()-1; b >= 0; b--) {
        Bee _bee = bees.get(b);

        if (_bee.getIsAlive() == false) continue;

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
        if (hypotenuse < (killFatigue || invincibleBees ? 0 : 1.5) && b.getDiameter() == BEE_DIAMETER) {
          lastKillMillis = gameMillis;
          b.updateIsAlive(false);
          //bees.remove(b);
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
      if (demo) { //GTdemo
        if (fireflyHp == 0) targetable = true;
        if (millis() - fireflyMoveTimer > 6000) {
          if (fireflyHp < 2 && targetable == false && GTSelected == 0) fireflyHp++;
          fireflyMoveTimer = millis();
          moveTheta = radians(random(360)); //go in a random angle
        }
        float gx, gy;
        gx = demoTrainingGuardian.getLocation().x;
        gy = demoTrainingGuardian.getLocation().y;

        float gHypotenuse = distance_between_two_points(gx, location.x, gy, location.y);
        if (gHypotenuse < 50) {
          fireflyMoveTimer = millis();
          //moveTheta = trainingGuardian.getMoveTheta() + radians(random(30)); //still radians
        }
      } else { //real training
        if (fireflyHp == 0) targetable = true;
        if (gameMillis - fireflyMoveTimer > 6000) {
          if (fireflyHp < 2 && targetable == false && GTSelected == 0) fireflyHp++;
          fireflyMoveTimer = gameMillis;
          moveTheta = radians(random(360)); //go in a random angle
        }
        float gx, gy;
        gx = trainingGuardian.getLocation().x;
        gy = trainingGuardian.getLocation().y;

        float gHypotenuse = distance_between_two_points(gx, location.x, gy, location.y);
        if (gHypotenuse < 50) {
          fireflyMoveTimer = gameMillis;
          //moveTheta = trainingGuardian.getMoveTheta() + radians(random(30)); //still radians
        }
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

      float maxX, minX, maxY, minY;
      if (demo) {
        minX = 220;
        maxX = 220+width/2;
        minY = 70;
        maxY = 70+height/1.75;
      } else {
        maxX = width;
        minX = 0;
        if (forTraining) maxY = height;
        else maxY = height-40;
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

    float moveX =   (killFatigue ? 0.7 : 1) * speed*cos(moveTheta);
    float moveY = - (killFatigue ? 0.7 : 1) * speed*sin(moveTheta);

    location = new PVector(location.x+moveX, location.y+moveY); //the actual moving code
  }

  int getFireflyHp() {
    return fireflyHp;
  }

  PVector getLocation() { 
    return location;
  }

  float getMoveTheta() {
    return moveTheta;
  }
}

PImage ladybug;
class Ladybug {
  PVector location; 
  float diameter = 15;
  float radius = diameter/2;
  float speed = 1.6;
  float moveTheta = radians(random(360));
  boolean forTraining = false;
  long ladybugMoveTimer = 0;
  int stuckFrames = 0;

  int revealTimer = (int)random(1.5, 5)*1000;
  int disguiseType;
  boolean selectedStatus = false;

  Ladybug(boolean _ft) {
    forTraining = _ft;

    if (random(1) > 0.5) {
      location = new PVector(2+random(width-4), random(1) > 0.5 ? 25+2 : height-40-2);
    } else {
      location = new PVector(random(1) > 0.5 ? 2 : width-2, 2+random(height-4));
    }

    if (forTraining && GTSelected == 5) { //bouncer
      disguiseType = (int)random(3); //0~3
      speed = beeFlightSpeed[disguiseType];
    }
  } 

  void updateSpeed(float _s) {
    speed = _s;
  }

  void resetSpeed() {
    speed = 1.6;
  }

  void updateLocation(float x, float y) {
    location = new PVector(x, y);
  }

  void updateLadybugMoveTimer(long _t) {
    ladybugMoveTimer = _t;
  }

  void updateMoveTheta(float _theta) {
    moveTheta = _theta;
  }

  void updateSelectedStatus(boolean _s) {
    selectedStatus = _s;
  }

  void updateRevealTimer(int _rt) {
    revealTimer = _rt;
  }

  void showLadybug() {
    if (GTSelected != 5) { //if not bouncer guardian (no need to disguise)
      pushMatrix();
      translate(location.x, location.y);
      rotate(-moveTheta);

      imageMode(CENTER);
      image(ladybug, 0, 0, diameter, diameter*(490/351));
      popMatrix();
    } else {
      if (GTHornets.size() == 0) revealTimer = constrain(revealTimer - int(timeMillis-pMillis), -150, 6000);

      if ((revealTimer <= 0 && revealTimer > -150)/*|| GTHornets.size() > 0*/) {        
        pushMatrix();
        translate(location.x, location.y);
        rotate(-moveTheta);

        imageMode(CENTER);
        image(ladybug, 0, 0, diameter, diameter*(490/351));
        popMatrix();
      } else {
        radius = BEE_DIAMETER /2; 

        for (int i = 0; i < beeFlightSpeed.length; i++) {
          fill(beeColour[disguiseType]);
        }    
        stroke(0); 
        strokeWeight(2); 

        //body
        pushMatrix();
        translate(location.x, location.y);
        rotate(-moveTheta);
        line(0, 0, -BEE_DIAMETER*1.7/2, 0); //sting of the bee
        ellipse(0, 0, BEE_DIAMETER*1.5, BEE_DIAMETER);

        //"zebra lines" on body (Body Pattern. Upgraded bees have special patterns)
        noStroke();
        fill(0);
        switch (disguiseType) {
        case 0:
        case 3:
          // *** center bar line ***
          beginShape();
          arc(0, 0, BEE_DIAMETER*1.5, BEE_DIAMETER, HALF_PI*3-radians(15), HALF_PI*3+radians(5));
          arc(0, 0, BEE_DIAMETER*1.5, BEE_DIAMETER, HALF_PI-radians(5), HALF_PI+radians(15));
          endShape();
          rect(-radius*1.5*cos(radians(75)), -radius*sin(radians(75)), radius*1.5*cos(radians(75)) *1.35, radius*sin(radians(75)) *2);

          // *** offset bar line(s) ***
          //     *** MOST LEFT ***
          arc(0, 0, BEE_DIAMETER*1.5, BEE_DIAMETER, radians(115), radians(135), CHORD);
          beginShape();
          vertex(-1.5*radius*cos(radians(45)), radius*sin(radians(45)));
          vertex(-1.5*radius*cos(radians(65)), radius*sin(radians(65)));
          vertex(-1.5*radius*cos(radians(65)), radius*sin(radians(45)));
          endShape();
          arc(0, 0, BEE_DIAMETER*1.5, BEE_DIAMETER, radians(180+45), radians(180+65), CHORD);
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
          arc(0, 0, BEE_DIAMETER*1.5, BEE_DIAMETER, radians(a), radians(b), CHORD);
          beginShape();
          vertex(-1.5*radius*cos(radians(180-b)), radius*sin(radians(180-b)));
          vertex(-1.5*radius*cos(radians(180-a)), radius*sin(radians(180-a)));
          vertex(-1.5*radius*cos(radians(180-a)), radius*sin(radians(180-b)));
          endShape();
          arc(0, 0, BEE_DIAMETER*1.5, BEE_DIAMETER, radians(180+180-b), radians(180+180-a), CHORD);
          beginShape();
          vertex(-1.5*radius*cos(radians(180-b)), -radius*sin(radians(180-b)));
          vertex(-1.5*radius*cos(radians(180-a)), -radius*sin(radians(180-a)));
          vertex(-1.5*radius*cos(radians(180-a)), -radius*sin(radians(180-b)));
          endShape();
          rect(-1.5*radius*cos(radians(180-b)), -radius*sin(radians(180-b)), 1.5*radius*cos(radians(180-b))-1.5*radius*cos(radians(180-a)), 2*radius*sin(radians(180-b)));

          //    *** CENTER ***
          a = 95;
          b = 110;
          arc(0, 0, BEE_DIAMETER*1.5, BEE_DIAMETER, radians(a), radians(b), CHORD);
          beginShape();
          vertex(-1.5*radius*cos(radians(180-b)), radius*sin(radians(180-b)));
          vertex(-1.5*radius*cos(radians(180-a)), radius*sin(radians(180-a)));
          vertex(-1.5*radius*cos(radians(180-a)), radius*sin(radians(180-b)));
          endShape();
          arc(0, 0, BEE_DIAMETER*1.5, BEE_DIAMETER, radians(180+180-b), radians(180+180-a), CHORD);
          beginShape();
          vertex(-1.5*radius*cos(radians(180-b)), -radius*sin(radians(180-b)));
          vertex(-1.5*radius*cos(radians(180-a)), -radius*sin(radians(180-a)));
          vertex(-1.5*radius*cos(radians(180-a)), -radius*sin(radians(180-b)));
          endShape();
          rect(-1.5*radius*cos(radians(180-b)), -radius*sin(radians(180-b)), 1.5*radius*cos(radians(180-b))-1.5*radius*cos(radians(180-a)), 2*radius*sin(radians(180-b)));

          //    ** RIGHT **
          a = 75;
          b = 85;
          arc(0, 0, BEE_DIAMETER*1.5, BEE_DIAMETER, radians(a), radians(b), CHORD);
          beginShape();
          vertex(1.5*radius*cos(radians(a)), radius*sin(radians(a)));
          vertex(1.5*radius*cos(radians(b)), radius*sin(radians(b)));
          vertex(1.5*radius*cos(radians(b)), radius*sin(radians(a)));
          endShape();
          arc(0, 0, BEE_DIAMETER*1.5, BEE_DIAMETER, radians(180+180-b), radians(180+180-a), CHORD);
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
          arc(0, 0, BEE_DIAMETER*1.5, BEE_DIAMETER, radians(a), radians(b), CHORD);
          beginShape();
          vertex(-1.5*radius*cos(radians(180-b)), radius*sin(radians(180-b)));
          vertex(-1.5*radius*cos(radians(180-a)), radius*sin(radians(180-a)));
          vertex(-1.5*radius*cos(radians(180-a)), radius*sin(radians(180-b)));
          endShape();
          arc(0, 0, BEE_DIAMETER*1.5, BEE_DIAMETER, radians(180+180-b), radians(180+180-a), CHORD);
          beginShape();
          vertex(-1.5*radius*cos(radians(180-b)), -radius*sin(radians(180-b)));
          vertex(-1.5*radius*cos(radians(180-a)), -radius*sin(radians(180-a)));
          vertex(-1.5*radius*cos(radians(180-a)), -radius*sin(radians(180-b)));
          endShape();
          rect(-1.5*radius*cos(radians(180-b)), -radius*sin(radians(180-b)), 1.5*radius*cos(radians(180-b))-1.5*radius*cos(radians(180-a)), 2*radius*sin(radians(180-b)));

          //    *** LEFT ***
          a = 111;
          b = 119;
          arc(0, 0, BEE_DIAMETER*1.5, BEE_DIAMETER, radians(a), radians(b), CHORD);
          beginShape();
          vertex(-1.5*radius*cos(radians(180-b)), radius*sin(radians(180-b)));
          vertex(-1.5*radius*cos(radians(180-a)), radius*sin(radians(180-a)));
          vertex(-1.5*radius*cos(radians(180-a)), radius*sin(radians(180-b)));
          endShape();
          arc(0, 0, BEE_DIAMETER*1.5, BEE_DIAMETER, radians(180+180-b), radians(180+180-a), CHORD);
          beginShape();
          vertex(-1.5*radius*cos(radians(180-b)), -radius*sin(radians(180-b)));
          vertex(-1.5*radius*cos(radians(180-a)), -radius*sin(radians(180-a)));
          vertex(-1.5*radius*cos(radians(180-a)), -radius*sin(radians(180-b)));
          endShape();
          rect(-1.5*radius*cos(radians(180-b)), -radius*sin(radians(180-b)), 1.5*radius*cos(radians(180-b))-1.5*radius*cos(radians(180-a)), 2*radius*sin(radians(180-b)));

          //    ** RIGHT **
          a = 95;
          b = 103;
          arc(0, 0, BEE_DIAMETER*1.5, BEE_DIAMETER, radians(a), radians(b), CHORD);
          beginShape();
          vertex(-1.5*radius*cos(radians(180-b)), radius*sin(radians(180-b)));
          vertex(-1.5*radius*cos(radians(180-a)), radius*sin(radians(180-a)));
          vertex(-1.5*radius*cos(radians(180-a)), radius*sin(radians(180-b)));
          endShape();
          arc(0, 0, BEE_DIAMETER*1.5, BEE_DIAMETER, radians(180+180-b), radians(180+180-a), CHORD);
          beginShape();
          vertex(-1.5*radius*cos(radians(180-b)), -radius*sin(radians(180-b)));
          vertex(-1.5*radius*cos(radians(180-a)), -radius*sin(radians(180-a)));
          vertex(-1.5*radius*cos(radians(180-a)), -radius*sin(radians(180-b)));
          endShape();
          rect(-1.5*radius*cos(radians(180-b)), -radius*sin(radians(180-b)), 1.5*radius*cos(radians(180-b))-1.5*radius*cos(radians(180-a)), 2*radius*sin(radians(180-b)));

          //    ** MOST RIGHT **
          a = 79;
          b = 87;
          arc(0, 0, BEE_DIAMETER*1.5, BEE_DIAMETER, radians(a), radians(b), CHORD);
          beginShape();
          vertex(1.5*radius*cos(radians(a)), radius*sin(radians(a)));
          vertex(1.5*radius*cos(radians(b)), radius*sin(radians(b)));
          vertex(1.5*radius*cos(radians(b)), radius*sin(radians(a)));
          endShape();
          arc(0, 0, BEE_DIAMETER*1.5, BEE_DIAMETER, radians(180+180-b), radians(180+180-a), CHORD);
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
        ellipse(BEE_DIAMETER*0.65, BEE_DIAMETER*0.35, BEE_DIAMETER*0.65, BEE_DIAMETER*0.65);
        ellipse(BEE_DIAMETER*0.65, -BEE_DIAMETER*0.35, BEE_DIAMETER*0.65, BEE_DIAMETER*0.65);

        //eyeballs (black)
        noStroke();
        fill(50);
        ellipse(BEE_DIAMETER*0.65, BEE_DIAMETER*0.35, BEE_DIAMETER*0.25, BEE_DIAMETER*0.25);
        ellipse(BEE_DIAMETER*0.65, -BEE_DIAMETER*0.35, BEE_DIAMETER*0.25, BEE_DIAMETER*0.25);

        //bigger wings
        fill(200, 200, 200, 150);
        pushMatrix();
        translate(0, BEE_DIAMETER*1);
        rotate(radians(60));
        ellipse(0, 0, BEE_DIAMETER*1.5, BEE_DIAMETER);
        popMatrix();
        pushMatrix();
        translate(0, -BEE_DIAMETER*1);
        rotate(-radians(60));
        ellipse(0, 0, BEE_DIAMETER*1.5, BEE_DIAMETER);
        popMatrix();

        //smaller wings
        pushMatrix();
        translate(-5, BEE_DIAMETER*0.8);
        rotate(radians(50));
        ellipse(0, 0, BEE_DIAMETER*1.2, BEE_DIAMETER);
        popMatrix();
        pushMatrix();
        translate(-5, -BEE_DIAMETER*0.8);
        rotate(-radians(50));
        ellipse(0, 0, BEE_DIAMETER*1.2, BEE_DIAMETER);
        popMatrix();



        popMatrix();




        if (selectedStatus) {
          fill(255, 0, 0);
          textSize(12);
          textAlign(CENTER);
          text("Ready to move!", location.x, location.y+25);
        }
      }
    }
  }

  void move() {
    speed = beeFlightSpeed[disguiseType] * (60/frameRate); //speed correction

    radius = diameter /2;
    if (forTraining == false) {
    } else { //forTraining = true
    }



    if (roundOver == false) {
      if (location.x + radius >= width) {
        stuckFrames += 1;
        println(location.x, location.y);
        if (stuckFrames >= 30) {
          if (forTraining) println("T. LADYBUG: solved stuck RIGHT");
          else println("LADYBUG: solved stuck RIGHT");
          location.x -= 3;
        }
      } else if (location.x - radius <= 0) {
        stuckFrames += 1;
        println(location.x, location.y);
        if (stuckFrames >= 30) {
          if (forTraining) println("T. LADYBUG: solved stuck LEFT");
          else println("LADYBUG: solved stuck LEFT");
          location.x += 3;
        }
      } else if (location.y + radius >= (forTraining ? height : height-40)) {
        stuckFrames += 1;
        println(location.x, location.y);
        if (stuckFrames >= 30) {
          if (forTraining) println("T. LADYBUG: solved stuck DOWN");
          else println("LADYBUG: solved stuck DOWN");
          location.y -= 3;
        }
      } else if (location.y - radius <= 30) {
        stuckFrames += 1;
        println(location.x, location.y);
        if (stuckFrames >= 30) {
          if (forTraining) println("T. LADYBUG: solved stuck UP");
          else println("LADYBUG: solved stuck UP");
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

    float moveX =  speed*cos(moveTheta);
    float moveY = -speed*sin(moveTheta);

    location = new PVector(location.x+moveX, location.y+moveY); //the actual moving code
  }

  PVector getLocation() { 
    return location;
  }

  float getMoveTheta() {
    return moveTheta;
  }

  boolean getSelectedStatus() {
    return selectedStatus;
  }
}

class Satanic {
  int satanicType = -1;

  float speed = 13.5;
  PVector location; 
  float radius = 8;
  float moveTheta = radians(random(360));
  int stuckFrames = 0;

  boolean isTurnBased = false;

  Satanic(int _type, boolean _tb) {
    satanicType = _type;
    isTurnBased = _tb;

    float rndX = random(width/2-220), rndY = random(height/2-250);
    float x = random(1)>0.5? width/2+200+rndX : width/2-200-rndX;
    float y = random(1)>0.5? height/2+200+rndY : height/2-200-rndY;
    location = new PVector(x, y);

    println(location);
  } 

  void updateLocation(float x, float y) {
    location = new PVector(x, y);
  }

  boolean changeSpeed = false;
  int changeSpeedDuration = 0;
  void changeSpeedForDuration(float newSpeed, int duration) {
    changeSpeed = true;
    speed = newSpeed;
    changeSpeedDuration = duration;
  }

  float angleOffset = 0;
  void show() {
    if (angleOffset >= 360) angleOffset -= 360;
    else angleOffset += 3;

    fill(134, 1, 1);
    stroke(70, 0, 10);
    strokeWeight(1.5);

    //animation for "purifying" the demon
    if ((BTObjectiveTier <= 1 && zoneNum >= 0) || (BTObjectiveTier == 2 && zoneNum == 2)) {
      println("animation");
      float t = map(moveTimer, 0, 2000, 0, 9.95)+1.08;
      radius = 0.0059*pow(t, 5)-0.1742*pow(t, 4)+1.7791*pow(t, 3)-7.5915*pow(t, 2)+13.724*t;
      float a = map(moveTimer, 0, 2000, 0, 9.157)+1.822;
      angleOffset += 0.00355*pow(a, 5)-0.0405*pow(a, 4)-0.4092*pow(a, 3)+5.11*pow(a, 2)-7.7474*a;
      fill(map(moveTimer, 0, 2000, 134, 251), map(moveTimer, 0, 2000, 1, 255), map(moveTimer, 0, 2000, 1, 214));
    }

    pushMatrix();
    translate(location.x, location.y);
    rotate(-moveTheta);
    rotate(-radians(angleOffset));
    polygon(0, 0, radius, 6);
    popMatrix();

    if (isTurnBased) {
      strokeWeight(1);
      stroke(50);
      noFill();
      rect(location.x+15, location.y-10, 6, 20);

      rectMode(CORNERS);
      noStroke();
      fill(70, 0, 10);
      rect(location.x+15.5, map(moveTimer, 0, 6000, location.y+10, location.y-10), location.x+20.75, location.y+9.75);
      rectMode(CORNER);
    }
  }

  int moveTimer = int(random(1000));
  ArrayList<PVector> BTDemonDotPos = new ArrayList<PVector>();
  void move() {
    if (isTurnBased) {
      moveTimer += timePassed;

      if (changeSpeed) {
        changeSpeedDuration -= timePassed;
        if (changeSpeedDuration <= 0) {
          changeSpeedDuration = 0;
          changeSpeed = false;
          speed = 13.5;
        }
      }

      if (moveTimer >= 6000) {
        BTDemonDotPos = new ArrayList<PVector>(); //reset dot pos (OMG I DIDNT RESET IT THATS WHY)
        moveTimer = 0;

        float turnSpeed = speed*6; //move once every 6 secs
        float bx = trainingBee.getLocation().x;
        float by = trainingBee.getLocation().y;
        moveTheta = calcMoveTheta(bx, by, location.x, location.y);

        float distance = distance_between_two_points(bx, location.x, by, location.y);
        float moveX, moveY;

        if (distance > turnSpeed) { //cant reach the bee this turn
          for (int i = 0; i < turnSpeed; i++) BTDemonDotPos.add(new PVector(location.x+i*cos(moveTheta), location.y-i*sin(moveTheta)));
          checkInZone();
          println(gameMillis, "checking ptf:", passThrough);
          if (passThrough.x != -1) { //after checkInZone, passThroughFirst will be set
            location = passThrough;
            return; //use the "passThroughFirst" position instead, so dont run the rest
          }

          moveX =  turnSpeed*cos(moveTheta);
          moveY = -turnSpeed*sin(moveTheta);

          location = new PVector(location.x+moveX, location.y+moveY); //the actual moving code
        } else { //can reach the bee this turn. just use its location
          location = new PVector(bx, by); //the actual moving code

          if (BTOngoing) {
            BTFailed = true; //fail the training course
            if (BTObjectiveTier == 0) trainingBee.updateIsAlive(false);
          }
        }
      }
    }
  }

  //boolean isInZone = false;
  int zoneNum = -1;
  PVector passThrough = new PVector(-1, -1);
  int checkInZone() {
    if (moveTimer > 2000) {
      if (zoneNum >= 0) {
        return zoneNum;
      }
    }

    boolean[] spCase = {false, false, false};
    boolean[] spCase2 = {false, false, false}; //for the possible second triangle
    float[][][] triangleTheta = new float[2][3][2]; //[2]triangles, [3]corners, [2]upper+lowerTheta
    int counter = 0, first = -1, end = -1;
    boolean[] confirmZone = {false, false, false};
    int enteredTriangles = 0;

    if (BTHolyPos[0][0] != -1 && BTHolyPos[1][0] != -1 && BTHolyPos[2][0] != -1) { //has 1 triangle, probably on progress to form another one
      PVector a = new PVector(BTHolyPos[0][0], BTHolyPos[0][1]), 
        b = new PVector(BTHolyPos[1][0], BTHolyPos[1][1]), 
        c = new PVector(BTHolyPos[2][0], BTHolyPos[2][1]);
      float a1 = calcMoveTheta(b.x, b.y, a.x, a.y);
      float a2 = calcMoveTheta(c.x, c.y, a.x, a.y);
      float b1 = calcMoveTheta(a.x, a.y, b.x, b.y);
      float b2 = calcMoveTheta(c.x, c.y, b.x, b.y);
      float c1 = calcMoveTheta(a.x, a.y, c.x, c.y);
      float c2 = calcMoveTheta(b.x, b.y, c.x, c.y);

      triangleTheta[0][0][0] = min(a1, a2);
      triangleTheta[0][0][1] = max(a1, a2);
      triangleTheta[0][1][0] = min(b1, b2);
      triangleTheta[0][1][1] = max(b1, b2);
      triangleTheta[0][2][0] = min(c1, c2);
      triangleTheta[0][2][1] = max(c1, c2);

      //(see notebook for ref)
      for (int i = 0; i < 3; i++) {
        if (triangleTheta[0][i][1] - triangleTheta[0][i][0] >= PI) {
          triangleTheta[0][i][0] += TWO_PI;
          float temp = triangleTheta[0][i][1];
          triangleTheta[0][i][1] = triangleTheta[0][i][0]; //exchange max/min
          triangleTheta[0][i][0] = temp;
          spCase[i] = true;
        }

        println("Triangle 1, Corner " + i + ": " + degrees(triangleTheta[0][i][0]), degrees(triangleTheta[0][i][1]));
      }

      //println("Triangle 1");
      for (PVector pos : BTDemonDotPos) {
        for (int i = 0; i < confirmZone.length; i++) confirmZone[i] = false; //reset confirmZone variable
        //println(1, counter, pos);
        counter++;
        float[] _target = {calcMoveTheta(pos.x, pos.y, a.x, a.y), calcMoveTheta(pos.x, pos.y, b.x, b.y), calcMoveTheta(pos.x, pos.y, c.x, c.y)};
        for (int i = 0; i < _target.length; i++) {
          if (spCase[i]) _target[i] += TWO_PI;
          if (_target[i] < triangleTheta[0][i][1] && _target[i] > triangleTheta[0][i][0]) { //between two angles
            confirmZone[i] = true;
          }
        }
        if (confirmZone[0] && confirmZone[1] && confirmZone[2]) {
          zoneNum = 0;
          if (first == -1) first = counter;
          if (enteredTriangles == 0) enteredTriangles = 1;
          //BTTriangle[0] = true;
          //passThroughFirst = pos;
          //return false; //no need to run the rest iteractions. this "false" is to exit the function. the enemy will be removed after 2s due to isInZone = true
        } else { //not passing through zone
          if (first != -1) { //if it's not passing through zone ANYMORE (it has passed through before)
            if (end == -1) {
              end = counter;
              break; //no need to run the rest iteration
            }
          }
        }
      }
      println("Triangle 1 meets first and end: " + first, end);
    }

    if ((BTObjectiveTier == 2 || first == -1) && BTHolyPos[3][0] != -1 && BTHolyPos[4][0] != -1 && BTHolyPos[5][0] != -1) { //first = -1, that means demon didnt even enter the 1st triangle. So check the 2nd one. && second triangle is present
      PVector a = new PVector(BTHolyPos[3][0], BTHolyPos[3][1]), 
        b = new PVector(BTHolyPos[4][0], BTHolyPos[4][1]), 
        c = new PVector(BTHolyPos[5][0], BTHolyPos[5][1]);
      float a1 = calcMoveTheta(b.x, b.y, a.x, a.y);
      float a2 = calcMoveTheta(c.x, c.y, a.x, a.y);
      float b1 = calcMoveTheta(a.x, a.y, b.x, b.y);
      float b2 = calcMoveTheta(c.x, c.y, b.x, b.y);
      float c1 = calcMoveTheta(a.x, a.y, c.x, c.y);
      float c2 = calcMoveTheta(b.x, b.y, c.x, c.y);

      triangleTheta[1][0][0] = min(a1, a2);
      triangleTheta[1][0][1] = max(a1, a2);
      triangleTheta[1][1][0] = min(b1, b2);
      triangleTheta[1][1][1] = max(b1, b2);
      triangleTheta[1][2][0] = min(c1, c2);
      triangleTheta[1][2][1] = max(c1, c2);

      //(see notebook for ref)
      for (int i = 0; i < 3; i++) {
        if (triangleTheta[1][i][1] - triangleTheta[1][i][0] >= PI) {
          triangleTheta[1][i][0] += TWO_PI;
          float temp = triangleTheta[1][i][1];
          triangleTheta[1][i][1] = triangleTheta[1][i][0]; //exchange max/min
          triangleTheta[1][i][0] = temp;
          spCase2[i] = true;
        }

        println("Triangle 2, Corner " + i + ": " + degrees(triangleTheta[1][i][0]), degrees(triangleTheta[1][i][1]));
      }

      //println("Triangle 2");
      counter = 0;
      for (PVector pos : BTDemonDotPos) {
        for (int i = 0; i < confirmZone.length; i++) confirmZone[i] = false; //reset confirmZone variable
        //println(2, counter, pos);
        counter++;
        float[] _target = {calcMoveTheta(pos.x, pos.y, a.x, a.y), calcMoveTheta(pos.x, pos.y, b.x, b.y), calcMoveTheta(pos.x, pos.y, c.x, c.y)};
        for (int i = 0; i < _target.length; i++) {
          if (spCase2[i]) _target[i] += TWO_PI;
          if (_target[i] < triangleTheta[1][i][1] && _target[i] > triangleTheta[1][i][0]) { //between two angles
            confirmZone[i] = true;
          }
        }
        if (confirmZone[0] && confirmZone[1] && confirmZone[2]) {
          zoneNum = 1;
          if (first == -1) first = counter;
          if (enteredTriangles == 1) enteredTriangles = 2;
          //BTTriangle[1] = true;
          //passThroughFirst = pos;
          //return false; //no need to run the rest iteractions. this "false" is to exit the function. the enemy will be removed after 2s due to isInZone = true
        } else { //not passing through zone
          if (first != -1) { //if it's not passing through zone ANYMORE (it has passed through before)
            if (end == -1) {
              end = counter;
              break; //no need to run the rest iteration
            }
          }
        }
      }
      println("Triangle 2 meets first and end: " + first, end);
    }

    //** REMOVED: The "lands right in the zone" case is merely a situation where it has no "end"

    if (BTObjectiveTier <= 1) {
      if (first != -1) { //it has passed through
        if (end != -1) { //it has an end
          passThrough = BTDemonDotPos.get((first+end)/2);
        } else passThrough = BTDemonDotPos.get(BTDemonDotPos.size()-1);
      } else passThrough = new PVector(-1, -1);
    } else if (BTObjectiveTier == 2) {
      if (first != -1) passThrough = BTDemonDotPos.get(BTDemonDotPos.size()-1);
    } else passThrough = new PVector(-1, -1);
    println(first, end, passThrough);

    if (enteredTriangles == 2 && BTObjectiveTier == 2) { //entered two overlapping triangles (only apply when it's devil stage)
      zoneNum = 2;
    } 

    return -1;
  }

  PVector getLocation() { 
    return location;
  }

  float getMoveTheta() {
    return moveTheta;
  }

  float getSpeed() {
    return speed;
  }

  float getChangeSpeedDuration() {
    return changeSpeedDuration;
  }
}