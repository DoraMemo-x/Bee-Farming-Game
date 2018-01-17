//tutorial
boolean initiateTutorial = false;
//https://forum.processing.org/two/discussion/23409/enums-in-openprocessing
//enum doesnt seem to be working very well. so the next best thing is "abstract class"
static abstract class TutorialStatus {
  static final int BeforeTutorial = 0; //0
  static final int BeeSingleMovement = 1; //1 
  static final int BeeMultipleMovement = 2;
  static final int Beehive = 3;
  static final int TopStatsBar = 4; 
  static final int BottomButtonsBar = 5; 
  static final int InsideMarket = 6;
  static final int InsideBeeInv = 7;
  static final int InsideGuardInv = 8;
  static final int Graph = 9;
  static final int EnemyHornet = 10;
  static final int EnemyFirefly = 11;
  static final int GTraining = 12;
  static final int BTraining = 13;
  static final int EndTutorial = 14;
}
//TutorialStatus status = TutorialStatus.BeforeTutorial;
int status = TutorialStatus.BeforeTutorial; //0 (debugging. should be BeforeTutorial)
float tutorialMinorStep = status;
boolean tutorialRequirements[] = new boolean[10];
boolean tutorialPass = false;
boolean tutorialFailed = false;
int tutorialTimerA = 0, tutorialTimerB = 0;
Button startTutorial;
Button nextPrompt;
Button retryTutorial;

