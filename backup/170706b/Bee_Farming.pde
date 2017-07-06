ArrayList<Flower> flowers = new ArrayList<Flower>(); //<>// //<>//
ArrayList<Bee> bees = new ArrayList<Bee>();
ArrayList<Hornet> hornets = new ArrayList<Hornet>();
ArrayList<Firefly> fireflies = new ArrayList<Firefly>();
ArrayList<Guardian> guardians = new ArrayList<Guardian>();

ArrayList<Firefly> trainingFireflies = new ArrayList<Firefly>();
TrainingGuardian trainingGuardian;

//button arraylist
ArrayList<Button> buyBee = new ArrayList<Button>();
ArrayList<Button> buyGuardian = new ArrayList<Button>();
ArrayList<Button> buyPot = new ArrayList<Button>();
ArrayList<Button> buyHive = new ArrayList<Button>();
ArrayList<Button> sellBee = new ArrayList<Button>();
ArrayList<Button> sellGuardian = new ArrayList<Button>();
ArrayList<Button> sellPot = new ArrayList<Button>();
ArrayList<Button> sellHive = new ArrayList<Button>();

ArrayList<Button> upgradeGuardian = new ArrayList<Button>();

static /*final*/ long ROUND_TIME = 180000;
static final int GAME_WEEK_LENGTH = 15; //15*3 = 45min
int honeyKg = 0;
boolean gameScreenActive = false, shopScreenActive = false, sellShopScreenActive = false, 
  GTShopScreenActive = false, BTShopScreenActive = false, graphScreenActive = false, 
  forestsScreenActive = false, guardianTrainScreenActive = false, 
  startupScreenActive = true;
boolean roundOver = false, gameOver = false;

long timeMillis = System.currentTimeMillis();
long gameMillis = 0, pMillis = System.currentTimeMillis();
long roundTime = 0;
int week = 1;

static final String VERSION = "Ver 17.07.06b <Pre-Alpha>";
boolean debug = false;

Button startGame;

void setup() {
  //if (debug) ROUND_TIME = 3000; //can be achieved by pressed 'w'


  size(800, 600);
  noFill();
  smooth(); //i dont know what effect it has but it looks fancier
  frameRate(60);

  flowers = new ArrayList<Flower>();

  for (int i=0; i<10; i++) flowers.add(new Flower(10+random(width-20), 40+random(height-40-50), 1, 3));
  for (int i=0; i<3; i++)  bees.add(new Bee(width/2, height/2, BEE_RADIUS, beeName[0]));

  startGame = new Button("Start Game", width/2-75, height/2+150, 150, 50, 251, 200, 55, 119, 94, 26);

  showMarketBtn = new Button("Market", width-120, height-40, 100, 35, 251, 200, 55, 119, 94, 26);
  showForestBtn = new Button("Forest", width-120, height-40, 100, 35, 251, 200, 55, 119, 94, 26);
  honeyFlucBtn = new Button("Honey Fluc. Graph", width-260, height-40, 120, 35, 251, 200, 55, 119, 94, 26);
  //saveBtn = new Button("Save", 
  buyMarketBtn = new Button("Buy Items", width-180, height-120, 100, 35, 251, 200, 55, 119, 94, 26);
  sellMarketBtn = new Button("Sell Items", width-300, height-120, 100, 35, 251, 200, 55, 119, 94, 26);
  GTMarketBtn = new Button("G. Training", width-300, height-165, 100, 35, 251, 200, 55, 119, 94, 26);
  BTMarketBtn = new Button("B. Training", width-180, height-165, 100, 35, 251, 200, 55, 119, 94, 26);

  sellAllHoneyBtn = new Button("Sell All Honey", width-400, height-40, 120, 35, 251, 200, 55, 119, 94, 26);
  sell10kg = new Button("Sell 10kg Honey", width-130, 260, 120, 40, 251, 200, 55, 119, 94, 26);
  sell100kg = new Button("Sell 100kg Honey", width-130, 320, 120, 40, 251, 200, 55, 119, 94, 26);
  sell1000kg = new Button("Sell 1000kg Honey", width-130, 380, 120, 40, 251, 200, 55, 119, 94, 26);

  //Buy Market
  for (int i = 0; i < beeName.length; i++) {
    if (i < 4) buyBee.add(new Button(beeName[i], 50+130*i, 50, 100, 50, 255, 100+50*i, 0, 100, 85, 0));
    else buyBee.add(new Button(beeName[i], 110+130*(i-4), 105, 100, 50, 200, 250-50*(i-4), 0, 100, 85, 10));
  }

  buyGuardian.add(new Button(guardianName[0], 50+130*0, 170, 100, 50, 186, 186, 255, 70, 70, 155));
  buyGuardian.add(new Button(guardianName[1], 50+130*1, 170, 100, 50, 136, 136, 255, 33, 34, 121));
  //buyGuardian.add(new Button(guardianName[2], 50+130*2, 170, 100, 50, 86, 86, 255, 0, 0, 120));

  buyPot.add(new Button(honeyPotCapKg[1] + "kg", 50, 200+60, 60, 100, 222, 168, 187, 173, 0, 61));
  buyPot.add(new Button(honeyPotCapKg[2] + "kg", 150, 200+60, 60, 100, 184, 222, 168, 44, 149, 0));
  buyPot.add(new Button(honeyPotCapKg[3] + "kg", 250, 200+60, 60, 100, 132, 134, 198, 0, 3, 124));
  buyPot.add(new Button(honeyPotCapKg[4] + "kg", 350, 200+60, 60, 100, 139, 192, 211, 1, 92, 124));
  buyPot.add(new Button(honeyPotCapKg[5] + "kg", 450, 200+60, 60, 100, 219, 139, 219, 105, 0, 106));
  buyPot.add(new Button(honeyPotCapKg[6] + "kg", 550, 200+60, 60, 100, 169, 206, 135, 51, 106, 0));

  for (int i = 1; i < beehiveSize.length; i++) {
    buyHive.add(new Button(beehiveSize[i] + " swarms", 50+130*(i-1), 350+60, 100, 100, 255, 220, 121, 237, 144, 2));
  }

  //Sell Market
  for (int i = 0; i < beeName.length; i++) {
    if (i < 4) sellBee.add(new Button(beeName[i], 50+130*i, 50, 100, 50, 255, 100+50*i, 0, 100, 85, 0));
    else sellBee.add(new Button(beeName[i], 110+130*(i-4), 105, 100, 50, 200, 250-50*(i-4), 0, 100, 85, 10));
  }

  sellGuardian.add(new Button(guardianName[0], 50+130*0, 170, 100, 50, 186, 186, 255, 70, 70, 155));
  sellGuardian.add(new Button(guardianName[1], 50+130*1, 170, 100, 50, 136, 136, 255, 33, 34, 121));
  //sellGuardian.add(new Button(guardianName[2], 50+130*2, 170, 100, 50, 86, 86, 255, 0, 0, 120));

  sellPot.add(new Button(honeyPotCapKg[1] + "kg", 50, 200+60, 60, 100, 222, 168, 187, 173, 0, 61));
  sellPot.add(new Button(honeyPotCapKg[2] + "kg", 150, 200+60, 60, 100, 184, 222, 168, 44, 149, 0));
  sellPot.add(new Button(honeyPotCapKg[3] + "kg", 250, 200+60, 60, 100, 132, 134, 198, 0, 3, 124));
  sellPot.add(new Button(honeyPotCapKg[4] + "kg", 350, 200+60, 60, 100, 139, 192, 211, 1, 92, 124));
  sellPot.add(new Button(honeyPotCapKg[5] + "kg", 450, 200+60, 60, 100, 219, 139, 219, 105, 0, 106));
  sellPot.add(new Button(honeyPotCapKg[6] + "kg", 550, 200+60, 60, 100, 169, 206, 135, 51, 106, 0));

  for (int i = 1; i < beehiveSize.length; i++) {
    sellHive.add(new Button(beehiveSize[i] + " swarms", 50+130*(i-1), 350+60, 100, 100, 255, 220, 121, 237, 144, 2));
  }

  //Forest Entry
  forestBtns.add(new CircleButton(forestName[0], "Free", 100, 100, 100, 60, 152, 255, 182, 1, 103, 31));
  forestBtns.add(new CircleButton(forestName[1], "$"+nfc(forestCost[1]), 210, 100, 100, 60, 162, 245, 192, 1, 103, 31));
  forestBtns.add(new CircleButton(forestName[2], "$"+nfc(forestCost[2]), 320, 100, 100, 60, 172, 235, 202, 1, 103, 31));
  forestBtns.add(new CircleButton(forestName[3], "$"+nfc(forestCost[3]), 430, 100, 100, 60, 182, 225, 212, 1, 103, 31));
  forestBtns.add(new CircleButton(forestName[4], "$"+nfc(forestCost[4]), 540, 100, 100, 60, 192, 215, 222, 1, 103, 31));
  forestBtns.add(new CircleButton(forestName[5], "$"+nfc(forestCost[5]), 100, 240, 100, 60, 202, 205, 232, 1, 103, 31));
  forestBtns.add(new CircleButton(forestName[6], "$"+nfc(forestCost[6]), 210, 240, 100, 60, 212, 195, 242, 1, 103, 31));
  forestBtns.add(new CircleButton(forestName[7], "$"+nfc(forestCost[7]), 320, 240, 100, 60, 222, 185, 252, 1, 103, 31));
  forestBtns.add(new CircleButton(forestName[8], "$"+nfc(forestCost[8]), 430, 240, 100, 60, 232, 175, 255, 1, 103, 31));
  forestBtns.add(new CircleButton(forestName[9], "$"+nfc(forestCost[9]), 540, 240, 100, 60, 242, 165, 255, 1, 103, 31));
  forestBtns.add(new CircleButton(forestName[10], "$"+nfc(forestCost[10]), 100, 380, 100, 60, 252, 155, 255, 1, 103, 31));
  forestBtns.add(new CircleButton(forestName[11], "$"+nfc(forestCost[11]), 210, 380, 100, 60, 255, 145, 255, 1, 103, 31));
  forestBtns.add(new CircleButton(forestName[12], "$"+nfc(forestCost[12]), 320, 380, 100, 60, 255, 135, 255, 1, 103, 31));

  //training shop - guardians
  for (int i = 0; i < upgradedGuardianName.length; i++) {
    upgradeGuardian.add(new Button(upgradedGuardianName[i], 50, 70+60*i, 150, 40, 255, 255, 0, 200, 200, 0));
  }
  GTPurchase = new Button("Purchase", width-300, height-240, 100, 35, 251, 200, 55, 119, 94, 26);
  GTSell = new Button("Sell", 240, height-240, 150, 35, 251, 200, 55, 119, 94, 26);

  //training panel
  showGuardianTrainBtn = new Button("Guardian Training", width-560, height-37.5, 140, 35, 251, 200, 55, 119, 94, 26);

  beesCount = bees.size() + guardians.size();
}

