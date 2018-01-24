void polygon(float x, float y, float radius, int npoints) {
  float angle = TWO_PI / npoints;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius;
    float sy = y + sin(a) * radius;
    vertex(sx, sy);
  }
  endShape(CLOSE);
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

void chargeBar(float LUx, float LUy, float w, float h, color normalColour, int currTimer, int maxTimer, boolean isVertical, boolean stayFull, boolean gradientBar) {
  int curr = currTimer, max = maxTimer;
  if (curr > max) {
    curr = max;
    if (stayFull == false) return; //dont draw if dont want it to stay full
  }

  strokeWeight(1);
  stroke(50);
  noFill();
  rect(LUx, LUy, w, h);

  rectMode(CORNERS);
  noStroke();
  if (curr == max) fill(12, 124, 13);
  else if (gradientBar) fill((curr >= max/2 ? map(curr-max/2, 0, max/2, cos(0), cos(HALF_PI)) : 1)*255, map(curr, 0, max/2, sin(0), sin(HALF_PI))*255, 0); //R & G is the sin & cos relationship
  else fill(normalColour);

  if (isVertical) rect(LUx+0.25, map(curr, 0, max, LUy+h-0.25, LUy+0.25), LUx+w-0.25, LUy+h-0.25);
  else rect(LUx+0.3, LUy+0.25, map(curr, 0, max, LUx+0.3, LUx+w-0.25), LUy+h-0.25);
  rectMode(CORNER);
}

ArrayList<Notification> noti = new ArrayList<Notification>();
class Notification {
  int textSize;
  color fillColor; 
  float x; 
  float y; 
  String text; 
  int duration;
  String spType;

  int notiID;

  Notification(int _textSize, color _fillColor, float _x, float _y, String _text, int _duration, String _spType) { //spType is for example, does the notification has images(icons)
    textSize = _textSize;
    fillColor = _fillColor;
    x = _x;
    y = _y;
    text = _text;
    duration = _duration;
    spType = _spType;

    notiID = noti.size();

    for (Notification n : noti) if (n.returnText().equals(_text)) {
      n.refreshTimer();
      text = "";
      return;
    }
    
    if (spType.equals("Down Corner")) {
      int presentNotis = 0;
      for (Notification n : noti) if (n.getSpType().equals("Down Corner") && n.returnText().equals("") == false) presentNotis++;
      y = height-60 - presentNotis*18;
    }
  }

  void refreshTimer() {
    timer = 0;
  }

  int timer = 0;
  float changingY = y;
  void showNoti() {
    timer += timePassed;

    textAlign(LEFT);
    textSize(textSize);
    if (duration <= 500) {
      if (timer <= duration/2) {
        fill(fillColor);
        changingY = y;
      } else {
        fill(fillColor, map(timer, duration/2, duration, 255, 0));
        changingY = map(timer, duration/2, duration, y, y-10);
      }
    } else {
      if (timer <= duration-500) {
        fill(fillColor);
        changingY = y;
      } else {
        fill(fillColor, map(timer, duration-500, duration, 255, 0));
        changingY = map(timer, duration-500, duration, y, y-10);
      }
    }


    text(text, x, changingY);
  }

  String returnText() {
    return text;
  }

  boolean canRemove() {
    return timer >= duration;
  }

  String getSpType() {
    return spType;
  }
}

//Rectangle buttons
class Button {
  String label;
  float x;    // top left corner x position
  float y;    // top left corner y position
  float w;    // width of button
  float h;    // height of button
  int fillR = 251, fillG = 200, fillB = 55;
  color fillColour = color(fillR, fillG, fillB);
  int lFillR = constrain(fillR+15, 0, 255), lFillG = constrain(fillG+15, 0, 255), lFillB = constrain(fillB+15, 0, 255);
  int strokeR = 119, strokeG = 94, strokeB = 26;
  boolean noStroke = false;
  String roundEdge = "default"; //default 10

  Button(String labelB, float xpos, float ypos, float widthB, float heightB, int _fillR, int _fillG, int _fillB, int _strokeR, int _strokeG, int _strokeB, boolean _noStroke, String _roundEdge) {
    label = labelB;
    x = xpos;
    y = ypos;
    w = widthB;
    h = heightB;
    if (fillR > 0 && fillG > 0 && fillB > 0) {
      fillR = _fillR;
      fillG = _fillG;
      fillB = _fillB;
      lFillR = constrain(fillR+15, 0, 255);
      lFillG = constrain(fillG+15, 0, 255);
      lFillB = constrain(fillB+15, 0, 255);
    }
    if (strokeR > 0 && strokeG > 0 && strokeB > 0) {
      strokeR = _strokeR;
      strokeG = _strokeG;
      strokeB = _strokeB;
    }

    noStroke = _noStroke;
    roundEdge = _roundEdge;
  }

