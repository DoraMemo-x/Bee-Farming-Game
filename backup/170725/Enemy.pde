static final float[] hornetFlightSpeed = {1.25, 1.5/*, 2.8*/};

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

  void showHornet() {
    if (hornetType == 0) fill(255, 137, 137);
    else if (hornetType == 1) fill(193, 59, 59);
    else if (hornetType == 2) fill(152, 0, 0);
    stroke(0); 
    strokeWeight(1.5);
    if (killFatigue) ellipse(location.x, location.y, radius*(6500-(gameMillis-lastKillMillis))/1500, radius*(6500-(gameMillis-lastKillMillis))/1500);
    else ellipse(location.x, location.y, radius, radius);

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
        if (hypotenuse < (killFatigue || invincibleBees ? 0 : 1.5) && b.getDiameter() == BEE_DIAMETER) {
          lastKillMillis = gameMillis;
          bees.remove(b);
        }
        float _thetaRad = asin(abs(by - location.y) / hypotenuse);
        moveTheta = returnRealTheta(_thetaRad, detX, detY);
        //DETERMINE CLOSEST BEE <END>
      }
    } else { //forTraining == true
      if (gameMillis - lastKillMillis < 5000) killFatigue = true;
      else killFatigue = false;

      //DETERMINE CLOSEST BEE <START>
      float shortestDistance = distance_between_two_points(0, width, 0, height); //set supposedly shortest distance to be the longest so that it is certain that there will be a shorter distance
      int closestBeeID = -1;
      for (int b = trainingBees.size ()-1; b >= 0; b--) {
        Bee _bee = trainingBees.get(b);

        float bx = _bee.getLocation().x;
        float by = _bee.getLocation().y;

        float hypotenuse = distance_between_two_points(location.x, bx, location.y, by);

        if (hypotenuse < shortestDistance) {
          shortestDistance = hypotenuse;
          closestBeeID = b;
        }
      }

      if (closestBeeID != -1) {
        Bee b = trainingBees.get(closestBeeID);
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
          trainingBees.remove(b);
        }
        float _thetaRad = asin(abs(by - location.y) / hypotenuse);
        moveTheta = returnRealTheta(_thetaRad, detX, detY);
        //DETERMINE CLOSEST BEE <END>
      }
    }

    if (roundOver == false && forTraining) {
      if (location.x + radius >= width) {
        stuckFrames += 1;
        println(location.x, location.y);
        if (stuckFrames >= 30) {
          println("T. HORNET: solved stuck RIGHT");
          location.x -= 3;
        }
      } else if (location.x - radius <= 0) {
        stuckFrames += 1;
        println(location.x, location.y);
        if (stuckFrames >= 30) {
          println("T. HORNET: solved stuck LEFT");
          location.x += 3;
        }
      } else if (location.y + radius >= (forTraining ? height : height-40)) {
        stuckFrames += 1;
        println(location.x, location.y);
        if (stuckFrames >= 30) {
          println("T. HORNET: solved stuck DOWN");
          location.y -= 3;
        }
      } else if (location.y - radius <= 30) {
        stuckFrames += 1;
        println(location.x, location.y);
        if (stuckFrames >= 30) {
          println("T. HORNET: solved stuck UP");
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

    float moveX =   (killFatigue ? 0.6 : 1) * speed*cos(moveTheta);
    float moveY = - (killFatigue ? 0.6 : 1) * speed*sin(moveTheta);

    location = new PVector(location.x+moveX, location.y+moveY); //the actual moving code
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
    println(bees.size(), guardians.size(), flowers.size(), factorX, "=", nextHornetTime);
    if (debug) {
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
    println(bees.size(), guardians.size(), flowers.size(), factorX, "=", nextHornetTime);
    if (debug) {
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
    println(bees.size(), guardians.size(), flowers.size(), factorX, "=", nextHornetTime);
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
  } else if (forestType == 3) { // 1 hornet
    float nextHornetTime = ROUND_TIME/2 + random(ROUND_TIME/2);
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
          println(fireflyHp);
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
        if (hypotenuse < (killFatigue || invincibleBees ? 0 : 1.5) && b.getDiameter() == BEE_DIAMETER) {
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
      if (fireflyHp == 0) targetable = true;
      if (gameMillis - fireflyMoveTimer > 6000) {
        if (fireflyHp < 2 && targetable == false && GTSelected == 0) fireflyHp++;
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

  int revealTimer = (int)random(1.5, 6)*1000;
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
      if (trainingHornets.size() == 0) revealTimer = constrain(revealTimer - int(timeMillis-pMillis), -150, 6000);

      if ((revealTimer <= 0 && revealTimer > -150)/*|| trainingHornets.size() > 0*/) {        
        pushMatrix();
        translate(location.x, location.y);
        rotate(-moveTheta);

        imageMode(CENTER);
        image(ladybug, 0, 0, diameter, diameter*(490/351));
        popMatrix();
      } else {
        radius = BEE_DIAMETER /2; 

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