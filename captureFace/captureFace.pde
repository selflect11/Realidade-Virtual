import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;
// BOM : sin(PI * k/255)*(255 - k) -- Duas caras
float distort(float k){
	return 255 - pow(k,1.5) + 2*k;
}

color crazyColor(float r, float g, float b){
  return color(constrain(distort(r), 0, 255), constrain(distort(g), 0, 255), constrain(distort(b), 0, 255));
}

void setup() {
  size(640, 480);
  video = new Capture(this, 640, 480, 30);
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
  //println(faces.length);
  int faceX, faceY, pixelPos;
  for (int i = 0; i < faces.length; i++) {
    //println(faces[i].x + "," + faces[i].y);
    //rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
    faceX = faces[i].x;
    faceY = faces[i].y;
    pixelPos = faceX + faceY*video.width;
    loadPixels();
    //color crazyFuckinColor = crazyColor(red(video.pixels[pixelPos]), green(video.pixels[pixelPos]), blue(video.pixels[pixelPos]));
    //stroke(crazyColor(red(video.pixels[pixelPos]), green(video.pixels[pixelPos]), blue(video.pixels[pixelPos])));
    //fill(crazyFuckinColor);
    //ellipse(faceX, faceY, 160,160);
    //filter(BLUR, 4);
    
    for (int fx = faceX; fx < faceX + faces[i].width; fx++){
      for (int fy = faceY; fy < faceY + faces[i].height; fy++){
        pixelPos = fx + fy * video.width;
        pixels[pixelPos] = crazyColor(red(video.pixels[pixelPos]), green(video.pixels[pixelPos]), blue(video.pixels[pixelPos]));
      }
    } //<>//
  } //<>//
  updatePixels();
}

void captureEvent(Capture c) {
  c.read();
}