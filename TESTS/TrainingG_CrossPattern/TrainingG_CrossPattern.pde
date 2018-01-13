//last update: 170807

ArrayList<Hornet> trainingHornets = new ArrayList<Hornet>(); //for hunting guardian, ranged guardian
TrainingGuardian trainingGuardian;

long timeMillis = System.currentTimeMillis();
long gameMillis = 5000, pMillis = System.currentTimeMillis();

String exception;
ArrayList<Float> trailPoints = new ArrayList<Float>();

boolean[][][] instantWall = new boolean[5][5][4]; //Up Right Down Left

PrintWriter output;

void setup() {
  //if (debug) ROUND_TIME = 3000; //can be achieved by pressed 'w'

  size(600, 600);
  noFill();
  smooth(); //i dont know what effect it has but it looks fancier
  frameRate(60);

  trainingGuardian = new TrainingGuardian();
  for (int i = 0; i < 1; i++) trainingHornets.add(new Hornet(0, true));

  for (int i = 0; i < linePos.length; i++) {
    linePos[i] = 0;
  }

  for (int x = 0; x < 5; x++) {
    for (int y = 0; y < 5; y++) {
      circleCenter[x][y] = new PVector(width/2 + (x-2)*(circleRadius*2*1.1), height/2 + (y-2)*(circleRadius*2*1.1));
      for (int i = 0; i < 4; i++) {
        instantWall[x][y][i] = false;
        if (x==2&&y==2) instantWall[x][y][i] = true;
      }
    }
  }

  output = createWriter("death details.txt");
}


