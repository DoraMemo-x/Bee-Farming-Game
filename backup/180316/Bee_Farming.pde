ArrayList<Flower> flowers = new ArrayList<Flower>(); //<>// //<>// //<>//
ArrayList<Bee> bees = new ArrayList<Bee>();
ArrayList<Hornet> hornets = new ArrayList<Hornet>();
ArrayList<Firefly> fireflies = new ArrayList<Firefly>();
ArrayList<Guardian> guardians = new ArrayList<Guardian>();

TrainingGuardian trainingGuardian;
ArrayList<Bee> GTBees = new ArrayList<Bee>(); //for bouncer guardian
ArrayList<Firefly> GTFireflies = new ArrayList<Firefly>(); //for royal guardian, hunting guardian, ranged guardian
ArrayList<Hornet> GTHornets = new ArrayList<Hornet>(); //for hunting guardian, ranged guardian
ArrayList<Ladybug> GTLadybugs = new ArrayList<Ladybug>(); //for hunting guardian
ArrayList<Flower> GTFlowers = new ArrayList<Flower>(); //for baiting guardian

TrainingBee trainingBee;
ArrayList<Satanic> BTDemons = new ArrayList<Satanic>(); //for priest bee
ArrayList<ItemSpawn> BTItems = new ArrayList<ItemSpawn>(); //for priest bee

//Shop showcase icons
ArrayList<Bee> showcaseBees = new ArrayList<Bee>();
ArrayList<Guardian> showcaseGuardians = new ArrayList<Guardian>();

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
ArrayList<Button> upgradeBee = new ArrayList<Button>();

static /*final*/ long ROUND_TIME = 180000;
static final int GAME_WEEK_LENGTH = 15; //15*3 = 45min
int honeyKg = 0;
//int[] stamen = new int[6]; //D C B A S SS
boolean gameScreenActive = false, shopScreenActive = false, sellShopScreenActive = false, 
  GTShopScreenActive = false, BTShopScreenActive = false, graphScreenActive = false, 
  forestsScreenActive = false, guardianTrainScreenActive = false, beeTrainScreenActive = false, 
  beeInventoryScreenActive = false, guardianInventoryScreenActive = false, itemInventoryScreenActive = false, 
  startupScreenActive = true, tutorialScreenActive = false, questScreenActive = false;

boolean roundOver = false, gameOver = false;

long timeMillis = System.currentTimeMillis(), pMillis = System.currentTimeMillis(), timePassed;
long gameMillis = 0;
long roundTime = 0;
int week = 1;

static final String VERSION = "Ver 18.03.16 <Alpha>";
boolean debug = false;

Button startGame;

void setup() {
  //if (debug) ROUND_TIME = 3000; //can be achieved by pressed 'w'

  size(800, 600);
  noFill();
  smooth(); //i dont know what effect it has but it looks fancier
  frameRate(60);

  startGame = new Button("Start Game", width/2-75, height/2+110, 150, 50, 251, 200, 55, 119, 94, 26, false, "default");
  //loadGame = ...
  startTutorial = new Button("Tutorial", width/2-75, height/2+220, 150, 40, 251, 200, 55, 119, 94, 26, false, "default");
  update = new Button("Update Game?", width/1.35, height/2+110+10, 150, 40, 251, 200, 55, 119, 94, 26, false, "default");
  changeLanguage = new Button("中文", width/2-75-150-100, height/2+110+10, 150, 40, 251, 200, 55, 119, 94, 26, false, "default");

  //tutorial
  nextPrompt = new Button("NEXT", width/2-75, height/2+220, 150, 40, 251, 200, 55, 119, 94, 26, false, "default");
  retryTutorial = new Button("Retry", width-170, height/2+220, 150, 40, 251, 200, 55, 119, 94, 26, false, "default");

  //general buttons
  showMarketBtn = new Button("Market", width-120, height-40, 100, 35, 251, 200, 55, 119, 94, 26, false, "default");
  showForestBtn = new Button("Forest", width-120, height-40, 100, 35, 251, 200, 55, 119, 94, 26, false, "default");
  honeyFlucBtn = new Button("Honey Fluc. Graph", width-260, height-40, 120, 35, 251, 200, 55, 119, 94, 26, false, "default");
  saveBtn = new Button("Save", width-150, 200, 100, 35, 251, 200, 55, 119, 94, 26, false, "default");
  loadBtn = new Button("Load Save", width/2-75, height/2+172.5, 150, 35, 251, 200, 55, 119, 94, 26, false, "default"); //forest location: width-150, 250
  questBtn = new Button("Quests", width-780, height-37.5, 100, 35, 251, 200, 55, 119, 94, 26, false, "default");
  questBtn.updateGreyOut(true);

  buyMarketBtn = new Button("Item Shop", width-180, height-120, 100, 35, 251, 200, 55, 119, 94, 26, false, "default");
  //sellMarketBtn = new Button("Sell Items", width-300, height-120, 100, 35, 251, 200, 55, 119, 94, 26, false, "default"); //will be removed after tutorial is changed
  inventoryBtn.add(new Button("Bee Inventory", width-300, height-120, 100, 35, 251, 200, 55, 119, 94, 26, false, "default"));
  inventoryBtn.add(new Button("G. Inventory", width-300, height-120, 100, 35, 251, 200, 55, 119, 94, 26, false, "default"));
  inventoryBtn.add(new Button("Item Inventory", width-300, height-120, 100, 35, 251, 200, 55, 119, 94, 26, false, "default"));
  GTMarketBtn = new Button("G. Training", width-300, height-165, 100, 35, 251, 200, 55, 119, 94, 26, false, "default");
  BTMarketBtn = new Button("Bee Training", width-180, height-165, 100, 35, 251, 200, 55, 119, 94, 26, false, "default");

  sellAllHoneyBtn = new Button("Sell All Honey", width-400, height-40, 120, 35, 251, 200, 55, 119, 94, 26, false, "default");
  sell10kg = new Button("Sell 10kg Honey", width-130, 260, 120, 40, 251, 200, 55, 119, 94, 26, false, "default");
  sell100kg = new Button("Sell 100kg Honey", width-130, 320, 120, 40, 251, 200, 55, 119, 94, 26, false, "default");
  sell1000kg = new Button("Sell 1000kg Honey", width-130, 380, 120, 40, 251, 200, 55, 119, 94, 26, false, "default");

  shopSetup();
  inventorySetup();

  forestSetup();

  //training shop - guardians
  for (int i = 0; i < upgradedGuardianName.length; i++) {
    upgradeGuardian.add(new Button(upgradedGuardianName[i], 50, 70+60*i, 150, 40, 255, 255, 0, 200, 200, 0, false, "default"));
  }
  GTPurchase = new Button("Purchase", width-355, height-240, 160, 35, 251, 200, 55, 119, 94, 26, false, "default");
  GTPurchase.updateGreyOut(true);
  demoTabLeft = new Button("←", 240, 380, 15, 15, 251, 200, 55, 180, 180, 180, true, "0");
  demoTabRight = new Button("→", 260, 380, 15, 15, 251, 200, 55, 180, 180, 180, true, "0");

  //training shop - bees
  for (int i = 0; i < upgradedBeeName.length; i++) {
    upgradeBee.add(new Button(upgradedBeeName[i], 50, 70+60*i, 150, 40, 255, 255, 0, 200, 200, 0, false, "default"));
  }
  BTPurchase = new Button("Purchase", width-355, height-240, 160, 35, 251, 200, 55, 119, 94, 26, false, "default");
  BTPurchase.updateGreyOut(true);

  //training screen - guardian
  showGuardianTrainBtn = new Button("Guard. Training", width-540, height-37.5, 120, 35, 251, 200, 55, 119, 94, 26, false, "default");
  GTObjCancel = new CircleButton("C", "", width-160, height-32.5, 35, 35, 251, 200, 55, 119, 94, 26); //hunting guardian: cancel trap area
  GTAbilityUse = new CircleButton("S", "", width-160, height-32.5, 35, 35, 251, 200, 55, 119, 94, 26); //ranged guardian: use sting

  collapsibleBtn = new Button("", width-540, height-37.5, 30, 130, 200, 200, 200, 200, 200, 200, false, "0");

  //training screen - bee
  showBeeTrainBtn = new Button("Bee Training", width-660, height-37.5, 100, 35, 251, 200, 55, 119, 94, 26, false, "default");
  for (int i = 0; i < BTAbility.length; i++) BTAbility[i] = new Button("Ability " + i, 2.5, height-32.5, 80, 30, 70, 255, 70, 0, 100, 0, false, "default");
  for (int i = 0; i < BTAbility2.length; i++) BTAbility2[i] = new threeDButton("Ability " + i, 12, 7.5 + 95*i, height-37.5, 80, 30, 5, color(200, 255, 200), color(150, 200, 150), color(120, 255, 120), color(70, 255, 70), color(0, 36, 0));
  BTFlowerStage[0] = loadImage("FlowerStage1.png");
  BTFlowerStage[1] = loadImage("FlowerStage2.png");
  BTFlowerStage[2] = loadImage("FlowerStage3.png");
  BTFlowerStage[3] = loadImage("FlowerStage4.png");
  BTFlowerStage[4] = loadImage("FlowerStage5.png");
  BTFlowerStage[5] = loadImage("FlowerStage6.png");
  BTFlowerStage[6] = loadImage("FlowerStage6_Trimmed.png");
  BTDryFlowerStage[0] = loadImage("FlowerStage1_Dry.png");
  BTDryFlowerStage[1] = loadImage("FlowerStage2_Dry.png");
  BTDryFlowerStage[2] = loadImage("FlowerStage3_Dry.png");
  BTDryFlowerStage[3] = loadImage("FlowerStage4_Dry.png");
  BTDryFlowerStage[4] = loadImage("FlowerStage5_Dry.png");
  BTDryFlowerStage[5] = loadImage("FlowerStage6_Dry.png");
  BTDryFlowerStage[6] = loadImage("FlowerStage6_Dry_Trimmed.png");
  BTFertilizer = loadImage("Fertilizer.png");
  BTCrackedPattern = loadImage("CrackedPattern.png");

  //Quest
  quest1 = new Button("Claim Reward", width-350, 190, 120, 35, 251, 200, 55, 119, 94, 26, false, "default");
  quest2 = new Button("Claim Reward", width-350, 460, 120, 35, 251, 200, 55, 119, 94, 26, false, "default");
  toggleEnemyFree = new Button("Toggle Enemy Free", width-185, 125+15*4, 150, 30, 251, 200, 55, 119, 94, 26, false, "default");

  beesCount = bees.size() + guardians.size();

  ladybug = loadImage("ladybug.png");
  pomegranateImage = loadImage("pomegranate.png");
  resourceImage[0] = loadImage("Resource_HolyWater.png");
  resourceImageGray[0] = loadImage("Resource_HolyWater.png");
  resourceImage[1] = loadImage("Resource_HolyCross.png");
  resourceImageGray[1] = loadImage("Resource_HolyCross.png");
  resourceImage[2] = loadImage("Resource_Bible.png");
  resourceImageGray[2] = loadImage("Resource_Bible.png");
  resourceImage[3] = loadImage("Resource_HolyBranch.png");
  resourceImageGray[3] = loadImage("Resource_HolyBranch.png");
  resourceImage[4] = loadImage("Resource_Z-Virus.png");
  resourceImageGray[4] = loadImage("Resource_Z-Virus.png");
  resourceImage[5] = loadImage("Resource_SoulEssence.png");
  resourceImageGray[5] = loadImage("Resource_SoulEssence.png");
  resourceImage[6] = loadImage("Resource_BeeGuts.png");
  resourceImageGray[6] = loadImage("Resource_BeeGuts.png");
  resourceImage[8] = loadImage("Resource_Fork.png");
  resourceImageGray[8] = loadImage("Resource_Fork.png");
  resourceImage[9] = loadImage("Resource_Shovel.png");
  resourceImageGray[9] = loadImage("Resource_Shovel.png");
  resourceImage[10] = loadImage("Resource_WateringCan.png");
  resourceImageGray[10] = loadImage("Resource_WateringCan.png");
  resourceImage[11] = loadImage("Resource_Shears.png");
  resourceImageGray[11] = loadImage("Resource_Shears.png");
  resourceImage[12] = loadImage("Resource_Flag.png");
  resourceImageGray[12] = loadImage("Resource_Flag.png");
  resourceImage[13] = loadImage("Resource_Injection.png");
  resourceImageGray[13] = loadImage("Resource_Injection.png");
  resourceImage[14] = loadImage("Resource_SkaterBoots.png");
  resourceImageGray[14] = loadImage("Resource_SkaterBoots.png");
  for (int i = 0; i < 7; i++) resourceImageGray[i].filter(GRAY);
  for (int i = 8; i < 15; i++) resourceImageGray[i].filter(GRAY);

  //for (int i = 8; i < 12; i++) inventoryResources.add(new Resource(i));
  //inventoryResources.add(new Resource(12));
  //inventoryResources.add(new Resource(14));
  //for (int i = 8; i < 12; i++) inventoryResources.add(new Resource(i));

  checkUpdate();
  //exit();
  assignQuest();

  String current = (VERSION.substring(4, 6)) + (VERSION.substring(7, 9)) + (VERSION.substring(10, 12));
  outputLog = createWriter("/logs/" + current + "-" +year()+nf(month(), 2)+nf(day(), 2)+"-"+nf(hour(), 2)+nf(minute(), 2)+nf(second(), 2)+".txt");
}

