Screw[] myScrews= new Screw[0];
int numScrews=22;
float factor=4;
float[] travelA= new float [0];
float[] travelB= new float [0];
float[] dirA= new float [0];
float[] dirB= new float [0];

void setup() {
  size (1024, 768, P3D);  
  factor= float(height)/260.0;
  smooth();
  rectMode(CENTER);
  

  for (int i=0;i< numScrews;i++) {  
    myScrews= (Screw[])append(myScrews, new Screw (100+i*factor *12,  6,  factor*9, factor*240, 180, 90, 1));
    

     
    travelA= append(travelA,i*1.12) ;
    travelB= append(travelA,i*1.12) ;
    dirA= append( dirA,0.1+float(10)/3);
    dirB= append( dirB,0.1+float(10)/2);
  /*
     travelA= append(travelA,i*2.57) ;
    travelB= append(travelA,i*1.12) ;
    dirA= append( dirA,0.1+float(10)/6);
    dirB= append( dirB,0.1+float(10)/2);
     */
  }
  
}

void draw() {
  lights();
 // pointLight(255,255,255,1,1,1);
  directionalLight(150,150,150,1,1,-1);
  background (10);
  translate(width/2, height/2);
rotateX(mouseY/100.0);
 rotateZ(mouseX/100.0);
  translate(-width/2, -height/2);
    for (int i=0;i< numScrews;i++) {
  travelA[i]+=dirA[i];
  if (travelA[i]> 90 || travelA[i] < -180)dirA[i]= -dirA[i];
  
  travelB[i]+=dirB[i];
  if (travelB[i]> 90 || travelB[i] < -180 )dirB[i]= -dirB[i];
  

    myScrews[i].drawScrew(travelA[i], travelB[i]);
  }
}


class Screw {
  float screwX, screwY, screwWidth, screwLength, angleA, angleB, speed, numSteps=200;
  Screw(float _screwX, float _screwY, float _screwWidth, float _screwLength, float _angleA, float _angleB, float _speed) {
    screwX=_screwX; 
    screwY=_screwY; 
    screwWidth=_screwWidth; 
    screwLength=_screwLength;
    angleA=_angleA;
    angleB=_angleB;
    speed=_speed;
  }

  void  drawScrew(float newAngleA, float newAngleB) {
    pushMatrix();
    if (newAngleA-angleA>speed)angleA+= speed;
    if (angleA-newAngleA>speed)angleA-= speed;

    if (newAngleB-angleB>speed)angleB+= speed;
    if (angleB-newAngleB>speed)angleB-= speed;

    fill(230,230,255);
    noStroke(); 
    translate(screwX, screwY);
    float step=screwLength/numSteps;
    float angleStep = (angleB-angleA)/numSteps;
    rotateY(radians(angleA));
    for (float i=0 ;i<numSteps;i++) {
      rotateY(radians(angleStep));
      translate(0, step);
      beginShape();
      vertex(-screwWidth/2, 0,0);
      vertex(screwWidth/2,0 ,0);
         vertex( screwWidth/2,step*2,0);
        vertex( -screwWidth/2,step*2,0);
      endShape(CLOSE);
    }
    popMatrix();
  }
}
