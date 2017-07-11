import java.util.Collections;
import java.util.Arrays;
import java.util.Comparator;
import java.util.List;

Button showGuardianTrainBtn;
Button showBeeTrainBtn;
Button GTMarketBtn, GTPurchase, GTSell;
Button BTMarketBtn, BTPurchase, BTSell;

CircleButton GTObjCancel;

int GTObjectiveAddAmount = -1; //used for Royal Guardian (Fireflies count)
long GTObjectiveTime = 0; //used for Baiting Guardian (Time spent next to flowers) ; Hunting Guardian (how long the trail lasts)
int GTObjectiveTimeRequired = 0; //for Baiting Guardian (time needed to spend next to flowers) ; Hunting Guardian (how long the trail lasts)
boolean GTObjectToggle = false; //Hunting Guardian (toggle trail)
float GTObjectiveScore = 0; //Hunting Guardian (Points scored for catching creatures)
float GTObjectUsed = 0; //Hunting Guardian (trail)
int GTObjectLimit = 0; //Hunting Guardian (trail)
ArrayList<float[]> pos = new ArrayList(); //Hunting Guardian Course (trail)
List<ArrayList<String>> dotPos = new ArrayList<ArrayList<String>>(); //Hunting Guardian Course (trail)

int GTObjectiveScoreRequired = 0; 
long trainingFadeOutTimer = 0;
boolean TFOTConfirmed = false; //trainingFadeOutTimer