void draw() {
  if (keyPressed && key == ' ') {
    nextPrompt.Draw();
    retryTutorial.Draw();
  }

  timeMillis = System.currentTimeMillis();

  timePassed = timeMillis - pMillis;

  if (gameOver) {
    background(255, 150, 0);
    showStats();
  } else {
    beesCount = bees.size() + guardians.size();

    //questEnemyProg += fireflies.size() + hornets.size() - pEnemies;\



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
      loadBtn.Draw(); 
      startTutorial.Draw(); 

      String latestVer;
      if (ERROR_CHKUPDT == false) {
        latestVer = trim(form[2].substring(0, 15)); 
        latestVer = latestVer.substring(0, 7) + latestVer.substring(8, 11) + latestVer.substring(12);
      } else latestVer = "ERR_NO_CONNECTION";
      if (oldPrompt) {
        update.Draw(); 

        fill(50); 
        textAlign(CENTER); 
        text("The latest build is: " + latestVer, width/1.35+75, height/2+110+68);
      } else if (latestVerPrompt) {
        fill(50); 
        textAlign(CENTER); 
        text("Your game is up to date!", width/1.35+75, height/2+110+68);
      } else if (devVerPrompt) {
        fill(50); 
        textAlign(CENTER); 
        text("Your build of the game is in development.", width/1.35+75, height/2+110+130); 
        text("The latest official build is: " + latestVer, width/1.35+75, height/2+110+130+15);
      } else if (ERROR_CHKUPDT) {
        fill(50); 
        textAlign(LEFT); 
        text("No internet connection or the check-update function", width/1.625, height/2+110+130); 
        text("is broken. Consider contacting the developer.", width/1.625, height/2+110+130+15);
      }

      //changeLanguage.Draw();
    }


    if (tutorialScreenActive) {
      tutorialDisplay();
    }

    if (gameScreenActive) {
      gameMillis += timePassed; 
      roundTime = gameMillis; 

      background(255); 

      fill(75, 125, 75); 
      textSize(11); 
      textAlign(LEFT); 
      text("Forest: " + forestName[forestType], 20, 55);

      //debugging
      //textAlign(CENTER);
      //textSize(10);
      //fill(50);
      //for (int i = bees.size()-1; i >= 0; i--) {
      //  Bee b = bees.get(i);
      //  text(i, b.getLocation().x, b.getLocation().y+20);
      //}

      bottomStatsBar(); 

      drawCenterBeehive(); 

      //fill(0);
      //textAlign(RIGHT);
      //text("Honey: " + honeyKg + "kg", width-20, 20);

      //println("Bees Alive Status:");
      boolean allBeesDead = false; 
      for (int i = 0; i < isBeeDead.length; i++) isBeeDead[i] = false; 
      for (int _bee = bees.size()-1; _bee >= 0; _bee--) {
        allBeesDead = false; 
        Bee b = bees.get(_bee); 

        //debug report
        //println(_bee, b.getBeeName(), b.getIsAlive()?"is alive":"is DEAD");

        if (b.getIsAlive() == false) {
          isBeeDead[_bee] = true; 
          inventoryBees.get(_bee).updateIsAlive(false); 
          allBeesDead = true; //if all bees are dead, this will stay true
        } else {
          isBeeDead[_bee] = false; 
          inventoryBees.get(_bee).updateIsAlive(true);
        }
      }
      //println("Ending Bees Report");
      //println();

      //reset the shop notification
      ERRORnotEnoughMoney = false; 
      ERRORbeehiveFull = false; 
      ERRORpotTierLow = false; 

      for (Flower f : flowers) { 
        f.showFlower();
      }
      for (Bee b : bees) {
        b.showBee(); 
        b.move(); //now contains pick honey mechanic
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
        if ((hx > width || hx < 0 || hy > height-40 || hy < 25) && allBeesDead) hornets.remove(h);
      }
      for (ItemSpawn is : resourceAppear) {
        is.showItem();
      }
      for (int _projectile = projectiles.size ()-1; _projectile >= 0; _projectile--) {
        ProjectileWeapon pw = projectiles.get(_projectile); 
        if (pw.getForTraining() == false) {
          pw.showProjectile(); 
          pw.move(); 

          float px = pw.getLocation().x; 
          float py = pw.getLocation().y; 
          if (px > width+5 || px < -5 || py > height+5 || py < 0) projectiles.remove(_projectile);
          if (pw.getCanRemove() && pw.getProjectileType() == 2) {
            for (Guardian g : guardians) {
              if (g.getGuardianType() == 5 && g.getDistinctID() == pw.getID()) { //if it's a border guardian, with that projectile id
                g.updateCDAbility(false);
                break;
              }
            }
            projectiles.remove(_projectile);
          }
        }
      }
      //flower generation over time
      createFlower(); 
      //hornet spawn
      if (effectTakingPlace[1][0] == 0 && enemyFree == false) spawnHornet(); 
      //resource item spawn
      spawnResource(); 
      //enemyFree cooldown
      if (effectTakingPlace[1][0] != 0 && enemyFree && toggleEnemyTimer <= 30000 && roundTime != 0) toggleEnemyTimer += timePassed;


      //<START> maintaining the g. training gameplay
      if (GTOngoing) {
        guardianTrainMechanicRun(false); 

        if (GTSelected == 2) { //hunting guardian
          if (dotPos.isEmpty()) {
            pos = new ArrayList(); 
            GTObjectToggle = false;
          }
        }
      }

      //<END> maintaining the g. training gameplay

      //<START> maintaining the bee training gameplay
      if (BTOngoing) {
        beeTrainMechanicRun(false);
      }
      //<END> maintaining the bee training gameplay
    }



    if (questScreenActive) {
      background(235); 

      showQuest();
      showForestBtn.Draw();
    }



    if (shopScreenActive) {
      background(235); 

      resetButtonPos(); 

      showForestBtn.Draw(); 
      sellAllHoneyBtn.Draw(); 
      honeyFlucBtn.Draw(); 

      buyMarketBtn.updateGreyOut(true); 
      buyMarketBtn.Draw(); 
      invTabLeft.Draw(); 
      invTabRight.Draw(); 
      inventoryBtn.get(invBtn).Draw(); 

      GTMarketBtn.updateGreyOut(false); 
      GTMarketBtn.Draw(); 
      BTMarketBtn.updateGreyOut(false); 
      BTMarketBtn.Draw(); 

      showMarket();
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

      buyMarketBtn.updateGreyOut(false); 
      buyMarketBtn.Draw(); 
      invTabLeft.Draw(); 
      invTabRight.Draw(); 
      inventoryBtn.get(invBtn).Draw(); 

      GTMarketBtn.updateGreyOut(false); 
      GTMarketBtn.Draw(); 
      BTMarketBtn.updateGreyOut(false); 
      BTMarketBtn.Draw();
    }



    if (forestsScreenActive) {
      background(150, 255, 150); 

      saveBtn.Draw(); 
      loadBtn.Draw(); 



      showForestMenu(); 
      String[] enterForestText = {"Enter this forest"}; //each forest's description
      String[] enterHornetForestText = { "Enter this forest", "WARNING: HORNETS"}; 
      String[] enterFHForestText = {"Enter this forest", "WARNING: HORNETS", "WARNING: FIREFLIES"}; 
      for (int fb = forestBtns.size ()-1; fb >= 0; fb--) {
        CircleButton _circleButton = forestBtns.get(fb); 
        if (_circleButton.getMouseIsOver()) {
          if (fb >= 6) drawPopupWindow(enterFHForestText, 0, 12, mouseX, mouseY, true, 0, width); 
          else if (fb < 3) drawPopupWindow(enterForestText, 0, 12, mouseX, mouseY, true, 0, width); 
          else drawPopupWindow(enterHornetForestText, 0, 12, mouseX, mouseY, true, 0, width);
        }
      }
    }




    if (guardianTrainScreenActive) {
      println("GT screen running"); 
      gameMillis += (timeMillis-pMillis); 
      roundTime = gameMillis; 

      guardianTrainDisplayRun(); 
      guardianTrainMechanicRun(true); 



      //<START> maintaining the normal gameplay
      for (Firefly ff : fireflies) {
        ff.showFirefly(); 
        ff.move();
      }
      for (Guardian g : guardians) g.move(); 
      for (Hornet h : hornets) h.move(); 
      for (Bee b : bees) {
        b.move();
      }
      for (ProjectileWeapon pw : projectiles) {
        if (pw.getForTraining() == false) {
          pw.move();
        }
      }

      //flower generation over time
      createFlower(); 
      //hornet spawn
      if (effectTakingPlace[1][0] == 0 && enemyFree == false) spawnHornet(); 
      //resource item spawn
      spawnResource(); 
      //enemyFree cooldown
      if (effectTakingPlace[1][0] != 0 && enemyFree && toggleEnemyTimer <= 30000 && roundTime != 0) toggleEnemyTimer += timePassed;
      //<END> maintaining the normal gameplay

      //<START> maintaining the bee training gameplay
      if (BTOngoing) {
        beeTrainMechanicRun(false);
      }
      //<END> maintaining the bee training gameplay
    }

    if (beeTrainScreenActive) {
      gameMillis += (timeMillis-pMillis); 
      roundTime = gameMillis; 

      beeTrainDisplayRun(); 
      beeTrainMechanicRun(true); 



      //<START> maintaining the normal gameplay
      for (Firefly ff : fireflies) {
        ff.showFirefly(); 
        ff.move();
      }
      for (Guardian g : guardians) g.move(); 
      for (Hornet h : hornets) h.move(); 
      for (Bee b : bees) {
        b.move();
      }
      for (ProjectileWeapon pw : projectiles) {
        if (pw.getForTraining() == false) {
          pw.move();
        }
      }

      //flower generation over time
      createFlower(); 
      //hornet spawn
      if (effectTakingPlace[1][0] == 0 && enemyFree == false) spawnHornet(); 
      //resource item spawn
      spawnResource(); 
      //enemyFree cooldown
      if (effectTakingPlace[1][0] != 0 && enemyFree && toggleEnemyTimer <= 30000 && roundTime != 0) toggleEnemyTimer += timePassed;
      //<END> maintaining the normal gameplay

      //<START> maintaining the g. training gameplay
      if (GTOngoing) {
        guardianTrainMechanicRun(false); 

        if (GTSelected == 2) { //hunting guardian
          if (dotPos.isEmpty()) {
            pos = new ArrayList(); 
            GTObjectToggle = false;
          }
        }
      }
      //<END> maintaining the g. training gameplay
    }



    if (GTShopScreenActive) {
      background(230); 
      GTShopActive();
    }

    if (BTShopScreenActive) {
      background(230); 
      BTShopActive();
    }



    if (beeInventoryScreenActive) {
      beeInventoryActive();
    }

    if (guardianInventoryScreenActive) {
      guardianInventoryActive();
    }

    if (itemInventoryScreenActive) {
      itemInventoryActive();
    }

    //fix for inventory button greyouts
    if (beeInventoryScreenActive == false && guardianInventoryScreenActive == false && itemInventoryScreenActive == false) {
      for (Button b : inventoryBtn) { 
        b.updateGreyOut(false);
      }
    }








    //ROUND OVER
    if (roundTime >= ROUND_TIME && tutorialScreenActive == false) {
      //round over. return all bees to beehive
      roundOver = true; 
      boolean canMoveToNextStage = true; 

      for (int i = resourceAppear.size()-1; i >=0; i--) {
        resourceAppear.remove(i);
      }



      if (GTOngoing) {
        if (GTFOTConfirmed == false) {
          GTFOTConfirmed = true; 
          GTFadeOutTimer = gameMillis;
        }

        //BELOW: ONLY GETS RUN WHEN PLAYER FAILS THE COURSE.
        if (gameMillis - GTFadeOutTimer > 5000) {
          screenDisable(); 
          gameScreenActive = true; 

          drawCenterBeehive(); 

          fill(0); 
          textSize(100); 
          textAlign(CENTER); 
          text("RND OVER (GT)", width/2, height/2); 

          showMarketBtn.updateGreyOut(true); 
          honeyFlucBtn.updateGreyOut(true); 
          bottomStatsBar(); 

          for (Flower f : flowers) f.showFlower(); 

          for (Bee b : bees) {
            b.showBee(); 
            b.goTowardsBeeHive(); 
            b.move(); 
            b.move(); //move twice as fast

            if (b.getIsAlive() == false) continue; 

            if (b.getNextStage() == false) canMoveToNextStage = false;
          }

          for (Guardian g : guardians) {
            g.showGuardian(); 
            g.goTowardsBeeHive(); 
            g.move(); 
            g.move(); //move twice as fast

            if (g.getNextStage() == false) canMoveToNextStage = false;
          }

          if (canMoveToNextStage) {
            //if (week == 15) gameOver = true; 

            screenDisable(); 
            roundOver = false; 
            gameMillis = 0; 
            roundTime = 0; 
            resetGTVars(); 

            GTFireflies = new ArrayList<Firefly>(); 
            GTHornets = new ArrayList<Hornet>(); 
            GTFlowers = new ArrayList<Flower>(); 
            GTLadybugs = new ArrayList<Ladybug>(); 
            projectiles = new ArrayList<ProjectileWeapon>(); 
            pomegranate = new ArrayList<ItemSpawn>(); 

            for (int t = 0; t < 2; t++) { //do it twice so the isBeeDead gets correctly updated after all dead bees have been removed
              for (int i = bees.size()-1; i >= 0; i--) {
                isBeeDead[i] = false; 

                Bee b = bees.get(i); 

                if (b.getIsAlive() == false) {
                  //isBeeDead[i] = true;
                  inventoryBees.remove(i); 
                  bees.remove(i); //if after a round that bee is still dead (not sold / revived), then remove that bee.
                }
              }
            }

            if (bees.isEmpty()) {
              // due to the new mechanic (remove dead bees after a round)
              // if all bees have died (aka all bees have been removed)
              // then game over.
              gameOver = true; 
              return; //cut the rest code
            }

            resetBeeInvPositions(); 
            resetGuardianInvPositions(); 
            resetItemInvPositions(); 
            beeInvSelected = -1; 
            guardianInvSelected = -1; 
            itemInvSelected = -1; 

            for (int bee = bees.size()-1; bee >= 0; bee--) {
              Bee b = bees.get(bee); 

              b.updateNextStage(false); 
              //if (b.getIsAlive() == false) bees.remove(bee);
            }
            for (Guardian g : guardians) {
              g.updateNextStage(false);
            }
            forestsScreenActive = true;
            week += 1;
          }
        } else { //guardian training not completely finished. forcefully change the view to training screen
          screenDisable(); 
          guardianTrainScreenActive = true;
        }
        ////////////////
      } else if (BTOngoing) {
        if (BTFOTConfirmed == false) {
          BTFOTConfirmed = true; 
          BTFadeOutTimer = gameMillis;
        }

        //BELOW: ONLY GETS RUN WHEN PLAYER FAILS THE COURSE.
        if (gameMillis - BTFadeOutTimer > 5000) {
          screenDisable(); 
          gameScreenActive = true; 

          drawCenterBeehive(); 

          fill(0); 
          textSize(100); 
          textAlign(CENTER); 
          text("RND OVER (BT)", width/2, height/2); 

          showMarketBtn.updateGreyOut(true); 
          honeyFlucBtn.updateGreyOut(true); 
          bottomStatsBar(); 

          for (Flower f : flowers) f.showFlower(); 

          for (Bee b : bees) {
            b.showBee(); 
            b.goTowardsBeeHive(); 
            b.move(); 
            b.move(); //move twice as fast

            if (b.getIsAlive() == false) continue; 

            if (b.getNextStage() == false) canMoveToNextStage = false;
          }

          for (Guardian g : guardians) {
            g.showGuardian(); 
            g.goTowardsBeeHive(); 
            g.move(); 
            g.move(); //move twice as fast

            if (g.getNextStage() == false) canMoveToNextStage = false;
          }

          if (canMoveToNextStage) {
            //if (week == 15) gameOver = true; 

            screenDisable(); 
            roundOver = false; 
            gameMillis = 0; 
            roundTime = 0; 
            resetBTVars(); 

            for (int t = 0; t < 2; t++) { //do it twice so the isBeeDead gets correctly updated after all dead bees have been removed
              for (int i = bees.size()-1; i >= 0; i--) {
                isBeeDead[i] = false; 

                Bee b = bees.get(i); 

                if (b.getIsAlive() == false) {
                  //isBeeDead[i] = true;
                  inventoryBees.remove(i); 
                  bees.remove(i); //if after a round that bee is still dead (not sold / revived), then remove that bee.
                }
              }
            }

            if (bees.isEmpty()) {
              // due to the new mechanic (remove dead bees after a round)
              // if all bees have died (aka all bees have been removed)
              // then game over.
              gameOver = true; 
              return; //cut the rest code
            }

            resetBeeInvPositions(); 
            resetGuardianInvPositions(); 
            resetItemInvPositions(); 
            beeInvSelected = -1; 
            guardianInvSelected = -1; 
            itemInvSelected = -1; 

            for (int bee = bees.size()-1; bee >= 0; bee--) {
              Bee b = bees.get(bee); 

              b.updateNextStage(false); 
              //if (b.getIsAlive() == false) bees.remove(bee);
            }
            for (Guardian g : guardians) {
              g.updateNextStage(false);
            }
            forestsScreenActive = true;
            week += 1;
          }
        } else { //bee training not completely finished. forcefully change the view to training screen
          screenDisable(); 
          beeTrainScreenActive = true;
        }
        ////////////////
      } else {
        background(230); 
        drawCenterBeehive(); 

        fill(0); 
        textSize(100); 
        textAlign(CENTER); 
        text("WEEKEND!", width/2, height/2); 

        showMarketBtn.updateGreyOut(true); 
        honeyFlucBtn.updateGreyOut(true); 
        bottomStatsBar(); 

        for (Flower f : flowers) f.showFlower(); 

        for (Bee b : bees) {
          b.showBee(); 
          b.goTowardsBeeHive(); 
          b.move(); 
          b.move(); 

          if (b.getIsAlive() == false) continue; 

          if (b.getNextStage() == false) canMoveToNextStage = false;
        }

        //println("Bees", canMoveToNextStage);

        for (Guardian g : guardians) {
          g.showGuardian(); 
          g.goTowardsBeeHive(); 
          g.move(); 
          g.move(); 

          if (g.getNextStage() == false) canMoveToNextStage = false;
        }

        //println("Guardian", canMoveToNextStage);

        if (canMoveToNextStage) {
          //if (week == 15) gameOver = true; 

          screenDisable(); 
          roundOver = false; 
          gameMillis = 0; 
          roundTime = 0; 

          for (int t = 0; t < 2; t++) { //do it twice so the isBeeDead gets correctly updated after all dead bees have been removed
            for (int i = bees.size()-1; i >= 0; i--) {
              isBeeDead[i] = false; 

              Bee b = bees.get(i); 

              if (b.getIsAlive() == false) {
                //isBeeDead[i] = true;
                inventoryBees.remove(i); 
                bees.remove(i); //if after a round that bee is still dead (not sold / revived), then remove that bee.
              }
            }
          }

          if (bees.isEmpty()) {
            // due to the new mechanic (remove dead bees after a round)
            // if all bees have died (aka all bees have been removed)
            // then game over.
            gameOver = true; 
            return; //cut the rest code
          }

          resetBeeInvPositions(); 
          resetGuardianInvPositions(); 
          resetItemInvPositions(); 
          beeInvSelected = -1; 
          guardianInvSelected = -1; 
          itemInvSelected = -1; 

          for (int bee = bees.size()-1; bee >= 0; bee--) {
            Bee b = bees.get(bee); 

            b.updateNextStage(false);
          }
          for (Guardian g : guardians) {
            g.updateNextStage(false);
          }
          forestsScreenActive = true;
          week += 1;
        }
      }
      updateQuest(); //refresh quest status (refresh at last because the week needs to be added first)
      if (effectTakingPlace[0][0] > 0) effectTakingPlace[0][0] -= 1; //price boost week
      if (effectTakingPlace[1][0] > 0) effectTakingPlace[1][0] -= 1; //enemy free week
      if (effectTakingPlace[2][0] > 0) effectTakingPlace[2][0] -= 1; //freeze enemy week
      if (effectTakingPlace[4][0] > 0) effectTakingPlace[4][0] -= 1; //extra playtime week
      if (effectTakingPlace[5][0] > 0) effectTakingPlace[5][0] -= 1; //shop sale 1 week

      if (effectTakingPlace[1][0] == 0) enemyFree = false;
      if (effectTakingPlace[4][0] == 0) ROUND_TIME = 180000;
      if (effectTakingPlace[5][0] == 0) shopSaleReset();
    }


    if (startupScreenActive == false && status > TutorialStatus.TopStatsBar) topStatsBar(); 

    for (int i = noti.size()-1; i >= 0; i--) {
      Notification n = noti.get(i); 

      n.showNoti(); 
      if (n.canRemove()) noti.remove(i);
    }

    pMillis = timeMillis;
    //pEnemies = fireflies.size() + hornets.size();
  }

  outputLog.flush();
}

