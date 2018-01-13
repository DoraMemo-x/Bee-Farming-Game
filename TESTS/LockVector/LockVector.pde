void setup() {
  size(800, 600);
  noStroke();

  float blockSize = (650 - 10*2 - 10*5)/5;
  for (int x = 0; x < 5; x++) {
    fill(180);
    //block
    rect(20 + (blockSize+10)*x, 70 + (blockSize+10)*1, blockSize, blockSize, 5, 5, 5, 5);

    //lock
    pushMatrix();

    translate(20 + (blockSize+10)*x + blockSize/2, 70 + (blockSize+10)*1 + blockSize/2   + 10);

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
  //fill(255, 255, 0);
  //rect(20, 70 + (blockSize+10)*1 + blockSize*0.4, (blockSize+10)*4 + blockSize, blockSize*0.2);
  //fill(0);
  //for (int i = 0; i < (blockSize+10)*4 + blockSize - 22; i+= 22) quad(20 + 10 + i, 70 + (blockSize+10)*1 + blockSize*0.4, 20 + 20 + i, 70 + (blockSize+10)*1 + blockSize*0.4, 20 + 15 + i, 70 + (blockSize+10)*1 + blockSize*0.6, 20 + 5 + i, 70 + (blockSize+10)*1 + blockSize*0.6);
}

void draw() {
}