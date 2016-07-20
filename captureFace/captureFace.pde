import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;

float distort(float c){
	return 255 - c;
}

color crazyColor(float r, float g, float b){
  color from = color(r, g, b);
  color to = color(r + random(r-255,255-r), g + random(g-255,255-g), b + random(b-255,255-b));
  color interA = lerpColor(from, to, );
  return interA;
}

void setup() {
  size(640, 480);
  video = new Capture(this, 640, 480, 5);
  opencv = new OpenCV(this, 640, 480);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  

  video.start();
}

void draw() {
  //scale(2);
  opencv.loadImage(video);

  //image(video, 0, 0 );
 
  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);
  Rectangle[] faces = opencv.detect();
  //println(faces.length);
  int faceX, faceY, pixelPos;
  for (int i = 0; i < faces.length; i++) {
    println(faces[i].x + "," + faces[i].y);
    //rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
    faceX = faces[i].x;
    faceY = faces[i].y;
    pixelPos = faceX + faceY*video.width;
    loadPixels();
    color crazyFuckinColor = crazyColor(red(video.pixels[pixelPos]), green(video.pixels[pixelPos]), blue(video.pixels[pixelPos]));
    stroke(crazyColor(red(video.pixels[pixelPos]), green(video.pixels[pixelPos]), blue(video.pixels[pixelPos])));
    fill(crazyFuckinColor);
    ellipse(faceX, faceY, 160,160);
    filter(BLUR, 4);
    
    //for (int fx = faceX; fx < faceX + faces[i].width; fx++){
    //  for (int fy = faceY; fy < faceY + faces[i].height; fy++){
    //    pixelPos = fx + fy * video.width;
    //    pixels[pixelPos] = crazyColor(red(video.pixels[pixelPos]), green(video.pixels[pixelPos]), blue(video.pixels[pixelPos]));
    //  }
    //} //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//
  } //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//
  updatePixels();
}

void captureEvent(Capture c) {
  c.read();
}