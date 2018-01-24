


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

    //Resource bar on right
    for (int i = 0; i < availableResourceTypes; i++) {
      if (typeCheck[i]) {
        image(resourceImage[i + BTSelected*4], width/2+230, 130 + i*70, 55, 55);
      } else {
        image(resourceImageGray[i + BTSelected*4], width/2+230, 130 + i*70, 55, 55);
      }
    }

    fill(255);
    textAlign(RIGHT);
    text("Demonstration - " + upgradedBeeName[BTSelected], width/2+200, 100);

    //println("Condition: ", money < upgradeBeeCost[BTSelected], BTPurchased, BTOngoing, enoughResource == false);
    if (money < upgradeBeeCost[BTSelected] || BTPurchased || BTOngoing || enoughResource == false || ((BTSelected == 1 || BTSelected == 3) && beesCount == beehiveSize[beehiveTier])) BTPurchase.updateGreyOut(true);
    else BTPurchase.updateGreyOut(false);
    BTPurchase.updateLabel("Purchase for $" + nfc(int(upgradeBeeCost[BTSelected])));
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
    if (BTPurchased || BTOngoing) btn.updateGreyOut(true);
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

void GTShopActive() {
  fill(180);
  rect(220, 70, width/2, height/1.75, 10);
  fill(255);
  textSize(12);
  textAlign(RIGHT);
  if (GTSelected == -1) text("Demonstration", width/2+200, 100);
  else {
    text("Demonstration - " + upgradedGuardianName[GTSelected], width/2+200, 100);

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
    GTPurchase.updateLabel("Purchase for $" + nfc(int(upgradeGuardianCost[GTSelected][0])));
    GTPurchase.Draw();

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