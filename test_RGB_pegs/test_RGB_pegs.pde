// The world pixel by pixel 2019
// Daniel Rozin
// Adjusting colors of a video
// uses PXP methods in the bottom
int cell = 15;
float count;
import processing.video.*;
int Rs[]= new int[0];
int Gs[]= new int[0];
int Bs[]= new int[0];
PImage ourImage;
//color colors[]={ color(0,199,217),color(0,194,224)};
Capture ourVideo;          // variable to hold the video
void setup() {
  size(1280, 720, P3D);
  frameRate(120);
  ourVideo = new Capture(this, width, height);       // open default video in the size of window
  ourVideo.start();                                  // start the video
  //noCursor();  
  noStroke();// so we can see the little smiley

  ourImage = loadImage("RGB.png");
  ourImage.loadPixels();
  for (int i= 0; i< ourImage.width; i++) {
    PxPGetPixel(i, 0, ourImage.pixels, ourImage.width); 
    if (!(R==0 && G==0 && B==0)) {
      Rs= append(Rs, R);
      Gs= append(Gs, G);
      Bs= append(Bs, B);
    }
  }
  for (int i=0; i< Rs.length; i++)
    println(Rs[i], Bs[i], Gs[i]);
  // noSmooth();
  // smooth(8);
}

void draw() {
  rotateY(mouseX/100.0);
  scale(mouseY/100.0);
  count++;
  count%= width;
  background (50);
  float ratio=1.154939587775409;
  ortho();
  fill(0);
  translate(0, 0, -10);
  ellipse (width/2, height/2, 700, 700);
  translate(0, 0, 10);
  directionalLight(255, 255, 255, 0, 900/ 100.0, -200/100.0);
  directionalLight(200, 200, 200, 0, 900/ 100.0, -200/100.0);
  ambientLight(20, 20, 20);
  randomSeed(0);
  cell = 16;
  if (ourVideo.available())  ourVideo.read();       // get a fresh frame of video as often as we can
  ourVideo.loadPixels();  
  fill(255, 255, 255);
  // load the pixels array of the video 
  // load the pixels array of the window  
  int county =0;
  for (int x = 0; x<width; x+=cell) {
    for (int y = 0; y<height* ratio; y+=cell) {


      int xToUse= x + ((y/cell)%2 )*cell/2;
      float yToUse= y/ratio;
      PxPGetPixel(xToUse, (int)yToUse, ourVideo.pixels, width);
      if (mousePressed){
        float thisDist = dist (xToUse, yToUse, mouseX, mouseY)+count;
        R = (int)thisDist;
        G = 255-(int)thisDist;
        B = mouseY;
        
      }

      float thisdist=dist (xToUse, yToUse, width/2, height/2);
      if (thisdist< 331) {
        pushMatrix();

        translate(xToUse, yToUse);

        R = -(int)map(R, 0, 255, 60, 160);
        G = -(int)map(G, 0, 255, 60, 160);
        B = -(int)map(B, 0, 255, 60, 160);

        int tilt = 90;
        int add= 0;
        if ((y/cell %2) ==1) {
          if ((x/cell)%3 ==0) {
            fill (255, add, add);    
            rotateZ(radians(R+tilt));
          }
          if ((x/cell)%3 ==1) {
            fill (add, 255, add);      
            rotateZ(radians(G+tilt));
          }
          if ((x/cell)%3 ==2) { 
            fill (add, add, 255);    
            rotateZ(radians(B+tilt));
          }
        }

        if ((y/cell %2) ==0) {
          if ((x/cell)%3 ==2) {
            fill (255, add, add);    
            rotateZ(radians(R+tilt));
          }
          if ((x/cell)%3 ==0) {
            fill (add, 255, add);    
            rotateZ(radians(G+tilt));
          }
          if ((x/cell)%3 ==1) {
            fill (add, add, 255);    
            rotateZ(radians(B+tilt));
          }
        }








        rotateY(radians(30));

        ellipse(0, 0, cell+1, cell-1);
        popMatrix();
        county++;
      }
    }
  }
  //  must call updatePixels once were done messing with pixels[]
  ourVideo.updatePixels(); 
  lights();
  ambientLight(60, 60, 60);
  fill(255, 255, 255);
  image(ourVideo, 0, 0, 100, 100);

  println (county, mouseX);
}



// our function for getting color components , it requires that you have global variables
// R,G,B   (not elegant but the simples way to go, see the example PxP methods in object for 
// a more elegant solution
int R, G, B, A;          // you must have these global varables to use the PxPGetPixel()
void PxPGetPixel(int x, int y, int[] pixelArray, int pixelsWidth) {
  int thisPixel=pixelArray[x+y*pixelsWidth];     // getting the colors as an int from the pixels[]
  A = (thisPixel >> 24) & 0xFF;                  // we need to shift and mask to get each component alone
  R = (thisPixel >> 16) & 0xFF;                  // this is faster than calling red(), green() , blue()
  G = (thisPixel >> 8) & 0xFF;   
  B = thisPixel & 0xFF;
}


//our function for setting color components RGB into the pixels[] , we need to efine the XY of where
// to set the pixel, the RGB values we want and the pixels[] array we want to use and it's width

void PxPSetPixel(int x, int y, int r, int g, int b, int a, int[] pixelArray, int pixelsWidth) {
  a =(a << 24);                       
  r = r << 16;                       // We are packing all 4 composents into one int
  g = g << 8;                        // so we need to shift them to their places
  color argb = a | r | g | b;        // binary "or" operation adds them all into one int
  pixelArray[x+y*pixelsWidth]= argb;    // finaly we set the int with te colors into the pixels[]
}