void showMinimap(float LUx, float LUy, float w, float h) {
  fill(255); 

  rect(LUx, LUy, w, h); 

  pushMatrix(); 

  stroke(252, 232, 100); 
  strokeWeight(1); 
  fill(221, 114, 1); 

  float hiveCenterX = LUx + w/2, hiveCenterY = LUy + h/2; 
  float hiveRadius = 15 * (w / width); 
  polygon(hiveCenterX, hiveCenterY, hiveRadius, 6); //beehive
  if (beehiveTier == 1) {
    polygon(hiveCenterX, hiveCenterY-(hiveRadius*sqrt(3)), hiveRadius, 6); //U
    polygon(hiveCenterX-(hiveRadius*3/2), hiveCenterY-(hiveRadius*sqrt(3)/2), hiveRadius, 6); //LU
  } else if (beehiveTier == 2) {
    polygon(hiveCenterX, hiveCenterY-(hiveRadius*sqrt(3)), hiveRadius, 6); //U
    polygon(hiveCenterX-(hiveRadius*3/2), hiveCenterY-(hiveRadius*sqrt(3)/2), hiveRadius, 6); //LU
    polygon(hiveCenterX-(hiveRadius*3/2), hiveCenterY+(hiveRadius*sqrt(3)/2), hiveRadius, 6); //LD
    polygon(hiveCenterX+(hiveRadius*3/2), hiveCenterY-(hiveRadius*sqrt(3)/2), hiveRadius, 6); //RU
  } else if (beehiveTier == 3) {
    polygon(hiveCenterX, hiveCenterY-(hiveRadius*sqrt(3)), hiveRadius, 6); //U
    polygon(hiveCenterX-(hiveRadius*3/2), hiveCenterY-(hiveRadius*sqrt(3)/2), hiveRadius, 6); //LU
    polygon(hiveCenterX-(hiveRadius*3/2), hiveCenterY+(hiveRadius*sqrt(3)/2), hiveRadius, 6); //LD
    polygon(hiveCenterX+(hiveRadius*3/2), hiveCenterY-(hiveRadius*sqrt(3)/2), hiveRadius, 6); //RU
    polygon(hiveCenterX, hiveCenterY+(hiveRadius*sqrt(3)), hiveRadius, 6); //D
    polygon(hiveCenterX+(hiveRadius*3/2), hiveCenterY+(hiveRadius*sqrt(3)/2), hiveRadius, 6); //RD
  }
  popMatrix(); 

  for (Flower f : minimapFlowers) f.showFlower(); 
  for (Bee b : minimapBees) b.showBee(); 
  for (Guardian g : minimapGuardians) g.showGuardian();
}

