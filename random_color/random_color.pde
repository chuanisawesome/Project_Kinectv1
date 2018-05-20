import SimpleOpenNI.*;
import java.util.*;

SimpleOpenNI context;
//--------------------------------------
int[] userID; // int of each user being  tracked
PImage kinectDepth; // image storage from kinect

color[] userColor = new color[]{ color(0,0,255), color(0,255,255), color(0,255,0),
                                 color(255,255,0), color(240,150,5), color(255,0,0)}; // user colors
color usericon = color(0, 255, 0);
int blob_array[];
int userCurID;
int cont_length = 640*480;

void setup()
{
  size(1450, 1350); //window size
  context = new SimpleOpenNI(this); // start and enable kinect object  
  context.setMirror(true); // set mirroring object
  context.enableDepth(); // enable depth  camera
  context.enableUser(); // enable skeleton generation for all joints
  context.isInit(); // enable scene 
  smooth(); // smooth out the drawing
  blob_array=new int[cont_length]; // initialize blob_array size
}
 
void draw() {
  background(51); //set background to black color
  noStroke();
  context.update(); // update kinect in each frame
  kinectDepth = context.depthImage(); // get Kinect data
  image(kinectDepth,0,0); // draw depth image at coordinates (0,0)
  IntVector userList = new IntVector();
  kinect.getUsers(userList); // gets list of users
  userID = context.getUsers(); // get all user IDs of tracked users
  int[] depthValues = context.depthMap(); // save all depth values in a array
  int[] userMap = null; // initalize array to null
  int userCount = context.getNumberOfUsers(); // get number of user in scene
  if (userCount > 0) { // check if number of user is more than zero
    userMap = context.userMap(); // get user pixles of all the users
  }
  loadPixels();
  for (int y=0; y<context.depthHeight(); y++) {
    for (int x=0; x<context.depthWidth(); x++) {
      int index = x + y * context.depthWidth();
      if (userMap != null && userMap[index] > 0) {
        fill(#FF0335);
        userCurID = userMap[index];
        blob_array[index] = 255;
        PVector position = new PVector(); 
        kinect.getCoM(userId, position); // gets users center of mass
        kinect.convertRealWorldToProjective(position, position);
        textSize(20);
        text("you're hot", position.x, position.y, 25, 25);
        //usericon=userColors[colorIndex];
        fill(userColor[int(random(0,10))],x,y); // put your sample random color
      }
      else {
        blob_array[index]=0;
      }
    }
  }
}
void onNewUser(int userId) {
  println("you're hot" + userId);
}
void onLostUser(int userId) {
  println("you're out " + userId);
}

void applyColor() {  // Generate the heat map
  pushStyle(); // Save current drawing style
  colorMode(HSB, 1, 1, 1); // Set drawing mode to HSB instead of RGB
  loadPixels();
  int p = 0;
  for (int r = 0; r < height; r++) {
    for (int c = 0; c < width; c++) {
      // Get the heat map value 
      float value = interp_array[c][r];
      // Constrain value to acceptable range.
      value = constrain(value, 25, 30);
      // Map the value to the hue
      // 0.2 blue
      // 1.0 red
      value = map(value, 25, 30, 0.2, 1.0);
      pixels[p++] = color(value, 0.9, 1);
    }
  }
  updatePixels();
  popStyle(); // Restore original drawing style
}
