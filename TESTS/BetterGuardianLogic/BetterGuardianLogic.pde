//last updated: 170701 (should work overall)

Bee simBee;
Bee realBee;
SimulHornet simHornet;
RealHornet realHornet;
NewGuardian simNewGuardian;
NewGuardian realNewGuardian;

ArrayList<PVector> hornetPoints = new ArrayList<PVector>();
void setup() {
  size(800, 600);
  simBee = new Bee(0.7);
  realBee = new Bee(0.7);
  simHornet = new SimulHornet(1.3);
  realHornet = new RealHornet(1.3);
  simNewGuardian = new NewGuardian(1.52);
  realNewGuardian = new NewGuardian(1.52);
  //frameRate(10000);
  frameRate(120);
}

int guardianFinalFrame = 0, guardianStuckTimes = 0;
void draw() {
  //background(255);
  textAlign(CENTER);
  while (simHornet.getStopMove() == false) {
    simBee.showBee();
    simBee.move();
    simHornet.showHornet();
    simHornet.move();
  }
  //myGuardian.showGuardian();
  //myGuardian.move();
  //if (myGuardian.getStopMove()) {
  //frameRate(60);
  //myNewGuardian.updateFinalLocation(myGuardian.getLocation().x, myGuardian.getLocation().y); //get the primitive final location
  //myNewGuardian.updateFinalLocation(hornetPoints.get(107).x, hornetPoints.get(107).y); //testing whether the final frames match
  //myNewGuardian.updateFinalLocation(425.36066, 362.76913); //107
  //myNewGuardian.updateFinalLocation(499.87952, 252.78468); //210

  //}



  if (simHornet.getStopMove() && simNewGuardian.getIsFinalFrame() == false) { // if -> while
    simNewGuardian.showGuardian();

    if (guardianFinalFrame != simNewGuardian.getMoves()) { 
      simNewGuardian.move();
      //assign guardian's final location to hornet's final frame
      if (guardianFinalFrame != 0) simNewGuardian.updateFinalLocation(hornetPoints.get(guardianFinalFrame).x, hornetPoints.get(guardianFinalFrame).y);

      if (simNewGuardian.getStopMove()) {
        if (guardianStuckTimes >= 15) {
          println("forcefully using this as the final frame because there won't be a shorter path");          
          
          simNewGuardian.confirmFinalFrame();
          println(guardianFinalFrame);
          background(220);
        } else {
          
          simNewGuardian.updateFinalLocation(hornetPoints.get(guardianFinalFrame).x, hornetPoints.get(guardianFinalFrame).y);

          guardianFinalFrame = simNewGuardian.getMoves();
          simNewGuardian.resetGuardian();
        }
      }
    } else { // Equal. 2 situations:
      // 1. Really final frame (shortest path)
      // 2. Hasn't reached the target yet. Stopped mid-way

      println("equal");

      if (simNewGuardian.getStopMove()) {
        println("Confirming this to be the final frame (shortest path)");

        simNewGuardian.confirmFinalFrame();
        println(guardianFinalFrame);
        background(220);
      } else {
        println("Hasn't reached the target yet. Stopped mid-way");

        guardianStuckTimes++; //it is possible that the shorest path and this "stucked" frame differs by a small value and keeps trying to get a shortest path. This stuckTimes will be used to determine whether it has got the shorest path possible.

        simNewGuardian.move(); //make it continue to move (the frames are unequal again)
      }
    }
  }

  if (simNewGuardian.getIsFinalFrame()) {
    realBee.showBee();
    realBee.move();
    realHornet.showHornet();
    realHornet.move();
    realNewGuardian.updateFinalLocation(hornetPoints.get(guardianFinalFrame).x, hornetPoints.get(guardianFinalFrame).y);
    realNewGuardian.showGuardian();
    realNewGuardian.move();
  }


  //Guideline
  //1. get every point of hornet's path.
  //2. use the new guardian logic to test the final location, until the hornet's and the guardian's final frames are the same
}

int speedMultiplier = 1;
class Bee {
  PVector location = new PVector(width/2-150, height/2+80); 
  float radius = 10;
  float speed;
  float moveTheta = radians(45);

  boolean printName = true;

  Bee(float _speed) {
    speed = _speed * speedMultiplier;
  }

  void showBee() {
    fill(255, 100, 0, 200);
    if (printName) text("Bee", location.x, location.y+15);
    printName = false;
    stroke(0); 
    noStroke(); 
    ellipse(location.x, location.y, radius, radius);
  }

  void resetBee() {
    location = new PVector(width/2-150, height/2+80);
  }

  void move() {
    float moveX = speed*cos(moveTheta);
    float moveY = -speed*sin(moveTheta);

    location = new PVector(location.x+moveX, location.y+moveY); //the actual moving code
  }

  PVector getLocation() {
    return location;
  }
}

class SimulHornet {
  PVector location = new PVector(width/2-150, height/2-200);
  float radius = 5;
  float speed;
  float moveTheta;
  boolean stopMove = false;
  int moves = 0;

  boolean printName = true;

  SimulHornet(float _speed) {
    speed = _speed * speedMultiplier;
  } 

  void showHornet() {
    fill(255, 137, 137);
    if (printName) text("Hornet", location.x, location.y+15);
    printName = false;
    stroke(0); 
    noStroke();
    ellipse(location.x, location.y, radius, radius);
  }

