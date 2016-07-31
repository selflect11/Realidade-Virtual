import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;
// BOM : sin(PI * k/255)*(255 - k) -- Duas caras
float distort(float k){
	return 255 - k;
}

color crazyColor(float r, float g, float b){
  return color(constrain(distort(r), 0, 255), constrain(distort(g), 0, 255), constrain(distort(b), 0, 255));
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
  image(video, 0, 0 );
 
  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);
  Rectangle[] faces = opencv.detect();
  int faceX, faceY, pixelPos;
  int totalR = 1, totalG = 1, totalB = 1;
  for (int i = 0; i < faces.length; i++) {
    //rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
    faceX = faces[i].x;
    faceY = faces[i].y;
    loadPixels();
    for (int fx = faceX; fx < faceX + faces[i].width; fx++){
      for (int fy = faceY; fy < faceY + faces[i].height; fy++){
        pixelPos = fx + fy * video.width;
        totalR += red(pixels[pixelPos]);
        totalG += green(pixels[pixelPos]);
        totalB += blue(pixels[pixelPos]);
        //pixels[pixelPos] = crazyColor(red(video.pixels[pixelPos]), green(video.pixels[pixelPos]), blue(video.pixels[pixelPos]));
      }
    } //<>//
    println(totalR);
    fill(constrain(255 * totalR/(totalR+totalG+totalB), 0, 255), constrain(255 * totalG/(totalR+totalG+totalB), 0, 255), constrain(255 * totalB/(totalR+totalG+totalB), 0, 255), 55);
    rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
    loadPixels();
  } //<>//
  updatePixels();
}

void captureEvent(Capture c) {
  c.read();
}