void guardianTrainDisplayRun() {
  if (trainingFadeOutTimer == 0) background(235, 235, 255);
  else background(map(gameMillis, trainingFadeOutTimer, trainingFadeOutTimer+5000, 235, 255), map(gameMillis, trainingFadeOutTimer, trainingFadeOutTimer+5000, 235, 255), 255);

  resetButtonPos();

  showForestBtn.Draw();



  fill(0);
  textSize(12);
  textAlign(LEFT);
  text("Training Time: ", 20, height-20);
  strokeWeight(1);
  stroke(135, 135, 255);
  noFill();
  ellipse(130, height-24, 26, 26);
  fill(135, 135, 255);
  arc(130, height-24, 26, 26, -HALF_PI, map(roundTime, 0, upgradeGuardianCost[GTSelected][1]*ROUND_TIME, -HALF_PI, PI+HALF_PI), PIE); 

  trainingGuardian.showGuardian();
  //trainingGuardian.move();
  switch (GTSelected) {
  case 0: //Royal Guardian
    for (Firefly ff : trainingFireflies) {
      ff.showFirefly();
      //ff.move();
    }
    break;

  case 1: //baiting guardian
    for (Flower tf : trainingFlowers) {
      tf.showFlower();
    }

    fill(0);
    textSize(10);
    textAlign(CENTER);
    text("Time spent near flowers (Progress Bar):", 375, height-45);
    noFill();
    strokeWeight(1);
    stroke(100);
    rect(175, height-35, 400, 25);

    fill((GTObjectiveTime >= GTObjectiveTimeRequired/2 ? map(GTObjectiveTime-GTObjectiveTimeRequired/2, 0, GTObjectiveTimeRequired/2, cos(0), cos(HALF_PI)) : 1)*255, map(GTObjectiveTime, 0, GTObjectiveTimeRequired/2, sin(0), sin(HALF_PI))*255, 0); //R & G is the sin & cos relationship
    rect(175.5, height-34.5, constrain(map(GTObjectiveTime, 0, GTObjectiveTimeRequired, 0, 399.5), 0, 399.5), 24.5);
    break;

  case 2: //hunting guardian
    //if (dotPos.size() == 0)

    GTObjCancel.Draw();

    for (Firefly ff : trainingFireflies) ff.showFirefly();
    for (Hornet h : trainingHornets) h.showHornet();
    for (Ladybug lb : trainingLadybugs) lb.showLadybug();

    fill(0);
    textSize(10);
    textAlign(CENTER);
    text("Score obtained by trapping creatures (Progress Bar):", 375, height-45);
    noFill();
    strokeWeight(1);
    stroke(100);
    rect(175, height-35, 400, 25);

    fill((GTObjectiveScore >= GTObjectiveScoreRequired/2 ? map(GTObjectiveScore-GTObjectiveScoreRequired/2, 0, GTObjectiveScoreRequired/2, cos(0), cos(HALF_PI)) : 1)*255, map(GTObjectiveScore, 0, GTObjectiveScoreRequired/2, sin(0), sin(HALF_PI))*255, 0); //R & G is the sin & cos relationship
    rect(175.5, height-34.5, constrain(map(GTObjectiveScore, 0, GTObjectiveScoreRequired, 0, 399.5), 0, 399.5), 24.5);

    fill(100);
    textSize(12);
    textAlign(LEFT);
    text((int)GTObjectiveScore + " / " + GTObjectiveScoreRequired, 185, height-18);

    if (mousePressed) {
      GTObjectToggle = true;
    }

    if (pos.size() == 0) GTObjCancel.updateGreyOut(true);
    else GTObjCancel.updateGreyOut(false);

    if (pos.size() >= 2 && GTObjectUsed < GTObjectLimit) {
      //display the circled area
      strokeWeight(1);
      stroke(map(GTObjectUsed, 0, GTObjectLimit/2, sin(0), sin(HALF_PI))*255, (GTObjectUsed >= GTObjectLimit/2 ? map(GTObjectUsed-GTObjectLimit/2, 0, GTObjectLimit/2, cos(0), cos(HALF_PI)) : 1)*255, 0);
      for (int i = pos.size()-2; i >= 0; i--) {
        line(pos.get(i)[0], pos.get(i)[1], pos.get(i+1)[0], pos.get(i+1)[1]);
      }
    }

    if (GTObjectToggle && GTObjectUsed < GTObjectLimit) {
      //line(mouseX, mouseY, pmouseX, pmouseY);
      GTObjectUsed += distance_between_two_points(mouseX, pmouseX, mouseY, pmouseY);
      pos.add(new float[] {mouseX, mouseY});
      //println(trailUsed);
    } else if (GTObjectUsed >= GTObjectLimit) {
      //toggle off the trail drawing ability
      GTObjectToggle = false;

      //CONFIRM display the circled area
      strokeWeight(2);
      stroke(255, 0, 0, map(GTObjectiveTime, 0, GTObjectiveTimeRequired, 255, 0));
      for (int i = pos.size()-2; i >= 0; i--) {
        line(pos.get(i)[0], pos.get(i)[1], pos.get(i+1)[0], pos.get(i+1)[1]);
        if (i == pos.size()-2) line(pos.get(0)[0], pos.get(0)[1], pos.get(pos.size()-1)[0], pos.get(pos.size()-1)[1]);
      }


      //cut the line into dots (only runs once)
      if (dotPos.size() == 0) {
        for (int i = pos.size()-2; i >= 0; i--) {
          float x1 = pos.get(i)[0], y1 = pos.get(i)[1];
          float x2 = pos.get(i+1)[0], y2 = pos.get(i+1)[1];
          float slope = (y2-y1)/(x2-x1);
          //println(slope, (y2-y1) + "/" + (x2-x1));

          //stroke(255, 0, 0);
          for (int x = ceil(min(x1, x2)); x < floor(max(x1, x2)); x++) {
            float y = slope*(x-x1) + y1;
            dotPos.add(new ArrayList<String>(Arrays.asList(str(x), str(y))));
            //point(x, y+150);
          }
          //stroke(0, 255, 0);
          for (int y = ceil(min(y1, y2)); y < floor(max(y1, y2)); y++) {
            float x = (y-y1)/slope + x1;
            dotPos.add(new ArrayList<String>(Arrays.asList(str(x), str(y))));
            //point(x+150, y);
          }
        }
        float x1 = pos.get(0)[0], y1 = pos.get(0)[1];
        float x2 = pos.get(pos.size()-1)[0], y2 = pos.get(pos.size()-1)[1];
        float slope = (y2-y1)/(x2-x1);

        //stroke(255, 0, 0);
        for (int x = ceil(min(x1, x2)); x < floor(max(x1, x2)); x++) {
          float y = slope*(x-x1) + y1;
          dotPos.add(new ArrayList<String>(Arrays.asList(str(x), str(y))));
          //point(x, y+150);
        }
        //stroke(0, 255, 0);
        for (int y = ceil(min(y1, y2)); y < floor(max(y1, y2)); y++) {
          float x = (y-y1)/slope + x1;
          dotPos.add(new ArrayList<String>(Arrays.asList(str(x), str(y))));
          //point(x+150, y);
        }
      }
    }
    break;
  }
}

