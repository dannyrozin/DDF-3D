import gab.opencv.*;

ArrayList<Ripple> ripples;
Pixel pixels[] = new Pixel[0];
float rippleSpeed= 0.3 *30;
float pixelSpeed = 1*30;
int pixelWidth = 10;
int pixelSpacing = 12;
float pixelDepth= 4;
float ringDistance = 50;
int maxWidth=170*12;
int maxHeight=96;
int numOfRings=10;
float pixelRotateFactor=-0.004;
float pixelRotateShift =1570 ;
PImage ourImage, ourTexture;
PImage src, dst;
OpenCV opencv;
ArrayList<Contour> contours;
ArrayList<Contour> polygons;

void setup() {
  src = loadImage("cracked mud for blobs.png"); 
  size(1600, 1000, P3D);
  opencv = new OpenCV(this, src);
  ripples = new ArrayList<Ripple>();
//noSmooth();
  opencv.invert();
  opencv.threshold(1);
  dst = opencv.getOutput();

  contours = opencv.findContours();
  println("found " + contours.size() + " contours");
  // rectMode(CENTER);
  ourImage = loadImage("wtc.jpg");
  ourTexture = loadImage("wood.jpg");
  // ourTexture.resize(width/15,maxWidth/15);


  for (Contour contour : contours) {
    int centerX=0, centerY =0, count=0;
    for (PVector point : contour.getPolygonApproximation().getPoints()) {
      centerX+=point.x;
      centerY+=point.y;
      count++;
    }
    centerX/=count;
    centerY/=count;
    pixels= (Pixel[])   append(pixels, new Pixel(centerX, centerY, 0, pixelSpeed, contour )  );
  }
}

void draw() {

  // image(ourImage, -200,0, width,800);
  background (0);
  // lights();
 ambientLight(50, 50, 50);
 // directionalLight(255, 255, 255, 1, 0, -1);
  
   //directionalLight(255, 255, 255, mouseX, 0, -mouseY);
//camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, mouseX, 0, 0, 1, 0);
  translate(width/2, 0);

  rotateY(1.45);
     rotateZ(585/100.0);
  rotateX(156/100.0);
  pushMatrix();
  fill(255,255,255);
  translate(700,-150,-1000);
  pointLight(255,255,255,0,-0,-200);
    sphere (10);
  translate(0,-0,200);

    emissive(205,155,0);

   sphere (100);
       emissive(0,0,0);
   popMatrix();
   

   
   
     fill(220, 110, 50);
  //println(mouseX, mouseY, frameRate);
  //println(mouseX);
  translate(-width/2, 0);
  translate(800, -940, -1300);
  //println(-mouseY);
  /*
  for (int x = 0; x < maxWidth; x+=pixelSpacing) {
   pushMatrix();
   translate (x, 339);
   
   box( pixelWidth, pixelSpacing*8, pixelDepth);
   popMatrix();
   
   beginShape();
   texture(ourTexture);
   vertex(x-pixelWidth/2, 296-pixelWidth/2, -5     , x/5, 0);
   vertex(x-pixelWidth/2, 296-pixelWidth/2+pixelSpacing*8, -5    ,x/5, (0+4)      );
   vertex(x+pixelWidth-pixelWidth/2,  296-pixelWidth/2+ pixelSpacing*8, -5 , (x/5+1), (0+4)  );
   vertex(x-pixelWidth/2+pixelWidth, 296-pixelWidth/2, -5, (x/5+1), (0) );
   endShape();
   
   
   }
   */
 

  for (int i = ripples.size()-1; i >= 0; i--) { 
    // An ArrayList doesn't know what it is storing so we have to cast the object coming out
    Ripple ripple = ripples.get(i);
    ripple.grow();
    ripple.display();
    if (ripple.finished()) {
      // Items can be deleted with remove()
      ripples.remove(i);
      println (ripples.size());
    }
  }
  for (int i = 0; i< pixels.length; i++) { 
    pixels[i].didWave=false;
    pixels[i].checkRipples();
    pixels[i].display();
  }
  
}


void mouseClicked() {
  ripples.add(new Ripple(constrain(height-mouseY, 0, maxWidth), mouseX, rippleSpeed));
}



