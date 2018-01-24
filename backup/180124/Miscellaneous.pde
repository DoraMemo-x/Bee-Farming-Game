ArrayList<ProjectileWeapon> projectiles = new ArrayList<ProjectileWeapon>();
static final float[] projectileSpeed = {13, 10}; //sting, pomegranate seed, ...
static final float[] projectileLength = {20, 5}; //sting, pomegranate seed, ...

ArrayList<ItemSpawn> pomegranate = new ArrayList<ItemSpawn>();
static final int[][] itemRewards = {{35, 60}}; //pomegranate (-> seed)     - {lowerLimit, higherLimit}

class ProjectileWeapon {
  PVector location;
  float speed; //travel speed
  float _length;
  //String name = "missingNamePW"; //default name for guardians if not specified
  int projectileType = -1;
  //float moveTheta = radians(random(360));
  float moveTheta;
  boolean forTraining = false;

  int bouncingTimes = 2;

  ProjectileWeapon(int _projectileType, float _speed, float _x, float _y, float _moveTheta, boolean _ft) {
    projectileType = _projectileType;
    if (_speed <= 0) speed = projectileSpeed[projectileType];
    else speed = _speed;
    _length = projectileLength[projectileType];
    location = new PVector(_x, _y);
    moveTheta = _moveTheta;
    forTraining = _ft;
  }

  void updateLocation(float x, float y) {
    location = new PVector(x, y);
  }

  void updateMoveTheta(float _theta) {
    moveTheta = _theta;
  }

  void updateSpeed(float _s) {
    speed = _s;
  }

  void showProjectile() {
    if (projectileType == 0) fill(192); //sting
    else if (projectileType == 1) fill(238, 50, 51); //pomegranate seed
    stroke(0);
    strokeWeight(1);
    pushMatrix();
    translate(location.x, location.y);
    rotate(-moveTheta);
    if (projectileType == 0) {
      rectMode(CENTER);
      rect(0, 0, _length, 2, 5, 5, 5, 5);
      rectMode(CORNER);
    } else if (projectileType == 1) {
      ellipse(0, 0, _length, _length);
    }
    popMatrix();
  }

