Button showMarketBtn;
Button showForestBtn;
Button honeyFlucBtn;

Button buyMarketBtn;
Button sellMarketBtn;

Button sellAllHoneyBtn;
Button sell10kg;
Button sell100kg;
Button sell1000kg;
Button sell10000kg;

static final int[] beeCost = {300, 1000, 5000, 10000, 15000, 50000 /*, not for sale*/};
static final int[] beeSellCost = {beeCost[0]/2, beeCost[1]/2, beeCost[2]/2, beeCost[3]/2, beeCost[4]/2, beeCost[5]/2, /*100000*/};
static final int[] guardianCost = {8000, 18000 /*, not for sale*/};
static final int[] guardianSellCost = {guardianCost[0]/2, guardianCost[1]/2};

int honeyPriceChgTimer = 0, honeyPriceChgTimes = 0;
float newHPCI = round(random(25000, 50000)); //HoneyPriceChgInterval
//int newHPCI = 3000; //HoneyPriceChgInterval for debug
int honeyPrice = int(ceil((random(1, 10)))) * 10; // $/kg
int[] honeyPriceRecord = {honeyPrice, 0, 0, 0, 0, 0};

int honeyPotTier = 0;
static final int[] honeyPotCapKg = {50, 200, 500, 1500, 3000, 10000, 50000};
static final int[] honeyPotPrice = {0, 1000, 3500, 12000, 30000, 120000, 800000};
static final int[] honeyPotSellPrice = {0, 500, 1250, 5000, 12500, 50000, 250000};

int beehiveTier = 0;
static final int[] beehiveSize = {5, 10, 15, 20};
static final int[] beehivePrice = {0, 3000, 5000, 8000};
static final int[] beehiveSellPrice = {0, 1000, 2000, 3000};

void honeyPriceFlutuate() {
  if (gameMillis - honeyPriceChgTimer > newHPCI) {

    honeyPriceChgTimer += newHPCI;
    //if (debug) newHPCI = 3000; //for test purpose, honey price will always change after 3s from the previous change
    //else newHPCI = round(random(25000, 50000));
    newHPCI = round(random(25000, 50000));
    //honeyPrice = int(ceil((random(1, 10)))) * 10; //honey price pre-nerf
    float honeyPriceDet = random(0, 1);
    if (honeyPriceDet < 0.15) honeyPrice = 10;
    else if (honeyPriceDet <= 0.25) honeyPrice = 20;
    else if (honeyPriceDet > 0.95) honeyPrice = 100;
    else if (honeyPriceDet >= 0.85) honeyPrice = 90;
    else honeyPrice = floor(map(honeyPriceDet, 0.25, 0.85, 3, 8)) * 10;
    
    if (gameMillis < ROUND_TIME/2 && honeyPrice > 60) honeyPrice = 60; //further nerf of honey price
    println(honeyPriceDet);

    newHPCI = newHPCI / map(honeyPriceDet, 0, 1, 1, 1.35); //"the previous honey selling price seem to affect the next iteration's time"

    honeyPriceChgTimes = constrain(honeyPriceChgTimes+1, 1, 6);
    if (honeyPriceChgTimes < honeyPriceRecord.length) honeyPriceRecord[honeyPriceChgTimes] = honeyPrice;
    else {
      for (int i = 0; i < honeyPriceRecord.length; i++) {
        if (i < honeyPriceRecord.length-1) honeyPriceRecord[i] = honeyPriceRecord[i+1];
        else honeyPriceRecord[i] = honeyPrice;
      }
    }
  }

  if (debug) {
    fill(0);
    textSize(12);
    textAlign(LEFT);
    text("HPCT: " + honeyPriceChgTimer + " ; newHPCI: " + newHPCI + " (will change in " + (honeyPriceChgTimer+newHPCI-gameMillis) + "s)", 20, height-20);
  }

  fill(255);
  textAlign(LEFT);
  text("Honey Price: ", 310, 19);

  if (honeyPriceChgTimes > 0 && honeyPriceChgTimes < 6) {
    if (honeyPriceRecord[honeyPriceChgTimes] > honeyPriceRecord[honeyPriceChgTimes-1]) fill(0, 255, 0);
    else if (honeyPriceRecord[honeyPriceChgTimes] == honeyPriceRecord[honeyPriceChgTimes-1]) fill(255, 250, 0);
    else fill(255, 0, 0);
  } else if (honeyPriceChgTimes == 6) {
    if (honeyPriceRecord[honeyPriceChgTimes-1] > honeyPriceRecord[honeyPriceChgTimes-2]) fill(0, 255, 0);
    else if (honeyPriceRecord[honeyPriceChgTimes-1] == honeyPriceRecord[honeyPriceChgTimes-2]) fill(255, 250, 0);
    else fill(255, 0, 0);
  } else fill(0, 255, 0);

  text(honeyPrice, 385, 19);

  fill(255);
  text("$/kg", 410, 19);
}