class Pixel {
  float x, y, w, speed, targetGray, gray;
  Contour contour;
  Boolean didWave=false;
  Pixel(int _x, int _y, int _w, float _speed, Contour _contour) {
    x=_x;
    y=_y;
    w=_w;
    speed= _speed;
    gray =0;
    targetGray = 0;
    contour=_contour;
  }
  void display() {
    float distFromCenter= dist(x,y, 600,700);
    float deltaX= (x-600);
    float deltaY= (y-700);
    float angi= atan(deltaX/deltaY);
    if (y>= 700)angi -=PI;
    noStroke();
    pushMatrix();
    translate(x, y);
   //
  //  if (keyPressed)rotateZ(distFromCenter/300.0);
      if (!keyPressed)rotateZ(-angi);
  if (!mousePressed) rotateX((gray+pixelRotateShift)*pixelRotateFactor);
 else rotateX((sin(distFromCenter/1000.0)+mouseY/100.0+ noise(mouseY)/10.0)+pixelRotateShift*pixelRotateFactor);
    // rotateX(mouseY/100.0);
    //if (keyPressed)rotateZ(-distFromCenter/300.0);
    if (!keyPressed)rotateZ(angi);
 
    translate(-x, -y);


    pushMatrix();
    translate (x, y);

    //  box( pixelWidth, pixelWidth, pixelDepth);
    popMatrix();

    beginShape();
    for (PVector point : contour.getPolygonApproximation().getPoints()) {
      vertex(point.x, point.y);
    }
    endShape();
    
     PVector lastpoint = contour.getPolygonApproximation().getPoints().get(contour.getPolygonApproximation().getPoints().size()-1);
   
    for (PVector point : contour.getPolygonApproximation().getPoints()) {
      beginShape();
      vertex(point.x, point.y, 0);
      vertex(lastpoint.x, lastpoint.y, 0);
      vertex(lastpoint.x, lastpoint.y, -10);
      vertex(point.x, point.y, -10);


      lastpoint.x =point.x;
      lastpoint.y =point.y;
       endShape();
    }




    popMatrix();
  }
  void  checkRipples() {
    int subtract= 135/numOfRings;
    for (int i = 0; i<ripples.size(); i++) { 
      // An ArrayList doesn't know what it is storing so we have to cast the object coming out
      Ripple ripple = ripples.get(i);
      float thisDist =  dist(ripple.centerX, ripple.centerY, x, y);

      for (int countRings=0; countRings < numOfRings; countRings++) {
        if (abs(thisDist-((int)ripple.radius-ringDistance*countRings)) < ripple.speed) {

          if (countRings % 2==0) {
            if (didWave==false )targetGray =max(127- countRings*subtract, 0);
            else targetGray = (targetGray+max(127- countRings*subtract, 0))/2;
          } else {
            if (didWave==false )targetGray = -max(127- countRings*subtract, 0);
            else targetGray =(targetGray-max(127- countRings*subtract, 0))/2;
          }
          didWave=true;
          break;
        }
      }
      /*
      if (abs(thisDist-(int)ripple.radius) < ripple.speed) {
       targetGray =255;
       } else if (abs(thisDist-((int)ripple.radius-ringDistance)) < ripple.speed) {
       targetGray =0;
       } else if (abs(thisDist-((int)ripple.radius-ringDistance*3)) < ripple.speed) {
       targetGray =127;
       }
       */
    }

    targetGray= constrain(targetGray, -127, 127);

    if (gray-targetGray> speed) {
      gray-=speed;
    } else if (targetGray-gray> speed) {
      gray+=speed;
    }

    // gray=targetGray;
  }
}



class Ripple {
  int centerX, centerY, maxRadius;
  float speed, radius;
  Ripple(int x, int y, float s) {
    centerX= x;
    centerY= y;
    radius = 0;
    speed = s;
    int deltaX= max(centerX, maxWidth-centerX);
    int deltaY= max(centerY, maxHeight-centerY);
    maxRadius= (int)sqrt(deltaX*deltaX+deltaY*deltaY);
  }
  boolean finished() {
    // Balls fade out
    if (radius > maxRadius+ringDistance*numOfRings) {
      return true;
    } else {
      return false;
    }
  }
  void grow() {
    radius += speed;
  }
  void display() {
    // Display the circle

    //noFill();
    //ellipse(centerX, centerY, radius*2, radius*2);
  }
}