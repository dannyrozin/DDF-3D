//DDF 2023
// pose to the camera and press R to export OBJ
// need to add library OBJExport from "add library"

import nervoussystem.obj.*;
import processing.video.*;

// Size of each cell in the grid
int cellSize = 18;
// Number of columns and rows in our system
int cols, rows;
// Variable for capture device
Capture video;
boolean record = false;

void setup() {
  size(640, 480, P3D);           // DXF like P3D
  //set up columns and rows
  cols = width / cellSize;
  rows = height / cellSize;
  colorMode(RGB, 255, 255, 255, 100);
  rectMode(CENTER);

  // Uses the default video input, see the reference if this causes an error
  video = new Capture(this, width, height);
  video.start();
  image(video,0,0);        // hack to make camera work in Processing 4
}


void draw() { 
  rotateY(0.2);               // rotating a bit so that we can appreciate the 3D
  if (video.available()) {
    video.read();
    video.loadPixels();
    background(0);
    fill(255, 255, 0);
    stroke (0);
    if (record) {
      beginRecord("nervoussystem.obj.OBJExport", "filename.obj");
      noStroke();
    }

    for (int i = 0; i < cols; i++) {          // Begin loop for columns     
      for (int j = 0; j < rows; j++) {        // Begin loop for rows

        // Where are we, pixel-wise?
        int x = i * cellSize;
        int y = j * cellSize;
        int loc = (video.width - x - 1) + y*video.width; // Reversing x to mirror the image

        // Each oval is sized  determined by brightness
        color c = video.pixels[loc];
        float sz = ((brightness(c)) / 255.0) * cellSize*1.0; 

        pushMatrix();
        translate(x + cellSize/2, y + cellSize/2, sz/2);   // translate put the current x and y at the 0,0
        box(sz, sz, sz);                                    // draw a box corelated to the brightness
        popMatrix();
      }
    }

    if (record == true) {
         endRecord();
      println("recorded OBJ");
      record = false; // Stop recording to the file
    }
  }
}
void keyPressed() {
  if (key == 'R' || key == 'r') { // Press R to save the file
    record = true;
  }
}
