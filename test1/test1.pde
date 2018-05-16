import processing.opengl.*;
import org.openkinect.freenect.*;
import org.openkinect.processing.*;
import SimpleOpenNI.*;

SimpleOpenNI kinect;

int closestValue;
int closestX;
int closestY;
PImage cam;
PImage backgroundImage; // background image
PImage heatmapBrush; // radial gradient used as a brush. Only the blue channel is used.
PImage heatmapColors; // single line bmp containing the color gradient for the finished heatmap, from cold to hot
PImage clickmapBrush; // bmp of the little marks used in the clickmap
PImage gradientMap; // canvas for the intermediate map
PImage heatmap; // canvas for the heatmap
ArrayList points = new ArrayList() ;
float maxValue = 0; // variable storing the current maximum value in the gradientMap

void setup()
{
    size(1450, 1350);
    frameRate(25);
    //fullScreen();
    background(0);
    surface.setResizable(true);
    noStroke();
    fill(102);
    kinect = new SimpleOpenNI(this);
    kinect.setMirror(true);
    kinect.enableDepth();
    //kinect.enableRGB();
    kinect.enableUser();
    colorMode(HSB);
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
                pixels[pixel] = color(0,0,0);
        }
    }
    updatePixels();
    }
}
