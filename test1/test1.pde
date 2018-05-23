import processing.opengl.*;
import org.openkinect.freenect.*;
import org.openkinect.processing.*;
import SimpleOpenNI.*;

SimpleOpenNI kinect;

int closestValue;
int closestX;
int closestY;
PImage cam;

void setup()
{
    size(1450, 1350);
    frameRate(25);
    background(0);
    surface.setResizable(true);
    noStroke();
    fill(102);
    kinect = new SimpleOpenNI(this);
    kinect.setMirror(true);
    kinect.enableDepth();
    kinect.enableUser();
    colorMode(HSB);
}

void draw()
{
    background(0);
    kinect.update();

    PImage depthImage = kinect.userImage();
    cam = kinect.userImage().get();
    image(cam, 0, 0, width, height);
    int[] depthValues = kinect.userMap();

    IntVector userList = new IntVector();
    kinect.getUsers(userList);

    for (int i=0; i<userList.size(); i++) {
      int userId = userList.get(i);

    PVector position = new PVector();
    kinect.getCoM(userId, position);

    kinect.convertRealWorldToProjective(position, position);
    fill(255,255,255);
    textSize(40);
    text("you're hot", position.x, position.y, 25, 25);

    loadPixels();
    for (int y=0; y < 480; y++) {
        for (int x=0; x < 640; x++) {
            int pixel = x + y * 640;
            int currentDepthValue = depthValues[pixel];

            if ( currentDepthValue > 610 || currentDepthValue > 1525 || currentDepthValue < closestValue)
                pixels[pixel] = color(0,0,0);
        }
    }
    updatePixels();
    }
}
