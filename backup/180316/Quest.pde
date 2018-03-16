Button questBtn;
int[][][] questReq = {{{0}, {0}, {-1, -1, -1}, {-1, 0, -1, 0, -1, 0, -1, 0, -1, 0}, {-1}, {-1, -1, -1, -1, -1, -1, -1, -1}}, {{0}, {0}, {-1, -1, -1}, {-1, 0, -1, 0, -1, 0, -1, 0, -1, 0}, {-1}, {-1, -1, -1, -1, -1, -1, -1, -1}}}; //for obtain entity, format is "entityType, entityLevel"; for resource, req is itemType
int[][] questDiff = {{0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0}};
boolean[][] questType = {{false, false, false, false, false, false}, {false, false, false, false, false, false}};
int[] questDeadlineWeek = {10, 10}/*, questOverallDiff = {-1, -1}*/; //overallDiff is done in showQuest() 
int completedQuests = 0;
String questReqString = "";
String[] questDescription = new String[6];
//solid star: ★, empty star: ☆, "half star": ✪ *note that lucida sans cannot show empty stars.

boolean[][] rewardGet = {{false, false, false, false, false, false, false, false, false, false, false, false, false, false, false}, {false, false, false, false, false, false, false, false, false, false, false, false, false, false, false}};
float[][][] rewardFloat = {{{0}, {0}, {-1, -1, -1}, {-1, -1, -1}, {-1}, {0}, {0}, {0, -1}, {0, -1}, {-1}, {0}, {-1}, {-1}, {-1}, {-1}}, {{0}, {0}, {-1, -1, -1}, {-1, -1, -1}, {-1}, {0}, {0}, {0, -1}, {0, -1}, {-1}, {0}, {-1}, {-1}, {-1}, {-1}}}; 
//7 freeze enemy: {weeks, slow-by_multiplier}
//8 forest fee reduction: {forestID, reduce-by_multiplier}
//9, 11-14: float mean nothing other than preventing repetition
String rewardString = "";
String[] rewardDescription = new String[15];

boolean[] rewardSelection = {false, false, false};
int rewardSelectedID = -1;

String[][] questDetail = new String[2][8];
float[][] effectTakingPlace = {{0}, {0}, {0, 1}, {0, 1}, {0}, {0}};
//0 price boost - weeks
//1 enemy free - weeks
//2 slow enemy - weeks, multi
//3 reduce fee - id, multi
//4 extra playtime - weeks
//5 shop sale - weeks (although set to be 1 week, player can accumulate)
Button toggleEnemyFree;
boolean enemyFree = false;
int toggleEnemyTimer = 0;

void refreshQuestDescription() {
  questDescription[0] = " - Gather " + questReqString + "kg of honey.";
  questDescription[1] = " - Earn $" + questReqString + ".";
  questDescription[2] = " - Enter " + questReqString + ".";
  questDescription[3] = " - Obtain one of each: " + questReqString + ".";
  questDescription[4] = " - Kill " + questReqString + " enemies. (i.e. Hornets, Fireflies)";
  questDescription[5] = " - Acquire " + questReqString + ".";
}

void refreshRewardDescription() {
  String weekDurationReward = rewardString + (int(rewardString) == 1 ? " week." : " weeks.");
  rewardDescription[0] = " - $" + rewardString + ".";
  rewardDescription[1] = " - " + rewardString + "kg of honey.";
  rewardDescription[2] = " - 1 x " + rewardString + "."; //bee
  rewardDescription[3] = " - 1 x " + rewardString + "."; //guardian
  rewardDescription[4] = " - Honey Pot Upgrade (1 Tier)";
  rewardDescription[5] = " - Honey will worth more money for " + weekDurationReward; //"price boost"
  rewardDescription[6] = " - No enemy for " + weekDurationReward;
  rewardDescription[7] = " - Enemies move slower for " + weekDurationReward;
  rewardDescription[8] = " - Reduce entry fee for " + char(34) + rewardString + char(34) + " for the next entry."; //forest fee reduction
  rewardDescription[9] = " - Unlock extra beehive space.";
  rewardDescription[10] = " - Extra playtime each week, for " + weekDurationReward;
  rewardDescription[11] = " - Shop sale for 1 week.";
  //below: requires player selection
  rewardDescription[12] = " - Exchange 2 selected resources for 3 random resources.";
  rewardDescription[13] = " - Exchange 1 selected resource for 1 custom resource.";
  rewardDescription[14] = " - Grant permanent speed buff to 1 selected guardian.";
}

Button quest1;
Button quest2;
boolean[][][] questDone = {{{false}, {false}, {false, false, false}, {false, false, false, false, false}, {false}, {false, false, false, false, false, false, false, false}}, {{false}, {false}, {false, false, false}, {false, false, false, false, false}, {false}, {false, false, false, false, false, false, false, false}}};

int questEnemyProg = 0;
//int pEnemies = 0;

