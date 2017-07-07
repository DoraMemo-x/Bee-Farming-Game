Button showGuardianTrainBtn;
Button showBeeTrainBtn;
Button GTMarketBtn, GTPurchase, GTSell;
Button BTMarketBtn, BTPurchase, BTSell;

int GTObjectiveAddAmount = -1; //used for Royal Guardian (Fireflies count)
long GTObjectiveTime = 0; //used for Baiting Guardian (Time spent next to flowers)
static final int GTObjectiveTimeRequired = (int)ROUND_TIME/2;
//long GTObjTimer = gameMillis, pGTObjTimer = gameMillis; //used for Baiting Guardian (technical)
long trainingFadeOutTimer = 0;
boolean TFOTConfirmed = false; //trainingFadeOutTimer

void guardianTrainDisplayRun() {
  if (trainingFadeOutTimer == 0) background(235, 235, 255);
  else background(map(gameMillis, trainingFadeOutTimer, trainingFadeOutTimer+5000, 235, 255), map(gameMillis, trainingFadeOutTimer, trainingFadeOutTimer+5000, 235, 255), 255);


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
  trainingGuardian.move();
  switch (GTSelected) {
  case 0: //Royal Guardian
    for (Firefly ff : trainingFireflies) {
      ff.showFirefly();
      ff.move();
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

    fill((GTObjectiveTime >= GTObjectiveTimeRequired/2 ? map(GTObjectiveTime-GTObjectiveTimeRequired/2, 0, GTObjectiveTimeRequired, cos(0), cos(HALF_PI)) : 1)*255, map(GTObjectiveTime, 0, GTObjectiveTimeRequired/2, sin(0), sin(HALF_PI))*255, 0); //R & G is the sin & cos relationship
    rect(175.5, height-34.5, constrain(map(GTObjectiveTime, 0, GTObjectiveTimeRequired, 0, 399.5), 0, 399.5), 24.5);
    break;
  }
}

boolean GTSuccessConditionMatch = false;

void guardianTrainMechanicRun(boolean showText) {
  switch (GTSelected) {
  case 0: //Royal Guardian
    if (trainingFireflies.size() < 5 && GTObjectiveAddAmount > 0) {
      trainingFireflies.add(new Firefly(true));
      GTObjectiveAddAmount--;
    }
    
    if (trainingFireflies.size() == 0) GTSuccessConditionMatch = true;
    break;

  case 1: //Baiting Guardian
    if (GTObjectiveTime >= GTObjectiveTimeRequired) GTSuccessConditionMatch = true;
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