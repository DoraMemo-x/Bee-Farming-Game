static final String[][] guardianTrainingDemo = {
  {"Objective: Kill 10 fireflies.", "", "Rule:", "   - Fireflies have to be tapped twice", "      before becoming targetable.", "   - Fireflies regenerate hp if they are not targetable."}, 
  {"Objective: Stay near flowers / consume flowers", "                for an accumulative duration."}, 
  {"Objective: Trap creatures by drawing shapes.", "", "Rule:", "   - Draw shapes and", "      move the guardian in to activate trapping.", "   - Trapping ladybugs deducts score;", "      trapping hornets / fireflies add score."}, 
  {}, 
  {"Objective: Kill enough enemies", "                with projectile seeds. (Tier-based)", "", "Rule:", "   - Collect ammo (seeds) by consuming pomegranates.", "   - Spread ammo ability is also available", "      as a cooldown ability.", "   - Spread ammo ability has a chance to shoot lethal stings."}, 
  {"Objective: Project the only bee and kill the hornets.", "", "Rule:", "   - Some ladybugs are disguised as bees,", "      but they will reveal themselves for a short period of time.", "   - A hornet will appear and go for the real bee", "      after some time."}
};

static final String[][] beeTrainingDemo = {
  {"Objective: Defeat demons.", "", "Rule:", "1) Collect holy branches for power-up.", "2) Turn-based movements.", "    Demons chase the bee.", "    If the bee is caught, training instantly ends.", "3) If an item is in the bee's range,", "    you can click on it to activate it.", "4) Form a holy triangle with 3 different items.", "    * You must finish a triangle before creating another one.", "5) If demon passes through the triangle,", "    it gets purifed."}, 
  {"(No Training)"}, 
  {"Objective: Obtain enough score by", "                planting and harvesting plants.", "", "Rule:", "- Take good care of plants. Plant abnormalies:", "1) Dry - slow growth", "2) Bugs - less points rewarded upon harvest", "", "- Bee abilities:", "1) Fertilize - faster growth for a short duration.", "2) Prune leaves - available when the plant", "                           is ready for harvest.", "                        - Increases points rewarded."}, 
  {"(No Training)"}
};

boolean GTDemoCollapsed = false, BTDemoCollapsed = false;
int demoBTSlides = 0, demoGTSlides = 0, demoBTSlidesMax = 4, demoGTSlidesMax = 4;

Button collapsibleBtn;
Button demoTabLeft;
Button demoTabRight;

ArrayList<TrainingBee> demoTrainingBee = new ArrayList<TrainingBee>();
ArrayList<Bee> demoBee = new ArrayList<Bee>();
TrainingGuardian demoTrainingGuardian;
ArrayList<Guardian> demoGuardian = new ArrayList<Guardian>();
ArrayList<Flower> demoFlower = new ArrayList<Flower>();
ArrayList<Hornet> demoHornet = new ArrayList<Hornet>();
ArrayList<Firefly> demoFirefly = new ArrayList<Firefly>();
ArrayList<Ladybug> demoLadybug = new ArrayList<Ladybug>();

void clearDemoEntities() {
  demoTrainingBee.clear();
  demoBee.clear();
  //demoTrainingGuardian;
  demoGuardian.clear();
  demoFlower.clear();
  demoHornet.clear();
  demoFirefly.clear();
  demoLadybug.clear();
}

