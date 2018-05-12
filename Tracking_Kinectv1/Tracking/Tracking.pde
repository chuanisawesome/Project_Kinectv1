import org.openkinect.freenect.*;
import org.openkinect.processing.*;

// Kinect Library object
Kinect kinect;

int threshold = 1000;
PImage display;
PImage rgbImage;
PImage colordepth;
int x = 0;
int screenWidth = displayWidth; 
int screenHeight = displayHeight;

void setup() {
   //size(displayWidth, displayHeight);
  //size(1280, 520);
  frameRate(5);
  fullScreen();
  surface.setResizable(true);
  smooth(8);
  kinect = new Kinect(this);
  kinect.initDepth();
  kinect.initVideo();
  kinect.enableMirror(true);
  kinect.enableColorDepth(true);
  background(0);
  noStroke();
  fill(102);
  // creates a blank image same as kinect.width
  display = createImage(kinect.width, kinect.height, RGB);
}

void draw() {

  // set pixels in that image based on the raw depth
  display.loadPixels();

  // Get the raw depth as array of integers
  int[] depth = kinect.getRawDepth();
  PImage depthImage = kinect.getDepthImage();
  //image(kinect.getVideoImage(), 640, 0);
  image(kinect.getDepthImage(), 0, 0, displayWidth, displayHeight);
  depthImage.resize(displayWidth, displayHeight);
  image(kinect.getDepthImage(), 0, 0, displayWidth, displayHeight);

  // keep track of the sum of all the X pixels
  float sumX = 0;
  // keep track of the sum of all the Y pixels
  float sumY = 0;
  // total number of pixels
  float count = 0;
  for (int x = 0; x < kinect.width; x++) {
    for (int y = 0; y < kinect.height; y++) {
      int offset = x + y * kinect.width;
      int d = depth[offset];


      // if distance is between x and y let me see color else black (threshold) got rid of wall
      if (d < threshold) {
        display.pixels[offset] = color(0,0,0);

         // adding up all the X and Y pixels
        sumX += x;
        sumY +=y;
        // for every single pixels add one
        count++;
      } else {
        display.pixels[offset] = color(0);
      }
    }
  }
  display.updatePixels();
 image(kinect.getDepthImage(), 0, 0);
}