  void move() {
    if (forTraining) {
      for (int h = GTHornets.size ()-1; h >= 0; h--) {
        Hornet _hornet = GTHornets.get(h);

        float hx = _hornet.getLocation().x;
        float hy = _hornet.getLocation().y;

        for (int i = 0; i < _length; i+=2) {
          float px = _length*cos(PI-moveTheta)*(i/_length)+location.x;
          float py = _length*sin(PI-moveTheta)*(i/_length)+location.y;

          float hypotenuse = distance_between_two_points(px, hx, py, hy);
          if (hypotenuse < 5) {
            if (projectileType == 1) _hornet.minusHornetHp();
            if (projectileType == 0) for (int j = 0; j < 5; j++) _hornet.minusHornetHp();
            if (_hornet.getHornetHp() == 0) {
              GTHornets.remove(h);
              if (_hornet.getHornetType() == 0) GTObjectiveScore += 4;
              else if (_hornet.getHornetType() == 1) GTObjectiveScore += 6;
            }
            break;
          }

          if (debug) {
            noStroke();
            fill(76, 139, 83, 25);
            ellipse(px, py, 10, 10);
          }
        }
      }
      for (int ff = GTFireflies.size ()-1; ff >= 0; ff--) {
        Firefly _firefly = GTFireflies.get(ff);

        float ffx = _firefly.getLocation().x;
        float ffy = _firefly.getLocation().y;

        for (int i = 0; i < _length; i+=2) {
          float px = _length*cos(PI-moveTheta)*(i/_length)+location.x;
          float py = _length*sin(PI-moveTheta)*(i/_length)+location.y;

          float hypotenuse = distance_between_two_points(px, ffx, py, ffy);
          if (hypotenuse < 5) {
            if (projectileType == 1) _firefly.minusFireflyHp();
            if (projectileType == 0) for (int j = 0; j < 5; j++) _firefly.minusFireflyHp();
            if (_firefly.getFireflyHp() == 0) {
              GTFireflies.remove(ff);
              GTObjectiveScore += 8;
            }
            break;
          }

          if (debug) {
            noStroke();
            fill(76, 139, 83, 25);
            ellipse(px, py, 10, 10);
          }
        }
      }
    } else {
      for (int h = hornets.size ()-1; h >= 0; h--) {
        Hornet _hornet = hornets.get(h);

        float hx = _hornet.getLocation().x;
        float hy = _hornet.getLocation().y;

        boolean removed = false;
        for (int i = 0; i < _length; i+=2) {
          float px = _length*cos(PI-moveTheta)*(i/_length)+location.x;
          float py = _length*sin(PI-moveTheta)*(i/_length)+location.y;

          float hypotenuse = distance_between_two_points(px, hx, py, hy);
          if (hypotenuse < 7) {
            hornets.remove(h);
            removed = true;
            break;
          }

          println(i, _length, px, py);

          if (debug) {
            noStroke();
            fill(76, 139, 83, 25);
            ellipse(px, py, 16, 16);
          }
        }
        if (removed == false) {
          for (int i = 0; i < speed; i+=2) {
            float px = speed*cos(PI-moveTheta)*(i/_length)+location.x;
            float py = speed*sin(PI-moveTheta)*(i/_length)+location.y;

            float hypotenuse = distance_between_two_points(px, hx, py, hy);
            if (hypotenuse < 7) {
              hornets.remove(h);
              break;
            }

            println(i, speed, px, py);

            if (debug) {
              noStroke();
              fill(125, 0, 0, 15);
              ellipse(px, py, 16, 16);
            }
          }
        }
      }
      for (int ff = fireflies.size ()-1; ff >= 0; ff--) {
        Firefly _firefly = fireflies.get(ff);

        float ffx = _firefly.getLocation().x;
        float ffy = _firefly.getLocation().y;

        for (int i = 0; i < _length; i+=2) {
          float px = _length*cos(PI-moveTheta)*(i/_length)+location.x;
          float py = _length*sin(PI-moveTheta)*(i/_length)+location.y;

          float hypotenuse = distance_between_two_points(px, ffx, py, ffy);
          if (hypotenuse < 7) {
            fireflies.remove(ff);
            break;
          }

          if (debug) {
            noStroke();
            fill(76, 139, 83, 25);
            ellipse(px, py, 16, 16);
          }
        }
      }
    }

    if (forTraining && projectileType == 1 && bouncingTimes > 0) {
      if (location.x + _length >= width || location.x - _length <= 0) {
        float thetaD = degrees(moveTheta);
        if (thetaD >= 0 && thetaD < 180) {
          thetaD = 180-thetaD;
        } else {
          thetaD = 180 + (360-thetaD);
        }
        moveTheta = radians(thetaD);
        bouncingTimes--;
      }
      if (location.y + _length >= (forTraining ? height : height-40) || location.y - _length <= 30) {
        float thetaD = degrees(moveTheta);
        thetaD = 360-thetaD;
        moveTheta = radians(thetaD);
        bouncingTimes--;
      }
    }

    float moveX = speed*cos(moveTheta);
    float moveY = -speed*sin(moveTheta);



    location = new PVector(location.x+moveX, location.y+moveY); //the actual moving code
  }

  PVector getLocation() { 
    return location;
  }

  float getMoveTheta() {
    return moveTheta;
  }

  int getProjectileType() {
    return projectileType;
  }

  boolean getForTraining() {
    return forTraining;
  }

  float getSpeed() {
    return speed;
  }
}

PImage pomegranateImage;
class ItemSpawn {
  PVector location = new PVector(10+random(width-20), 40+random(height-40-50));
  int itemType = -1;
  int itemReward = 0;

  boolean forTraining = false;