void BTShopActive() {
  if (BTSelected != -1) {
    noStroke();
    fill(195);
    rect(200+width/2, 70, 110, height/1.75, 10);
  }
  fill(180);
  rect(220, 70, width/2, height/1.75, 10);
  if (BTSelected != -1) {
    fill(50);
    textSize(12);
    textAlign(LEFT);
    text("Materials", width/2+230, 100);
    text("Required:", width/2+230, 115);

    imageMode(CORNER);

    //Resource Checking
    boolean enoughResource = true;
    boolean[] typeCheck = {false, false, false, false};
    int availableResourceTypes = -1;
    if (BTSelected == 0 || BTSelected == 2) availableResourceTypes = typeCheck.length; //if it's priest / gardening, 4 types are available
    else availableResourceTypes = typeCheck.length-1; //if it's undead / rush, 3 types are available

    for (Resource r : inventoryResources) {
      int resourceType = r.getType();
      for (int i = 0; i < availableResourceTypes; i++) {
        if (typeCheck[i] == false) {
          if (resourceType == i + BTSelected*4) typeCheck[i] = true;
        }
      }
    }
    for (int i = 0; i < availableResourceTypes; i++) {
      if (typeCheck[i] == false) {
        enoughResource = false; 
        break;
      }
    }

    textAlign(CENTER);
    textSize(20);
    //Resource bar on right
    for (int i = 0; i < availableResourceTypes; i++) {
      if (rewardSelection[1]) {
        if (rewardSelectedID == i+BTSelected*4) {
          fill(0, 200, 0);
          text("✓", 200+width/2+110, 130+i*70+60/2);
        } else {
          fill(200, 0, 0);
          text("←", 200+width/2+110, 130+i*70+60/2);
        }
      }

      if (typeCheck[i]) {
        image(resourceImage[i + BTSelected*4], width/2+230, 130 + i*70, 55, 55);
      } else {
        image(resourceImageGray[i + BTSelected*4], width/2+230, 130 + i*70, 55, 55);
      }
    }

    fill(255);
    textSize(12);
    textAlign(RIGHT);
    text("Demonstration - " + upgradedBeeName[BTSelected], width/2+200, 100);

    collapsibleTextbox(beeTrainingDemo[BTSelected], 12, 220, 110, color(130), 0, width/2);

    //println("Condition: ", money < upgradeBeeCost[BTSelected], BTPurchased, BTOngoing, enoughResource == false);

    if (rewardSelection[1] && rewardSelectedID == -1) {
      BTPurchase.updateLabel("Confirm");
      BTPurchase.updateGreyOut(true); //upon selecting a bee, DO NOT allow confirm resource (because player hasnt selected a resource yet)
    } else if (rewardSelection[1] == false) {
      if (money < upgradeBeeCost[BTSelected] || BTPurchased || BTOngoing || enoughResource == false || ((BTSelected == 1 || BTSelected == 3) && beesCount == beehiveSize[beehiveTier])) BTPurchase.updateGreyOut(true);
      else BTPurchase.updateGreyOut(false);
      BTPurchase.updateLabel("Purchase for $" + nfc(int(upgradeBeeCost[BTSelected])));
    }
    BTPurchase.Draw();



    if (enoughResource == false && BTPurchased == false) {
      fill(255, 50, 50);
      textSize(12);
      textAlign(LEFT);
      text("You don't have enough materials!", 40, height-125);
    } else if (BTPurchased == false && ((BTSelected == 1 || BTSelected == 3) && beesCount == beehiveSize[beehiveTier])) {
      fill(255, 50, 50);
      textSize(12);
      textAlign(LEFT);
      text("Your beehive is full!", 40, height-125+15);
    }
  } else {
    fill(255);
    textSize(12);
    textAlign(RIGHT);
    text("Demonstration", width/2+200, 100);
  }

  resetButtonPos();

  showForestBtn.Draw();
  buyMarketBtn.updateGreyOut(false);
  buyMarketBtn.Draw();
  invTabLeft.Draw();
  invTabRight.Draw();
  inventoryBtn.get(invBtn).Draw();
  GTMarketBtn.updateGreyOut(false);
  GTMarketBtn.Draw();
  BTMarketBtn.updateGreyOut(true);
  BTMarketBtn.Draw();
  if (demoBTSlides == 0) demoTabLeft.updateGreyOut(true);
  else demoTabLeft.updateGreyOut(false);
  //if (demoBTSlides == demoBTSlidesMax) 
  demoTabRight.updateGreyOut(true);
  //else demoTabRight.updateGreyOut(false);
  demoTabLeft.Draw();
  demoTabRight.Draw();

  textSize(12);
  textAlign(LEFT);
  fill(0);
  if (BTOngoing) {
    text("You have a " + upgradedBeeName[BTSelected] + " training ongoing.", 40, height-125-17);
    text("Check the Bee Training tab.", 40, height-125);
  } else if (BTPurchased) {
    text("You have purchased a " + upgradedBeeName[BTSelected] + " training course.", 40, height-125-17);
    text("The course will take place after this week.", 40, height-125);
  }

  for (int _btn = upgradeBee.size()-1; _btn >= 0; _btn--) {
    Button btn = upgradeBee.get(_btn);
    if ((BTPurchased || BTOngoing) && rewardSelection[1] == false) btn.updateGreyOut(true);
    else btn.updateGreyOut(false);
    btn.Draw();

    int num = 0;
    for (Bee b : bees) {
      if (b.getBeeType()-beeName.length == _btn) {
        num++;
      }
    }
    if (num > 0) {
      fill(80);
      textSize(10);
      textAlign(CENTER);
      text("("+num+")", 125, 70+60*_btn+10);
    }
  }

  for (int _btn = upgradeBee.size()-1; _btn >= 0; _btn--) {
    Button btn = upgradeBee.get(_btn);
    if (btn.getMouseIsOver()) {
      drawPopupWindow(upgradedBeeDescription[_btn], 0, 12, mouseX, mouseY, true, 0, width);
    }
  }
}