int circleRadius = 50;
PVector[][] circleCenter = new PVector[5][5];
void draw() {
  timeMillis = System.currentTimeMillis();
  gameMillis += (timeMillis-pMillis);

  background(255);

  fill(0);
  textSize(10);
  textAlign(LEFT);
  text("Hornets Alive: " + trainingHornets.size(), 10, 15);
  text("Frame Rate: " + (int)frameRate, 10, 27);

  fill(125);
  text("v170807", 10, height-15);
  if (oneBounce) fill(0, 175, 75);
  else fill(255, 100, 100);
  text("[O] One Reflection is: " + (oneBounce ? "on." : "off."), 10, height-27);

  noFill();
  strokeWeight(1);
  stroke(0);
  for (int x = 0; x < 5; x++) {
    for (int y = 0; y < 5; y++) {
      strokeWeight(1);
      stroke(0);
      ellipse(width/2 + (x-2)*(circleRadius*2*1.1), height/2 + (y-2)*(circleRadius*2*1.1), circleRadius*2, circleRadius*2); // center

      strokeWeight(1.5);
      stroke(150, 255, 150);
      if (instantWall[x][y][0]) line(circleCenter[x][y].x-50, circleCenter[x][y].y-50, circleCenter[x][y].x+50, circleCenter[x][y].y-50);
      if (instantWall[x][y][1]) line(circleCenter[x][y].x+50, circleCenter[x][y].y-50, circleCenter[x][y].x+50, circleCenter[x][y].y+50);
      if (instantWall[x][y][2]) line(circleCenter[x][y].x+50, circleCenter[x][y].y+50, circleCenter[x][y].x-50, circleCenter[x][y].y+50);
      if (instantWall[x][y][3]) line(circleCenter[x][y].x-50, circleCenter[x][y].y+50, circleCenter[x][y].x-50, circleCenter[x][y].y-50);
    }
  }

  if (showIniTheta) {
    for (Hornet th : trainingHornets) {
      th.showIniTheta();
    }
  }

  if (showDebug) {
    fill(0, 0, 0, 150);
    noStroke();
    rect(0, height-218, width/2+10, height);
    if (oneBounce) fill(150, 255, 150);
    else fill(255, 150, 150);
    text("[O] One Reflection is: " + (oneBounce ? "on." : "off."), 10, height-27);
    fill(255);
    text("[r/R] Respawn 1/100 hornet", 10, height-39);
    text("[1/2] Lower framerate", 10, height-51);
    text("[D] Reset framerate", 10, height-63);
    text("[F/G] Increase framerate", 10, height-75);
    if (noLine == false) fill(150, 255, 150);
    else fill(255, 150, 150);
    text("[N] Show debug lines ("+(noLine == false ? "ON" : "OFF")+")", 10, height-87);
    fill(255, 150, 255);
    text("[P] Reset magenta line", 10, height-99);
    fill(255);
    text("[8] Move in opposite dir", 10, height-111);
    if (showTrail) fill(150, 255, 150);
    else fill(255, 150, 150);
    text("[T] Show history trails ("+(showTrail ? "ON" : "OFF")+")", 10, height-123);
    if (showHornet) fill(150, 255, 150);
    else fill(255, 150, 150);
    text("[A] Show Hornet ("+(showHornet ? "ON" : "OFF")+")", 10, height-135);
    fill(255);
    text("[C] Stop/Continue hornet movement", 10, height-147);
    if (spawnAtMouse) fill(150, 255, 150);
    else fill(255, 150, 150);
    text("[M] Spawn hornet at mouse ("+(spawnAtMouse ? "ON" : "OFF")+")", 10, height-159);
    if (useManualTheta) fill(150, 255, 150);
    else fill(255, 150, 150);
    text("[U] Use mousewheel manual theta ("+(useManualTheta ? manualMoveTheta : "OFF")+")", 10, height-171);
    fill(255);
    text("[Q] Spawn hornets at 360 degrees", 10, height-183);
    text("[q] Spawn 1000 hornets", 10, height-195);
    text("[</>] Save/Delete respawn location", 10, height-207);
  }

  if (trainingHornets.size()==1) {
    if (data.size()>0) {
      if (noLine == false) {
        strokeWeight(1);
        stroke(255, 0, 0);
        line(linePos[0], linePos[1], linePos[2], linePos[3]);
        stroke(0, 255, 0);
        line(linePos[4], linePos[5], linePos[6], linePos[7]);
      }

      if (showTrail) {
        strokeWeight(0.5);
        stroke(0, 0, 255);
        for (int i = trailPoints.size()-4; i >= 0; i-=2) {
          float tp1x = trailPoints.get(i);
          float tp1y = trailPoints.get(i+1);
          float tp2x = trailPoints.get(i+2);
          float tp2y = trailPoints.get(i+3);

          line(tp1x, tp1y, tp2x, tp2y);
        }
      }

      if (tempLocX != -1) {
        strokeWeight(2);
        stroke(255, 150, 0);
        point(tempLocX, tempLocY);
        fill(255, 150, 0);
        textSize(8);
        textAlign(CENTER);
        text(tempLocX + ", " + tempLocY, tempLocX, tempLocY-7);
      }

      fill(125);
      textAlign(RIGHT);
      textSize(10);
      text("Impact at: (" + nf(float(data.get(0)), 3, 3) + ", " + nf(float(data.get(1)), 3, 3) + ")", width-10, 10);
      if (float(data.get(2)) > 0) fill(0, 175, 75);
      else if (float(data.get(2)) < 0) fill(255, 100, 100);
      else if (float(data.get(2)) == 0) fill(255, 255, 100);
      else if (float(data.get(2)) == Float.POSITIVE_INFINITY || float(data.get(2)) == Float.NEGATIVE_INFINITY) fill(255, 100, 255);
      text("Gradient: " + data.get(2), width-10, 22);

      fill(125);
      text("Hornet vector: " + nfp(float(data.get(3)), 1, 3) + "i " + nfp(float(data.get(4)), 1, 3) + "j", width-10, 34);
      text("Collision to circle center vector: " + nfp(float(data.get(5)), 1, 3) + "i " + nfp(float(data.get(6)), 1, 3) + "j", width-10, 46);
      text("Vector Theta: " + nf(float(data.get(7)), 2, 3), width-10, 58);
      text("Move Theta: " + nf(float(data.get(8)), 2, 3) + " -> " + nf(float(data.get(10)), 2, 3), width-10, 70);
      if (exception.length() > 1) text("EXCEPTION: " + exception, width-10, 106);

      float _vectorThetaD = float(data.get(7)), _purpleAngleD = float(data.get(9)), _moveThetaD = float(data.get(8));
      if (float(data.get(2)) > 0) {
        float blueAngle = 180 + (90-_vectorThetaD) + 2*_vectorThetaD;
        text("Blue Angle: " + nf(blueAngle, 3, 3), width-10, 82);
        text("Purple Angle: " + nf(float(data.get(9)), 3, 3), width-10, 94);
      }
    }

    if (noLine == false) {
      textSize(9);
      textAlign(CENTER);
      fill(255, 0, 255);
      text(degrees(tempTheta), tempLinePos[2], tempLinePos[3]-8);
      stroke(255, 0, 255);
      line(tempLinePos[0], tempLinePos[1], tempLinePos[2], tempLinePos[3]);
    }
  }

  trainingGuardian.showGuardian();
  trainingGuardian.move();
  for (int h = trainingHornets.size ()-1; h >= 0; h--) {
    Hornet _h = trainingHornets.get(h);
    if (showHornet) _h.showHornet();
    _h.move();

    float hx = _h.getLocation().x;
    float hy = _h.getLocation().y;

    if (hx > width || hx < 0 || hy > height || hy < 0) trainingHornets.remove(h);
  }

  pMillis = timeMillis;
}

float[] tempLinePos = new float[4];
float tempTheta;
void mousePressed() {
  if (data.size()>0) {
    tempLinePos[0] = float(data.get(0));
    tempLinePos[1] = float(data.get(1));
    tempLinePos[2] = mouseX;
    tempLinePos[3] = mouseY;
    tempTheta = calcMoveTheta(mouseX, mouseY, float(data.get(0)), float(data.get(1)));
  }
}

