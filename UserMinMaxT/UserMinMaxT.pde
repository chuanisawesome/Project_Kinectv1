import org.openkinect.processing.*;

Kinect kinect;

float minT = 300;
float maxT = 800;
PImage img;

void setup() {
  size(640,480);
  frameRate(3);
  kinect = new Kinect(this);
  kinect.initDepth();
  kinect.enableMirror(true);
  img = createImage(kinect.width, kinect.height, RGB);
}

void draw() {
  background(0);
  img.loadPixels();
  
  int[] depth = kinect.getRawDepth();
  
  float sumX = 0;
  float sumY = 0;
  float totalPixels = 0;
  
  for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++) {
      int offset = x + y * kinect.width;
      int d = depth[offset];
      
      if (d > minT && d < maxT && x > 100) {
        img.pixels[offset] = color(255, 0, 140);
        
        sumX += x;
        sumY += y;
        totalPixels++;
       
      } else {
        img.pixels[offset] = color(0);
    }
  }
  img.updatePixels();
  image(img, 0, 0);
  
  float avgX = sumX / totalPixels;
  float avgY = sumY / totalPixels;
  //fill(150, 0, 255);
  textSize(20);
  text("you're hot", avgX, avgY);
  } 
}