void sellHoney(int amount) {
  if (amount <= honeyKg) {
    money += amount * honeyPrice;
    honeyKg -= amount;
  } else println("not enough honey");
}

void honeyPriceGraph() {
  fill(200);
  stroke(0);
  strokeWeight(5);
  rect(70, 50, 400, height-100);

  //horizontal lines & axis
  stroke(225);
  strokeWeight(1);
  textAlign(RIGHT);
  for (int i = 0; i < 10; i++) {
    line(70+3, 50 + (height-100)/11*(i+1), 470-3, 50 + (height-100)/11*(i+1));

    fill(0);
    text((i+1)*10, 64, 50+3 + (height-100)/11*(10-i));
  }
  textAlign(CENTER, BOTTOM);

  pushMatrix();
  translate(40, height/2);
  rotate(-HALF_PI);
  text("Honey Price ($)", 0, 0);
  popMatrix();

  //vertical lines
  for (int i = 1; i < 5; i++) { // (0) 1 - 4 (5)
    line(70+(400/5)*i, 50+3, 70+(400/5)*i, height-50-3);
  }

  fill(255, 0, 0);
  fill(200, 0, 0);

  int validPt = 0;
  for (int i = 0; i < honeyPriceRecord.length; i++) {
    noStroke();
    if (honeyPriceRecord[i] != 0) {
      ellipse(71+(400/5)*i, 5+(height-100)/11*(12-(honeyPriceRecord[i]/10)), 12, 12);
      validPt++;
    }
    //    println(validPt);
  }
  for (int i = 0; i < honeyPriceRecord.length; i++) {
    stroke(200, 0, 0);
    strokeWeight(2);
    if (i+1 < validPt) {
      line(71+(400/5)*i, 5+(height-100)/11*(12-(honeyPriceRecord[i]/10)), 71+(400/5)*(i+1), 5+(height-100)/11*(12-(honeyPriceRecord[i+1]/10)));
    }
  }
}

//these 2 are 2 entirely different shops.
//one is for player selling/buying,
//another is for the flutuation of honey prices (honey market)

int money = 0; //$ (RAISED BCUZ IMPLEMENTING THINGS. THIS SHOULD BE 0)
void showMarket() {

  int beesCountIndividual[] = new int[beeName.length];
  for (Bee b : bees) {
    for (int i = 0; i < beeName.length; i++) {
      if (b.getBeeName().equals(beeName[i])) {
        beesCountIndividual[i]++;
        continue; //shorten the time of counting bees - go to next iteration once found the name
      }
    }
  }
  for (int i = 0; i < beeName.length; i++) {
    //if (i==beeName.length-1) buyBee.get(i).updateGreyOut(true); //REMOVED JUMBEE
    buyBee.get(i).Draw();

    fill(80);
    if (i<beeName.length-3) {
      if (beesCountIndividual[i] > 0) text("("+beesCountIndividual[i]+")", 50+195*i + 100/2, 60);
    } else {
      if (beesCountIndividual[i] > 0) text("("+beesCountIndividual[i]+")", 50+195*(i-(beeName.length-3)) + 100/2, 115);
    }
  }
  fill(0);
  textAlign(CENTER);
  for (int i = 0; i < beeCost.length; i++) {
    if (i<beeCost.length-3) text("$"+nfc(beeCost[i]), 50+195*i + 100/2, 95);
    else text("$"+nfc(beeCost[i]), 50+195*(i-(beeCost.length-3)) + 100/2, 150);
  }
  //text("Not For Sale", 110+130*2 + 100/2, 150);


  int guardiansCountIndividual[] = new int[guardianName.length];
  for (Guardian g : guardians) {
    for (int i = 0; i < guardianName.length; i++) {
      if (g.getGuardianName().equals(guardianName[i])) {
        guardiansCountIndividual[i]++;
        continue; //shorten the time of counting guardians - go to next iteration once found the name
      }
    }
  }
  for (int i = 0; i < guardianName.length; i++) {
    //if (i==guardianName.length-1) buyGuardian.get(i).updateGreyOut(true); //REMOVED ROYAL GUARDIAN
    buyGuardian.get(i).Draw();

    fill(80);
    if (guardiansCountIndividual[i] > 0) {
      if (i == 0) text("("+guardiansCountIndividual[i]+")", 50+185*i + 100/2, 180);
      else text("("+guardiansCountIndividual[i]+")", 50+185*i + 120/2, 180);
    }
  }
  fill(0);
  //textAlign(CENTER);
  for (int i = 0; i < guardianCost.length; i++) {
    if (i == 0) text("$"+nfc(guardianCost[i]), 50+185*i + 100/2, 150+60);
    else text("$"+nfc(guardianCost[i]), 50+185*i + 120/2, 150+60);
  }
  //text("Not For Sale", 50+130*2 + 100/2, 150+60);

  if (ERRORnotEnoughMoney) {
    fill(0);
    textAlign(LEFT);
    text("You don't have enough money!", 50, height-50);
  } else if (ERRORbeehiveFull) {
    fill(0);
    textAlign(LEFT);
    text("Your beehive is full!", 50, height-50);
  } else if (ERRORpotTierLow) {
    fill(0);
    textAlign(LEFT);
    text("Your honey pot is bigger than that!", 50, height-50);
  } else if (ERRORhiveTierLow) {
    fill(0);
    textAlign(LEFT);
    text("Your beehive is larger than that!", 50, height-50);
  }

  for (int i = 0; i < honeyPotPrice.length-1; i++) {
    buyPot.get(i).Draw();

    text("Pot", 80+100*i, 230+60);
    text("$"+nfc(honeyPotPrice[i+1]), 80+100*i, 270+60);
  }

  for (int i = 0; i < beehiveSize.length-1; i++) {
    buyHive.get(i).Draw();

    text("Beehive", 102+130*i, 385+60);
    text("$"+nfc(beehivePrice[i+1]), 102+130*i, 420+60);
  }



  for (Bee sb : showcaseBees) {
    sb.showBee();
  }
  for (Guardian sg : showcaseGuardians) {
    sg.showGuardian();
  }
}

