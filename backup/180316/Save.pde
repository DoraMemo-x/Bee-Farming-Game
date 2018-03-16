//************************************************************************
// This is a temporary version (or rather, a simple version)
// of save load system, which is only available during forest selection.
// The complete system should be available at any time, and should be able to
// save/load absolutely EVERYTHING.
//************************************************************************

Button saveBtn, loadBtn;

PrintWriter output;
PrintWriter outputLog;

void saveGame() {
  String s_week = hex(week).substring(6, 8);
  String s_money = "";
  String s_honeyKg = "";
  String s_honeyPrice = "";
  int s_potTier = honeyPotTier;
  int s_hiveTier = beehiveTier;
  String s_bees = str(returnABC(bees.size())), s_guardians = guardians.size() == 0? "X" : str(returnABC(guardians.size()));
  int s_BTP = BTPurchased ? BTSelected+1 : 0;
  int s_GTP = GTPurchased ? GTSelected+1 : 0;
  String s_resources = inventoryResources.size() == 0? "X" : str(returnABC(inventoryResources.size()));

  int temp = 10;
  while (money / temp > 0) temp *= 10;
  s_money = returnABC(int(log(temp)/log(10))) + str(money);

  temp = 10;
  while (honeyKg / temp > 0) temp *= 10;
  s_honeyKg = returnABC(int(log(temp)/log(10))) + str(honeyKg);

  for (int i = 0; i < honeyPriceRecord.length; i++) {
    if (honeyPriceRecord[i] == 0) s_honeyPrice += "0";
    else s_honeyPrice += returnABC(honeyPriceRecord[i]/10);
  }

  for (Bee b : bees) {
    s_bees += returnABC(b.getBeeType()+1);
    if (b.getBeeType() >= beeName.length) s_bees += b.getTier();
    else s_bees += "0";
  }

  for (Guardian g : guardians) {
    s_guardians += returnABC(g.getGuardianType()+1);
    if (g.getGuardianName() == "Ranged Guardian") s_guardians += g.getStingTier();
    else s_guardians += "0";
    s_guardians += str(g.getSpeedBuffTier());
  }

  for (Resource r : inventoryResources) {
    s_resources += returnABC(r.getType()+1);
  }

  int s_rndSeed = (int)random(10, 99);
  String s_assignedQuestWeek = hex(assignedQuestWeek).substring(6, 8);
  String s_questSeed = hex(questSeed).substring(5, 8);
  String s_enemyProg = nf(questEnemyProg, 2);
  String s_completedQuests = nf(completedQuests, 2);

  String s_forestQuest = "";
  for (int i = 0; i < questReq.length; i++) {
    for (int k = 0; k < questReq[i][2].length; k++) {
      if (questDone[i][2][k]) s_forestQuest += "1";
      else s_forestQuest += "0";
    }
  }

  String s_enemyElimScore = hex(enemyElimScore).substring(4, 8);
  String s_questDiffSum = hex(questDiffSum).substring(5, 8);
  String s_totalHoneyCollected = hex(totalHoneyCollected).substring(4, 8), s_honeyOverflown = hex(honeyOverflown).substring(4, 8);
  String s_beeDeaths = hex(beeDeaths).substring(5, 8);
  String s_purchasesDone = hex(purchasesDone).substring(5, 8);
  String s_flowersDepleted = hex(flowersDepleted).substring(5, 8);
  String s_enemyAliveTime = hex(int(enemyAliveTime)).substring(3, 8);
  String s_trainingsCompleted = hex(trainingsCompleted).substring(5, 8);
  String s_resultCard = s_enemyElimScore + s_questDiffSum + s_totalHoneyCollected + s_honeyOverflown+ s_beeDeaths + s_purchasesDone + s_flowersDepleted + s_enemyAliveTime + s_trainingsCompleted;

  String saveString = s_week + s_money + s_honeyKg + s_honeyPrice + str(s_potTier) + str(s_hiveTier) + s_bees + s_guardians + str(s_BTP) + str(s_GTP) + s_resources + s_assignedQuestWeek + s_enemyProg + s_completedQuests + s_forestQuest + s_resultCard + s_questSeed + s_rndSeed;

  println(s_week, s_money, s_honeyPrice, str(s_potTier), str(s_hiveTier), s_bees, s_guardians, str(s_BTP), str(s_GTP), s_resources);
  println(saveString);

  randomSeed(s_rndSeed);
  //Encryption
  ArrayList<String> readable = new ArrayList<String>();
  ArrayList<String> encrypted = new ArrayList<String>();
  String encryptedString = "";

  for (int i = 0; i < saveString.length()-2; i++) readable.add(saveString.substring(i, i+1));

  for (int i = readable.size()-1; i >= 0; i--) {
    int digit = (int)random(readable.size()-1);
    encrypted.add(readable.get(digit));
    readable.remove(digit);
  }
  //printArray(encrypted);

  for (int i = 0; i < encrypted.size(); i++) encryptedString += encrypted.get(i);
  //println("The encrypted string is: " + encryptedString);

  output = createWriter("/data/save.txt");
  output.println(encryptedString + s_rndSeed);
  output.flush();
  output.close();

  noti.add(new Notification(12, color(50), 20, height-60, "Game Saved.", 2500, "Down Corner"));

  randomSeed(millis());
}