void draw() { 
  timeMillis = System.currentTimeMillis();

  if (gameOver) {
    showStats();
  } else {
    beesCount = bees.size() + guardians.size();

    if (startupScreenActive) {
      background(255, abs(sin(radians(millis()/50)))*(255-128)+128, abs(sin(radians(millis()/50)))*255);
      fill(0);
      textSize(100);
      textAlign(CENTER);
      text("BEE FARMING", width/2, height/2);
      fill(70);
      textSize(16);
      text("Inspired by the game with the same name: Bee Farming, created by Five Deer Limited.", width/2, height/2+50);
      text("This game does not intend to profit any money. Instead, it is more of a personal project.", width/2, height/2+70);
      textSize(12);
      textAlign(RIGHT);
      text(VERSION, width-20, height-20);
      startGame.Draw();
    }

    if (gameScreenActive) {
      gameMillis += (timeMillis-pMillis);
      roundTime = gameMillis;

      background(255);
      //moved to bottomStatsBar()
      //showMarketBtn.Draw();
      //sellAllHoneyBtn.Draw();
      //honeyFlucBtn.Draw();

      bottomStatsBar();

      drawCenterBeehive();


      //fill(0);
      //textAlign(RIGHT);
      //text("Honey: " + honeyKg + "kg", width-20, 20);

      //reset the shop notification
      ERRORnotEnoughMoney = false;
      ERRORbeehiveFull = false;
      ERRORpotTierLow = false;

      for (Flower f : flowers) { 
        f.showFlower();
      }
      for (Bee b : bees) {
        b.showBee();
        b.move();
        float bx = b.getLocation().x;
        float by = b.getLocation().y;
        //        stroke(180);
        //        line(bx, by, mouseX, mouseY);
        float _currHoneyCap = b.getCurrHoneyCap();
        float _maxHoneyCap = b.getMaxHoneyCap();
        boolean beeFull;
        if (_currHoneyCap < _maxHoneyCap) beeFull = false;
        else beeFull = true;



        if (b.getBeeTarget().equals("Flower")) {
          int beePedalAmount = b.getPedalAmount();
          color[] beeFlowerColors = b.getFlowerColors();

          //Find the selected flower by pedal amount and the colour
          //(Using simply ID won't work because when other flowers are removed their ID would shift too
          float fx = 0;
          float fy = 0;
          for (int f = flowers.size ()-1; f >= 0; f--) {
            Flower _flower = flowers.get(f);
            if (beePedalAmount == _flower.getPedalAmount() && beeFlowerColors[0] == _flower.getStamenPedalColor()[0]) {
              fx = _flower.getLocation().x;
              fy = _flower.getLocation().y;
              break;
            }
          }

          if (fx == 0 && fy == 0) {
            //the bee's flower target has been removed
            b.updateBeeTarget("None");
            b.updateBeeTimeoutMove(true);
            b.updateBeeMoveTimer(gameMillis);
          } else {
            float hypotenuse = distance_between_two_points(bx, fx, by, fy);
            float _thetaRad = asin(abs(fy - by) / hypotenuse);
            float detX = fx - bx;
            float detY = fy - by;
            _thetaRad = returnRealTheta(_thetaRad, detX, detY);


            if (hypotenuse < 2.0) { //if the bee went close enough to the selected flower's area (how close? used to be 10 but would fly to other flowers)
              b.updateBeeTarget("None"); //move on to the code below (i dont know if this would have any bug)
              b.updateBeeTimeoutMove(true);
            }
          }
        } else if (b.getBeeTarget().equals("Beehive")) {
          //In Bee class. already moving towards beehive
          //this is put here to cancel the "honey picking" action
          b.updateBeeMoveTimer(gameMillis); //constantly reset the auto-change-direction timer
        } else if (beeFull == false) {
          //check collision by Pythagorus theorem
          for (int f = flowers.size ()-1; f >= 0; f--) {
            Flower _flower = flowers.get(f);
            float fx = _flower.getLocation().x;
            float fy = _flower.getLocation().y;

            float hypotenuse = distance_between_two_points(bx, fx, by, fy);


            if (hypotenuse <= 2.0) { //pick honey
              b.updateShouldBeeMove(false); //if bee is picking honey, do not move
              b.updateBeeMoveTimer(gameMillis);
              //        float currHoneyGram = _flower.getHoneyGram();
              float _beeMaxCap = b.getMaxHoneyCap();
              float _beeCurrCap = b.getCurrHoneyCap();
              float _beeHoneyPickingSpeed = b.getHoneyPickingSpeed();
              float _newBeeHoneyCap = _beeCurrCap + _beeHoneyPickingSpeed;

              if (_newBeeHoneyCap < _beeMaxCap) {
                float _newFlowerHoneyGram = _flower.getHoneyGram() - _beeHoneyPickingSpeed;

                // WILL FLOWER STILL HAVE HONEY? <begin>
                if (_newFlowerHoneyGram >= 0) {
                  _flower.updateHoneyGram(_newFlowerHoneyGram);
                  b.updateHoneyCap(_currHoneyCap + _beeHoneyPickingSpeed);
                  if (_newFlowerHoneyGram == 0) {
                    flowers.remove(f);
                    moveAllBees();
                    if (beeFull) b.goTowardsBeeHive();
                  }
                } else if (abs(_newFlowerHoneyGram) < _beeHoneyPickingSpeed) {
                  b.increaseHoneyCap(_beeHoneyPickingSpeed+_newFlowerHoneyGram);  //this is to make up the difference of non-divisible(minusable?) flower honey
                  flowers.remove(f);                                          //after adding that difference just remove the flower like normal
                  moveAllBees();                              //flower has been emptied. Bee can move again.
                  if (beeFull) b.goTowardsBeeHive();
                } else {
                  flowers.remove(f);                                     //divisible number. remove as normal
                  moveAllBees();                              //flower has been emptied. Bee can move again.
                  if (beeFull) b.goTowardsBeeHive();
                }
                // WILL FLOWER STILL HAVE HONEY? <close>
              } else { //bee will be full
                float honeyGramPicked = _beeMaxCap - _beeCurrCap;
                float _newFlowerHoneyGram = _flower.getHoneyGram() - honeyGramPicked;

                if (_newFlowerHoneyGram > 0) {
                  _flower.updateHoneyGram(_flower.getHoneyGram() - honeyGramPicked);
                  b.updateHoneyCap(_currHoneyCap + honeyGramPicked);
                  if (_newFlowerHoneyGram == 0) {
                    flowers.remove(f);
                    moveAllBees();
                  }
                } else if (abs(_newFlowerHoneyGram) < honeyGramPicked) {
                  b.increaseHoneyCap(honeyGramPicked + _newFlowerHoneyGram);  //this is to make up the difference of non-divisible(minusable?) flower honey
                  flowers.remove(f);                                          //after adding that difference just remove the flower like normal
                  moveAllBees();                                //flower has been emptied. Bee can move again.
                } else {
                  flowers.remove(f);                                     //divisible number. remove as normal
                  moveAllBees();                                //flower has been emptied. Bee can move again.
                }
                b.goTowardsBeeHive();
              }
            } else if (hypotenuse <= 55) { //go in flower. hypotenuse < flower radius + bee radius
              //if (b.getBeeTarget().equals("Flower")) {
              //  b.updateBeeTarget("None");
              //  b.updateBeeTimeoutMove(true);
              //}

              b.updateInsideFlower(true);
              float detX = fx - bx;
              float detY = fy - by;

              float _thetaRad = asin(abs(fy - by) / hypotenuse);
              _thetaRad = returnRealTheta(_thetaRad, detX, detY);
              //          println(_thetaRad);
              b.updateMoveTheta(_thetaRad);
              b.updateFlowerLocation(fx, fy);
            } else { //tell bee that it is not inside flower

              b.updateInsideFlower(false);
            }
          }
        } else { //if beeFull
          b.updateShouldBeeMove(true);
          //dealt in Bee move()
        }
      }

      for (int g = guardians.size()-1; g >= 0; g--) {
        Guardian _guardian = guardians.get(g);

        _guardian.showGuardian();
        _guardian.move();
      }
      for (Firefly ff : fireflies) {
        ff.showFirefly();
        ff.move();
      }
      for (int h = hornets.size ()-1; h >= 0; h--) {
        Hornet _hornet = hornets.get(h);

        _hornet.showHornet();
        _hornet.move();

        float hx = _hornet.getLocation().x;
        float hy = _hornet.getLocation().y;
        if (hx > width || hx < 0 || hy > height-40 || hy < 25) hornets.remove(h);
      }

      //flower generation over time
      createFlower();
      //hornet spawn
      spawnHornet();


      //<START> maintaining the training gameplay
      if (GTOngoing) { //<>//
        trainingGuardian.move();
        for (Firefly ff : trainingFireflies) ff.move();

        guardianTrainMechanicRun(false);
      }


      //<END> maintaining the training gameplay //<>//
    }



    if (shopScreenActive) {
      background(235);

      resetButtonPos();

      showForestBtn.Draw();
      sellAllHoneyBtn.Draw();
      honeyFlucBtn.Draw();

      buyMarketBtn.updateGreyOut(true);
      buyMarketBtn.Draw();
      sellMarketBtn.updateGreyOut(false);
      sellMarketBtn.Draw();
      GTMarketBtn.updateGreyOut(false);
      GTMarketBtn.Draw();

      showMarket();
    }
    if (sellShopScreenActive) {
      background(235);

      resetButtonPos();

      showForestBtn.Draw();
      sellAllHoneyBtn.Draw();
      honeyFlucBtn.Draw();

      buyMarketBtn.updateGreyOut(false);
      buyMarketBtn.Draw();
      sellMarketBtn.updateGreyOut(true);
      sellMarketBtn.Draw();
      GTMarketBtn.updateGreyOut(false);
      GTMarketBtn.Draw();

      showSellMarket();
    }


    if (graphScreenActive) {
      background(235);

      resetButtonPos();

      showForestBtn.Draw();
      //showMarketBtn.updateLabel("Market");
      //      honeyFlucBtn.Draw();

      sellAllHoneyBtn.updateSize(120, 40);
      sellAllHoneyBtn.Draw();
      if (honeyKg < 10) sell10kg.updateGreyOut(true);
      else sell10kg.updateGreyOut(false);
      sell10kg.Draw();
      if (honeyKg < 100) sell100kg.updateGreyOut(true);
      else sell100kg.updateGreyOut(false);
      sell100kg.Draw();
      if (honeyKg < 1000) sell1000kg.updateGreyOut(true);
      else sell1000kg.updateGreyOut(false);
      sell1000kg.Draw();


      honeyPriceGraph();
    }



    if (forestsScreenActive) {
      background(150, 255, 150);



      showForestMenu();
      String[] enterForestText = {"Enter this forest"}; //each forest's description
      String[] enterHornetForestText = { "Enter this forest", "WARNING: HORNETS"};
      String[] enterFHForestText = {"Enter this forest", "WARNING: HORNETS", "WARNING: FIREFLIES"};
      for (int fb = forestBtns.size ()-1; fb >= 0; fb--) {
        CircleButton _circleButton = forestBtns.get(fb);
        if (_circleButton.getMouseIsOver()) {
          if (fb >= 6) drawPopupWindow(enterFHForestText, 12, mouseX, mouseY);
          else if (fb < 3) drawPopupWindow(enterForestText, 12, mouseX, mouseY);
          else drawPopupWindow(enterHornetForestText, 12, mouseX, mouseY);
        }
      }
    }




    if (guardianTrainScreenActive) {
      gameMillis += (timeMillis-pMillis);
      roundTime = gameMillis;

      guardianTrainDisplayRun();
      guardianTrainMechanicRun(true);

      resetButtonPos();

      showForestBtn.Draw();

      //<START> maintaining the normal gameplay
      for (Firefly ff : fireflies) {
        ff.showFirefly();
        ff.move();
      }
      for (Guardian g : guardians) g.move();
      for (Hornet h : hornets) h.move();
      for (Bee b : bees) {
        b.move();
        float bx = b.getLocation().x;
        float by = b.getLocation().y;
        //        stroke(180);
        //        line(bx, by, mouseX, mouseY);
        float _currHoneyCap = b.getCurrHoneyCap();
        float _maxHoneyCap = b.getMaxHoneyCap();
        boolean beeFull;
        if (_currHoneyCap < _maxHoneyCap) beeFull = false;
        else beeFull = true;



        if (b.getBeeTarget().equals("Flower")) {
          int beePedalAmount = b.getPedalAmount();
          color[] beeFlowerColors = b.getFlowerColors();

          //Find the selected flower by pedal amount and the colour
          //(Using simply ID won't work because when other flowers are removed their ID would shift too
          float fx = 0;
          float fy = 0;
          for (int f = flowers.size ()-1; f >= 0; f--) {
            Flower _flower = flowers.get(f);
            if (beePedalAmount == _flower.getPedalAmount() && beeFlowerColors[0] == _flower.getStamenPedalColor()[0]) {
              fx = _flower.getLocation().x;
              fy = _flower.getLocation().y;
              break;
            }
          }

          if (fx == 0 && fy == 0) {
            //the bee's flower target has been removed
            b.updateBeeTarget("None");
            b.updateBeeTimeoutMove(true);
            b.updateBeeMoveTimer(gameMillis);
          } else {
            float hypotenuse = distance_between_two_points(bx, fx, by, fy);
            float _thetaRad = asin(abs(fy - by) / hypotenuse);
            float detX = fx - bx;
            float detY = fy - by;
            _thetaRad = returnRealTheta(_thetaRad, detX, detY);


            if (hypotenuse <= 2.0) { //if the bee went close enough to the selected flower's area (how close? used to be 10 but would fly to other flowers)
              b.updateBeeTarget("None"); //move on to the code below (i dont know if this would have any bug)
              b.updateBeeTimeoutMove(true);
            }
          }
        } else if (b.getBeeTarget().equals("Beehive")) {
          //In Bee class. already moving towards beehive
          //this is put here to cancel the "honey picking" action
          b.updateBeeMoveTimer(gameMillis); //constantly reset the auto-change-direction timer
        } else if (beeFull == false) {
          //check collision by Pythagorus theorem
          for (int f = flowers.size ()-1; f >= 0; f--) {
            Flower _flower = flowers.get(f);
            float fx = _flower.getLocation().x;
            float fy = _flower.getLocation().y;

            float hypotenuse = distance_between_two_points(bx, fx, by, fy);


            if (hypotenuse <= 2.0) { //pick honey
              b.updateShouldBeeMove(false); //if bee is picking honey, do not move
              b.updateBeeMoveTimer(gameMillis);
              //        float currHoneyGram = _flower.getHoneyGram();
              float _beeMaxCap = b.getMaxHoneyCap();
              float _beeCurrCap = b.getCurrHoneyCap();
              float _beeHoneyPickingSpeed = b.getHoneyPickingSpeed();
              float _newBeeHoneyCap = _beeCurrCap + _beeHoneyPickingSpeed;

              if (_newBeeHoneyCap < _beeMaxCap) {
                float _newFlowerHoneyGram = _flower.getHoneyGram() - _beeHoneyPickingSpeed;

                // WILL FLOWER STILL HAVE HONEY? <begin>
                if (_newFlowerHoneyGram >= 0) {
                  _flower.updateHoneyGram(_newFlowerHoneyGram);
                  b.updateHoneyCap(_currHoneyCap + _beeHoneyPickingSpeed);
                  if (_newFlowerHoneyGram == 0) {
                    flowers.remove(f);
                    moveAllBees();
                    if (beeFull) b.goTowardsBeeHive();
                  }
                } else if (abs(_newFlowerHoneyGram) < _beeHoneyPickingSpeed) {
                  b.increaseHoneyCap(_beeHoneyPickingSpeed+_newFlowerHoneyGram);  //this is to make up the difference of non-divisible(minusable?) flower honey
                  flowers.remove(f);                                          //after adding that difference just remove the flower like normal
                  moveAllBees();                              //flower has been emptied. Bee can move again.
                  if (beeFull) b.goTowardsBeeHive();
                } else {
                  flowers.remove(f);                                     //divisible number. remove as normal
                  moveAllBees();                              //flower has been emptied. Bee can move again.
                  if (beeFull) b.goTowardsBeeHive();
                }
                // WILL FLOWER STILL HAVE HONEY? <close>
              } else { //bee will be full
                float honeyGramPicked = _beeMaxCap - _beeCurrCap;
                float _newFlowerHoneyGram = _flower.getHoneyGram() - honeyGramPicked;

                if (_newFlowerHoneyGram > 0) {
                  _flower.updateHoneyGram(_flower.getHoneyGram() - honeyGramPicked);
                  b.updateHoneyCap(_currHoneyCap + honeyGramPicked);
                  if (_newFlowerHoneyGram == 0) {
                    flowers.remove(f);
                    moveAllBees();
                  }
                } else if (abs(_newFlowerHoneyGram) < honeyGramPicked) {
                  b.increaseHoneyCap(honeyGramPicked + _newFlowerHoneyGram);  //this is to make up the difference of non-divisible(minusable?) flower honey
                  flowers.remove(f);                                          //after adding that difference just remove the flower like normal
                  moveAllBees();                                //flower has been emptied. Bee can move again.
                } else {
                  flowers.remove(f);                                     //divisible number. remove as normal
                  moveAllBees();                                //flower has been emptied. Bee can move again.
                }
                b.goTowardsBeeHive();
              }
            } else if (hypotenuse <= 55) { //go in flower. hypotenuse < flower radius + bee radius
              //if (b.getBeeTarget().equals("Flower")) {
              //  b.updateBeeTarget("None");
              //  b.updateBeeTimeoutMove(true);
              //}

              b.updateInsideFlower(true);
              float detX = fx - bx;
              float detY = fy - by;

              float _thetaRad = asin(abs(fy - by) / hypotenuse);
              _thetaRad = returnRealTheta(_thetaRad, detX, detY);
              //          println(_thetaRad);
              b.updateMoveTheta(_thetaRad);
              b.updateFlowerLocation(fx, fy);
            } else { //tell bee that it is not inside flower

              b.updateInsideFlower(false);
            }
          }
        } else { //if beeFull
          b.updateShouldBeeMove(true);
          //dealt in Bee move()
        }
      }

      //flower generation over time
      createFlower();
      //hornet spawn
      spawnHornet();
      //<END> maintaining the normal gameplay
    }



    if (GTShopScreenActive) {
      background(230);

      fill(180);
      rect(220, 70, width/2, height/1.75, 10);
      fill(255);
      textSize(12);
      textAlign(RIGHT);
      if (GTSelected == -1) text("Demonstration", width/2+200, 100);
      else {
        text("Demonstration - " + upgradedGuardianName[GTSelected], width/2+200, 100);
        if (money < upgradeGuardianCost[GTSelected][0] || GTPurchased) GTPurchase.updateGreyOut(true);
        else {
          GTPurchase.updateGreyOut(true);
          for (Guardian g : guardians) {
            if (g.getGuardianName().equals(guardianName[1])) {
              GTPurchase.updateGreyOut(false);
              break; //break out of "for" so it runs faster
            }
          }
        }
        GTPurchase.Draw();

        GTSell.updateGreyOut(true);
        for (Guardian g : guardians) {
          if (g.getGuardianName().equals(upgradedGuardianName[GTSelected])) {
            GTSell.updateGreyOut(false);
            break;
          }
        }
        GTSell.updateLabel("Sell for $" + nfc(int(upgradeGuardianCost[GTSelected][0])/2));
        GTSell.Draw();
      }
      resetButtonPos();

      showForestBtn.Draw();
      buyMarketBtn.updateGreyOut(false);
      buyMarketBtn.Draw();
      sellMarketBtn.updateGreyOut(false);
      sellMarketBtn.Draw();
      GTMarketBtn.updateGreyOut(true);
      GTMarketBtn.Draw();

      fill(255, 50, 50);
      textSize(12);
      textAlign(LEFT);
      text("All guardian trainings requires a " + guardianName[1] + ".", 50, height-75);
      text("Once the training starts, the " + guardianName[1] + " will be sent to a training ground.", 50, height-58);
      fill(0);
      if (GTOngoing) {
        text("You have a " + upgradedGuardianName[GTSelected] + " training ongoing.", 50, height-125);
        text("Check the Guardian Training tab.", 50, height-108);
      } else if (GTPurchased) {
        text("You have purchased a " + upgradedGuardianName[GTSelected] + " training course.", 50, height-125);
        text("The course will take place after this week.", 50, height-108);
      }
      for (Button btn : upgradeGuardian) btn.Draw();

      for (int _btn = upgradeGuardian.size()-1; _btn >= 0; _btn--) {
        Button btn = upgradeGuardian.get(_btn);
        if (btn.getMouseIsOver()) {
          drawPopupWindow(upgradedGuardianDescription[_btn], 12, mouseX, mouseY);
        }
      }
    }



    if (roundTime >= ROUND_TIME) {
      //round over. return all bees to beehive
      roundOver = true;
      boolean canMoveToNextStage = true;

      //screenDisable();
      background(230);



      if (GTOngoing) {
        switch (GTSelected) {
        case 0: //Royal Guardian
          if (TFOTConfirmed == false) {
            TFOTConfirmed = true;
            trainingFadeOutTimer = gameMillis;
          }

          if (gameMillis - trainingFadeOutTimer > 5000) {
            screenDisable();
            gameScreenActive = true;

            drawCenterBeehive();

            fill(0);
            textSize(100);
            textAlign(CENTER);
            text("ROUND OVER", width/2, height/2);

            showMarketBtn.updateGreyOut(true);
            honeyFlucBtn.updateGreyOut(true);
            bottomStatsBar();

            for (Flower f : flowers) f.showFlower();

            for (Bee b : bees) {
              b.showBee();
              b.goTowardsBeeHive();
              b.move();

              if (b.getNextStage() == false) canMoveToNextStage = false;
            }

            for (Guardian g : guardians) {
              g.showGuardian();
              g.goTowardsBeeHive();
              g.move();

              if (g.getNextStage() == false) canMoveToNextStage = false;
            }

            if (canMoveToNextStage) {
              screenDisable();
              roundOver = false;
              gameMillis = 0;
              roundTime = 0;
              GTSelected = -1;
              // GTPurchased = false;
              GTOngoing = false;
              TFOTConfirmed = false;

              trainingFireflies = new ArrayList<Firefly>();

              for (Bee b : bees) {
                b.updateNextStage(false);
              }
              for (Guardian g : guardians) {
                g.updateNextStage(false);
              }
              forestsScreenActive = true;
            }
          } else {
            screenDisable();
            gameMillis += (timeMillis-pMillis);

            // guardianTrainScreenActive = true;
            guardianTrainDisplayRun();
            guardianTrainMechanicRun(true);
            //println(gameMillis, trainingFadeOutTimer);
          }
          break;
        }
      } else {

        drawCenterBeehive();

        fill(0);
        textSize(100);
        textAlign(CENTER);
        text("ROUND OVER", width/2, height/2);

        showMarketBtn.updateGreyOut(true);
        honeyFlucBtn.updateGreyOut(true);
        bottomStatsBar();

        for (Flower f : flowers) f.showFlower();

        for (Bee b : bees) {
          b.showBee();
          b.goTowardsBeeHive();
          b.move();

          if (b.getNextStage() == false) canMoveToNextStage = false;
        }

        for (Guardian g : guardians) {
          g.showGuardian();
          g.goTowardsBeeHive();
          g.move();

          if (g.getNextStage() == false) canMoveToNextStage = false;
        }

        if (canMoveToNextStage) {
          screenDisable();
          roundOver = false;
          gameMillis = 0;
          roundTime = 0;

          for (Bee b : bees) {
            b.updateNextStage(false);
          }
          for (Guardian g : guardians) {
                g.updateNextStage(false);
              }
          forestsScreenActive = true;
        }
      }
    }


    if (startupScreenActive == false) topStatsBar();
  }
}

