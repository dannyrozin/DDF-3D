
//DDF 2018
//tracks the closest point and exports a 3D polygon of the path
// press s to start sampling , and again to stop
// press d to erase the sampling
// press r to export the dxf

import org.openkinect.freenect.*;
import org.openkinect.processing.*;
import processing.dxf.*;
// Danny Rozin based on
// Dan O'Sullivan based on 
// Daniel Shiffman
// Kinect Point Cloud example
// http://www.shiffman.net
// https://github.com/shiffman/libfreenect/tree/master/wrappers/java/processing

// Kinect Library object
Kinect kinect;
boolean record = false;
boolean sampling = false;
// Size of kinect image
int w = 640;
int h = 480;

int threshold = 50;
int[] Xs  = new int[0];
int[] Ys  = new int[0];
int[] Zs  = new int[0];
int samples = 0;
int lastX,lastY,lastZ;

public void setup() {
  size(640, 480,P3D);
  kinect = new Kinect(this);
  kinect.initDepth();


  ellipseMode(CENTER);
}

public void draw() {
  //rotateY(radians(mouseX));     // rotating so that we can see the 3D
  background(0);
  image(kinect.getDepthImage(),0,0);    // show the depth image
  fill(255);
  textMode(SCREEN);
  text("Processing FR: " + (int) frameRate+ "\nSamples: " + (int) samples+"\nSampling: " + sampling, 10, 16);

  // Get the raw depth as array of integers
  int[] depth = kinect.getRawDepth();

  int allX = 0,recordX=0,recordY=0,recordDepth = 3000;
  int allY = 0;
  int allZ = 0;
  int all = 0;



  for (int x = 0; x < w; x ++) {   // first round looking for closest pixel
    for (int y = 0; y < h; y ++) {
      int offset = x + y * w;
      int rawDepth = depth[offset];
      if (depth == null) return;
      if (rawDepth < recordDepth) {    
        recordDepth=rawDepth;     // remembering the depth of the closest pixel
      }
    }
  }

  for (int x = 0; x < w; x ++) { 
    for (int y = 0; y < h; y ++) {
      int offset = x + y * w;
      int rawDepth = depth[offset];
      if (depth == null) return;
      if (rawDepth < recordDepth+20) {  //second round we look for all pixels 20 depth from closest
        allX += x;
        allY += y;
        allZ +=rawDepth;
        all++;
      }
    }
  }
  if (all>0){
  recordX=allX / all;    // get the average x and y of all closest pixels
  recordY=allY / all;
  recordDepth=allZ / all;
  }

  int ourDepth = 200-recordDepth/5;  // making depth a smaller number
  translate(0,0,10);                // translating so our circle will be seen above the image
  ellipse(recordX,recordY, 20, 20);   // draw a circle where we found the closest pixel
  if (record == true) {
    beginRaw(DXF, "output.dxf"); // Start recording to the file
    noFill();                    // we only want the outline
  }
  stroke(255,0,0);
  noFill();

  // if we pressed s then we are sampling so we add the deepest point to our arrays
  // we dont want too many lines, so we only add a line if it is at least 5 pixels away from the last
  if (dist(lastX,lastY,lastZ,recordX,recordY,ourDepth)>5 && sampling == true && ourDepth <1000) {
    samples++;
    lastX=recordX;        // remembering this point to compare nxt time around            
    lastY=recordY;
    lastZ=ourDepth;

    Xs =append(Xs,recordX);       // add the point to our arrays
    Ys =append(Ys,recordY);
    Zs =append(Zs,ourDepth);
  }
  beginShape();                     // draw the polygon
  for (int i = 0;i< samples;i++) {
    vertex(Xs[i],Ys[i],Zs[i]*5-200);
  }
  endShape();

  if (record == true) {
    endRaw();
    println("recorded DXF");
    record = false; // Stop recording to the file
  }
}
void keyPressed() {
  if (key == 'R' || key == 'r') { // Press R to save the file
    record = true;
  }
  if (key == 'S' || key == 's') { // this will activate / deactivate the sampling
    sampling = !sampling;
  }

  if (key == 'd' || key == 'D') { // this erases the arrays to start over
    samples = 0;
    Xs=expand( Xs,0);
    Ys=expand( Ys,0);
    Zs=expand( Zs,0);
  }
}