void allCreatureWall(float x1, float y1, float x2, float y2) {
}

void mouseReleased() {  
  float gx = trainingGuardian.getLocation().x;
  float gy = trainingGuardian.getLocation().y;

  if (mouseX > gx-25 && mouseX < gx+25 && mouseY > gy-25 && mouseY < gy+25) {
    if (trainingGuardian.getGuardianSelectedStatus() == false) trainingGuardian.updateGuardianSelectedStatus(true); //selected the guardian
    else trainingGuardian.updateGuardianSelectedStatus(false); //deselect the guardian
  } else if (trainingGuardian.getGuardianSelectedStatus() == true) { //if the guardian is selected (the only situation that it can be assigned a target)

    float _thetaRad = calcMoveTheta(mouseX, mouseY, gx, gy);
    trainingGuardian.updateMoveTheta(_thetaRad);

    trainingGuardian.updateGuardianSelectedStatus(false);
    trainingGuardian.updateGuardianMoveTimer(gameMillis);
  } else {
    float _thetaRad = calcMoveTheta(mouseX, mouseY, gx, gy);
    trainingGuardian.updateMoveTheta(_thetaRad);

    trainingGuardian.updateGuardianSelectedStatus(false);
    trainingGuardian.updateGuardianMoveTimer(gameMillis);
  }
}

boolean oneBounce = true, showDebug = false, canMove = true, noLine = false, showTrail = false, showHornet = true, showIniTheta = false;
void keyPressed() {
  if (key == 'r' && keyPressed) {
    background(255);
    trailPoints = new ArrayList<Float>();
    trainingHornets = new ArrayList<Hornet>();
    for (int i = 0; i < 1; i++) trainingHornets.add(new Hornet(0, true));
  } else if (key == 'R' && keyPressed) {
    background(255);
    trainingHornets = new ArrayList<Hornet>();
    for (int x = 0; x < 5; x++) {
      for (int y = 0; y < 5; y++) {
        for (int i = 0; i < 4; i++) {
          trainingHornets.add(new Hornet(0, true));
          trainingHornets.get(trainingHornets.size()-1).updateCircleInfo(width/2 + (x-2)*(circleRadius*2*1.1), height/2 + (y-2)*(circleRadius*2*1.1), circleRadius);
        }
      }
    }
  } else if (key == 'q' && keyPressed) {
    background(255);
    trainingHornets = new ArrayList<Hornet>();
    for (int i = 0; i < 1000; i++) trainingHornets.add(new Hornet(0, true));
  } else if (key == 'Q' && keyPressed) {
    background(255);
    trainingHornets = new ArrayList<Hornet>();
    for (int i = 0; i < 360; i++) {
      trainingHornets.add(new Hornet(0, true));
      trainingHornets.get(i).updateMoveTheta(radians(i));
    }
  } else if (key == '=' && keyPressed) {
    background(255);
    trainingHornets = new ArrayList<Hornet>();
    for (int i = 0; i < 10000; i++) trainingHornets.add(new Hornet(0, true));
  } else if (key == '1' && keyPressed) {
    frameRate(20);
  } else if (key == '2' && keyPressed) {
    frameRate(5);
  } else if ((key == 'g' || key == 'G') && keyPressed) {
    frameRate(240);
  } else if ((key == 'f' || key == 'F') && keyPressed) {
    frameRate(120);
  } else if ((key == 'd' || key == 'D') && keyPressed) {
    frameRate(60);
  } else if ((key == 'o' || key == 'O') && keyPressed) {
    oneBounce = !oneBounce;
    println("oneBounce is " + oneBounce);
  } else if ((key == 'n' || key == 'N') && keyPressed) {
    noLine = !noLine;
  } else if ((key == 'p' || key == 'P') && keyPressed) {
    for (int i = 0; i < tempLinePos.length; i++) tempLinePos[i] = 0;
    tempTheta = 0;
  } else if ((key == 't' || key == 'T') && keyPressed) {
    showTrail = !showTrail;
  } else if ((key == 'a' || key == 'A') && keyPressed) {
    showHornet = !showHornet;
  } else if (key == '8' && keyPressed) {
    trainingHornets.get(0).updateMoveTheta(PI + trainingHornets.get(0).getMoveTheta() );
  } else if ((key == 's' || key == 'S') && keyPressed) {
    showDebug = !showDebug;
  } else if ((key == 'c' || key == 'C') && keyPressed) {
    canMove = !canMove;
  } else if ((key == 'm' || key == 'M') && keyPressed) {
    spawnAtMouse = !spawnAtMouse;
  } else if ((key == 'u' || key == 'U') && keyPressed) {
    useManualTheta = !useManualTheta;
  } else if ((key == 'b' || key == 'B') && keyPressed) {
    frameRate(10000);
  } else if (key == '<' && keyPressed) {
    tempLocX = mouseX;
    tempLocY = mouseY;
  } else if (key == '>' && keyPressed) {
    tempLocX = -1;
    tempLocY = -1;
  } else if (key == ']') {
    output.println("END OF DEATH REPORT");
    output.flush();
    output.close();
    exit();
  } else if (key == '[') {
    showIniTheta = !showIniTheta;
  } else if (tempLocX != -1) {
    switch (keyCode) {
    case UP:
      tempLocY -= 1;
      break;
    case DOWN:
      tempLocY += 1;
      break;
    case LEFT:
      tempLocX -= 1;
      break;
    case RIGHT:
      tempLocX += 1;
      break;
    }
  }
}
float tempLocX = -1, tempLocY = -1;

