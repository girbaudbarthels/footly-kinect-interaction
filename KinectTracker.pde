// Daniel Shiffman
// Tracking the average location beyond a given depth threshold
// Thanks to Dan O'Sullivan

// https://github.com/shiffman/OpenKinect-for-Processing
// http://shiffman.net/p5/kinect/

class KinectTracker {

  // Depth threshold
  //int threshold = 710;
  float minThreshold = 765;
  float threshold = 850;
  // Raw location
  PVector loc;

  // Interpolated location
  PVector lerpedLoc;

  // Depth data
  int[] depth;

  // What we'll show the user
  PImage display;

  KinectTracker() {
    // This is an awkard use of a global variable here
    // But doing it this way for simplicity
    kinect.initDepth();
    kinect.enableMirror(false);
    // Make a blank image
    display = createImage(kinect.width, kinect.height, RGB);
    // Set up the vectors
    loc = new PVector(0, 0);
    lerpedLoc = new PVector(0, 0);
  }

  void track() {
    // Get the raw depth as array of integers
    depth = kinect.getRawDepth();

    // Being overly cautious here
    if (depth == null) return;

    float sumX = 0;
    float sumY = 0;
    float count = 0;

    for (int x = 0; x < kinect.width; x++) {
      for (int y = 0; y < kinect.height; y++) {

        int offset =  x + y*kinect.width;
        // Grabbing the raw depth
        int rawDepth = depth[offset];

        // Testing against threshold
        if (rawDepth < threshold && rawDepth>minThreshold) {
          sumX += x;
          sumY += y;
          count++;
        }
      }
    }
    // As long as we found something
    if (count != 0) {
    }

    // Interpolating the location, doing it arbitrarily for now
    lerpedLoc.x = PApplet.lerp(lerpedLoc.x, loc.x, 0.3f);
    lerpedLoc.y = PApplet.lerp(lerpedLoc.y, loc.y, 0.3f);
  }

  PVector getLerpedPos() {
    return lerpedLoc;
  }

  PVector getPos() {
    return loc;
  }

  void display() {
    PImage img = kinect.getDepthImage();

    // Being overly cautious here
    if (depth == null || img == null) return;

    // CLEAR ALL BLOBS
    blobs.clear();




    // Going to rewrite the depth image to show which pixels are in threshold
    // A lot of this is redundant, but this is just for demonstration purposes
    display.loadPixels();
    for (int x = 0; x < kinect.width; x++) {
      for (int y = 0; y < kinect.height; y++) {

        int offset = x + y * kinect.width;
        // Raw depth
        int rawDepth = depth[offset];
        int pix = x + y * display.width;
        //float threshold = map(y, 0, kinect.height, 694, 760 );
        float threshold = map(y, 0, kinect.height, 735, 790 );
        float minthresh = map(y, 0, kinect.height, 700, 750);
        //float minthresh = map(y, 0, kinect.height, 670, 720);
        if (rawDepth < threshold && rawDepth>minthresh && x>180 && y<kinect.height-20 && y>100) {


          // A red color instead
          display.pixels[pix] = color(255);
        } else {
          display.pixels[pix] = color(0);
        }
      }
    }




    display.updatePixels();



    // Draw the image
    offscreen.image(display, 0, 0);


    ////// START BLOB DETECTION
    // Begin loop to walk through every pixel
    for (int x = 0; x < display.width; x++ ) {
      for (int y = 0; y < display.height; y++ ) {
        int loc = x + y * display.width;
        // What is current color
        color currentColor = display.pixels[loc];
        float r1 = red(currentColor);
        float g1 = green(currentColor);
        float b1 = blue(currentColor);
        float r2 = red(trackColor);
        float g2 = green(trackColor);
        float b2 = blue(trackColor);

        float d = distSq(r1, g1, b1, r2, g2, b2); 

        if (d < thresholdBlob*thresholdBlob) {

          boolean found = false;
          for (Blob b : blobs) {
            if (b.isNear(x, y)) {
              b.add(x, y);

              found = true;
              break;
            }
          }

          if (!found) {
            Blob b = new Blob(x, y);
            blobs.add(b);
          }
        }
      }
    }

    for (Blob b : blobs) {
      if (b.size() > 500) {
        b.show();
      }
    }
  }




  void setThreshold(int t) {
    threshold =  t;
  }

  void setMinThreshold(int tm) {
    minThreshold = tm;
  }
}



//BLOB CALCULATION
// Custom distance functions w/ no square root for optimization
float distSq(float x1, float y1, float x2, float y2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1);
  return d;
}


float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
  return d;
}