boolean GTSuccessConditionMatch = false;

void guardianTrainMechanicRun(boolean showText) {
  trainingGuardian.move();

  switch (GTSelected) {   
  case 0: //Royal Guardian
    for (Firefly ff : trainingFireflies) ff.move();

    if (trainingFireflies.size() < 5 && GTObjectiveAddAmount > 0) {
      trainingFireflies.add(new Firefly(true));
      GTObjectiveAddAmount--;
    }

    if (trainingFireflies.size() == 0) GTSuccessConditionMatch = true;
    break;

  case 1: //Baiting Guardian
    if (GTObjectiveTime >= GTObjectiveTimeRequired) GTSuccessConditionMatch = true;
    break;

  case 2: //Hunting Guardian
    for (Firefly ff : trainingFireflies) ff.move();
    for (Hornet h : trainingHornets) h.move();
    for (Ladybug lb : trainingLadybugs) lb.move();

    if (trainingFireflies.size() < 3) trainingFireflies.add(new Firefly(true));
    if (trainingHornets.size() < 4) trainingHornets.add(new Hornet(0, true));
    if (trainingLadybugs.size() < 3) trainingLadybugs.add(new Ladybug(true));

    if (keyPressed && (key == 'c' || key == 'C')) {
      pos = new ArrayList();
      dotPos = new ArrayList<ArrayList<String>>();

      GTObjectUsed = 0;
      GTObjectToggle = false;
      GTObjectiveTime = 0;
    }

    PVector guardianCoords = trainingGuardian.getLocation();
    if (checkWithinShape(guardianCoords.x, guardianCoords.y) == true && GTObjectiveTime <= GTObjectiveTimeRequired) {
      GTObjectiveTime += (timeMillis-pMillis);

      trainingGuardian.updateSpeed(guardianFlightSpeed[1]/3);
      //println(frameCount + " / SPEED: "+trainingGuardian.getSpeed());

      PVector coordinates[] = new PVector[trainingFireflies.size() + trainingHornets.size() + trainingLadybugs.size()];
      int tfRemoved = 0, thRemoved = 0, tlbRemoved = 0;
      for (int i = 0; i < coordinates.length; i++) {

        if (i < trainingFireflies.size()) coordinates[i] = trainingFireflies.get(i -tfRemoved).getLocation();
        else if (i < trainingFireflies.size() + trainingHornets.size()) coordinates[i] = trainingHornets.get(i-trainingFireflies.size() -thRemoved).getLocation();
        else if (i < trainingFireflies.size() + trainingHornets.size() + trainingLadybugs.size()) coordinates[i] = trainingLadybugs.get(i-trainingFireflies.size()-trainingHornets.size() -tlbRemoved).getLocation();
        else continue;

        float _COORx = coordinates[i].x, _COORy = coordinates[i].y;
        if (checkWithinShape(_COORx, _COORy)) {
          if (i < trainingFireflies.size()) {
            println("Firefly within");
            GTObjectiveScore += 5;
            println(GTObjectiveScore);
            GTObjectiveScore = constrain(GTObjectiveScore, 0, GTObjectiveScoreRequired);
            trainingFireflies.remove(i -tfRemoved);
            tfRemoved++;
          } else if (i < trainingFireflies.size() + trainingHornets.size()) {
            println("Hornet within"); 
            GTObjectiveScore += 3;
            println(GTObjectiveScore);
            GTObjectiveScore = constrain(GTObjectiveScore, 0, GTObjectiveScoreRequired);
            trainingHornets.remove(i-trainingFireflies.size() -thRemoved);
            thRemoved++;
          } else if (i < trainingFireflies.size() + trainingHornets.size() + trainingLadybugs.size()) {
            println("Ladybug within");
            GTObjectiveScore -= 2;
            println(GTObjectiveScore);
            GTObjectiveScore = constrain(GTObjectiveScore, 0, GTObjectiveScoreRequired);
            trainingLadybugs.remove(i-trainingFireflies.size()-trainingHornets.size() -tlbRemoved);
            tlbRemoved++;
          }
        }
      }
    } else if (GTObjectiveTime > GTObjectiveTimeRequired) {
      pos = new ArrayList();
      dotPos = new ArrayList<ArrayList<String>>();

      GTObjectUsed = 0;
      GTObjectToggle = false;
      GTObjectiveTime = 0;
    } else {
      trainingGuardian.updateSpeed(guardianFlightSpeed[1]);
      //println(frameCount + " / SPEED: "+trainingGuardian.getSpeed());
    }



    if (GTObjectiveScore >= GTObjectiveScoreRequired) GTSuccessConditionMatch = true;


    break;
  }

  if (roundTime >= upgradeGuardianCost[GTSelected][1]*ROUND_TIME) { //failed
    fill(0);
    textSize(100);
    textAlign(CENTER);
    if (showText) text("FAILED...", width/2, height/2);
    textSize(30);
    if (showText) text("Your Super Guardian has died of fatigue.", width/2, height/2+80);
  } else if (GTSuccessConditionMatch) { //success
    if (TFOTConfirmed == false) {
      TFOTConfirmed = true;
      trainingFadeOutTimer = gameMillis;
    }
    fill(0);
    textSize(100);
    textAlign(CENTER);
    if (showText) text("COMPLETED!", width/2, height/2);
    if (beesCount < beehiveSize[beehiveTier]) {
      textSize(30);
      if (showText) text(upgradedGuardianName[GTSelected] + " will be delivered in: " + ((5000+trainingFadeOutTimer-gameMillis)/1000) + " seconds", width/2, height/2+80);
    } else {
      textSize(18);
      fill(255, 50, 50);
      if (showText) text(upgradedGuardianName[GTSelected] + " cannot be delivered due to occupied beehive!", width/2, height/2+80);
      if (showText) text(upgradedGuardianName[GTSelected] + " will be delivered once your beehive is not full.", width/2, height/2+105);
      fill(255, 0, 0);
      if (showText) text("WARNING: " + upgradedGuardianName[GTSelected] + " will be KILLED if it is still not delivered within this week!", width/2, height/2+130);
    }

    if (gameMillis - trainingFadeOutTimer > 5000) {
      if (beesCount < beehiveSize[beehiveTier]) {
        guardians.add(new Guardian(upgradedGuardianName[GTSelected]));
        trainingFadeOutTimer = gameMillis;
        GTSelected = -1;
        GTOngoing = false;
        screenDisable();
        gameScreenActive = true;
      } else {
        //do nothing.
        //wait until the beehive occupancy is lower
      }
    }
  }
}