void drawCenterBeehive() {
  stroke(252, 232, 100); 
  strokeWeight(1); 
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
  strokeWeight(1); 
  stroke(0); 
  line(225, 25, 225, 29); 
  line(225+70, 25, 225+70, 29); 
  fill(200); 
  noStroke(); 
  fill(10); 
  rect(225+1, 25, 70-2, 4); 
  chargeBar(225, 25, 70, 4, color(0, 0, 0), honeyKg, honeyPotCapKg[honeyPotTier], true, false, true, true); 


  //honeyMarket
  honeyPriceFlutuate(); 

  text("Money: $" + nfc(money), 480, 19); 

  text("Time: ", 600, 19); 
  strokeWeight(1); 
  if (roundTime < 181000) stroke(255); //extra 1s to prevent lagging
  else if (roundTime > 180000) stroke(215, 255, 255);
  noFill(); 
  ellipse(660, 15, 26, 26); 
  if (roundTime < 181000) fill(255); //extra 1s to prevent lagging
  else if (roundTime > 180000) fill(215, 255, 255);
  arc(660, 15, 26, 26, -HALF_PI, map(roundTime, 0, ROUND_TIME, -HALF_PI, PI+HALF_PI), PIE); 

  textSize(12); 
  textAlign(RIGHT); 
  fill(255); 
  text("Week: " +week, width-20, 19); 

  fill(0); 
  textAlign(RIGHT); 
  text("Frame Rate: " + int(frameRate), width-20, 55); 
  fill(105); 
  textSize(9); 
  text(VERSION, width-20, 70); 


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
  showBeeTrainBtn.updateGreyOut(true); 
  if (BTOngoing) showBeeTrainBtn.updateGreyOut(false); 

  showGuardianTrainBtn.Draw(); 
  showBeeTrainBtn.Draw(); 
  if (week >= 10) {
    questBtn.updateGreyOut(false);
    questBtn.Draw();
  }
}

void resetButtonPos() {
  showMarketBtn.updateXY(width-120, height-50); 
  showForestBtn.updateXY(width-120, height-50); 
  honeyFlucBtn.updateXY(width-130, 250); 
  sellAllHoneyBtn.updateXY(width-130, 200);
}

void moveAllBees() {
  for (Bee b : bees) {
    b.updateShouldBeeMove(true);
  }
}

void screenDisable() {
  gameScreenActive = false; 
  shopScreenActive = false; 
  sellShopScreenActive = false; //unused
  beeInventoryScreenActive = false; 
  guardianInventoryScreenActive = false; 
  itemInventoryScreenActive = false; 
  graphScreenActive = false; 
  forestsScreenActive = false; 
  guardianTrainScreenActive = false; 
  beeTrainScreenActive = false; 
  GTShopScreenActive = false; 
  BTShopScreenActive = false; 
  questScreenActive = false;
}

void resetBeeInvPositions() {
  float blockSize = (650 - 10*2 - 10*5)/5; 

  beeInvSlot = 0; 
  int counter = 0; 
  for (int y = 0; y < 2; y++) {
    for (int x = 0; x < 5; x++) {
      if (inventoryBees.size() > beeInvSlot+counter) {
        inventoryBees.get(beeInvSlot+counter).updateLocation(20 + blockSize/2 + (blockSize+10)*x, 70 + blockSize/2 + (blockSize+10)*y); 
        counter++;
      } else break;
    }
  }
}
void resetGuardianInvPositions() {
  float blockSize = (650 - 10*2 - 10*5)/5; 

  guardianInvSlot = 0; 
  int counter = 0; 
  for (int y = 0; y < 2; y++) {
    for (int x = 0; x < 2; x++) {
      if (inventoryGuardians.size() > guardianInvSlot+counter) {
        inventoryGuardians.get(guardianInvSlot+counter).updateLocation(20 + blockSize/2 + (blockSize+10)*x, 70 + blockSize/2 + (blockSize+10)*y); 
        counter++;
      } else break;
    }
  }
}
void resetItemInvPositions() {
  float blockSize = (650 - 10*2 - 10*5)/5; 

  int counter = 0; 
  for (int y = 0; y < 2; y++) {
    for (int x = 0; x < 4; x++) {
      if (inventoryResources.size() > counter) {
        inventoryResources.get(counter).updateLocation(20 + blockSize/2 + (blockSize+10)*x, 70 + blockSize/2 + (blockSize+10)*y); 
        counter++;
      } else break;
    }
  }
}


void ifInvBtnClicked() {
  switch (invBtn) {
  case 0 : //bee inventory
    if (inventoryBtn.get(0).MouseClicked()) {
      screenDisable(); 
      beeInventoryScreenActive = true; 
      resetBeeInvPositions(); 
      //guardianInvSelected = -1;

      for (int i = bees.size()-1; i >= 0; i--) {
        Bee b = bees.get(i); 
        if (b.getBeeName().equals(upgradedBeeName[1]) && b.getCDAbility()) inventoryBees.get(i).updateCDAbility(true);
      }

      float blockSize = (650 - 10*2 - 10*5)/5; 
      updateMinimap(20 + blockSize*0.1, 70 + (blockSize+10)*2.4, (blockSize+10)*3.3 - 135);
    } 
    break; 
  case 1 : //guardian inventory
    if (inventoryBtn.get(1).MouseClicked()) {
      screenDisable(); 
      guardianInventoryScreenActive = true; 
      resetGuardianInvPositions(); 
      //beeInvSelected = -1;

      float blockSize = (650 - 10*2 - 10*5)/5; 
      updateMinimap(20 + blockSize+10 + blockSize*0.14, 70 + (blockSize+10)*2.4, (blockSize+10)*3.3 - 135); 
      for (int i = guardians.size()-1; i >= 0; i--) {
        Guardian g = guardians.get(i); 

        int spGuardianType = g.getGuardianType()-2; 
        if (spGuardianType == 4) {
          inventoryGuardians.get(i).updateStingAmount(g.getStingAmount()); 
          inventoryGuardians.get(i).updateStingTier(g.getStingTier());
        }
      }
    }
    break; 

  case 2 : //resource(item) inventory
    if (inventoryBtn.get(2).MouseClicked()) {
      screenDisable(); 
      itemInventoryScreenActive = true; 
      resetItemInvPositions();
    }
    break;
  }

  if (invTabLeft.MouseClicked()) {
    if (invBtn > 0) invBtn--; 
    else invBtn = inventoryBtn.size()-1;
  } else if (invTabRight.MouseClicked()) {
    if (invBtn < inventoryBtn.size()-1) invBtn++; 
    else invBtn = 0;
  }
}