  void resetHornet() {
    stopMove = false;
    location = new PVector(width/2-150, height/2-200);
    moves = 0;
  }

  void move() {
    float bx = simBee.getLocation().x;
    float by = simBee.getLocation().y;

    float detX = bx - location.x;
    float detY = by - location.y;
    float hypotenuse = distance_between_two_points(location.x, bx, location.y, by);
    if (hypotenuse < 1.5) {
      if (stopMove == false) {
        guardianFinalFrame = moves-1;
        println("Hornet stops at " + moves + " moves");
      }
      stopMove = true;
      text(moves, location.x, location.y-15);
    }
    float _thetaRad = asin(abs(by - location.y) / hypotenuse);
    moveTheta = returnRealTheta(_thetaRad, detX, detY);
    float moveX = speed*cos(moveTheta);
    float moveY = -speed*sin(moveTheta);

    if (stopMove == false) {
      location = new PVector(location.x+moveX, location.y+moveY); //the actual moving code
      if (simNewGuardian.getIsFinalFrame() == false) {
        hornetPoints.add(location);
        println(moves, hornetPoints.get(moves));
      }
      moves++;
    }
  }

  PVector getLocation() {
    return location;
  }

  int getMoves() {
    return moves;
  }

  boolean getStopMove() {
    return stopMove;
  }
}

class RealHornet {
  PVector location = new PVector(width/2-150, height/2-200);
  float radius = 5;
  float speed;
  float moveTheta;
  boolean stopMove = false;
  int moves = 0;

  boolean printName = true;

  RealHornet(float _speed) {
    speed = _speed * speedMultiplier;
  } 

  void showHornet() {
    fill(255, 137, 137);
    if (printName) text("Hornet", location.x, location.y+15);
    printName = false;
    stroke(0); 
    noStroke();
    ellipse(location.x, location.y, radius, radius);
  }

  void resetHornet() {
    stopMove = false;
    location = new PVector(width/2-150, height/2-200);
    moves = 0;
  }

  void move() {
    float bx = realBee.getLocation().x;
    float by = realBee.getLocation().y;

    float detX = bx - location.x;
    float detY = by - location.y;
    float hypotenuse = distance_between_two_points(location.x, bx, location.y, by);
    if (hypotenuse < 1.5) {
      if (stopMove == false) {
        guardianFinalFrame = moves-1;
        println("Hornet stops at " + moves + " moves");
      }
      stopMove = true;
      text(moves, location.x, location.y-15);
    }
    float _thetaRad = asin(abs(by - location.y) / hypotenuse);
    moveTheta = returnRealTheta(_thetaRad, detX, detY);
    float moveX = speed*cos(moveTheta);
    float moveY = -speed*sin(moveTheta);

    if (stopMove == false) {
      location = new PVector(location.x+moveX, location.y+moveY); //the actual moving code
      //if (simNewGuardian.getIsFinalFrame() == false) {
      //  hornetPoints.add(location);
      //  println(moves, hornetPoints.get(moves));
      //}
      moves++;
    }
  }

  PVector getLocation() {
    return location;
  }

  int getMoves() {
    return moves;
  }

  boolean getStopMove() {
    return stopMove;
  }
}

class NewGuardian {
  PVector location = new PVector(width/2+180, height/2);
  float radius = 8;
  float speed;
  float moveTheta = radians(450);
  boolean stopMove = false; //initial false. reset to true when it is assigned a final location
  int moves = 0;
  boolean isFinalFrame = false;

  boolean printName = true;

  NewGuardian(float _speed) {
    speed = _speed * speedMultiplier;
  } 

  void resetGuardian() {
    stopMove = false;
    location = new PVector(width/2+180, height/2);
    moves = 0;
  }

  void confirmFinalFrame() {
    isFinalFrame = true;
  }

  float finalX, finalY;
  void updateFinalLocation(float x, float y) {
    finalX = x;
    finalY = y;
  }

  void showGuardian() {
    fill(116, 117, 183);
    if (printName) text("New Guardian", location.x, location.y-15);
    printName = false;
    stroke(0); 
    noStroke();
    ellipse(location.x, location.y, radius, radius);

    fill(0, 255, 0);
    ellipse(finalX, finalY, 1, 1);
  }

  void move() {
    float hx = finalX;
    float hy = finalY;

    float detX = hx - location.x;
    float detY = hy - location.y;
    float hypotenuse = distance_between_two_points(location.x, hx, location.y, hy);
    float _thetaRad = asin(abs(hy - location.y) / hypotenuse);
    if (hypotenuse < 1.5) {
      if (stopMove == false) {
        fill(116, 117, 183);
        println("New Guardian stops at " + moves + " moves");
        text(moves, location.x, location.y-25);
      }
      stopMove = true;
    }
    moveTheta = returnRealTheta(_thetaRad, detX, detY);
    float moveX = speed*cos(moveTheta);
    float moveY = -speed*sin(moveTheta);

    if (stopMove == false) {
      location = new PVector(location.x+moveX, location.y+moveY); //the actual moving code
      moves++;
    }
  }

  boolean getStopMove() {
    return stopMove;
  }

  boolean getIsFinalFrame() {
    return isFinalFrame;
  }

  int getMoves() {
    return moves;
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

void keyReleased() {
  if (key == 's') {
    frameRate(10);
  } else if (key == 'h') {
    frameRate(300);
  } else {
    frameRate(120);
  }
}