int demoChargeBar = 0;
void GTShopActive() {
  noStroke();
  fill(180);
  rect(220, 70, width/2, height/1.75, 10);
  fill(255);
  textSize(12);
  textAlign(RIGHT);
  if (GTSelected == -1) text("Demonstration", width/2+200, 100);
  else {
    text("Demonstration - " + upgradedGuardianName[GTSelected], width/2+200, 100);

    GTPurchase.updateLabel("Purchase for $" + nfc(int(upgradeGuardianCost[GTSelected][0])));
    GTPurchase.Draw();
    //collapsible textbox is drawn after everything is drawn (it should cover everything)

    switch (GTSelected) {
    case 0: //royal
      if (demoGTSlides == 0) {
        demoTrainingGuardian.showGuardian();
        demoTrainingGuardian.move();
        for (Firefly ff : demoFirefly) {
          ff.showFirefly();
          ff.move();
        }
      } else if (demoGTSlides == 1) {
        for (Guardian g : demoGuardian) {
          g.showGuardian();
          g.move();
        }
        for (Hornet h : demoHornet) {
          h.showHornet();
          h.move();
        }
      }
      break;

    case 1: //baiting
      if (demoGTSlides == 0) {
        //float gx = demoTrainingGuardian.getLocation().x, gy = demoTrainingGuardian.getLocation().y;
        for (Flower f : demoFlower) f.showFlower();

        demoTrainingGuardian.showGuardian();
        demoTrainingGuardian.move();
      } else if (demoGTSlides == 1) {
      }

      textSize(10);
      textAlign(CENTER);
      fill(50);
      text("Demo. Score", 280+75, 375);
      chargeBar(280+0.45, 380+0.45, 150-0.45, 15-0.45, color(0, 220, 0), demoChargeBar, 20000, false, false, true, true);

      break;
    }

    if (money < upgradeGuardianCost[GTSelected][0] || GTPurchased || GTOngoing) GTPurchase.updateGreyOut(true);
    else {
      GTPurchase.updateGreyOut(true);
      for (Guardian g : guardians) {
        if (g.getGuardianName().equals(guardianName[1])) {
          GTPurchase.updateGreyOut(false);
          break; //break out of "for" so it runs faster
        }
      }
    }

    collapsibleTextbox(guardianTrainingDemo[GTSelected], 12, 220, 110, color(130), 0, width/2);

    //moved to inventory
    //GTSell.updateGreyOut(true);
    //for (Guardian g : guardians) {
    //  if (g.getGuardianName().equals(upgradedGuardianName[GTSelected])) {
    //    GTSell.updateGreyOut(false);
    //    break;
    //  }
    //}
    //GTSell.updateLabel("Sell for $" + nfc(int(upgradeGuardianCost[GTSelected][0])/2));
    //GTSell.Draw();
  }
  resetButtonPos();

  showForestBtn.Draw();
  buyMarketBtn.updateGreyOut(false);
  buyMarketBtn.Draw();
  invTabLeft.Draw();
  invTabRight.Draw();
  inventoryBtn.get(invBtn).Draw();
  GTMarketBtn.updateGreyOut(true);
  GTMarketBtn.Draw();
  BTMarketBtn.updateGreyOut(false);
  BTMarketBtn.Draw();
  if (demoGTSlides == 0 || GTSelected == -1) demoTabLeft.updateGreyOut(true);
  else demoTabLeft.updateGreyOut(false);
  if (demoGTSlides == demoGTSlidesMax || GTSelected == -1) demoTabRight.updateGreyOut(true);
  else demoTabRight.updateGreyOut(false);
  demoTabLeft.Draw();
  demoTabRight.Draw();

  fill(255, 50, 50);
  textSize(12);
  textAlign(LEFT);
  text("All guardian trainings requires a " + guardianName[1] + ".", 40, height-75-17*2);
  text("Once the training starts, the " + guardianName[1] + " will be sent to a training ground.", 40, height-75-17);
  fill(0);
  if (GTOngoing) {
    text("You have a " + upgradedGuardianName[GTSelected] + " training ongoing.", 40, height-125-17);
    text("Check the Guardian Training tab.", 40, height-125);
  } else if (GTPurchased) {
    text("You have purchased a " + upgradedGuardianName[GTSelected] + " training course.", 40, height-125-17);
    text("The course will take place after this week.", 40, height-125);
  }
  for (int _btn = upgradeGuardian.size()-1; _btn >= 0; _btn--) {
    Button btn = upgradeGuardian.get(_btn);

    if (GTPurchased || GTOngoing) btn.updateGreyOut(true);
    else btn.updateGreyOut(false);
    btn.Draw();

    int num = 0;
    for (Guardian g : guardians) {
      if (g.getGuardianType()-guardianName.length == _btn) {
        num++;
      }
    }
    if (num > 0) {
      fill(80);
      textSize(10);
      textAlign(CENTER);
      text("("+num+")", 125, 70+60*_btn+10);
    }
  }

  for (int _btn = upgradeGuardian.size()-1; _btn >= 0; _btn--) {
    Button btn = upgradeGuardian.get(_btn);
    if (btn.getMouseIsOver()) {
      drawPopupWindow(upgradedGuardianDescription[_btn], 0, 12, mouseX, mouseY, true, 0, width);
    }
  }
}





