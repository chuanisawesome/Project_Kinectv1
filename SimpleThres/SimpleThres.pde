import SimpleOpenNI.*;
import processing.opengl.*;
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
float textColor = 0;

void setup(){
  size(1920, 1280);
  frameRate(20);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.setMirror(true);
  kinect.enableUser();
  colorMode(HSB, 100);
  img = createImage(640, 480, RGB);
  smooth();
  blob_array=new int[cont_length];
  c1 = color(random(36), 255, 255);
  c2 = color(random(36), 255, 255);
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



    for(int y = 0; y < img.height; y++){
      for(int x = 0; x < img.width; x++){
        float n = map(y, 0, img.height, 0, 1);
        // randomized gradient color
        if (second() % 10 == 0) {
          c1 = color(random(36), 255, 255);
          c2 = color(random(36), 255, 255);
        }
        color newc = lerpColor(c1, c2, n);
        stroke(newc);
        //line(0, y, img.width, y);
        int offset = x + y * img.width;
        int d = depth[offset];

      // min and max threshold that is set
        if(d > minT && d < maxT && x > 100){
          img.pixels[offset] = newc;

      // if there is no user detected
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
      // makes background black
          img.pixels[offset] = color(0);
      }
    }
   }
   // updates the img pixels
    img.updatePixels();
    image(img, 0, 0);
    // get center of mass of a user
    //float avgX = sumX / totalPixels;
    //float avgY = sumY / totalPixels;

    IntVector userList = new IntVector();
    kinect.getUsers(userList);
    for (int i=0; i<userList.size(); i++) {
      int userId = userList.get(i);
    // get center of mass of a user
    PVector position = new PVector();
    kinect.getCoM(userId, position);
    // rainbow text color
    textSize(20);
    if (textColor >= 255) {
      textColor=0;
    } else {
      textColor++;
    }
    kinect.convertRealWorldToProjective(position, position);
    textSize(20);
    text("you're hot", position.x, position.y);
    fill(textColor, 255,255);
  }
}

//rm img
