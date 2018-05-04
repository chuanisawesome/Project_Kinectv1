import org.openkinect.freenect.*;
import org.openkinect.processing.*;

// Kinect Library object
Kinect kinect;

int threshold = 800;
PImage display;
PImage rgbImage;

void setup() {
   size(displayWidth, displayHeight);
  //size(1280, 520);
  smooth();
  kinect = new Kinect(this);
  kinect.initDepth();
  kinect.enableMirror(true);
  kinect.enableColorDepth(true);
  // creates a blank image same as kinect.width
  display = createImage(kinect.width, kinect.height, RGB);
}

void draw() {
  background(0);
  // set pixels in that image based on the raw depth  
  display.loadPixels();

  // Get the raw depth as array of integers
  int[] depth = kinect.getRawDepth();
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
        display.pixels[offset] = color(255, 0, 0);
                                 color(109, 57, 255);
                                 color(0,255,0);
                                 color(0,0,255);
        
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
  image(display, 0, 0);
}