void showQuest() {
  if (week >= 10) { //10 weeks
    quest1.Draw();
    quest2.Draw();

    for (int t = 0; t < questDeadlineWeek.length; t++) { //2
      drawPopupWindow(questDetail[t], 0, 12, 50, 70 + t*225, false, 0, width);

      int line = 4;
      for (int qd = 0; qd < questDetail[t].length; qd++) {
        if (match(questDetail[t][qd], "Difficulty") != null) {
          line = qd;
          break;
        }
      }
      if (t == 1) quest2.updateXY(width-350, 410+(line-4)*12);

      if (week > questDeadlineWeek[t]) { //"expired"
        strokeWeight(5);
        stroke(255, 0, 0);
        fill(200, 0, 0);
        textAlign(CENTER);
        textSize(20);
        if (t == 0) {
          line(width-350, 190, width-350+120, 190+35);
          line(width-350+120, 190, width-350, 190+35);
          text("EXPIRED", width-350+60, 190-10);
        } else if (t == 1) {
          line(width-350, 410+(line-4)*12, width-350+120, 410+(line-4)*12+35);
          line(width-350+120, 410+(line-4)*12, width-350, 410+(line-4)*12+35);
          text("EXPIRED", width-350+60, 410+(line-4)*12-10);
        }
      }

      int sumDiff = 0;
      for (int s = 0; s < questDiff[t].length; s++) {
        if (questDiff[t][s] != 0) sumDiff += questDiff[t][s];
      }
      if (t == 0) drawStarBar(115, 110+(line-4)*12, 35, 235, 0, sumDiff);
      else if (t == 1) drawStarBar(115, 335+(line-4)*12, 35, 235, 0, sumDiff);
      //x always 125, y depends: (150) 35 height / (375) 35 height; 1 line 10 pixel ***note: all minus 10
    }
    
    
    
    //Effects rack
    strokeWeight(3);
    stroke(119, 96, 26);
    fill(150, 116, 0);
    //line(width-200, 0, width-200, height);
    rect(width-200, 0, 200, height);
    
    randomSeed(questSeed);
    for (int i = 0; i < 12+random(12); i++) {
      strokeWeight(1+random(1));
      stroke(67+random(40), 69, 8+random(16), 125);
      //stroke(100, 63, 22);
      
      float startX = width-200+random(200);
      float startY = 30+random(height-30-35-50);
      line(startX, startY, startX, startY + 50+random(100));
    }
    
    randomSeed(millis());
    
    fill(255);
    textAlign(LEFT);
    textSize(12);
    text("You have completed " + completedQuests + " quests.", width-185, 125);
    //0 price boost - weeks
    //1 enemy free - weeks
    //2 slow enemy - weeks, multi
    //3 reduce fee - id, multi
    //4 extra playtime - weeks
    //5 shop sale - weeks (although set to be 1 week, player can accumulate)
    if (effectTakingPlace[0][0] != 0) text("Boosting Honey Price (" + (int)effectTakingPlace[0][0] + (int(effectTakingPlace[0][0]) == 1 ? " week left)" : " weeks left)"), width-185, 125+15*2);
    if (effectTakingPlace[1][0] != 0) {
      if (enemyFree) {
        fill(0, 200, 0);
        text("No enemies - ON (" + (int)effectTakingPlace[1][0] + (int(effectTakingPlace[1][0]) == 1 ? " week left)" : " weeks left)"), width-185, 125+15*3);
        if (toggleEnemyTimer >= 30000) {
          toggleEnemyFree.updateGreyOut(false);
        }

        if (roundTime != 0) chargeBar(width-180, 125+15*6+3, 140, 5, color(60, 120, 0), toggleEnemyTimer, 30000, false, false, false, true);
        //println(toggleEnemyTimer);
      } else {
        fill(200, 0, 0);
        text("No enemies - OFF (" + (int)effectTakingPlace[1][0] + (int(effectTakingPlace[1][0]) == 1 ? " week left)" : " weeks left)"), width-185, 125+15*3);
        if (hornets.size() + fireflies.size() > 0) toggleEnemyFree.updateGreyOut(false);
      }

      if (roundTime == 0) {
        toggleEnemyFree.updateGreyOut(false);
        if (toggleEnemyTimer != 30000) toggleEnemyTimer = 30000;
      }
      toggleEnemyFree.Draw();
    }
    fill(255);
    textAlign(LEFT);
    textSize(12);
    if (effectTakingPlace[2][0] != 0) text("Slow enemies (" + (int)effectTakingPlace[2][0] + (int(effectTakingPlace[2][0]) == 1 ? " week left)" : " weeks left)"), width-185, 125+15*7);
    if (effectTakingPlace[4][0] != 0) text("Extra playtime (" + (int)effectTakingPlace[4][0] + (int(effectTakingPlace[4][0]) == 1 ? " week left)" : " weeks left)"), width-185, 125+15*8);
    if (effectTakingPlace[5][0] != 0) text("Shop sale (" + (int)effectTakingPlace[5][0] + (int(effectTakingPlace[5][0]) == 1 ? " week left)" : " weeks left)"), width-185, 125+15*9);
    
    text("Enemies Killed: " + questEnemyProg, width-185, 125+15*20);
  }
}