void tutorialDisplay() {

  gameMillis += (timeMillis-pMillis);
  //println(status, tutorialMinorStep);

  if (status == TutorialStatus.InsideMarket || status == TutorialStatus.InsideBeeInv || status == TutorialStatus.Graph || tutorialMinorStep == TutorialStatus.EnemyFirefly+0.2 || status == TutorialStatus.GTraining || status == TutorialStatus.BTraining) background(235); 
  else background(255);

  fill(0);
  textAlign(LEFT);
  textSize(12);
  if (status < TutorialStatus.BottomButtonsBar || status == TutorialStatus.InsideMarket || status == TutorialStatus.InsideBeeInv || status == TutorialStatus.Graph || tutorialMinorStep == TutorialStatus.EnemyFirefly+0.2 || status == TutorialStatus.GTraining || status == TutorialStatus.BTraining) text("Tutorial: Section " + tutorialMinorStep, 20, height-20);
  else text("Tutorial: Section " + tutorialMinorStep, 20, height-55);

  if (status == TutorialStatus.BeforeTutorial) {
    status = TutorialStatus.BeeSingleMovement; 
    tutorialMinorStep = status;
    //status = TutorialStatus.EnemyFirefly;
    //tutorialMinorStep = status+0.1; //testing. uncomment the above 2 lines for full tutorial
  }

  //if (keyPressed && key == ' ') {
  //  nextPrompt.Draw();
  //  retryTutorial.Draw();
  //}


  if (status == TutorialStatus.BeeSingleMovement) {
    // println(tutorialMinorStep);
    if (tutorialMinorStep == TutorialStatus.BeeSingleMovement) {
      fill(54, 27, 0);
      strokeWeight(12);
      stroke(251, 200, 55);
      rect(50, 50, 300, 150, 20, 0, 20, 0);
      fill(255);
      textAlign(CENTER);
      PFont lineFont = createFont("Lucida Sans Demibold", 16);
      textFont(lineFont);
      text("Welcome to the tutorial!", 200, 50+75+6);
      lineFont = createFont("Lucida Sans Regular", 16);
      textFont(lineFont);

      tutorialPass = true;
      nextPrompt.Draw();
    } else if (tutorialMinorStep == TutorialStatus.BeeSingleMovement+0.1) {
      fill(54, 27, 0);
      strokeWeight(12);
      stroke(251, 200, 55);
      rect(50, 50, 300, 150, 20, 0, 20, 0);
      fill(255);
      textAlign(CENTER);
      PFont lineFont = createFont("Lucida Sans Demibold", 16);
      textFont(lineFont);

      if (flowers.size() == 0) tutorialPass = true;

      if (bees.get(0).getBeeSelectedStatus()) {
        text("Press the flower", 200, 50+75+6-10);
        text("to select the flower!", 200, 50+75+6+10);
      } else if (bees.get(0).getBeeTarget().equals("Flower")) {
        text("Now the bee will fly towards", 200, 50+75+6-10);
        text("the flower to pick honey!", 200, 50+75+6+10);
      } else if (bees.get(0).getCurrHoneyCap() != 0 && flowers.size() > 0) {
        text("When the bee is picking honey,", 200, 50+75+6-10);
        text("it will stay on the flower.", 200, 50+75+6+10);
      } else if (tutorialPass) {
        text("The flower is emptied!", 200, 50+75+6-10);
        text("Proceed to the next tutorial.", 200, 50+75+6+10);
        nextPrompt.Draw();
      } else text("Press the bee to select the bee!", 200, 50+75+6);
      lineFont = createFont("Lucida Sans Regular", 16);
      textFont(lineFont);

      for (Flower f : flowers) {
        f.showFlower();
      }
      for (Bee b : bees) {
        b.showBee();
        b.move();
      }
    } else if (tutorialMinorStep == TutorialStatus.BeeSingleMovement+0.2) {
      flowers = new ArrayList<Flower>();
      bees = new ArrayList<Bee>();

      for (int i = 0; i < 3; i++) bees.add(new Bee(0));
      flowers.add(new Flower(width/2+200, height/2+150, 10, 12));

      status = TutorialStatus.BeeMultipleMovement;
      tutorialMinorStep = status;
    }
  }
  if (status == TutorialStatus.BeeMultipleMovement) {
    if (tutorialMinorStep == TutorialStatus.BeeMultipleMovement) {
      fill(54, 27, 0);
      strokeWeight(12);
      stroke(251, 200, 55);
      rect(50, 50, 300, 150, 20, 0, 20, 0);
      fill(255);
      textAlign(CENTER);
      PFont lineFont = createFont("Lucida Sans Demibold", 16);
      textFont(lineFont);

      //int beesSelected = 0;
      boolean beeFull = false;
      for (Bee b : bees) {
        if (b.getCurrHoneyCap() == b.getMaxHoneyCap()) beeFull = true;
        if (b.getCurrHoneyCap() > 0 || b.getBeeTarget().equals("Flower")) {
          tutorialRequirements[1] = true;
          break;
        }
      }
      //if (beesSelectedCurr >= 2) tutorialRequirements[0] = true;

      if (beeFull) tutorialPass = true;

      if (tutorialPass) {
        text("Bees that are full", 200, 50+75+6-20);
        text("cannot pick more honey.", 200, 50+75+6);
        text("(Shown in red text)", 200, 50+75+6+20);
        nextPrompt.Draw();
      } else if (tutorialRequirements[1]) {
        text("Now wait for a bee", 200, 50+75+6-10);
        text("to pick up 5kg of honey...", 200, 50+75+6+10);
      } else if (beesSelectedCurr >= 2) {
        text("Press the flower", 200, 50+75+6-20);
        text("to make the " + beesSelectedCurr + " selected", 200, 50+75+6);
        text("bees to fly to that flower!", 200, 50+75+6+20);
      } else {
        text("Press 2 bees (or more)", 200, 50+75+6-10);
        text("to select them!", 200, 50+75+6+10);
      }
      lineFont = createFont("Lucida Sans Regular", 16);
      textFont(lineFont);

      for (Flower f : flowers) {
        f.showFlower();
      }
      for (Bee b : bees) {
        b.showBee();
        b.move();
      }
      if (flowers.size() == 0) flowers.add(new Flower(random(width/2-20)+10, 200+random(height/2), 10, 12));
    } else if (tutorialMinorStep == TutorialStatus.BeeMultipleMovement+0.1) {
      fill(54, 27, 0);
      strokeWeight(12);
      stroke(251, 200, 55);
      rect(50, 50, 300, 150, 20, 0, 20, 0);
      fill(255);
      textAlign(CENTER);
      PFont lineFont = createFont("Lucida Sans Demibold", 16);
      textFont(lineFont);

      //int beesSelected = 0, beesPrevSelected = 0;
      //for (Bee b : bees) {
      //  if (b.getBeeSelectedStatus()) beesSelected++;
      //}


      if (beesSelectedPrev > 0 && beesSelectedCurr < beesSelectedPrev) {
        tutorialPass = true;
      }

      if (beesSelectedCurr > 0) {
        text("You can deselect a bee", 200, 50+75+6-10);
        text("by pressing the bee again.", 200, 50+75+6+10);
      } else if (tutorialPass) {
        text("Good job!", 200, 50+75+6);
        nextPrompt.Draw();
      } else {
        text("Press a bee to select it!", 200, 50+75+6);
      }
      lineFont = createFont("Lucida Sans Regular", 16);
      textFont(lineFont);

      for (Bee b : bees) {
        b.showBee();
        b.move();
      }
    } else if (tutorialMinorStep == TutorialStatus.BeeMultipleMovement+0.2) {
      fill(54, 27, 0);
      strokeWeight(12);
      stroke(251, 200, 55);
      rect(50, 50, 300, 150, 20, 0, 20, 0);
      fill(255);
      textAlign(CENTER);
      PFont lineFont = createFont("Lucida Sans Demibold", 16);
      textFont(lineFont);

      for (Bee b : bees) {
        if (b.getBeeTarget().equals("Flower")) {
          tutorialRequirements[0] = true;
          continue;
        } else {
          tutorialRequirements[0] = false;
          break;
        }
      }
      if (beesSelectedCurr > 0) tutorialFailed = true;
      if (tutorialRequirements[0] == true) tutorialPass = true;

      if (tutorialPass) tutorialFailed = false;

      if (tutorialFailed) {
        fill(255, 200, 200);
        text("You failed!", 200, 50+75+6-30);
        text("Select the flower", 200, 50+75+6-10);
        fill(255, 50, 50);
        text("WITHOUT SELECTING BEES!", 200, 50+75+6+10);
        fill(255, 200, 200);
        text("Press retry.", 200, 50+75+6+30);
        retryTutorial.Draw();
      } else if (tutorialPass) {
        text("If a flower is selected", 200, 50+75+6-30);
        text("without selecting any bees,", 200, 50+75+6-10);
        text("all bees would fly to", 200, 50+75+6+10);
        text("the selected flower.", 200, 50+75+6+30);
        nextPrompt.Draw();
      } else {
        text("Try to select the flower", 200, 50+75+6-10);
        text("without selecting any bees!", 200, 50+75+6+10);
      }
      lineFont = createFont("Lucida Sans Regular", 16);
      textFont(lineFont);

      for (Flower f : flowers) {
        f.showFlower();
      }
      for (Bee b : bees) {
        b.showBee();
        b.move();
      }
    } else if (tutorialMinorStep == TutorialStatus.BeeMultipleMovement+0.3) {
      //next stage
      flowers = new ArrayList<Flower>();

      for (int i = 0; i < 3; i++) {
        bees.get(i).updateHoneyCap(2000);
      }
      moveAllBees();

      status = TutorialStatus.Beehive;
      tutorialMinorStep = status;
    }
  }
  if (status == TutorialStatus.Beehive) {
    if (tutorialMinorStep == TutorialStatus.Beehive) {
      fill(54, 27, 0);
      strokeWeight(12);
      stroke(251, 200, 55);
      rect(50, 50, 300, 150, 20, 0, 20, 0);
      fill(255);
      textAlign(CENTER);
      PFont lineFont = createFont("Lucida Sans Demibold", 16);
      textFont(lineFont);

      for (Bee b : bees) {
        if (b.getCurrHoneyCap() == 0) {
          tutorialPass = true;
          break;
        }
      }
      if (beesSelectedCurr > 0) tutorialRequirements[0] = true;

      if (tutorialPass) {
        text("Good job!", 200, 50+75+6-30);
        text("If bees have honey on them", 200, 50+75+6-10);
        text("when they return to beehive,", 200, 50+75+6+10);
        text("they will store the honey.", 200, 50+75+6+30);
        nextPrompt.Draw();
      } else if (tutorialRequirements[0]) {
        text("Press the beehive", 200, 50+75+6-20);
        text("to return the bee", 200, 50+75+6);
        text("to beehive!", 200, 50+75+6+20);
      } else text("Press a bee to select the bee!", 200, 50+75+6);
      lineFont = createFont("Lucida Sans Regular", 16);
      textFont(lineFont);


      drawCenterBeehive();
      for (Flower f : flowers) {
        f.showFlower();
      }
      for (Bee b : bees) {
        b.showBee();
        b.move();
      }
    } else if (tutorialMinorStep == TutorialStatus.Beehive+0.1) {
      fill(54, 27, 0);
      strokeWeight(12);
      stroke(251, 200, 55);
      rect(50, 50, 300, 150, 20, 0, 20, 0);
      fill(255);
      textAlign(CENTER);
      PFont lineFont = createFont("Lucida Sans Demibold", 16);
      textFont(lineFont);

      for (Bee b : bees) {
        if (b.getBeeTarget().equals("Beehive")) {
          tutorialRequirements[0] = true;
          continue;
        } else {
          tutorialRequirements[0] = false;
          break;
        }
      }
      if (beesSelectedCurr > 0) tutorialFailed = true;
      if (tutorialRequirements[0] == true) tutorialPass = true;

      if (tutorialPass) tutorialFailed = false;

      if (tutorialFailed) {
        fill(255, 200, 200);
        text("You failed!.", 200, 50+75+6-30);
        text("Select the beehive", 200, 50+75+6-10);
        fill(255, 50, 50);
        text("WITHOUT SELECTING BEES!", 200, 50+75+6+10);
        fill(255, 200, 200);
        text("Press retry.", 200, 50+75+6+30);
        retryTutorial.Draw();
      } else if (tutorialPass) {
        text("If the beehive is selected", 200, 50+75+6-30);
        text("without selecting any bees,", 200, 50+75+6-10);
        text("all bees would return", 200, 50+75+6+10);
        text("to the beehive.", 200, 50+75+6+30);
        nextPrompt.Draw();
      } else {
        text("Try to select the beehive", 200, 50+75+6-10);
        text("without selecting any bees!", 200, 50+75+6+10);
      }
      lineFont = createFont("Lucida Sans Regular", 16);
      textFont(lineFont);

      drawCenterBeehive();
      for (Flower f : flowers) {
        f.showFlower();
      }
      for (Bee b : bees) {
        b.showBee();
        b.move();
      }
    } else if (tutorialMinorStep == TutorialStatus.Beehive+0.2) {
      //next stage
      flowers = new ArrayList<Flower>();
      bees = new ArrayList<Bee>();

      for (int i = 0; i < 3; i++) bees.add(new Bee(0));
      flowers.add(new Flower(width/2+200, height/2+150, 10, 12));

      tutorialTimerA = (int)gameMillis;
      tutorialTimerB = (int)gameMillis;

      status = TutorialStatus.TopStatsBar;
      tutorialMinorStep = status;
    }
  }
  if (status == TutorialStatus.TopStatsBar) {
    if (flowers.size() == 0) flowers.add(new Flower(10+random(width-20), 40+random(height-40-50), 10, 12));

    //stats bar grey
    noStroke();
    fill(160);
    rect(0, 0, width, 30);

    fill(54, 27, 0);
    strokeWeight(12);
    stroke(251, 200, 55);
    rect(50, 50, 300, 150, 20, 0, 20, 0);
    fill(255);
    textAlign(CENTER);
    PFont lineFont = createFont("Lucida Sans Demibold", 16);
    textFont(lineFont);

    tutorialPass = true;

    if (tutorialMinorStep == TutorialStatus.TopStatsBar) {
      text("This stat shows the information", 200, 50+75+6-40);
      text("of the size of the beehive.", 200, 50+75+6-20);
      text(bees.size() + " means you own " + bees.size() + " bees;", 200, 50+75+6);
      text("5 means the maximum number", 200, 50+75+6+20);
      text("bees you can have.", 200, 50+75+6+40);
      nextPrompt.Draw();

      lineFont = createFont("Lucida Sans Regular", 16);
      textFont(lineFont);


      drawCenterBeehive();
      for (Flower f : flowers) {
        f.showFlower();
      }
      for (Bee b : bees) {
        b.showBee();
        b.move();
      }


      stroke(252, 232, 100);
      strokeWeight(2);
      fill(221, 114, 1);
      pushMatrix();
      translate(50, 15);
      rotate(HALF_PI);
      polygon(0, 0, 12, 6); //beehive size icon
      popMatrix();

      textSize(12);
      if (tutorialRequirements[9] == false) {
        if (beesCount < beehiveSize[beehiveTier]) fill(255);
        else fill(255, 0, 0);
        if (gameMillis - tutorialTimerA > 300) {
          tutorialTimerA = (int)gameMillis;
          tutorialTimerB = (int)gameMillis;
          tutorialRequirements[9] = true;
        }
      } else {
        fill(255, 188, 0);
        if (gameMillis - tutorialTimerB > 300) {
          tutorialTimerA = (int)gameMillis;
          tutorialTimerB = (int)gameMillis;
          tutorialRequirements[9] = false;
        }
      }

      textAlign(LEFT);
      text(beesCount + " / " + beehiveSize[beehiveTier], 80, 19);
    } else if (tutorialMinorStep == TutorialStatus.TopStatsBar+0.1) {
      text("This stat shows the information", 200, 50+75+6-40);
      text("of the amount of honey you have.", 200, 50+75+6-20);
      text("The honey pot has a capacity - ", 200, 50+75+6);
      text("if the capcity is reached,", 200, 50+75+6+20);
      text("the honey will not be stored.", 200, 50+75+6+40);
      nextPrompt.Draw();

      lineFont = createFont("Lucida Sans Regular", 16);
      textFont(lineFont);


      drawCenterBeehive();
      for (Flower f : flowers) {
        f.showFlower();
      }
      for (Bee b : bees) {
        b.showBee();
        b.move();
      }



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

      fill(255);

      if (tutorialRequirements[9] == false) {
        if (honeyKg < honeyPotCapKg[honeyPotTier]) fill(255);
        else fill(255, 0, 0);
        if (gameMillis - tutorialTimerA > 300) {
          tutorialTimerA = (int)gameMillis;
          tutorialTimerB = (int)gameMillis;
          tutorialRequirements[9] = true;
        }
      } else {
        fill(255, 188, 0);
        if (gameMillis - tutorialTimerB > 300) {
          tutorialTimerA = (int)gameMillis;
          tutorialTimerB = (int)gameMillis;
          tutorialRequirements[9] = false;
        }
      }
      text("Honey: ", 180, 19);   
      text(honeyKg, 225, 19);
    } else if (tutorialMinorStep == TutorialStatus.TopStatsBar+0.2) {
      text("This stat shows the information", 200, 50+75+6-30);
      text("of how much you can sell", 200, 50+75+6-10);
      text("your honey for. This price", 200, 50+75+6+10);
      text("changes over time randomly.", 200, 50+75+6+30);
      nextPrompt.Draw();

      lineFont = createFont("Lucida Sans Regular", 16);
      textFont(lineFont);


      drawCenterBeehive();
      for (Flower f : flowers) {
        f.showFlower();
      }
      for (Bee b : bees) {
        b.showBee();
        b.move();
      }



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

      if (tutorialRequirements[9] == false) {
        fill(255);
        if (gameMillis - tutorialTimerA > 300) {
          tutorialTimerA = (int)gameMillis;
          tutorialTimerB = (int)gameMillis;
          tutorialRequirements[9] = true;
        }
      } else {
        fill(255, 188, 0);
        if (gameMillis - tutorialTimerB > 300) {
          tutorialTimerA = (int)gameMillis;
          tutorialTimerB = (int)gameMillis;
          tutorialRequirements[9] = false;
        }
      }
      textAlign(LEFT);
      text("Honey Price: ", 310, 19);

      if (tutorialRequirements[9] == false) {
        fill(0, 255, 0);
        if (gameMillis - tutorialTimerA > 300) {
          tutorialTimerA = (int)gameMillis;
          tutorialTimerB = (int)gameMillis;
          tutorialRequirements[9] = true;
        }
      } else {
        fill(255, 188, 0);
        if (gameMillis - tutorialTimerB > 300) {
          tutorialTimerA = (int)gameMillis;
          tutorialTimerB = (int)gameMillis;
          tutorialRequirements[9] = false;
        }
      }
      text("50", 385, 19);
      if (tutorialRequirements[9] == false) {
        fill(255);
        if (gameMillis - tutorialTimerA > 300) {
          tutorialTimerA = (int)gameMillis;
          tutorialTimerB = (int)gameMillis;
          tutorialRequirements[9] = true;
        }
      } else {
        fill(255, 188, 0);
        if (gameMillis - tutorialTimerB > 300) {
          tutorialTimerA = (int)gameMillis;
          tutorialTimerB = (int)gameMillis;
          tutorialRequirements[9] = false;
        }
      }
      text("$/kg", 410, 19);
    } else if (tutorialMinorStep == TutorialStatus.TopStatsBar+0.3) {
      text("This stat shows the information", 200, 50+75+6-10);
      text("of your current balance.", 200, 50+75+6+10);
      nextPrompt.Draw();

      lineFont = createFont("Lucida Sans Regular", 16);
      textFont(lineFont);


      drawCenterBeehive();
      for (Flower f : flowers) {
        f.showFlower();
      }
      for (Bee b : bees) {
        b.showBee();
        b.move();
      }



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

      fill(255);
      textAlign(LEFT);
      text("Honey Price: ", 310, 19);

      fill(0, 255, 0);
      text(50, 385, 19);
      fill(255);
      text("$/kg", 410, 19);

      if (tutorialRequirements[9] == false) {
        fill(255);
        if (gameMillis - tutorialTimerA > 300) {
          tutorialTimerA = (int)gameMillis;
          tutorialTimerB = (int)gameMillis;
          tutorialRequirements[9] = true;
        }
      } else {
        fill(255, 188, 0);
        if (gameMillis - tutorialTimerB > 300) {
          tutorialTimerA = (int)gameMillis;
          tutorialTimerB = (int)gameMillis;
          tutorialRequirements[9] = false;
        }
      }
      text("Money: $" + nfc(money), 480, 19);
    } else if (tutorialMinorStep == TutorialStatus.TopStatsBar+0.4) {
      roundTime = gameMillis;

      if (roundTime < ROUND_TIME) {
        text("This shows the time passed", 200, 50+75+6-30);
        text("in the current round.", 200, 50+75+6-10);
        text("Once it is full,", 200, 50+75+6+10);
        text("the round ends.", 200, 50+75+6+30);
      } else {
        text("Hey! Press NEXT already!", 200, 50+75+6);
      }
      nextPrompt.Draw();

      lineFont = createFont("Lucida Sans Regular", 16);
      textFont(lineFont);


      drawCenterBeehive();
      for (Flower f : flowers) {
        f.showFlower();
      }
      for (Bee b : bees) {
        b.showBee();
        b.move();
      }



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

      fill(255);
      textAlign(LEFT);
      text("Honey Price: ", 310, 19);

      fill(0, 255, 0);
      text(50, 385, 19);
      fill(255);
      text("$/kg", 410, 19);

      fill(255);
      text("Money: $" + nfc(money), 480, 19);

      if (tutorialRequirements[9] == false) {
        fill(255);
        stroke(255);
        if (gameMillis - tutorialTimerA > 300) {
          tutorialTimerA = (int)gameMillis;
          tutorialTimerB = (int)gameMillis;
          tutorialRequirements[9] = true;
        }
      } else {
        fill(255, 188, 0);
        stroke(255, 188, 0);
        if (gameMillis - tutorialTimerB > 300) {
          tutorialTimerA = (int)gameMillis;
          tutorialTimerB = (int)gameMillis;
          tutorialRequirements[9] = false;
        }
      }
      text("Time: ", 600, 19);
      strokeWeight(1);
      noFill();
      ellipse(660, 15, 26, 26);
      if (tutorialRequirements[9] == false) {
        fill(255);
        if (gameMillis - tutorialTimerA > 300) {
          tutorialTimerA = (int)gameMillis;
          tutorialTimerB = (int)gameMillis;
          tutorialRequirements[9] = true;
        }
      } else {
        fill(255, 188, 0);
        if (gameMillis - tutorialTimerB > 300) {
          tutorialTimerA = (int)gameMillis;
          tutorialTimerB = (int)gameMillis;
          tutorialRequirements[9] = false;
        }
      }
      arc(660, 15, 26, 26, -HALF_PI, map(roundTime, 0, ROUND_TIME, -HALF_PI, PI+HALF_PI), PIE);
    } else if (tutorialMinorStep == TutorialStatus.TopStatsBar+0.5) {
      roundTime = gameMillis;

      if (roundTime < ROUND_TIME) {
        text("This stat shows which week", 200, 50+75+6-20);
        text("you are in now.", 200, 50+75+6);
        text("The game ends after " + GAME_WEEK_LENGTH + " weeks.", 200, 50+75+6+20);
      } else {
        text("Hey! Press NEXT already!", 200, 50+75+6);
      }
      nextPrompt.Draw();

      lineFont = createFont("Lucida Sans Regular", 16);
      textFont(lineFont);


      drawCenterBeehive();
      for (Flower f : flowers) {
        f.showFlower();
      }
      for (Bee b : bees) {
        b.showBee();
        b.move();
      }



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

      fill(255);
      textAlign(LEFT);
      text("Honey Price: ", 310, 19);

      fill(0, 255, 0);
      text(50, 385, 19);
      fill(255);
      text("$/kg", 410, 19);

      fill(255);
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
      if (tutorialRequirements[9] == false) {
        fill(255);
        if (gameMillis - tutorialTimerA > 300) {
          tutorialTimerA = (int)gameMillis;
          tutorialTimerB = (int)gameMillis;
          tutorialRequirements[9] = true;
        }
      } else {
        fill(255, 188, 0);
        if (gameMillis - tutorialTimerB > 300) {
          tutorialTimerA = (int)gameMillis;
          tutorialTimerB = (int)gameMillis;
          tutorialRequirements[9] = false;
        }
      }
      text("Week: " +week, width-20, 19);
    } else if (tutorialMinorStep == TutorialStatus.TopStatsBar+0.6) {
      //next stage
      gameMillis = 0;
      tutorialTimerA = 0;
      tutorialTimerB = 0;

      flowers = new ArrayList<Flower>();
      flowers.add(new Flower(width/2+200, height/2+150, 10, 15));

      status = TutorialStatus.BottomButtonsBar;
      tutorialMinorStep = status;
    }
  }
  if (status == TutorialStatus.BottomButtonsBar) {
    roundTime = gameMillis;

    fill(54, 27, 0);
    strokeWeight(12);
    stroke(251, 200, 55);
    rect(50, 50, 300, 150, 20, 0, 20, 0);
    fill(255);
    textAlign(CENTER);
    PFont lineFont = createFont("Lucida Sans Demibold", 16);
    textFont(lineFont);

    if (tutorialRequirements[8] == false) {
      text("This bar gives you access", 200, 50+75+6-20);
      text("to other locations.", 200, 50+75+6);
      text("Press Market to continue.", 200, 50+75+6+20);
    } else {
      text("Not this! Press Market!", 200, 50+75+6);
    }

    lineFont = createFont("Lucida Sans Regular", 16);
    textFont(lineFont);



    drawCenterBeehive();
    for (Flower f : flowers) {
      f.showFlower();
    }
    for (Bee b : bees) {
      b.showBee();
      b.move();
    }



    if (tutorialRequirements[9] == false) {
      showMarketBtn.updateMouseIsOver(true);
      if (gameMillis - tutorialTimerA > 300) {
        tutorialTimerA = (int)gameMillis;
        tutorialTimerB = (int)gameMillis;
        tutorialRequirements[9] = true;
      }
    } else {
      showMarketBtn.updateMouseIsOver(false);
      if (gameMillis - tutorialTimerB > 300) {
        tutorialTimerA = (int)gameMillis;
        tutorialTimerB = (int)gameMillis;
        tutorialRequirements[9] = false;
      }
    }
    bottomStatsBar();
  }
  if (status == TutorialStatus.InsideMarket) {
    fill(255);
    textAlign(CENTER);
    PFont lineFont = createFont("Lucida Sans Demibold", 16);
    textFont(lineFont);

    if (tutorialMinorStep == TutorialStatus.InsideMarket) {
      fill(54, 27, 0);
      strokeWeight(12);
      stroke(251, 200, 55);
      rect(50, height-220, 300, 150, 20, 0, 20, 0);

      if (bees.size() == 5) tutorialPass = true;

      fill(255);
      if (tutorialPass) {
        text("There you go!", 200, height-220+75+6-10);
        text("You now own a new bee.", 200, height-220+75+6+10);
        nextPrompt.Draw();
      } else {
        text("In the market, time is paused!", 200, height-220+75+6-50);

        text("The more expensive the bees are,", 200, height-220+75+6-10);
        text("the faster they fly and", 200, height-220+75+6+10);
        text("the faster they collect honey.", 200, height-220+75+6+30);
        text("Try to make a purchase!", 200, height-220+75+6+50);
      }

      lineFont = createFont("Lucida Sans Regular", 16);
      textFont(lineFont);



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

      if (ERRORnotEnoughMoney) {
        fill(0);
        textAlign(LEFT);
        text("You don't have enough money!", 50, height-50);
      } else if (ERRORbeehiveFull) {
        fill(0);
        textAlign(LEFT);
        text("Your beehive is full!", 50, height-50);
      }



      for (Bee sb : showcaseBees) {
        sb.showBee();
      }
    } else if (tutorialMinorStep == TutorialStatus.InsideMarket+0.1) {
      fill(54, 27, 0);
      strokeWeight(12);
      stroke(251, 200, 55);
      rect(50, height-220, 300, 150, 20, 0, 20, 0);

      tutorialPass = true;

      fill(255);
      text("These are guardians.", 200, height-220+75+6-30);
      text("They can protect your bees", 200, height-220+75+6-10);
      text("from enemy insects.", 200, height-220+75+6+10);
      text("You don't need them right now.", 200, height-220+75+6+30);
      nextPrompt.Draw();

      lineFont = createFont("Lucida Sans Regular", 16);
      textFont(lineFont);



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
        buyGuardian.get(i).Draw();

        fill(80);
        if (guardiansCountIndividual[i] > 0) {
          if (i == 0) text("("+guardiansCountIndividual[i]+")", 50+185*i + 100/2, 180);
          else text("("+guardiansCountIndividual[i]+")", 50+185*i + 120/2, 180);
        }
      }
      fill(0);
      for (int i = 0; i < guardianCost.length; i++) {
        if (i == 0) text("$"+nfc(guardianCost[i]), 50+185*i + 100/2, 150+60);
        else text("$"+nfc(guardianCost[i]), 50+185*i + 120/2, 150+60);
      }

      if (ERRORnotEnoughMoney) {
        fill(0);
        textAlign(LEFT);
        text("You don't have enough money!", 50, height-50);
      } else if (ERRORbeehiveFull) {
        fill(0);
        textAlign(LEFT);
        text("Your beehive is full!", 50, height-50);
      }

      for (Bee sb : showcaseBees) {
        sb.showBee();
      }
      for (Guardian sg : showcaseGuardians) {
        sg.showGuardian();
      }
    } else if (tutorialMinorStep == TutorialStatus.InsideMarket+0.2) {
      fill(54, 27, 0);
      strokeWeight(12);
      stroke(251, 200, 55);
      rect(50, height-220, 300, 150, 20, 0, 20, 0);

      if (money < 1000) tutorialPass = true;

      fill(255);
      if (tutorialPass) {
        text("The colour of your", 200, height-220+75+6-20);
        text("new honey pot is applied to the", 200, height-220+75+6);
        text("Honey stat in the top bar.", 200, height-220+75+6+20);
        nextPrompt.Draw();
      } else {
        text("Your honey pot has a capacity", 200, height-220+75+6-50);
        text("limit. You can increase its", 200, height-220+75+6-30);
        text("capacity by upgrading the", 200, height-220+75+6-10);
        text("current honey pot to a larger one.", 200, height-220+75+6+10);
        text("(You can't buy more honey pots.)", 200, height-220+75+6+30);
        text("Try to purchase the pink pot!", 200, height-220+75+6+50);
      }
      lineFont = createFont("Lucida Sans Regular", 16);
      textFont(lineFont);



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
        buyGuardian.get(i).Draw();

        fill(80);
        if (guardiansCountIndividual[i] > 0) {
          if (i == 0) text("("+guardiansCountIndividual[i]+")", 50+185*i + 100/2, 180);
          else text("("+guardiansCountIndividual[i]+")", 50+185*i + 120/2, 180);
        }
      }
      fill(0);
      for (int i = 0; i < guardianCost.length; i++) {
        if (i == 0) text("$"+nfc(guardianCost[i]), 50+185*i + 100/2, 150+60);
        else text("$"+nfc(guardianCost[i]), 50+185*i + 120/2, 150+60);
      }

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
      }

      for (int i = 0; i < honeyPotPrice.length-1; i++) {
        buyPot.get(i).Draw();

        text("Pot", 80+100*i, 230+60);
        text("$"+nfc(honeyPotPrice[i+1]), 80+100*i, 270+60);
      }



      for (Bee sb : showcaseBees) {
        sb.showBee();
      }
      for (Guardian sg : showcaseGuardians) {
        sg.showGuardian();
      }
    } else if (tutorialMinorStep == TutorialStatus.InsideMarket+0.3) {
      fill(54, 27, 0);
      strokeWeight(12);
      stroke(251, 200, 55);
      rect(50, 50, 300, 150, 20, 0, 20, 0);

      if (beehiveTier > 0) tutorialPass = true;

      fill(255);
      if (tutorialPass) {
        text("You now have a larger beehive!", 200, 50+75+6-30);
        text("The number of bees", 200, 50+75+6-10);
        text("you can now own is updated", 200, 50+75+6+10);
        text("in the top bar too.", 200, 50+75+6+30);
        nextPrompt.Draw();
      } else {
        text("Your beehive has a capacity too.", 200, 50+75+6-50);
        text("Once you do own 5 bees,", 200, 50+75+6-30);
        text("you cannot purchase more bees", 200, 50+75+6-10);
        text("unless you upgrade the beehive", 200, 50+75+6+10);
        text("to a larger one.", 200, 50+75+6+30);
        text("Try to buy a larger beehive!", 200, 50+75+6+50);
      }
      lineFont = createFont("Lucida Sans Regular", 16);
      textFont(lineFont);


      textSize(12);
      if (ERRORnotEnoughMoney) {
        fill(0);
        textAlign(LEFT);
        text("You don't have enough money!", 50, height-50);
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
    } else if (tutorialMinorStep == TutorialStatus.InsideMarket+0.4) {
      fill(54, 27, 0);
      strokeWeight(12);
      stroke(251, 200, 55);
      rect(50, 50, 300, 150, 20, 0, 20, 0);

      fill(255);
      text("In addition to purchasing,", 200, 50+75+6-20);
      text("you can also sell your bees!", 200, 50+75+6);
      text("Press Bee Inventory to continue.", 200, 50+75+6+20);

      lineFont = createFont("Lucida Sans Regular", 16);
      textFont(lineFont);


      textSize(12);
      if (ERRORnotEnoughMoney) {
        fill(0);
        textAlign(LEFT);
        text("You don't have enough money!", 50, height-50);
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

      buyMarketBtn.updateGreyOut(true);
      buyMarketBtn.Draw();
      //sellMarketBtn.updateGreyOut(false);
      //sellMarketBtn.Draw();
      inventoryBtn.get(0).Draw();

      if (tutorialRequirements[9] == false) {
        inventoryBtn.get(0).updateMouseIsOver(true);
        if (gameMillis - tutorialTimerA > 300) {
          tutorialTimerA = (int)gameMillis;
          tutorialTimerB = (int)gameMillis;
          tutorialRequirements[9] = true;
        }
      } else {
        inventoryBtn.get(0).updateMouseIsOver(false);
        if (gameMillis - tutorialTimerB > 300) {
          tutorialTimerA = (int)gameMillis;
          tutorialTimerB = (int)gameMillis;
          tutorialRequirements[9] = false;
        }
      }
    } 
    //else if (tutorialMinorStep == TutorialStatus.InsideMarket+0.5) {
    //  //next stage
    //}
  }
  if (status == TutorialStatus.InsideBeeInv) {
    beeInventoryActive();
    inventoryBtn.get(0).updateGreyOut(true);
    inventoryBtn.get(invBtn).Draw();
    fill(0);
    textAlign(LEFT);
    textSize(12);
    text("Tutorial: Section " + tutorialMinorStep, 20, height-20);

    if (tutorialMinorStep == TutorialStatus.InsideBeeInv) {    
      invTabLeft.updateGreyOut(true);
      invTabRight.updateGreyOut(true);

      fill(54, 27, 0);
      strokeWeight(12);
      stroke(251, 200, 55);
      rect(50, height-220, 300, 150, 20, 0, 20, 0);

      if (beeInvSelected != -1) tutorialMinorStep += 0.1;

      tipboxFontFormat();
      text("You can view your indivual bees", 200, height-220+75+6-20);
      text("and their attributes here.", 200, height-220+75+6);
      text("Try to select a bee.", 200, height-220+75+6+20);

      PFont lineFont = createFont("Lucida Sans Regular", 16);
      textFont(lineFont);
    } else if (tutorialMinorStep == TutorialStatus.InsideBeeInv+0.1) {
      invTabLeft.updateGreyOut(true);
      invTabRight.updateGreyOut(true);

      fill(54, 27, 0);
      strokeWeight(12);
      stroke(251, 200, 55);
      if (tutorialPass) rect(50, height-220, 300, 150, 20, 0, 20, 0);
      else rect(width*0.51, 150, 300, 150, 20, 0, 20, 0);

      tutorialPass = true;
      for (Bee b : bees) {
        if (b.getBeeName().equals("Lovee")) tutorialPass = false;
      }
      if (bees.size() < 5 && tutorialPass == false) tutorialFailed = true;

      tipboxFontFormat();
      if (tutorialFailed) {
        fill(255, 200, 200);
        text("That was not Lovee!", width*0.51+150, 150+75+6-10);
        text("Please retry.", width*0.51+150, 150+75+6+10);
        retryTutorial.Draw();
      } else if (tutorialPass) {
        text("Good job! You can make use of", 50+150, height-220+75+6-20);
        text("these stats to", 50+150, height-220+75+6);
        text("make strategic moves.", 50+150, height-220+75+6+20);
        nextPrompt.Draw();
      } else {
        text("In addition, you can see", width*0.51+150, 150+75+6-20);
        text("its location on the minimap.", width*0.51+150, 150+75+6);
        text("Try to sell the bee Lovee.", width*0.51+150, 150+75+6+20);
      }

      PFont lineFont = createFont("Lucida Sans Regular", 16);
      textFont(lineFont);
    } else if (tutorialMinorStep == TutorialStatus.InsideBeeInv+0.2) {
      invTabLeft.updateGreyOut(false);
      invTabRight.updateGreyOut(false);
      invTabLeft.Draw();
      invTabRight.Draw();

      fill(54, 27, 0);
      strokeWeight(12);
      stroke(251, 200, 55);
      rect(50, height-220, 300, 150, 20, 0, 20, 0);

      tipboxFontFormat();
      text("Other than bees, you can also", 50+150, height-220+75+6-40);
      text("view guardians and items", 50+150, height-220+75+6-20);
      text("in their own inventories.", 50+150, height-220+75+6);
      text("Navigate using the arrow buttons", 50+150, height-220+75+6+20);
      text("and enter the guardian inventory.", 50+150, height-220+75+6+40);
      PFont lineFont = createFont("Lucida Sans Regular", 16);
      textFont(lineFont);

      if (invBtn == 1) {
        if (tutorialRequirements[9] == false) {
          inventoryBtn.get(1).updateMouseIsOver(true);
          if (gameMillis - tutorialTimerA > 300) {
            tutorialTimerA = (int)gameMillis;
            tutorialTimerB = (int)gameMillis;
            tutorialRequirements[9] = true;
          }
        } else {
          inventoryBtn.get(1).updateMouseIsOver(false);
          if (gameMillis - tutorialTimerB > 300) {
            tutorialTimerA = (int)gameMillis;
            tutorialTimerB = (int)gameMillis;
            tutorialRequirements[9] = false;
          }
        }
      }
    }
    //else if (tutorialMinorStep == TutorialStatus.InsideBeeInv+0.3) {
    //  resetButtonPos();
    //  honeyFlucBtn.Draw();

    //  if (tutorialRequirements[9] == false) {
    //    honeyFlucBtn.updateMouseIsOver(true);
    //    if (gameMillis - tutorialTimerA > 300) {
    //      tutorialTimerA = (int)gameMillis;
    //      tutorialTimerB = (int)gameMillis;
    //      tutorialRequirements[9] = true;
    //    }
    //  } else {
    //    honeyFlucBtn.updateMouseIsOver(false);
    //    if (gameMillis - tutorialTimerB > 300) {
    //      tutorialTimerA = (int)gameMillis;
    //      tutorialTimerB = (int)gameMillis;
    //      tutorialRequirements[9] = false;
    //    }
    //  }
    //}
  }
  if (status == TutorialStatus.InsideGuardInv) {
    guardianInventoryActive();
    inventoryBtn.get(1).updateGreyOut(true);
    inventoryBtn.get(invBtn).Draw();

    fill(0);
    textAlign(LEFT);
    textSize(12);
    text("Tutorial: Section " + tutorialMinorStep, 20, height-20);
    if (tutorialMinorStep == TutorialStatus.InsideGuardInv) {
      fill(54, 27, 0);
      strokeWeight(12);
      stroke(251, 200, 55);
      rect(width*0.36, 100, 300, 150, 20, 0, 20, 0);

      tipboxFontFormat();
      if (tutorialRequirements[0]) {
        text("Press Honey Fluc. Graph", width*0.36+150, 100+75+6-10);
        text("to continue.", width*0.36+150, 100+75+6+10);

        invTabLeft.Draw();
        invTabRight.Draw();

        resetButtonPos();
        honeyFlucBtn.Draw();

        if (tutorialRequirements[9] == false) {
          honeyFlucBtn.updateMouseIsOver(true);
          if (gameMillis - tutorialTimerA > 300) {
            tutorialTimerA = (int)gameMillis;
            tutorialTimerB = (int)gameMillis;
            tutorialRequirements[9] = true;
          }
        } else {
          honeyFlucBtn.updateMouseIsOver(false);
          if (gameMillis - tutorialTimerB > 300) {
            tutorialTimerA = (int)gameMillis;
            tutorialTimerB = (int)gameMillis;
            tutorialRequirements[9] = false;
          }
        }
      } else {
        text("Your guardian stats are", width*0.36+150, 100+75+6-40);
        text("visible here.", width*0.36+150, 100+75+6-20);
        text("However, you don't own", width*0.36+150, 100+75+6);
        text("a guardian right now.", width*0.36+150, 100+75+6+20);
        text("So let's just move on!", width*0.36+150, 100+75+6+40);
        nextPrompt.Draw();
      }
    }
  }
  if (status == TutorialStatus.Graph) {
    if (tutorialMinorStep == TutorialStatus.Graph) {
      if (tutorialTimerA < 25) tutorialTimerA += (timeMillis-pMillis);

      resetButtonPos();

      sellAllHoneyBtn.updateSize(120, 40);
      sellAllHoneyBtn.Draw();
      if (honeyKg < 10 || tutorialTimerA < 25) sell10kg.updateGreyOut(true);
      else sell10kg.updateGreyOut(false);
      sell10kg.Draw();
      if (honeyKg < 100) sell100kg.updateGreyOut(true);
      else sell100kg.updateGreyOut(false);
      sell100kg.Draw();

      sell1000kg.updateGreyOut(true);
      sell1000kg.Draw();

      honeyPriceGraph();


      if (honeyKg == 25) tutorialPass = true;
      else if (honeyKg < 25) tutorialFailed = true;

      fill(54, 27, 0);
      strokeWeight(12);
      stroke(251, 200, 55);
      rect(80, 60, 300, 150, 20, 0, 20, 0);
      fill(255);
      textAlign(CENTER);
      PFont lineFont = createFont("Lucida Sans Demibold", 16);
      textFont(lineFont);

      if (tutorialPass && honeyKg != 25) {
        text("Huh. So you want more money.", 230, 60+75+6-20);
        text("It's okay!", 230, 60+75+6);
        text("I can respect that... :)", 230, 60+75+6+20);
        nextPrompt.Draw();
      } else if (tutorialPass) {
        text("Good job!", 230, 60+75+6);
        nextPrompt.Draw();
      } else if (tutorialFailed) {
        fill(255, 200, 200);
        text("Sell only 100kg of your honey!", 230, 60+75+6-10);
        text("Please retry.", 230, 60+75+6+10);
        retryTutorial.Draw();
      } else {
        text("The previous changes to the", 230, 60+75+6-40);
        text("honey price are recorded here.", 230, 60+75+6-20);
        text("It is also possible to sell", 230, 60+75+6);
        text("some of the honey you have here!", 230, 60+75+6+20);
        text("Try to sell 100kg of your honey!", 230, 60+75+6+40);
      }
      lineFont = createFont("Lucida Sans Regular", 16);
      textFont(lineFont);
    } else if (tutorialMinorStep == TutorialStatus.Graph+0.1) {
      resetButtonPos();

      showForestBtn.Draw();

      sellAllHoneyBtn.updateSize(120, 40);
      sellAllHoneyBtn.Draw();
      if (honeyKg < 10) sell10kg.updateGreyOut(true);
      else sell10kg.updateGreyOut(false);
      sell10kg.Draw();
      if (honeyKg < 100) sell100kg.updateGreyOut(true);
      else sell100kg.updateGreyOut(false);
      sell100kg.Draw();

      sell1000kg.updateGreyOut(true);
      sell1000kg.Draw();

      honeyPriceGraph();



      fill(54, 27, 0);
      strokeWeight(12);
      stroke(251, 200, 55);
      rect(80, 60, 300, 150, 20, 0, 20, 0);
      fill(255);
      textAlign(CENTER);
      PFont lineFont = createFont("Lucida Sans Demibold", 16);
      textFont(lineFont);

      text("Press Forest to", 230, 60+75+6-10);
      text("continue the tutorial.", 230, 60+75+6+10);

      lineFont = createFont("Lucida Sans Regular", 16);
      textFont(lineFont);
    }
  }
  if (status == TutorialStatus.EnemyHornet) {
    roundTime = gameMillis;

    drawCenterBeehive();
    bottomStatsBar();
    if (tutorialMinorStep == TutorialStatus.EnemyHornet) {
      fill(54, 27, 0);
      strokeWeight(12);
      stroke(251, 200, 55);
      rect(50, 50, 300, 150, 20, 0, 20, 0);
      fill(255);
      textAlign(CENTER);
      PFont lineFont = createFont("Lucida Sans Demibold", 16);
      textFont(lineFont);

      if (bees.get(0).getIsAlive() == false) tutorialPass = true;

      if (tutorialPass) {
        text("Your bee just got killed.", 200, 50+75+6-10);
        text("Tragic.", 200, 50+75+6+10);
        nextPrompt.Draw();
      } else {
        text("This is a hornet.", 200, 50+75+6-10);
        text("Beware of it killing your bees!", 200, 50+75+6+10);
      }
      lineFont = createFont("Lucida Sans Regular", 16);
      textFont(lineFont);



      for (Bee b : bees) {
        b.showBee();
        b.move();
      }
      for (Hornet h : hornets) {
        h.showHornet();
        h.move();
      }

      strokeWeight(1.5);
      stroke(75, 0, 0);
      fill(255, 0, 0);
      PVector hPos = hornets.get(0).getLocation();
      float hx = hPos.x, hy = hPos.y;
      beginShape();
      vertex(hx, hy+10);
      vertex(hx+8, hy+18);
      vertex(hx+5, hy+18);
      vertex(hx+5, hy+30);
      vertex(hx, hy+25);
      vertex(hx-5, hy+30);
      vertex(hx-5, hy+18);
      vertex(hx-8, hy+18);
      vertex(hx, hy+10);
      endShape();
    } else if (tutorialMinorStep == TutorialStatus.EnemyHornet+0.1) {
      fill(54, 27, 0);
      strokeWeight(12);
      stroke(251, 200, 55);
      rect(50, 50, 300, 150, 20, 0, 20, 0);
      fill(255);
      textAlign(CENTER);
      PFont lineFont = createFont("Lucida Sans Demibold", 16);
      textFont(lineFont);

      int isAlives = 0;
      for (Bee b : bees) {
        if (b.getIsAlive()) isAlives++;
      }
      if (isAlives == 1) tutorialPass = true;

      if (tutorialPass) {
        text("Hornets that have just killed", 200, 50+75+6-50);
        text("a bee will experience the", 200, 50+75+6-30);
        text("effect " + char(34) + "Kill Fatigue" + char(34) + ". They will not", 200, 50+75+6-10);
        text("be able to kill your bees", 200, 50+75+6+10);
        text("in the following few seconds", 200, 50+75+6+30);
        text("and they will move slower.", 200, 50+75+6+50);
        nextPrompt.Draw();
      } else {
        text("Here is another hornet.", 200, 50+75+6-10);
        text("Beware of it killing your bees!", 200, 50+75+6+10);
      }
      lineFont = createFont("Lucida Sans Regular", 16);
      textFont(lineFont);



      for (Bee b : bees) {
        b.showBee();
        b.move();
      }
      for (Hornet h : hornets) {
        h.showHornet();
        h.move();
      }
    } else if (tutorialMinorStep == TutorialStatus.EnemyHornet+0.2) {
      fill(54, 27, 0);
      strokeWeight(12);
      stroke(251, 200, 55);
      rect(50, 50, 300, 150, 20, 0, 20, 0);
      fill(255);
      textAlign(CENTER);
      PFont lineFont = createFont("Lucida Sans Demibold", 16);
      textFont(lineFont);

      tutorialPass = true;

      text("This is a guardian.", 200, 50+75+6-30);
      text("If a hornet is within this", 200, 50+75+6-10);
      text("guardian's range, it will catch", 200, 50+75+6+10);
      text("and kill the hornet.", 200, 50+75+6+30);
      nextPrompt.Draw();

      lineFont = createFont("Lucida Sans Regular", 16);
      textFont(lineFont);



      for (Bee b : bees) {
        b.showBee();
        b.move();
      }
      for (Guardian g : guardians) {
        g.showGuardian();
        g.move();
      }
      strokeWeight(1.5);
      stroke(0, 15, 50);
      fill(185, 190, 255);
      PVector gPos = guardians.get(0).getLocation();
      float gx = gPos.x, gy = gPos.y;
      pushMatrix();
      translate(gx, gy);
      rotate(radians(guardians.get(0).getAngleOffset()));
      beginShape();
      vertex(0, 15);
      vertex(6, 21);
      vertex(6, 32);
      vertex(0, 26);
      vertex(-6, 32);
      vertex(-6, 21);
      vertex(0, 15);
      endShape();
      popMatrix();
    } else if (tutorialMinorStep == TutorialStatus.EnemyHornet+0.3) {
      fill(54, 27, 0);
      strokeWeight(12);
      stroke(251, 200, 55);
      rect(50, 50, 300, 150, 20, 0, 20, 0);
      fill(255);
      textAlign(CENTER);
      PFont lineFont = createFont("Lucida Sans Demibold", 16);
      textFont(lineFont);

      int isAlives = 0;
      for (Bee b : bees) {
        if (b.getIsAlive()) isAlives++;
      }
      if (hornets.size() == 0 && isAlives > 0) tutorialPass = true;
      if (isAlives == 0) tutorialFailed = true;

      if (tutorialFailed) {
        fill(255, 200, 200);
        text("Ouch! Your bee died :(", 200, 50+75+6-20);
        text("Try to catch the hornet", 200, 50+75+6);
        text("before it kills your bee!", 200, 50+75+6+20);
        retryTutorial.Draw();
      } else if (tutorialPass) {
        text("Nice work!", 200, 50+75+6);
        nextPrompt.Draw();
      } else {
        text("Now try to catch the hornet", 200, 50+75+6-20);
        text("with this guardian before", 200, 50+75+6);
        text("the hornet kills your only bee!", 200, 50+75+6+20);
      }

      lineFont = createFont("Lucida Sans Regular", 16);
      textFont(lineFont);



      for (Bee b : bees) {
        b.showBee();
        b.move();
      }
      for (Guardian g : guardians) {
        g.showGuardian();
        g.move();
      }
      for (Hornet h : hornets) {
        h.showHornet();
        h.move();
      }
    }
  }
  if (status == TutorialStatus.EnemyFirefly) {
    //roundTime = gameMillis; //this one is special because it contains a shop interface too

    if (tutorialMinorStep == TutorialStatus.EnemyFirefly) {
      roundTime = gameMillis;

      drawCenterBeehive();
      bottomStatsBar();

      fill(54, 27, 0);
      strokeWeight(12);
      stroke(251, 200, 55);
      rect(50, 50, 300, 150, 20, 0, 20, 0);
      fill(255);
      textAlign(CENTER);
      PFont lineFont = createFont("Lucida Sans Demibold", 16);
      textFont(lineFont);

      int isAlives = 0;
      for (Bee b : bees) {
        if (b.getIsAlive()) isAlives++;
      }
      if (isAlives == 0) tutorialRequirements[0] = true;

      if (tutorialRequirements[1]) {
        text("Similar to hornets, fireflies also", 200, 50+75+6-50);
        text("experience " + char(34) + "Kill Fatigue" + char(34) + ".", 200, 50+75+6-30);
        text("However, fireflies do not exit", 200, 50+75+6-10);
        text("the forest once all of the", 200, 50+75+6+10);
        text("bees are dead. They stay in the", 200, 50+75+6+30);
        text("forest until a guardian kills them.", 200, 50+75+6+50);
        nextPrompt.Draw();
      } else {
        text("These two guardians are", 200, 50+75+6-40);
        text("guardian and super guardian.", 200, 50+75+6-20);
        text("They can be purchased from the", 200, 50+75+6);
        text("market directly, but they can't", 200, 50+75+6+20);
        text("catch the firefly.", 200, 50+75+6+40);
        if (tutorialRequirements[0]) nextPrompt.Draw();
      }
      lineFont = createFont("Lucida Sans Regular", 16);
      textFont(lineFont);

      for (Bee b : bees) {
        b.showBee();
        b.move();
      }
      for (Guardian g : guardians) {
        g.showGuardian();
        g.move();
      }
      for (Firefly ff : fireflies) {
        ff.showFirefly();
        ff.move();
      }
    } else if (tutorialMinorStep == TutorialStatus.EnemyFirefly+0.1) {
      roundTime = gameMillis;

      drawCenterBeehive();
      bottomStatsBar();

      if (tutorialRequirements[9] == false) {
        showMarketBtn.updateMouseIsOver(true);
        if (gameMillis - tutorialTimerA > 300) {
          tutorialTimerA = (int)gameMillis;
          tutorialTimerB = (int)gameMillis;
          tutorialRequirements[9] = true;
        }
      } else {
        showMarketBtn.updateMouseIsOver(false);
        if (gameMillis - tutorialTimerB > 300) {
          tutorialTimerA = (int)gameMillis;
          tutorialTimerB = (int)gameMillis;
          tutorialRequirements[9] = false;
        }
      }

      fill(54, 27, 0);
      strokeWeight(12);
      stroke(251, 200, 55);
      rect(50, 50, 300, 150, 20, 0, 20, 0);
      fill(255);
      textAlign(CENTER);
      PFont lineFont = createFont("Lucida Sans Demibold", 16);
      textFont(lineFont);

      text("Although the Guardian and", 200, 50+75+6-40);
      text("the Super Guardian cannot catch", 200, 50+75+6-20);
      text("the firefly, there are guardians", 200, 50+75+6);
      text("that can catch the fireflies!", 200, 50+75+6+20);
      text("Press Market to find out.", 200, 50+75+6+40);

      lineFont = createFont("Lucida Sans Regular", 16);
      textFont(lineFont);

      for (Bee b : bees) {
        b.showBee();
        b.move();
      }
      for (Guardian g : guardians) {
        g.showGuardian();
        g.move();
      }
      for (Firefly ff : fireflies) {
        ff.showFirefly();
        ff.move();
      }
    } else if (tutorialMinorStep == TutorialStatus.EnemyFirefly+0.2) {
      fill(54, 27, 0);
      strokeWeight(12);
      stroke(251, 200, 55);
      rect(50, 50, 300, 150, 20, 0, 20, 0);
      fill(255);
      textAlign(CENTER);
      PFont lineFont = createFont("Lucida Sans Demibold", 16);
      textFont(lineFont);

      fill(255);
      text("Press G. Training.", 200, 50+75+6-20);
      text("(Which stands for", 200, 50+75+6);
      text("Guardian Training)", 200, 50+75+6+20);

      lineFont = createFont("Lucida Sans Regular", 16);
      textFont(lineFont);


      textSize(12);

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

      buyMarketBtn.updateGreyOut(true);
      buyMarketBtn.Draw();
      invTabLeft.Draw();
      invTabRight.Draw();
      inventoryBtn.get(invBtn).Draw();

      GTMarketBtn.updateGreyOut(false);
      GTMarketBtn.Draw();
      if (tutorialRequirements[9] == false) {
        GTMarketBtn.updateMouseIsOver(true);
        if (gameMillis - tutorialTimerA > 300) {
          tutorialTimerA = (int)gameMillis;
          tutorialTimerB = (int)gameMillis;
          tutorialRequirements[9] = true;
        }
      } else {
        GTMarketBtn.updateMouseIsOver(false);
        if (gameMillis - tutorialTimerB > 300) {
          tutorialTimerA = (int)gameMillis;
          tutorialTimerB = (int)gameMillis;
          tutorialRequirements[9] = false;
        }
      }
    }
  }
  if (status == TutorialStatus.GTraining) {
    if (tutorialMinorStep == TutorialStatus.GTraining) {
      noStroke();
      fill(180);
      rect(220, 70, width/2, height/1.75, 10);
      fill(255);
      textSize(12);
      textAlign(RIGHT);
      text("Demonstration", width/2+200, 100);

      resetButtonPos();

      buyMarketBtn.updateGreyOut(false);
      buyMarketBtn.Draw();
      invTabLeft.Draw();
      invTabRight.Draw();
      inventoryBtn.get(invBtn).Draw();
      GTMarketBtn.updateGreyOut(true);
      GTMarketBtn.Draw();

      for (Button btn : upgradeGuardian) {
        if (GTPurchased || GTOngoing) btn.updateGreyOut(true);
        else btn.updateGreyOut(false);
        btn.Draw();
      }



      fill(54, 27, 0);
      strokeWeight(12);
      stroke(251, 200, 55);
      rect(270, 165, 300, 150, 20, 0, 20, 0);
      tipboxFontFormat();

      if (tutorialRequirements[1]) {
        tutorialPass = true;
        text("Training courses will", 420, 165+75+6-20);
        text("only begin after your", 420, 165+75+6);
        text("current week is over.", 420, 165+75+6+20);
      } else if (tutorialRequirements[0]) {
        text("These guardians can only", 420, 165+75+6-40);
        text("be obtained after completing", 420, 165+75+6-20);
        text("a training course,", 420, 165+75+6);
        text("and only Super Guardians", 420, 165+75+6+20);
        text("can be sent to training.", 420, 165+75+6+40);
      } else {
        text("So here is the solution.", 420, 165+75+6-20);
        text("All of the guardians here can", 420, 165+75+6);
        text("catch the firefly.", 420, 165+75+6+20);
      }
      nextPrompt.Draw();

      PFont lineFont = createFont("Lucida Sans Regular", 16);
      textFont(lineFont);
    } else if (tutorialMinorStep == TutorialStatus.GTraining+0.1) {
      noStroke();
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
        GTPurchase.Draw();
      }
      resetButtonPos();

      buyMarketBtn.updateGreyOut(false);
      buyMarketBtn.Draw();
      invTabLeft.Draw();
      invTabRight.Draw();
      inventoryBtn.get(invBtn).Draw();
      GTMarketBtn.updateGreyOut(true);
      GTMarketBtn.Draw();

      for (Button btn : upgradeGuardian) {
        if (GTPurchased || GTOngoing) btn.updateGreyOut(true);
        else btn.updateGreyOut(false);
        btn.Draw();
      }



      fill(54, 27, 0);
      strokeWeight(12);
      stroke(251, 200, 55);
      rect(270, 165, 300, 150, 20, 0, 20, 0);
      fill(255);
      textAlign(CENTER);
      PFont lineFont = createFont("Lucida Sans Demibold", 16);
      textFont(lineFont);

      if (tutorialRequirements[1]) {
        tutorialPass = true;
        text("There is also a training", 420, 165+75+6-20);
        text("store for bees!", 420, 165+75+6);
        text("Press Bee Training to continue.", 420, 165+75+6+20);

        if (tutorialRequirements[9] == false) {
          BTMarketBtn.updateMouseIsOver(true);
          if (gameMillis - tutorialTimerA > 300) {
            tutorialTimerA = (int)gameMillis;
            tutorialTimerB = (int)gameMillis;
            tutorialRequirements[9] = true;
          }
        } else {
          BTMarketBtn.updateMouseIsOver(false);
          if (gameMillis - tutorialTimerB > 300) {
            tutorialTimerA = (int)gameMillis;
            tutorialTimerB = (int)gameMillis;
            tutorialRequirements[9] = false;
          }
        }

        BTMarketBtn.Draw();
      } else if (tutorialRequirements[0]) {
        text("As for the tutorials", 420, 165+75+6-40);
        text("of each training course,", 420, 165+75+6-20);
        text("it will be demonstrated", 420, 165+75+6);
        text("once you click on the", 420, 165+75+6+20);
        text("guardian names while in-game!", 420, 165+75+6+40);
        nextPrompt.Draw();
      } else {
        text("Additionally, each of these", 420, 165+75+6-40);
        text("guardians has its speciality!", 420, 165+75+6-20);
        text("You can hover on their", 420, 165+75+6);
        text("names for more details.", 420, 165+75+6+20);
        text("(Available in game too)", 420, 165+75+6+40);
        nextPrompt.Draw();
      }


      lineFont = createFont("Lucida Sans Regular", 16);
      textFont(lineFont);



      for (int _btn = upgradeGuardian.size()-1; _btn >= 0; _btn--) {
        Button btn = upgradeGuardian.get(_btn);
        if (btn.getMouseIsOver()) {
          drawPopupWindow(upgradedGuardianDescription[_btn], 0, 12, mouseX, mouseY, true, 0, width);
        }
      }
    }
  }
  if (status == TutorialStatus.BTraining) {
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
      int availableResourceTypes = -1;
      if (BTSelected == 0 || BTSelected == 2) availableResourceTypes = 4; //if it's priest / gardening, 4 types are available
      else availableResourceTypes = 3; //if it's undead / rush, 3 types are available

      //Resource bar on right
      for (int i = 0; i < availableResourceTypes; i++) {
        if (i + BTSelected*4 == 0) image(resourceImageGray[i + BTSelected*4], width/2+230, 135 + i*60, 40, 40);
        else {
          fill(255, 0, 0);
          text(resourceName[i + BTSelected*4], width/2+230, 135 + i*60);
        }
      }

      fill(255);
      textAlign(RIGHT);
      text("Demonstration - " + upgradedBeeName[BTSelected], width/2+200, 100);

      if (money < upgradeBeeCost[BTSelected] || BTPurchased || BTOngoing || ((BTSelected == 1 || BTSelected == 3) && beesCount == beehiveSize[beehiveTier])) BTPurchase.updateGreyOut(true);
      else BTPurchase.updateGreyOut(false);
      BTPurchase.updateLabel("Purchase for $" + nfc(int(upgradeBeeCost[BTSelected])));
      BTPurchase.Draw();

      //in tutorial, the player wont have enough materials anyway (no way to earn)
      fill(255, 50, 50);
      textSize(12);
      textAlign(LEFT);
      text("You don't have enough materials!", 40, height-125);
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
    for (Button btn : upgradeBee) {
      if (BTPurchased || BTOngoing) btn.updateGreyOut(true);
      else btn.updateGreyOut(false);
      btn.Draw();
    }

    

    fill(54, 27, 0);
    strokeWeight(12);
    stroke(251, 200, 55);
    rect(270, 165, 300, 150, 20, 0, 20, 0);
    tipboxFontFormat();

    if (tutorialRequirements[2]) {
      tutorialPass = true;
      text("Resources spawn randomly", 420, 165+75+6-50);
      text("in forests, allowing bees", 420, 165+75+6-30);
      text("to pick them up.", 420, 165+75+6-10);
      text("One special case is Bee Guts,", 420, 165+75+6+10);
      text("which has a chance to drop", 420, 165+75+6+30);
      text("upon selling a dead bee.", 420, 165+75+6+50);
    } else if (tutorialRequirements[1]) {
      text("However, each of them", 420, 165+75+6-40);
      text("requires different Resources,", 420, 165+75+6-20);
      text("which is shown on the right.", 420, 165+75+6);
      text("Resources are stored in", 420, 165+75+6+20);
      text("Item Inventory.", 420, 165+75+6+40);
    } else if (tutorialRequirements[0]) {
      text("Some of them require finishing", 420, 165+75+6-20);
      text("a training course,", 420, 165+75+6);
      text("while some do not.", 420, 165+75+6+20);
    } else {
      text("It is possible to obtain", 420, 165+75+6-20);
      text("special bees with powerful", 420, 165+75+6);
      text("abilities.", 420, 165+75+6+20);
    }
    nextPrompt.Draw();

    PFont lineFont = createFont("Lucida Sans Regular", 16);
    textFont(lineFont);
    
    for (int _btn = upgradeBee.size()-1; _btn >= 0; _btn--) {
      Button btn = upgradeBee.get(_btn);
      if (btn.getMouseIsOver()) {
        drawPopupWindow(upgradedBeeDescription[_btn], 0, 12, mouseX, mouseY, true, 0, width);
      }
    }
  }
  if (status == TutorialStatus.EndTutorial) {
    roundTime = gameMillis;

    bottomStatsBar();

    fill(54, 27, 0);
    strokeWeight(12);
    stroke(251, 200, 55);
    rect(width/2-150, height/2-75, 300, 150, 20, 0, 20, 0);
    fill(255);
    textAlign(CENTER);
    PFont lineFont = createFont("Lucida Sans Demibold", 16);
    textFont(lineFont);

    text("The tutorial ends here!", width/2, height/2+6-20);
    text("Press NEXT to return", width/2, height/2+6);
    text("to the menu.", width/2, height/2+6+20);
    nextPrompt.Draw();

    lineFont = createFont("Lucida Sans Regular", 16);
    textFont(lineFont);
  }
}

