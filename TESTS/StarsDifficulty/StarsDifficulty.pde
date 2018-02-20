void setup() {
  smooth();
  size(800, 200);
}

float rotation = -17.5;
void draw() {
  background(255);
  noStroke();
  fill(0);
  drawStarBar(10, height/2, 35, color(255, 0, 0), 0, 17);
}

void drawStarBar(int LUx, int LUy, int h, color bgColour, color starColour, int stars) {
  int bigStars = int(stars/5);
  int smallStars = stars%5;
  
  noStroke();
  fill(bgColour);
  rect(LUx, LUy-h*0.05, h*1.1*(bigStars+max(2, smallStars)/2), h);
  
  fill(starColour);
  for (int b = 0; b < bigStars; b++) {
    pushMatrix();
    translate(LUx+h*0.1 + h*(b+0.5), LUy+h/2);
    rotate(radians(-17.5));
    star(0, 0, h/4, h/2, 5);
    popMatrix();
  }
  for (int s = 0; s < smallStars; s++) {
    pushMatrix();
    translate(LUx+h*0.1 + h*(bigStars+0.5) + (s%2==0?-1:1)*h*0.25, LUy+h/2 + (s<2?-1:1)*h*0.25);
    rotate(radians(-17.5));
    star(0, 0, h/8, h/4, 5);
    popMatrix();
  }
}

void star(float x, float y, float radius1, float radius2, int npoints) {
  float angle = TWO_PI / npoints; 
  float halfAngle = angle/2.0; 

  beginShape(); 
  for (float a = 0; a < TWO_PI; a += angle) { 
    float sx = x + cos(a) * radius2; 
    float sy = y + sin(a) * radius2; 
    vertex(sx, sy); 
    sx = x + cos(a+halfAngle) * radius1; 
    sy = y + sin(a+halfAngle) * radius1; 
    vertex(sx, sy);
  } 
  endShape(CLOSE);
}