void guardianTrainClickEvents() {
  //hunting guardian (2)
  if (GTObjCancel.MouseClicked()) {
    pos = new ArrayList();
    dotPos = new ArrayList<ArrayList<String>>();

    GTObjectUsed = 0;
    GTObjectToggle = false;
    GTObjectiveTime = 0;
  }

  float gx = trainingGuardian.getLocation().x;
  float gy = trainingGuardian.getLocation().y;

  int selectedFireflyID = -1;
  if (mouseX > gx-25 && mouseX < gx+25 && mouseY > gy-25 && mouseY < gy+25) {
    if (trainingGuardian.getGuardianSelectedStatus() == false) trainingGuardian.updateGuardianSelectedStatus(true); //selected the guardian
    else trainingGuardian.updateGuardianSelectedStatus(false); //deselect the guardian
  } else if (trainingGuardian.getGuardianSelectedStatus() == true) { //if the guardian is selected (the only situation that it can be assigned a target)
    switch (GTSelected) {
    case 0: //Royal Guardian
      for (int ff = trainingFireflies.size ()-1; ff >= 0; ff--) {
        Firefly _firefly = trainingFireflies.get(ff);
        float ffx = _firefly.getLocation().x;
        float ffy = _firefly.getLocation().y;

        if (mouseX > ffx-15 && mouseX < ffx+15 && mouseY > ffy-15 && mouseY < ffy+15) {
          trainingGuardian.updateGuardianSelectedStatus(false);
          //tapped a firefly. not selected yet
          _firefly.minusFireflyTap();
          _firefly.updateFireflyMoveTimer(gameMillis);

          if (_firefly.getFireflyTap() == 0) {
            selectedFireflyID = ff;
            float _thetaRad = calcMoveTheta(ffx, ffy, gx, gy);

            trainingGuardian.updateGuardianSelectedStatus(false);
            trainingGuardian.updateMoveTheta(_thetaRad);
            trainingGuardian.updateGuardianMoveTimer(gameMillis);

            trainingGuardian.selectTarget(ff);
            trainingGuardian.updateGuardianTimeoutMove(false);
          }
        }
      }
      break;

    case 1: //baiting guardian
      boolean selectedFlower = false;

      for (int tf = trainingFlowers.size ()-1; tf >= 0; tf--) {
        Flower _tf = trainingFlowers.get(tf);
        float tfx = _tf.getLocation().x;
        float tfy = _tf.getLocation().y;

        if (mouseX > tfx-15 && mouseX < tfx+15 && mouseY > tfy-15 && mouseY < tfy+15) {
          trainingGuardian.updateGuardianSelectedStatus(false);
          trainingGuardian.updateGuardianMoveTimer(gameMillis);

          trainingGuardian.selectTarget(tf);
          trainingGuardian.updateGuardianTimeoutMove(false);

          selectedFlower = true;

          break;
        }
      }

      if (selectedFlower == false) { // didnt select a flower. go to mouse direction
        float _thetaRad = calcMoveTheta(mouseX, mouseY, gx, gy);
        trainingGuardian.updateMoveTheta(_thetaRad);

        trainingGuardian.updateGuardianSelectedStatus(false);
        trainingGuardian.updateGuardianMoveTimer(gameMillis);
      }
      break;

    case 2: //hunting guardian
      float _thetaRad = calcMoveTheta(mouseX, mouseY, gx, gy);
      trainingGuardian.updateMoveTheta(_thetaRad);

      trainingGuardian.updateGuardianSelectedStatus(false);
      trainingGuardian.updateGuardianMoveTimer(gameMillis);
      break;
    }
  } else {
    switch (GTSelected) {
    case 2: //hunting guardian
      if (GTObjCancel.MouseClicked() == false) {
        float _thetaRad = calcMoveTheta(mouseX, mouseY, gx, gy);
        trainingGuardian.updateMoveTheta(_thetaRad);

        trainingGuardian.updateGuardianSelectedStatus(false);
        trainingGuardian.updateGuardianMoveTimer(gameMillis);
      }
      break;
    }
  }
}