void tutorialClickEvents() {
  // need to determine the tutorialMinorStep before adding 0.1.
  if (status == TutorialStatus.BeeSingleMovement) {
    if (tutorialMinorStep == TutorialStatus.BeeSingleMovement && nextPrompt.MouseClicked()) {  
      flowers = new ArrayList<Flower>();
      bees = new ArrayList<Bee>();

      flowers.add(new Flower(width/2+200, height/2+150, 1, 3));
      bees.add(new Bee(0));
    } else if (tutorialMinorStep == TutorialStatus.BeeSingleMovement+0.1) {
      selectionMechanic();
    }
  }
  if (status == TutorialStatus.BeeMultipleMovement) {
    if (tutorialMinorStep == TutorialStatus.BeeMultipleMovement) {
      selectionMechanic();

      if (nextPrompt.MouseClicked() && tutorialPass) {
        flowers = new ArrayList<Flower>();
        bees = new ArrayList<Bee>();

        for (int i = 0; i < 3; i++) bees.add(new Bee(0));
      }
    } else if (tutorialMinorStep == TutorialStatus.BeeMultipleMovement+0.1) {
      selectionMechanic();

      if (nextPrompt.MouseClicked() && tutorialPass) {
        flowers = new ArrayList<Flower>();
        bees = new ArrayList<Bee>();

        flowers.add(new Flower(width/2+200, height/2+150, 10, 15));
        for (int i = 0; i < 3; i++) bees.add(new Bee(0));
      }
    } else if (tutorialMinorStep == TutorialStatus.BeeMultipleMovement+0.2) {
      selectionMechanic();

      if (retryTutorial.MouseClicked() && tutorialFailed && tutorialPass == false) {
        tutorialRequirements[0] = false;
        tutorialFailed = false;

        flowers = new ArrayList<Flower>();
        bees = new ArrayList<Bee>();

        flowers.add(new Flower(width/2+200, height/2+150, 10, 15));
        for (int i = 0; i < 3; i++) bees.add(new Bee(0));
      }
    }
  }
  if (status == TutorialStatus.Beehive) {
    if (tutorialMinorStep == TutorialStatus.Beehive) {
      selectionMechanic();

      if (nextPrompt.MouseClicked() && tutorialPass) {
        bees = new ArrayList<Bee>();
        flowers = new ArrayList<Flower>();

        for (int i = 0; i < 3; i++) {
          bees.add(new Bee(0));
          bees.get(i).updateHoneyCap(2000);
          bees.get(i).updateLocation(width/2+100, height/2+100);
        }
        moveAllBees();
      }
    } else if (tutorialMinorStep == TutorialStatus.Beehive+0.1) {
      selectionMechanic();

      if (retryTutorial.MouseClicked() && tutorialFailed && tutorialPass == false) {
        tutorialRequirements[0] = false;
        tutorialFailed = false;

        bees = new ArrayList<Bee>();

        for (int i = 0; i < 3; i++) {
          bees.add(new Bee(0));
          bees.get(i).updateHoneyCap(2000);
          bees.get(i).updateLocation(width/2+100, height/2+100);
        }
      }
    }
  }
  if (status == TutorialStatus.TopStatsBar) {
    selectionMechanic();
    if (tutorialMinorStep >= TutorialStatus.TopStatsBar+0.3 && nextPrompt.MouseClicked()) {
      gameMillis = 0;
      tutorialTimerA = 0;
      tutorialTimerB = 0;

      flowers = new ArrayList<Flower>();
      flowers.add(new Flower(width/2+200, height/2+150, 10, 15));
    }
  }
  if (status == TutorialStatus.BottomButtonsBar) {
    selectionMechanic();
    if (honeyFlucBtn.MouseClicked()) {
      tutorialRequirements[8] = true;
    }
    if (showMarketBtn.MouseClicked()) {
      //next stage
      money = 300;
      status = TutorialStatus.InsideMarket;
      tutorialMinorStep = status;

      tutorialPass = false;
      tutorialFailed = false;

      flowers = new ArrayList<Flower>();
      bees = new ArrayList<Bee>();

      for (int i = 0; i < 4; i++) bees.add(new Bee(0));

      nextPrompt.updateXY(width-250, height-50);
    }
  }
  if (status == TutorialStatus.InsideMarket) {
    if (tutorialMinorStep == TutorialStatus.InsideMarket) {
      for (int i = 0; i < beeName.length; i++) {
        if (buyBee.get(i).MouseClicked()) buyBee(i);
      }
    }
    if (tutorialMinorStep >= TutorialStatus.InsideMarket+0.2) {
      for (int i = 0; i < honeyPotPrice.length-1; i++) {
        if (buyPot.get(i).MouseClicked()) buyPot(i+1);
      }
    }
    if (tutorialMinorStep == TutorialStatus.InsideMarket+0.3) {
      for (int i = 0; i < beehivePrice.length-1; i++) {
        if (buyHive.get(i).MouseClicked()) buyHive(i+1);
      }
    }

    if (tutorialMinorStep == TutorialStatus.InsideMarket+0.4) {
      if (inventoryBtn.get(0).MouseClicked()) {
        status = TutorialStatus.InsideBeeInv;
        tutorialMinorStep = status;
        tutorialPass = false;

        //add minimap bees!!!
        float blockSize = (650 - 10*2 - 10*5)/5;
        bees.clear();
        inventoryBees.clear();
        for (int i = 0; i < 5; i++) {
          bees.add(new Bee(i));
          bees.get(i).updateLocation(width/3 + random(300), height/3 + random(200));
          inventoryBees.add(new Bee(i));
          inventoryBees.get(inventoryBees.size()-1).updateMoveTheta(HALF_PI);
          inventoryBees.get(inventoryBees.size()-1).updateForShop(true);
        }
        //for (Bee b : bees) b.updateLocation(width/3 + random(300), height/3 + random(200));
        resetBeeInvPositions();
        updateMinimap(20 + blockSize*0.1, 70 + (blockSize+10)*2.4, (blockSize+10)*3.3 - 135);
      }
    }

    if (nextPrompt.MouseClicked() && tutorialPass) {
      if (tutorialMinorStep == TutorialStatus.InsideMarket+0.1) money = 1000;
      if (tutorialMinorStep == TutorialStatus.InsideMarket+0.2) money = 3000;
    }
  }
  if (status == TutorialStatus.InsideBeeInv) {
    int counter = 0;
    float blockSize = (650 - 10*2 - 10*5)/5;
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
          break;
        }
        counter++;
      }
    }

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

    if (invTabLeft.MouseClicked()) {
      if (invBtn > 0) invBtn--;
      else invBtn = inventoryBtn.size()-1;
    } else if (invTabRight.MouseClicked()) {
      if (invBtn < inventoryBtn.size()-1) invBtn++;
      else invBtn = 0;
    }

    if (tutorialMinorStep == TutorialStatus.InsideBeeInv+0.2 && tutorialFailed == false && invBtn == 1 && inventoryBtn.get(invBtn).MouseClicked()) {
      status = TutorialStatus.InsideGuardInv;
      tutorialMinorStep = status;

      tutorialTimerA = 0;
      tutorialTimerB = 0;
      tutorialPass = false;
      tutorialFailed = false;
      inventoryBtn.get(0).updateGreyOut(false);
    }

    if (retryTutorial.MouseClicked() && tutorialFailed && tutorialPass == false) {
      tutorialPass = false;
      tutorialFailed = false;

      bees.clear();
      inventoryBees.clear();
      for (int i = 0; i < 5; i++) {
        bees.add(new Bee(i));
        bees.get(i).updateLocation(width/3 + random(300), height/3 + random(200));
        inventoryBees.add(new Bee(i));
        inventoryBees.get(inventoryBees.size()-1).updateMoveTheta(HALF_PI);
        inventoryBees.get(inventoryBees.size()-1).updateForShop(true);
      }
      //for (Bee b : bees) b.updateLocation(width/3 + random(300), height/3 + random(200));
      resetBeeInvPositions();
      updateMinimap(20 + blockSize*0.1, 70 + (blockSize+10)*2.4, (blockSize+10)*3.3 - 135);
    }
  }
  if (status == TutorialStatus.InsideGuardInv) {
    if (invTabLeft.MouseClicked()) {
      if (invBtn > 0) invBtn--;
      else invBtn = inventoryBtn.size()-1;
    } else if (invTabRight.MouseClicked()) {
      if (invBtn < inventoryBtn.size()-1) invBtn++;
      else invBtn = 0;
    }

    if (nextPrompt.MouseClicked()) {
      if (tutorialRequirements[0] == false) tutorialRequirements[0] = true;
      else if (tutorialRequirements[1] == false) tutorialRequirements[1] = true;
    }

    if (tutorialRequirements[0]) {
      if (honeyFlucBtn.MouseClicked()) {
        //next stage
        money = 0; //can no-reset money so can trigger easter egg 
        status = TutorialStatus.Graph;
        honeyKg = 125;
        tutorialMinorStep = status;
        tutorialPass = false;
        tutorialTimerA = 0;
        tutorialTimerB = 0;
        sell10kg.updateGreyOut(true);

        retryTutorial.updateXY(width-250, height-100);
      }
    }
  }
  if (status == TutorialStatus.Graph) {
    if (sell10kg.MouseClicked()) sellHoney(10);
    else if (sell100kg.MouseClicked()) sellHoney(100);
    else if (sell1000kg.MouseClicked()) sellHoney(1000);


    if (retryTutorial.MouseClicked() && tutorialFailed && tutorialPass == false) {
      tutorialPass = false;
      tutorialFailed = false;
      money -= (125-honeyKg)*honeyPrice; 
      honeyKg = 125;
    }

    if (tutorialMinorStep == TutorialStatus.Graph+0.1) {
      if (showForestBtn.MouseClicked()) {
        //next stage
        status = TutorialStatus.EnemyHornet;
        tutorialMinorStep = status;

        bees = new ArrayList<Bee>();

        bees.add(new Bee(0));
        hornets.add(new Hornet(0, false));

        nextPrompt.updateXY(width/2-75, height/2+210);
        retryTutorial.updateXY(width-160, height/2+210);
      }
    }
  }
  if (status == TutorialStatus.EnemyHornet) {
    selectionMechanic();
    if (nextPrompt.MouseClicked() && tutorialPass) {
      if (tutorialMinorStep == TutorialStatus.EnemyHornet) {
        hornets = new ArrayList<Hornet>();

        for (int i = 0; i < 2; i++) bees.add(new Bee(0));
        hornets.add(new Hornet(0, false));

        hornets.get(0).updateLocation(5, height/2);
        bees.get(0).updateLocation(35, height/2+100);
        bees.get(1).updateMoveTheta(-radians(150));

        for (Bee b : bees) {
          b.updateIsAlive(true);
          b.resetDiameter();
        }
      } else if (tutorialMinorStep == TutorialStatus.EnemyHornet+0.1) {
        hornets = new ArrayList<Hornet>();

        for (int i = bees.size()-1; i >= 0; i--) {
          Bee b = bees.get(i);
          if (b.getIsAlive() == false) bees.remove(i);
        }
        if (bees.size() == 0) bees.add(new Bee(0));
        guardians.add(new Guardian(guardianName[0]));
      } else if (tutorialMinorStep == TutorialStatus.EnemyHornet+0.2) {
        hornets.add(new Hornet(0, false));
        println("spawned hornet");
        for (Bee b : bees) {
          b.updateIsAlive(true);
          b.resetDiameter();
        }
      } else if (tutorialMinorStep == TutorialStatus.EnemyHornet+0.3) {
        //next stage
        tutorialPass = false;
        tutorialFailed = false;

        status = TutorialStatus.EnemyFirefly;
        tutorialMinorStep = status;

        hornets = new ArrayList<Hornet>();

        guardians.add(new Guardian(guardianName[1]));
        fireflies.add(new Firefly(false));
      }
    }

    if (retryTutorial.MouseClicked() && tutorialFailed && tutorialPass == false) {
      tutorialPass = false;
      tutorialFailed = false;

      hornets.clear();
      hornets.add(new Hornet(0, false));

      bees.clear();
      bees.add(new Bee(0));
    }
  }
  if (status == TutorialStatus.EnemyFirefly) {
    selectionMechanic();
    if (tutorialMinorStep == TutorialStatus.EnemyFirefly) {
      if (nextPrompt.MouseClicked() && tutorialRequirements[0]) {
        if (tutorialRequirements[1] == false) tutorialRequirements[1] = true; //first extra msg
        else {
          tutorialPass = true;
        }
      }
    } else if (tutorialMinorStep == TutorialStatus.EnemyFirefly+0.1) {
      if (showMarketBtn.MouseClicked()) {
        //supposed to go into shop. but this is tutorial and i put shop in the next minor step
        int stepHold = round(10*(tutorialMinorStep-status))+1;
        tutorialMinorStep = status+0.1*stepHold;

        tutorialPass = false;
        tutorialFailed = false;
        for (int i = 0; i < tutorialRequirements.length; i++) tutorialRequirements[i] = false;
      }
    } else if (tutorialMinorStep == TutorialStatus.EnemyFirefly+0.2) {
      if (GTMarketBtn.MouseClicked()) {
        //go into the guardian training screen. (next stage)
        status = TutorialStatus.GTraining;
        tutorialMinorStep = status;

        tutorialPass = false;
        tutorialFailed = false;

        nextPrompt.updateXY(50, 450);
      }
    }
  }
  if (status == TutorialStatus.GTraining) {
    if (tutorialMinorStep == TutorialStatus.GTraining) {
      if (nextPrompt.MouseClicked()) {
        if (tutorialRequirements[0] == false) tutorialRequirements[0] = true;
        else if (tutorialRequirements[1] == false) tutorialRequirements[1] = true;
      }
    } else if (tutorialMinorStep == TutorialStatus.GTraining+0.1) {
      if (nextPrompt.MouseClicked() && tutorialPass == false) {
        if (tutorialRequirements[0] == false) tutorialRequirements[0] = true;
        else if (tutorialRequirements[1] == false) {
          tutorialRequirements[1] = true;
          nextPrompt.updateGreyOut(true); //prevent player to continuously click on the same spot, accidentally entering 12.2 (which doesnt exist)
        }
      }

      if (tutorialPass && BTMarketBtn.MouseClicked()) {
        //next stage (BT shop)
        status = TutorialStatus.BTraining;
        tutorialMinorStep = status;
        
        tutorialPass = false;
        for (int i = 0; i < tutorialRequirements.length; i++) tutorialRequirements[i] = false;
        nextPrompt.updateGreyOut(false);
        nextPrompt.updateXY(50, 360);
      }
    }
  }
  if (status == TutorialStatus.BTraining) {
    for (int _btn = upgradeBee.size()-1; _btn >= 0; _btn--) {
      Button btn = upgradeBee.get(_btn);
      if (btn.MouseClicked()) {
        BTSelected = _btn;
      }
    }
    
    if (nextPrompt.MouseClicked()) {
      if (tutorialRequirements[0] == false) tutorialRequirements[0] = true;
      else if (tutorialRequirements[1] == false) tutorialRequirements[1] = true;
      else if (tutorialRequirements[2] == false) tutorialRequirements[2] = true;

      if (tutorialPass) {
        //next stage (end tutorial)
        status = TutorialStatus.EndTutorial;
        tutorialMinorStep = status;

        nextPrompt.updateXY(width/2-75, height/2+210); //update it right before reaching ending tutorial!
      }
    }
  }
  if (status == TutorialStatus.EndTutorial) {
    if (nextPrompt.MouseClicked()) {
      gameMillis = 0;
      roundTime = 0;

      screenDisable();
      tutorialScreenActive = false;
      startupScreenActive = true;

      status = TutorialStatus.BeforeTutorial;
      tutorialMinorStep = status;

      bees = new ArrayList<Bee>();
      hornets = new ArrayList<Hornet>();
      guardians = new ArrayList<Guardian>();
      fireflies = new ArrayList<Firefly>();

      beehiveTier = 0;
      honeyPotTier = 0;
      honeyKg = 0;
      money = 0;
      week = 1;

      nextPrompt.updateXY(width/2-75, height/2+220);
      retryTutorial.updateXY(width-170, height/2+220);
    }
  }

  if (nextPrompt.MouseClicked() && tutorialPass) {
    //every time a "next" prompt is confirmed, move to the next minor step
    int stepHold = round(10*(tutorialMinorStep-status))+1;
    tutorialMinorStep = status+0.1*stepHold;

    tutorialPass = false;
    tutorialFailed = false;
    for (int i = 0; i < tutorialRequirements.length; i++) tutorialRequirements[i] = false;

    // tutorialTimerA = (int)gameMillis;
    // tutorialTimerB = (int)gameMillis;
  }
}

void tipboxFontFormat() {
  fill(255);
  textAlign(CENTER);
  PFont lineFont = createFont("Lucida Sans Demibold", 16);
  textFont(lineFont);
}