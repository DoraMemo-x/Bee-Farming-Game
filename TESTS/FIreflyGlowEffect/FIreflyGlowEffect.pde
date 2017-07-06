PGraphics pg;

void setup() {
  size(200, 200);
  fill(0, 0, 255);
  noStroke();
  smooth();
}

void draw() {
  background(0);

  float glowValue = abs(sin(radians(millis()/7))); // divide more = slower (lower frequency)
  pg = createGraphics(width, height);
  //white glow outline
  pg.beginDraw();
  pg.smooth();
  pg.background(255, 0);
  pg.noStroke();
  pg.fill(255);
  pg.ellipse(100, 100, map(glowValue, 0, 1, 40, 60), map(glowValue, 0, 1, 40, 60));
  pg.filter(BLUR, 12);
  pg.endDraw();
  image(pg, 0, 0);
  //green thin line
  pg.beginDraw();
  pg.fill(173, 209, 53);
  pg.ellipse(100, 100, map(glowValue, 0, 1, 42, 62), map(glowValue, 0, 1, 42, 62));
  pg.filter(BLUR, 2);
  pg.endDraw();
  image(pg, 0, 0); 
  //green light (minor glow)
  pg.beginDraw();
  pg.fill(219, 241, 0);
  pg.ellipse(100, 100, map(glowValue, 0, 1, 35, 55), map(glowValue, 0, 1, 35, 55));
  pg.filter(BLUR, 4);
  pg.endDraw();
  image(pg, 0, 0);
  //main yellow light glow
  pg.beginDraw();
  pg.fill(254, 252, 80);
  pg.ellipse(100, 100, map(glowValue, 0, 1, 30, 50), map(glowValue, 0, 1, 30, 50));
  pg.filter(BLUR, 4);
  pg.endDraw();
  image(pg, 0, 0);
  //center white shine
  pg.beginDraw();
  pg.fill(255);
  pg.ellipse(100, 100, map(glowValue, 0, 1, 0, 12), map(glowValue, 0, 1, 0, 12));
  pg.filter(BLUR, 4);
  pg.endDraw();
  image(pg, 0, 0);
}