  ItemSpawn(int _itemType) {
    itemType = _itemType;
    if (itemType == 17) itemReward = (int)random(itemRewards[0][0], itemRewards[0][1]);
  }

  void updateLocation(float x, float y) {
    location = new PVector(x, y);
  }

  void updateForTraining(boolean _ft) {
    forTraining = _ft;
  }

  void updateT_satisfied(boolean _s) {
    T_satisfied = _s;
  }

  boolean T_satisfied = false;
  void showItem() {
    if (forTraining) {      
      switch (itemType) {
      case 0:
        imageMode(CENTER);
        if (T_satisfied) {
          noFill();
          strokeWeight(3);
          stroke(255, 200, 0, 150);
          ellipse(location.x, location.y, 55, 55);
          image(resourceImage[itemType], location.x, location.y, 50, 50);
        } else image(resourceImageGray[itemType], location.x, location.y, 50, 50);
        break;
        
        case 1:
        imageMode(CENTER);
        if (T_satisfied) {
          noFill();
          strokeWeight(3);
          stroke(255, 200, 0, 150);
          ellipse(location.x, location.y, 58, 58);
          image(resourceImage[itemType], location.x, location.y, 55, 55);
        } else image(resourceImageGray[itemType], location.x, location.y, 55, 55);
        break;

      case 2:
      case 3:
      imageMode(CENTER);
        if (T_satisfied) {
          noFill();
          strokeWeight(3);
          stroke(255, 200, 0, 150);
          ellipse(location.x, location.y, 58, 58);
          image(resourceImage[itemType], location.x, location.y, 45, 45);
        } else image(resourceImageGray[itemType], location.x, location.y, 45, 45);
        break;

      default:
        textSize(15);
        textAlign(CENTER);
        if (T_satisfied) {
          noFill();
          strokeWeight(3);
          stroke(255, 200, 0, 150);
          ellipse(location.x, location.y, 55, 55);
          fill(255, 200, 0, 150);
        } else fill(200, 0, 0);
        text(resourceName[itemType], location.x, location.y);
        break;

      case 17: //pomegranate
        strokeWeight(1);
        stroke(238, 50, 51);
        noFill();

        star(location.x, location.y, 26, 30, 25);

        pushMatrix();
        imageMode(CENTER);
        image(pomegranateImage, location.x, location.y, 28, 28*(94/88));
        popMatrix();

        fill(237, 117, 117);
        textSize(9);
        textAlign(CENTER);
        PFont lineFont = createFont("Lucida Sans Demibold", 9);
        textFont(lineFont);
        text(str(itemReward).substring(0, 1), location.x-3, location.y-15);
        text(str(itemReward).substring(1), location.x+2, location.y-15);
        lineFont = createFont("Lucida Sans Regular", 9);
        textFont(lineFont);
        break;
      }
    } else {
      switch (itemType) {
      case 0:
      case 6:
      case 8:
      case 9:
      case 10:
      case 13:
        noFill();
        strokeWeight(3);
        stroke(0, 255, 255);
        ellipse(location.x, location.y, 55, 55);
        imageMode(CENTER);
        image(resourceImage[itemType], location.x, location.y, 50, 50);
        break;

      case 1:
        noFill();
        strokeWeight(3);
        stroke(0, 255, 255);
        ellipse(location.x, location.y, 58, 58);
        imageMode(CENTER);
        image(resourceImage[itemType], location.x, location.y, 55, 55);
        break;

      case 2:
        noFill();
        strokeWeight(3);
        stroke(0, 255, 255);
        ellipse(location.x, location.y, 58, 58);
        imageMode(CENTER);
        image(resourceImage[itemType], location.x+2, location.y+2, 45, 45);
        break;

      case 3:
        noFill();
        strokeWeight(3);
        stroke(0, 255, 255);
        ellipse(location.x, location.y, 58, 58);
        imageMode(CENTER);
        image(resourceImage[itemType], location.x+2, location.y, 45, 45);
        break;

      case 11:
        noFill();
        strokeWeight(3);
        stroke(0, 255, 255);
        ellipse(location.x, location.y, 55, 55);
        imageMode(CENTER);
        image(resourceImage[itemType], location.x-2, location.y+2, 42, 42);
        break;

      case 4:
        noFill();
        strokeWeight(3);
        stroke(0, 255, 255);
        ellipse(location.x, location.y, 55, 55);
        imageMode(CENTER);
        image(resourceImage[itemType], location.x+1, location.y-1, 40, 40);
        break;

      case 5:
      case 12:
      case 14:
        noFill();
        strokeWeight(3);
        stroke(0, 255, 255);
        ellipse(location.x, location.y, 55, 55);
        imageMode(CENTER);
        image(resourceImage[itemType], location.x, location.y, 40, 40);
        break;

      default:
        noFill();
        strokeWeight(3);
        stroke(0, 255, 255);
        ellipse(location.x, location.y, 55, 55);
        textSize(15);
        fill(0);
        textAlign(CENTER);
        text(resourceName[itemType], location.x, location.y);
        break;

      case 17: //pomegranate
        strokeWeight(1);
        stroke(238, 50, 51);
        noFill();

        star(location.x, location.y, 26, 30, 25);

        pushMatrix();
        imageMode(CENTER);
        image(pomegranateImage, location.x, location.y, 28, 28*(94/88));
        popMatrix();

        fill(237, 117, 117);
        textSize(9);
        textAlign(CENTER);
        PFont lineFont = createFont("Lucida Sans Demibold", 9);
        textFont(lineFont);
        text(str(itemReward).substring(0, 1), location.x-3, location.y-15);
        text(str(itemReward).substring(1), location.x+2, location.y-15);
        lineFont = createFont("Lucida Sans Regular", 9);
        textFont(lineFont);
        break;
      }
    }
  }

