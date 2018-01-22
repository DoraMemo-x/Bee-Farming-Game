import java.util.Collections;
import java.util.Arrays;
import java.util.Comparator;
import java.util.List;

Button showGuardianTrainBtn;
Button showBeeTrainBtn;
Button GTMarketBtn, GTPurchase/*, GTSell*/;

CircleButton GTObjCancel;
CircleButton GTAbilityUse;

int GTObjectiveAddAmount = -1; //used for Royal Guardian (Fireflies count)
long GTObjectiveTime = 0; //used for Baiting Guardian (Time spent next to flowers) ; Hunting Guardian (how long the trail lasts) ; Bouncer Guardian (used as the round's time)
int GTObjectiveTimeRequired = 0; //for Baiting Guardian (time needed to spend next to flowers) ; Hunting Guardian (how long the trail lasts)
int GTObjectiveTier = 0; //for Ranged Guardian
boolean GTObjectToggle = false; //Hunting Guardian (toggle trail)
float GTObjectiveScore = 0; //Hunting Guardian (Points scored for catching creatures) ; Ranged Guardian ; Bouncer Guardian
int GTObjectiveScoreRequired = 0; //Hunting Guardian ; Ranged Guardian ; Bouncer Guardian
float GTObjectUsed = 0; //Hunting Guardian (trail)
int GTObjectLimit = 0; //Hunting Guardian (trail)
ArrayList<float[]> pos = new ArrayList(); //Hunting Guardian Course (trail)
List<ArrayList<String>> dotPos = new ArrayList<ArrayList<String>>(); //Hunting Guardian Course (trail)

long GTFadeOutTimer = 0;
boolean GTFOTConfirmed = false; //GuardianTrainingFadeOutTimer. a boolean used for confirming we have starting the fadeOutTimer

boolean ignoreGTClick = false;