void updateQuest() { //optimally, only "update" when clicked in quest screen
  if (week < 10) questEnemyProg = 0; //im lazy. just reset the value here.

  boolean[] questExpired = {false, false};
  for (int i = 0; i < questExpired.length; i++) {
    if (week > questDeadlineWeek[i]) {
      questExpired[i] = true;
      if (i == 0) quest1.updateGreyOut(true);
      else if (i == 1) quest2.updateGreyOut(true);
    }
  }
  if (questExpired[0] && questExpired[1]) {
    gameOver = true;
    return; //no need to run the rest.
  }

  for (int i = 0; i < questDone.length; i++) {
    if (questExpired[i]) break;
    for (int x = 3; x <= 5; x += 2) {
      for (int k = 0; k < questDone[i][x].length; k++) {
        questDone[i][x][k] = false; //resetting all entity/resource quest progress to false (because the player might have sold the object)
      }
    }
  }

  rewardSelectedID = -1;

  for (int i = 0; i < questDone.length; i++) {
    if (questExpired[i]) break;
    for (int j = 0; j < questDone[i].length; j++) {
      int[] invResType = {-1, -1, -1, -1, -1, -1, -1, -1}; //prevention: inv res only use one time. then discard (-1)
      if (j == 5) { //resource
        for (int res = inventoryResources.size()-1; res >= 0; res--) {
          Resource r = inventoryResources.get(res);
          invResType[res] = r.getType();
        }
      }

      int[] invBeeType = new int[bees.size()];
      int[] invGuardType = new int[guardians.size()];
      if (j == 3) { //entity
        for (int bee = bees.size()-1; bee >= 0; bee--) {
          Bee b = bees.get(bee);
          invBeeType[bee] = b.getBeeType();
        }
        for (int guard = guardians.size()-1; guard >=0; guard--) {
          Guardian g = guardians.get(guard);
          invGuardType[guard] = g.getGuardianType();
        }
      }


      for (int k = 0; k < questDone[i][j].length; k++) {
        if (questType[i][j]) {
          switch (j) {
          case 0: //honey
            if (honeyKg >= questReq[i][j][k]) questDone[i][j][k] = true;
            break;
          case 1: //money
            if (money >= questReq[i][j][k]) questDone[i][j][k] = true;  
            break;
          case 2: //forest
            //done in forest entry. however, that only checks valid forests (invalid = -1)
            if (questReq[i][j][k] == -1) questDone[i][j][k] = true;
            break;
          case 3: //obtain entity
            //(see resource for explanation)
            if (questReq[i][j][k*2] == 1) { //bee
              for (int x = 0; x < invBeeType.length; x++) {
                if (questReq[i][j][k*2+1] == invBeeType[x]) {
                  invBeeType[x] = -1;
                  questDone[i][j][k] = true;
                  break;
                }
              }
            } else if (questReq[i][j][k*2] == 0) { //guardian
              for (int x = 0; x < invGuardType.length; x++) {
                if (questReq[i][j][k*2+1] == invGuardType[x]) {
                  invGuardType[x] = -1;
                  questDone[i][j][k] = true;
                  break;
                }
              }
            } else if (questReq[i][j][k*2] == -1) { //not specificed - not required
              questDone[i][j][k] = true;
            }
            break;
          case 4: //kill enemy
            if (questEnemyProg >= questReq[i][j][k]) questDone[i][j][k] = true;
            break;
          case 5: //acquire resource 
            for (int x = 0; x < invResType.length; x++) {
              if (questReq[i][j][k] == invResType[x]) { //no need  && questDone[i][j][k] == false because it's ofc false... (iterating k)
                invResType[x] = -1; //"discard" it
                questDone[i][j][k] = true; //this is kinda smart because in invResType, un-set values (i.e. player doesn't have a resource in that slot) are -1. In questReq, un-set reqs are also -1.
                break; //only check once.
              }
            }
            break;
          }
        } /*else questDone[i][j][k] = true; //un-set quest types are considered "finished"*/
      }
    }
  }

  for (int t = 0; t < questDeadlineWeek.length; t++) { //2
    if (questExpired[t]) break;

    int stopLine = 0;
    for (int x = 1; x < questDetail[t].length; x++) {
      if (questDetail[t][x].equals("Difficulty: ")) {
        stopLine = x-2; //2 space lines before "difficulty"
      }
    }

    boolean allDone = true;
    for (int x = 1; x < stopLine; x++) {
      int questType = -1;
      String questDesLine = questDetail[t][x];

      int startText = 3;
      if (questDesLine.substring(0, 1).equals("|")) startText += 2;

      if (questDesLine.substring(startText, startText+4).equals("Gath")) questType = 0;
      else if (questDesLine.substring(startText, startText+4).equals("Earn")) questType = 1;
      else if (questDesLine.substring(startText, startText+4).equals("Ente")) questType = 2;
      else if (questDesLine.substring(startText, startText+4).equals("Obta")) questType = 3;
      else if (questDesLine.substring(startText, startText+4).equals("Kill")) questType = 4;
      else if (questDesLine.substring(startText, startText+4).equals("Acqu")) questType = 5;
      else {
        println("Quest type cannot be determined...? : " + questDesLine); 
        continue;
      }

      boolean done = true;
      for (int k = 0; k < questDone[t][questType].length; k++) {
        if (questDone[t][questType][k] == false) {
          done = false;
          allDone = false;
          break;
        }
      }

      if (done) { //either already done or refreshed to done
        if (questDesLine.substring(0, 1).equals("|") == false) questDetail[t][x] = "|G" + questDesLine; //refreshed to done case
        // no need to do anything if it's already done.
      } else { //either not done or "un-finished" 
        if (questDesLine.substring(0, 1).equals("|")) questDetail[t][x] = questDesLine.substring(2); //"un-finished" case
        // no need to do anything if it's not done.
      }
    }

    if (allDone) {
      if (t == 0) quest1.updateGreyOut(false);
      else if (t == 1) quest2.updateGreyOut(false);
    } else {
      if (t == 0) quest1.updateGreyOut(true);
      else if (t == 1) quest2.updateGreyOut(true);
    }
  }
}