  void updateLabel(String _label) {
    label = _label;
  }

  void updateGreyOut(boolean _greyOut) {
    greyOut = _greyOut;
  }

  void updateXY(float _x, float _y) {
    x = _x;
    y = _y;
  }

  void updateSize(float _w, float _h) {
    w = _w;
    h = _h;
  }

  void updateMouseIsOver(boolean _newMIO) {
    mouseIsOver = _newMIO;
  }

  boolean mouseIsOver = false, greyOut = false;
  void Draw() {
    if (greyOut && fillR == 180 && fillG == 180 && fillB == 180) fill(120); //for up down buttons.
    else if (greyOut) fill(saturation(fillColour));
    else if (mouseIsOver) fill(lFillR, lFillG, lFillB);
    else fill(fillR, fillG, fillB);
    stroke(strokeR, strokeG, strokeB);
    if (noStroke) noStroke();
    else strokeWeight(2);
    if (roundEdge.equals("default")) rect(x, y, w, h, 10);
    else rect(x, y, w, h, float(roundEdge));
    textSize(12);
    textAlign(CENTER, CENTER);
    PFont lineFont = createFont("Lucida Sans Regular", 12);
    textFont(lineFont);
    fill(0);
    text(label, x + (w / 2), y + (h / 2)-2);

    if (mouseX > x && mouseX < (x + w) && mouseY > y && mouseY < (y + h)) mouseIsOver = true;
    else mouseIsOver = false;
  }

  boolean MouseClicked() {
    if (mouseX > x && mouseX < (x + w) && mouseY > y && mouseY < (y + h) && greyOut == false) {
      return true;
    } 
    return false;
  }

  boolean getMouseIsOver() {
    if (greyOut) mouseIsOver = false;
    return mouseIsOver;
  }
}

class CircleButton {
  String label, secLabel;
  float x;    // top left corner x position
  float y;    // top left corner y position
  float w;    // width of button
  float h;    // height of button
  int fillR = 251, fillG = 200, fillB = 55;
  color fillColour = color(fillR, fillG, fillB);
  int lFillR = constrain(fillR+15, 0, 255), lFillG = constrain(fillG+15, 0, 255), lFillB = constrain(fillB+15, 0, 255);
  //  color lFillColour = color(lFillR, lFillG, lFillB);
  int strokeR = 119, strokeG = 94, strokeB = 26;

  CircleButton(String labelB, String secLabelB, float xpos, float ypos, float widthB, float heightB, int _fillR, int _fillG, int _fillB, int _strokeR, int _strokeG, int _strokeB) {
    label = labelB;
    secLabel = secLabelB;
    x = xpos;
    y = ypos;
    w = widthB;
    h = heightB;
    if (fillR > 0 && fillG > 0 && fillB > 0) {
      fillR = _fillR;
      fillG = _fillG;
      fillB = _fillB;
      lFillR = constrain(fillR+15, 0, 255);
      lFillG = constrain(fillG+15, 0, 255);
      lFillB = constrain(fillB+15, 0, 255);
    }
    if (strokeR > 0 && strokeG > 0 && strokeB > 0) {
      strokeR = _strokeR;
      strokeG = _strokeG;
      strokeB = _strokeB;
    }
  }

  void updateLabel(String _label) {
    label = _label;
  }

  void updateGreyOut(boolean _greyOut) {
    greyOut = _greyOut;
  }

  void updateXY(float _x, float _y) {
    x = _x;
    y = _y;
  }

  void updateSize(float _w, float _h) {
    w = _w;
    h = _h;
  }

  boolean mouseIsOver = false, greyOut = false;
  void Draw() {
    if (greyOut) fill(saturation(fillColour));
    else if (mouseIsOver) fill(lFillR, lFillG, lFillB);
    else fill(fillR, fillG, fillB);
    stroke(strokeR, strokeG, strokeB);
    strokeWeight(2);
    ellipse(x, y, w, h);
    noTint();
    textAlign(CENTER, CENTER);
    fill(0);
    textSize(12);
    text(label, x, y);
    textSize(9);
    text(secLabel, x, y+15);

    if (mouseX > x-w/2 && mouseX < (x + w/2) && mouseY > y-h/2 && mouseY < (y + h/2)) mouseIsOver = true;
    else mouseIsOver = false;
  }