void updateMinimap(float minimapLUx, float minimapLUy, float minimapW) {
  minimapBees = new ArrayList<Bee>(); 

  //minimapBees = bees;
  for (int i = 0; i < bees.size(); i++) {
    Bee b = bees.get(i); 
    float bx = b.getLocation().x * (minimapW / width) + minimapLUx, by = (b.getLocation().y-30) * (minimapW / width) + minimapLUy; 

    minimapBees.add(new Bee(b.getBeeType())); 
    Bee mb = minimapBees.get(i); 
    mb.updateLocation(bx, by); 
    mb.updateForShop(true); 
    if (i != beeInvSelected) mb.updateDiameter(BEE_DIAMETER * (minimapW / width)); 
    else mb.resetDiameter(); 
    mb.updateMoveTheta(b.getMoveTheta()); 
    if (isBeeDead[i]) mb.updateIsAlive(false); 

    if (b.getBeeName().equals(upgradedBeeName[1]) && b.getCDAbility()) mb.updateCDAbility(true);
  }



  minimapFlowers = new ArrayList<Flower>(); 

  //minimapFlowers = flowers; //i think this actually connects the two arraylists...
  for (int i = 0; i < flowers.size(); i++) {
    Flower f = flowers.get(i); 
    float fx = f.getLocation().x * (minimapW / width) + minimapLUx, fy = (f.getLocation().y-30) * (minimapW / width) + minimapLUy; 

    minimapFlowers.add(new Flower(fx, fy, forestHoneyRng[forestType][0], forestHoneyRng[forestType][1])); 
    Flower mf = minimapFlowers.get(i); 
    mf.updateForShop(true); 
    mf.transferFlower(f.getHoneyGram(), f.getPedalAmount(), f.getStamenPedalColor(), f.getAngleOffset());
  }



  minimapGuardians = new ArrayList<Guardian>(); 

  for (int i = 0; i < guardians.size(); i++) {
    Guardian g = guardians.get(i); 
    float gx = g.getLocation().x * (minimapW / width) + minimapLUx, gy = (g.getLocation().y-30) * (minimapW / width) + minimapLUy; 

    minimapGuardians.add(new Guardian(g.getGuardianName())); 
    Guardian mg = minimapGuardians.get(i); 
    mg.updateLocation(gx, gy); 
    mg.updateShouldGuardianMove(false); 
    if (i != guardianInvSelected) mg.updateRadius(GUARDIAN_RADIUS * (minimapW / width)); 
    else mg.resetRadius(); 
    mg.updateMoveTheta(g.getMoveTheta()); 

    if (mg.getGuardianType() == 6) { //if it is a ranged guardian
      mg.updateStingAmount(g.getStingAmount()); //update the sting amount
    }
  }
}