int _GTBeesSelectedPrev = 0, _GTBeesSelectedCurr = 0;
int _trainingGuardsSelectedPrev = 0, _trainingGuardsSelectedCurr = 0;
boolean _ignoreGTClick = false, _ignorePurchase = false;
void demoGuardianTrainClickEvents() {
  _ignorePurchase = false;
  if (_ignoreGTClick) {
    _ignoreGTClick = false;
    return;
  } else if (GTSelected != -1) { //in progress
    //GTObjCancel for: hunting guardian (2)
    if (GTObjCancel.MouseClicked()) {
      pos = new ArrayList();
      dotPos = new ArrayList<ArrayList<String>>();

      GTObjectUsed = 0;
      GTObjectToggle = false;
      GTObjectiveTime = 0;
    }
    //GTAbilityUse for: ranged guardian (4)
    if (GTAbilityUse.MouseClicked() && demoTrainingGuardian.getStingCooldown() == 0 && demoTrainingGuardian.getShootSting() == false) {
      demoTrainingGuardian.updateShootSting(true);
      //demoTrainingGuardian.get(0).resetStingCooldown();
      return;
    }
    //else if (GTAbilityUse.MouseClicked() && demoTrainingGuardian.get(0).getShootSting()) {
    //  demoTrainingGuardian.get(0).updateShootSting(false);
    //  return;
    //}

    float gx = -50, gy = -50;
    if (demoGTSlides == 0) {
      gx = demoTrainingGuardian.getLocation().x;
      gy = demoTrainingGuardian.getLocation().y;
    }

    int selectedFireflyID = -1;
    if (mouseX > gx-25 && mouseX < gx+25 && mouseY > gy-25 && mouseY < gy+25) {
      if (demoTrainingGuardian.getGuardianSelectedStatus() == false) {
        demoTrainingGuardian.updateGuardianSelectedStatus(true); //selected the guardian

        if (GTSelected == 5) { //bouncer. can select bees & fake bees
          GTBees.get(0).updateBeeSelectedStatus(false);
          for (Ladybug lb : GTLadybugs) {
            lb.updateSelectedStatus(false);
          }
        }
      } else demoTrainingGuardian.updateGuardianSelectedStatus(false); //deselect the guardian
      _ignorePurchase = true;
    } else if (demoTrainingGuardian.getGuardianSelectedStatus() == true) { //if the guardian is selected (the only situation that it can be assigned a target)
      switch (GTSelected) {
      case 0: //Royal Guardian
        for (int ff = demoFirefly.size ()-1; ff >= 0; ff--) {
          Firefly _firefly = demoFirefly.get(ff);
          float ffx = _firefly.getLocation().x;
          float ffy = _firefly.getLocation().y;

          if (dist(mouseX, mouseY, ffx, ffy) < 20) {
            demoTrainingGuardian.updateGuardianSelectedStatus(false);
            //tapped a firefly. not selected yet
            _firefly.minusFireflyHp();
            _firefly.updateFireflyMoveTimer(millis());

            if (_firefly.getFireflyHp() == 0) {
              selectedFireflyID = ff;
              float _thetaRad = calcMoveTheta(ffx, ffy, gx, gy);

              demoTrainingGuardian.updateGuardianSelectedStatus(false);
              demoTrainingGuardian.updateMoveTheta(_thetaRad);
              demoTrainingGuardian.updateGuardianMoveTimer(millis());

              demoTrainingGuardian.selectTarget(ff);
              demoTrainingGuardian.updateGuardianTimeoutMove(false);
            }

            _ignorePurchase = true;
          }
        }
        break;

      case 1: //baiting guardian
        boolean selectedFlower = false;

        for (int i = demoFlower.size()-1; i >= 0; i--) {
          Flower _tf = demoFlower.get(i);
          float tfx = _tf.getLocation().x;
          float tfy = _tf.getLocation().y;

          if (mouseX > tfx-15 && mouseX < tfx+15 && mouseY > tfy-15 && mouseY < tfy+15) {
            demoTrainingGuardian.updateGuardianSelectedStatus(false);
            demoTrainingGuardian.updateGuardianMoveTimer(gameMillis);

            demoTrainingGuardian.selectTarget(i);
            demoTrainingGuardian.updateGuardianTimeoutMove(false);

            selectedFlower = true;

            break;
          }
        }


        if (selectedFlower == false) { // didnt select a flower. go to mouse direction
          float _thetaRad = calcMoveTheta(mouseX, mouseY, gx, gy);
          demoTrainingGuardian.updateMoveTheta(_thetaRad);

          demoTrainingGuardian.updateGuardianSelectedStatus(false);
          demoTrainingGuardian.updateGuardianMoveTimer(gameMillis);
        } else _ignorePurchase = true;
        break;

      case 2: //hunting guardian
      case 4: //ranged guardian
      case 5: //bouncer guardian
        float _thetaRad = calcMoveTheta(mouseX, mouseY, gx, gy);
        demoTrainingGuardian.updateMoveTheta(_thetaRad);

        demoTrainingGuardian.updateGuardianSelectedStatus(false);
        demoTrainingGuardian.updateGuardianMoveTimer(gameMillis);
        break;

      case 3:
        break;
      }
    } else {
      switch (GTSelected) {
      case 2: //hunting guardian
        if (GTObjCancel.MouseClicked() == false && dotPos.size() > 0) {
          // move the guardian to the mouse location (without selecting) when:
          // 1. not cancelling the trail
          // 2. a trail has been drawn

          float _thetaRad = calcMoveTheta(mouseX, mouseY, gx, gy);
          demoTrainingGuardian.updateMoveTheta(_thetaRad);

          demoTrainingGuardian.updateGuardianSelectedStatus(false);
          demoTrainingGuardian.updateGuardianMoveTimer(gameMillis);
        }
        break;

      case 4: //ranged guardian
        float _thetaRad = calcMoveTheta(mouseX, mouseY, gx, gy);
        demoTrainingGuardian.updateMoveTheta(_thetaRad);

        demoTrainingGuardian.updateGuardianSelectedStatus(false);
        demoTrainingGuardian.updateGuardianMoveTimer(gameMillis);
        break;

      case 5: //bouncer guardian *** remember to "exclude" the case when player selected something ON the purchase button to negate the purchase effect.
        boolean selectedObject = false;

        _GTBeesSelectedPrev = 0;
        for (Bee b : GTBees) {
          if (b.getBeeSelectedStatus()) _GTBeesSelectedPrev++;
        }
        for (Ladybug lb : GTLadybugs) {
          if (lb.getSelectedStatus()) _GTBeesSelectedPrev++;
        }
        _GTBeesSelectedCurr = _GTBeesSelectedPrev;
        for (Bee b : GTBees) {
          float bx = b.getLocation().x;
          float by = b.getLocation().y;

          if (mouseX > bx-25 && mouseX < bx+25 && mouseY > by-25 && mouseY < by+25) {
            selectedObject = true;

            _ignorePurchase = true;

            if (b.getBeeSelectedStatus() == false) {
              b.updateBeeSelectedStatus(true); //selected a bee
              _GTBeesSelectedCurr++;

              demoTrainingGuardian.updateGuardianSelectedStatus(false);
              break; //only select ONE "UNSELECTED" bee
            } else {
              b.updateBeeSelectedStatus(false); //deselect a bee
              _GTBeesSelectedCurr--;
              break;
            }
          }
        }
        if (selectedObject == false) {
          for (Ladybug lb : GTLadybugs) {
            float lbx = lb.getLocation().x;
            float lby = lb.getLocation().y;

            if (mouseX > lbx-25 && mouseX < lbx+25 && mouseY > lby-25 && mouseY < lby+25) {
              selectedObject = true;

              _ignorePurchase = true;

              if (lb.getSelectedStatus() == false) {
                lb.updateSelectedStatus(true); //selected a bee
                _GTBeesSelectedCurr++;

                demoTrainingGuardian.updateGuardianSelectedStatus(false);
                break; //only select ONE "UNSELECTED" bee
              } else {
                lb.updateSelectedStatus(false); //deselect a bee
                _GTBeesSelectedCurr--;
                break;
              }
            }
          }
        } else return;

        if (_GTBeesSelectedCurr == 0 && demoTrainingGuardian.getGuardianSelectedStatus() == false && selectedObject == false) { //selected no bee no guardian, but selected a new target, so training guardian go to that location
          float thetaRad = calcMoveTheta(mouseX, mouseY, gx, gy);
          demoTrainingGuardian.updateMoveTheta(thetaRad);

          demoTrainingGuardian.updateGuardianSelectedStatus(false);
          demoTrainingGuardian.updateGuardianMoveTimer(gameMillis);
        } else if (_GTBeesSelectedCurr > 0 && selectedObject == false) { //selected at least 1 bee. move that bee to mouse direction
          if (GTBees.get(0).getBeeSelectedStatus()) {
            PVector bPos = GTBees.get(0).getLocation();
            float thetaRad = calcMoveTheta(mouseX, mouseY, bPos.x, bPos.y);
            GTBees.get(0).updateMoveTheta(thetaRad);

            GTBees.get(0).updateBeeSelectedStatus(false);
            GTBees.get(0).updateBeeMoveTimer(gameMillis);
          }

          for (Ladybug lb : GTLadybugs) {
            if (lb.getSelectedStatus()) {
              float lbx = lb.getLocation().x;
              float lby = lb.getLocation().y;

              float thetaRad = calcMoveTheta(mouseX, mouseY, lbx, lby);
              lb.updateMoveTheta(thetaRad);

              lb.updateSelectedStatus(false);
              lb.updateLadybugMoveTimer(gameMillis);
            }
          }
          break;
        }
      }
    }
  }
}