float manualMoveTheta = 0;
void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  manualMoveTheta -= e;
  if (manualMoveTheta > 360) manualMoveTheta -= 360;
  else if (manualMoveTheta < 0) manualMoveTheta += 360;
}

ArrayList<String> data = new ArrayList<String>();
float[] linePos = new float[8];
boolean spawnAtMouse = false, useManualTheta = false;
static final float[] hornetFlightSpeed = {1.25, 1.5/*, 2.8*/};
class Hornet {
  int hornetType = -1;

  //PVector location = new PVector(width/2 + random(70)*(random(1)>0.5?1:-1), height/2 + random(70)*(random(1)>0.5?1:-1)); 
  PVector location;
  float radius = 2.5;
  float diameter = radius*2;
  float speed;
  float moveTheta = radians(random(360));
  float initialTheta;
  //float moveTheta = radians(manualMoveTheta);
  boolean killFatigue = false; //5s
  long lastKillMillis;
  //int displayMillis;
  boolean bouncing = false;
  PVector[] locations = new PVector[100];
  int locationMarked = 0;

  PVector circleCenter = new PVector(width/2, height/2);
  int circleRadius = 50;

  boolean forTraining = false;

  Hornet(int _hornetType, boolean _ft) {
    hornetType = _hornetType;
    forTraining = _ft;
    speed = hornetFlightSpeed[_hornetType];
    if (spawnAtMouse) location = new PVector(mouseX, mouseY);
    else if (tempLocX != -1) location = new PVector(tempLocX, tempLocY);
    else location = new PVector(circleCenter.x + random(circleRadius*0.7)*(random(1)>0.5?1:-1), circleCenter.y + random(circleRadius*0.7)*(random(1)>0.5?1:-1)); 
    if (useManualTheta) moveTheta = radians(manualMoveTheta);
    else moveTheta = radians(random(360));
    initialTheta = moveTheta;
    locations[0] = location;
  } 

  void updateSpeed(float _s) {
    speed = _s;
  }

  void resetSpeed() {
    speed = hornetFlightSpeed[hornetType];
  }

  void updateLocation(float x, float y) {
    location = new PVector(x, y);
  }

  void updateCircleInfo(float x, float y, int radius) {
    circleCenter = new PVector(x, y);
    circleRadius = radius;
    location = new PVector(circleCenter.x + random(circleRadius*0.7)*(random(1)>0.5?1:-1), circleCenter.y + random(circleRadius*0.7)*(random(1)>0.5?1:-1));
  }

  void updateMoveTheta(float _mt) {
    moveTheta = _mt;
  }

  void showIniTheta() {
    textSize(8);
    textAlign(CENTER);
    fill(0);
    text(degrees(initialTheta), location.x, location.y-15);
  }

  void showHornet() {
    if (hornetType == 0) fill(255, 137, 137);
    else if (hornetType == 1) fill(193, 59, 59);
    else if (hornetType == 2) fill(152, 0, 0);
    stroke(0); 
    strokeWeight(1.5);
    ellipse(location.x, location.y, diameter, diameter);
  }


