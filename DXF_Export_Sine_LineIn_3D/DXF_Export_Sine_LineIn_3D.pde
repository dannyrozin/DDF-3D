// DDF 2023
//  Make sure the audio input is set to the internal mic then sing into it to get nice waves
//   and press R to record DXF

import processing.dxf.*;
import processing.sound.*;

// Declare the sound source and Waveform analyzer variables
AudioIn input;
Waveform waveform;
boolean record = false;
int samples = 300;
void setup()
{
  size(512, 200, P3D);

  input = new AudioIn(this, 0);
  input.start();

  // Create the Waveform analyzer and connect the playing soundfile to it.
  waveform = new Waveform(this, samples);
  waveform.input(input);
}

void draw()
{
  if (record == ! true)rotateY(0.3);
  background(0);
  noStroke();
  fill(0, 0, 255);

  if (record == true) {
    beginRaw(DXF, "output.dxf"); // Start recording to the file
  }

  waveform.analyze();

  // draw the waveforms
  int skip = 2;
  for (int i = 0; i < samples- skip; i+=skip) {
    float thisReading = 20+waveform.data[i]*500;
    float nextReading = 20+waveform.data[i+skip]*500;
    println (thisReading);
    beginShape();
    vertex(i, 50 + thisReading, 0);
    vertex(i, 50 - thisReading, 50);
    vertex(i+skip, 50 - nextReading, 50);
    vertex(i+skip, 50 + nextReading, 0);
    endShape(CLOSE);
  }

  if (record == true) {
    endRaw();
    record = false; // Stop recording to the file
  }
}

void keyPressed() {
  if (key == 'R' || key == 'r') { // Press R to save the file
    record = true;
    println("Exported DXF");
  }
}
