int diameter = 12, radius = diameter/2;

void setup() {
  size(300, 200);
  smooth();
}

void draw() {
  background(255);

  stroke(0); 
  strokeWeight(2); 

  fill(255, 150, 0);

  radius = diameter/2;

  //body
  pushMatrix();
  translate(width/2, height/2);
  //rotate(-moveTheta);
  line(0, 0, -diameter*1.7/2, 0); //sting of the bee
  ellipse(0, 0, diameter*1.5, diameter);

  //"zebra lines" on body
  noStroke();
  fill(0);
  // *** offset bar line(s) ***
  //     *** MOST LEFT ***
  int a = 127, b = 136;
  arc(0, 0, diameter*1.5, diameter, radians(a), radians(b), CHORD);
  beginShape();
  vertex(-1.5*radius*cos(radians(180-b)), radius*sin(radians(180-b)));
  vertex(-1.5*radius*cos(radians(180-a)), radius*sin(radians(180-a)));
  vertex(-1.5*radius*cos(radians(180-a)), radius*sin(radians(180-b)));
  endShape();
  arc(0, 0, diameter*1.5, diameter, radians(180+180-b), radians(180+180-a), CHORD);
  beginShape();
  vertex(-1.5*radius*cos(radians(180-b)), -radius*sin(radians(180-b)));
  vertex(-1.5*radius*cos(radians(180-a)), -radius*sin(radians(180-a)));
  vertex(-1.5*radius*cos(radians(180-a)), -radius*sin(radians(180-b)));
  endShape();
  rect(-1.5*radius*cos(radians(180-b)), -radius*sin(radians(180-b)), 1.5*radius*cos(radians(180-b))-1.5*radius*cos(radians(180-a)), 2*radius*sin(radians(180-b)));

  //    *** LEFT ***
  a = 111;
  b = 119;
  arc(0, 0, diameter*1.5, diameter, radians(a), radians(b), CHORD);
  beginShape();
  vertex(-1.5*radius*cos(radians(180-b)), radius*sin(radians(180-b)));
  vertex(-1.5*radius*cos(radians(180-a)), radius*sin(radians(180-a)));
  vertex(-1.5*radius*cos(radians(180-a)), radius*sin(radians(180-b)));
  endShape();
  arc(0, 0, diameter*1.5, diameter, radians(180+180-b), radians(180+180-a), CHORD);
  beginShape();
  vertex(-1.5*radius*cos(radians(180-b)), -radius*sin(radians(180-b)));
  vertex(-1.5*radius*cos(radians(180-a)), -radius*sin(radians(180-a)));
  vertex(-1.5*radius*cos(radians(180-a)), -radius*sin(radians(180-b)));
  endShape();
  rect(-1.5*radius*cos(radians(180-b)), -radius*sin(radians(180-b)), 1.5*radius*cos(radians(180-b))-1.5*radius*cos(radians(180-a)), 2*radius*sin(radians(180-b)));

  //    ** RIGHT **
  a = 95;
  b = 103;
  arc(0, 0, diameter*1.5, diameter, radians(a), radians(b), CHORD);
  beginShape();
  vertex(-1.5*radius*cos(radians(180-b)), radius*sin(radians(180-b)));
  vertex(-1.5*radius*cos(radians(180-a)), radius*sin(radians(180-a)));
  vertex(-1.5*radius*cos(radians(180-a)), radius*sin(radians(180-b)));
  endShape();
  arc(0, 0, diameter*1.5, diameter, radians(180+180-b), radians(180+180-a), CHORD);
  beginShape();
  vertex(-1.5*radius*cos(radians(180-b)), -radius*sin(radians(180-b)));
  vertex(-1.5*radius*cos(radians(180-a)), -radius*sin(radians(180-a)));
  vertex(-1.5*radius*cos(radians(180-a)), -radius*sin(radians(180-b)));
  endShape();
  rect(-1.5*radius*cos(radians(180-b)), -radius*sin(radians(180-b)), 1.5*radius*cos(radians(180-b))-1.5*radius*cos(radians(180-a)), 2*radius*sin(radians(180-b)));

  //    ** MOST RIGHT **
  a = 79;
  b = 87;
  arc(0, 0, diameter*1.5, diameter, radians(a), radians(b), CHORD);
  beginShape();
  vertex(1.5*radius*cos(radians(a)), radius*sin(radians(a)));
  vertex(1.5*radius*cos(radians(b)), radius*sin(radians(b)));
  vertex(1.5*radius*cos(radians(b)), radius*sin(radians(a)));
  endShape();
  arc(0, 0, diameter*1.5, diameter, radians(180+180-b), radians(180+180-a), CHORD);
  beginShape();
  vertex(1.5*radius*cos(radians(a)), -radius*sin(radians(a)));
  vertex(1.5*radius*cos(radians(b)), -radius*sin(radians(b)));
  vertex(1.5*radius*cos(radians(b)), -radius*sin(radians(a)));
  endShape();
  rect(1.5*radius*cos(radians(b)), -radius*sin(radians(a)), 1.5*radius*cos(radians(a))-1.5*radius*cos(radians(b)), 2*radius*sin(radians(a)));


  //sclera (white part of the eye)
  stroke(0);
  strokeWeight(1);
  fill(255);
  ellipse(diameter*0.7, diameter*0.35, diameter*0.8, diameter*0.8);
  ellipse(diameter*0.7, -diameter*0.35, diameter*0.8, diameter*0.8);

  //eyeballs (black)
  noStroke();
  fill(50);
  ellipse(diameter*0.7, diameter*0.35, diameter*0.3, diameter*0.3);
  ellipse(diameter*0.7, -diameter*0.35, diameter*0.3, diameter*0.3);

  //bigger wings
  fill(200, 200, 200, 150);
  pushMatrix();
  translate(0, diameter*1);
  rotate(radians(60));
  ellipse(0, 0, diameter*1.5, diameter);
  popMatrix();
  pushMatrix();
  translate(0, -diameter*1);
  rotate(-radians(60));
  ellipse(0, 0, diameter*1.5, diameter);
  popMatrix();

  //smaller wings
  pushMatrix();
  translate(-5, diameter*0.8);
  rotate(radians(50));
  ellipse(0, 0, diameter*1.2, diameter);
  popMatrix();
  pushMatrix();
  translate(-5, -diameter*0.8);
  rotate(-radians(50));
  ellipse(0, 0, diameter*1.2, diameter);
  popMatrix();



  popMatrix();
}

void keyReleased() {
  switch (key) {
  case '1':
    diameter = 12;
    break;
  case '2':
    diameter *= 2;
    break;
  case '3':
    diameter *= 4;
    break;
  case '4':
    diameter *= 8;
    break;
  case '5':
    diameter *= 16;
    break;
  case '6':
    diameter /= 2;
    break;
  case '7':
    diameter /= 4;
    break;
  case '8':
    diameter /= 8;
    break;
  case '9':
    diameter /= 16;
    break;
  }
}