  //logic ref in notebook, not implemented yet
  void move() {  
    if (canMove) {
      locationMarked = constrain(locationMarked+1, 1, 100);
      if (locationMarked < locations.length) locations[locationMarked] = location;
      else {
        for (int i = 0; i < locations.length; i++) {
          if (i < locations.length-1) locations[i] = locations[i+1];
          else locations[i] = location;
        }
      }
    }
    if (noLine == false) {
      strokeWeight(0.5);
      stroke(0, 0, 255);
      if (locationMarked > 1) {
        for (int i = 1; i < locationMarked-1; i++) {
          line(locations[i].x, locations[i].y, locations[i-1].x, locations[i-1].y);
        }
      }
    }

    if (canMove) {
      //println(degrees(moveTheta));
      if (gameMillis - lastKillMillis < 5000) killFatigue = true;
      else killFatigue = false;

      float moveX =   (killFatigue ? 0.6 : 1) * speed*cos(moveTheta);
      float moveY = - (killFatigue ? 0.6 : 1) * speed*sin(moveTheta);

      float hypotenuse = distance_between_two_points(location.x, circleCenter.x, location.y, circleCenter.y);
      if (hypotenuse > circleRadius-radius) {
        if (bouncing == false || oneBounce == false) {
          data = new ArrayList<String>();

          bouncing = true;
          exception = "";

          PVector impactPoint = new PVector(location.x+(hypotenuse-(circleRadius-radius))*cos(moveTheta), location.y+(hypotenuse-(circleRadius-radius))*sin(moveTheta));

          trailPoints.add(impactPoint.x);
          trailPoints.add(impactPoint.y);

          strokeWeight(2);
          point(impactPoint.x, impactPoint.y);
          data.add(str(impactPoint.x));
          data.add(str(impactPoint.y));

          //bounce off
          strokeWeight(1);
          stroke(255, 0, 0);
          if (noLine == false) line(circleCenter.x, circleCenter.y, impactPoint.x, impactPoint.y);
          linePos[0] = circleCenter.x;
          linePos[1] = circleCenter.y;
          linePos[2] = impactPoint.x;
          linePos[3] = impactPoint.y;

          float m = 1/((location.y-circleCenter.y)/(location.x-circleCenter.x));
          data.add(str(m));
          stroke(0, 255, 0);
          if (noLine == false) line(impactPoint.x, impactPoint.y, x(m, impactPoint.x, impactPoint.y, height ), height);
          linePos[4] = impactPoint.x;
          linePos[5] = impactPoint.y;
          linePos[6] = x(m, impactPoint.x, impactPoint.y, height );
          linePos[7] = height;

          PVector a = new PVector(-moveX, -moveY);
          PVector b = new PVector(impactPoint.x-circleCenter.x, impactPoint.y-circleCenter.y);
          a.normalize();
          b.normalize();
          //float vectorThetaD = degrees( abs(a.dot(b)) / (a.mag()*b.mag()) );
          float vectorThetaD = 180-degrees( PVector.angleBetween(a, b) );
          data.add(str(a.x));
          data.add(str(a.y));
          data.add(str(b.x));
          data.add(str(b.y));
          data.add(str(vectorThetaD));

          float moveThetaD = degrees(moveTheta);
          //float purpleAngleD = degrees(atan(m));
          float purpleAngleD = degrees( atan(m) );
          //if (purpleAngleD < 0) {
          //  purpleAngleD += 180;

          //}
          data.add(str(moveThetaD));
          data.add(str(purpleAngleD));

          if (round(abs(m)*100) == 0) {
            m = 0; //"super exceptional case" fix
            exception = "CLOSE TO 0 GRADIENT";
          }
          if (m > 0) {
            float newMoveThetaD = 180 + (90-vectorThetaD) + 2*vectorThetaD + purpleAngleD;
            moveTheta = radians(newMoveThetaD);
            println((int)newMoveThetaD+1);
            if ((int)newMoveThetaD+1 >= 360) newMoveThetaD -= 360; 
            if (abs(moveThetaD - newMoveThetaD) < 1.0) { //(+), EXCEPTION: PIERCES THROUGH
              newMoveThetaD = 180 - (90-vectorThetaD) - 2*vectorThetaD + purpleAngleD;
              moveTheta = radians(newMoveThetaD);
              exception = "PIERCE THROUGH";
              println("PIERCE THROUGH");
            }

            if (a.x > 0 && a.y < 0 && b.x > 0 && b.y > 0) { //(+), + - + +
              moveTheta += PI;
            } 
            //else if (0.01-abs(b.x) <= 0.01 && b.y == 1) { //"super exceptional case", trying to fix this
            else if (round(abs(b.x)*1000) == 0 && b.y == 1) {
              moveTheta += PI;
              exception = "Gradient > 0 but close to 0";
            }
            //println();
            //println("COLLISION VECTOR: " + b, (round(abs(b.x)*1000) == 0 && b.y == 1));
          } else if (m < 0) {
            float newMoveThetaD = 180 + moveThetaD + 2*vectorThetaD; //simplified the  +purpleAngleD -purpleAngleD
            moveTheta = radians(newMoveThetaD);
            if (a.x < 0 && a.y < 0 && b.x > 0 && b.y < 0) { //(-), - - + -
              moveTheta += PI;
            }

            float detX = circleCenter.x - location.x; //center - loc
            float detY = circleCenter.y - location.y; //center - loc
            //strokeWeight(5);
            //point(impactPoint.x, impactPoint.y);
            //point(location.x-10*moveX, location.y-10*moveY);

            //println(nfp(detX, 1, 1), nfp(detY, 1, 1), nfp(reflectedDetX, 1, 1), nfp(reflectedDetY, 1, 1));
            //println(nfp(detX, 1, 1).substring(0, 1), nfp(detY, 1, 1).substring(0, 1), nfp(reflectedDetX, 1, 1).substring(0, 1), nfp(reflectedDetY, 1, 1).substring(0, 1));
            if (detX < 0 && detY > 0) { // - +, quad I
              if (moveThetaD > 90 && moveThetaD <= 180) { // 90 - 180 (included 180), -2i
                moveTheta = radians( 180 + moveThetaD - 2*vectorThetaD );
                exception = "W.R. Quad I 90-180, -2i";
                println(exception);
              } else if (moveThetaD > 270 && moveThetaD <= 360) { // 270 - 360 (included 360), +2i
                moveTheta = radians( 180 + moveThetaD + 2*vectorThetaD );
                exception = "W.R. Quad I 270-360, +2i";
                println(exception);
              } else if (moveThetaD > 0 && moveThetaD <= 90) { // 0 - 90 (included 90), two cases
                float iAcuteD = moveThetaD + (moveThetaD > 180 ? -180 : 0);
                float rAcutePlusD = 180 + moveThetaD + 2*vectorThetaD;
                while (rAcutePlusD > 180) rAcutePlusD -= 180;
                float rAcuteMinusD = 180 + moveThetaD - 2*vectorThetaD;
                while (rAcuteMinusD > 180) rAcuteMinusD -= 180;

                //determine which direction is the line coming from
                //"dis is the direction when u stand at the point of collision looking out in the direction of the normal btw."
                float redLineAngleD = degrees( abs(atan2( (impactPoint.y-circleCenter.y), (impactPoint.x-circleCenter.x) )) ) + 180; //+180, opposite dir
                float moveThetaOppD = moveThetaD + 180; //will never exceed 180 (because this is 0-90 case)
                println("NORMAL: " + redLineAngleD, "MOVE OPPOSITE: " + moveThetaOppD);

                //if (rAcuteMinusD < iAcuteD) { // (-) r < i, default from left
                if (moveThetaOppD > redLineAngleD) { //from left, default situation (keep -2i)
                  moveTheta = radians( 180 + moveThetaD - 2*vectorThetaD );
                  exception = "W.R. Quad I (-) r<i";
                } else { //from right, use (+2i) instead
                  moveTheta = radians( 180 + moveThetaD + 2*vectorThetaD );
                  exception = "W.R. Quad I (+) fromR";
                }
                //} else if (rAcutePlusD > iAcuteD) {// (+) r > i, default from right
                //  if (moveThetaOppD < redLineAngleD) { //from right, default situation (keep +2i)
                //    moveTheta = radians( 180 + moveThetaD + 2*vectorThetaD );
                //    exception = "W.R. Quad I (+) r>i";
                //  } else { //from left, use (-2i) instead
                //    moveTheta = radians( 180 + moveThetaD - 2*vectorThetaD );
                //    exception = "W.R. Quad I (-) fromL";
                //  }
                //} else {
                //  exception = "W.R. FUCK MATH 1";
                //  println("FUCK MATH I");
                //}

                println(exception);
              }
            } else if (detX > 0 && detY < 0) { // + -, quad III
              if (moveThetaD > 270 && moveThetaD <= 360) { // 270 - 360 (included 360), -2i
                moveTheta = radians( 180 + moveThetaD - 2*vectorThetaD );
                exception = "W.R. Quad III 270-360, -2i";
                println(exception);
              } else if (moveThetaD > 90 && moveThetaD <= 180) { // 90 - 180 (included 180), +2i
                moveTheta = radians( 180 + moveThetaD + 2*vectorThetaD );
                exception = "W.R. Quad III 90-180, +2i";
                println(exception);
              } else if (moveThetaD > 180 && moveThetaD <= 270) { // 180 - 270 (included 270), two cases
                //determine which direction is the line coming from
                //"dis is the direction when u stand at the point of collision looking out in the direction of the normal btw."
                float redLineAngleD = 180 - degrees( abs(atan2( (impactPoint.y-circleCenter.y), (impactPoint.x-circleCenter.x) )) ); //atan2 calculation is weird. 180 - instead.
                float moveThetaOppD = moveThetaD - 180; //will always exceed 180 (because this is 180-270 case)
                println("NORMAL: " + redLineAngleD, "MOVE OPPOSITE: " + moveThetaOppD);

                //if (rAcuteMinusD < iAcuteD) { // (-) r < i, default from left
                if (moveThetaOppD > redLineAngleD) { //from left, default situation (keep -2i)
                  moveTheta = radians( 180 + moveThetaD - 2*vectorThetaD );
                  exception = "W.R. Quad III (-) r<i";
                } else { //from right, use (+2i) instead
                  moveTheta = radians( 180 + moveThetaD + 2*vectorThetaD );
                  exception = "W.R. Quad III (+) fromR";
                }
                //} else if (rAcutePlusD > iAcuteD) {// (+) r > i, default from right
                //  if (moveThetaOppD < redLineAngleD) { //from right, default situation (keep +2i)
                //    moveTheta = radians( 180 + moveThetaD + 2*vectorThetaD );
                //    exception = "W.R. Quad III (+) r>i";
                //  } else { //from left, use (-2i) instead
                //    moveTheta = radians( 180 + moveThetaD - 2*vectorThetaD );
                //    exception = "W.R. Quad III (-) fromL";
                //  }
                //} else {
                //  exception = "W.R. FUCK MATH 3";
                //  println("FUCK MATH III");
                //}
                println(exception);
              }
            }
          } else if (m == 0) { //this means y = 0. use the LR walls fix
            moveThetaD = 360-moveThetaD;
            moveTheta = radians(moveThetaD);
          } else if (m == Float.POSITIVE_INFINITY || m == Float.NEGATIVE_INFINITY) { //this means x = 0. use top down walls fix
            if (moveThetaD >= 0 && moveThetaD < 180) {
              moveThetaD = 180 - moveThetaD;
            } else {
              moveThetaD = 180 + (360-moveThetaD);
            }
            moveTheta = radians(moveThetaD);
            canMove = false;
          }

          boolean isWrongReflection = false;
          try {
            isWrongReflection = exception.substring(0, 4).equals("W.R.");
          } 
          catch (RuntimeException e) {
            //whatever
          }
          if (moveThetaD >= 270 && moveThetaD <= 360 && exception.equals("PIERCE THROUGH") == false && isWrongReflection == false /* wrong reflection == false */ && (m != 0)) { //EXCEPTION: quad IV
            moveTheta += PI;
            exception = "QUAD IV";
            println("QUAD IV");
          }
          println(degrees(moveTheta), moveThetaD, abs(abs(moveTheta-radians(moveThetaD))-PI));
          if (vectorThetaD > 2.5 && abs(abs(moveTheta-radians(moveThetaD))-PI) < radians(1)) { //EXCEPTION: self reflection
            moveTheta -= 2*radians(vectorThetaD);
            exception = "SELF REFLECT";
            println("SELF REFLECT");
          }
          while (moveTheta > TWO_PI) moveTheta -= TWO_PI;
          data.add(str(degrees(moveTheta)));


          moveX =   (killFatigue ? 0.6 : 1) * 3*speed*cos(moveTheta);
          moveY = - (killFatigue ? 0.6 : 1) * 3*speed*sin(moveTheta);
        }

        //death report, dont know how to deal with
        //if (location.x < 10 || location.x > width-10 || location.y < 10 || location.y > height-10) {
        //  background(255, 0, 0);
        //  output.println("Death of hornet sensed at " + millis() + ":");
        //  output.println("  - Start moveTheta: " + degrees(initialTheta));
        //  output.print("  - Start location: ");
        //  if (tempLocX == -1) output.println("Unknown, possibly " + mouseX + ", " + mouseY);
        //  else output.println(tempLocX + ", " + tempLocY);
        //  output.println("  - Impact location: " + impactPoint.x + ", " + impactPoint.y);
        //  output.println("  - Gradient: " + m);
        //  output.println("  - Hornet vector: " + a.x + ", " + a.y);
        //  output.println("  - Collision to circle center vector: " + b.x + ", " + b.y);
        //  output.println("  - Vector Theta: " + vectorThetaD);
        //  output.println("  - Move Theta: " + moveThetaD + " -> " + degrees(moveTheta));
        //  output.println("  - Possible exception: " + (exception.length() == 0 ? "null" : exception));
        //  output.println();
        //}
        /////
      } else bouncing = false;



      location = new PVector(location.x+moveX, location.y+moveY); //the actual moving code
    }
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

  float getInitialTheta() {
    return initialTheta;
  }
}

float y(float _m, float _x, float _x1, float _y1) {
  float __m = _m, __x = _x, __x1 = _x1, __y1 = _y1;
  float result = __m*(__x-__x1) + __y1;
  return result;
}
float x(float _m, float _x1, float _y, float _y1) {
  float __m = _m, __x1 = _x1, __y = _y, __y1 = _y1;
  float result = (__y-__y1)/__m + __x1;
  return result;
}

static final float[] guardianFlightSpeed = {1.32, 1.65, 1.825, 1.65, 1.4, 1.5, 2.5, 1.5};
static int[] guardianSenseArea = {100, 150, 250, 60, 25, 1000, 0, 125};

class TrainingGuardian {
  PVector location = new PVector(width/2, height/2); 
  float radius = 8;
  float angleOffset = 0;
  float speed = guardianFlightSpeed[1]; //all the training guardians possess the properties of "Super Guardian"
  boolean guardianTimeoutMove = true;
  long guardianMoveTimer = 0;
  boolean guardianSelectedStatus = false;
  boolean shouldGuardianMove = true; 
  String guardianTarget = "None"; //"None", 0:"Firefly"
  float moveTheta = radians(random(360));
  int objectiveID = -1; //default selected none
  int stuckFrames = 0;

