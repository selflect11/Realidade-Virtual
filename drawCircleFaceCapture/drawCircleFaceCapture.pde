import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;
// BOM : sin(PI * k/255)*(255 - k) -- Duas caras
float distort(float k){
  return k;
}

color crazyColor(float r, float g, float b){
  return color(constrain(distort(r), 0, 255), constrain(distort(g), 0, 255), constrain(distort(b), 0, 255));
}

color switchColor(int i){
  return color(255 / (i%3), 255 / ((i+1)%3), 255 / ((i-1)%3));
}

void setup() {
  size(640, 480);
  video = new Capture(this, 640, 480, 10);
  opencv = new OpenCV(this, 640, 480);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  video.start();
}

void draw() {
  //scale(2);
  opencv.loadImage(video);
  //image(video, 0, 0 );
  background(255);
  noStroke();
  //stroke(0, 255, 0);
  //strokeWeight(3);
  Rectangle[] faces = opencv.detect();
int faceX, faceY, pixelPos;
  
  for (int i = 0; i < faces.length; i++) {
    //rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
    faceX = faces[i].x;
    faceY = faces[i].y;
    float centerX = (faceX + faces[i].width/2);
    float centerY = (faceY + faces[i].height/2);
    ellipse(centerX,centerY, 1.2*faces[i].width, 1.2*faces[i].height);
    fill(constrain(255 * (i%3), 0, 255), constrain(255 * ((i+1)%3), 0, 255), constrain(255 * ((i-1)%3), 0, 255), 55);
    //loadPixels();
    
  }
  //updatePixels();
}

void captureEvent(Capture c) {
  c.read();
}