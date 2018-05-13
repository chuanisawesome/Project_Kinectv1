import processing.opengl.*;
import org.openkinect.freenect.*;
import org.openkinect.processing.*;
import SimpleOpenNI.*;

SimpleOpenNI kinect;

int closestValue;
int closestX;
int closestY;
PImage cam;
int screenWidth = displayWidth;
int screenHeight = displayHeight;


void setup()
{
    //size(640, 480);
    frameRate(5);
    fullScreen();
    background(0);
    frame.setResizable(true);
    noStroke();
    fill(102);
    kinect = new SimpleOpenNI(this);
    kinect.setMirror(true);
    kinect.enableDepth();
    //kinect.enableRGB();
    kinect.enableUser();
}

void draw()
{
    background(0);
    kinect.update();

    PImage depthImage = kinect.userImage();
    //PImage rgbImage = kinect.rgbImage();

    //image(depthImage, 0, 0);
    cam = kinect.userImage().get();
    //image(cam, 0, 0);
    //depthImage.resize(displayWidth, displayHeight);
    //image(depthImage, 0, 0);
    //image(depthImage, 0, 0, displayWidth, displayHeight);
    image(cam, 0, 0, width, height);
    //image(rgbImage, 0, 0);
    //int[] depthValues = kinect.depthMap();
    int[] depthValues = kinect.userMap();

    IntVector userList = new IntVector();
    kinect.getUsers(userList);
    for (int i=0; i<userList.size(); i++) {
      int userId = userList.get(i);

    PVector position = new PVector();
    kinect.getCoM(userId, position);

    kinect.convertRealWorldToProjective(position, position);
    textSize(40);
    text("you're hot", 25, 25);

    loadPixels();
    for (int y=0; y < 480; y++) {
        for (int x=0; x < 640; x++) {
            int pixel = x + y * 640;
            int currentDepthValue = depthValues[pixel];

            if ( currentDepthValue > 610 || currentDepthValue > 1525 || currentDepthValue < closestValue)
                pixels[pixel] = color(255,0,0);
        }
    }
    updatePixels();
    }
}
