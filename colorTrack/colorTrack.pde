import processing.video.*;

float threshold = 100;
boolean isFirstClick = true;
int[] xpos = new int[50];
int[] ypos = new int[50];
Capture video;
color trackColor;

void setup(){
  size(640, 480);
  video = new Capture(this, width, height, 15);
  trackColor = color(255, 0 , 0);
  smooth();
  video.start();
  for (int i = 0; i < xpos.length; i++){
    xpos[i] = 0;
    ypos[i] = 0;
  }
}

void draw(){
  if (video.available()){
    video.read();
  }
  video.loadPixels();
  image(video, 0,0);
  float worldRecord = 500;
  int closestX = 0;
  int closestY = 0;
  
  // Rollback
  for (int i = 0; i < xpos.length - 1; i++){
    xpos[i] = xpos[i+1];
    ypos[i] = ypos[i+1];
  }

  for (int x=0; x < video.width; x++){
    for (int y=0; y < video.height; y++){
      int loc = x + y*video.width;
      color currentColor = video.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(trackColor);
      float g2 = green(trackColor);
      float b2 = blue(trackColor);

      float d = dist(r1, g1, b1, r2, g2, b2);

      //
      if (d < worldRecord){
        if (isFirstClick) { //<>//
          worldRecord = d;
          closestX = x;
          closestY = y;
          xpos[xpos.length - 1] = closestX;
          ypos[ypos.length - 1] = closestY;
          isFirstClick = false;
        } else {
          if (abs(closestX - x) < threshold && abs(closestY - y) < threshold){ //<>//
            worldRecord = d;
            closestX = x;
            closestY = y;
            xpos[xpos.length - 1] = closestX;
            ypos[ypos.length - 1] = closestY;
          } else {
            xpos[xpos.length - 1] = closestX;
            ypos[ypos.length - 1] = closestY;
          }
        }
        
      }
    }
  }

    if (worldRecord < 10){
      //fill(trackColor);
      //strokeWeight(4.0);
      //stroke(0);
      //ellipse(closestX, closestY, 16, 16);
      for (int i = 0; i < xpos.length - 1; i++){
        noStroke();
        fill(trackColor - i*5);
        ellipse(xpos[i], ypos[i], 16, 16);
      }
    }
}

void mousePressed(){
  int loc = mouseX + mouseY*video.width;
  trackColor = video.pixels[loc];
}