  PVector getLocation() { 
    return location;
  }

  int getItemType() {
    return itemType;
  }

  int getItemReward() {
    return itemReward;
  }

  boolean getT_satisfied() {
    return T_satisfied;
  }
}

PImage[] resourceImage = new PImage[resourceName.length];
PImage[] resourceImageGray = new PImage[resourceName.length];
ArrayList<ItemSpawn> resourceAppear = new ArrayList<ItemSpawn>();
class Resource {
  PVector location = new PVector(width/2, height/2);
  int resourceType = -1;
  String name = "missingName";

  Resource(int type) {
    resourceType = type;
    name = resourceName[type];
  }

  void updateLocation(float x, float y) {
    location = new PVector(x, y);
  }

  float blockSize = (650 - 10*2 - 10*5)/5;
  void showItem() {
    imageMode(CENTER);
    switch (resourceType) {
    case 0:
    case 1:
    case 2:
    case 3:
    case 4:
    case 5:
    case 6:
    case 8:
    case 9:
    case 10:
    case 11:
    case 12:
    case 13:
    case 14:
      image(resourceImage[resourceType], location.x, location.y, blockSize*0.75, blockSize*0.75);
      break;

    default:
      fill(0);
      textAlign(CENTER);
      text(name, location.x, location.y);
      break;
    }
  }

  int getType() {
    return resourceType;
  }
}

long resourceAppearTimer = ROUND_TIME*2 + (int)random(180000); //guarantee first 2 rounds wont appear
void spawnResource() {
  //if (debug) println("Resource will spawn in: " + resourceAppearTimer/1000 + "s");
  resourceAppearTimer -= timePassed;

  if (resourceAppearTimer <= 0) {
    int rnd = (int)random(16);
    while (rnd == 6 || rnd == 7 || rnd == 15) rnd = (int)random(16);
    resourceAppear.add(new ItemSpawn(rnd));

    resourceAppearTimer = ROUND_TIME - int(5*1000*(random(forestType)+1)*(random(forestType)+1));
    resourceAppearTimer = (int)constrain(resourceAppearTimer, ROUND_TIME/3, ROUND_TIME);
  }
}