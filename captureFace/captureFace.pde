import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;

float distort(float c){
	return 255 - c;
}

color crazyColor(float r, float g, float b){
  float new_r = distort(r);
  float new_g = distort(g);
  float new_b = distort(b);
  new_r = constrain(new_r, 0, 255);
  new_g = constrain(new_g, 0, 255);
  new_b = constrain(new_b, 0, 255);
  color c = color(new_r, new_g, new_b);
  return c;
}

void setup() {
  size(640, 480);
  video = new Capture(this, 640/2, 480/2);
  opencv = new OpenCV(this, 640/2, 480/2);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  

  video.start();
}

void draw() {
  scale(2);
  opencv.loadImage(video);

  image(video, 0, 0 );

  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);
  Rectangle[] faces = opencv.detect();
  //println(faces.length);
  float r,g,b;
  int faceX, faceY, pixelPos;
  for (int i = 0; i < faces.length; i++) {
    //println(faces[i].x + "," + faces[i].y);
    rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
    
    faceX = faces[i].x;
    faceY = faces[i].y;
    pixelPos = faceX + faceY*video.width; //<>//
    loadPixels(); //<>//
    for (int fx = faceX; fx < faces[i].width; fx++){ //<>//
      for (int fy = faceY; fy < faces[i].height; fy++){ //<>//
        println("worked2"); //<>//
        r = red(video.pixels[pixelPos]); //<>//
        g = green(video.pixels[pixelPos]); //<>//
        b = blue(video.pixels[pixelPos]); //<>//
        pixelPos = fx + fy*video.width;
        pixels[pixelPos] = crazyColor(r,g,b);
       
        println(r + "," + g + "," + b); //<>//
        println("coords" + fx + "," + fy); //<>//
      }
    }
  }
  updatePixels();
}

void captureEvent(Capture c) {
  c.read();
}