void drawCenterBeehive() {
  stroke(252, 232, 100);
  fill(221, 114, 1);
  polygon(width/2, height/2, 15, 6); //beehive
  if (beehiveTier == 1) {
    polygon(width/2, height/2-(15*sqrt(3)), 15, 6); //U
    polygon(width/2-(15*3/2), height/2-(15*sqrt(3)/2), 15, 6); //LU
  } else if (beehiveTier == 2) {
    polygon(width/2, height/2-(15*sqrt(3)), 15, 6); //U
    polygon(width/2-(15*3/2), height/2-(15*sqrt(3)/2), 15, 6); //LU
    polygon(width/2-(15*3/2), height/2+(15*sqrt(3)/2), 15, 6); //LD
    polygon(width/2+(15*3/2), height/2-(15*sqrt(3)/2), 15, 6); //RU
  } else if (beehiveTier == 3) {
    polygon(width/2, height/2-(15*sqrt(3)), 15, 6); //U
    polygon(width/2-(15*3/2), height/2-(15*sqrt(3)/2), 15, 6); //LU
    polygon(width/2-(15*3/2), height/2+(15*sqrt(3)/2), 15, 6); //LD
    polygon(width/2+(15*3/2), height/2-(15*sqrt(3)/2), 15, 6); //RU
    polygon(width/2, height/2+(15*sqrt(3)), 15, 6); //D
    polygon(width/2+(15*3/2), height/2+(15*sqrt(3)/2), 15, 6); //RD
  }
  //ellipse(width/2, height/2, 10, 10); //center point
}