  boolean MouseClicked() {
    if (mouseX > x-w/2 && mouseX < (x + w/2) && mouseY > y-h/2 && mouseY < (y + h/2) && greyOut == false) {
      return true;
    } 
    return false;
  }

  boolean getMouseIsOver() {
    if (greyOut) mouseIsOver = false;
    return mouseIsOver;
  }
}

class threeDButton {
  String label;
  float textSize;
  float thick = 15;
  float h = 50;
  float w = 100;
  float x = 25;
  float y = 25;
  color centerColour = color(240);
  color stroke = color(100);
  color lightColour = color(220);
  color deepColour = color(150);
  color textColour = color(0);
  boolean isActive = false;

  threeDButton(String labelB, float _textSize, float xpos, float ypos, float widthB, float heightB, float _thick, color _centerColour, color _stroke, color _lightColour, color _deepColour, color _textColour) {
    label = labelB;
    textSize = _textSize;
    x = xpos;
    y = ypos;
    w = widthB;
    h = heightB;
    thick = _thick;
    centerColour = _centerColour;
    stroke = _stroke;
    lightColour = _lightColour;
    deepColour = _deepColour;
    textColour = _textColour;
  }

  void updateLabel(String _label) {
    label = _label;
  }

  void updateGreyOut(boolean _greyOut) {
    greyOut = _greyOut;
  }

  void updateXY(float _x, float _y) {
    x = _x;
    y = _y;
  }

  void updateSize(float _w, float _h) {
    w = _w;
    h = _h;
  }

  void updateMouseIsOver(boolean _newMIO) {
    mouseIsOver = _newMIO;
  }

  void updateActive(boolean _a) {
    isActive = _a;
  }

  boolean mouseIsOver = false, greyOut = false;
  void Draw() {
    if (mouseX > x && mouseX < (x + w) && mouseY > y && mouseY < (y + h)) mouseIsOver = true;
    else mouseIsOver = false;

    strokeWeight(1);

    if (mouseIsOver && isActive) fill(red(centerColour)-80, green(centerColour)-80, blue(centerColour)-80);
    else if (mouseIsOver) fill(red(centerColour)+20, green(centerColour)+20, blue(centerColour)+20);
    else if (isActive) fill(red(centerColour)-100, green(centerColour)-100, blue(centerColour)-100);
    else fill(centerColour);
    stroke(stroke);
    rect(x, y, w, h);

    if (mouseIsOver && isActive == false) fill(red(textColour)+20, green(textColour)+20, blue(textColour)+20);
    else if (isActive) fill(255);
    else fill(textColour);
    textSize(textSize);
    textAlign(CENTER);
    text(label, x+w/2, y+h*0.65);    

    if (isActive) fill(deepColour);
    else fill(lightColour);
    beginShape();
    vertex(x, y);
    vertex(x, y+h);
    vertex(x-thick, y+h+thick);
    vertex(x-thick, y-thick);
    vertex(x+w+thick, y-thick);
    vertex(x+w, y);
    vertex(x, y);
    vertex(x-thick, y-thick);
    endShape();

    if (isActive) fill(lightColour);
    else fill(deepColour);
    beginShape();
    vertex(x+w, y+h);
    vertex(x, y+h);
    vertex(x-thick, y+h+thick);
    vertex(x+w+thick, y+h+thick);
    vertex(x+w+thick, y-thick);
    vertex(x+w, y);
    vertex(x+w, y+h);
    vertex(x+w+thick, y+h+thick);
    endShape();
  }

  boolean MouseClicked() {
    if (mouseX > x && mouseX < (x + w) && mouseY > y && mouseY < (y + h) && greyOut == false) {
      return true;
    } 
    return false;
  }

  boolean getMouseIsOver() {
    if (greyOut) mouseIsOver = false;
    return mouseIsOver;
  }

  boolean getIsActive() {
    return isActive;
  }
}

