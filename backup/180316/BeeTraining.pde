Button BTMarketBtn, BTPurchase;
Button[] BTAbility = new Button[2]; //holy branch ability for priest bee
threeDButton[] BTAbility2 = new threeDButton[6]; //gardening bee "modes"

long BTObjectiveTime = 0;
int BTObjectiveTier = 0;
float BTObjectiveScore = 0;
int BTObjectiveScoreRequired = 0;
int BTAbilityCharge = 1; //for priest bee (how many holy branch picked up *initially have 1 for the player to experience*) ; for Gardening Bee (mode selection)

long BTFadeOutTimer = 0;
boolean BTFOTConfirmed = false; //BeeTrainingFadeOutTimer. a boolean used for confirming we have starting the fadeOutTimer
int BTCounter = 0;

boolean BTSuccessConditionMatch = false;
boolean BTFailed = false;

boolean[] BTCheck = {false, false, false}; //for priest bee (the holy triangle)
float[][] BTHolyPos = new float[6][2]; //6 possible positions, 2 for x and y
int BTSatisfied = 0; //for priest bee
int[] BTHolyWaterIndex = {-1, -1}; //for priest bee (which index is holy water in the BTHolyPos arrayList)
boolean[] BTHolyWaterShattered = {false, false};

ArrayList<Plot> BTPlots = new ArrayList<Plot>();
ArrayList<Pest> BTPest = new ArrayList<Pest>();
PVector[][] BTPlotLocation = new PVector[4][2]; //x y
boolean BTisDay = true;
PImage[] BTFlowerStage = new PImage[7];
PImage[] BTDryFlowerStage = new PImage[7];
PImage BTFertilizer = new PImage();
PImage BTCrackedPattern = new PImage();

TrainingBee beeProjection;