void topStatsBar() {
  //stats bar grey
  noStroke();
  fill(160);
  rect(0, 0, width, 30);



  stroke(252, 232, 100);
  strokeWeight(2);
  fill(221, 114, 1);
  pushMatrix();
  translate(50, 15);
  rotate(HALF_PI);
  polygon(0, 0, 12, 6); //beehive size icon
  popMatrix();

  textSize(12);
  if (beesCount < beehiveSize[beehiveTier]) fill(255);
  else fill(255, 0, 0);
  textAlign(LEFT);
  text(beesCount + " / " + beehiveSize[beehiveTier], 80, 19);

  if (honeyPotTier == 0) fill(255);
  else if (honeyPotTier == 1) fill(222, 168, 187);
  else if (honeyPotTier == 2) fill(184, 222, 168);
  else if (honeyPotTier == 3) fill(132, 134, 198);
  else if (honeyPotTier == 4) fill(139, 192, 211);
  else if (honeyPotTier == 5) fill(219, 139, 219);
  else if (honeyPotTier == 6) fill(169, 206, 135);

  text("Honey: ", 180, 19);
  if (honeyKg < honeyPotCapKg[honeyPotTier]) fill(255);
  else fill(255, 0, 0);
  text(honeyKg, 225, 19);

  //honeyMarket
  honeyPriceFlutuate();

  text("Money: $" + nfc(money), 480, 19);

  text("Time: ", 600, 19);
  strokeWeight(1);
  stroke(255);
  noFill();
  ellipse(660, 15, 26, 26);
  fill(255);
  arc(660, 15, 26, 26, -HALF_PI, map(roundTime, 0, ROUND_TIME, -HALF_PI, PI+HALF_PI), PIE); 

  textSize(12);
  textAlign(RIGHT);
  fill(255);
  text("Week: " +week, width-20, 19);



  fill(0);
  textAlign(RIGHT);
  text("Frame Rate: " + int(frameRate), width-20, 50);
  fill(105);
  textSize(9);
  text(VERSION, width-20, 65);

  pMillis = timeMillis;
  //    println(gameMillis);
}