void showSellMarket() {
  for (int i = 0; i < beeName.length; i++) {
    sellBee.get(i).updateGreyOut(true);
  }

  int beesCountIndividual[] = new int[beeName.length];
  if (bees.size() > 1) {
    for (Bee b : bees) {
      for (int i = 0; i < beeName.length; i++) {
        if (b.getBeeName().equals(beeName[i])) {
          sellBee.get(i).updateGreyOut(false);
          beesCountIndividual[i]++;
          continue; //shorten the time of counting bees - go to next iteration once found the name
        }
      }
    }
  } else {
    fill(200, 0, 0);
    textAlign(LEFT);
    text("* You can't sell the last honey-picking bee!", 50, height-50);
  }

  for (int i = 0; i < beeName.length; i++) {
    sellBee.get(i).Draw();

    fill(80);
    if (i<beeName.length-3) {
      if (beesCountIndividual[i] > 0) {
        text("("+beesCountIndividual[i]+")", 50+195*i + 100/2, 60);
        showcaseBees.get(i).showBee();
      }
    } else {
      if (beesCountIndividual[i] > 0) {
        text("("+beesCountIndividual[i]+")", 50+195*(i-(beeName.length-3)) + 100/2, 115);
        showcaseBees.get(i).showBee();
      }
    }
  }
  fill(0);
  textAlign(CENTER);
  for (int i = 0; i < beeSellCost.length; i++) {
    if (i<beeCost.length-3) text("$"+nfc(beeSellCost[i]), 50+195*i + 100/2, 95);
    else text("$"+nfc(beeSellCost[i]), 50+195*(i-(beeSellCost.length-3)) + 100/2, 150);
  }


  int guardiansCountIndividual[] = new int[guardianName.length];
  boolean guardianTrainingException = false;
  for (int i = 0; i < guardianName.length; i++) {
    sellGuardian.get(i).updateGreyOut(true);
  }
  for (Guardian g : guardians) {
    for (int i = 0; i < guardianName.length; i++) {
      if (i == 1 && GTPurchased) { //Super Guardian under the situation of having purchased a training course
        if (guardianTrainingException == false) {
          guardianTrainingException = true;
          continue; //training only takes up 1 super guardian. go to next iteration and check if player has more than 1
        } else {
          sellGuardian.get(i).updateGreyOut(false);
          guardiansCountIndividual[i]++;
          continue;
        }
      } else if (g.getGuardianName().equals(guardianName[i])) {
        sellGuardian.get(i).updateGreyOut(false);
        guardiansCountIndividual[i]++;
        continue; //shorten the time of counting guardians - go to next iteration once found the name
      }
    }
  }
  for (int i = 0; i < guardianName.length; i++) {
    sellGuardian.get(i).Draw();

    fill(80);
    if (guardiansCountIndividual[i] > 0) {
      if (i == 0) text("("+guardiansCountIndividual[i]+")", 50+185*i + 100/2, 180);
      else text("("+guardiansCountIndividual[i]+")", 50+185*i + 120/2, 180);
      showcaseGuardians.get(i).showGuardian();
    }
  }

  fill(0);
  for (int i = 0; i < guardianSellCost.length; i++) {
    if (i == 0) text("$"+nfc(guardianSellCost[i]), 50+185*i + 100/2, 150+60);
    else text("$"+nfc(guardianSellCost[i]), 50+185*i + 120/2, 150+60);
  }


  //if (ERRORbeeNotFound) {
  //  fill(0);
  //  textAlign(LEFT);
  //  text("You don't have that kind of bee!", 50, height-50);
  //} 

  for (int i = 0; i < honeyPotSellPrice.length-1; i++) {
    sellPot.get(i).updateGreyOut(true);
    sellPot.get(i).Draw();

    text("Pot", 80+100*i, 230+60);
    //text("$"+nfc(honeyPotSellPrice[i+1]), 80+100*i, 270);
  }


  for (int i = 0; i < beehiveSize.length-1; i++) {
    sellHive.get(i).updateGreyOut(true);
    sellHive.get(i).Draw();

    text("Beehive", 102+130*i, 385+60);
    //text("$"+nfc(beehiveSellPrice[i+1]), 102+130*i, 420);
  }
}

