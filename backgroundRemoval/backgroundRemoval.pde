import processing.video.*;

Capture video;
PImage[] backgroundImages;
float threshold = 20;
int npast = 5;
int ipast = 0, n = 0;
int hyst = 10;
int hmatrix[][];
// Bucket related
int[] BCM;
int numBuckets = 26;
int redBucketIndex, greenBucketIndex, blueBucketIndex;
ArrayList blueBuckets[] = new ArrayList[numBuckets];
ArrayList greenBuckets[] = new ArrayList[numBuckets];
ArrayList redBuckets[] = new ArrayList[numBuckets];
//
PImage textura;

void setup(){
   size(640, 480);
   video = new Capture(this, width, height, 30);
   video.start();
   backgroundImages = new PImage[npast];
   for (int i = 0; i < npast; i++) 
     backgroundImages[i] = createImage(video.width, video.height, RGB);
   hmatrix = new int[width][height];
   textura = loadImage("CottonCandy_640.jpg");
   // Initializes bucket array
   for (int i = 0; i < numBuckets; i++){ 
     redBuckets[i] = new ArrayList(); //<>//
     blueBuckets[i] = new ArrayList();
     greenBuckets[i] = new ArrayList();
   }
   // Background color matrix
   int[] BCM = makeBackgroundColorMatrix(backgroundImages);
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
        int loc = x + y*video.width; //<>//
        color fgColor = video.pixels[loc];
        color bgColor = (color) BCM[loc];
        float r2 = red(bgColor);
        float g2 = green(bgColor);
        float b2 = blue(bgColor);
        float r1 = red(fgColor);
        float g1 = green(fgColor);
        float b1 = blue(fgColor);
        float diff = dist(r1,g1,b1,r2,g2,b2);
  
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
    backgroundImages[ipast].copy(video, 0, 0, video.width, video.height, 0, 0, video.width, video.height); //<>//
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

int[] makeBackgroundColorMatrix(PImage[] backgroundImages){
    int[] bgMatrix = new int[video.width*video.height];
    color[] colorArr = new color[npast];
    int pixelPos;
    for (int x = 0; x < video.width; x++){
      for (int y = 0; y < video.height; y++){
        pixelPos = x + y*video.width;
        // Get color array
        for (int imgIndex = 0; imgIndex < npast; imgIndex++){
          colorArr = append(colorArr, backgroundImages[imgIndex].pixels[pixelPos]);
        }
        // get the three buckets
        redBuckets = getBucket(colorArr, "red");
        greenBuckets = getBucket(colorArr, "green");
        blueBuckets = getBucket(colorArr, "blue");
        // gets the avg of most frequent bucket
        bgMatrix[x + y*video.width] = color(bucketAvg(redBuckets), bucketAvg(greenBuckets), bucketAvg(blueBuckets)); 
      }
    }
    return bgMatrix;
}

int getArrayLen(Integer arr[]){
  int len = 0;
  for (int i = 0; i < arr.length; i++){
    if (arr[i] != null){
      len++;
    } else {
      return len;
    }
  }
  return len;
}

// Receives list of colors; Puts into RGB buckets; 
ArrayList[] getBucket(color[] colors, String code){
  ArrayList[] buckets = new ArrayList[numBuckets];
  int bucketIndex;
  float colorChannel = 0;
  for (int i = 0; i < numBuckets; i++){
    buckets[i] = new ArrayList();
  }
  // Populates the buckets
  for (int i = 0; i < colors.length; i++){
    // buckets -> [0,5), [5,10), [10,15), ... , [245,250), [250,255)
    // Gets index by the formula bgColor ~= 10*bucketIndex + 5
    switch(code){ //<>//
      case "red":
        colorChannel = red(colors[i]);
      break;
      case "green":
        colorChannel = green(colors[i]);
      break;
      case "blue":
        colorChannel = blue(colors[i]);
      break;
    }
    bucketIndex = ceil((colorChannel-5)/10);
    buckets[bucketIndex].add(red(colors[i]));
  }
  return buckets;
}

// Receives buckets; Returns avg of largest bucket
float bucketAvg(ArrayList[] buckets){
  int largestBucketIndex = 0,
      largestBucketLen = buckets[largestBucketIndex].size();
  float avgColor = 0.0;
  // Finds largest bucket
  for (int i = 0; i < numBuckets; i++){ //<>//
    if (redBuckets[i].size() > largestBucketLen){
        largestBucketLen = redBuckets[i].size(); //<>//
        largestBucketIndex = i;
      }
  }
  // Gets the avg
  for (int i = 0; i < largestBucketLen; i++){
      avgColor += (float) redBuckets[largestBucketIndex].get(i) / largestBucketLen;
    } 
  return avgColor;
}