void guardianTrainDisplayRun() {
  if (GTFadeOutTimer == 0) background(235, 235, 255);
  else background(map(gameMillis, GTFadeOutTimer, GTFadeOutTimer+5000, 235, 255), map(gameMillis, GTFadeOutTimer, GTFadeOutTimer+5000, 235, 255), 255);

  resetButtonPos();

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
  arc(130, height-24, 26, 26, -HALF_PI, map(roundTime, 0, upgradeGuardianCost[GTSelected][1]*ROUND_TIME, -HALF_PI, PI+HALF_PI), PIE); 

  trainingGuardian.showGuardian();

  switch (GTSelected) {
  case 0: //Royal Guardian
    for (Firefly ff : GTFireflies) {
      ff.showFirefly();
      //ff.move();
    }
    break;

  case 1: //baiting guardian
    for (Flower tf : GTFlowers) {
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

    fill((GTObjectiveTime >= GTObjectiveTimeRequired/2 ? map(GTObjectiveTime-GTObjectiveTimeRequired/2, 0, GTObjectiveTimeRequired/2, cos(0), cos(HALF_PI)) : 1)*255, map(GTObjectiveTime, 0, GTObjectiveTimeRequired/2, sin(0), sin(HALF_PI))*255, 0); //R & G is the sin & cos relationship
    rect(175.5, height-34.5, constrain(map(GTObjectiveTime, 0, GTObjectiveTimeRequired, 0, 399.5), 0, 399.5), 24.5);
    break;

  case 2: //hunting guardian
    //if (dotPos.size() == 0)

    GTObjCancel.Draw();

    for (Firefly ff : GTFireflies) ff.showFirefly();
    for (Hornet h : GTHornets) h.showHornet();
    for (Ladybug lb : GTLadybugs) lb.showLadybug();

    fill(0);
    textSize(10);
    textAlign(CENTER);
    text("Score obtained by trapping creatures (Progress Bar):", 375, height-45);
    noFill();
    strokeWeight(1);
    stroke(100);
    rect(175, height-35, 400, 25);

    fill((GTObjectiveScore >= GTObjectiveScoreRequired/2 ? map(GTObjectiveScore-GTObjectiveScoreRequired/2, 0, GTObjectiveScoreRequired/2, cos(0), cos(HALF_PI)) : 1)*255, map(GTObjectiveScore, 0, GTObjectiveScoreRequired/2, sin(0), sin(HALF_PI))*255, 0); //R & G is the sin & cos relationship
    rect(175.5, height-34.5, constrain(map(GTObjectiveScore, 0, GTObjectiveScoreRequired, 0, 399.5), 0, 399.5), 24.5);

    fill(100);
    textSize(12);
    textAlign(LEFT);
    text((int)GTObjectiveScore + " / " + GTObjectiveScoreRequired, 185, height-18);

    float guardianMouseDistance = distance_between_two_points(trainingGuardian.getLocation().x, mouseX, trainingGuardian.getLocation().y, mouseY);
    if (mousePressed && guardianMouseDistance > 25 && trainingGuardian.getGuardianSelectedStatus() == false) {
      // only use trail when:
      // 1. not selecting a guardian
      // 2. not assigning a location for the guardian
      GTObjectToggle = true;
    }

    if (pos.size() == 0) GTObjCancel.updateGreyOut(true);
    else GTObjCancel.updateGreyOut(false);

    if (pos.size() >= 2 && GTObjectUsed < GTObjectLimit) {
      //display the circled area
      strokeWeight(1);
      stroke(map(GTObjectUsed, 0, GTObjectLimit/2, sin(0), sin(HALF_PI))*255, (GTObjectUsed >= GTObjectLimit/2 ? map(GTObjectUsed-GTObjectLimit/2, 0, GTObjectLimit/2, cos(0), cos(HALF_PI)) : 1)*255, 0);
      for (int i = pos.size()-2; i >= 0; i--) {
        line(pos.get(i)[0], pos.get(i)[1], pos.get(i+1)[0], pos.get(i+1)[1]);
      }
    }

    if (GTObjectToggle && GTObjectUsed < GTObjectLimit) {
      //line(mouseX, mouseY, pmouseX, pmouseY);
      GTObjectUsed += distance_between_two_points(mouseX, pmouseX, mouseY, pmouseY);
      pos.add(new float[] {mouseX, mouseY});
      //println(trailUsed);
    } else if (GTObjectUsed >= GTObjectLimit) {
      //toggle off the trail drawing ability
      GTObjectToggle = false;

      //CONFIRM display the circled area
      strokeWeight(2);
      stroke(255, 0, 0, map(GTObjectiveTime, 0, GTObjectiveTimeRequired, 255, 0));
      for (int i = pos.size()-2; i >= 0; i--) {
        line(pos.get(i)[0], pos.get(i)[1], pos.get(i+1)[0], pos.get(i+1)[1]);
        if (i == pos.size()-2) line(pos.get(0)[0], pos.get(0)[1], pos.get(pos.size()-1)[0], pos.get(pos.size()-1)[1]);
      }


      //cut the line into dots (only runs once)
      if (dotPos.size() == 0) {
        for (int i = pos.size()-2; i >= 0; i--) {
          float x1 = pos.get(i)[0], y1 = pos.get(i)[1];
          float x2 = pos.get(i+1)[0], y2 = pos.get(i+1)[1];
          float slope = (y2-y1)/(x2-x1);
          //println(slope, (y2-y1) + "/" + (x2-x1));

          //stroke(255, 0, 0);
          for (int x = ceil(min(x1, x2)); x < floor(max(x1, x2)); x++) {
            float y = slope*(x-x1) + y1;
            dotPos.add(new ArrayList<String>(Arrays.asList(str(x), str(y))));
            //point(x, y+150);
          }
          //stroke(0, 255, 0);
          for (int y = ceil(min(y1, y2)); y < floor(max(y1, y2)); y++) {
            float x = (y-y1)/slope + x1;
            dotPos.add(new ArrayList<String>(Arrays.asList(str(x), str(y))));
            //point(x+150, y);
          }
        }
        float x1 = pos.get(0)[0], y1 = pos.get(0)[1];
        float x2 = pos.get(pos.size()-1)[0], y2 = pos.get(pos.size()-1)[1];
        float slope = (y2-y1)/(x2-x1);

        //stroke(255, 0, 0);
        for (int x = ceil(min(x1, x2)); x < floor(max(x1, x2)); x++) {
          float y = slope*(x-x1) + y1;
          dotPos.add(new ArrayList<String>(Arrays.asList(str(x), str(y))));
          //point(x, y+150);
        }
        //stroke(0, 255, 0);
        for (int y = ceil(min(y1, y2)); y < floor(max(y1, y2)); y++) {
          float x = (y-y1)/slope + x1;
          dotPos.add(new ArrayList<String>(Arrays.asList(str(x), str(y))));
          //point(x+150, y);
        }
      }
    }
    break;

  case 3:
    break;

  case 4: //ranged guardian
    for (Firefly ff : GTFireflies) ff.showFirefly();
    for (Hornet h : GTHornets) h.showHornet();

    fill(0);
    textSize(10);
    textAlign(CENTER);
    text("Score obtained by eliminating enemies (Progress Bar):", 375, height-50);
    noFill();
    strokeWeight(1);
    stroke(100);
    rect(175, height-35, 400, 25);
    int t1=0, t2=0, t3=0, t4=0, t5=0; //t5 means success. end of the course
    if (GTObjectiveTier == 0) { //+0
      t1 = GTObjectiveScoreRequired;
      t2 = GTObjectiveScoreRequired+30; 
      t3 = GTObjectiveScoreRequired+30+40; 
      t4 = GTObjectiveScoreRequired+30+40+50;
      t5 = GTObjectiveScoreRequired+30+40+50+65;
      //println(t1, t2, t3, t4);
    } else if (GTObjectiveTier == 1) { //+30
      t1 = GTObjectiveScoreRequired-30; 
      t2 = GTObjectiveScoreRequired; 
      t3 = GTObjectiveScoreRequired+40; 
      t4 = GTObjectiveScoreRequired+40+50;
      t5 = GTObjectiveScoreRequired+40+50+65;
    } else if (GTObjectiveTier == 2) { //+40
      t1 = GTObjectiveScoreRequired-30-40;
      t2 = GTObjectiveScoreRequired-40; 
      t3 = GTObjectiveScoreRequired; 
      t4 = GTObjectiveScoreRequired+50;
      t5 = GTObjectiveScoreRequired+50+65;
    } else if (GTObjectiveTier == 3) { //+50
      t1 = GTObjectiveScoreRequired-30-40-50; 
      t2 = GTObjectiveScoreRequired-40-50; 
      t3 = GTObjectiveScoreRequired-50; 
      t4 = GTObjectiveScoreRequired;
      t5 = GTObjectiveScoreRequired+65;
    } else if (GTObjectiveTier == 4 || GTSuccessConditionMatch) { //+65
      t1 = GTObjectiveScoreRequired-30-40-50-65; 
      t2 = GTObjectiveScoreRequired-40-50-65; 
      t3 = GTObjectiveScoreRequired-50-65; 
      t4 = GTObjectiveScoreRequired-65;
      t5 = GTObjectiveScoreRequired;
    }
    //println(t1, t2, t3, t4, t5);

    fill((GTObjectiveScore >= t5/2 ? map(GTObjectiveScore-t5/2, 0, t5/2, cos(0), cos(HALF_PI)) : 1)*255, map(GTObjectiveScore, 0, t5/2, sin(0), sin(HALF_PI))*255, 0); //R & G is the sin & cos relationship
    rect(175.5, height-34.5, constrain(map(GTObjectiveScore, 0, t5, 0, 399.5), 0, 399.5), 24.5);

    fill(0);
    textSize(8);
    text("Tier 1", 175.5+map(t1, 0, t5, 0, 400), height-38);
    text("Tier 2", 175.5+map(t2, 0, t5, 0, 400), height-38);
    text("Tier 3", 175.5+map(t3, 0, t5, 0, 400), height-38);
    text("Tier 4", 175.5+map(t4, 0, t5, 0, 400), height-38);
    text("Tier 5", 175.5+400, height-38);
    stroke(125);
    line(175.5+map(t1, 0, t5, 0, 400), height-35, 175.5+map(t1, 0, t5, 0, 400), height-10);
    line(175.5+map(t2, 0, t5, 0, 400), height-35, 175.5+map(t2, 0, t5, 0, 400), height-10);
    line(175.5+map(t3, 0, t5, 0, 400), height-35, 175.5+map(t3, 0, t5, 0, 400), height-10);
    line(175.5+map(t4, 0, t5, 0, 400), height-35, 175.5+map(t4, 0, t5, 0, 400), height-10);

    fill(100);
    textSize(12);
    textAlign(LEFT);
    text((int)GTObjectiveScore + " / " + GTObjectiveScoreRequired, 185, height-18);

    if (trainingGuardian.getStingCooldown() > 0) {
      strokeWeight(2);
      stroke(119, 94, 26);
      fill(251, 200, 55);
      ellipse(width-160, height-32.5, 35, 35);
      textAlign(CENTER, CENTER);
      fill(0);
      textSize(12);
      text("S", width-160, height-32.5);
      noStroke();
      fill(saturation(color(251, 200, 55)));
      arc(width-160, height-32.5, 32.5, 32.5, -HALF_PI, map(trainingGuardian.getStingCooldown(), 0, 10000, -HALF_PI, PI+HALF_PI), PIE);
    } else if (trainingGuardian.getShootSting()) {
      strokeWeight(2);
      stroke(119, 94, 26);
      fill(136, 136, 255);
      ellipse(width-160, height-32.5, 35, 35);
      textAlign(CENTER, CENTER);
      fill(0);
      textSize(12);
      text("C", width-160, height-32.5);
    } else {
      GTAbilityUse.Draw();
    }

    for (int _projectile = projectiles.size ()-1; _projectile >= 0; _projectile--) {
      ProjectileWeapon p = projectiles.get(_projectile);

      if (p.getForTraining()) {
        p.showProjectile();
        //p.move(); //mechanic - move projectile
      }

      //mechanic - remove projectile
      //float px = p.getLocation().x;
      //float py = p.getLocation().y;
      //if (px > width+5 || px < -5 || py > height+5 || py < 0) projectiles.remove(_projectile);
      /////
    }
    for (ItemSpawn is : pomegranate) {
      is.showItem();
    }
    break;

  case 5: //Bouncer Guardian
    for (Bee b : GTBees) b.showBee();
    for (Hornet h : GTHornets) h.showHornet();
    for (Ladybug lb : GTLadybugs) lb.showLadybug();

    fill(0);
    textSize(12);
    textAlign(LEFT);
    text("Training Progress: ", 165, height-20);
    strokeWeight(1);
    stroke((GTObjectiveScore >= GTObjectiveScoreRequired/2 ? map(GTObjectiveScore-GTObjectiveScoreRequired/2, 0, GTObjectiveScoreRequired/2, cos(0), cos(HALF_PI)) : 1)*255, map(GTObjectiveScore, 0, GTObjectiveScoreRequired/2, sin(0), sin(HALF_PI))*255, 0); //R & G is the sin & cos relationship
    noFill();
    ellipse(300, height-24, 26, 26);
    fill((GTObjectiveScore >= GTObjectiveScoreRequired/2 ? map(GTObjectiveScore-GTObjectiveScoreRequired/2, 0, GTObjectiveScoreRequired/2, cos(0), cos(HALF_PI)) : 1)*255, map(GTObjectiveScore, 0, GTObjectiveScoreRequired/2, sin(0), sin(HALF_PI))*255, 0); //R & G is the sin & cos relationship
    if (GTSuccessConditionMatch == false) arc(300, height-24, 26, 26, -HALF_PI, map(GTObjectiveScore, -0.01, GTObjectiveScoreRequired+1, -HALF_PI, PI+HALF_PI), PIE);
    else arc(300, height-24, 26, 26, -HALF_PI, PI+HALF_PI, PIE);
    break;
  }
}

boolean GTSuccessConditionMatch = false;

void guardianTrainMechanicRun(boolean showText) {
  trainingGuardian.move();

  switch (GTSelected) {
  case 0: //Royal Guardian
    for (Firefly ff : GTFireflies) ff.move();

    if (GTFireflies.size() < 5 && GTObjectiveAddAmount > 0) {
      GTFireflies.add(new Firefly(true));
      GTObjectiveAddAmount--;
    }

    if (GTFireflies.size() == 0) GTSuccessConditionMatch = true;
    break;

  case 1: //Baiting Guardian
    if (GTObjectiveTime >= GTObjectiveTimeRequired) GTSuccessConditionMatch = true;
    break;

  case 2: //Hunting Guardian
    for (Firefly ff : GTFireflies) ff.move();
    for (Hornet h : GTHornets) h.move();
    for (Ladybug lb : GTLadybugs) lb.move();

    if (GTFireflies.size() < 3) GTFireflies.add(new Firefly(true));
    if (GTHornets.size() < 4) GTHornets.add(new Hornet((random(1) > 0.6 ? 1 : 0), true));
    if (GTLadybugs.size() < 3) GTLadybugs.add(new Ladybug(true));

    if (keyPressed && (key == 'c' || key == 'C')) {
      pos = new ArrayList();
      dotPos = new ArrayList<ArrayList<String>>();

      GTObjectUsed = 0;
      GTObjectToggle = false;
      GTObjectiveTime = 0;
    }

    PVector guardianCoords = trainingGuardian.getLocation();
    if (checkWithinShape(guardianCoords.x, guardianCoords.y) == true && GTObjectiveTime <= GTObjectiveTimeRequired) {
      GTObjectiveTime += (timeMillis-pMillis);

      trainingGuardian.updateSpeed(guardianFlightSpeed[1]/3);
      //println(frameCount + " / SPEED: "+trainingGuardian.getSpeed());

      PVector coordinates[] = new PVector[GTFireflies.size() + GTHornets.size() + GTLadybugs.size()];
      int tfRemoved = 0, thRemoved = 0, tlbRemoved = 0;
      for (int i = 0; i < coordinates.length; i++) {

        if (i < GTFireflies.size()) coordinates[i] = GTFireflies.get(i -tfRemoved).getLocation();
        else if (i < GTFireflies.size() + GTHornets.size()) coordinates[i] = GTHornets.get(i-GTFireflies.size() -thRemoved).getLocation();
        else if (i < GTFireflies.size() + GTHornets.size() + GTLadybugs.size()) coordinates[i] = GTLadybugs.get(i-GTFireflies.size()-GTHornets.size() -tlbRemoved).getLocation();
        else continue;

        float _COORx = coordinates[i].x, _COORy = coordinates[i].y;
        if (checkWithinShape(_COORx, _COORy)) {
          if (i < GTFireflies.size()) {
            println("Firefly within");
            GTObjectiveScore += 5;
            println(GTObjectiveScore);
            GTObjectiveScore = constrain(GTObjectiveScore, 0, GTObjectiveScoreRequired);
            GTFireflies.remove(i -tfRemoved);
            tfRemoved++;
          } else if (i < GTFireflies.size() + GTHornets.size()) {
            println("Hornet within"); 
            GTObjectiveScore += 3;
            println(GTObjectiveScore);
            GTObjectiveScore = constrain(GTObjectiveScore, 0, GTObjectiveScoreRequired);
            GTHornets.remove(i-GTFireflies.size() -thRemoved);
            thRemoved++;
          } else if (i < GTFireflies.size() + GTHornets.size() + GTLadybugs.size()) {
            println("Ladybug within");
            GTObjectiveScore -= 2;
            println(GTObjectiveScore);
            GTObjectiveScore = constrain(GTObjectiveScore, 0, GTObjectiveScoreRequired);
            GTLadybugs.remove(i-GTFireflies.size()-GTHornets.size() -tlbRemoved);
            tlbRemoved++;
          }
        }
      }
    } else if (GTObjectiveTime > GTObjectiveTimeRequired) {
      pos = new ArrayList();
      dotPos = new ArrayList<ArrayList<String>>();

      GTObjectUsed = 0;
      GTObjectToggle = false;
      GTObjectiveTime = 0;
    } else {
      trainingGuardian.updateSpeed(guardianFlightSpeed[1]);
      //println(frameCount + " / SPEED: "+trainingGuardian.getSpeed());
    }



    if (GTObjectiveScore >= GTObjectiveScoreRequired) GTSuccessConditionMatch = true;
    break;

  case 3:
    break;

  case 4: //Ranged Guardian
    for (Firefly ff : GTFireflies) ff.move();
    for (Hornet h : GTHornets) h.move();

    if (GTFireflies.size() < 4) {
      GTFireflies.add(new Firefly(true));
      //GTFireflies.get(3).updateFireflyHp(10);
    }
    if (GTHornets.size() < 5) {
      GTHornets.add(new Hornet((random(1) > 0.6 ? 1 : 0), true));
      //int multiplier = GTHornets.get(4).getHornetType()+1;
      //GTHornets.get(4).updateHornetHp(4*multiplier);
    }
    if (pomegranate.size() < 2) {
      pomegranate.add(new ItemSpawn(17));
      pomegranate.get(pomegranate.size()-1).updateForTraining(true);
    }

    for (int _projectile = projectiles.size ()-1; _projectile >= 0; _projectile--) {
      ProjectileWeapon p = projectiles.get(_projectile);

      if (p.getForTraining()) {
        p.move(); //mechanic - move projectile
      }

      //mechanic - remove projectile
      float px = p.getLocation().x;
      float py = p.getLocation().y;
      if (px > width+5 || px < -5 || py > height+5 || py < 0) projectiles.remove(_projectile);
      /////
    }

    if (GTObjectiveScore >= GTObjectiveScoreRequired) {
      if (GTObjectiveTier == 0) GTObjectiveScoreRequired += 30;
      else if (GTObjectiveTier == 1) GTObjectiveScoreRequired += 40;
      else if (GTObjectiveTier == 2) GTObjectiveScoreRequired += 50;
      else if (GTObjectiveTier == 3) GTObjectiveScoreRequired += 65;
      else if (GTObjectiveTier == 4) GTSuccessConditionMatch = true;

      if (GTObjectiveTier < 5) GTObjectiveTier++;
    }
    break;

  case 5: //Bouncer Guardian
    if (GTObjectiveTime > 0) {
      GTObjectiveTime -= (timeMillis-pMillis);
      GTObjectiveTime = (long)constrain(GTObjectiveTime, 0, 7000);
    } else if (GTObjectiveTime == 0 && GTHornets.size() == 0) {
      GTHornets.add(new Hornet(random((GTObjectiveScore+1)) > 0.5045*pow(GTObjectiveScore, 0.6823) ? 1 : 0, true));
      GTObjectiveTime = -1;
    }

    for (Bee b : GTBees) b.move();
    for (Hornet h : GTHornets) h.move();
    for (Ladybug lb : GTLadybugs) lb.move();

    if (GTObjectiveTime < 0) { //round's time is up. reveal everything & spawn hornet

      if (GTHornets.size() == 0 && GTBees.size() > 0) { //round success
        if (GTObjectiveScore < GTObjectiveScoreRequired) GTObjectiveScore++;
        else GTSuccessConditionMatch = true; //this means the "required rounds" is scoreRequired+1

        GTBees = new ArrayList<Bee>();
        GTHornets = new ArrayList<Hornet>();
        GTLadybugs = new ArrayList<Ladybug>();

        GTBees.add(new Bee( (int)random(3) ));
        GTBees.get(0).updateForTraining(true);
        GTBees.get(0).updateLocation(10+random(width-20), 40+random(height-40-50));
        for (int i = 0; i < GTObjectiveScore+1; i++) GTLadybugs.add(new Ladybug(true));

        GTObjectiveTime = (int)random(5.5, 7)*1000;
      } else if (GTBees.size() == 0) { //bee died, round fail
        GTBees = new ArrayList<Bee>();
        GTHornets = new ArrayList<Hornet>();
        GTLadybugs = new ArrayList<Ladybug>();

        GTBees.add(new Bee( (int)random(3) ));
        GTBees.get(0).updateForTraining(true);
        for (int i = 0; i < GTObjectiveScore+1; i++) {
          GTLadybugs.add(new Ladybug(true));
          //GTLadybugs.get(i).updateLocation(width/2, height/2);
        }
        GTObjectiveTime = (int)random(4, 6)*1000;
      }
    }
    break;
  }

  if (GTSuccessConditionMatch == false && roundTime >= upgradeGuardianCost[GTSelected][1]*ROUND_TIME) { //mostly failed. but if the training course has "tier system", then it might not be.
    if (GTObjectiveTier == 0) { //this is a fail
      fill(0);
      textSize(100);
      textAlign(CENTER);
      if (showText) text("FAILED...", width/2, height/2);
      textSize(30);
      if (showText) text("Your Super Guardian has died of fatigue.", width/2, height/2+80);
      trainingGuardian.updateShouldGuardianMove(false);
    } else {
      if (GTFOTConfirmed == false) {
        GTFOTConfirmed = true;
        GTFadeOutTimer = gameMillis;
      }
      fill(0);
      textSize(100);
      textAlign(CENTER);
      if (showText) text("COMPLETED!", width/2, height/2);
      if (beesCount < beehiveSize[beehiveTier]) {
        textSize(30);
        if (showText) {
          text("A tier " + GTObjectiveTier + ' ' + upgradedGuardianName[GTSelected], width/2, height/2+80);
          text("will be delivered in: " + ((5000+GTFadeOutTimer-gameMillis)/1000) + " seconds", width/2, height/2+110);
        }
      } else {
        textSize(18);
        fill(255, 50, 50);
        if (showText) {
          text(upgradedGuardianName[GTSelected] + " cannot be delivered due to occupied beehive!", width/2, height/2+80);
          text(upgradedGuardianName[GTSelected] + " will be delivered once your beehive is not full.", width/2, height/2+110);
          fill(255, 0, 0);
          text("WARNING: " + upgradedGuardianName[GTSelected] + " will be KILLED if it is still not delivered within this week!", width/2, height/2+135);
        }
      }

      if (gameMillis - GTFadeOutTimer > 5000) {
        if (beesCount < beehiveSize[beehiveTier]) {
          guardians.add(new Guardian(upgradedGuardianName[GTSelected]));
          float blockSize = (650 - 10*2 - 10*5)/5;
          inventoryGuardians.add(new Guardian(upgradedGuardianName[GTSelected]));
          inventoryGuardians.get(inventoryGuardians.size()-1).updateShouldGuardianMove(false);
          int counter = 0;
          for (int y = 0; y < 2; y++) {
            for (int x = 0; x < 5; x++) {
              if (inventoryGuardians.size() > guardianInvSlot+counter) {
                inventoryGuardians.get(guardianInvSlot+counter).updateLocation(20 + blockSize/2 + (blockSize+10)*x, 70 + blockSize/2 + (blockSize+10)*y);
                counter++;
              } else break;
            }
          }

          if (GTSelected == 4) for (Guardian g : guardians) {
            if (g.getGuardianType() == 6) { //confirm if it is ranged guardian
              g.updateStingTier(GTObjectiveTier);
            }
          }
          GTFadeOutTimer = gameMillis;
          resetGTVars();
          screenDisable();
          gameScreenActive = true;
        } else {
          //do nothing.
          //wait until the beehive occupancy is lower
        }
      }
    }
  } else if (GTSuccessConditionMatch) { //success
    if (GTFOTConfirmed == false) {
      GTFOTConfirmed = true;
      GTFadeOutTimer = gameMillis;
    }
    fill(0);
    textSize(100);
    textAlign(CENTER);
    if (showText) text("COMPLETED!", width/2, height/2);
    if (beesCount < beehiveSize[beehiveTier]) {
      textSize(30);
      if (showText) {
        if (GTSelected == 4) {
          text("A tier " + GTObjectiveTier + ' ' + upgradedGuardianName[GTSelected], width/2, height/2+80);
          text("will be delivered in: " + ((5000+GTFadeOutTimer-gameMillis)/1000) + " seconds", width/2, height/2+110);
        } else text(upgradedGuardianName[GTSelected] + " will be delivered in: " + ((5000+GTFadeOutTimer-gameMillis)/1000) + " seconds", width/2, height/2+80);
      }
    } else {
      textSize(18);
      fill(255, 50, 50);
      if (showText) {
        text(upgradedGuardianName[GTSelected] + " cannot be delivered due to occupied beehive!", width/2, height/2+80);
        text(upgradedGuardianName[GTSelected] + " will be delivered once your beehive is not full.", width/2, height/2+1110);
        fill(255, 0, 0);
        text("WARNING: " + upgradedGuardianName[GTSelected] + " will be KILLED if it is still not delivered within this week!", width/2, height/2+135);
      }
    }

    if (gameMillis - GTFadeOutTimer > 5000) {
      if (beesCount < beehiveSize[beehiveTier]) {
        guardians.add(new Guardian(upgradedGuardianName[GTSelected]));
        float blockSize = (650 - 10*2 - 10*5)/5;
        inventoryGuardians.add(new Guardian(upgradedGuardianName[GTSelected]));
        inventoryGuardians.get(inventoryGuardians.size()-1).updateShouldGuardianMove(false);
        int counter = 0;
        for (int y = 0; y < 2; y++) {
          for (int x = 0; x < 5; x++) {
            if (inventoryGuardians.size() > guardianInvSlot+counter) {
              inventoryGuardians.get(guardianInvSlot+counter).updateLocation(20 + blockSize/2 + (blockSize+10)*x, 70 + blockSize/2 + (blockSize+10)*y);
              counter++;
            } else break;
          }
        }

        if (GTSelected == 4) for (Guardian g : guardians) {
          if (g.getGuardianType() == 6) { //confirm if it is ranged guardian
            g.updateStingTier(GTObjectiveTier);
          }
        }
        GTFadeOutTimer = gameMillis;
        resetGTVars();
        screenDisable();
        gameScreenActive = true;
      } else {
        //do nothing.
        //wait until the beehive occupancy is lower
      }
    }
  }
}

int GTBeesSelectedPrev = 0, GTBeesSelectedCurr = 0;
int trainingGuardsSelectedPrev = 0, trainingGuardsSelectedCurr = 0;
void guardianTrainClickEvents() {
  if (ignoreGTClick) {
    ignoreGTClick = false;
    return;
  } else {
    //GTObjCancel for: hunting guardian (2)
    if (GTObjCancel.MouseClicked()) {
      pos = new ArrayList();
      dotPos = new ArrayList<ArrayList<String>>();

      GTObjectUsed = 0;
      GTObjectToggle = false;
      GTObjectiveTime = 0;
    }
    //GTAbilityUse for: ranged guardian (4)
    if (GTAbilityUse.MouseClicked() && trainingGuardian.getStingCooldown() == 0 && trainingGuardian.getShootSting() == false) {
      trainingGuardian.updateShootSting(true);
      //trainingGuardian.resetStingCooldown();
      return;
    }
    //else if (GTAbilityUse.MouseClicked() && trainingGuardian.getShootSting()) {
    //  trainingGuardian.updateShootSting(false);
    //  return;
    //}

    float gx = trainingGuardian.getLocation().x;
    float gy = trainingGuardian.getLocation().y;

    int selectedFireflyID = -1;
    if (mouseX > gx-25 && mouseX < gx+25 && mouseY > gy-25 && mouseY < gy+25) {
      if (trainingGuardian.getGuardianSelectedStatus() == false) {
        trainingGuardian.updateGuardianSelectedStatus(true); //selected the guardian

        if (GTSelected == 5) { //bouncer. can select bees & fake bees
          GTBees.get(0).updateBeeSelectedStatus(false);
          for (Ladybug lb : GTLadybugs) {
            lb.updateSelectedStatus(false);
          }
        }
      } else trainingGuardian.updateGuardianSelectedStatus(false); //deselect the guardian
    } else if (trainingGuardian.getGuardianSelectedStatus() == true) { //if the guardian is selected (the only situation that it can be assigned a target)
      switch (GTSelected) {
      case 0: //Royal Guardian
        for (int ff = GTFireflies.size ()-1; ff >= 0; ff--) {
          Firefly _firefly = GTFireflies.get(ff);
          float ffx = _firefly.getLocation().x;
          float ffy = _firefly.getLocation().y;

          if (mouseX > ffx-15 && mouseX < ffx+15 && mouseY > ffy-15 && mouseY < ffy+15) {
            trainingGuardian.updateGuardianSelectedStatus(false);
            //tapped a firefly. not selected yet
            _firefly.minusFireflyHp();
            _firefly.updateFireflyMoveTimer(gameMillis);

            if (_firefly.getFireflyHp() == 0) {
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
        break;

      case 1: //baiting guardian
        boolean selectedFlower = false;

        for (int tf = GTFlowers.size ()-1; tf >= 0; tf--) {
          Flower _tf = GTFlowers.get(tf);
          float tfx = _tf.getLocation().x;
          float tfy = _tf.getLocation().y;

          if (mouseX > tfx-15 && mouseX < tfx+15 && mouseY > tfy-15 && mouseY < tfy+15) {
            trainingGuardian.updateGuardianSelectedStatus(false);
            trainingGuardian.updateGuardianMoveTimer(gameMillis);

            trainingGuardian.selectTarget(tf);
            trainingGuardian.updateGuardianTimeoutMove(false);

            selectedFlower = true;

            break;
          }
        }

        if (selectedFlower == false) { // didnt select a flower. go to mouse direction
          float _thetaRad = calcMoveTheta(mouseX, mouseY, gx, gy);
          trainingGuardian.updateMoveTheta(_thetaRad);

          trainingGuardian.updateGuardianSelectedStatus(false);
          trainingGuardian.updateGuardianMoveTimer(gameMillis);
        }
        break;

      case 2: //hunting guardian
      case 4: //ranged guardian
      case 5: //bouncer guardian
        float _thetaRad = calcMoveTheta(mouseX, mouseY, gx, gy);
        trainingGuardian.updateMoveTheta(_thetaRad);

        trainingGuardian.updateGuardianSelectedStatus(false);
        trainingGuardian.updateGuardianMoveTimer(gameMillis);
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
          trainingGuardian.updateMoveTheta(_thetaRad);

          trainingGuardian.updateGuardianSelectedStatus(false);
          trainingGuardian.updateGuardianMoveTimer(gameMillis);
        }
        break;

      case 4: //ranged guardian
        float _thetaRad = calcMoveTheta(mouseX, mouseY, gx, gy);
        trainingGuardian.updateMoveTheta(_thetaRad);

        trainingGuardian.updateGuardianSelectedStatus(false);
        trainingGuardian.updateGuardianMoveTimer(gameMillis);
        break;

      case 5: //bouncer guardian
        boolean selectedObject = false;

        GTBeesSelectedPrev = 0;
        for (Bee b : GTBees) {
          if (b.getBeeSelectedStatus()) GTBeesSelectedPrev++;
        }
        for (Ladybug lb : GTLadybugs) {
          if (lb.getSelectedStatus()) GTBeesSelectedPrev++;
        }
        GTBeesSelectedCurr = GTBeesSelectedPrev;
        for (Bee b : GTBees) {
          float bx = b.getLocation().x;
          float by = b.getLocation().y;

          if (mouseX > bx-25 && mouseX < bx+25 && mouseY > by-25 && mouseY < by+25) {
            selectedObject = true;
            if (b.getBeeSelectedStatus() == false) {
              b.updateBeeSelectedStatus(true); //selected a bee
              GTBeesSelectedCurr++;

              trainingGuardian.updateGuardianSelectedStatus(false);
              break; //only select ONE "UNSELECTED" bee
            } else {
              b.updateBeeSelectedStatus(false); //deselect a bee
              GTBeesSelectedCurr--;
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
              if (lb.getSelectedStatus() == false) {
                lb.updateSelectedStatus(true); //selected a bee
                GTBeesSelectedCurr++;

                trainingGuardian.updateGuardianSelectedStatus(false);
                break; //only select ONE "UNSELECTED" bee
              } else {
                lb.updateSelectedStatus(false); //deselect a bee
                GTBeesSelectedCurr--;
                break;
              }
            }
          }
        }

        if (GTBeesSelectedCurr == 0 && trainingGuardian.getGuardianSelectedStatus() == false && selectedObject == false) { //selected no bee no guardian, but selected a new target, so training guardian go to that location
          float thetaRad = calcMoveTheta(mouseX, mouseY, gx, gy);
          trainingGuardian.updateMoveTheta(thetaRad);

          trainingGuardian.updateGuardianSelectedStatus(false);
          trainingGuardian.updateGuardianMoveTimer(gameMillis);
        } else if (GTBeesSelectedCurr > 0 && selectedObject == false) { //selected at least 1 bee. move that bee to mouse direction
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



//functions
void resetGTVars() {
  GTSelected = -1;
  GTOngoing = false;
  GTFOTConfirmed = false;
  GTObjectiveTier = 0;
}



//mechanics
void sortArrayList1() {  //sort by first element
  Collections.sort(dotPos, new Comparator<ArrayList<String>>() {    
    public int compare(ArrayList<String> o1, ArrayList<String> o2) {
      String x1 = o1.get(0), x2 = o2.get(0);
      return x1.compareTo(x2);
    }
  }
  );
}

void sortArrayList2() {  //sort by second element
  Collections.sort(dotPos, new Comparator<ArrayList<String>>() {    
    public int compare(ArrayList<String> o1, ArrayList<String> o2) {
      String x1 = o1.get(1), x2 = o2.get(1);
      return x1.compareTo(x2);
    }
  }
  );
}

boolean checkWithinShape(float COORx, float COORy) {
  boolean xValid = false;
  boolean yValid = false;

  sortArrayList1();
  for (int i = dotPos.size()-2; i >= 0; i--) {
    List<String> positions1 = dotPos.get(i);
    PVector pos1 = new PVector(float(positions1.get(0)), float(positions1.get(1)));
    List<String> positions2 = dotPos.get(i+1);
    PVector pos2 = new PVector(float(positions2.get(0)), float(positions2.get(1)));

    if (pos1.x == pos2.x) {
      if (COORx > pos1.x-0.5 && COORx < pos1.x+0.5) {
        if (COORy > min(pos1.y, pos2.y)   &&   COORy < max(pos1.y, pos2.y)) {
          //stroke(255);
          //line(pos1.x, pos1.y, pos2.x, pos2.y);
          //stroke(255, 0, 0);
          //point(COORx, COORy);

          yValid = true;
          break;
        } else continue;
      } else continue;
    } else continue;
  }

  sortArrayList2();
  for (int i = dotPos.size()-2; i >= 0; i--) {
    List<String> positions1 = dotPos.get(i);
    PVector pos1 = new PVector(float(positions1.get(0)), float(positions1.get(1)));
    List<String> positions2 = dotPos.get(i+1);
    PVector pos2 = new PVector(float(positions2.get(0)), float(positions2.get(1)));

    if (pos1.y == pos2.y) {
      if (COORy > pos1.y-0.5 && COORy < pos1.y+0.5) {
        if (COORx > min(pos1.x, pos2.x)   &&   COORx < max(pos1.x, pos2.x)) {
          xValid = true;
          break;
        } else continue;
      } else continue;
    } else continue;
  }

  if (xValid && yValid) return true;
  else return false;
}