void drawPopupWindow(String[] _text, int beginOnLine, int _textSize, float x, float y, boolean showWindow, color c, float boxWidth) {
  //x and y make the left up corner
  textSize(_textSize);
  textAlign(LEFT);

  String[] text = _text, text2 = _text;
  float longestWidth = 0, totalHeight = (text.length-beginOnLine)*(textAscent()+textDescent())+4;
  boolean[] exceedsBoxWidth = new boolean[text.length];
  for (int i = beginOnLine; i < text.length; i++) {
    if (textWidth(text[i]) > longestWidth) longestWidth = textWidth(text[i]);
    if (textWidth(text[i]) > boxWidth) exceedsBoxWidth[i] = true;
    //println(text[i], textWidth(text[i]), boxWidth);
  }

  if (showWindow) {
    fill(255, 251, 201);
    strokeWeight(1);
    stroke(200);
    rect(x, y, longestWidth+_textSize*2.2, totalHeight +_textSize*1.2);

    fill(c);

    for (int i = beginOnLine; i < text.length; i++) {
      try {
        String formatCode = text[i].substring(0, 2);
        if (formatCode.equals("|b")) {
          PFont lineFont = createFont("Lucida Sans Demibold", _textSize);
          textFont(lineFont);
          text(text[i].substring(2), x+_textSize*2.2/2, _textSize*0.8+y+_textSize*(i+1 - beginOnLine));
        } else if (formatCode.equals("|r")) {
          PFont lineFont = createFont("Lucida Sans Regular", _textSize);
          textFont(lineFont);
          text(text[i].substring(2), x+_textSize*2.2/2, _textSize*0.8+y+_textSize*(i+1 - beginOnLine));
        } else if (formatCode.equals("|i")) {
          PFont lineFont = createFont("Arial Italic", _textSize);
          textFont(lineFont);
          text(text[i].substring(2), x+_textSize*2.2/2, _textSize*0.8+y+_textSize*(i+1 - beginOnLine));
        } else text(text[i], x+_textSize*2.2/2, _textSize*0.8+y+_textSize*(i+1 - beginOnLine));
      } 
      catch (RuntimeException e) {
        text(text[i], x+_textSize*2.2/2, _textSize*0.8+y+_textSize*(i+1 - beginOnLine));
      }
    }
    PFont lineFont = createFont("Lucida Sans Regular", _textSize);
    textFont(lineFont);
  } else {
    String[][] splittedText = new String[text.length][1];
    int extraLine = 0;
    for (int i = beginOnLine; i < text.length-extraLine; i++) {
      if (exceedsBoxWidth[i]) {
        extraLine++;

        splittedText[i] = split(text[i], " ");
        String testingCombine = "";
        String remainderSentence = "";
        if (text[i].substring(0, 2).equals("- ")) remainderSentence = "   "; //indent
        for (int a = splittedText[i].length-1; a >= 0; a--) {
          for (int b = 0; b < a; b++) {
            testingCombine += splittedText[i][b] + " ";
          }
          //println(testingCombine);

          if (textWidth(testingCombine) > boxWidth) continue;
          else {
            for (int b = a; b < splittedText[i].length; b++) {
              remainderSentence += splittedText[i][b] + " ";
            }
            text = expand(text, text.length+1); //woah technology...
            break;
          }
        }

        text[i] = testingCombine;
        text[i+1] = remainderSentence;

        //shift the rest of the text
        for (int j = i; j < text.length-extraLine-1; j++) { //-extraLine because expanded how many times = extraLine
          //println(text[j+1+extraLine]);
          //println(text2[j+1]);
          text[j+1+extraLine] = text2[j+1];
        }
      }
    }
    //println(extraLine);

    fill(c);

    for (int i = beginOnLine; i < text.length; i++) {
      try {
        String formatCode = text[i].substring(0, 2);
        if (formatCode.equals("|b")) {
          PFont lineFont = createFont("Lucida Sans Demibold", _textSize);
          textFont(lineFont);
          text(text[i].substring(2), x, y+_textSize*(i+1 - beginOnLine));
        } else if (formatCode.equals("|r")) {
          PFont lineFont = createFont("Lucida Sans Regular", _textSize);
          textFont(lineFont);
          text(text[i].substring(2), x, y+_textSize*(i+1 - beginOnLine));
        } else if (formatCode.equals("|i")) {
          PFont lineFont = createFont("Arial Italic", _textSize);
          textFont(lineFont);
          text(text[i].substring(2), x, y+_textSize*(i+1 - beginOnLine));
        } else text(text[i], x+_textSize*2.2/2, _textSize*0.8+y+_textSize*(i+1 - beginOnLine));
      } 
      catch (RuntimeException e) {
        text(text[i], x, y+_textSize*(i+1 - beginOnLine));
      }
    }
    PFont lineFont = createFont("Lucida Sans Regular", _textSize);
    textFont(lineFont);
  }
}

char returnABC(int num) {
  return char(num+64);
}

int returnInt(String ABC) {
  char tmp = ABC.charAt(0);
  return int(tmp)-64;
}