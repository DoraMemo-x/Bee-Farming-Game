//Inventory
int invBtn = 0;
Button invTabLeft, invTabRight;

//Bee Inventory
Button beeInvUp, beeInvDown;
Button beeInvSell;
int beeInvSelected = -1, beeInvSlot = 0;
boolean[] isBeeDead = new boolean[25];
ArrayList<Bee> inventoryBees = new ArrayList<Bee>();

//Guardian Inventory
Button guardianInvUp, guardianInvDown;
Button guardianInvSell;
int guardianInvSelected = -1, guardianInvSlot = 0;
ArrayList<Guardian> inventoryGuardians = new ArrayList<Guardian>();

//Item Inventory
Button itemInvSell;
int itemInvSelected = -1;
int[] resourcePrice = {100, 100, 500, 10, 500, 150, 1, 0, 250, 250, 100, 100, 50, 500, 150, 0}; //holyWater, holyCross, "bible", holyBranch; virus, souldEssence, beeGuts, ?; fork, shovel, wateringCan, shears; flag, injection, skaterBoots, ?
String[] resourceName = {"Holy Water", "Holy Cross", char(34)+"Bible"+char(34), "Holy Branch", "Z-Virus", "Soul Essence", "Bee Guts", "UNNAMED", "Gardening Fork", "Shovel", "Watering Can", "Shears", "Flag", "Injection", "Skater Boots", "UNNAMED"};
ArrayList<Resource> inventoryResources = new ArrayList<Resource>();

//Minimap
ArrayList<Bee> minimapBees = new ArrayList<Bee>();
ArrayList<Flower> minimapFlowers = new ArrayList<Flower>();
ArrayList<Guardian> minimapGuardians = new ArrayList<Guardian>();

void inventorySetup() {
  //Inventory Tab
  invTabLeft = new Button("←", width-300+40-8.5, height-120+45, 15, 15, 251, 200, 55, 180, 180, 180, true, "0");
  invTabRight = new Button("→", width-300+40+8.5, height-120+45, 15, 15, 251, 200, 55, 180, 180, 180, true, "0");

  //Bee Inventory
  float blockSize = (650 - 10*2 - 10*5)/5;
  for (int i = 0; i < isBeeDead.length; i++) isBeeDead[i] = false;
  beeInvUp = new Button("", 20 + (blockSize+10)*3.7, 70 + (blockSize+10)*2 + 10, blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize), blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize), 180, 180, 180, 180, 180, 180, false, "default");
  beeInvDown = new Button("", 20 + (blockSize+10)*4.35, 70 + (blockSize+10)*2 + 10, blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize), blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize), 180, 180, 180, 180, 180, 180, false, "default");
  beeInvSell = new Button("Sell for $xxx", 20 + (blockSize+10)*2.4, 70 + (blockSize+10)*3.55, 120, 35, 251, 200, 55, 119, 94, 26, false, "default");

  //Guardian Inventory
  guardianInvUp = new Button("", 20 + (blockSize - blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize))/2, 70 + (blockSize+10)*2.3, blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize), blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize), 180, 180, 180, 180, 180, 180, false, "default");
  guardianInvDown = new Button("", 20 + (blockSize - blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize))/2, 70 + (blockSize+10)*2.95, blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize), blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize), 180, 180, 180, 180, 180, 180, false, "default");
  guardianInvSell = new Button("Sell for $xxx", 20 + (blockSize+10)*3.86, 70 + (blockSize+10)*1.55, 120, 35, 251, 200, 55, 119, 94, 26, false, "default");

  for (int x = 0; x < 3; x++) {
    inventoryBees.add(new Bee(0));
    inventoryBees.get(inventoryBees.size()-1).updateMoveTheta(HALF_PI);
    inventoryBees.get(inventoryBees.size()-1).updateForShop(true);
    inventoryBees.get(inventoryBees.size()-1).updateLocation(20 + blockSize/2 + (blockSize+10)*x, 70 + blockSize/2 + (blockSize+10)*0);
  }

  itemInvSell = new Button("Sell for $xxx", 20 + (blockSize+10)*2.4, 70 + (blockSize+10)*3.55, 120, 35, 251, 200, 55, 119, 94, 26, false, "default");
}