boolean questCompleted = false; //the player has to complete an 10-week quest first.
int questSeed = (int)random(0, 4095);
int assignedQuestWeek = 10;
void assignQuest() {
  println("the following quests are generated using this seed: " + questSeed);
  //if (week >= questDeadlineWeek[0] && questCompleted) {

  //<start> initializing
  for (int i = 0; i < questReq.length; i++) {
    for (int j = 0; j < questReq[i].length; j++) {
      questType[i][j] = false;
      questDiff[i][j] = 0;
      for (int k = 0; k < questReq[i][j].length; k++) {
        if (j == 0 || j == 1 || j == 4) questReq[i][j][k] = 0;
        else if (j == 3) {
          if (k % 2 == 0) questReq[i][j][k] = -1;
          else questReq[i][j][k] = 0;
        } else questReq[i][j][k] = -1;
      }
    }
  }
  //for (int i = 0; i < questReq.length; i++) {
  //  for (int j = 0; j < questReq[i].length; j++) {
  //    questType[i][j] = false;
  //    questDiff[i][j] = 0;
  //  }
  //}
  for (int i = 0; i < rewardFloat.length; i++) {
    for (int j = 0; j < rewardFloat[i].length; j++) {
      for (int k = 0; k < rewardFloat[i][j].length; k++) {
        if (j == 0 || j == 1 || j == 5 || j == 6 || (j == 7 && k == 0) || (j == 8 && k == 0) || j == 10) rewardFloat[i][j][k] = 0;
        else rewardFloat[i][j][k] = -1;
      }
    }
  }
  for (int i = 0; i < rewardGet.length; i++) {
    for (int j = 0; j < rewardGet[i].length; j++) {
      rewardGet[i][j] = false;
    }
  }
  for (int i = 0; i < questDone.length; i++) {
    for (int j = 0; j < questDone[i].length; j++) {
      for (int k = 0; k < questDone[i][j].length; k++) {
        questDone[i][j][k] = false;
      }
    }
  }
  //for (int i = 0; i < questOverallDiff.length; i++) {
  //  questOverallDiff[i] = -1;
  //}

  //<end> initializing

  if (loadingSave == false) assignedQuestWeek = week;

  randomSeed(questSeed);
  for (int j = 0; j < questType.length; j++) { //2
    int questDurationWeek = 0;
    int questChances = min(completedQuests/2, questType[j].length);

    boolean focusQuest; //focusQuest means: objective has only 1 type, but more difficult
    if (j == 0) focusQuest = true;
    else focusQuest = false;

    int focusQuestType = -1;
    if (focusQuest) focusQuestType = (int)random(0, 3) == 2 ? 4 : (int)random(0, 2);

    float questMulti = 0, temp = 2;
    float nondivQuest = 0;
    for (int i = 0; i <= questChances; i++) {
      int assignQuestType = (int)random(0, 6);
      //int assignQuestType = 3; //for debug
      //while (questType[j][assignQuestType]) assignQuestType = (int)random(0, 6); //discarded. types can be repeated, with additive req.

      if (focusQuest) {
        assignQuestType = focusQuestType; //focusQuests can only be "additive" quests. (For now)
        println("focusing on type " + assignQuestType + ", with " + (questChances+1) + " chances");
      }

      questType[j][assignQuestType] = true;

      int duration = -1, difficulty = -1;
      switch (assignQuestType) {
        //dividable req
      case 0:
      case 1:
      case 4:
        questMulti += temp * 0.5;
        temp *= 0.5;
        break;

      case 2:
      case 3:
      case 5:
        questMulti += temp * 0.75;
        //nondivQuest += temp2*0.5;
        temp *= 0.75;
        break;
      }
      switch (assignQuestType) {
      case 0: //honey
        duration = (int)random(2, 5);
        if (focusQuest == false) difficulty = (int)random(max(1, completedQuests/2.5), min(max(1, completedQuests/2), 6));
        else difficulty = (int)random(max(1, completedQuests/2.25), min(max(1, completedQuests/1.25), 6));
        questDurationWeek += duration;
        questDiff[j][assignQuestType] += difficulty;
        if (focusQuest == false) questReq[j][assignQuestType][0] += int(map(constrain(week, 10, 50), 10, 50, 1, 3)*pow(duration, 0.75)*int(random(350, 450))*map(difficulty, 1, 5, 1, 2)); //formula needed
        else questReq[j][assignQuestType][0] += int(map(constrain(week, 10, 50), 10, 50, 1, 4)*pow(duration, 0.75)*int(random(375, 475))*map(difficulty, 1, 5, 1, 2.25)); //formula needed
        println("HONEY VARIABLES:");
        println(duration, difficulty);
        break;

      case 1: //money
        duration = (int)random(2, 5);
        if (focusQuest == false) difficulty = (int)random(max(1, completedQuests/2.5), min(max(1, completedQuests/2), 6));
        else difficulty = (int)random(max(1, completedQuests/2.25), min(max(1, completedQuests/1.25), 6));
        questDurationWeek += duration;
        questDiff[j][assignQuestType] += difficulty;
        if (focusQuest == false) questReq[j][assignQuestType][0] += int(map(constrain(week, 10, 50), 10, 50, 1, 3)*pow(duration, 0.75)*int(random(27.5, 40))*map(difficulty, 1, 5, 1, 2)) *1000; //formula needed
        else questReq[j][assignQuestType][0] += int(map(constrain(week, 10, 50), 10, 50, 1, 4)*pow(duration, 0.75)*int(random(32.5, 42.5))*map(difficulty, 1, 5, 1, 2.5)) *1000; //formula needed
        break;

      case 2: //forest
        int enterForests = min(2, int(completedQuests/3))+1; //max is 3 forests
        if (completedQuests < 2) questDurationWeek += 2;
        else questDurationWeek += 3;

        int beginX = 0;
        for (int x = 0; x < questReq[j][assignQuestType].length; x++) { //determining beginX
          if (questReq[j][assignQuestType][x] == -1) {
            beginX = x;
            println("forest beginX: " + beginX);
            break;
          }
        }
        if (beginX != 0) enterForests = 1; //if not initial assign, then only add 1 more entity

        if (beginX + enterForests > questReq[j][assignQuestType].length) { //if exceeds 3 forests (limit), then refresh this questChance to assign another quest.
          i--;
          println("forest exceeding. refreshing chances: " + i);
          break;
        }

        for (int x = beginX; x < beginX + enterForests; x++) {
          //below forestType: p0.85,(x+1) because forests might just repeat themselves which is boring/too difficult.
          int forestType = (int)(pow(0.85, x+1) * random(completedQuests/2 + (week-10)/4 + 3, min(forestName.length-1, int(completedQuests/2 +  (week-10)/4 + 5)))); //better formula needed
          println("forestType: " + forestType);
          if (forestType == 7 || forestType == 10) forestType += random(1) > 0.5 ? 1 : -1; //guardian school and jumbee valley don't exist; randomly up / down one tier
          questReq[j][assignQuestType][x] = forestType;

          //difficulty evaluation
          //---> done after all quests are assigned
          questDiff[j][assignQuestType] += forestBaseCost[forestType];
        }
        //sigmaDiff = sigmaDiff / enterForests; //<- doesnt make sense.
        break;

      case 3: //obtain specific entity
        duration = (int)random(2, 5);
        questDurationWeek += duration;

        int entNums = min(5, ceil(max(2, completedQuests/2))); // 5 quests = 3; might need to be adjusted.

        beginX = 0;
        for (int x = 0; x < questReq[j][assignQuestType].length; x+=2) { //determining beginX
          if (questReq[j][assignQuestType][x] == -1) {
            beginX = x;
            println("entity beginX: " + beginX);
            break;
          }
        }
        if (beginX != 0) entNums = 1; //if not initial assign, then only add 1 more entity

        if (beginX + entNums*2 > questReq[j][assignQuestType].length) { //if exceeds 5 entities (limit), then refresh this questChance to assign another quest.
          i--;
          println("entity exceeding. refreshing chances: " + i);
          break;
        }

        difficulty = 0;
        for (int x = beginX; x < beginX + entNums*2; x+=2) {
          int entType = (int)random(0, 2), type;
          if (entType == 0) { //guardian
            type = (int)random(1, 2+6);
            while (type == 5) type = (int)random(1, 2+6); //computer g doesnt exist

            if (type <= 1) difficulty += 1;
            else difficulty += 2;
          } else { //bee
            type = (int)random(3, 6+4);

            if (type <= 5) difficulty += 1;
            else difficulty += 3;
          }
          questReq[j][assignQuestType][x] = entType;
          questReq[j][assignQuestType][x+1] = type;
        }

        questDiff[j][assignQuestType] += difficulty;
        break;

      case 4: //enemies
        int duraWeek = (int)random(2, 5);
        if (focusQuest == false) difficulty = (int)random(1, min(max(1, completedQuests/1.5), 6));
        else difficulty = (int)random(max(1, completedQuests/1.7), min(max(1, completedQuests/1.05), 6));
        questDurationWeek += duraWeek;
        questDiff[j][assignQuestType] += difficulty;
        if (focusQuest == false) questReq[j][assignQuestType][0] += (pow(duraWeek, 0.65)+pow(duraWeek, 0.25)) * map(difficulty, 1, 5, 1, 3); //better formula needed
        else questReq[j][assignQuestType][0] += (pow(duraWeek, 0.65)+pow(duraWeek, 0.25)) * difficulty; //better formula needed
        break;

      case 5: //resource
        int resourceNums;
        if (completedQuests < 3) resourceNums = 2;
        else resourceNums = floor((completedQuests-3)/2)+3; //else if (completedQuests >= 3)
        resourceNums = constrain(resourceNums, 2, 8); //min 2 max 8

        beginX = 0;
        for (int x = 0; x < questReq[j][assignQuestType].length; x++) { //8
          if (questReq[j][assignQuestType][x] == -1) {
            beginX = x;
            println("resource beginX: " + beginX);
            break;
          }
        }
        if (beginX != 0) resourceNums = 1; // if not initial assign, then only add 1

        if (beginX + resourceNums > questReq[j][assignQuestType].length) { //if exceeds 8 resources (limit), then refresh this questChance to assign another quest.
          i--;
          println("resources exceeding. refreshing chances: " + i);
          break;
        }

        for (int x = beginX; x < beginX + resourceNums; x++) {
          int rnd = (int)random(16);
          while (rnd == 6 || rnd == 7 || rnd == 15) rnd = (int)random(16);
          questReq[j][assignQuestType][x] = rnd;
        }

        questDurationWeek += 1+int((resourceNums-2)/2);
        questDiff[j][assignQuestType] += max(3, resourceNums+1);
        break;
      }
    }

    //difficulty evaluation for forest
    if (questType[j][2]) {
      int avgMoneyObtainable = 35; //*1000 "35" is the avg money obtainable (further test needed)

      questDiff[j][2] = round(map((questDiff[j][2]-money)/1000/3 / avgMoneyObtainable, 0.5, 3, 1, 5))+1; //(round makes more sense)

      //Explanation:
      //-money because this is supposed to be calculating "how much more money the player has to earn"
      //"/1000/3" is how much money required per round, in order to get to that target amount;
    }

    questDurationWeek = round(questDurationWeek / (questChances+1) * questMulti);
    if (completedQuests == 0) questDeadlineWeek[j] = 10 + questDurationWeek;
    else questDeadlineWeek[j] = assignedQuestWeek + questDurationWeek;

    //offset req
    if (focusQuest) {
      float reqOffset = questMulti/(questChances+1);
      questReq[j][focusQuestType][0] *= reqOffset;
      if (focusQuestType == 1) { //money
        questReq[j][focusQuestType][0] = int(questReq[j][focusQuestType][0]/1000)*1000;
      }
    } else {
      float reqOffset = questMulti/(questChances+1-nondivQuest);
      for (int i = 0; i < questType[j].length; i++) {
        if (questType[j][i] && (i == 0 || i == 1 || i == 4)) {
          questReq[j][i][0] *= reqOffset;
          if (i == 1) { //money
            questReq[j][i][0] = int(questReq[j][i][0]/1000)*1000;
          }
        }
      }
    }







    int questTypes = 0;
    if (focusQuest) questTypes = 0; //focusQuest
    else {
      for (int x = 0; x < questType[j].length; x++) {
        if (questType[j][x]) questTypes++;
      }
      questTypes-=1; //compensation. annoying to explain lul
      //questTypes = int(min(completedQuests/2, questType[t].length));
    }

    String[] questContent = new String[1+questTypes+1]; //[1+]:heading [+1]:special treatment due to questTypes being weird (0 = 1)
    questContent[0] = "Quest:";
    int counter = 1;
    //println("completed: "+completedQuests);
    for (int i = 0; i < questType[j].length; i++) {
      if (questType[j][i]) {
        questReqString = "";

        if (i == 0 || i == 1 || i == 4) questReqString = str(questReq[j][i][0]);
        else if (i == 2) {
          for (int x = 0; x < questReq[j][i].length; x++) {
            int forestType = questReq[j][i][x];

            if (forestType != -1) questReqString += char(34) + forestName[questReq[j][i][x]] + char(34);

            if (x+1 >= questReq[j][i].length) break; //x+1 >= is the prevention of out of bounds
            if (questReq[j][i][x+1] == -1) break; //check before adding comma.
            else questReqString += ", ";
          }
        } else if (i == 3) {
          for (int x = 0; x < questReq[j][i].length; x+=2) {
            int entType = questReq[j][i][x], type = questReq[j][i][x+1];

            if (entType == 0) {
              if (type == 0 || type == 1) questReqString += guardianName[type];
              else questReqString += upgradedGuardianName[type-2];
            } else if (entType == 1) {
              if (type < 6) questReqString += beeName[type];
              else questReqString += upgradedBeeName[type-6];
            } else if (entType == -1) break;

            if (x+2 >= questReq[j][i].length) break; //x+2 >= is the prevention of out of bounds
            if (questReq[j][i][x+2] == -1) break; //check before adding comma.
            else questReqString += ", ";
          }
        } else if (i == 5) {
          for (int x = 0; x < questReq[j][i].length; x++) {
            int resType = questReq[j][i][x];

            if (resType != -1) questReqString += resourceName[questReq[j][i][x]];

            if (x+1 >= questReq[j][i].length) break; //x+1 >= is the prevention of out of bounds
            if (questReq[j][i][x+1] == -1) break; //check before adding comma.
            else questReqString += ", ";
          }
        }
        //questReqString += " (" + questDiff[j][i] + ")"; //debug

        refreshQuestDescription();
        questContent[counter] = questDescription[i];
        counter++;
      }
    }

    //int avgDiff = 0;
    //for (int s = 0; s < questDiff[j].length; s++) {
    //  if (questDiff[j][s] != 0) avgDiff += questDiff[j][s];
    //}

    //String diffStars = "";
    //for (int a = 0; a < avgDiff; a++) diffStars += "★"; //solid
    //for (int a = avgDiff; a < 5; a++) diffStars += "☆"; //empty

     String[] defaultDes = {"", "", "Difficulty: " /*+ diffStars*/    , "", "", "Deadline: Week " + questDeadlineWeek[j], "", "Reward:"};
    String[] wholeDes = concat(questContent, defaultDes);





    int questRewards = int(min(max(1, completedQuests/2), 3)); //4- = 1, 4 = 2, 6+ = 3
    int sumDiff = 0;
    for (int s = 0; s < questDiff[j].length; s++) {
      if (questDiff[j][s] != 0) sumDiff += questDiff[j][s];
    }
    boolean[] eliReward = new boolean[15];
    for (int e = 0; e < eliReward.length; e++) eliReward[e] = true;

    //<BEGIN> Deny reward type: Difficulty Dependent
    if (sumDiff < 3) eliReward[10] = false; //Extra time per round
    if (sumDiff < 5) {
      eliReward[5] = false; //Price Boost
      eliReward[6] = false; //Enemy Free
    }
    if (sumDiff < 8) eliReward[14] = false; //perma speed buff
    //<END> Deny reward type: Difficulty Dependent

    //<BEGIN> Deny reward type: Miscell
    if (beehiveTier < 3) eliReward[9] = false; //Unlock extra hive size

    if (honeyPotTier == honeyPotPrice.length-1 || 
      (sumDiff < 20 && honeyPotTier == 5) ||
      (sumDiff < 15 && honeyPotTier == 4) ||
      (sumDiff < 8 && honeyPotTier == 3) ||
      rewardFloat[j][4][0] != -1) eliReward[4] = false; //pot upgrade

    for (int t = 8; t <= 14; t++) {
      if (t == 10) continue;
      if (rewardFloat[j][t][0] != -1) eliReward[t] = false;
    }
    //<END> Deny reward type: Miscell

    //<BEGIN> Deny reward type: Quest Dependent
    //Quest: only honey
    if (questType[j][0] && !questType[j][1] && !questType[j][2] && !questType[j][3] && !questType[j][4] && !questType[j][5]) {
      eliReward[1] = false; //honey
      eliReward[3] = false; //guardian
    }
    //Quest: only money
    if (!questType[j][0] && questType[j][1] && !questType[j][2] && !questType[j][3] && !questType[j][4] && !questType[j][5]) {
      eliReward[0] = false; //money
      eliReward[2] = false; //bee
    }
    //Quest: NO FOREST
    if (!questType[j][2]) eliReward[8] = false; //forest fee reduction
    //Quest: NO ENTITY / NO RESOURCE
    if (!questType[j][3] || !questType[j][5]) {
      eliReward[12] = false; //resource rnd
      eliReward[13] = false; //resource exchange
    }
    //Quest: NO ENEMY
    if (!questType[j][4]) {
      eliReward[6] = false; //enemy free
      eliReward[7] = false; //slower enemy
    }
    //<END> Deny reward type: Quest Dependent

    for (int r = 0; r < questRewards; r++) {
      int rewardType = (int)random(1, 15);
      while (eliReward[rewardType] == false) rewardType = (int)random(1, 15);
      rewardGet[j][rewardType] = true;

      int rewardBefore = int(rewardString);
      switch (rewardType) {
      case 0: //money
        rewardFloat[j][rewardType][0] += int(rewardBefore + random(17500, 22500) * map(sumDiff, 1, 10, 1, 2) / questRewards);
        break;
      case 1: //honey
        rewardFloat[j][rewardType][0] += int(rewardBefore + random(225, 275) * map(sumDiff, 1, 10, 1, 2) / questRewards);
        break;
      case 2: //bee
        for (int x = 0; x < rewardFloat[j][rewardType].length; x++) {
          if (rewardFloat[j][rewardType][x] == -1) {
            boolean upgraded = false;
            if (sumDiff >= 9) upgraded = true;

            if (upgraded) rewardFloat[j][rewardType][x] = beeName.length+(int)random(0, upgradedBeeName.length);
            else rewardFloat[j][rewardType][x] = (int)random(3, beeName.length);
            break;
          }
        }
        break;
      case 3: //guardian
        for (int x = 0; x < rewardFloat[j][rewardType].length; x++) {
          if (rewardFloat[j][rewardType][x] == -1) {
            boolean upgraded = false;
            if (sumDiff >= 5) upgraded = true;

            if (upgraded) rewardFloat[j][rewardType][x] = guardianName.length+(int)random(0, upgradedGuardianName.length);
            else rewardFloat[j][rewardType][x] = 1;

            while (rewardFloat[j][rewardType][x] == 5) rewardFloat[j][rewardType][x] = guardianName.length+(int)random(0, upgradedGuardianName.length);
            break;
          }
        }
        break;
      case 4: //pot ugprade
        rewardFloat[j][rewardType][0] = honeyPotTier+1;
        break;
      case 5: //price boost
        rewardFloat[j][rewardType][0] += (int)random(max(1, sumDiff/12), min(3, max(1, sumDiff/6)));
        break;
      case 6: //enemy free
        rewardFloat[j][rewardType][0] += (int)random(max(1, sumDiff/12), min(2, max(1, sumDiff/6)));
        break;
      case 7: //freeze enemy
        rewardFloat[j][rewardType][0] += (int)random(max(1, sumDiff/10), min(3, max(1, sumDiff/6))); //week

        if (rewardFloat[j][rewardType][1] == -1) rewardFloat[j][rewardType][1] = 0.75; //initial
        else rewardFloat[j][rewardType][1] -= sumDiff/100;

        if (rewardFloat[j][rewardType][1] < 0.25) rewardFloat[j][rewardType][1] = 0.25; //constraint
        break;
      case 8: //forest fee reduction
        rewardFloat[j][rewardType][0] += (int)random(max(1, sumDiff/12), min(2, max(1, sumDiff/6))); //week

        if (rewardFloat[j][rewardType][1] == -1) rewardFloat[j][rewardType][1] = 0.5; //initial
        else rewardFloat[j][rewardType][1] -= sumDiff/70;

        if (rewardFloat[j][rewardType][1] < 0.25) rewardFloat[j][rewardType][1] = 0.25; //constraint 
        break;
        //case 9: //unlock extra hive space (25)
        //self explanatory
        //break;
      case 10: //extra time in a round
        rewardFloat[j][rewardType][0] += (int)random(max(1, sumDiff/12), min(2, max(1, sumDiff/6))); //week
        break;
        //case 11: //shop sale 1 week
        //self explanatory
        //break;
        //case 12: //3 resources at rnd (dump 2)
        //self explanatory
        //break;
        //case 13: //1 for 1 resource
        //self explanatory
        //break;
        //case 14: //perma speed buff
        //self explanatory
        //break;
      }
    }



    int actualRewards = 0;
    for (int g = 0; g < rewardGet[j].length; g++) {
      if (rewardGet[j][g]) actualRewards++;
    }
    String[] rewardContent = new String[actualRewards];
    counter = 0;
    for (int type = 0; type < rewardGet[j].length; type++) {
      if (rewardGet[j][type]) {
        rewardString = "";

        switch (type) {
        case 0: //money
        case 1: //honey
        case 4: //pot ugprade
        case 5: //price boost
        case 6: //enemy free
        case 7: //freeze enemy
        case 8: //forest fee reduction
        case 10: //extra time in a round
          rewardString = str(int(rewardFloat[j][type][0]));
          break;
        case 2: //bee
          for (int x = 0; x < rewardFloat[j][type].length; x++) {
            if (rewardFloat[j][type][x] != -1) {
              boolean upgraded = true;
              if (rewardFloat[j][type][x] < beeName.length) upgraded = false;

              if (x != 0) rewardString += ", ";
              if (upgraded) rewardString += upgradedBeeName[int(rewardFloat[j][type][x])-beeName.length];
              else rewardString += beeName[int(rewardFloat[j][type][x])];
            } else break;
          }
          break;
        case 3: //guardian
          for (int x = 0; x < rewardFloat[j][type].length; x++) {
            if (rewardFloat[j][type][x] != -1) {
              boolean upgraded = true;
              if (rewardFloat[j][type][x] == 1) upgraded = false;

              if (x != 0) rewardString += ", ";
              if (upgraded) rewardString += upgradedGuardianName[int(rewardFloat[j][type][x])-guardianName.length];
              else rewardString += guardianName[int(rewardFloat[j][type][x])];
            } else break;
          }
          break;
        }
        refreshRewardDescription();
        rewardContent[counter] = rewardDescription[type];
        counter++;
      }
    }


    wholeDes = concat(wholeDes, rewardContent);
    printArray(wholeDes);

    questDetail[j] = wholeDes;
  }
  //} //note: dont remove!

  randomSeed(System.currentTimeMillis());
}

