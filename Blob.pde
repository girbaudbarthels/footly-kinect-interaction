// Daniel Shiffman
// http://codingtra.in
// http://patreon.com/codingtrain
// Code for: https://youtu.be/1scFcY-xMrI

class Blob {
  float minx;
  float miny;
  float maxx;
  float maxy;

  ArrayList<PVector> points;

  Blob(float x, float y) {
    minx = x;
    miny = y;
    maxx = x;
    maxy = y;
    points = new ArrayList<PVector>();
    points.add(new PVector(x, y));
  }

  void show() {
    stroke(0);
    fill(255);
    strokeWeight(2);
    rectMode(CORNERS);
    rect(minx, miny, maxx, maxy);

    for (PVector v : points) {
      //stroke(0, 0, 255);
      //point(v.x, v.y);
    }
  }


  void add(float x, float y) {
    minx = min(minx, x);
    miny = min(miny, y);
    maxx = max(maxx, x);
    maxy = max(maxy, y);


    if (size() >1000) {    
      points.add(new PVector(x, y));
      if (minx<100) {
        extraXValue = -300;
      }

      if (minx<150) {
        extraXValue = -300;
      }
      if (minx<200) {
        extraXValue = -250;
      }

      if (minx>250) {
        extraXValue = -150;
      }   
      if (minx>300) {
        extraXValue = -50;
      }    
      if (minx>350) {
        extraXValue = 0;
      }    
      if (minx>400) {
        extraXValue = 40;
      }     
      if (minx>450) {
        extraXValue = 70;
      }    
      if (minx>500) {
        extraXValue = 150;
      } 

      if (minx>550) {
        extraXValue = 180;
      } 
      if (minx>600) {
        extraXValue = 200;
      }

      if (miny<200) {
        extraYValue = -250;
      }

      if (miny<300) {
        extraYValue = -200;
      } 
      if (miny>300) {
        extraYValue = -150;
      }
      if (miny>400) {
        extraYValue = -100;
      }
      if (miny>500) {
        extraYValue = -50;
      }


      xmousePos = int(((maxx+minx)/2)) + extraXValue; ///extraXValue
      ymousePos = int((((maxy+miny))/2)) +extraYValue; //-50

  







      locatieblob = new PVector((maxx+minx)/2, ((maxy+miny))/2);
    }
  }

  float size() {
    return (maxx-minx)*(maxy-miny);
  }

  boolean isNear(float x, float y) {

    // The Rectangle "clamping" strategy
    // float cx = max(min(x, maxx), minx);
    // float cy = max(min(y, maxy), miny);
    // float d = distSq(cx, cy, x, y);

    // Closest point in blob strategy
    float d = 10000000;
    for (PVector v : points) {
      float tempD = distSq(x, y, v.x, v.y);
      if (tempD < d) {
        d = tempD;
      }
    }

    if (d < distThresholdBlob*distThresholdBlob) {
      return true;
    } else {
      return false;
    }
  }
}