void beeInventoryActive() {
  background(210); //should be 235 but it looks so clumped up with that, 210 looks better

  resetButtonPos();

  showForestBtn.Draw();
  sellAllHoneyBtn.Draw();
  honeyFlucBtn.Draw();

  buyMarketBtn.updateGreyOut(false);
  buyMarketBtn.Draw();
  invTabLeft.Draw();
  invTabRight.Draw();
  //for (int i = inventoryBtn.size()-1; i >= 0; i--) { 
  //  Button btn = inventoryBtn.get(i);
  //  if (i == 0) btn.updateGreyOut(true); //0 is bee inventory
  //  else btn.updateGreyOut(false);
  //}
  inventoryBtn.get(invBtn).Draw();
  GTMarketBtn.updateGreyOut(false);
  GTMarketBtn.Draw();
  BTMarketBtn.updateGreyOut(false);
  BTMarketBtn.Draw();

  float blockSize = (650 - 10*2 - 10*5)/5;

  fill(120);
  textAlign(LEFT);
  textSize(12);
  text("Viewing " + (beeInvSlot+1) + " - " + (beeInvSlot+10) + " bees", 25, 70 + (blockSize+10)*2 + 20);

  if (beeInvSlot == 0) beeInvUp.updateGreyOut(true);
  else beeInvUp.updateGreyOut(false);
  beeInvUp.Draw();
  noStroke();
  fill(120);
  triangle(20 + (blockSize+10)*3.7   +   blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize)/2, 70 + (blockSize+10)*2 + 10   +   blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize)*0.4, 
    20 + (blockSize+10)*3.7   +   blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize)*0.35, 70 + (blockSize+10)*2 + 10   +   blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize)*0.6, 
    20 + (blockSize+10)*3.7   +   blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize)*0.65, 70 + (blockSize+10)*2 + 10   +   blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize)*0.6);
  if (beeInvSlot == 15) beeInvDown.updateGreyOut(true); //most allowed is 25 bees (beehive 20 + possibly a power up)
  else beeInvDown.updateGreyOut(false);
  beeInvDown.Draw();
  noStroke();
  fill(120);
  triangle(20 + (blockSize+10)*4.35   +   blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize)/2, 70 + (blockSize+10)*2 + 10   +   blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize)*0.6, 
    20 + (blockSize+10)*4.35   +   blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize)*0.35, 70 + (blockSize+10)*2 + 10   +   blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize)*0.4, 
    20 + (blockSize+10)*4.35   +   blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize)*0.65, 70 + (blockSize+10)*2 + 10   +   blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize)*0.4);

  int counter = 0;
  noStroke();
  for (int y = 0; y < 2; y++) {
    for (int x = 0; x < 5; x++) {
      if (beeInvSelected != counter+beeInvSlot) fill(180);
      else fill(255, 255, 150);
      //block
      rect(20 + (blockSize+10)*x, 70 + (blockSize+10)*y, blockSize, blockSize, 5, 5, 5, 5);

      if (counter+beeInvSlot >= beehiveSize[beehiveTier]) {
        //lock
        pushMatrix();

        translate(20 + (blockSize+10)*x + blockSize/2, 70 + (blockSize+10)*y + blockSize/2   + 10);

        fill(60);
        rect(-30, -15, 60, 40);
        rect(-23, -30, 10, 30);
        rect(13, -30, 10, 30);
        arc(0, -30, (23+13+10), (23+13+10), PI, TWO_PI, OPEN);
        fill(180);
        arc(0, -30, (13+10+3), (13+10+3), PI, TWO_PI, OPEN);


        fill(255);
        ellipse(0, 0, 10, 10);
        beginShape();
        vertex(-5, 15);
        vertex( 5, 15);
        vertex(1.5, 0);
        vertex(-1.5, 0);
        endShape();

        popMatrix();
      }

      counter++;
    }
  }

  for (int i = beeInvSlot; i < min(10 + beeInvSlot, inventoryBees.size()); i++) {
    Bee b = inventoryBees.get(i);
    b.showBee();
  }

  counter = 0;
  for (int y = 0; y < 2; y++) {
    for (int x = 0; x < 5; x++) {
      if (isBeeDead[counter + beeInvSlot]) { //draw the "DEAD" bar
        fill(255, 0, 0, 60);
        rectMode(CORNERS);
        pushMatrix();
        translate(20 + (blockSize+10)*x, 70 + (blockSize+10)*y);
        beginShape();
        vertex(0, blockSize*0.5);
        vertex(0, blockSize*0.65);
        vertex(blockSize, blockSize*0.5);
        vertex(blockSize, blockSize*0.35);
        endShape();

        rotate(-radians(9));
        textSize(20);
        textAlign(CENTER);
        fill(200);
        text("D E    A D", blockSize*0.43, blockSize*0.64);
        fill(0);
        text("D E    A D", blockSize*0.42, blockSize*0.63);
        popMatrix();
        rectMode(CORNER);
      }
      if (counter+beeInvSlot > inventoryBees.size()-1 && counter+beeInvSlot < beesCount) { //draw a "G" to represent guardian
        fill(0, 0, 150);
        textAlign(CENTER);
        textSize(blockSize*0.6);

        PFont font = createFont("Lucida Sans Demibold", 28);
        textFont(font);
        text("─ G ─", 20 + (blockSize+10)*x + blockSize/2, 70 + (blockSize+10)*y + blockSize/2 + 10);
        font = createFont("Lucida Sans Regular", 28);
        textFont(font);

        //stroke(0, 0, 150);
        //noFill();
        //star(20 + (blockSize+10)*x + blockSize/2, 70 + (blockSize+10)*y + blockSize/2, blockSize*0.6/2, blockSize*0.5/2, 50);
      }
      counter++;
    }
  }

  //selected a bee in inventory
  if (beeInvSelected != -1) {
    boolean beeBeingRevived = false;
    Bee selectedB = bees.get(beeInvSelected);

    fill(180);
    rect(20, 70 + (blockSize+10)*2.3, (blockSize+10)*3.5, blockSize*1.8, 5, 5, 5, 5);

    float minimapLUx = 20 + blockSize*0.1, minimapLUy = 70 + (blockSize+10)*2.4;
    float minimapW = (blockSize+10)*3.3 - 135, minimapH = ((blockSize+10)*3.3 - 135) * ((600-30-40.0) / 800.0); //30 top, 40 bottom

    if (!(roundOver == false && gameMillis == 0 && roundTime == 0)) {
      showMinimap(minimapLUx, minimapLUy, minimapW, minimapH);

      String selectedBeeName = selectedB.getBeeName();

      if (selectedBeeName.equals(upgradedBeeName[0]) && bees.get(beeInvSelected).getCDAbility()) { //if the bee is PRIEST BEE and REVIVING
        fill(beeColour[beeName.length]);
        textAlign(LEFT);
        textSize(12);
        text("Reviving...", 20 + (blockSize+10)*2.4, 70 + (blockSize+10)*2.3 + 25 + 15*3);
      } else if (selectedBeeName.equals(upgradedBeeName[1])) { //Undead bee
        textAlign(LEFT);
        textSize(12);
        if (selectedB.getCDAbility() == false) {
          fill(beeColour[beeName.length+1]);
          text("FIRST LIFE", 20 + (blockSize+10)*2.4, 70 + (blockSize+10)*2.3 + 25 + 15*4);
        } else {
          fill(undeadColour);
          text("SECOND LIFE", 20 + (blockSize+10)*2.4, 70 + (blockSize+10)*2.3 + 25 + 15*4);
        }
      } else if (selectedBeeName.equals(upgradedBeeName[2])) {
        int CDACooldown = selectedB.getCDACooldown();
        textAlign(LEFT);
        textSize(12);
        fill(60);
        if (selectedB.getCDAbility()) {
          fill(beeColour[beeName.length+2]);
          text("Using "+char(34)+"Nature's Path"+char(34), 20 + (blockSize+10)*2.4, 70 + (blockSize+10)*2.3 + 25 + 15*4);
        } else if (CDACooldown == 0) text(char(34)+"Nature's Path"+char(34)+" READY!", 20 + (blockSize+10)*2.4, 70 + (blockSize+10)*2.3 + 25 + 15*4);
        else text(char(34)+"Nature's Path"+char(34) + " " + 100*(beeCDAVar[2][1]-CDACooldown)/beeCDAVar[2][1] + "%", 20 + (blockSize+10)*2.4, 70 + (blockSize+10)*2.3 + 25 + 15*4);
        println(CDACooldown, beeCDAVar[2][1]);
      } else if (selectedBeeName.equals(upgradedBeeName[3])) { //RushB
        int CDACooldown = ceil(selectedB.getCDACooldown()/1000);
        textAlign(LEFT);
        textSize(12);
        fill(60);
        if (selectedB.getCDAbility()) {
          fill(beeColour[beeName.length+3]);
          text("Using " + char(34) + "Adrenaline" + char(34), 20 + (blockSize+10)*2.4, 70 + (blockSize+10)*2.3 + 25 + 15*4);
        } else if (CDACooldown == 0) text(char(34)+"Adrenaline"+char(34)+" READY!", 20 + (blockSize+10)*2.4, 70 + (blockSize+10)*2.3 + 25 + 15*4);
        else text(char(34)+"Adrenaline"+char(34)+" CD.: " + CDACooldown + "s", 20 + (blockSize+10)*2.4, 70 + (blockSize+10)*2.3 + 25 + 15*4);
      }
      for (Bee b : bees) {
        if (b.getBeeName().equals(upgradedBeeName[0])) {
          if (b.getTargetBeeDistinctID() == selectedB.getDistinctID()) {
            fill(beeColour[beeName.length]);
            textAlign(LEFT);
            textSize(12);
            text("Being revived...", 20 + (blockSize+10)*2.4, 70 + (blockSize+10)*2.3 + 25 + 15*3);

            beeBeingRevived = true;

            break;
          }
        }
      }
    } else {
      fill(60);
      textAlign(CENTER);
      textSize(28);
      PFont font = createFont("Lucida Sans Demibold", 28);
      textFont(font);
      text("NOT IN A FOREST", minimapLUx + minimapW/2, minimapLUy + minimapH/2 /* + ceil(i/2.0)*33*(i%2==0?1:-1) */);
      font = createFont("Lucida Sans Regular", 28);
      textFont(font);
    }

    fill(60);
    textAlign(LEFT);
    textSize(12);
    text("Name: " + inventoryBees.get(beeInvSelected).getBeeName(), 20 + (blockSize+10)*2.4, 70 + (blockSize+10)*2.3 + 25);
    if (selectedB.getBeeType() == beeName.length || selectedB.getBeeType() == beeName.length+2) text("Tier: " + selectedB.getTier(), 20 + (blockSize+10)*2.4, 70 + (blockSize+10)*2.3 + 25 + 15*2);
    if (selectedB.getCurrHoneyCap() == selectedB.getMaxHoneyCap()) fill(200, 0, 0);
    if (selectedB.getBeeName().equals(upgradedBeeName[0]) == false) text("Honey: " + floor((selectedB.getCurrHoneyCap())/1000) + " / " + floor((selectedB.getMaxHoneyCap())/1000) + " kg", 20 + (blockSize+10)*2.4, 70 + (blockSize+10)*2.3 + 25 + 15*1);

    if (isBeeDead[beeInvSelected]) {
      fill(200, 0, 0);
      text("THIS BEE IS DEAD.", 20 + (blockSize+10)*2.4, 70 + (blockSize+10)*2.3 + 25 + 15*7);
    }

    if (bees.size() == 1 
      || (selectedB.getBeeName().equals(upgradedBeeName[0]) && selectedB.getCDAbility())
      || beeBeingRevived) beeInvSell.updateGreyOut(true);
    else beeInvSell.updateGreyOut(false);
    beeInvSell.Draw();
  }
}

