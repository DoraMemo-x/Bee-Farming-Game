static final String[] forestName = {
  "Forest Humming", "Forest Sting", "Forest Wax", "Forest Beetle", "Forest King", "Forest Glow", "Forest Dark", "Guardian School", "Forest Light", "Forest Amazing", "Jumbee Valley", "Dream Land", "Penisula Giant"
};
int[] forestCost = {0, 1500, 2500, 5000, 15000, 35000, 70000, 0, 180000, 500000, 0, 1500000, 2000000};
static final int[] forestBaseCost = {0, 1500, 2500, 5000, 15000, 35000, 70000, 0, 180000, 500000, 0, 1500000, 2000000};
static final int[][] forestHoneyRng = {
  {1, 3}, {3, 9}, {7, 15}, {10, 25}, {15, 35}, {30, 55}, {45, 70}, {0, 0}, {60, 100}, {100, 175}, {0, 0}, {300, 500}, {450, 650}
};
//static final int[][] forestFlowerSpawnRate = {{}, {}, {}, {}, {}, {}, {}, {0,0}, {}, {}, {0,0}, {}, {}};

ArrayList<CircleButton> forestBtns = new ArrayList<CircleButton>();

void forestSetup() {
  //Forest Entry
  forestBtns.add(new CircleButton(forestName[0], "Free", 100, 100, 100, 60, 152, 255, 182, 1, 103, 31));
  forestBtns.add(new CircleButton(forestName[1], "$"+nfc(forestCost[1]), 210, 100, 100, 60, 162, 245, 192, 1, 103, 31));
  forestBtns.add(new CircleButton(forestName[2], "$"+nfc(forestCost[2]), 320, 100, 100, 60, 172, 235, 202, 1, 103, 31));
  forestBtns.add(new CircleButton(forestName[3], "$"+nfc(forestCost[3]), 430, 100, 100, 60, 182, 225, 212, 1, 103, 31));
  forestBtns.add(new CircleButton(forestName[4], "$"+nfc(forestCost[4]), 540, 100, 100, 60, 192, 215, 222, 1, 103, 31));
  forestBtns.add(new CircleButton(forestName[5], "$"+nfc(forestCost[5]), 100, 240, 100, 60, 202, 205, 232, 1, 103, 31));
  forestBtns.add(new CircleButton(forestName[6], "$"+nfc(forestCost[6]), 210, 240, 100, 60, 212, 195, 242, 1, 103, 31));
  forestBtns.add(new CircleButton("DISABLED", "$"+nfc(forestCost[7]), 320, 240, 100, 60, 222, 185, 252, 1, 103, 31));
  forestBtns.add(new CircleButton(forestName[8], "$"+nfc(forestCost[8]), 430, 240, 100, 60, 232, 175, 255, 1, 103, 31));
  forestBtns.add(new CircleButton(forestName[9], "$"+nfc(forestCost[9]), 540, 240, 100, 60, 242, 165, 255, 1, 103, 31));
  forestBtns.add(new CircleButton("DISABLED", "$"+nfc(forestCost[10]), 100, 380, 100, 60, 252, 155, 255, 1, 103, 31));
  forestBtns.add(new CircleButton(forestName[11], "$"+nfc(forestCost[11]), 210, 380, 100, 60, 255, 145, 255, 1, 103, 31));
  forestBtns.add(new CircleButton(forestName[12], "$"+nfc(forestCost[12]), 320, 380, 100, 60, 255, 135, 255, 1, 103, 31));
}

void showForestMenu() {
  //sellAllHoneyBtn.Draw();
  showMarketBtn.updateGreyOut(false);
  honeyFlucBtn.updateGreyOut(false);
  bottomStatsBar();

  for (int fb = forestBtns.size()-1; fb >= 0; fb--) {
    CircleButton _forestBtn = forestBtns.get(fb);

    if (money < forestCost[fb]) _forestBtn.updateGreyOut(true);
    else _forestBtn.updateGreyOut(false);

    if (fb == 7 || fb == 10) _forestBtn.updateGreyOut(true); //guardian school / jumbee valley

    if (!(fb == 7 || fb == 10)) _forestBtn.Draw();
  }
}