void bottomStatsBar() {
  //bottom stats bar grey
  noStroke();
  fill(160);
  rect(0, height-40, width, 40);

  showMarketBtn.updateXY(width-120, height-37.5);
  honeyFlucBtn.updateXY(width-260, height-37.5);
  sellAllHoneyBtn.updateXY(width-400, height-37.5);
  sellAllHoneyBtn.updateSize(120, 35);



  showMarketBtn.Draw();
  sellAllHoneyBtn.Draw();
  honeyFlucBtn.Draw();

  showGuardianTrainBtn.updateGreyOut(true);
  if (GTOngoing) showGuardianTrainBtn.updateGreyOut(false);

  showGuardianTrainBtn.Draw();
}

void resetButtonPos() {
  showMarketBtn.updateXY(width-120, height-50);
  showForestBtn.updateXY(width-120, height-50);
  honeyFlucBtn.updateXY(width-130, 250);
  sellAllHoneyBtn.updateXY(width-130, 200);
}

void showStats() {
  println(gameOver);
}

void moveAllBees() {
  for (Bee b : bees) {
    b.updateShouldBeeMove(true);
  }
}

void screenDisable() {
  gameScreenActive = false;
  shopScreenActive = false;
  sellShopScreenActive = false;
  graphScreenActive = false;
  forestsScreenActive = false;
  guardianTrainScreenActive = false;
  GTShopScreenActive = false;
  BTShopScreenActive = false;
}

