//latest update: 170710 (WORKS PERFECTLY OMFG)

import java.util.Collections;
import java.util.Arrays;
import java.util.Comparator;
import java.util.List;

void setup() {
  size(200, 200);
  background(102);

  frameRate(120);
}

ArrayList<float[]> pos = new ArrayList();
List<ArrayList<String>> dotPos = new ArrayList<ArrayList<String>>();
//ArrayList<Float> posY = new ArrayList<Float>();

float trailUsed = 0;
int trailLimit = 325; //pixels
boolean toggleTrail = false;

int step = 0;
void draw() {  
  stroke(255);
  if (mousePressed) toggleTrail = true;
  if (toggleTrail == true && trailUsed < trailLimit) {
    line(mouseX, mouseY, pmouseX, pmouseY);
    trailUsed += distance_between_two_points(mouseX, pmouseX, mouseY, pmouseY);
    pos.add(new float[] {mouseX, mouseY});
    //println(trailUsed);
  } else if (trailUsed >= trailLimit) {
    toggleTrail = false;
    //line(pos.get(0)[0], pos.get(0)[1], pos.get(pos.size()-1)[0], pos.get(pos.size()-1)[1]);

    //println("Sorted Positions:");
    //sortLists(pos);
    //displayLists(pos);

    if (key == 'c') {
      background(102);
      step = 0;
    } else if (key == 'a') {
      if (keyPressed && step <= pos.size()-2) {
        line(pos.get(step)[0], pos.get(step)[1], pos.get(step+1)[0], pos.get(step+1)[1]);
        if (step == pos.size()-2) line(pos.get(0)[0], pos.get(0)[1], pos.get(pos.size()-1)[0], pos.get(pos.size()-1)[1]);
        step++;
      }

      //for (int i = pos.size()-2; i >= 0; i--) {
      //  line(pos.get(i)[0], pos.get(i)[1], pos.get(i+1)[0], pos.get(i+1)[1]);
      //}
    } else if (key == 'd') {
      if (dotPos.size() == 0) {
        //cut the line into dots
        for (int i = pos.size()-2; i >= 0; i--) {
          float x1 = pos.get(i)[0], y1 = pos.get(i)[1];
          float x2 = pos.get(i+1)[0], y2 = pos.get(i+1)[1];
          float slope = (y2-y1)/(x2-x1);
          //println(slope, (y2-y1) + "/" + (x2-x1));

          stroke(255, 0, 0);
          for (int x = ceil(min(x1, x2)); x < floor(max(x1, x2)); x++) {
            float y = slope*(x-x1) + y1;
            dotPos.add(new ArrayList<String>(Arrays.asList(str(x), str(y))));
            point(x, y+150);
          }
          stroke(0, 255, 0);
          for (int y = ceil(min(y1, y2)); y < floor(max(y1, y2)); y++) {
            float x = (y-y1)/slope + x1;
            dotPos.add(new ArrayList<String>(Arrays.asList(str(x), str(y))));
            point(x+150, y);
          }
        }
        float x1 = pos.get(0)[0], y1 = pos.get(0)[1];
        float x2 = pos.get(pos.size()-1)[0], y2 = pos.get(pos.size()-1)[1];
        float slope = (y2-y1)/(x2-x1);

        stroke(255, 0, 0);
        for (int x = ceil(min(x1, x2)); x < floor(max(x1, x2)); x++) {
          float y = slope*(x-x1) + y1;
          dotPos.add(new ArrayList<String>(Arrays.asList(str(x), str(y))));
          point(x, y+150);
        }
        stroke(0, 255, 0);
        for (int y = ceil(min(y1, y2)); y < floor(max(y1, y2)); y++) {
          float x = (y-y1)/slope + x1;
          dotPos.add(new ArrayList<String>(Arrays.asList(str(x), str(y))));
          point(x+150, y);
        }

        sortArrayList2();
        //displayLists(dotPos);
      }

      stroke(255);
      if (keyPressed && step <= dotPos.size()-1) {
        point(float(dotPos.get(step).get(0)), float(dotPos.get(step).get(1)));
        step++;
      }
    } else if (trailUsed != 0 && keyPressed && key == 'r') {
      background(102);
      pos = new ArrayList();
      dotPos = new ArrayList();
      step = 0;
      trailUsed = 0;
    } else if (keyPressed && key == 'p') {
      println("mouse positions are: ");
      //displayLists(pos);
      displayListInArray(dotPos);
    } else if (keyPressed && key == 'g') {
      for (int COORx = 0; COORx < width; COORx++) {
        for (int COORy = 0; COORy < height; COORy++) {
          println(COORx, COORy);
          boolean xValid = false;
          boolean yValid = false;

          sortArrayList1();
          for (int i = dotPos.size()-2; i >= 0; i--) {
           List<String> positions1 = dotPos.get(i);
           PVector pos1 = new PVector(float(positions1.get(0)), float(positions1.get(1)));
           List<String> positions2 = dotPos.get(i+1);
           PVector pos2 = new PVector(float(positions2.get(0)), float(positions2.get(1)));

           if (pos1.x == pos2.x) {
             if (/*COORx == pos1.x */ COORx > pos1.x-0.15 && COORx < pos1.x+0.15) {
               if (COORy > min(pos1.y, pos2.y)   &&   COORy < max(pos1.y, pos2.y)) {
                 //stroke(255);
                 //line(pos1.x, pos1.y, pos2.x, pos2.y);
                 stroke(255, 0, 0);
                 point(COORx, COORy);

                 yValid = true;
                 continue;
               } else continue;
             } else continue;
           } else continue;
          }

          sortArrayList2();
          for (int i = dotPos.size()-2; i >= 0; i--) {
            List<String> positions1 = dotPos.get(i);
            PVector pos1 = new PVector(float(positions1.get(0)), float(positions1.get(1)));
            List<String> positions2 = dotPos.get(i+1);
            PVector pos2 = new PVector(float(positions2.get(0)), float(positions2.get(1)));

            if (pos1.y == pos2.y) {
              if (/*COORy == pos1.y */ COORy > pos1.y-0.15 && COORy < pos1.y+0.15) {
                if (COORx > min(pos1.x, pos2.x)   &&   COORx < max(pos1.x, pos2.x)) {
                  //stroke(255);
                  //line(pos1.x, pos1.y, pos2.x, pos2.y);
                  stroke(0, 255, 0);
                  point(COORx, COORy);

                  xValid = true;
                  continue;
                } else continue;
              } else continue;
            } else continue;
          }

          if (xValid && yValid) {
            stroke(0, 0, 255);
            point(COORx, COORy);
          }
        }
      }
      println("done");
    }
  }
}

