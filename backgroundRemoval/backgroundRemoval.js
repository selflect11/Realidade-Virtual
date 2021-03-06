import processing.video.*;

Capture video;
PImage[] backgroundImages;
float threshold = 50;
int npast = 6;
int ipast = 0, n = 0;
int hyst = 20;
int hmatrix[][];
PImage textura;

float getMedian(PImage[] images){
  
}

void setup(){
   size(640, 480);
   video = new Capture(this, width, height, 30);
   video.start();
   backgroundImages = new PImage[npast];
   for (int i = 0; i < npast; i++) 
     backgroundImages[i] = createImage(video.width, video.height, RGB);
   hmatrix = new int[width][height];
   textura = loadImage("CottonCandy_640.jpg");
}

void draw(){
  if (video.available()){
    video.read();
  }
  
  loadPixels();
  video.loadPixels();
  
  if (n >= npast) {
    for (int i = 0; i < npast; i++)
      backgroundImages[i].loadPixels();
    
    // Desenha no background
    image(video, 0, 0);
    // loop
    for (int x = 0; x < video.width; x++){
      for (int y = 0; y < video.height; y++){
        int loc = x + y*video.width;
        color fgColor = video.pixels[loc];
  
        float r2 = 0.0, g2 = 0.0, b2 = 0.0;
        for (int i = 0; i < npast; i++) {
          color bgColor = backgroundImages[i].pixels[loc];
          r2 += red(bgColor) * (1.0/npast);
          g2 += green(bgColor) * (1.0/npast);
          b2 += blue(bgColor) * (1.0/npast);
        }
  
        float r1 = red(fgColor);
        float g1 = green(fgColor);
        float b1 = blue(fgColor);
        //float diff = dist(r1,g1,b1,r2,g2,b2);
        float diff = abs(r1-r2)+abs(g1-g2)+abs(b1-b2);
  
        if (diff > threshold){
          hmatrix [x][y] = hyst;
        } else {
          if (hmatrix[x][y]>0) hmatrix[x][y]--;
        }
        if (hmatrix[x][y]>0) {
           pixels[loc] = fgColor;
        } else {
           pixels[loc] = color(0);
        }
      }
    }
  }
  n++;
  if (n < 20) {
    backgroundImages[ipast].copy(video, 0, 0, video.width, video.height, 0, 0, video.width, video.height);
    backgroundImages[ipast].updatePixels();
    ipast = (ipast+1)%npast;
  }
  
  updatePixels();
  blend(textura,0,0,width,height,0,0,width,height,DODGE);
}

void mousePressed(){
//  backgroundImage.copy(video, 0, 0, video.width, video.height, 0, 0, video.width, video.height);
//  backgroundImage.updatePixels();
}