int beesSelectedPrev = 0, beesSelectedCurr = 0;
int guardsSelectedPrev = 0, guardsSelectedCurr = 0;
int GTSelected = -1; //default not selected any guardian training
boolean GTPurchased = false; //default not purchased any training course ofc
boolean GTOngoing = false; //selected -> purchased -> ongoing (next round)
void mouseReleased() {
  //universal
  if (buyMarketBtn.MouseClicked() || sellMarketBtn.MouseClicked()) {
    resetShopErrors();
  }

  if (startupScreenActive) {
    if (startGame.MouseClicked()) {
      screenDisable();
      startupScreenActive = false;
      gameScreenActive = true;
    }
  } else if (gameScreenActive) {
    boolean selectedObject = false;

    for (Bee b : bees) {
      if (b.getBeeSelectedStatus()) beesSelectedPrev++;
    }
    beesSelectedCurr = beesSelectedPrev;
    for (Bee b : bees) {
      float bx = b.getLocation().x;
      float by = b.getLocation().y;

      if (mouseX > bx-25 && mouseX < bx+25 && mouseY > by-25 && mouseY < by+25) {
        selectedObject = true;
        if (b.getBeeSelectedStatus() == false) {
          b.updateBeeSelectedStatus(true); //selected a bee
          beesSelectedCurr++;

          //deselect all guardians
          for (Guardian g : guardians) {
            g.updateGuardianSelectedStatus(false);
          }

          break; //only select ONE "UNSELECTED" bee
        } else {
          b.updateBeeSelectedStatus(false); //deselect a bee
          beesSelectedCurr--;
          break;
        }
      }
    }


    for (Guardian g : guardians) {
      if (g.getGuardianSelectedStatus()) guardsSelectedPrev++;
    }
    guardsSelectedCurr = guardsSelectedPrev;
    if (selectedObject == false) {
      for (Guardian g : guardians) {
        float gx = g.getLocation().x;
        float gy = g.getLocation().y;

        if (mouseX > gx-25 && mouseX < gx+25 && mouseY > gy-25 && mouseY < gy+25) {
          selectedObject = true;
          if (g.getGuardianSelectedStatus() == false) {
            g.updateGuardianSelectedStatus(true); //selected a guardian
            guardsSelectedCurr++;

            //deselect all bees
            for (Bee b : bees) {
              b.updateBeeSelectedStatus(false);
            }

            break; //only select ONE "UNSELECTED" guardian
          } else {
            g.updateGuardianSelectedStatus(false); //deselect a guardian
            guardsSelectedCurr--;
            break;
          }
        }
      }
    }

    int selectedFlowerID = -1;
    boolean goTowardsBeehive = false;
    int selectedHornetID = -1;
    if (beesSelectedCurr == 0 && selectedObject == false) { //selected no bee, but selected a target, so all bees go towards target
      for (int f = flowers.size ()-1; f >= 0; f--) {
        Flower _flower = flowers.get(f);
        float fx = _flower.getLocation().x;
        float fy = _flower.getLocation().y;

        if (mouseX > fx-15 && mouseX < fx+15 && mouseY > fy-15 && mouseY < fy+15) {
          selectedObject = true;
          //selected a flower
          selectedFlowerID = f;
          println("selected flower");
        }
      }

      if (mouseX > width/2-15 && mouseX < width/2+15 && mouseY > height/2-15 && mouseY < height/2+15) {
        selectedObject = true;

        goTowardsBeehive = true;
        println("going towards hive");
      }
    } else if (guardsSelectedCurr == 0 && selectedObject == false) { //selected no guardian but selected a hornet so all guardians go to that hornet
      for (int h = guardians.size ()-1; h >= 0; h--) {
        Guardian _guardian = guardians.get(h);
        float hx = _guardian.getLocation().x;
        float hy = _guardian.getLocation().y;

        if (mouseX > hx-15 && mouseX < hx+15 && mouseY > hy-15 && mouseY < hy+15) {
          selectedObject = true;
          //selected a hornet
          selectedHornetID = h;
          println("selected hornet "+h);
        }
      }
    }




    if (goTowardsBeehive) {
      for (Bee b : bees) {
        println("Returning all bees to beehive...");
        b.goTowardsBeeHive();
        b.updateBeeSelectedStatus(false); //neutralize (reset) the bee's busy state because it has a target
        b.updateBeeMoveTimer(gameMillis);
      }
    } else if (selectedFlowerID != -1) {
      Flower f = flowers.get(selectedFlowerID);
      float fx = f.getLocation().x;
      float fy = f.getLocation().y;
      int _pedalAmount = f.getPedalAmount();
      color[] _fColors = f.getStamenPedalColor();

      for (Bee b : bees) {
        float bx = b.getLocation().x;
        float by = b.getLocation().y;


        float hypotenuse = distance_between_two_points(bx, fx, by, fy);
        float _thetaRad = asin(abs(fy - by) / hypotenuse);
        println("Raw flower theta " + degrees(_thetaRad));
        float detX = fx - bx;
        float detY = fy - by;
        _thetaRad = returnRealTheta(_thetaRad, detX, detY);
        //    println(detX, detY, degrees(_thetaRad));
        b.updateBeeSelectedStatus(false); //neutralize (reset) the bee's busy state because it has a target
        b.updateMoveTheta(_thetaRad);
        b.updateBeeMoveTimer(gameMillis);

        b.updateBeeTarget("Flower");
        b.updateShouldBeeMove(true); //the bee can move out from other flowers
        b.transferFlowerPedalAmount(_pedalAmount);
        b.transferFlowerColors(_fColors);
        b.updateBeeTimeoutMove(false);
      }
    } else {
      // separated into two similar patterns because they actually different.
      // the following one only moves the bees that are selected while the one above moves all, and that requires only a single click.
      for (Bee b : bees) {
        float bx = b.getLocation().x;
        float by = b.getLocation().y;

        if (b.getBeeSelectedStatus() == true && beesSelectedCurr == beesSelectedPrev) {
          beesSelectedCurr = 0;
          beesSelectedPrev = 0;
          b.updateBeeSelectedStatus(false);

          if (mouseX > width/2-15 && mouseX < width/2+15 && mouseY > height/2-15 && mouseY < height/2+15) {
            b.goTowardsBeeHive();
            b.updateBeeMoveTimer(gameMillis);
          } else {
            //boolean selectedFlower = false;
            float fx = 0, fy = 0;
            int _pedalAmount = 0;
            color[] _fColors = new color[2];
            for (int f = flowers.size ()-1; f >= 0; f--) {
              Flower _flower = flowers.get(f);
              fx = _flower.getLocation().x;
              fy = _flower.getLocation().y;
              _pedalAmount = _flower.getPedalAmount();
              _fColors = _flower.getStamenPedalColor();
              if (distance_between_two_points(fx, mouseX, fy, mouseY) < 20) {
                selectedFlowerID = f;
                break; //break out of "for" to confirm these values
              }
            }

            if (selectedFlowerID >= 0) {
              float hypotenuse = distance_between_two_points(bx, fx, by, fy);
              float _thetaRad = asin(abs(fy - by) / hypotenuse);
              println("Raw mouse theta " + degrees(_thetaRad));
              float detX = fx - bx;
              float detY = fy - by;
              _thetaRad = returnRealTheta(_thetaRad, detX, detY);
              //    println(detX, detY, degrees(_thetaRad));
              b.updateMoveTheta(_thetaRad);
              b.updateBeeTarget("Flower");
              b.updateShouldBeeMove(true); //the bee can move out from other flowers
              b.transferFlowerPedalAmount(_pedalAmount);
              b.transferFlowerColors(_fColors);
              b.updateBeeTimeoutMove(false);
            } else {
              float hypotenuse = distance_between_two_points(bx, mouseX, by, mouseY);
              float _thetaRad = asin(abs(mouseY - by) / hypotenuse);
              println("Raw mouse theta " + degrees(_thetaRad));
              float detX = mouseX - bx;
              float detY = mouseY - by;
              _thetaRad = returnRealTheta(_thetaRad, detX, detY);
              //    println(detX, detY, degrees(_thetaRad));
              b.updateMoveTheta(_thetaRad);
              b.updateBeeTarget("None");
              b.updateBeeTimeoutMove(true);

              b.updateBeeMoveTimer(gameMillis);
            }
          }
        }
      }
    }

    if (selectedHornetID != -1) {
      Hornet h = hornets.get(selectedHornetID);
      float hx = h.getLocation().x;
      float hy = h.getLocation().y;

      for (Guardian g : guardians) {
        float gx = g.getLocation().x;
        float gy = g.getLocation().y;


        float hypotenuse = distance_between_two_points(gx, hx, gy, hy);
        float _thetaRad = asin(abs(hy - gy) / hypotenuse);
        println("Raw hornet theta " + degrees(_thetaRad));
        float detX = hx - gx;
        float detY = hy - gy;
        _thetaRad = returnRealTheta(_thetaRad, detX, detY);
        //    println(detX, detY, degrees(_thetaRad));
        g.updateGuardianSelectedStatus(false); //neutralize (reset) the bee's busy state because it has a target
        g.updateMoveTheta(_thetaRad);
        g.updateGuardianMoveTimer(gameMillis);

        g.updateGuardianTarget("Hornet");
        g.updateGuardianTimeoutMove(false);
      }
    } else {
      // separated into two similar patterns because they actually different.
      // the following one only moves the guardians that are selected while the one above moves all, and that requires only a single click.
      for (Guardian g : guardians) {
        float gx = g.getLocation().x;
        float gy = g.getLocation().y;

        if (g.getGuardianSelectedStatus() == true && guardsSelectedCurr == guardsSelectedPrev) {
          guardsSelectedCurr = 0;
          guardsSelectedPrev = 0;
          g.updateGuardianSelectedStatus(false);

          if (mouseX > width/2-15 && mouseX < width/2+15 && mouseY > height/2-15 && mouseY < height/2+15) {
          } else {
            //boolean selectedFlower = false;
            float hx = 0, hy = 0;
            for (int h = hornets.size ()-1; h >= 0; h--) {
              Hornet _hornet = hornets.get(h);
              hx = _hornet.getLocation().x;
              hy = _hornet.getLocation().y;
              if (distance_between_two_points(hx, mouseX, hy, mouseY) < 20) {
                selectedHornetID = h;
                break; //break out of "for" to confirm these values
              }
            }

            if (selectedHornetID >= 0) {
              float hypotenuse = distance_between_two_points(gx, hx, gy, hy);
              float _thetaRad = asin(abs(hy - gy) / hypotenuse);
              println("Raw mouse theta " + degrees(_thetaRad));
              float detX = hx - gx;
              float detY = hy - gy;
              _thetaRad = returnRealTheta(_thetaRad, detX, detY);
              //    println(detX, detY, degrees(_thetaRad));
              g.updateMoveTheta(_thetaRad);
              g.updateGuardianTarget("Hornet");
              g.updateGuardianTimeoutMove(false);
            } else {
              float hypotenuse = distance_between_two_points(gx, mouseX, gy, mouseY);
              float _thetaRad = asin(abs(mouseY - gy) / hypotenuse);
              println("Raw mouse theta " + degrees(_thetaRad));
              float detX = mouseX - gx;
              float detY = mouseY - gy;
              _thetaRad = returnRealTheta(_thetaRad, detX, detY);
              //    println(detX, detY, degrees(_thetaRad));
              g.updateMoveTheta(_thetaRad);
              g.updateGuardianTarget("None");
              g.updateGuardianTimeoutMove(true);

              g.updateGuardianMoveTimer(gameMillis);
            }
          }
        }
      }
    }

    if (honeyFlucBtn.MouseClicked()) {
      screenDisable();
      graphScreenActive = true;
    }
    if (showMarketBtn.MouseClicked()) {
      screenDisable();
      shopScreenActive = true;
    }
    if (showGuardianTrainBtn.MouseClicked()) {
      screenDisable();
      guardianTrainScreenActive = true;
    }
    /////
  } else if (shopScreenActive) {
    for (int i = 0; i < beeName.length; i++) {
      if (buyBee.get(i).MouseClicked()) buyBee(i);
    }
    for (int i = 0; i < guardianName.length; i++) {
      if (buyGuardian.get(i).MouseClicked()) buyGuardian(i);
    }
    for (int i = 0; i < honeyPotPrice.length-1; i++) {
      if (buyPot.get(i).MouseClicked()) buyPot(i+1);
    }
    for (int i = 0; i < beehivePrice.length-1; i++) {
      if (buyHive.get(i).MouseClicked()) buyHive(i+1);
    }

    if (honeyFlucBtn.MouseClicked()) {
      screenDisable();
      graphScreenActive = true;
    }
    if (showForestBtn.MouseClicked()) {
      if (roundTime == 0) {
        screenDisable();
        forestsScreenActive = true;
      } else {
        screenDisable();
        gameScreenActive = true;
      }
    }
    if (sellMarketBtn.MouseClicked()) {
      screenDisable();
      sellShopScreenActive = true;
    }
    if (GTMarketBtn.MouseClicked()) {
      screenDisable();
      GTShopScreenActive = true;
    }
    /////
  } else if (sellShopScreenActive) {
    for (int i = 0; i < beeName.length; i++) {
      if (sellBee.get(i).MouseClicked()) sellBee(i);
    }
    for (int i = 0; i < guardianName.length; i++) {
      if (sellGuardian.get(i).MouseClicked()) sellGuardian(i);
    }
    //for (int i = 0; i < honeyPotPrice.length-1; i++) {
    //  if (sellPot.get(i).MouseClicked()) sellPot(i+1);
    //}
    //for (int i = 0; i < beehivePrice.length-1; i++) {
    //  if (sellHive.get(i).MouseClicked()) sellHive(i+1);
    //}

    if (honeyFlucBtn.MouseClicked()) {
      screenDisable();
      graphScreenActive = true;
    }
    if (showForestBtn.MouseClicked()) {
      if (roundTime == 0) {
        screenDisable();
        forestsScreenActive = true;
      } else {
        screenDisable();
        gameScreenActive = true;
      }
    }
    if (buyMarketBtn.MouseClicked()) {
      screenDisable();
      shopScreenActive = true;
    }
    if (GTMarketBtn.MouseClicked()) {
      screenDisable();
      GTShopScreenActive = true;
    }
    /////
  } else if (graphScreenActive) {

    if (showMarketBtn.MouseClicked()) {
      if (roundTime == 0) {
        screenDisable();
        forestsScreenActive = true;
      } else {
        screenDisable();
        gameScreenActive = true;
      }
    }
    if (sell10kg.MouseClicked()) sellHoney(10);
    else if (sell100kg.MouseClicked()) sellHoney(100);
    else if (sell1000kg.MouseClicked()) sellHoney(1000);
    /////
  } else if (forestsScreenActive) {

    for (int fb = forestBtns.size ()-1; fb >= 0; fb--) {
      CircleButton _forestBtn = forestBtns.get(fb);

      if (_forestBtn.MouseClicked()) initializeForest(fb);
    }

    if (honeyFlucBtn.MouseClicked()) {
      screenDisable();
      graphScreenActive = true;
    }
    if (showMarketBtn.MouseClicked()) {
      screenDisable();
      shopScreenActive = true;
    }
    /////
  } else if (guardianTrainScreenActive) {

    if (showForestBtn.MouseClicked()) {
      if (roundTime == 0) {
        screenDisable();
        forestsScreenActive = true;
      } else {
        screenDisable();
        gameScreenActive = true;
      }
    }


    float gx = trainingGuardian.getLocation().x;
    float gy = trainingGuardian.getLocation().y;

    int selectedFireflyID = -1;
    if (mouseX > gx-25 && mouseX < gx+25 && mouseY > gy-25 && mouseY < gy+25) {
      if (trainingGuardian.getGuardianSelectedStatus() == false) trainingGuardian.updateGuardianSelectedStatus(true); //selected the guardian
      else trainingGuardian.updateGuardianSelectedStatus(false); //deselect the guardian
    } else if (trainingGuardian.getGuardianSelectedStatus() == true) { //if the guardian is selected (the only situation that it can be assigned a target)
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
    }

    /////
  } else if (GTShopScreenActive) {

    if (showForestBtn.MouseClicked()) {
      if (roundTime == 0) {
        screenDisable();
        forestsScreenActive = true;
      } else {
        screenDisable();
        gameScreenActive = true;
      }
    }
    if (buyMarketBtn.MouseClicked()) {
      screenDisable();
      shopScreenActive = true;
    }
    if (sellMarketBtn.MouseClicked()) {
      screenDisable();
      sellShopScreenActive = true;
    }
    for (int _btn = upgradeGuardian.size()-1; _btn >= 0; _btn--) {
      Button btn = upgradeGuardian.get(_btn);
      if (btn.MouseClicked()) {
        GTSelected = _btn;
      }
    }
    if (GTPurchase.MouseClicked()) {
      GTPurchased = true;
      money -= upgradeGuardianCost[GTSelected][0];

      //adding objectives, removing the guardian, assigning the trainingGuardian in NewForest.pde
    }
    if (GTSell.MouseClicked()) {
      for (int _g = guardians.size()-1; _g >= 0; _g--) {
        Guardian g = guardians.get(_g);
        if (g.getGuardianName().equals(upgradedGuardianName[GTSelected])) {
          guardians.remove(_g);
          break; //break out of "for" since it only sells 1 of that guardian
        }
      }
      money += upgradeGuardianCost[GTSelected][0]/2;
    }
  }

  //universal buttons
  if (sellAllHoneyBtn.MouseClicked()) {
    sellHoney(honeyKg);
  }
}

