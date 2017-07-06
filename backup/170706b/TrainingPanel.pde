Button showGuardianTrainBtn;
Button showBeeTrainBtn;
Button GTMarketBtn, GTPurchase, GTSell;
Button BTMarketBtn, BTPurchase, BTSell;

int GTObjectiveAddAmount = -1;
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
  for (Firefly ff : trainingFireflies) {
    ff.showFirefly();
    ff.move();
  }
}

void guardianTrainMechanicRun(boolean showText) {
  switch (GTSelected) {
  case 0: //Royal Guardian
    if (trainingFireflies.size() < 5 && GTObjectiveAddAmount > 0) {
      trainingFireflies.add(new Firefly(true));
      GTObjectiveAddAmount--;
    }

    if (roundTime >= upgradeGuardianCost[GTSelected][1]*ROUND_TIME) { //failed
      fill(0);
      textSize(100);
      textAlign(CENTER);
      if (showText) text("FAILED...", width/2, height/2);
      textSize(30);
      if (showText) text("Your Super Guardian has died of fatigue.", width/2, height/2+80);
    } else if (trainingFireflies.size() == 0) { //success
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
        if (showText) text("WARNING: " + upgradedGuardianName[GTSelected] + " will be KILLED if it is still not delivered in this week!", width/2, height/2+130);
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
    break;
  }
}