void claimReward(int _q) {
  int q = _q;
  if (q != -1) {
    for (int j = 0; j < questType[q].length; j++) {
      if (questType[q][j]) {
        if (j == 0) honeyKg -= questReq[q][j][0];
        else if (j == 1) money -= questReq[q][j][0];
      }
    }

    for (int j = 0; j < rewardGet[q].length; j++) {
      if (rewardGet[q][j]) {
        switch (j) {
        case 0: //money
          money += rewardFloat[q][j][0];
          break;
        case 1: //honey
          if (rewardFloat[q][j][0]+honeyKg > honeyPotCapKg[honeyPotTier]) honeyKg = honeyPotCapKg[honeyPotTier];
          else honeyKg += rewardFloat[q][j][0];
          break;
        case 2: //bee
          for (int k = 0; k < rewardFloat[q][j].length; k++) {
            if (rewardFloat[q][j][k] == -1) break;
            bees.add(new Bee((int)rewardFloat[q][j][k]));
            inventoryBees.add(new Bee((int)rewardFloat[q][j][k]));
            inventoryBees.get(inventoryBees.size()-1).updateMoveTheta(HALF_PI);
            inventoryBees.get(inventoryBees.size()-1).updateForShop(true);
          }
          break;
        case 3: //guardian
          for (int k = 0; k < rewardFloat[q][j].length; k++) {
            if (rewardFloat[q][j][k] == -1) break;
            else if (rewardFloat[q][j][k] <= 1) guardians.add(new Guardian(guardianName[(int)rewardFloat[q][j][k]]));
            else guardians.add(new Guardian(upgradedGuardianName[(int)rewardFloat[q][j][k]-2]));
            if (rewardFloat[q][j][k] <= 1) inventoryGuardians.add(new Guardian(guardianName[(int)rewardFloat[q][j][k]]));
            else inventoryGuardians.add(new Guardian(upgradedGuardianName[(int)rewardFloat[q][j][k]-2]));
            inventoryGuardians.get(inventoryGuardians.size()-1).updateShouldGuardianMove(false);
          }
          break;
        case 4: //pot upgrade
          honeyPotTier++;
          break;
        case 5: //price boost
          effectTakingPlace[0][0] += rewardFloat[q][j][0];
          break;
        case 6: //enemy free (x weeks)
          effectTakingPlace[1][0] += rewardFloat[q][j][0];
          break;
        case 7: //freeze enemy
          effectTakingPlace[2][0] += rewardFloat[q][j][0];
          effectTakingPlace[2][1] = rewardFloat[q][j][1];
          break;
        case 8: //reduce forest entrance fee
          forestCost[(int)rewardFloat[q][j][0]] *= rewardFloat[q][j][1];
          break;
        case 9: //unlock extra hive space
          beehiveTier++;
          break;
        case 10: //extra time in a round
          ROUND_TIME = 240000;
          effectTakingPlace[4][0] += rewardFloat[q][j][0];
          break;
        case 11: //shop sale 1 round
          if (effectTakingPlace[5][0] == 0) shopSaleInitiate();
          effectTakingPlace[5][0] += 1;
          break;
        case 12: //3 resource at random, dump 2
        case 13: //1 specific resource, dump 1
        case 14: //perm speed buff to 1 guardian
          rewardSelection[j-12] = true;
          break;
        }
      }
    }

    questEnemyProg = 0;
    for (int x = 0; x < questDiff[q].length; x++) questDiffSum += questDiff[q][x];

    completedQuests += 1;
    randomSeed(millis());
    questSeed = (int)random(0, 4095);
    assignQuest();
    updateQuest();
  }

  if (rewardSelection[0] || rewardSelection[1]) {
    resetItemInvPositions();
    itemInvSelected = -1;
    screenDisable();
    itemInventoryScreenActive = true;
  } else if (rewardSelection[2]) {
    resetGuardianInvPositions();
    guardianInvSelected = -1;
    screenDisable();
    guardianInventoryScreenActive = true;
  }
}