boolean invincibleBees = false;
//boolean beeTimeoutMove = true;
void keyReleased() {
  switch (key) {     
  case 'g':
  case 'G':
    guardians.add(new Guardian(guardianName[0])); 
    break;

  case 'h':
  case 'H':
    hornets.add(new Hornet(hornetFlightSpeed[0]));
    break;

  case 'd':
  case 'D':
    debug = !debug;
    break;

  case 'i':
  case 'I':
    invincibleBees = !invincibleBees;
    println("Invincible Bees turned to: " + invincibleBees);
    break;

  case 'm':
    money += 5000;
    break;
  case 'M':
    money += 50000;
    break;

  case 's':
  case 'S':
    //sell all honey
    money += honeyKg * honeyPrice;
    honeyKg = 0;
    break;

  case 'f':
  case 'F':
    flowers.add(new Flower(10+random(width-20), 40+random(height-40-50), forestHoneyRng[forestType][0], forestHoneyRng[forestType][1]));
    break;

  case 'w':
  case 'W':
    gameMillis = ROUND_TIME;
    break;

  case '1':
  case '2':
  case '3':
  case '4':
  case '5':
  case '6':
    println(int(key)-49);
    buyBee(int(key)-49);    
    break;

  case 'z':
  case 'Z':
    if (flowers.size()>0) flowers.remove(0);
    break;

    //  case 'm':
    //  case 'M':
    //    for (Bee b : bees) {
    //      b.updateBeeTimeoutMove(!b.getBeeTimeoutMove());
    //      println(b.getBeeTimeoutMove());
    //    }
    //    break;

  case 'p':
  case 'P':
    println('X', mouseX, 'Y', mouseY);
    break;

  case 'l':
    fireflies.add(new Firefly(false));
    break;

  case 't':
  case 'T':
    for (int i = trainingFireflies.size()-1; i >= 0; i--) {
      trainingFireflies.remove(i);
    }
    break;
  }
}