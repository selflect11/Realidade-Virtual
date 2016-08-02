import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;
PImage img;
int hueRange = 360;
float hue, saturation, brightness = 0;
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
  video = new Capture(this, 640, 480, 30);
  opencv = new OpenCV(this, 640, 480);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  colorMode(HSB, (hueRange - 1));
  video.start();
  background(255);
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
    //color c = video.get(faceX - 10, faceY - 10);
    //color c2 = video.get(faceX + 10, faceY + 10);
    float centerX = (faceX + faces[i].width/2);
    float centerY = (faceY + faces[i].height/2);
    
    //extractColorFromImage(int(faceX+20), int(faceY+20),int(faces[i].width-40), int(faces[i].height-20) );
      
    ellipse(centerX,centerY, 1.2*faces[i].width, 1.2*faces[i].height);
    fill(getColor(int(faceX + 20), int(faceY + 20), int(faces[i].width - 40), int(faces[i].height - 20)));
    //fill(this.hue, this.saturation, this.brightness, 55);
    //fill(constrain(255 * (i%3), 0, 255), constrain(255 * ((i+1)%3), 0, 255), constrain(255 * ((i-1)%3), 0, 255), 55);
    //loadPixels(); 
    
  }
  //updatePixels();
  //filter(BLUR, 6);
  
}

void captureEvent(Capture c) {
  c.read();
}

private void extractColorFromImage(int faceX, int faceY, int w, int h) {
    img = video.get(faceX, faceY, w, h);
    image(img, 0,0);
    int numberOfPixels = img.pixels.length;
    int[] hues = new int[hueRange];
    float[] saturations = new float[hueRange];
    float[] brightnesses = new float[hueRange];

    for (int i = 0; i < numberOfPixels; i++) {
      int pixel = img.pixels[i];
      int hue = Math.round(hue(pixel));
      float saturation = saturation(pixel);
      float brightness = brightness(pixel);
      hues[hue]++;
      saturations[hue] += saturation;
      brightnesses[hue] += brightness;
    }

    // Find the most common hue.
    int hueCount = hues[0];
    int hue = 0;
    for (int i = 1; i < hues.length; i++) {
       if (hues[i] > hueCount) {
        hueCount = hues[i];
        hue = i;
      }
    }

    // Set the vars for displaying the color.
    this.hue = hue;
    this.saturation = saturations[hue] / hueCount;
    this.brightness = brightnesses[hue] / hueCount;
  }
  
color getColor(int faceX, int faceY, int w, int h) {
    img = video.get(faceX, faceY, w, h);
    image(img, 0,0);
    int numberOfPixels = img.pixels.length;
    float r = 0, g = 0, b = 0;

    for (int i = 0; i < numberOfPixels; i++) {
      int pixel = img.pixels[i];
      r += red(pixel)/numberOfPixels;
      g += green(pixel)/numberOfPixels;
      b += blue(pixel)/numberOfPixels;
    }
  return color(254 - r, 254 - g, 254 - b, 55);
  }