  PVector circleID = new PVector(2, 2);

  boolean nextToObjective = false;

  TrainingGuardian() {
  }

  void updateCircleID(int x, int y) {
    circleID = new PVector(x, y);
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
  }

  void move() {
    float shortestDistance = distance_between_two_points(0, width, 0, height); //set supposedly shortest distance to be the longest so that it is certain that there will be a shorter distance
    int closestHornetID = -1;

    for (int h = trainingHornets.size ()-1; h >= 0; h--) {
      Hornet _hornet = trainingHornets.get(h);

      float hx = _hornet.getLocation().x;
      float hy = _hornet.getLocation().y;

      if (hx > circleCenter[(int)circleID.x][(int)circleID.y].x+50 || hx < circleCenter[(int)circleID.x][(int)circleID.y].x-50 || hy > circleCenter[(int)circleID.x][(int)circleID.y].y+50 || hy < circleCenter[(int)circleID.x][(int)circleID.y].y-50) continue;
      else {
        float hypotenuse = distance_between_two_points(hx, location.x, hy, location.y);

        //if (hypotenuse > 50) continue; // different mechanic, dont need this line
        //else {
        if (hypotenuse < shortestDistance) {
          shortestDistance = hypotenuse;
          closestHornetID = h;
        }
        //}
      }
    }

    if (closestHornetID != -1) {
      guardianTarget = "Hornet";

      Hornet h = trainingHornets.get(closestHornetID);
      float hx = h.getLocation().x;
      float hy = h.getLocation().y;

      float hypotenuse = distance_between_two_points(location.x, hx, location.y, hy);
      if (hypotenuse < 1.5) {
        trainingHornets.remove(h);
      }
      moveTheta = calcMoveTheta(hx, hy, location.x, location.y);
    } else guardianTarget = "None"; //reset the target

    if (guardianTimeoutMove) {
      if (gameMillis - guardianMoveTimer > 8000) {
        guardianMoveTimer = gameMillis;
        moveTheta = radians(random(360)); //go in a random angle
      }
    }


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

    // INSTANT WALLS <START>
    if (location.x + radius >= circleCenter[(int)circleID.x][(int)circleID.y].x + 50 || location.x - radius <= circleCenter[(int)circleID.x][(int)circleID.y].x - 50) {
      float thetaD = degrees(moveTheta);
      if (thetaD >= 0 && thetaD < 180) {
        thetaD = 180-thetaD;
      } else {
        thetaD = 180 + (360-thetaD);
      }
      moveTheta = radians(thetaD);
    }
    if (location.y + radius >= circleCenter[(int)circleID.x][(int)circleID.y].y + 50 || location.y - radius <= circleCenter[(int)circleID.x][(int)circleID.y].y - 50) {
      float thetaD = degrees(moveTheta);
      thetaD = 360-thetaD;
      moveTheta = radians(thetaD);
    }
    // INSTANT WALLS <END>

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


    float moveX = speed*cos(moveTheta);
    float moveY = -speed*sin(moveTheta);



    if (shouldGuardianMove) location = new PVector(location.x+moveX, location.y+moveY); //the actual moving code
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
}

float distance_between_two_points(float _x1, float _x2, float _y1, float _y2) {
  float result = sqrt(pow((_x1-_x2), 2) + pow((_y1-_y2), 2));  
  return result;
}
float returnRealTheta(float __theta, float determinantX, float determinantY) {
  if (determinantX >= 0 && determinantY < 0) {
    __theta = __theta;
  } else if (determinantX < 0 && determinantY < 0) {
    __theta = PI - __theta;
  } else if (determinantX < 0 && determinantY >= 0) {
    __theta = PI + __theta;
  } else if (determinantX >= 0 && determinantY >= 0) {
    __theta = TWO_PI - __theta;
  } else println("wtf?");

  return __theta;
}
float calcMoveTheta(float targetX, float targetY, float objectX, float objectY) {
  float hypotenuse = distance_between_two_points(objectX, targetX, objectY, targetY);
  float _thetaRad = asin(abs(targetY - objectY) / hypotenuse);
  //println("Raw CALC theta " + degrees(_thetaRad));
  float detX = targetX - objectX;
  float detY = targetY - objectY;
  _thetaRad = returnRealTheta(_thetaRad, detX, detY);
  return _thetaRad;
}
void polygon(float x, float y, float radius, int npoints) {
  float angle = TWO_PI / npoints;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius;
    float sy = y + sin(a) * radius;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}