void guardianInventoryActive() {
  background(210);

  resetButtonPos();

  showForestBtn.Draw();
  sellAllHoneyBtn.Draw();
  honeyFlucBtn.Draw();

  buyMarketBtn.updateGreyOut(false);
  buyMarketBtn.Draw();
  invTabLeft.Draw();
  invTabRight.Draw();
  //for (int i = inventoryBtn.size()-1; i >= 0; i--) { 
  //  Button btn = inventoryBtn.get(i);
  //  if (i == 1) btn.updateGreyOut(true); //1 is guardian inventory
  //  else btn.updateGreyOut(false);
  //}
  inventoryBtn.get(invBtn).Draw();
  GTMarketBtn.updateGreyOut(false);
  GTMarketBtn.Draw();
  BTMarketBtn.updateGreyOut(false);
  BTMarketBtn.Draw();

  float blockSize = (650 - 10*2 - 10*5)/5;

  fill(120);
  textAlign(LEFT);
  textSize(12);
  text("Viewing " + (guardianInvSlot+1) + " - " + (guardianInvSlot+4) + " guardians", 25, 70 + (blockSize+10)*2 + 20);

  if (guardianInvSlot == 0) guardianInvUp.updateGreyOut(true);
  else guardianInvUp.updateGreyOut(false);
  guardianInvUp.Draw();
  noStroke();
  fill(120);
  beginShape();
  vertex(20 + (blockSize - blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize))/2   +   blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize)/2, 70 + (blockSize+10)*2.3   +   blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize)*0.4);
  vertex(20 + (blockSize - blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize))/2   +   blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize)*0.35, 70 + (blockSize+10)*2.3   +   blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize)*0.6);
  vertex(20 + (blockSize - blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize))/2   +   blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize)*0.65, 70 + (blockSize+10)*2.3   +   blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize)*0.6);
  endShape();
  if (guardianInvSlot == 20) guardianInvDown.updateGreyOut(true); //most allowed is 25 bees (beehive 20 + possibly a power up)
  else guardianInvDown.updateGreyOut(false);
  guardianInvDown.Draw();
  noStroke();
  fill(120);
  beginShape();
  vertex(20 + (blockSize - blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize))/2   +   blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize)/2, 70 + (blockSize+10)*2.95   +   blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize)*0.6);
  vertex(20 + (blockSize - blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize))/2   +   blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize)*0.35, 70 + (blockSize+10)*2.95   +   blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize)*0.4);
  vertex(20 + (blockSize - blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize))/2   +   blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize)*0.65, 70 + (blockSize+10)*2.95   +   blockSize*(((blockSize+10)*4+blockSize - (blockSize+10)*4.35)/blockSize)*0.4);
  endShape();

  int counter = 0; //this counter is to iterate the number of grids
  noStroke();
  for (int y = 0; y < 2; y++) {
    for (int x = 0; x < 2; x++) {
      if (guardianInvSelected != counter+guardianInvSlot) fill(180);
      else fill(255, 255, 150);
      //block
      rect(20 + (blockSize+10)*x, 70 + (blockSize+10)*y, blockSize, blockSize, 5, 5, 5, 5);

      if (counter+guardianInvSlot >= beehiveSize[beehiveTier]) {
        //lock
        pushMatrix();

        translate(20 + (blockSize+10)*x + blockSize/2, 70 + (blockSize+10)*y + blockSize/2   + 10);

        fill(60);
        rect(-30, -15, 60, 40);
        rect(-23, -30, 10, 30);
        rect(13, -30, 10, 30);
        arc(0, -30, (23+13+10), (23+13+10), PI, TWO_PI, OPEN);
        fill(180);
        arc(0, -30, (13+10+3), (13+10+3), PI, TWO_PI, OPEN);


        fill(255);
        ellipse(0, 0, 10, 10);
        beginShape();
        vertex(-5, 15);
        vertex( 5, 15);
        vertex(1.5, 0);
        vertex(-1.5, 0);
        endShape();

        popMatrix();
      }

      counter++;
    }
  }

  for (int i = guardianInvSlot; i < min(4 + guardianInvSlot, inventoryGuardians.size()); i++) {
    Guardian g = inventoryGuardians.get(i);
    g.showGuardian();
  }

  counter = 0;
  for (int y = 0; y < 2; y++) {
    for (int x = 0; x < 2; x++) {
      //Bee Representation
      if (counter+guardianInvSlot > inventoryGuardians.size()-1 && counter+guardianInvSlot < beesCount) { //draw a "B" to represent Bee
        fill(255, 75, 0);
        textAlign(CENTER);
        textSize(blockSize*0.6);

        PFont font = createFont("Lucida Sans Demibold", 28);
        textFont(font);
        text("─ B ─", 20 + (blockSize+10)*x + blockSize/2, 70 + (blockSize+10)*y + blockSize/2 + 10);
        font = createFont("Lucida Sans Regular", 28);
        textFont(font);

        //stroke(0, 0, 150);
        //noFill();
        //star(20 + (blockSize+10)*x + blockSize/2, 70 + (blockSize+10)*y + blockSize/2, blockSize*0.6/2, blockSize*0.5/2, 50);
      }

      counter++;
    }
  }

  //selected a guardian in inventory
  if (guardianInvSelected != -1) {
    noStroke();
    fill(180);
    rect(20 + blockSize+10, 70 + (blockSize+10)*2.3, (blockSize+10)*2.5, blockSize*1.8, 5, 5, 5, 5); //minimap box
    rect(20 + (blockSize+10)*2, 70, blockSize*3 + 10*2, blockSize*2 + 10, 5, 5, 5, 5); //description box

    float minimapLUx = 20 + blockSize+10 + blockSize*0.14, minimapLUy = 70 + (blockSize+10)*2.4;
    float minimapW = (blockSize+10)*3.3 - 135, minimapH = ((blockSize+10)*3.3 - 135) * ((600-30-40.0) / 800.0); //30 top, 40 bottom

    //display guardian data on the panel
    Guardian invG = guardians.get(guardianInvSelected);
    fill(60);
    textAlign(LEFT);
    textSize(12);
    text("Name: " + invG.getGuardianName(), 20 + (blockSize+10)*2.1, 70 + (blockSize+10)*0.18);
    int spGuardianType = invG.getGuardianType()-2;
    if (spGuardianType == 2) { //Hunting Guardian
      float CDACooldown = float(invG.getCDACooldown());
      if (invG.getCDAbility()) {
        fill(guardianColour[spGuardianType+2]);
        text("Using " + char(34) + "Hunter's Aura" + char(34), 20 + (blockSize+10)*2.1, 70 + (blockSize+10)*0.18+16);
      } else if (CDACooldown == 0) text(char(34) + "Hunter's Aura" + char(34) + " READY!", 20 + (blockSize+10)*2.1, 70 + (blockSize+10)*0.18+16);
      else text(char(34) + "Hunter's Aura" + char(34) + " Cooldown: " + ceil(CDACooldown/1000) + "s", 20 + (blockSize+10)*2.1, 70 + (blockSize+10)*0.18+16);
    } else if (spGuardianType == 4) { //Ranged Guardian
      int stingAmount = invG.getStingAmount();
      int stingTier = invG.getStingTier();
      text("Stings: " + stingAmount, 20 + (blockSize+10)*2.1, 70 + (blockSize+10)*0.18+16);
      text("Tier: " + stingTier, 20 + (blockSize+10)*2.1, 70 + (blockSize+10)*0.18+16*2);
    }

    if (!(roundOver == false && gameMillis == 0 && roundTime == 0)) {

      showMinimap(minimapLUx, minimapLUy, minimapW, minimapH);
    } else {
      fill(60);
      textAlign(CENTER);
      textSize(28);
      PFont font = createFont("Lucida Sans Demibold", 28);
      textFont(font);
      text("NOT IN A FOREST", minimapLUx + minimapW/2, minimapLUy + minimapH/2 /* + ceil(i/2.0)*33*(i%2==0?1:-1) */);
      font = createFont("Lucida Sans Regular", 28);
      textFont(font);
    }

    guardianInvSell.Draw();
  }

  counter = 0;
  for (int y = 0; y < 2; y++) {
    for (int x = 0; x < 2; x++) {
      //Mouse Over Grid
      if (counter+guardianInvSlot < inventoryGuardians.size() && mouseX > 20 + (blockSize+10)*x && mouseX < 20 + (blockSize+10)*x + blockSize && mouseY > 70 + (blockSize+10)*y && mouseY < 70 + (blockSize+10)*y + blockSize) {
        int guardianType = inventoryGuardians.get(counter+guardianInvSlot).getGuardianType()-2; //-2 because guardian type is guardian-0, super_guardian-1, sp_guardian-2. the array only covers upgraded guardians
        if (guardianType >= 0) { //if it is a special guardian
          String[][] newDescription = upgradedGuardianDescription;
          //removing the price & week length text
          String[] frontSet = subset(newDescription[guardianType], 0, 1);
          String[] endSet = subset(newDescription[guardianType], 2, newDescription[guardianType].length-2);
          String[] concatedSet = concat(frontSet, endSet);
          drawPopupWindow(concatedSet, 0, 12, mouseX, mouseY, true, 0, width);
        } else { //else, it's shop guardians
          String[] description = {guardianType+2 == 0 ? "Guardian" : "Super Guardian"}; //+2 back to check if it's guardian/super
          drawPopupWindow(description, 0, 12, mouseX, mouseY, true, 0, width);
        }
      }
      counter++;
    }
  }
}

