import SimpleOpenNI.*;
SimpleOpenNI kinect;

int closestValue;
float minT = 500;
float maxT = 2000;
PImage img;

// declare global variables for the
// previous x and y coordinates
int previousX;
int previousY;

int blob_array[];
int userCurID;
int cont_length = 640*480;

color c1;
color c2;

void setup(){
  size(640, 480);
  frameRate(3);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.setMirror(true);
  kinect.enableUser();
  colorMode(HSB, 100);
  img = createImage(640, 480, RGB);
  smooth();
  blob_array=new int[cont_length];
}

void draw(){
  background(0);

  kinect.update();
  loadPixels();

  int[] depth = kinect.depthMap();
  
  float sumX = 0;
  float sumY = 0;
  float totalPixels = 0;
  int[] userMap =null;
  int userCount = kinect.getNumberOfUsers();
  if (userCount > 0) {
  userMap = kinect.userMap();
  }
  
  c1 = color(random(100), 100, 100);
  c2 = color(random(100), 100, 30);
          
    for(int y = 0; y < img.height; y++){
      for(int x = 0; x < img.width; x++){
        float n = map(y, 0, img.height, 0, 1);
            color newc = lerpColor(c1, c2, n);
            stroke(newc);
            line(0, y, img.width, y);
        int offset = x + y * img.width;
        int d = depth[offset];
      
      
        if(d > minT && d < maxT && x > 100){
          img.pixels[offset] = newc;
          
        if (userMap != null && userMap[offset] > 0) {
          userCurID = userMap[offset];
          blob_array[offset] = 255;
          
          fill(200,0,200);
        }
          
          closestValue = d;
          sumX += x;
          sumY += y;
          totalPixels++;
        } else {
          img.pixels[offset] = color(0);
      }
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