boolean ERRORnotEnoughMoney = false, ERRORbeehiveFull = false, ERRORpotTierLow = false, ERRORhiveTierLow = false;
void buyBee(int beeType) {
  ERRORnotEnoughMoney = false;
  ERRORbeehiveFull = false;
  if (beesCount < beehiveSize[beehiveTier]) {
    if (money >= beeCost[beeType]) {
      money -= beeCost[beeType];
      bees.add(new Bee(beeType));
      //beesCount++;
    } else {
      ERRORnotEnoughMoney = true;
    }
  } else ERRORbeehiveFull = true;
}

void buyGuardian(int guardianType) {
  ERRORnotEnoughMoney = false;
  ERRORbeehiveFull = false;
  if (beesCount < beehiveSize[beehiveTier]) {
    if (money >= guardianCost[guardianType]) {
      money -= guardianCost[guardianType];
      guardians.add(new Guardian(guardianName[guardianType]));
    } else {
      ERRORnotEnoughMoney = true;
    }
  } else ERRORbeehiveFull = true;
}

void buyPot(int potType) {
  ERRORnotEnoughMoney = false;
  ERRORpotTierLow = false;
  if (potType > honeyPotTier) {
    if (money >= honeyPotPrice[potType]) {
      money -= honeyPotPrice[potType];
      honeyPotTier = potType;
    } else ERRORnotEnoughMoney = true;
  } else ERRORpotTierLow = true;
}

void buyHive(int hiveType) {
  ERRORnotEnoughMoney = false;
  ERRORhiveTierLow = false;
  if (hiveType > beehiveTier) {
    if (money >= beehivePrice[hiveType]) {
      money -= beehivePrice[hiveType];
      beehiveTier = hiveType;
    } else ERRORnotEnoughMoney = true;
  } else ERRORhiveTierLow = true;
}



void sellBee(int beeType) {
  //ERRORbeeNotFound = false;

  for (int b = bees.size ()-1; b >= 0; b--) {
    Bee _bee = bees.get(b);

    //search if there is a bee with that type (name)
    if (_bee.getBeeName().equals(beeName[beeType])) {
      bees.remove(b);
      //beesCount--;
      money += beeSellCost[beeType];
      break; //sell 1 bee only
    } else {
      //ERRORbeeNotFound = true;
      println("player shouldn't be able to click this! grey out the button!");
    }
  }
}

void sellGuardian(int guardianType) {
  //ERRORbeeNotFound = false;

  for (int g = guardians.size ()-1; g >= 0; g--) {
    Guardian _guardian = guardians.get(g);

    //search if there is a bee with that type (name)
    if (_guardian.getGuardianName().equals(guardianName[guardianType])) {
      guardians.remove(g);
      //beesCount--;
      money += guardianSellCost[guardianType];
      break; //sell 1 bee only
    } else {
      //ERRORbeeNotFound = true;
      println("player shouldn't be able to click this! grey out the button!");
    }
  }
}

void resetShopErrors() {
  ERRORnotEnoughMoney = false;
  ERRORbeehiveFull = false;
  ERRORpotTierLow = false;
  ERRORhiveTierLow = false;
}

//void sellPot(int potType) {
//  ERRORpotTierHigh = false;

//  if (potType <= honeyPotTier) {
//      money += honeyPotSellPrice[potType];
//      honeyPotTier = potType-1;
//  } else {
//    ERRORpotTierHigh = true;
//  }
//}

//void sellHive(int hiveType) {
//  ERRORhiveTierHigh = false;

//  if (hiveType <= beehiveTier) {
//      money -= beehivePrice[hiveType];
//      beehiveTier = hiveType-1;
//  } else ERRORhiveTierHigh = true;
//}