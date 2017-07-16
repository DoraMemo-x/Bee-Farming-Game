int timerA, timerB, interval = 1000; //ms
boolean anotherColour = false;
void setup() {
  timerA = millis();
  timerB = millis();
}

void draw() {
  if (millis() - timerA > interval && anotherColour == false) {
    timerA = millis();
    timerB = millis();
    background(255, 0, 0);
    anotherColour = true;
  }
  if (millis() - timerB > interval && anotherColour) {
    timerA = millis();
    timerB = millis();
    background(0, 0, 255);
    anotherColour = false;
  }
}