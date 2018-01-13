void setup() {
  size(400, 400);
  strokeWeight(20);
  noFill();
  textAlign(CENTER);
  textSize(50);
  strokeCap(PROJECT); //ROUND, SQUARE, PROJECT
} 

int upperLimit = 5000;
void draw() {
  background(220);
  color gradient = color(map(millis(), 0, upperLimit/2, 0, 255), 255-(millis()>=upperLimit/2?map(millis(), upperLimit/2, upperLimit, 0, 255):0), 0);
  
  noFill();
  stroke(gradient);
  arc(width/2, height/2, 350, 350, -HALF_PI, map(millis(), 0, upperLimit, PI+HALF_PI, -HALF_PI));
  
  fill(gradient);
  text(int((upperLimit - millis())/1000)+1, width/2, height/2);
}