boolean loadingSave = false;
void loadGame() {
  try {
    loadingSave = true;

    String path = "save.txt";
    File file = new File(dataPath(path));
    if (file.exists() == false) path = "/data/save.txt";
    file = new File(dataPath(path));
    if (file.exists() == false) {
      noti.add(new Notification(12, color(200, 0, 0), 20, height-60, "Save not found!", 2000, "Down Corner"));
      loadError = true;
      return; //after checking the file => doesnt exist
    }

    String[] lines = loadStrings("save.txt");
    ArrayList<String> encrypted = new ArrayList<String>();
    ArrayList<Integer> digit = new ArrayList<Integer>();
    ArrayList<Integer> decryptedDigit = new ArrayList<Integer>();
    String[] decrypted = new String[lines[0].length()-2];
    String og = "";

    for (int i = 0; i < lines[0].length()-2; i++) {
      digit.add(i);
      encrypted.add(lines[0].substring(i, i+1));
    }
    randomSeed(int(lines[0].substring(lines[0].length()-2)));
    for (int i = digit.size()-1; i >= 0; i--) {
      int num = (int)random(digit.size()-1);
      decryptedDigit.add(digit.get(num));
      digit.remove(num);
    }
    printArray(decryptedDigit);

    for (int i = 0; i < decryptedDigit.size(); i++) {
      decrypted[decryptedDigit.get(i)] = encrypted.get(i);
    }
    //printArray(decrypted);
    og = join(decrypted, "") + lines[0].substring(lines[0].length()-2);
    println("The original string is: " + og);

    randomSeed(millis());

    String s_week = og.substring(0, 2);
    int moneyEndIndex = 3+returnInt(og.substring(2, 3));
    String s_money = og.substring(3, moneyEndIndex);
    int honeyEndIndex = moneyEndIndex+1+returnInt(og.substring(moneyEndIndex, moneyEndIndex+1));
    String s_honeyKg = og.substring(moneyEndIndex+1, honeyEndIndex);
    String s_honeyPrice = og.substring(honeyEndIndex, honeyEndIndex+6);
    String s_potTier = og.substring(honeyEndIndex+6, honeyEndIndex+7);
    String s_hiveTier = og.substring(honeyEndIndex+7, honeyEndIndex+8);
    int beeLength = returnInt(og.substring(honeyEndIndex+8, honeyEndIndex+9))*2;
    int guardianLength;
    if (og.substring(honeyEndIndex+8+1 + beeLength, honeyEndIndex+8+1 + beeLength+1).equals("X")) guardianLength = 0;
    else guardianLength = returnInt(og.substring(honeyEndIndex+8+1 + beeLength, honeyEndIndex+8+1 + beeLength+1))*3;
    int guardianStartIndex = honeyEndIndex+9+beeLength+1;
    String s_bees = og.substring(honeyEndIndex+9, honeyEndIndex+9+beeLength);
    String s_guardians = og.substring(honeyEndIndex+8+1 + beeLength, honeyEndIndex+8+1 + beeLength+1).equals("X") ? "" : og.substring(guardianStartIndex, guardianStartIndex+guardianLength);
    String s_BTP = og.substring(guardianStartIndex+guardianLength, guardianStartIndex+guardianLength+1);
    String s_GTP = og.substring(guardianStartIndex+guardianLength+1, guardianStartIndex+guardianLength+2);
    int resourceLength;
    if (og.substring(guardianStartIndex+guardianLength+2, guardianStartIndex+guardianLength+3).equals("X")) resourceLength = 0;
    else resourceLength = returnInt(og.substring(guardianStartIndex+guardianLength+2, guardianStartIndex+guardianLength+3));
    String s_resources = og.substring(guardianStartIndex+guardianLength+3, lines[0].length()-2-2-2-6-32-3-2);
    String s_assignedQuestWeek = og.substring(lines[0].length()-2-2-2-6-32-3-2, lines[0].length()-2-2-6-32-3-2); //2digit
    String s_enemyProg = og.substring(lines[0].length()-2-2-6-32-3-2, lines[0].length()-2-6-32-3-2); //2digit
    String s_completedQuests = og.substring(lines[0].length()-2-6-32-3-2, lines[0].length()-6-32-3-2); //2digit
    String s_forestQuest = og.substring(lines[0].length()-6-32-3-2, lines[0].length()-32-3-2); //6digit
    String s_resultCard = og.substring(lines[0].length()-32-3-2, lines[0].length()-3-2); //32digit
    String s_questSeed = og.substring(lines[0].length()-3-2, lines[0].length()-2); //3digit

    enemyElimScore = unhex((s_resultCard).substring(0, 4));
    questDiffSum = unhex((s_resultCard).substring(4, 7));
    totalHoneyCollected = unhex((s_resultCard).substring(7, 11));
    honeyOverflown = unhex((s_resultCard).substring(11, 15));
    beeDeaths = unhex((s_resultCard).substring(15, 18));
    purchasesDone = unhex((s_resultCard).substring(18, 21));
    flowersDepleted = unhex((s_resultCard).substring(21, 24));
    enemyAliveTime = unhex((s_resultCard).substring(24, 29));
    trainingsCompleted = unhex((s_resultCard).substring(29, 32));

    println(s_week, s_money, s_honeyKg, s_honeyPrice, s_potTier, s_hiveTier, s_bees, s_guardians, s_BTP, s_GTP, s_resources, s_forestQuest);

    bees.clear();
    inventoryBees.clear();
    guardians.clear();
    inventoryGuardians.clear();
    inventoryResources.clear();
    hornets.clear();
    guardians.clear();
    fireflies.clear();

    //week = unhex(s_week);
    week = unhex(s_assignedQuestWeek);
    money = int(s_money);
    honeyKg = int(s_honeyKg);
    for (int i = 0; i < 6; i++) honeyPriceRecord[i] = returnInt(s_honeyPrice.substring(i, i+1))*10;
    honeyPrice = honeyPriceRecord[5];
    honeyPriceChgTimes = 6;
    honeyPotTier = int(s_potTier);
    beehiveTier = int(s_hiveTier);
    for (int i = 0; i < beeLength/2; i++) {
      int type = returnInt(s_bees.substring(i*2, i*2+1))-1;
      bees.add(new Bee(type));
      inventoryBees.add(new Bee(type));
      inventoryBees.get(inventoryBees.size()-1).updateMoveTheta(HALF_PI);
      inventoryBees.get(inventoryBees.size()-1).updateForShop(true);

      int tier = int(s_bees.substring(i*2+1, i*2+2));
      if (tier != 0) {
        bees.get(bees.size()-1).updateTier(tier);
        inventoryBees.get(inventoryBees.size()-1).updateTier(tier);
      }
    }
    for (int i = 0; i < guardianLength/3; i++) {
      int type = returnInt(s_guardians.substring(i*3, i*3+1))-1;
      if (type <= 1) guardians.add(new Guardian(guardianName[type]));
      else guardians.add(new Guardian(upgradedGuardianName[type-2]));

      if (type <= 1) inventoryGuardians.add(new Guardian(guardianName[type]));
      else inventoryGuardians.add(new Guardian(upgradedGuardianName[type-2]));
      inventoryGuardians.get(inventoryGuardians.size()-1).updateShouldGuardianMove(false);

      int tier = int(s_guardians.substring(i*3+1, i*3+2));
      if (tier != 0) {
        guardians.get(guardians.size()-1).updateStingTier(tier);
        inventoryGuardians.get(inventoryGuardians.size()-1).updateStingTier(tier);
      }

      int speedBuffTier = int(s_guardians.substring(i*3+2, i*3+3));
      for (int t = 0; t < speedBuffTier; t++) {
        guardians.get(guardians.size()-1).grantSpeedBuff();
        inventoryGuardians.get(inventoryGuardians.size()-1).grantSpeedBuff();
      }
    }
    if (int(s_BTP) != 0) {
      BTPurchased = true;
      BTSelected = int(s_BTP)-1;
    }
    if (int(s_GTP) != 0) {
      GTPurchased = true;
      GTSelected = int(s_GTP)-1;
    }
    for (int i = 0; i < resourceLength; i++) {
      inventoryResources.add(new Resource(returnInt(s_resources.substring(i, i+1))-1));
    }
    assignedQuestWeek = unhex(s_assignedQuestWeek); 
    questEnemyProg = int(s_enemyProg);
    completedQuests = int(s_completedQuests);

    questSeed = unhex(s_questSeed);
    assignQuest();
    for (int i = 0; i < 6; i++) {
      int k = floor(i/3);
      if (s_forestQuest.substring(i, i+1).equals("0")) questDone[k][2][k==0?i:i-3] = false;
      else if (s_forestQuest.substring(i, i+1).equals("1")) questDone[k][2][k==0?i:i-3] = true;
    }
    updateQuest();

    week = unhex(s_week);


    roundOver = false;
    gameMillis = 0;
    roundTime = 0;
    screenDisable();
    forestsScreenActive = true;

    noti.add(new Notification(12, color(50), 20, height-60, "Game successfully loaded.", 2500, "Down Corner"));

    loadingSave = false;
  } 
  catch (RuntimeException e) {
    e.printStackTrace();
    output = createWriter("/logs/loadError.txt");
    output.println("Error occurred at: " + year() + "/" + month() + "/" + day() + "   " + hour() + ":" + minute() + ":" + second());
    output.println(e);
    for (int i = 0; i < e.getStackTrace().length; i++) output.println(e.getStackTrace()[i]);
    output.flush();
    output.close();

    noti.add(new Notification(12, color(200, 0, 0), 20, height-60, "Oops! An error occured. Check loadError.txt!", 2000, "Down Corner"));
    loadError = true;
  }
}

boolean loadError = false;

//TBA
//https://processing.org/reference/loadJSONArray_.html