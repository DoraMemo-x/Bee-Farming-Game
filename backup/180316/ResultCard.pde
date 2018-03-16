int enemyElimScore = 0;
int questDiffSum = 0;
int totalHoneyCollected = 0, honeyOverflown = 0;
int beeDeaths = 0;
int purchasesDone = 0; //not including upgrades
int flowersDepleted = 0;
long enemyAliveTime = 0;
int trainingsCompleted = 0;

int tact_PreventOverflow = 0; //selling partial of honey to prevent honey pot overflow
int tact_SellEntity = 0; //sell entity to prevent upgrading beehive
int tact_SkipTier = 0; //(score) skipped honey pot / beehive tier


int debugRating = 0;
void showStats() { //game over stats
  topStatsBar(); 
  fill(0); 
  textAlign(CENTER); 
  textSize(100); 
  text("GAME OVER!", width/2, height*0.4); 
  textAlign(LEFT); 
  textSize(16);
  fill(0);
  text("Primary Stats:", width*0.083, height*0.4+50+21*1);
  text("Secondary Stats:", width*0.4, height*0.4+50+21*1);

  float totalBalance = money + honeyKg * honeyPrice;
  for (int b = bees.size()-1; b >= 0; b--) {
    int beeType = bees.get(b).getBeeType();
    boolean isBeeAlive = bees.get(b).getIsAlive();
    if (beeType < beeName.length) {
      if (isBeeAlive) totalBalance += beeSellCost[beeType];
      else totalBalance += (int)sqrt(beeSellCost[beeType])*3;
    } else {
      int spType = beeType - beeName.length;
      if (isBeeAlive) totalBalance += upgradeBeeCost[spType]/2;
      else totalBalance += (int)sqrt(upgradeBeeCost[spType]/2)*3;
    }
  }
  for (int g = guardians.size()-1; g >= 0; g--) {
    int guardianType = guardians.get(g).getGuardianType();
    guardians.remove(g);
    if (guardianType <= 1) totalBalance += guardianSellCost[guardianType]; // normal ones
    else totalBalance += upgradeGuardianCost[guardianType-2][0]/2; //training ones
  }
  for (int i = inventoryResources.size()-1; i >= 0; i--) {
    totalBalance += resourcePrice[inventoryResources.get(i).getType()];
  }

  //Each category has 10 rating points. The higher the better
  float normRating = 0;
  if (week-1 <= 4) normRating += 1;
  else if (week-1 <= 8) normRating += 2;
  else if (week-1 <= 12) normRating += 3;
  else if (week-1 >= 60) normRating += 10;
  else normRating += map(week-1, 12, 60, 3, 10);

  if (totalHoneyCollected <= 350) normRating += 1;
  else if (totalHoneyCollected <= 700) normRating += 2;
  else if (totalHoneyCollected <= 1250) normRating += 3;
  else if (totalHoneyCollected >= 100000) normRating += 10;
  else normRating += map(totalHoneyCollected, 1250, 950000, 3, 9.5);

  if (totalBalance <= 7500) normRating += 1;
  else if (totalBalance <= 15000) normRating += 2;
  else if (totalBalance <= 30000) normRating += 3;
  else if (totalBalance > 2500000) normRating += 10;
  else normRating += map(totalBalance, 30000, 2500000, 3, 10);

  if (completedQuests == 0) normRating += 0;
  else if (completedQuests == 1) normRating += 1;
  else if (completedQuests >= 8) normRating += 10;
  else normRating += map(completedQuests, 1, 8, 1, 10);



  //Ratings   SS     S      S-     A+     A      A-     B+     B      B-     C+     C      C-    D    E    F
  //Score     39-40  37-38  35-36  32-34  30-31  26-29  23-25  18-22  16-17  13-15  10-12  8-10  6-7  4-5
  normRating += debugRating;
  String visualRatingPrim = "";
  if (normRating >= 39) visualRatingPrim = "SS";
  else if (normRating >= 37) visualRatingPrim = "S";
  else if (normRating >= 35) visualRatingPrim = "S-";
  else if (normRating >= 32) visualRatingPrim = "A+";
  else if (normRating >= 30) visualRatingPrim = "A";
  else if (normRating >= 26) visualRatingPrim = "A-";
  else if (normRating >= 23) visualRatingPrim = "B+";
  else if (normRating >= 18) visualRatingPrim = "B";
  else if (normRating >= 16) visualRatingPrim = "B-";
  else if (normRating >= 13) visualRatingPrim = "C+";
  else if (normRating >= 10) visualRatingPrim = "C";
  else if (normRating >= 8) visualRatingPrim = "C-";
  else if (normRating >= 6) visualRatingPrim = "D";
  else if (normRating >= 4) visualRatingPrim = "E";
  else visualRatingPrim = "F";



  float secRating = 0;
  if (enemyElimScore < 15) secRating += 1;
  else if (enemyElimScore < 30) secRating += 2.5;
  else if (enemyElimScore >= 750) secRating += 10;
  else secRating += map(enemyElimScore, 30, 750, 2.5, 10);

  if (enemyAliveTime / (enemyElimScore+1) < 300) secRating += 8;
  else if (enemyAliveTime / (enemyElimScore+1) < 600) secRating += 7;
  else if (enemyAliveTime / (enemyElimScore+1) > 10000) secRating += 0;
  else secRating += map(enemyAliveTime / (enemyElimScore+1), 600, 10000, 7, 0);

  if (beeDeaths < 2) secRating += 6;
  else if (beeDeaths < 5) secRating += 5;
  else if (beeDeaths >= 20) secRating += 0;
  else if (beeDeaths >= 17) secRating += 1;
  else secRating += map(beeDeaths, 5, 17, 5, 1);

  if (honeyOverflown < 30) secRating += 5;
  else if (honeyOverflown <= 80) secRating += 4;
  else if (honeyOverflown > 2000) secRating += 0;
  else if (honeyOverflown > 1500) secRating += 1;
  else secRating += map(honeyOverflown, 80, 1500, 4, 1);

  if (questDiffSum < 8) secRating += 1;
  else if (questDiffSum < 15) secRating += 2;
  else if (questDiffSum >= 100) secRating += 4;
  else secRating += map(questDiffSum, 15, 100, 2, 4);

  if (trainingsCompleted == 0) secRating += 0;
  else if (trainingsCompleted <= 2) secRating += 1;
  else if (trainingsCompleted >= 8) secRating += 3;
  else secRating += map(trainingsCompleted, 2, 8, 1, 3);

  if (flowersDepleted < 50) secRating += 0;
  else if (flowersDepleted <= 100) secRating += 1;
  else if (flowersDepleted >= 500) secRating += 2;
  else secRating += map(flowersDepleted, 100, 500, 1, 2);

  if (purchasesDone <= 5) secRating += 1;
  else if (purchasesDone >= 20) secRating += 2;
  else secRating += map(purchasesDone, 5, 20, 1, 2);

  String visualRatingSec = "";
  if (secRating >= 39) visualRatingSec = "SS";
  else if (secRating >= 37) visualRatingSec = "S";
  else if (secRating >= 35) visualRatingSec = "S-";
  else if (secRating >= 32) visualRatingSec = "A+";
  else if (secRating >= 30) visualRatingSec = "A";
  else if (secRating >= 26) visualRatingSec = "A-";
  else if (secRating >= 23) visualRatingSec = "B+";
  else if (secRating >= 18) visualRatingSec = "B";
  else if (secRating >= 16) visualRatingSec = "B-";
  else if (secRating >= 13) visualRatingSec = "C+";
  else if (secRating >= 10) visualRatingSec = "C";
  else if (secRating >= 8) visualRatingSec = "C-";
  else if (secRating >= 6) visualRatingSec = "D";
  else if (secRating >= 4) visualRatingSec = "E";
  else if (secRating >= 0) visualRatingSec = "F";



  if (week-1 >= 60) fill(215, 255, 215);
  else fill(255);
  text("  You worked for: " + (week-1) + (week-1 == 1 ? " week" : " weeks"), width*0.083, height*0.4+50+21*2);  //-1 because week is now added right after entering forest.
  if (totalHoneyCollected >= 100000) fill(215, 255, 215);
  else fill(255);
  text("  Honey Collected: " + totalHoneyCollected + "kg", width*0.083, height*0.4+50+21*3);
  if (totalBalance > 2500000) fill(215, 255, 215);
  else fill(255);
  text("  Net Gain: $" + nfc((int)totalBalance), width*0.083, height*0.4+50+21*4);
  if (completedQuests >= 8) fill(215, 255, 215);
  else fill(255);
  text("  Quests completed: " + completedQuests, width*0.083, height*0.4+50+21*5);
  fill(255);
  text("  Primary Rating: ", width*0.083, height*0.4+50+21*8);

  if (enemyElimScore >= 750) fill(215, 255, 215);
  else fill(255);
  text("  Enemy Elimination Score: " + enemyElimScore, width*0.4, height*0.4+50+21*2);
  if (enemyAliveTime / (enemyElimScore+1) < 300)  fill(215, 255, 215);
  else fill(255);
  text("  Enemy Alive Time: " + enemyAliveTime/1000 + "s", width*0.4, height*0.4+50+21*3);
  if (beeDeaths < 2) fill(215, 255, 215);
  else fill(255);
  text("  Bee Deaths: " + beeDeaths, width*0.4, height*0.4+50+21*4);
  if (honeyOverflown < 30) fill(215, 255, 215);
  else fill(255);
  text("  Overflown Honey: " + honeyOverflown + "kg", width*0.4, height*0.4+50+21*5);
  if (questDiffSum >= 100) fill(215, 255, 215);
  else fill(255);
  text("  Quest Difficulty Sigma: " + questDiffSum, width*0.4, height*0.4+50+21*6);
  if (trainingsCompleted >= 8) fill(215, 255, 215);
  else fill(255);
  text("  Trainings Completed: " + trainingsCompleted, width*0.4, height*0.4+50+21*7);
  if (flowersDepleted >= 500) fill(215, 255, 215);
  else fill(255);
  text("  Flowers Depleted: " + flowersDepleted, width*0.4, height*0.4+50+21*8);
  if (purchasesDone >= 20) fill(215, 255, 215);
  else fill(255);
  text("  Purchases Done: " + purchasesDone, width*0.4, height*0.4+50+21*9);
  fill(255);
  text("  Secondary Rating: ", width*0.4, height*0.4+50+21*12);

  fill(0);
  textAlign(CENTER);
  text("- Overall Rating -", width*0.85, height*0.4+50+21*3);
  textAlign(LEFT);



  if (normRating >= 35) fill(124, 102, 45);
  else if (normRating >= 26) fill(12, 72, 14);
  else if (normRating >= 16) fill(12, 67, 72);
  else if (normRating >= 8) fill(80, 49, 19);
  else if (normRating >= 6) fill(70, 14, 62);
  else if (normRating >= 4) fill(38, 19, 80);
  else fill(70, 14, 14);
  PFont lineFont = createFont("AR BERKLEY", 65);
  textFont(lineFont);
  if (normRating >= 39) {
    text("S", width*0.26, height*0.4+50+21*8.75);
    text("S", width*0.31, height*0.4+50+21*8.75);
  } else text(visualRatingPrim, width*0.26, height*0.4+50+21*8.75);

  if (normRating >= 35) fill(247, 245, 175);
  else if (normRating >= 26) fill(110, 232, 115);
  else if (normRating >= 16) fill(184, 236, 250);
  else if (normRating >= 8) fill(255, 227, 219);
  else if (normRating >= 6) fill(247, 202, 241);
  else if (normRating >= 4) fill(182, 45, 246);
  else fill(255, 10, 10);
  if (normRating >= 39) {
    text("S", width*0.255, height*0.4+50+21*8.65);
    text("S", width*0.305, height*0.4+50+21*8.65);
  } else text(visualRatingPrim, width*0.255, height*0.4+50+21*8.65);



  if (secRating >= 35) fill(124, 102, 45);
  else if (secRating >= 26) fill(12, 72, 14);
  else if (secRating >= 16) fill(12, 67, 72);
  else if (secRating >= 8) fill(80, 49, 19);
  else if (secRating >= 6) fill(70, 14, 62);
  else if (secRating >= 4) fill(38, 19, 80);
  else fill(70, 14, 14);
  lineFont = createFont("AR BERKLEY", 65);
  textFont(lineFont);
  if (secRating >= 39) {
    text("S", width*0.597, height*0.4+50+21*12.75);
    text("S", width*0.607, height*0.4+50+21*12.75);
  } else text(visualRatingSec, width*0.597, height*0.4+50+21*12.75);

  if (secRating >= 35) fill(247, 245, 175);
  else if (secRating >= 26) fill(110, 232, 115);
  else if (secRating >= 16) fill(184, 236, 250);
  else if (secRating >= 8) fill(255, 227, 219);
  else if (secRating >= 6) fill(247, 202, 241);
  else if (secRating >= 4) fill(182, 45, 246);
  else fill(255, 10, 10);
  if (secRating >= 39) {
    text("S", width*0.592, height*0.4+50+21*12.65);
    text("S", width*0.602, height*0.4+50+21*12.65);
  } else text(visualRatingSec, width*0.592, height*0.4+50+21*12.65);



  float combRating = normRating*0.85+secRating*0.15;
  String visualRatingComb = "";
  if (combRating >= 39) visualRatingComb = "SS";
  else if (combRating >= 37) visualRatingComb = "S";
  else if (combRating >= 35) visualRatingComb = "S-";
  else if (combRating >= 32) visualRatingComb = "A+";
  else if (combRating >= 30) visualRatingComb = "A";
  else if (combRating >= 26) visualRatingComb = "A-";
  else if (combRating >= 23) visualRatingComb = "B+";
  else if (combRating >= 18) visualRatingComb = "B";
  else if (combRating >= 16) visualRatingComb = "B-";
  else if (combRating >= 13) visualRatingComb = "C+";
  else if (combRating >= 10) visualRatingComb = "C";
  else if (combRating >= 8) visualRatingComb = "C-";
  else if (combRating >= 6) visualRatingComb = "D";
  else if (combRating >= 4) visualRatingComb = "E";
  else if (combRating >= 0) visualRatingComb = "F";

  if (combRating >= 35) fill(124, 102, 45);
  else if (combRating >= 26) fill(12, 72, 14);
  else if (combRating >= 16) fill(12, 67, 72);
  else if (combRating >= 8) fill(80, 49, 19);
  else if (combRating >= 6) fill(70, 14, 62);
  else if (combRating >= 4) fill(38, 19, 80);
  else fill(70, 14, 14);
  lineFont = createFont("AR BERKLEY", 100);
  textFont(lineFont);
  if (combRating >= 39) {
    text("S", width*0.76, height*0.4+50+21*7);
    text("S", width*0.84, height*0.4+50+21*7);
  } else text(visualRatingComb, width*0.78, height*0.4+50+21*7);

  if (combRating >= 35) fill(247, 245, 175);
  else if (combRating >= 26) fill(110, 232, 115);
  else if (combRating >= 16) fill(184, 236, 250);
  else if (combRating >= 8) fill(255, 227, 219);
  else if (combRating >= 6) fill(247, 202, 241);
  else if (combRating >= 4) fill(182, 45, 246);
  else fill(255, 10, 10);
  if (combRating >= 39) {
    text("S", width*0.755, height*0.4+50+21*6.9);
    text("S", width*0.835, height*0.4+50+21*6.9);
  } else text(visualRatingComb, width*0.775, height*0.4+50+21*6.9);

  lineFont = createFont("Lucida Sans Regular", 12);
  textFont(lineFont);
}



void addEnemyElimScore(int enemyType) {
  if (enemyType == 0) enemyElimScore += 5; //normal hornet
  else if (enemyType == 1) enemyElimScore += 8; //lv2 hornet
  else if (enemyType == 2) enemyElimScore += 14; //firefly
}