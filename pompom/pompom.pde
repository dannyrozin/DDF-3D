import processing.video.*;

int ball = 12;
int spacing = ball*2;
Capture video;
void setup() {
  size(640, 640, OPENGL);
  noStroke();
  video = new Capture(this, width, height);
  video.start();
  image(video,0,0);
  sphereDetail(6);
  
}

void draw() {
  lights();
  translate(width/2,0,0);
  rotateY(0.8);
  translate(-width/2,0,0);
  if (video.available()) {
    video.read();
    video.loadPixels();

    background (0);
    int shift, count=0;
    for (int x = 0; x < width; x+=spacing) {
      for (int y = 0; y < height; y+=spacing/2) {
        if ( (y%(2*spacing/2))==0) shift = spacing/2; 
        else shift = 0;
        
        int thisPix = x+ width*y;
        color thisColor = video.pixels[thisPix];
        float bright= brightness (thisColor)-128;

        float Zoffset= bright/(mouseX/10.0);
        pushMatrix();
       if (!mousePressed) translate(x+shift, y, Zoffset);
       else translate(x+shift, y, 0);
        fill(250);
        sphere(ball);
        translate(spacing/2, 0, -Zoffset);
        fill(50);
        sphere(ball);
        popMatrix();
        count++;
      }
    }
      println(count);
  }

  
}