void itemInventoryActive() {
  background(210); //should be 235 but it looks so clumped up with that, 210 looks better

  resetButtonPos();

  showForestBtn.Draw();
  sellAllHoneyBtn.Draw();
  honeyFlucBtn.Draw();

  buyMarketBtn.updateGreyOut(false);
  buyMarketBtn.Draw();
  invTabLeft.Draw();
  invTabRight.Draw();
  //for (int i = inventoryBtn.size()-1; i >= 0; i--) { 
  //  Button btn = inventoryBtn.get(i);
  //  if (i == 0) btn.updateGreyOut(true); //0 is bee inventory
  //  else btn.updateGreyOut(false);
  //}
  inventoryBtn.get(invBtn).Draw();
  GTMarketBtn.updateGreyOut(false);
  GTMarketBtn.Draw();
  BTMarketBtn.updateGreyOut(false);
  BTMarketBtn.Draw();

  float blockSize = (650 - 10*2 - 10*5)/5;

  fill(120);
  textAlign(LEFT);
  textSize(12);
  text("Viewing Material Inventory", 25, 70 + (blockSize+10)*2 + 20);

  int counter = 0;
  noStroke();
  for (int y = 0; y < 2; y++) {
    for (int x = 0; x < 4; x++) {
      if (itemInvSelected != counter) fill(180);
      else fill(255, 255, 150);
      //block
      rect(20 + (blockSize+10)*x, 70 + (blockSize+10)*y, blockSize, blockSize, 5, 5, 5, 5);

      counter++;
    }
  }

  for (Resource r : inventoryResources) r.showItem();

  if (itemInvSelected != -1) {
    fill(180);
    rect(20, 70 + (blockSize+10)*2.3, (blockSize+10)*3.5, blockSize*1.8, 5, 5, 5, 5);
    
    fill(60);
    textAlign(LEFT);
    text("Material: " + resourceName[inventoryResources.get(itemInvSelected).getType()], 40, 100 + (blockSize+10)*2.3);
    itemInvSell.Draw();
  }
}