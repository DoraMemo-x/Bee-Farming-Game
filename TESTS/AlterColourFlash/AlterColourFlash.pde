//last update: 170716b

int timerA, timerB, interval = 1000; //ms
boolean anotherColour = false;
void setup() {
  timerA = millis();
  timerB = millis();
}

void draw() {
  background(0, 255, 0);

  if (anotherColour == false) {
    background(255, 0, 0);
    if (millis() - timerA > interval) {
      timerA = millis();
      timerB = millis();
      anotherColour = true;
    }
  } else { //(if anotherColour == true)
    background(0, 0, 255);
    if (millis() - timerB > interval) {
      timerA = millis();
      timerB = millis();
      anotherColour = false;
    }
  }
}