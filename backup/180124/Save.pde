//************************************************************************
// This is a temporary version (or rather, a simple version)
// of save load system, which is only available during forest selection.
// The complete system should be available at any time, and should be able to
// save/load absolutely EVERYTHING.
//************************************************************************

Button saveBtn, loadBtn;

PrintWriter output;

void saveGame() {
  String s_week = nf(week, 2);
  String s_money = "";
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
  }

  for (Resource r : inventoryResources) {
    s_resources += returnABC(r.getType()+1);
  }

  int s_rndSeed = (int)random(10, 99);
  String saveString = s_week + s_money + s_honeyPrice + str(s_potTier) + str(s_hiveTier) + s_bees + s_guardians + str(s_BTP) + str(s_GTP) + s_resources + s_rndSeed;

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

  randomSeed((int)random(100000));
}

void loadGame() {
  try {
    String path = "save.txt";
    File file = new File(dataPath(path));
    if (file.exists() == false) path = "/data/save.txt";
    file = new File(dataPath(path));
    if (file.exists() == false) {
      noti.add(new Notification(12, color(50, 0, 0), 20, height-60, "Save not found!", 2000, "Down Corner"));
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

    randomSeed((int)random(100000));

    String s_week = og.substring(0, 2);
    int moneyEndIndex = 3+returnInt(og.substring(2, 3));
    String s_money = og.substring(3, moneyEndIndex);
    String s_honeyPrice = og.substring(moneyEndIndex, moneyEndIndex+6);
    String s_potTier = og.substring(moneyEndIndex+6, moneyEndIndex+7);
    String s_hiveTier = og.substring(moneyEndIndex+7, moneyEndIndex+8);
    int beeLength = returnInt(og.substring(moneyEndIndex+8, moneyEndIndex+9))*2;
    int guardianLength;
    if (og.substring(moneyEndIndex+8+1 + beeLength, moneyEndIndex+8+1 + beeLength+1).equals("X")) guardianLength = 0;
    else guardianLength = returnInt(og.substring(moneyEndIndex+8+1 + beeLength, moneyEndIndex+8+1 + beeLength+1))*2;
    int guardianStartIndex = moneyEndIndex+9+beeLength+1;
    String s_bees = og.substring(moneyEndIndex+9, moneyEndIndex+9+beeLength);
    String s_guardians = og.substring(moneyEndIndex+8+1 + beeLength, moneyEndIndex+8+1 + beeLength+1).equals("X") ? "" : og.substring(guardianStartIndex, guardianStartIndex+guardianLength);
    String s_BTP = og.substring(guardianStartIndex+guardianLength, guardianStartIndex+guardianLength+1);
    String s_GTP = og.substring(guardianStartIndex+guardianLength+1, guardianStartIndex+guardianLength+2);
    int resourceLength;
    if (og.substring(guardianStartIndex+guardianLength+2, guardianStartIndex+guardianLength+3).equals("X")) resourceLength = 0;
    else resourceLength = returnInt(og.substring(guardianStartIndex+guardianLength+2, guardianStartIndex+guardianLength+3));
    String s_resources = og.substring(guardianStartIndex+guardianLength+3, lines[0].length()-2);

    println(s_week, s_money, s_honeyPrice, s_potTier, s_hiveTier, s_bees, s_guardians, s_BTP, s_GTP, s_resources);

    bees.clear();
    inventoryBees.clear();
    guardians.clear();
    inventoryGuardians.clear();
    inventoryResources.clear();
    hornets.clear();
    guardians.clear();
    fireflies.clear();

    week = int(s_week);
    money = int(s_money);
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
    for (int i = 0; i < guardianLength/2; i++) {
      int type = returnInt(s_guardians.substring(i*2, i*2+1))-1;
      if (type <= 1) guardians.add(new Guardian(guardianName[type]));
      else guardians.add(new Guardian(upgradedGuardianName[type-2]));

      if (type <= 1) inventoryGuardians.add(new Guardian(guardianName[type]));
      else inventoryGuardians.add(new Guardian(upgradedGuardianName[type-2]));
      inventoryGuardians.get(inventoryGuardians.size()-1).updateShouldGuardianMove(false);
      int tier = int(s_guardians.substring(i*2+1, i*2+2));
      if (tier != 0) {
        guardians.get(guardians.size()-1).updateStingTier(tier);
        inventoryGuardians.get(inventoryGuardians.size()-1).updateStingTier(tier);
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

    roundOver = false;
    gameMillis = 0;
    roundTime = 0;
    screenDisable();
    forestsScreenActive = true;

    noti.add(new Notification(12, color(50), 20, height-60, "Game successfully loaded.", 2500, "Down Corner"));
  } 
  catch (RuntimeException e) {
    e.printStackTrace();
    output = createWriter("/data/loadError.txt");
    output.println(e);
    for (int i = 0; i < e.getStackTrace().length; i++) output.println(e.getStackTrace()[i]);
    output.flush();
    output.close();

    noti.add(new Notification(12, color(50, 0, 0), 20, height-60, "Oops! An error occured. Check loadError.txt!", 2000, "Down Corner"));
  }
}


//TBA
//https://processing.org/reference/loadJSONArray_.html