int forestType = 0; //which forest player is in
//boolean ERRORForestNEM = false;
void initializeForest(int _forestType) {
  if (money >= forestCost[_forestType]) {
    if (week > GAME_WEEK_LENGTH) gameOver = true; //+1 is now done right after entering forest screen

    forestType = _forestType;
    gameMillis = 0;
    roundTime = 0;
    pMillis = timeMillis;
    flowerTimer = 0;
    honeyPriceChgTimer = 0;
    hornetTimer = 0;
    GTFadeOutTimer = 0;
    BTFadeOutTimer = 0;

    money -= forestCost[_forestType];

    //reset entry cost
    if (forestCost[_forestType] != forestBaseCost[_forestType]) forestCost[_forestType] = forestBaseCost[_forestType];

    //check quest
    for (int i = 0; i < questReq.length; i++) {
      for (int k = 0; k < questReq[i][2].length; k++) {
        if (questDone[i][2][k] == false && _forestType == questReq[i][2][k]) {
          questDone[i][2][k] = true;
          break;
        }
      }
    }

    flowers = new ArrayList<Flower>();

    screenDisable();
    gameScreenActive = true;

    //remove all hornets, fireflies
    hornets = new ArrayList<Hornet>();
    fireflies = new ArrayList<Firefly>();

    //create flowers
    for (int i=0; i<10; i++) { 
      flowers.add(new Flower(10+random(width-20), 40+random(height-40-50), forestHoneyRng[_forestType][0], forestHoneyRng[_forestType][1]));
    }

    //reset bees
    for (Bee b : bees) {
      b.updateLocation(width/2, height/2);
      b.resetDiameter();
      b.updateShouldBeeMove(true);
      b.updateBeeMoveTimer(0);
      b.updateMoveTheta(random(TWO_PI));
    }

    for (Guardian g : guardians) {
      g.updateLocation(width/2, height/2);
      g.resetRadius();
      g.updateShouldGuardianMove(true);
      g.updateGuardianMoveTimer(0);
      g.updateMoveTheta(random(TWO_PI));
    }

    //initiate guardian training (if available)
    if (GTPurchased) {
      GTSuccessConditionMatch = false;
      GTPurchased = false;
      GTOngoing = true;

      for (int _g = guardians.size()-1; _g >= 0; _g--) {
        Guardian g = guardians.get(_g);
        if (g.getGuardianName().equals(guardianName[1])) {
          guardians.remove(_g);
          inventoryGuardians.remove(_g);
          break;
        }
      }

      trainingGuardian = new TrainingGuardian(GTSelected);

      switch (GTSelected) {
      case 0: //Royal Guardian
        GTFireflies = new ArrayList<Firefly>();

        GTObjectiveAddAmount = 5;
        for (int i = 0; i < 5; i++) {
          GTFireflies.add(new Firefly(true));
        }
        break;

      case 1: //Baiting Guardian
        GTFlowers = new ArrayList<Flower>();

        GTObjectiveTime = 0;
        GTObjectiveTimeRequired = (int)ROUND_TIME/2;
        for (int i = 0; i < 6; i++) {
          GTFlowers.add(new Flower(10+random(width-20), 40+random(height-40-50), 0, 0));
          GTFlowers.get(i).updateForTraining(true);
        }
        break;

      case 2: //Hunting Guardian
        GTFireflies = new ArrayList<Firefly>();
        GTHornets = new ArrayList<Hornet>();
        GTLadybugs = new ArrayList<Ladybug>();

        pos = new ArrayList();
        dotPos = new ArrayList<ArrayList<String>>();

        GTObjectUsed = 0;
        GTObjectToggle = false;
        GTObjectLimit = 325;


        GTObjectiveTimeRequired = 3000;
        GTObjectiveTime = 0;

        GTObjectiveScore = 0;
        GTObjectiveScoreRequired = 175;
        for (int i = 0; i < 3; i++) GTFireflies.add(new Firefly(true));
        for (int i = 0; i < 4; i++) GTHornets.add(new Hornet((random(i) > 1 ? 1 : 0), true));
        for (int i = 0; i < 3; i++) GTLadybugs.add(new Ladybug(true));
        break;

      case 3:
        break;

      case 4: //Ranged Guardian
        GTFireflies = new ArrayList<Firefly>();
        GTHornets = new ArrayList<Hornet>();
        GTLadybugs = new ArrayList<Ladybug>();

        GTObjectiveTier = 0;
        GTObjectiveScore = 0;
        GTObjectiveScoreRequired = 125;

        for (int i = 0; i < 4; i++) {
          GTFireflies.add(new Firefly(true));
          GTFireflies.get(i).updateFireflyHp(10);
        }
        for (int i = 0; i < 5; i++) {
          GTHornets.add(new Hornet((random(i) > 2 ? 1 : 0), true));
          int multiplier = GTHornets.get(i).getHornetType()+1;
          GTHornets.get(i).updateHornetHp(4*multiplier);
        }
        break;

      case 5: //Bouncer Guardian
        GTBees = new ArrayList<Bee>();
        GTHornets = new ArrayList<Hornet>();
        GTLadybugs = new ArrayList<Ladybug>();

        GTObjectiveScore = 0;
        GTObjectiveScoreRequired = 6; // how many rounds
        GTObjectiveTime = (int)random(5, 8)*1000;

        GTBees.add(new Bee( (int)random(3) ));
        GTBees.get(0).updateForTraining(true);
        GTBees.get(0).updateLocation(10+random(width-20), 40+random(height-40-50));
        GTLadybugs.add(new Ladybug(true));
        break;
      }
    }

    //initiate bee training (if available)
    if (BTPurchased) {
      BTSuccessConditionMatch = false;
      BTFailed = false;
      BTPurchased = false;
      BTOngoing = true;
      BTObjectiveTier = 0;
      BTObjectiveScore = 0;

      trainingBee = new TrainingBee(BTSelected);
      BTItems.clear();

      switch (BTSelected) {
      case 0: //Priest Bee
        beeProjection = new TrainingBee(BTSelected);
        beeProjection.updateIsProjection(true);

        BTDemons.clear();
        BTDemons.add(new Satanic(0, true));
        for (int i = 0; i < 4; i++) {
          for (int j = 0; j < 2; j++) {
            BTItems.add(new ItemSpawn(i));
            BTItems.get(BTItems.size()-1).updateForTraining(true);
          }
        }

        BTAbility[0].updateLabel("Slow 15s");
        BTAbility[1].updateLabel("Range 12s");
        BTAbility[0].updateXY(160, height-40);
        BTAbility[1].updateXY(160+80+5, height-40);

        for (int i = 0; i < BTCheck.length; i++) BTCheck[i] = false;
        for (int i = 0; i < BTHolyPos.length; i++) {
          BTHolyPos[i][0] = -1; 
          BTHolyPos[i][1] = -1;
        }

        BTAbilityCharge = 1;
        break;

      case 2: //Gardening Bee
        BTAbilityCharge = -1;
        BTCounter = 1; //for day night control

        BTPlots.clear();
        BTPest.clear();
        for (int x = 0; x < 4; x++) {
          for (int y = 0; y < 2; y++) {
            BTPlots.add(new Plot(x, y));
          }
        }

        BTAbility2[0].updateLabel("Plant");
        BTAbility2[1].updateLabel("Harvest");
        BTAbility2[2].updateLabel("Water");
        BTAbility2[3].updateLabel("Fertilize");
        BTAbility2[4].updateLabel("Spray Pest.");
        BTAbility2[5].updateLabel("Prune Leaves");

        BTObjectiveScoreRequired = 100;

        float plotSize = width/5;
        for (int x = 0; x < 4; x++) {
          for (int y = 0; y < 2; y++) {
            BTPlotLocation[x][y] = new PVector(plotSize/5 + (plotSize+plotSize/5)*x   +   plotSize/2, 30+height/4 + (plotSize+plotSize/5)*y   +   plotSize/2);
          }
        }
        break;
      }
    }

    if (forestType == 3) {
      forest3Hornet = random(ROUND_TIME/2);
    }
  }
}

float forest3Hornet;