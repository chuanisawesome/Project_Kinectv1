import SimpleOpenNI.*;
import java.util.*;

SimpleOpenNI context;
//--------------------------------------
int[] userID; // int of each user being  tracked
PImage kinectDepth; // image storage from kinect
// user colors
color[] userColor = new color[]{ color(255,0,0), color(0,255,0), color(0,0,255),
                                 color(255,255,0), color(255,0,255), color(0,255,255)};
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
  background(0); //set background to black color
  context.update(); // update kinect in each frame
  kinectDepth = context.depthImage(); // get Kinect data
  image(kinectDepth,0,0); // draw depth image at coordinates (0,0)
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
        //usericon=userColors[colorIndex];
        text(userColor[int(random(0,10))],x,y); // put your sample random color
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
