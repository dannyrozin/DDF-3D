
/* DDF 2018
/** Exoprts DXF, press R when you want to Export
 
 
 * Linear Averages
 * by Damien Di Fede. 
 * This sketch demonstrates how to use the averaging abilities of the FFT.
 * 128 linearly spaced averages are requested and then those are drawn as rectangles.
 */

import ddf.minim.analysis.*;
import ddf.minim.*;
int countFrames=0;
Minim minim;
AudioPlayer jingle;
FFT fft;
import processing.dxf.*;
boolean record = false;
float [][] readings = new float[40][50];  // our aray to hold all the fft readings for export


void setup()
{
  size(800, 600, P3D);   
  minim = new Minim(this);

  jingle = minim.loadFile("jingle.mp3", 2048);
  // loop the file
  jingle.loop();
  // create an FFT object that has a time-domain buffer the same size as jingle's sample buffer
  // and a sample rate that is the same as jingle's
  // note that this needs to be a power of two 
  // and that it means the size of the spectrum will be 1024. 
  // see the online tutorial for more info.
  fft = new FFT(jingle.bufferSize(), jingle.sampleRate());
  // use 128 averages.
  // the maximum number of averages we could ask for is half the spectrum size. 
  fft.linAverages(128);

  stroke(0);
}

void draw() {
  background(0);
  countFrames++;
  translate(width/2, height/2, 0);      // traslating so that we rotate around the center
  rotateX(mouseX/100.0);                 //rotating with the mouse to look around
  rotateY(mouseY/100.0);
  if (countFrames > 49) {                // we limit ourselves to 50 readdings and then start over
    countFrames = 0;
  }

  fft.forward(jingle.mix);
  int w = int(fft.specSize()/128);
  for (int i = 0; i < 40; i++) {        // we are using the lower 40 frequencies
    readings[i][countFrames]=fft.getAvg(i);  // put all the readings into our array
  }  

  if (record == true) {
    beginRaw(DXF, "output.dxf");           // Start recording to the file
    noStroke();
  }

  for (int count=0; count< 50; count++) {  //  draw 50 frames worth of readings
    for (int i = 0; i < 40; i++) {        // draw 40 frequencies per reading
      fill(0, 0, 255);
      if (count == countFrames)fill(255, 255, 0);    // to show the current readding in yellow
      pushMatrix();
      translate(i*w+50, count*10, 0);
      box(10, 10, readings[i][count]*10);    // draw a box per frequency
      popMatrix();
    }
  }
  if (record == true) {
    endRaw();
    record = false;                         // Stop recording to the file
    println("recorded DXF");
  }
}

void keyPressed() {
  if (key == 'R' || key == 'r') { // Press R to save the file
    record = true;
  }
}

void stop() {
  // always close Minim audio classes when you finish with them
  jingle.close();
  minim.stop();
  super.stop();
}