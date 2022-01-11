// Daniel Shiffman
// Tracking the average location beyond a given depth threshold
// Thanks to Dan O'Sullivan

// https://github.com/shiffman/OpenKinect-for-Processing
// http://shiffman.net/p5/kinect/

import org.openkinect.freenect.*;
import org.openkinect.processing.*;
import deadpixel.keystone.*;
import java.awt.Robot;

// The kinect stuff is happening in another class
KinectTracker tracker;
Kinect kinect;

///BLOB TRACKING
color trackColor; 
float thresholdBlob = 25;
float distThresholdBlob = 50;
ArrayList<Blob> blobs = new ArrayList<Blob>();
PVector locatieblob = new PVector(0, 0);


//KEYSTONE
Keystone ks;
CornerPinSurface surface;
PGraphics offscreen;

//mouse control
Robot rbt;
boolean trackMouse = false;
int xmousePos;
int ymousePos;
int extraXValue;
int extraYValue;

//keystone size
int heightSurface = 640;
int widthSurface = 480;

float tlx = 0;
float tly = 0;

float trx = 640;
float trY = 0;

float blx = 0;
float bly = 480;

float brx= 640;
float bry = 480;

int heightKinect = 640;
int widthKinect = 480;

int prevX =0;
int prevY=0;

void setup() {
  //size(640, 480);
  //size for keystone
  size(800, 600, P3D);

  ks = new Keystone(this);
  surface = ks.createCornerPinSurface(640, 480, 20);
  offscreen = createGraphics(640, 480, P3D);

  //init Kinect & tracker
  kinect = new Kinect(this);
  kinect.enableMirror(false);
  tracker = new KinectTracker();
  trackColor = color(255);

  //init mouse
  try {
    rbt = new Robot();
  } 
  catch(Exception e) {
    e.printStackTrace();
  }
}

void draw() {
  offscreen.beginDraw();
  offscreen.background(255);

  // Run the tracking analysis
  tracker.track();
  // Show the image
  tracker.display();

  // Let's draw the raw location
  PVector v1 = locatieblob;
  offscreen.fill(50, 100, 250, 200);
  offscreen.noStroke();
  offscreen.ellipse(v1.x, v1.y, 20, 20);
  thread("getMousePos");


  //Let's draw the "lerped" location
  //PVector v2 = tracker.getLerpedPos();
  //fill(100, 250, 50, 200);
  //noStroke();
  //ellipse(v2.x, v2.y, 20, 20);

  offscreen.endDraw();
  background(0);
  surface.render(offscreen);
}

// Adjust the threshold with key presses
void keyPressed() {

  switch(key) {
  case 'c':
    ks.toggleCalibration();
    break;

  case 'l':
    ks.load();
    break;

  case 'o':
    // saoves the layout
    surface = ks.createCornerPinSurface(heightSurface+4, widthSurface+3, 20);
    heightSurface = heightSurface+4;
    widthSurface = widthSurface+3;

    surface.moveMeshPointBy(surface.TL, 
      tlx+8, 
      tly+6);

    surface.moveMeshPointBy(surface.TR, 
      trx+8, 
      trY+6);
    surface.moveMeshPointBy(surface.BL, 
      (blx+8)-35, 
      bly+6);
    surface.moveMeshPointBy(surface.BR, 
      (brx+8)+30, 
      bry+6);

    tlx = 0+8;
    tly = 0+6;

    trx = 640+8;
    trY = 0+6;

    blx = 0+8;
    bly = 480+6;

    brx= 640+8;
    bry = 480+6;

    heightKinect = heightKinect+4;
    widthKinect = widthKinect+3;

    println(widthKinect);
    println(heightKinect);

    offscreen = createGraphics(heightKinect, widthKinect, P3D);

    break;

  case 'm':
    trackMouse = !trackMouse;
    break;

  case 's':
    // saves the layout
    ks.save();
    break;
  }
}

void getMousePos() {
  if (trackMouse) {  
    prevX = xmousePos;
    prevY = ymousePos;
    
    float lerpedPosX = lerp(prevX, xmousePos, 0.8);
    float lerpedPosY = lerp(prevY, ymousePos, 0.8);
    
    
    if(abs(prevX - int(lerpedPosX)) < 30 && abs(prevY - int(lerpedPosY)) < 30){
        rbt.mouseMove(1792+(int(lerpedPosX)), ((int(lerpedPosY))  *2));

    }
    

  }
}