void shopSaleInitiate() {
  int[] _beeCost = {300/10*6, 1000/10*6, 5000/10*6, 10000/10*6, 15000/10*6, 50000/10*6 /*, not for sale*/};
  int[] _guardianCost = {8000/10*6, 18000/10*6 /*, not for sale*/};
  int[] _honeyPotPrice = {0, 1000/10*6, 3500/10*6, 12000/10*6, 30000/10*6, 120000/10*6, 800000/10*6};
  int[] _beehivePrice = {0, 3000/10*6, 5000/10*6, 8000/10*6, 9999999};
  int[] _upgradeBeeCost = {70000/10*6, 55000/10*6, 90000/10*6, 70000/10*6}; //money
  float[][] _upgradeGuardianCost = {{75000/10*6, 1}, {65000/10*6, 1}, {100000/10*6, 1}, {11500000, 2}, {75000/10*6, 1}, {70000/10*6, 0.5}}; //money, week

  beeCost = _beeCost;
  guardianCost = _guardianCost;
  honeyPotPrice = _honeyPotPrice;
  beehivePrice = _beehivePrice;
  upgradeBeeCost = _upgradeBeeCost;
  upgradeGuardianCost = _upgradeGuardianCost;
}

void shopSaleReset() {
  int[] _beeCost = {300, 1000, 5000, 10000, 15000, 50000 /*, not for sale*/};  
  int[] _guardianCost = {8000, 18000 /*, not for sale*/};
  int[] _honeyPotPrice = {0, 1000, 3500, 12000, 30000, 120000, 800000};
  int[] _beehivePrice = {0, 3000, 5000, 8000, 9999999};
  int[] _upgradeBeeCost = {70000, 55000, 90000, 70000}; //money
  float[][] _upgradeGuardianCost = {{75000, 1}, {65000, 1}, {100000, 1}, {11500000, 2}, {75000, 1}, {70000, 0.5}}; //money, week

  beeCost = _beeCost;
  guardianCost = _guardianCost;
  honeyPotPrice = _honeyPotPrice;
  beehivePrice = _beehivePrice;
  upgradeBeeCost = _upgradeBeeCost;
  upgradeGuardianCost = _upgradeGuardianCost;
}