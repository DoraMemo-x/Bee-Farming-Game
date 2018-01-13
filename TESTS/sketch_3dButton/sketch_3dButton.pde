float thick = 15;
float h = 50;
float w = 100;
float x = 25;
float y = 25;
color centerColour = color(240);
color stroke = color(100);
color lightColour = color(220);
color deepColour = color(150);

size(200, 200);

fill(centerColour);
stroke(stroke);
rect(x, y, w, h);

fill(lightColour);
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

fill(deepColour);
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