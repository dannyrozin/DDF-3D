
// DDF 2018
// pose to the camera and press R to export DXF

import processing.dxf.*;
import processing.video.*;

// Size of each cell in the grid
int cellSize = 6;
// Number of columns and rows in our system
int cols, rows;
// Variable for capture device
Capture video;
boolean record = false;
float[][] brightnesses= new float[640][480];

void setup() {
  size(640, 480, P3D);           // DXF like P3D
  //set up columns and rows
  cols = width / cellSize;
  rows = height / cellSize;
  colorMode(RGB, 255, 255, 255, 100);
  rectMode(CENTER);

  // Uses the default video input, see the reference if this causes an error
  video = new Capture(this, width, height, 15);
  video.start();
}


void draw() { 
  rotateY(0.5);               // rotating a bit so that we can appreciate the 3D
  if (video.available()) {
    video.read();
    video.loadPixels();
   // video.filter(BLUR,10);
    background(0);
    fill(0,255,0);
    stroke (0);
    noStroke();
    if (record == true) {
      beginRaw(DXF, "output.dxf"); // Start recording to the file
      noStroke();                    // we dont want the outline, just the faces of the boxes
    }
    // Begin loop for columns
    for (int i = 0; i < cols;i++) {
      // Begin loop for rows
      for (int j = 0; j < rows;j++) {

        // Where are we, pixel-wise?
        int x = i * cellSize;
        int y = j * cellSize;
        int loc = (video.width - x - 1) + y*video.width; // Reversing x to mirror the image

        // Each oval is sized  determined by brightness
        color c = video.pixels[loc];
        brightnesses[x][y] = 3*((brightness(c)) / 255.0) * cellSize*5.0; // need to be inverted , the ovals are black
      }
    }
    
    
    for (int i = 0; i < cols-1;i++) {
      for (int j = 0; j < rows-1;j++) {
         int x = i * cellSize;
        int y = j * cellSize;
         int loc = (video.width - x - 1) + y*video.width; // Reversing x to mirror the image

        // Each oval is sized  determined by brightness
        color c = video.pixels[loc];
        fill(c);
       beginShape();
       vertex(x,y,brightnesses[x][y]);
         vertex(x+cellSize,y,brightnesses[x+cellSize][y]);
          vertex(x+cellSize,y+cellSize,brightnesses[x+cellSize][y+cellSize]);
          vertex(x,y+cellSize,brightnesses[x][y+cellSize]);
          endShape(CLOSE);
      }
    }

    if (record == true) {
      endRaw();
      println("recorded DXF");
      record = false; // Stop recording to the file
    }
  }
}
void keyPressed() {
  if (key == 'R' || key == 'r') { // Press R to save the file
    record = true;
  }
}