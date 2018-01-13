//https://forum.processing.org/two/discussion/20904/can-someone-explain-how-this-code-makes-a-star

void setup() {
  size(400, 400);
  noFill();
  star(width/2, height/2, 100, 120, 30);
}
 
void star(float x, float y, 
  float radius1, float radius2, 
  int npoints) { 
 
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