int GTSelected = -1; //default not selected any guardian training
boolean GTPurchased = false; //default not purchased any training course ofc
boolean GTOngoing = false; //selected -> purchased -> ongoing (next round)
int BTSelected = -1; //default not selected any bee training
boolean BTPurchased = false; //default not purchased any training course ofc
boolean BTOngoing = false; //selected -> purchased -> ongoing (next round)
void mouseReleased() {
  //universal
  //if (buyMarketBtn.MouseClicked() || beeInventoryBtn.MouseClicked()) {
  resetShopErrors(); //reset errors as long as player clicks
  //}

  if (startupScreenActive) {
    if (startGame.MouseClicked()) {
      pMillis = System.currentTimeMillis(); 
      gameMillis = 0; 

      honeyKg = 0; 
      money = 0; 
      status = TutorialStatus.EndTutorial+1; 
      tutorialMinorStep = 100; 

      flowers = new ArrayList<Flower>(); 
      bees = new ArrayList<Bee>(); 
      guardians = new ArrayList<Guardian>(); 
      hornets = new ArrayList<Hornet>(); 
      fireflies = new ArrayList<Firefly>(); 

      for (int i=0; i<10; i++) flowers.add(new Flower(10+random(width-20), 40+random(height-40-50), 1, 3)); 
      for (int i=0; i<3; i++)  bees.add(new Bee(0)); 

      screenDisable(); 
      startupScreenActive = false; 
      gameScreenActive = true; 

      loadBtn.updateXY(width-150, 250); 
      loadBtn.updateSize(100, 35);
    }
    if (loadBtn.MouseClicked()) {
      loadGame(); 

      if (loadError) loadError = false; 
      else {
        loadBtn.updateXY(width-150, 250); 
        loadBtn.updateSize(100, 35); 
        status = TutorialStatus.EndTutorial+1; 
        tutorialMinorStep = 100; 
        screenDisable(); 
        startupScreenActive = false; 
        forestsScreenActive = true;
      }
    }
    if (startTutorial.MouseClicked()) {
      screenDisable(); 
      startupScreenActive = false; 
      tutorialScreenActive = true;
    }
    if (update.MouseClicked()) {
      String link = form[3].substring(1, 8)+form[3].substring(9, 13)+form[3].substring(14, 17)+form[3].substring(18, 24); 
      link(link);
    }
  } else if (tutorialScreenActive) {
    tutorialClickEvents(); 
    /////
  } else if (gameScreenActive) {
    selectionMechanic(); 

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
    if (showBeeTrainBtn.MouseClicked()) {
      screenDisable(); 
      beeTrainScreenActive = true;
    }
    if (questBtn.MouseClicked()) {
      screenDisable(); 
      questScreenActive = true; 
      updateQuest();
    }
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
    for (int i = 0; i < beehivePrice.length-2; i++) {
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

    ifInvBtnClicked(); 
    if (GTMarketBtn.MouseClicked()) {
      screenDisable(); 
      GTShopScreenActive = true;
    }
    if (BTMarketBtn.MouseClicked()) {
      screenDisable(); 
      BTShopScreenActive = true;
    }
  } else if (beeInventoryScreenActive) {
    int counter = 0; 
    float blockSize = (650 - 10*2 - 10*5)/5; 
    //beeInvSelected = -1;
    for (int y = 0; y < 2; y++) {
      for (int x = 0; x < 5; x++) {
        if (counter+beeInvSlot < inventoryBees.size() && mouseX > 20 + (blockSize+10)*x && mouseX < 20 + (blockSize+10)*x + blockSize && mouseY > 70 + (blockSize+10)*y && mouseY < 70 + (blockSize+10)*y + blockSize) {
          beeInvSelected = counter + beeInvSlot; 
          Bee invB = inventoryBees.get(beeInvSelected); 
          int invBType = invB.getBeeType(); 

          if (invBType < beeName.length) {
            if (invB.getIsAlive()) beeInvSell.updateLabel("Sell for $" + nfc(beeSellCost[invBType])); 
            else beeInvSell.updateLabel("Sell for $" + nfc((int)sqrt(beeSellCost[invBType])*3));
          } else {
            int spType = invBType - beeName.length; 
            if (invB.getIsAlive()) beeInvSell.updateLabel("Sell for $" + nfc((int)upgradeBeeCost[spType]/2)); 
            else beeInvSell.updateLabel("Sell for $" + nfc((int)sqrt(upgradeBeeCost[spType]/2)*3));
          }

          float minimapW = (blockSize+10)*3.3 - 135; 
          for (int i = minimapBees.size()-1; i >= 0; i--) {
            Bee b = minimapBees.get(i); 

            if (i != beeInvSelected) b.updateDiameter(BEE_DIAMETER * (minimapW / width)); 
            else b.resetDiameter();
          }

          //rect(20, 70 + (blockSize+10)*2.3, (blockSize+10)*3.5, blockSize*1.8, 5, 5, 5, 5);
          break;
        } /* else beeInvSelected = -1; */
        counter++;
      }
      //if (beeInvSelected != -1) break;
    }

    println(beeInvSelected); 

    counter = 0; 
    if (beeInvUp.MouseClicked()) {
      beeInvSlot-=5; 

      for (int y = 0; y < 2; y++) {
        for (int x = 0; x < 5; x++) {
          if (inventoryBees.size() > beeInvSlot+counter) {
            inventoryBees.get(beeInvSlot+counter).updateLocation(20 + blockSize/2 + (blockSize+10)*x, 70 + blockSize/2 + (blockSize+10)*y); 
            counter++;
          } else break;
        }
      }
    }

    counter = 0; 
    if (beeInvDown.MouseClicked()) {
      beeInvSlot+=5; 

      for (int y = 0; y < 2; y++) {
        for (int x = 0; x < 5; x++) {
          println(inventoryBees.size(), beeInvSlot, counter); 
          if (inventoryBees.size() > beeInvSlot+counter) {
            inventoryBees.get(beeInvSlot+counter).updateLocation(20 + blockSize/2 + (blockSize+10)*x, 70 + blockSize/2 + (blockSize+10)*y); 
            counter++;
          } else break;
        }
      }
    }

    if (beeInvSelected != -1 && beeInvSell.MouseClicked()) {
      sellBee(beeInvSelected); 
      inventoryBees.remove(beeInvSelected); 

      for (int i = 0; i < isBeeDead.length; i++) {
        isBeeDead[i] = false; 

        if (i < bees.size()) {
          Bee b = bees.get(i); 

          if (b.getIsAlive() == false) {
            isBeeDead[i] = true; 
            inventoryBees.get(i).updateIsAlive(false);
          }
        }
      }

      resetBeeInvPositions(); 

      updateMinimap(20 + blockSize*0.1, 70 + (blockSize+10)*2.4, (blockSize+10)*3.3 - 135); 

      beeInvSelected = -1;
    }

    ifInvBtnClicked(); 
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
    if (BTMarketBtn.MouseClicked()) {
      screenDisable(); 
      BTShopScreenActive = true;
    }

    /////
  } else if (guardianInventoryScreenActive) {
    int counter = 0; 
    float blockSize = (650 - 10*2 - 10*5)/5; 
    //guardianInvSelected = -1;
    for (int y = 0; y < 2; y++) {
      for (int x = 0; x < 2; x++) {
        if (counter+guardianInvSlot < inventoryGuardians.size() && mouseX > 20 + (blockSize+10)*x && mouseX < 20 + (blockSize+10)*x + blockSize && mouseY > 70 + (blockSize+10)*y && mouseY < 70 + (blockSize+10)*y + blockSize) {
          guardianInvSelected = counter + guardianInvSlot; 

          int guardianType = inventoryGuardians.get(guardianInvSelected).getGuardianType(); 
          if (rewardSelection[2]) {
            guardianInvSell.updateLabel("Confirm Buff");
          } else {
            if (guardianType <= 1) guardianInvSell.updateLabel("Sell for $" + nfc(guardianSellCost[guardianType])); //normal ones
            else guardianInvSell.updateLabel("Sell for $" + nfc((int)upgradeGuardianCost[guardianType-2][0]/2));
          }

          float minimapW = (blockSize+10)*3.3 - 135; 
          for (int i = minimapGuardians.size()-1; i >= 0; i--) {
            Guardian g = minimapGuardians.get(i); 

            if (i != guardianInvSelected) g.updateRadius(GUARDIAN_RADIUS * (minimapW / width)); 
            else g.resetRadius();
          }
          break;
        }
        counter++;
      }
    }

    if (rewardSelection[2]) {
      if (guardianInvSelected != -1 && guardianInvSell.MouseClicked()) {
        rewardSelection[2] = false;

        Guardian g = guardians.get(guardianInvSelected);
        Guardian invG = inventoryGuardians.get(guardianInvSelected);
        g.grantSpeedBuff();
        invG.grantSpeedBuff(); //so guardians and invGuardians are incline with each other

        noti.add(new Notification(12, 50, 20, height-60, "Granted permanent speed buff to this guardian!", 2500, "Down Corner")); 

        guardianInvSelected = -1;
      }
    }

    counter = 0; 
    if (guardianInvUp.MouseClicked()) {
      guardianInvSlot-=2; 

      for (int y = 0; y < 2; y++) {
        for (int x = 0; x < 2; x++) {
          if (inventoryGuardians.size() > guardianInvSlot+counter) {
            inventoryGuardians.get(guardianInvSlot+counter).updateLocation(20 + blockSize/2 + (blockSize+10)*x, 70 + blockSize/2 + (blockSize+10)*y); 
            counter++;
          } else break;
        }
      }
    }

    counter = 0; 
    if (guardianInvDown.MouseClicked()) {
      guardianInvSlot+=2; 

      for (int y = 0; y < 2; y++) {
        for (int x = 0; x < 2; x++) {
          println(inventoryGuardians.size(), guardianInvSlot, counter); 
          if (inventoryGuardians.size() > guardianInvSlot+counter) {
            inventoryGuardians.get(guardianInvSlot+counter).updateLocation(20 + blockSize/2 + (blockSize+10)*x, 70 + blockSize/2 + (blockSize+10)*y); 
            counter++;
          } else break;
        }
      }
    }

    if (rewardSelection[2] == false) {
      if (guardianInvSelected != -1 && guardianInvSell.MouseClicked()) {
        sellGuardian(guardianInvSelected); 

        inventoryGuardians.remove(guardianInvSelected); 
        resetGuardianInvPositions(); 

        guardianInvSelected = -1;
      }

      ifInvBtnClicked(); 
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
      if (BTMarketBtn.MouseClicked()) {
        screenDisable(); 
        BTShopScreenActive = true;
      }
    }
    /////
  } else if (itemInventoryScreenActive) {
    int counter = 0; 
    float blockSize = (650 - 10*2 - 10*5)/5; 
    //beeInvSelected = -1;
    for (int y = 0; y < 2; y++) {
      for (int x = 0; x < 4; x++) {
        if (counter < inventoryResources.size() && mouseX > 20 + (blockSize+10)*x && mouseX < 20 + (blockSize+10)*x + blockSize && mouseY > 70 + (blockSize+10)*y && mouseY < 70 + (blockSize+10)*y + blockSize) {
          itemInvSelected = counter;
          Resource r = inventoryResources.get(itemInvSelected);

          if (rewardSelection[0] || rewardSelection[1]) itemInvSell.updateLabel("Confirm");
          else itemInvSell.updateLabel("Sell for $" + resourcePrice[r.getType()]);
          break;
        }
        counter++;
      }
    }

    if (rewardSelection[0]) {
      if (itemInvSelected != -1 && itemInvSell.MouseClicked()) {
        if (rewardSelectedID == -1) rewardSelectedID = itemInvSelected;
        else if (rewardSelectedID == itemInvSelected) rewardSelectedID = -1; //deselect
        else {
          //rewardSelectedID[1] = itemInvSelected;
          rewardSelection[0] = false;

          inventoryResources.remove(rewardSelectedID);
          if (itemInvSelected == inventoryResources.size()) inventoryResources.remove(itemInvSelected-1); //selected last one
          else inventoryResources.remove(itemInvSelected);
          int exchangeNums = min(3, 8-inventoryResources.size());
          for (int i = 0; i < exchangeNums; i++) {
            int rnd = (int)random(16);
            while (rnd == 6 || rnd == 7 || rnd == 15) rnd = (int)random(16);
            inventoryResources.add(new Resource(rnd));
          }
          resetItemInvPositions();
          if (exchangeNums == 3) noti.add(new Notification(12, 50, 20, height-60, "Exchanged 2 selected resources for 3 random resources.", 2500, "Down Corner")); 
          else noti.add(new Notification(12, color(50, 0, 0), 20, height-60, "Exchanged 2 selected resources for " + exchangeNums + " random resources (Inventory Full)", 2500, "Down Corner"));

          if (rewardSelection[2]) {
            resetGuardianInvPositions();
            guardianInvSelected = -1;
            screenDisable();
            guardianInventoryScreenActive = true;
          }
        }
        itemInvSelected = -1;
      }
    } else if (rewardSelection[1]) {
      if (itemInvSelected != -1 && itemInvSell.MouseClicked()) {
        //rewardSelectedID = itemInvSelected;
        //rewardSelection[1] = false; //not yet. go to BTscreen
        inventoryResources.remove(itemInvSelected);
        screenDisable();
        BTShopScreenActive = true;

        itemInvSelected = -1;
      }
    }

    if (rewardSelection[0] == false && rewardSelection[1] == false) { //while claiming reward, disable screen switching
      if (itemInvSelected != -1 && itemInvSell.MouseClicked()) {
        money += resourcePrice[inventoryResources.get(itemInvSelected).getType()]; 
        inventoryResources.remove(itemInvSelected); 

        resetItemInvPositions(); 

        itemInvSelected = -1;
      }

      ifInvBtnClicked(); 
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
      if (BTMarketBtn.MouseClicked()) {
        screenDisable(); 
        BTShopScreenActive = true;
      }
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

    ifInvBtnClicked(); 
    if (buyMarketBtn.MouseClicked()) {
      screenDisable(); 
      shopScreenActive = true;
    }
    if (GTMarketBtn.MouseClicked()) {
      screenDisable(); 
      GTShopScreenActive = true;
    }
    if (BTMarketBtn.MouseClicked()) {
      screenDisable(); 
      BTShopScreenActive = true;
    }
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
    if (questBtn.MouseClicked()) {
      screenDisable(); 
      questScreenActive = true; 
      updateQuest();
    }
    if (showMarketBtn.MouseClicked()) {
      screenDisable(); 
      shopScreenActive = true;
    }
    if (saveBtn.MouseClicked()) {
      saveGame();
    }
    if (loadBtn.MouseClicked()) {
      loadGame();
    }
    /////
  } else if (guardianTrainScreenActive) {

    if (showForestBtn.MouseClicked()) {
      ignoreGTClick = true; 
      if (roundTime == 0) {
        screenDisable(); 
        forestsScreenActive = true;
      } else {
        screenDisable(); 
        gameScreenActive = true;
      }
    }

    guardianTrainClickEvents(); 

    /////
  } else if (beeTrainScreenActive) {

    if (showForestBtn.MouseClicked()) {
      if (roundTime == 0) {
        screenDisable(); 
        forestsScreenActive = true;
      } else {
        screenDisable(); 
        gameScreenActive = true;
      }
    }

    beeTrainClickEvents(); 
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
    if (collapsibleBtn.MouseClicked()) {
      GTDemoCollapsed = !GTDemoCollapsed;
    }
    boolean updateDemo = false; 
    if (demoTabLeft.MouseClicked() || demoTabRight.MouseClicked()) {
      if (demoTabLeft.MouseClicked()) {
        if (demoGTSlides > 0) demoGTSlides--;
      } else if (demoTabRight.MouseClicked()) {
        demoGTSlides++;
      }

      updateDemo = true;
    }
    if (buyMarketBtn.MouseClicked()) {
      screenDisable(); 
      shopScreenActive = true;
    }
    ifInvBtnClicked(); 
    for (int _btn = upgradeGuardian.size()-1; _btn >= 0; _btn--) {
      Button btn = upgradeGuardian.get(_btn); 
      if (btn.MouseClicked()) {
        GTSelected = _btn; 
        updateDemo = true;
      }
    }
    if (BTMarketBtn.MouseClicked()) {
      screenDisable(); 
      BTShopScreenActive = true;
    }

    if (updateDemo) {
      clearDemoEntities(); 
      switch (GTSelected) {
      case 0 : 
        demoGTSlidesMax = 1; 
        if (demoGTSlides == 0) {
          demoTrainingGuardian = new TrainingGuardian(0); 
          demoTrainingGuardian.updateIsDemo(true); 
          demoFirefly.add(new Firefly(true)); 
          demoFirefly.get(0).updateIsDemo(true);
        } else if (demoGTSlides == 1) {
          for (int i = 0; i < 2; i++) demoGuardian.add(new Guardian(guardianName[i])); 
          demoGuardian.add(new Guardian(upgradedGuardianName[0])); 
          for (int i = 0; i < 3; i++) {
            demoGuardian.get(i).updateIsDemo(true); 
            demoGuardian.get(i).updateLocation(width*0.3, 30+(height/1.75)/2 - 100 + 120*i); 
            demoGuardian.get(i).updateMoveTheta(0);

            demoHornet.add(new Hornet(0, true)); 
            demoHornet.get(i).updateIsDemo(true); 
            demoHornet.get(i).updateShouldMove(false); 
            demoHornet.get(i).updateLocation(width*0.75, 30+(height/1.75)/2 - 100 + 120*i); 
            demoHornet.get(i).updateMoveTheta(PI);
          }
        }
        break; 

      case 1 : 
        demoGTSlidesMax = 1; 
        demoChargeBar = 0; 
        if (demoGTSlides == 0) {
          demoTrainingGuardian = new TrainingGuardian(1); 
          demoTrainingGuardian.updateIsDemo(true); 
          for (int i = 0; i < 3; i++) {
            demoFlower.add(new Flower(0, 0, 5, 5)); //if too close to beehive, it auto re-calculates location
            demoFlower.get(i).updateLocation(220+width/4 + random(-100, 100), 30+(height/1.75)/2 + 20 + random(-100, 100)); 
            demoFlower.get(i).updateIsDemo(true); 
            demoFlower.get(i).updateForTraining(true);
          }
        } else if (demoGTSlides == 1) {
          demoGuardian.add(new Guardian(upgradedGuardianName[0]));
        }
        break;
      }
    }
    if (GTSelected == 0 || GTSelected == 1) demoGuardianTrainClickEvents(); 

    if (_ignorePurchase == false && GTPurchase.MouseClicked()) {
      GTPurchased = true; 
      money -= upgradeGuardianCost[GTSelected][0]; 

      //adding objectives, removing the guardian, assigning the trainingGuardian in NewForest.pde
    }
  } else if (BTShopScreenActive) {

    if (rewardSelection[1]) {
      int ART = -1; //AvailableResourceTypes
      if (BTSelected == 0 || BTSelected == 2) ART = 4; //if it's priest / gardening, 4 types are available
      else ART = 3; //if it's undead / rush, 3 types are available

      int counter = 0;
      for (int i = 0; i < ART; i++) {
        int LUx = width/2+230, LUy = 130 + i*70;
        if (mouseX > LUx && mouseX < LUx + 55 && mouseY > LUy && mouseY < LUy+55) {
          rewardSelectedID = counter + BTSelected*4;
          BTPurchase.updateGreyOut(false);
        }
        counter++;
      }

      if (rewardSelectedID != -1) {
        if (BTPurchase.MouseClicked()) {
          BTPurchase.updateGreyOut(true);
          inventoryResources.add(new Resource(rewardSelectedID));
          rewardSelection[1] = false;
          screenDisable();
          resetItemInvPositions();
          itemInventoryScreenActive = true;
          noti.add(new Notification(12, 50, 20, height-60, "Exchanged 1 selected resource for 1 custom resource.", 3500, "Down Corner"));

          if (rewardSelection[2]) {
            resetGuardianInvPositions();
            guardianInvSelected = -1;
            screenDisable();
            guardianInventoryScreenActive = true;
          }
        }
      }
    }
    for (int _btn = upgradeBee.size()-1; _btn >= 0; _btn--) {
      Button btn = upgradeBee.get(_btn); 
      if (btn.MouseClicked()) {
        BTSelected = _btn;
      }
    }

    if (rewardSelection[1] == false) {
      if (showForestBtn.MouseClicked()) {
        if (roundTime == 0) {
          screenDisable(); 
          forestsScreenActive = true;
        } else {
          screenDisable(); 
          gameScreenActive = true;
        }
      }
      if (collapsibleBtn.MouseClicked()) {
        BTDemoCollapsed = !BTDemoCollapsed;
      }
      if (buyMarketBtn.MouseClicked()) {
        screenDisable(); 
        shopScreenActive = true;
      }
      ifInvBtnClicked(); 

      if (BTPurchase.MouseClicked()) {
        money -= upgradeBeeCost[BTSelected]; 

        boolean[] removeCheck = {false, false, false, false}; 
        for (int i = inventoryResources.size()-1; i >= 0; i--) {
          Resource r = inventoryResources.get(i); 

          for (int j = 0; j < 4; j++) {
            if (removeCheck[j] == false && r.getType() == j + BTSelected*4) {
              removeCheck[j] = true; 
              inventoryResources.remove(i); 
              break; //break out of the "check type for" because that resource has been removed
            }
          }
        }

        if (BTSelected == 0 || BTSelected == 2) BTPurchased = true; 
        else {
          bees.add(new Bee(BTSelected+beeName.length)); 
          inventoryBees.add(new Bee(BTSelected+beeName.length)); 
          inventoryBees.get(inventoryBees.size()-1).updateShouldBeeMove(false); 
          inventoryBees.get(inventoryBees.size()-1).updateForShop(true); 
          inventoryBees.get(inventoryBees.size()-1).updateMoveTheta(HALF_PI); 
          resetBeeInvPositions();
        }
      }
      if (GTMarketBtn.MouseClicked()) {
        screenDisable(); 
        GTShopScreenActive = true;
      }
    }
  } else if (questScreenActive) {
    int q = -1;
    if (quest1.MouseClicked()) q = 0;
    if (quest2.MouseClicked()) q = 1;
    claimReward(q);

    if (effectTakingPlace[1][0] != 0 && toggleEnemyFree.MouseClicked()) {
      enemyFree = !enemyFree;
      toggleEnemyFree.updateGreyOut(true);
      toggleEnemyTimer = 0;
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
  }

  //universal buttons
  if (sellAllHoneyBtn.MouseClicked()) {
    sellHoney(honeyKg);
  }
}

int beesSelectedPrev = 0, beesSelectedCurr = 0; 
int guardsSelectedPrev = 0, guardsSelectedCurr = 0; 
void selectionMechanic() {
  boolean selectedObject = false; 

  beesSelectedPrev = 0; 
  for (Bee b : bees) {
    if (b.getBeeSelectedStatus()) beesSelectedPrev++;
  }
  beesSelectedCurr = beesSelectedPrev; 

  boolean reviveAvailable = false; 
  for (Bee b : bees) { 
    if (b.getBeeName().equals(upgradedBeeName[0]) && b.getHyperSelectedStatus() == true && b.getBeeTarget().equals("Revive") == false) {//check if a HYPER-SELECTED, PRIEST BEE, NOT ON THE WAY is present
      reviveAvailable = true; 
      break; //break out of for because already found one available priest
    }
  }
  for (Bee b : bees) {
    if (reviveAvailable && b.getIsAlive() == true && b.getBeeName().equals(upgradedBeeName[0]) == false) continue; //remember... continue means go to the next iteration
    else if (reviveAvailable == false && b.getIsAlive() == false) continue; 

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

        if (beesSelectedCurr == 0) {
          //if the deselected bee is PRIEST BEE / RUSHB, 
          //and after the deselect, no bees have been selected (== 0)
          //(that means the player only selected PRIEST BEE / RUSHB in first place)
          if (b.getBeeName().equals(upgradedBeeName[0])) { //PRIEST BEE
            b.updateHyperSelectedStatus(true);
          } else if (b.getBeeName().equals(upgradedBeeName[2])) {
            if (b.getCDACooldown() == 0) b.updateCDAbility(true);
          } else if (b.getBeeName().equals(upgradedBeeName[3])) { //RUSHB
            if (b.getCDACooldown() == 0) b.updateCDAbility(true);
          }
        }
        break;
      }
    }
  }

  guardsSelectedPrev = 0; 
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
          if (g.getGuardianName().equals(upgradedGuardianName[5]) && g.getHyperSelectedStatus()) {
            g.updateHyperSelectedStatus(false); //deactivate the hyper status
            return; //do not select it
          }
          if (g.getGuardianName().equals(upgradedGuardianName[3]) && g.getCDAbility()) { //border, has a candy flying around
            //activate the candy
            for (ProjectileWeapon pw : projectiles) {
              if (pw.getProjectileType() == 2 && pw.getID() == g.getDistinctID()) { //check if the candy is the guardian's candy 
                pw.activate();
                break; //if activate, dont move all guardians
              }
            }
          }
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

          if (guardsSelectedCurr == 0) {
            //if the deselected guardian is HUNTING / BORDER / RANGED / BOUNCER, 
            //and after the deselect, no guardians have been selected (== 0)
            //(that means the player only selected HUNTING / BORDER / RANGED / BOUNCER in first place)
            if (g.getGuardianName().equals(upgradedGuardianName[2])) {
              if (g.getCDACooldown() == 0) {
                g.updateCDAInitiateTimer(500); 
                g.updateCDAbility(true);
              }
            } else if (g.getGuardianName().equals(upgradedGuardianName[3]) || g.getGuardianName().equals(upgradedGuardianName[4])) {
              if (g.getStingAmount() > 0) {
                g.updateHyperSelectedStatus(true); //border, ranged
                break; //don't move all
              }
            } else if (g.getGuardianName().equals(upgradedGuardianName[5])) {
              g.updateHyperSelectedStatus(true);
              break; //don't move all
            }
          }
          break;
        }
      }
    }
  }

  int selectedFlowerID = -1; 
  boolean goTowardsBeehive = false; 
  int selectedHornetID = -1; 
  if (beesSelectedCurr == 0 && guardsSelectedCurr == 0 && selectedObject == false) { //selected no bee no guardian, but selected a new target, so all bees (& baiting guardian) go towards target
    //selected flower
    for (int f = flowers.size ()-1; f >= 0; f--) {
      Flower _flower = flowers.get(f); 
      float fx = _flower.getLocation().x; 
      float fy = _flower.getLocation().y; 

      if (mouseX > fx-15 && mouseX < fx+15 && mouseY > fy-15 && mouseY < fy+15) {
        selectedObject = true; 
        //selected a flower
        selectedFlowerID = f; 
        println("selected flower " + f);
      }
    }

    //if (beehiveTier == 1) {
    //    polygon(width/2, height/2-(15*sqrt(3)), 15, 6); //U
    //    polygon(width/2-(15*3/2), height/2-(15*sqrt(3)/2), 15, 6); //LU
    //  } else if (beehiveTier == 2) {
    //    polygon(width/2, height/2-(15*sqrt(3)), 15, 6); //U
    //    polygon(width/2-(15*3/2), height/2-(15*sqrt(3)/2), 15, 6); //LU
    //    polygon(width/2-(15*3/2), height/2+(15*sqrt(3)/2), 15, 6); //LD
    //    polygon(width/2+(15*3/2), height/2-(15*sqrt(3)/2), 15, 6); //RU
    //  }

    //selected beehive
    if (tutorialMinorStep >= TutorialStatus.Beehive) {
      if ((beehiveTier == 0 && dist(mouseX, mouseY, width/2, height/2) <= 15) || 
        (beehiveTier == 1 && dist(mouseX, mouseY, width/2-(15*sqrt(3))+15, height/2-(15*sqrt(3))+15) <= 30) || 
        (beehiveTier == 2 && (dist(mouseX, mouseY, width/2-(15*sqrt(3))+15, height/2-(15*sqrt(3))+15) <= 30) || dist(mouseX, mouseY, width/2-(15*3/2), height/2+(15*sqrt(3)/2)) <= 15 || dist(mouseX, mouseY, width/2+(15*3/2), height/2-(15*sqrt(3)/2)) <= 15) || 
        (beehiveTier == 3 && dist(mouseX, mouseY, width/2, height/2) <= 42)) {
        selectedObject = true; 

        goTowardsBeehive = true; 
        println("selected beehive");
      }
    }
  } else if (guardsSelectedCurr == 0 && selectedObject == false) { //selected no guardian but selected a new target so all guardians go to that target's current position (not track it)
    //selected hornet
    for (int h = hornets.size ()-1; h >= 0; h--) {
      Hornet _hornet = hornets.get(h); 
      float hx = _hornet.getLocation().x; 
      float hy = _hornet.getLocation().y; 

      if (mouseX > hx-15 && mouseX < hx+15 && mouseY > hy-15 && mouseY < hy+15) {
        selectedObject = true; 
        //selected a hornet
        selectedHornetID = h; 
        println("selected hornet "+h);
      }
    }

    // (selected flower for baiting guardian included as "bees")
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
  } else if (guardsSelectedCurr == 0 && beesSelectedCurr == 0 && selectedObject == false) { //didnt select any guardian, or bee, or anything (so the player missed his click)
    //for (Guardian g : guardians) {
    //  if (g.getShooting()) return; //terminate this click because the player is shooting, not misclicking <-- ok not working. whatever.
    //}

    for (Guardian g : guardians) {
      float gx = g.getLocation().x, gy = g.getLocation().y; 

      float hypotenuse = distance_between_two_points(gx, mouseX, gy, mouseY); 
      float _thetaRad = asin(abs(mouseY - gy) / hypotenuse); 
      println("Raw mouse theta " + degrees(_thetaRad)); 
      float detX = mouseX - gx; 
      float detY = mouseY - gy; 
      _thetaRad = returnRealTheta(_thetaRad, detX, detY); 
      g.updateMoveTheta(_thetaRad); 
      g.updateGuardianTarget("None"); 
      g.updateGuardianTimeoutMove(true); 

      g.updateGuardianMoveTimer(gameMillis);
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

            if (selectedFlowerID >= 0 && g.getGuardianType() == 3) {
              float _thetaRad = calcMoveTheta(fx, fy, gx, gy); 
              //    println(detX, detY, degrees(_thetaRad));
              g.updateMoveTheta(_thetaRad); 
              g.updateGuardianTarget("Flower"); 
              g.updateInsideFlowerTimer(4501); //the guardian can move out from other flowers
              g.transferFlowerPedalAmount(_pedalAmount); 
              g.transferFlowerColors(_fColors); 
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
  }
  /////



  if (goTowardsBeehive) {
    for (Bee b : bees) {
      if (b.getBeeName().equals(upgradedBeeName[0])) continue; //priest bee
      println("Returning all bees to beehive..."); 
      b.goTowardsBeeHive(); 
      b.updateBeeSelectedStatus(false); //neutralize (reset) the bee's busy state because it has a target
      b.updateBeeMoveTimer(gameMillis);
    }
    for (Guardian g : guardians) {
      if (g.getGuardianName().equals(upgradedGuardianName[1])) { //baiting guardian
        g.goTowardsBeeHive(); 
        g.updateGuardianSelectedStatus(false); //neutralize (reset) the guardian's busy state because it has a target
        g.updateGuardianMoveTimer(gameMillis);
      }
    }
  } else if (selectedFlowerID != -1) {
    Flower f = flowers.get(selectedFlowerID); 
    float fx = f.getLocation().x; 
    float fy = f.getLocation().y; 
    int _pedalAmount = f.getPedalAmount(); 
    color[] _fColors = f.getStamenPedalColor(); 

    for (Bee b : bees) {
      if (b.getIsAlive() == false || b.getCurrHoneyCap() == b.getMaxHoneyCap() || b.getBeeName().equals(upgradedBeeName[0])) continue; //if the bee is dead / has full honey / is priest bee, skip this bee for choosing bees

      float bx = b.getLocation().x; 
      float by = b.getLocation().y; 

      float _thetaRad = calcMoveTheta(fx, fy, bx, by); 
      //    println(detX, detY, degrees(_thetaRad));
      b.updateBeeSelectedStatus(false); //neutralize (reset) the bee's busy state because it has a target
      b.updateMoveTheta(_thetaRad); 
      b.updateBeeMoveTimer(gameMillis); 

      b.transferFlowerPedalAmount(_pedalAmount); 
      b.transferFlowerColors(_fColors); 
      b.updateBeeTarget("Flower"); 
      b.updateShouldBeeMove(true); //so that the bee can move out from other flowers
      b.updateBeeTimeoutMove(false);
    }
    for (Guardian g : guardians) {
      if (g.getGuardianType() == 3) { //baiting guardian
        float gx = g.getLocation().x; 
        float gy = g.getLocation().y; 

        float _thetaRad = calcMoveTheta(fx, fy, gx, gy); 
        //    println(detX, detY, degrees(_thetaRad));
        g.updateGuardianSelectedStatus(false); //neutralize (reset) the guardian's busy state because it has a target
        g.updateMoveTheta(_thetaRad); 
        g.updateGuardianMoveTimer(gameMillis); 

        g.updateGuardianTarget("Flower"); 
        g.updateInsideFlowerTimer(4501); //so that the guardian can move out from other flowers
        g.transferFlowerPedalAmount(_pedalAmount); 
        g.transferFlowerColors(_fColors); 
        g.updateGuardianTimeoutMove(false);
      }
    }
  } else {
    // separated into two similar patterns because they actually different.
    // the following one only moves the bees that are selected while the one above moves all which requires only a single click.
    for (Bee b : bees) {
      if (b.getIsAlive() == false) continue; 

      float bx = b.getLocation().x; 
      float by = b.getLocation().y; 

      if (b.getBeeSelectedStatus() == true && beesSelectedCurr == beesSelectedPrev) {
        beesSelectedCurr = 0; 
        beesSelectedPrev = 0; 
        b.updateBeeSelectedStatus(false); 

        if (mouseX > width/2-15 && mouseX < width/2+15 && mouseY > height/2-15 && mouseY < height/2+15 && tutorialMinorStep >= TutorialStatus.Beehive) {
          if (b.getBeeName().equals(upgradedBeeName[0])) {
            b.updateBeeSelectedStatus(false); 
            continue;
          }
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
            if (b.getBeeName().equals(upgradedBeeName[0])) {
              b.updateBeeSelectedStatus(false); 
              continue;
            }
            float hypotenuse = distance_between_two_points(bx, fx, by, fy); 
            float _thetaRad = asin(abs(fy - by) / hypotenuse); 
            println("Raw flower theta " + degrees(_thetaRad)); 
            float detX = fx - bx; 
            float detY = fy - by; 
            _thetaRad = returnRealTheta(_thetaRad, detX, detY); 
            //    println(detX, detY, degrees(_thetaRad));
            b.updateMoveTheta(_thetaRad); 
            b.transferFlowerPedalAmount(_pedalAmount); 
            b.transferFlowerColors(_fColors); 
            b.updateBeeTarget("Flower"); 
            b.updateShouldBeeMove(true); //the bee can move out from other flowers
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
        //return; //prevent all guardian to go towards mouse position
      }
    }
  }
  /////
}

boolean invincibleBees = false; 
//boolean beeTimeoutMove = true;
void keyReleased() {
  switch (key) {
  case 's':
    save("/ScreenShots/"+year()+nf(month(), 2)+nf(day(), 2)+"-"+nf(hour(), 2)+nf(minute(), 2)+nf(second(), 2)+".png");
    println("screenshot saved.");
    break;

  case '-' : 
    questSeed = (int)random(0, 4095);
    assignQuest(); 
    break; 
  case '+' : 
    completedQuests++; 
    questSeed = (int)random(0, 4095);
    assignQuest(); 
    break; 
  case '=':
    updateQuest();
    break;

  case 'k' : 
  case 'K' : 
    int kill = (int)random(bees.size()-1); 
    while (isBeeDead[kill]) kill = (int)random(bees.size()-1); 
    bees.get(kill).updateIsAlive(false); 
    break; 

  case '`' : 
    frameRate(60); 
    break; 
  case 'g' : 
    buyGuardian(0); 
    break; 
  case 'G' : 
    buyGuardian(1); 
    break; 

  case 'h' : 
    hornets.add(new Hornet(0, false)); 
    break; 
  case 'H' : 
    for (int i = 0; i < 100; i++) hornets.add(new Hornet(0, false)); 
    break; 

  case 'd' : 
  case 'D' : 
    debug = !debug; 
    break; 

  case 'i' : 
  case 'I' : 
    invincibleBees = !invincibleBees; 
    println("Invincible Bees turned to: " + invincibleBees); 
    break;

  case 'm' : 
  case 'M' : 
    money += 100000; 
    break; 

    //case 's':
    //case 'S':
    //  //sell all honey
    //  money += honeyKg * honeyPrice;
    //  honeyKg = 0;
    //  break;

  case 'f' : 
    flowers.add(new Flower(10+random(width-20), 40+random(height-40-50), forestHoneyRng[forestType][0], forestHoneyRng[forestType][1])); 
    break; 
  case 'F' : 
    for (int i = 0; i < 50; i++) flowers.add(new Flower(10+random(width-20), 40+random(height-40-50), forestHoneyRng[forestType][0], forestHoneyRng[forestType][1])); 
    break; 

  case 'w' : 
  case 'W' : 
    gameMillis = ROUND_TIME; 
    break; 

  case '1' : 
  case '2' : 
  case '3' : 
  case '4' : 
  case '5' : 
  case '6' : 
    println(int(key)-49); 
    buyBee(int(key)-49); 
    break; 

  case 'z' : 
  case 'Z' : 
    if (flowers.size()>0) flowers.remove(0); 
    break; 

    //  case 'm':
    //  case 'M':
    //    for (Bee b : bees) {
    //      b.updateBeeTimeoutMove(!b.getBeeTimeoutMove());
    //      println(b.getBeeTimeoutMove());
    //    }
    //    break;

  case 'p' : 
  case 'P' : 
    println('X', mouseX, 'Y', mouseY); 
    break; 

  case 'l' : 
  case 'L' : 
    fireflies.add(new Firefly(false));
    break; 

  case 't' : 
  case 'T' : 
    //GTSuccessConditionMatch = true;
    BTObjectiveScore += 50; 
    //GTObjectiveTier = 4;
    break; 

    //case 'a':
    //case 'A':
    //  GTObjectiveScore++;
    //  break;
    //case 'b':
    //case 'B':
    //  GTObjectiveScore+=5;
    //  break;

    //case 'r':
    //  projectiles.add(new ProjectileWeapon(random(1) > 0.5 ? 1 : 0, width/2, height/2, radians(random(360)), false));
    //  break;
    //case 'R':
    //  for (int i = 0; i < 50; i++) projectiles.add(new ProjectileWeapon(random(1) > 0.5 ? 1 : 0, width/2, height/2, radians(random(360)), false));
    //  break;

    //case 's':
    //case 'S':
    //  pomegranate.add(new ItemSpawn(0));
    //  break;

  case '!' : 
  case '@' : 
  case '#' : 
  case '$' : 
  case '%' : 
  case '^' : 
    guardians.add(new Guardian(upgradedGuardianName[(keyCode-49)])); 
    inventoryGuardians.add(new Guardian(upgradedGuardianName[(keyCode-49)])); 
    inventoryGuardians.get(inventoryGuardians.size()-1).updateShouldGuardianMove(false); 
    break; 

  case '&' : 
  case '*' : 
  case '(' : 
    bees.add(new Bee(keyCode-55+beeName.length)); 
    bees.get(bees.size()-1).updateTier(1);
    inventoryBees.add(new Bee(keyCode-55+beeName.length)); 
    inventoryBees.get(inventoryBees.size()-1).updateShouldBeeMove(false); 
    inventoryBees.get(inventoryBees.size()-1).updateForShop(true); 
    inventoryBees.get(inventoryBees.size()-1).updateMoveTheta(HALF_PI); 
    break; 

  case ')' : 
    bees.add(new Bee(beeName.length+upgradedBeeName.length-1)); 
    inventoryBees.add(new Bee(beeName.length+upgradedBeeName.length-1)); 
    inventoryBees.get(inventoryBees.size()-1).updateShouldBeeMove(false); 
    inventoryBees.get(inventoryBees.size()-1).updateForShop(true); 
    inventoryBees.get(inventoryBees.size()-1).updateMoveTheta(HALF_PI); 
    break; 

  case 'q' : 
    resourceAppearTimer = 0; 
    break; 

  case 'n' : 
    noti.add(new Notification(12, color(50), 20, height-60, "Hello World!", 1000, "Down Corner")); 
    break; 

  case 'o':
  case 'O':
    gameOver = true;
    break;

  case 'r':
    debugRating -= 2;
    break;
  case 'R':
    debugRating +=2;
    break;

  case 'j':
    projectiles.add(new ProjectileWeapon(2, -1, width/2, height/2, random(TWO_PI), false));
    break;
  case 'J':
    try {
      projectiles.get(projectiles.size()-1).activate();
    } 
    catch (RuntimeException e) {
    }
    break;

    //surface.setTitle("HI"); //<== this thing changes the window name
  }

  //if (keyCode == ENTER && startupScreenActive) {
  //  pMillis = System.currentTimeMillis();

  //  screenDisable();
  //  startupScreenActive = false;
  //  gameScreenActive = true;
  //}
}

void keyPressed() {
  if (keyCode == ESC) {
    key = 0; 
    println("disabled esc key :)");
  }
}