//forum.processing.org/two/discussion/5826/sort-array (NOT WHAT I WANT)
void displayLists(ArrayList<float[]> lists) {
  int num = 0;
  for (float[] scores : lists) {
    println("List: #" + nf(num++, 2) + ":");
    for (float score : scores)  print(score + ", ");
    println("\n");
  }
}

void displayListInArray(List<ArrayList<String>> arrays) {
  for (List<String> list : arrays) printArray(list);
}

//NONONO
//void sortLists(ArrayList<float[]> arrays) {
//  for (float[] positions : arrays) sort(positions);
//}

//https://stackoverflow.com/questions/4907683/sort-a-two-dimensional-array-based-on-one-column
//https://stackoverflow.com/questions/20480723/how-to-sort-2d-arrayliststring-by-only-the-first-element
void sortArrayList1() {  //sort by first element
  Collections.sort(dotPos, new Comparator<ArrayList<String>>() {    
    public int compare(ArrayList<String> o1, ArrayList<String> o2) {
      String x1 = o1.get(0), x2 = o2.get(0);
      return x1.compareTo(x2);
    }
  }
  );
}

void sortArrayList2() {  //sort by second element
  Collections.sort(dotPos, new Comparator<ArrayList<String>>() {    
    public int compare(ArrayList<String> o1, ArrayList<String> o2) {
      String x1 = o1.get(1), x2 = o2.get(1);
      return x1.compareTo(x2);
    }
  }
  );
}

float distance_between_two_points(float _x1, float _x2, float _y1, float _y2) {
  float result = sqrt(pow((_x1-_x2), 2) + pow((_y1-_y2), 2));  
  return result;
}