void sortArrayList1() {  //sort by first element
  Collections.sort(dotPos, new Comparator<ArrayList<String>>() {    
    public int compare(ArrayList<String> o1, ArrayList<String> o2) {
      String x1 = o1.get(0), x2 = o2.get(0);
      return x1.compareTo(x2);
    }
  }
  );
}

void sortArrayList2() {  //sort by second element
  Collections.sort(dotPos, new Comparator<ArrayList<String>>() {    
    public int compare(ArrayList<String> o1, ArrayList<String> o2) {
      String x1 = o1.get(1), x2 = o2.get(1);
      return x1.compareTo(x2);
    }
  }
  );
}

boolean checkWithinShape(float COORx, float COORy) {
  boolean xValid = false;
  boolean yValid = false;

  sortArrayList1();
  for (int i = dotPos.size()-2; i >= 0; i--) {
    List<String> positions1 = dotPos.get(i);
    PVector pos1 = new PVector(float(positions1.get(0)), float(positions1.get(1)));
    List<String> positions2 = dotPos.get(i+1);
    PVector pos2 = new PVector(float(positions2.get(0)), float(positions2.get(1)));

    if (pos1.x == pos2.x) {
      if (COORx > pos1.x-0.5 && COORx < pos1.x+0.5) {
        if (COORy > min(pos1.y, pos2.y)   &&   COORy < max(pos1.y, pos2.y)) {
          //stroke(255);
          //line(pos1.x, pos1.y, pos2.x, pos2.y);
          //stroke(255, 0, 0);
          //point(COORx, COORy);

          yValid = true;
          break;
        } else continue;
      } else continue;
    } else continue;
  }

  sortArrayList2();
  for (int i = dotPos.size()-2; i >= 0; i--) {
    List<String> positions1 = dotPos.get(i);
    PVector pos1 = new PVector(float(positions1.get(0)), float(positions1.get(1)));
    List<String> positions2 = dotPos.get(i+1);
    PVector pos2 = new PVector(float(positions2.get(0)), float(positions2.get(1)));

    if (pos1.y == pos2.y) {
      if (COORy > pos1.y-0.5 && COORy < pos1.y+0.5) {
        if (COORx > min(pos1.x, pos2.x)   &&   COORx < max(pos1.x, pos2.x)) {
          xValid = true;
          break;
        } else continue;
      } else continue;
    } else continue;
  }

  if (xValid && yValid) return true;
  else return false;
}