void beeTrainDisplayRun() {
  if (BTFadeOutTimer == 0) background(235, 235, 255);
  else background(map(gameMillis, BTFadeOutTimer, BTFadeOutTimer+5000, 235, 255), map(gameMillis, BTFadeOutTimer, BTFadeOutTimer+5000, 235, 255), 255);

  resetButtonPos();

  if (BTSelected != 2) {//gardening bee draws background in the switch case block
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
    arc(130, height-24, 26, 26, -HALF_PI, map(roundTime, 0, ROUND_TIME, -HALF_PI, PI+HALF_PI), PIE);

    trainingBee.showBee();
  }



  switch (BTSelected) {
  case 0: //Priest Bee
    float bx = trainingBee.getLocation().x, by = trainingBee.getLocation().y;
    float radius = trainingBee.getPriestRange()/2;
    float moveTheta = calcMoveTheta(mouseX, mouseY, bx+0.1, by); //+0.1 to prevent division by zero - if player doesnt move mouse
    if (BTConfirmed == false) {
      beeProjection.updateMoveTheta(moveTheta);

      if (distance_between_two_points(bx, mouseX, by, mouseY) < radius) beeProjection.updateLocation(mouseX, mouseY);
      else {
        float newX = radius*cos(moveTheta), newY = -radius*sin(moveTheta);
        beeProjection.updateLocation(bx+newX, by+newY);
      }
    }
    beeProjection.showBee();

    for (Satanic st : BTDemons) st.show();
    for (ItemSpawn is : BTItems) is.showItem();

    stroke(238, 238, 0);
    fill(#0b3b03, 100);
    beginShape();
    for (int i = 0; i < min(BTSatisfied, 3); i++) {
      if (BTHolyPos[i][0] == -1) continue; //not taken, connect the other points
      vertex(BTHolyPos[i][0], BTHolyPos[i][1]);
    }
    if (BTHolyWaterShattered[0] == false && BTSatisfied >= 3) vertex(BTHolyPos[0][0], BTHolyPos[0][1]);
    endShape();
    if (BTSatisfied > 3) {
      beginShape();
      for (int i = 3; i < min(BTSatisfied, 6); i++) {
        if (BTHolyPos[i][0] == -1) continue; //not taken, connect the other points
        vertex(BTHolyPos[i][0], BTHolyPos[i][1]);
      }
      if (BTHolyWaterShattered[1] == false && BTSatisfied == 6) vertex(BTHolyPos[3][0], BTHolyPos[3][1]);
      endShape();
    }


    if (BTAbilityCharge == 0) {
      BTAbility[0].updateGreyOut(true);
      BTAbility[1].updateGreyOut(true);
    } else {
      BTAbility[0].updateGreyOut(false);
      BTAbility[1].updateGreyOut(false);
    }
    BTAbility[0].Draw();
    BTAbility[1].Draw();

    textAlign(LEFT);
    fill(0, 100, 0);
    text("Powerup Available: " + BTAbilityCharge, 160+80*2+15, height-22);

    if (BTDemons.size() > 0) {
      if (BTDemons.get(0).getChangeSpeedDuration() != 0) { //that means "SLOW" ability is active
        rectMode(CORNER);
        strokeWeight(1);
        stroke(50);
        noFill();
        rect(160+10, height-50-5, 60, 6);

        rectMode(CORNERS);
        noStroke();
        fill(0, 150, 0);
        rect(160+10.25, height-50-4.75, map(BTDemons.get(0).getChangeSpeedDuration(), 15000, 0, 160+10.25+60, 160+10.25), height-50-4.75+6);
        rectMode(CORNER);
      }
      if (trainingBee.getChangeRangeDuration() != 0) { //that means "INCREASE RANGE" ability is active
        rectMode(CORNER);
        strokeWeight(1);
        stroke(50);
        noFill();
        rect(160+80+5+10, height-50-5, 60, 6);

        rectMode(CORNERS);
        noStroke();
        fill(0, 150, 0);
        rect(160+80+5+10.25, height-50-4.75, map(trainingBee.getChangeRangeDuration(), 12000, 0, 160+80+5+10.25+60, 160+80+5+10.25), height-50-4.75+6);
        rectMode(CORNER);
      }
    }

    String[][] explanation = {{"Enemy speed is halved for 15 seconds.", "* Stacking refreshes timer and enhances the effect"}, {"Range of bee is increased by 50% for 12 seconds.", "* Stacking refreshes timer and enhances the effect"}};
    for (int i = 0; i < 2; i++) {
      if (BTAbility[i].getMouseIsOver()) {
        drawPopupWindow(explanation[i], 0, 12, mouseX, mouseY-50, true, 0, width);
      }
    }

    for (int i = 0; i < BTSatisfied; i++) {
      fill(0);
      textAlign(CENTER);
      textSize(10);
      text(i, BTHolyPos[i][0], BTHolyPos[i][1]-20);
    }
    break;

  case 2: //Gardening Bee
    float plotSize = width/5;

    noStroke();
    rectMode(CORNER);
    if (BTisDay) fill(215-map(BTTimer, 0, ROUND_TIME/14, 0, 196), 232-map(BTTimer, 0, ROUND_TIME/14, 0, 208), 253-map(BTTimer, 0, ROUND_TIME/14, 0, 155)); //morning sky blue
    else fill(19+map(BTTimer, 0, ROUND_TIME/14, 0, 196), 24+map(BTTimer, 0, ROUND_TIME/14, 0, 208), 98+map(BTTimer, 0, ROUND_TIME/14, 0, 155)); //night sky blue
    rect(0, 30, width, height/4-plotSize/5);
    fill(#3B5323); //romaine lettuce (green)
    rect(0, 30+height/4-plotSize/5, width, height);

    showForestBtn.Draw();
    for (Plot p : BTPlots) p.showPlot();
    for (Pest p : BTPest) p.showPest();
    trainingBee.showBee();


    for (int i = 0; i < BTAbility2.length; i++) {
      if (BTAbilityCharge == i) BTAbility2[i].updateActive(true);
      else BTAbility2[i].updateActive(false);
      BTAbility2[i].Draw();
    }    

    fill((BTisDay && BTTimer > ROUND_TIME/14/2)||(BTisDay == false && BTTimer < ROUND_TIME/14/2) ? 255 : 0);
    textSize(11);
    textAlign(CENTER);
    text("Gardening Points:", width/2, 60);
    noFill();
    strokeWeight(1);
    stroke(100);
    rect(175, 75, 400, 25);
    int t1=0, t2=0, t3=0, t4=0; //t4 means success. end of the course
    if (BTObjectiveTier == 0) { //+0
      t1 = BTObjectiveScoreRequired;
      t2 = BTObjectiveScoreRequired+55; 
      t3 = BTObjectiveScoreRequired+55+55; 
      t4 = BTObjectiveScoreRequired+55+55+65;
    } else if (BTObjectiveTier == 1) { //+55
      t1 = BTObjectiveScoreRequired-55; 
      t2 = BTObjectiveScoreRequired; 
      t3 = BTObjectiveScoreRequired+55; 
      t4 = BTObjectiveScoreRequired+55+65;
    } else if (BTObjectiveTier == 2) { //+55
      t1 = BTObjectiveScoreRequired-55-55;
      t2 = BTObjectiveScoreRequired-55; 
      t3 = BTObjectiveScoreRequired; 
      t4 = BTObjectiveScoreRequired+65;
    } else if (BTObjectiveTier == 3 || BTSuccessConditionMatch) { //+65
      t1 = BTObjectiveScoreRequired-55-55-65; 
      t2 = BTObjectiveScoreRequired-55-65; 
      t3 = BTObjectiveScoreRequired-65; 
      t4 = BTObjectiveScoreRequired;
    }

    fill((BTObjectiveScore >= t4/2 ? map(BTObjectiveScore-t4/2, 0, t4/2, cos(0), cos(HALF_PI)) : 1)*255, map(BTObjectiveScore, 0, t4/2, sin(0), sin(HALF_PI))*255, 0); //R & G is the sin & cos relationship
    rect(175.5, 75.5, constrain(map(BTObjectiveScore, 0, t4, 0, 399.5), 0, 399.5), 24);

    fill((BTisDay && BTTimer > ROUND_TIME/14/2)||(BTisDay == false && BTTimer < ROUND_TIME/14/2) ? 255 : 0);
    textSize(8);
    text("Tier 1", 175.5+map(t1, 0, t4, 0, 400), 70);
    text("Tier 2", 175.5+map(t2, 0, t4, 0, 400), 70);
    text("Tier 3", 175.5+map(t3, 0, t4, 0, 400), 70);
    text("Tier 4", 175.5+400, 70);
    stroke(125);
    line(175.5+map(t1, 0, t4, 0, 400), 75, 175.5+map(t1, 0, t4, 0, 400), 75+25);
    line(175.5+map(t2, 0, t4, 0, 400), 75, 175.5+map(t2, 0, t4, 0, 400), 75+25);
    line(175.5+map(t3, 0, t4, 0, 400), 75, 175.5+map(t3, 0, t4, 0, 400), 75+25);

    fill(100);
    textSize(12);
    textAlign(LEFT);
    text((int)BTObjectiveScore + " / " + BTObjectiveScoreRequired, 185, 75+17);
    break;
  }
}



void beeTrainMechanicRun(boolean showText) {  
  trainingBee.move();

  switch (BTSelected) {
  case 0: //Priest Bee
    BTTimer += timePassed;

    BTSatisfied = 0;
    for (ItemSpawn is : BTItems) if (is.getT_satisfied()) BTSatisfied++;
    for (int i = 0; i < BTHolyWaterShattered.length; i++) if (BTHolyWaterShattered[i]) BTSatisfied++; //TESTING. MIGHT BE THE SOLUTION?

    if (BTHolyWaterShattered[0] || BTHolyWaterShattered[1]) {
      for (int i = 0; i < BTCheck.length; i++) BTCheck[i] = false;
    }

    if (BTHolyWaterShattered[0] == false && BTSatisfied == 3) { //formed a triangle
      for (int i = 0; i < BTCheck.length; i++) BTCheck[i] = false; //reset
    }

    for (int i = BTDemons.size()-1; i >= 0; i--) {
      Satanic st = BTDemons.get(i);
      st.move();
      int triangleZone = st.checkInZone();
      if (BTObjectiveTier <= 1 && (triangleZone == 0 || triangleZone == 1)) {
        for (ItemSpawn is : BTItems) {
          if (is.getLocation().x == BTHolyPos[BTHolyWaterIndex[triangleZone]][0]) is.updateT_satisfied(false);
        }
        BTHolyWaterShattered[triangleZone] = true;
        BTHolyPos[BTHolyWaterIndex[triangleZone]][0] = -1;
        BTHolyPos[BTHolyWaterIndex[triangleZone]][1] = -1;
        BTDemons.remove(i);
      } else if (triangleZone == 2 && BTObjectiveTier == 2) { //in devil stage, overlapping
        BTDemons.remove(i);
      }
    }

    if (BTDemons.size() == 0 && BTSuccessConditionMatch == false) { //cleared all demons in a wave (or stage)
      BTObjectiveTier++; //raise a wave
      if (BTObjectiveTier == 1) { //stage 2: 2 demons
        for (int i = 0; i < 2; i++) BTDemons.add(new Satanic(0, true));
      } else if (BTObjectiveTier == 2) { //stage 3: devil
        //reset everything
        BTItems = new ArrayList<ItemSpawn>();

        for (int i = 0; i < 3; i++) {
          for (int j = 0; j < 2; j++) {
            BTItems.add(new ItemSpawn(i));
            BTItems.get(BTItems.size()-1).updateForTraining(true);
          }
        }

        BTItems.get(0).updateLocation(width/2, height/2-150);
        BTItems.get(1).updateLocation(width/2+150, height/2-75);
        BTItems.get(2).updateLocation(width/2-150, height/2-75);
        BTItems.get(3).updateLocation(width/2+150, height/2+75);
        BTItems.get(4).updateLocation(width/2-150, height/2+75);
        BTItems.get(5).updateLocation(width/2, height/2+150);

        for (int i = 0; i < BTHolyPos.length; i++) {
          BTHolyPos[i][0] = -1;
          BTHolyPos[i][1] = -1;
        }
        for (int i = 0; i < BTCheck.length; i++) BTCheck[i] = false;

        BTDemons.add(new Satanic(1, true));
      } else if (BTObjectiveTier == 3) {
        BTSuccessConditionMatch = true; //finished training before the week ends
      }
    }

    if (BTTimer >= 5000 && BTFailed == false) {
      BTTimer = 0;
      BTConfirmed = false;
      float px = beeProjection.getLocation().x, py = beeProjection.getLocation().y;
      float moveTheta = beeProjection.getMoveTheta();
      trainingBee.updateLocation(px, py);
      trainingBee.updateMoveTheta(moveTheta);
    }




    if (BTFailed && BTObjectiveTier == 0 && roundTime < ROUND_TIME) { //died at first stage, before round ended
      if (BTFOTConfirmed == false) {
        BTFOTConfirmed = true;
        BTFadeOutTimer = gameMillis;
        noti.add(new Notification(12, color(200, 0, 0), 20, height-60, "You failed the "+upgradedBeeName[BTSelected]+" training course!", 4000, "Down Corner"));
      }

      fill(0);
      textSize(100);
      textAlign(CENTER);
      if (showText) text("FAILED...", width/2, height/2);
      textSize(30);
      if (showText) {
        text("A tier " + BTObjectiveTier + ' ' + upgradedBeeName[BTSelected], width/2, height/2+80);
        text("will be delivered in: " + ((5000+BTFadeOutTimer-gameMillis)/1000) + " seconds", width/2, height/2+110);
      }
      trainingBee.updateShouldBeeMove(false);

      if (gameMillis - BTFadeOutTimer > 5000) {
        resetBTVars();
        if (gameScreenActive == false) {
          screenDisable();
          gameScreenActive = true;
        }
      }
    } else if (BTFailed && BTObjectiveTier > 0 && roundTime < ROUND_TIME) { //died at second/third stage, before round ended
      if (BTFOTConfirmed == false) {
        BTFOTConfirmed = true;
        BTFadeOutTimer = gameMillis;
        noti.add(new Notification(12, color(200, 0, 0), 20, height-60, "You passed the "+upgradedBeeName[BTSelected]+" training course!", 4000, "Down Corner"));
      }

      fill(0);
      textSize(100);
      textAlign(CENTER);
      if (showText) text("SUCCESS!", width/2, height/2);
      if (beesCount < beehiveSize[beehiveTier]) {
        textSize(30);
        if (showText) {
          text("A tier " + BTObjectiveTier + ' ' + upgradedBeeName[BTSelected], width/2, height/2+80);
          text("will be delivered in: " + ((5000+BTFadeOutTimer-gameMillis)/1000) + " seconds", width/2, height/2+110);
        }
      } else {
        textSize(18);
        fill(255, 50, 50);
        if (showText) {
          text(upgradedBeeName[BTSelected] + " cannot be delivered due to occupied beehive!", width/2, height/2+80);
          text(upgradedBeeName[BTSelected] + " will be delivered once your beehive is not full.", width/2, height/2+1110);
          fill(255, 0, 0);
          text("WARNING: " + upgradedBeeName[BTSelected] + " will be KILLED if it is still not delivered within this week!", width/2, height/2+135);
        }
      }

      if (gameMillis - BTFadeOutTimer > 5000) {
        if (beesCount < beehiveSize[beehiveTier]) {
          trainingsCompleted++;
          bees.add(new Bee(BTSelected+beeName.length));
          inventoryBees.add(new Bee(BTSelected+beeName.length));
          inventoryBees.get(inventoryBees.size()-1).updateShouldBeeMove(false);
          inventoryBees.get(inventoryBees.size()-1).updateForShop(true);
          inventoryBees.get(inventoryBees.size()-1).updateMoveTheta(HALF_PI);
          resetBeeInvPositions();

          if (BTSelected == 0 || BTSelected == 2) bees.get(bees.size()-1).updateTier(BTObjectiveTier);

          BTFadeOutTimer = gameMillis;
          resetBTVars();
          screenDisable();
          gameScreenActive = true;
        } else {
          //do nothing.
          //wait until the beehive occupancy is lower
        }
      }
    }
    break;

  case 2: //Gardening Bee
    spawnPest();
    BTTimer += timePassed;

    if (BTTimer > ROUND_TIME/14) {
      BTCounter++;
      BTTimer = 0;
      BTisDay = BTCounter%2 == 1 ? true : false;
      //for (Plot p : BTPlots) p.updateIsDay(BTisDay);
    }

    for (Plot p : BTPlots) p.growPlant();
    for (Pest p : BTPest) p.movePest();

    float bx = trainingBee.getLocation().x, by = trainingBee.getLocation().y;
    switch (BTAbilityCharge) {
    case 0: //Plant
      for (int i = BTPlots.size()-1; i >= 0; i--) {
        Plot p = BTPlots.get(i);
        byte[] xy = p.getXY();
        if (bx > BTPlotLocation[xy[0]][xy[1]].x-width/10 && bx < BTPlotLocation[xy[0]][xy[1]].x+width/10 && by > BTPlotLocation[xy[0]][xy[1]].y-width/10 && by < BTPlotLocation[xy[0]][xy[1]].y+width/10) {
          p.plant(0);
        }
      }
      break;

    case 1: //Harvest
      for (int i = BTPlots.size()-1; i >= 0; i--) {
        Plot p = BTPlots.get(i);
        byte[] xy = p.getXY();
        if (p.returnHarvestable() && bx > BTPlotLocation[xy[0]][xy[1]].x-width/10 && bx < BTPlotLocation[xy[0]][xy[1]].x+width/10 && by > BTPlotLocation[xy[0]][xy[1]].y-width/10 && by < BTPlotLocation[xy[0]][xy[1]].y+width/10) {
          p.harvest();
        }
      }
      break;

    case 2: //Water
      for (int i = BTPlots.size()-1; i >= 0; i--) {
        Plot p = BTPlots.get(i);
        byte[] xy = p.getXY();
        if (bx > BTPlotLocation[xy[0]][xy[1]].x-width/10 && bx < BTPlotLocation[xy[0]][xy[1]].x+width/10 && by > BTPlotLocation[xy[0]][xy[1]].y-width/10 && by < BTPlotLocation[xy[0]][xy[1]].y+width/10) {
          p.water();
        }
      }
      break;

    case 3: //Fertilize
      for (int i = BTPlots.size()-1; i >= 0; i--) {
        Plot p = BTPlots.get(i);
        byte[] xy = p.getXY();
        if (bx > BTPlotLocation[xy[0]][xy[1]].x-width/10 && bx < BTPlotLocation[xy[0]][xy[1]].x+width/10 && by > BTPlotLocation[xy[0]][xy[1]].y-width/10 && by < BTPlotLocation[xy[0]][xy[1]].y+width/10) {
          p.fertilize();
        }
      }
      break;

    case 4: //Spray Pesticide
      for (int i = BTPlots.size()-1; i >= 0; i--) {
        Plot p = BTPlots.get(i);
        byte[] xy = p.getXY();
        if (bx > BTPlotLocation[xy[0]][xy[1]].x-width/10 && bx < BTPlotLocation[xy[0]][xy[1]].x+width/10 && by > BTPlotLocation[xy[0]][xy[1]].y-width/10 && by < BTPlotLocation[xy[0]][xy[1]].y+width/10) {
          for (int j = BTPest.size()-1; j >= 0; j--) {
            Pest pest = BTPest.get(j);
            if (pest.getXY()[0] == p.getXY()[0] && pest.getXY()[1] == p.getXY()[1]) {
              BTPest.remove(j);
            }
          }
        }
      }
      break;

    case 5: //Trim Leaves
      for (int i = BTPlots.size()-1; i >= 0; i--) {
        Plot p = BTPlots.get(i);
        byte[] xy = p.getXY();
        if (p.returnHarvestable() && bx > BTPlotLocation[xy[0]][xy[1]].x-width/10 && bx < BTPlotLocation[xy[0]][xy[1]].x+width/10 && by > BTPlotLocation[xy[0]][xy[1]].y-width/10 && by < BTPlotLocation[xy[0]][xy[1]].y+width/10) {
          p.trimLeaves();
        }
      }
      break;
    }

    if (BTObjectiveScore >= BTObjectiveScoreRequired) {
      if (BTObjectiveTier == 0) BTObjectiveScoreRequired += 55;
      else if (BTObjectiveTier == 1) BTObjectiveScoreRequired += 55;
      else if (BTObjectiveTier == 2) BTObjectiveScoreRequired += 65;
      else if (BTObjectiveTier == 3) BTSuccessConditionMatch = true;

      if (BTObjectiveTier < 4) BTObjectiveTier++;
    }
    break;
  }

  if (BTSuccessConditionMatch == false && roundTime >= ROUND_TIME) { //mostly failed. but if the training course has "tier system", then it might not be.
    if (BTObjectiveTier == 0) { //this is a fail
      fill(0);
      textSize(100);
      textAlign(CENTER);
      if (showText) text("FAILED...", width/2, height/2);
      textSize(30);
      if (showText) text("Your bee has died of fatigue.", width/2, height/2+80);
      trainingBee.updateShouldBeeMove(false);
    } else {
      if (BTFOTConfirmed == false) {
        BTFOTConfirmed = true;
        BTFadeOutTimer = gameMillis;
      }
      fill(0);
      textSize(100);
      textAlign(CENTER);
      if (showText) text("COMPLETED!", width/2, height/2);
      if (beesCount < beehiveSize[beehiveTier]) {
        textSize(30);
        if (showText) {
          if (BTSelected == 0 || BTSelected == 2) {
            text("A tier " + BTObjectiveTier + ' ' + upgradedBeeName[BTSelected], width/2, height/2+80);
            text("will be delivered in: " + ((5000+BTFadeOutTimer-gameMillis)/1000) + " seconds", width/2, height/2+110);
          }
          // else ...
        }
      } else {
        textSize(18);
        fill(255, 50, 50);
        if (showText) {
          text(upgradedBeeName[BTSelected] + " cannot be delivered due to occupied beehive!", width/2, height/2+80);
          text(upgradedBeeName[BTSelected] + " will be delivered once your beehive is not full.", width/2, height/2+1110);
          fill(255, 0, 0);
          text("WARNING: " + upgradedBeeName[BTSelected] + " will be KILLED if it is still not delivered within this week!", width/2, height/2+135);
        }
      }

      if (gameMillis - BTFadeOutTimer > 5000) {
        if (beesCount < beehiveSize[beehiveTier]) {
          trainingsCompleted++;
          bees.add(new Bee(BTSelected+beeName.length));
          inventoryBees.add(new Bee(BTSelected+beeName.length));
          inventoryBees.get(inventoryBees.size()-1).updateShouldBeeMove(false);
          inventoryBees.get(inventoryBees.size()-1).updateForShop(true);
          inventoryBees.get(inventoryBees.size()-1).updateMoveTheta(HALF_PI);
          resetBeeInvPositions();

          if (BTSelected == 0 || BTSelected == 2) bees.get(bees.size()-1).updateTier(BTObjectiveTier);

          BTFadeOutTimer = gameMillis;
          resetBTVars();
          screenDisable();
          gameScreenActive = true;
        } else {
          //do nothing.
          //wait until the beehive occupancy is lower
        }
      }
    }
  } else if (BTSuccessConditionMatch) { //success
    if (BTFOTConfirmed == false) {
      BTFOTConfirmed = true;
      BTFadeOutTimer = gameMillis;
      noti.add(new Notification(12, color(0, 200, 0), 20, height-60, "You finished the "+upgradedBeeName[BTSelected]+" training course!", 4000, "Down Corner"));
    }
    fill(0);
    textSize(100);
    textAlign(CENTER);
    if (showText) text("COMPLETED!", width/2, height/2);
    if (beesCount < beehiveSize[beehiveTier]) {
      textSize(30);
      if (showText) {
        if (BTSelected == 0 || BTSelected == 2) {
          text("A tier " + BTObjectiveTier + ' ' + upgradedBeeName[BTSelected], width/2, height/2+80);
          text("will be delivered in: " + ((5000+BTFadeOutTimer-gameMillis)/1000) + " seconds", width/2, height/2+110);
        }
        // else ...
      }
    } else {
      textSize(18);
      fill(255, 50, 50);
      if (showText) {
        text(upgradedBeeName[BTSelected] + " cannot be delivered due to occupied beehive!", width/2, height/2+80);
        text(upgradedBeeName[BTSelected] + " will be delivered once your beehive is not full.", width/2, height/2+1110);
        fill(255, 0, 0);
        text("WARNING: " + upgradedBeeName[BTSelected] + " will be KILLED if it is still not delivered within this week!", width/2, height/2+135);
      }
    }

    if (gameMillis - BTFadeOutTimer > 5000) {
      if (beesCount < beehiveSize[beehiveTier]) {
        bees.add(new Bee(BTSelected+beeName.length));
        inventoryBees.add(new Bee(BTSelected+beeName.length));
        inventoryBees.get(inventoryBees.size()-1).updateShouldBeeMove(false);
        inventoryBees.get(inventoryBees.size()-1).updateForShop(true);
        inventoryBees.get(inventoryBees.size()-1).updateMoveTheta(HALF_PI);
        resetBeeInvPositions();

        if (BTSelected == 0 || BTSelected == 2) bees.get(bees.size()-1).updateTier(BTObjectiveTier);

        BTFadeOutTimer = gameMillis;
        resetBTVars();
        screenDisable();
        gameScreenActive = true;
      } else {
        //do nothing.
        //wait until the beehive occupancy is lower
      }
    }
  }
}



int BTTimer = 0;
boolean BTConfirmed = false;
boolean ignoreBTClick = false;
void beeTrainClickEvents() {
  if (ignoreBTClick) {
    ignoreBTClick = false;
    return;
  } else {
    float bx = trainingBee.getLocation().x;
    float by = trainingBee.getLocation().y;

    switch (BTSelected) {
    case 0: //Priest Bee
      for (int i = BTItems.size()-1; i >= 0; i--) {
        ItemSpawn is = BTItems.get(i);

        float ix = is.getLocation().x, iy = is.getLocation().y;
        if (distance_between_two_points(ix, bx, iy, by) <= trainingBee.getPriestRange()/2*1.1) { // the item is in the priest's range
          if (distance_between_two_points(mouseX, ix, mouseY, iy) < 20) { //mouse close enough to the item
            if (is.getT_satisfied() == false) {
              int itemType = is.getItemType();
              if (itemType == 3) { //if picked up holy branch
                BTAbilityCharge++;
                BTItems.remove(i);
              } else if (BTCheck[itemType] == false) { //if valid ("is a part of MISSING components in holy triangle formation")
                if (itemType == 0) { //if the picked item is holy water
                  if (BTHolyWaterIndex[0] == -1) BTHolyWaterIndex[0] = BTSatisfied; //not yet added the position, so no need to -1 (supposedly, im not sure lul)
                  else if (BTHolyWaterIndex[1] == -1) BTHolyWaterIndex[1] = BTSatisfied;
                }
                if (itemType == 0) {
                  if (BTHolyWaterShattered[0]) { //reactivating the shattered holy water in FIRST triangle
                    BTHolyWaterShattered[0] = false; //because activated, so not shattered anymore
                    BTHolyPos[BTHolyWaterIndex[0]][0] = is.getLocation().x;
                    BTHolyPos[BTHolyWaterIndex[0]][1] = is.getLocation().y;
                  } else if (BTHolyWaterShattered[1]) { //reactivating the shattered holy water in SECOND triangle
                    BTHolyWaterShattered[1] = false; //because activated, so not shattered anymore
                    BTHolyPos[BTHolyWaterIndex[1]][0] = is.getLocation().x;
                    BTHolyPos[BTHolyWaterIndex[1]][1] = is.getLocation().y;
                  } else {
                    //normal treatment
                    for (int j = 0; j < BTHolyPos.length; j++) { 
                      if (BTHolyPos[j][0] == -1) { //check from 0 to max. as soon as the position is not taken, assign target.
                        BTHolyPos[j][0] = is.getLocation().x;
                        BTHolyPos[j][1] = is.getLocation().y;
                        break; //break out of for
                      }
                    }
                  }
                } else {
                  //normal treatment
                  for (int j = 0; j < BTHolyPos.length; j++) { 
                    if (BTHolyPos[j][0] == -1) { //check from 0 to max. as soon as the position is not taken, assign target.
                      BTHolyPos[j][0] = is.getLocation().x;
                      BTHolyPos[j][1] = is.getLocation().y;
                      break; //break out of for
                    }
                  }
                }
                is.updateT_satisfied(true);
                BTCheck[itemType] = true;
              }
              return; //prevent the bee to be set in place
            }
          }
        }
      }

      if (BTAbility[0].MouseClicked()) {
        BTAbilityCharge--;
        for (Satanic s : BTDemons) {
          s.changeSpeedForDuration(s.getSpeed()/2, 15000);
        }
        return; //prevent the bee to be set in place
      } else if (BTAbility[1].MouseClicked()) {
        BTAbilityCharge--;
        trainingBee.changeRangeForDuration(trainingBee.getPriestRange()*1.5, 12000);
        return; //prevent the bee to be set in place
      }

      float px = beeProjection.getLocation().x;
      float py = beeProjection.getLocation().y;
      if (BTConfirmed && (mouseX > bx-15 && mouseX < bx+15 && mouseY > by-15 && mouseY < by+15 || mouseX > px-15 && mouseX < px+15 && mouseY > py-15 && mouseY < py+15)) BTConfirmed = false;
      else if (BTConfirmed == false) BTConfirmed = true;
      break;
    case 2: //Gardening Bee
      for (int i = 0; i < BTAbility2.length; i++) {
        if (BTAbility2[i].MouseClicked()) {
          if (BTAbility2[i].getIsActive()) BTAbilityCharge = -1;
          else BTAbilityCharge = i;

          return; //dont run the rest
        }
      }

      trainingBee.updateMoveTheta(calcMoveTheta(mouseX, mouseY, bx, by));
      trainingBee.updateBeeMoveTimer(gameMillis);

      break;
    }
  }
}



//functions
void resetBTVars() {
  BTSelected = -1;
  BTOngoing = false;
  BTFOTConfirmed = false;
  BTObjectiveTier = 0;
}

static final int[] BTGrowthTime = {40000};
class Plot {
  PVector location;
  byte[] xy = new byte[2];
  float plotSize = width/5;
  int plantType = -1;
  int plantStage = 0;
  int progressTimer = 0, bugTimer = 0, damagedLevel = 0;
  int fertilizeActiveTimer = 0, fertilizeTimer = 0;
  int turnDryTimer = int(random(5, 15))*1000, beenDryTimer = 0; //turnDryTimer: the time required for it to turn "dry"
  float progMulti = 1;
  boolean isDry = false, leavesTrimmed = false; //removed isDay
  int bugsPresent = 0;
  int rewardPoints = 13;

  Plot(int x, int y) {
    location = new PVector(plotSize/5 + (plotSize+plotSize/5)*x   +   plotSize/2, 30+height/4 + (plotSize+plotSize/5)*y   +   plotSize/2);
    xy[0]=byte(x);
    xy[1]=byte(y);
  }

  void plant(int type) {
    if (plantType == -1) {
      plantType = type;
      if (type == 0) rewardPoints = 13;
    }
  }

  void updateIsDry(boolean _isDry) {
    isDry = _isDry;
  }

  void updateBugs(int bugs) {
    bugsPresent = bugs;
  }

  void water() {
    isDry = false;
    beenDryTimer = 0;
    if (turnDryTimer < 5000) turnDryTimer += int(random(5, 10))*1000;
  }

  void fertilize() {
    if (plantType != -1 && fertilizeTimer <= 0) {
      fertilizeTimer = int(random(20, 30))*1000; //timer allowed for next apply
      fertilizeActiveTimer = int(random(5, 10))*1000;
    }
  }

  void trimLeaves() {
    if (progressTimer >= BTGrowthTime[plantType] && leavesTrimmed == false) {
      leavesTrimmed = true;
      rewardPoints *= random(1.25, 1.5);
    }
  }

  void harvest() {
    plantType = -1;
    if (damagedLevel > rewardPoints) damagedLevel = rewardPoints-1;
    rewardPoints -= damagedLevel;
    if (bugTimer <= 0) rewardPoints *= 1.25; //no bug damage done (or completely negated)
    BTObjectiveScore += rewardPoints;
    //reset every variable
    rewardPoints = 0;
    progressTimer = 0;
    bugTimer = 0; 
    damagedLevel = 0;
    fertilizeTimer = 0; 
    turnDryTimer = int(random(5, 15))*1000;
    beenDryTimer = 0;
    progMulti = 1;
    isDry = false;
    leavesTrimmed = false;
    bugsPresent = 0;
  }

  void showPlot() {
    //Base
    rectMode(CENTER);
    imageMode(CENTER);
    noStroke();
    if (turnDryTimer > 5000) fill(87, 59, 12); //dirt brown
    else fill(map(turnDryTimer, 5000, 0, 87, 204), map(turnDryTimer, 5000, 0, 59, 168), map(turnDryTimer, 5000, 0, 12, 118)); //dry dirt
    rect(location.x, location.y, plotSize, plotSize, 10, 10, 10, 10);
    //if (turnDryTimer <= 5000 && plantType != -1) {
    //  tint(255, map(turnDryTimer, 5000, 0, 0, 175));
    //  image(BTCrackedPattern, location.x, location.y, plotSize, plotSize);
    //  noTint();
    //}
    rectMode(CORNER);

    //Plants
    switch (plantType) { // i might add more plant types later. currently it's just flowers
    case 0:
      //fill(255);
      //textAlign(CENTER);
      //textSize(10);
      //text("progmulti: " + progMulti, location.x, location.y-10);
      //text("TYPE " + plantType, location.x, location.y);
      //text("isDry: "+isDry+" "+turnDryTimer, location.x, location.y+10);
      //text("fert: " + fertilizeActiveTimer + " " + fertilizeTimer, location.x, location.y+20);
      //text("bugs: " + bugsPresent + " " +bugTimer, location.x, location.y+30);
      //text("trimmed: " + leavesTrimmed + " " + rewardPoints, location.x, location.y+40);
      //text("dmged: " + damagedLevel, location.x, location.y+50);

      chargeBar(location.x-plotSize*0.4, location.y-plotSize*0.65, plotSize*0.8, 15, color(#f5deb3), progressTimer, BTGrowthTime[plantType], false, false, true, false);
      println(progressTimer);

      if (progressTimer >= BTGrowthTime[plantType]) {
        if (beenDryTimer >= 2500 && leavesTrimmed) image(BTDryFlowerStage[BTDryFlowerStage.length-1], location.x, location.y, plotSize*0.85, plotSize*0.85);
        else if (beenDryTimer < 2500 && leavesTrimmed) image(BTFlowerStage[BTDryFlowerStage.length-1], location.x, location.y, plotSize*0.85, plotSize*0.85);
        else if (beenDryTimer >= 2500 && leavesTrimmed == false) image(BTDryFlowerStage[BTDryFlowerStage.length-2], location.x, location.y, plotSize*0.85, plotSize*0.85);
        else if (beenDryTimer < 2500 && leavesTrimmed == false) image(BTFlowerStage[BTFlowerStage.length-2], location.x, location.y, plotSize*0.85, plotSize*0.85);
      } else {
        for (int i = 0; i < 5; i++) { //5 i-s because there are 5 stages pics before fully grown
          if (progressTimer < BTGrowthTime[plantType]/5*(i+1)) {
            if (beenDryTimer >= 2500) image(BTDryFlowerStage[i], location.x, location.y, plotSize*0.85, plotSize*0.85);
            else image(BTFlowerStage[i], location.x, location.y, plotSize*0.85, plotSize*0.85);
            break; //break out of for
          }
        }
      }
      if (fertilizeTimer > 0) image(BTFertilizer, location.x, location.y, plotSize*0.85, plotSize*0.85);

      break;
    }
  }

  void growPlant() {
    switch (plantType) {
    case 0:
      if (progressTimer < BTGrowthTime[plantType]) {
        bugsPresent = 0;
        for (Pest p : BTPest) {
          if (p.getXY()[0] == xy[0] && p.getXY()[1] == xy[1]) bugsPresent++; //for some reason the entire array does not equal, even though their elements are equal.
        }

        if (BTisDay) progMulti = map(BTTimer, 0, ROUND_TIME/14, 1.25, 1); 
        else progMulti = map(BTTimer, 0, ROUND_TIME/14, 1, 1.25); 

        if (isDry && beenDryTimer > 2500) progMulti *= map(beenDryTimer, 2500, 6000, 1, 0.75);

        if (fertilizeActiveTimer > 0) progMulti *= 1.35;



        if (progressTimer < BTGrowthTime[plantType]) progressTimer += timePassed*progMulti;

        if (bugsPresent > 0) bugTimer += timePassed*bugsPresent;
        if (bugTimer > 1000 && bugsPresent == 0) bugTimer -= timePassed/5;
        damagedLevel = floor(pow(bugTimer/1000, 0.75));

        if (isDry == false) turnDryTimer -= timePassed;
        else beenDryTimer = constrain(int(beenDryTimer+timePassed), 0, 6000);
        if (turnDryTimer <= 0) isDry = true;

        if (fertilizeActiveTimer > 0) fertilizeActiveTimer -= timePassed;
        if (fertilizeTimer > 0) fertilizeTimer -= timePassed;
      }
      break;
    }
  }

  int getPlantType() {
    return plantType;
  }

  PVector getLocation() {
    return location;
  }

  boolean returnHarvestable() {
    if (plantType == -1) return false; //not even planted anything, so false
    else if (progressTimer >= BTGrowthTime[plantType]) return true;
    else return false;
  }

  byte[] getXY() {
    return xy;
  }
}

class Pest {
  PVector location;
  byte[] xy = new byte[2];
  float speed = 0.2;
  boolean moveLeft = random(1)>0.5?true:false;

  float plotSize = width/5;

  Pest(int x, int y) {
    location = new PVector(plotSize/5 + (plotSize+plotSize/5+10)*x + random(plotSize-20), 30+height/4 + (plotSize+plotSize/5+10)*y + random(plotSize-10));
    xy[0]=byte(x);
    xy[1]=byte(y);
  }

  void showPest() {
    strokeWeight(0.5);
    stroke(100, 27, 40);
    fill(255, 182, 193);
    rectMode(CENTER);
    rect(location.x, location.y, 6, 2.5);
    rectMode(CORNER);
  }

  int noChangeTimer = 0;
  void movePest() {
    if (noChangeTimer > 250) noChangeTimer = 0;
    else if (noChangeTimer > 0) noChangeTimer += timePassed;

    float LUx = plotSize/5 + (plotSize+plotSize/5)*xy[0];
    if (noChangeTimer == 0 && (location.x+2.5 >= LUx+plotSize || location.x-2.5 <= LUx)) {
      noChangeTimer = 1;
      moveLeft = !moveLeft;
    }

    if (moveLeft) location = new PVector(location.x-speed, location.y);
    else location = new PVector(location.x+speed, location.y);
  }

  PVector getLocation() {
    return location;
  }

  byte[] getXY() {
    return xy;
  }
}

int BTPestTimer = int(random(10, 20))*1000;
void spawnPest() {
  //println("next pest in: "+BTPestTimer);
  BTPestTimer -= timePassed;
  if (BTPestTimer <= 0) {
    BTPestTimer = 1000* int(random(5, 20) * map(BTObjectiveScore, 0, 100+55+55+65, 1, 0.5));

    ArrayList<byte[]> availablePlots = new ArrayList<byte[]>();
    for (Plot p : BTPlots) {
      if (p.getPlantType() != -1) availablePlots.add(p.getXY());
    }
    for (byte[] b : availablePlots) printArray(b);
    int available = availablePlots.size();
    if (available > 0) {
      byte[] spawnOn = availablePlots.get((int)random(available));
      BTPest.add(new Pest(spawnOn[0], spawnOn[1]));
    }
  }
}