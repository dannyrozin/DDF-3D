Screw[] myScrews= new Screw[0];
int numScrews=22;
float factor=4;
float[] travelA= new float [0];
float[] travelB= new float [0];
float[] dirA= new float [0];
float[] dirB= new float [0];
PImage myImage, myImage2;
int shiftX= 205;
int shiftY=175;
float range = 240;                   // degrees 
float speedFactor =300;
float TopBottomDifference= 1.1;
float betweenStripsDifference= 1.12*5;
int signA= 1, signB=1;
void setup() {
  size (1280, 800, P3D);  
  factor= float(height)/360.0;
  smooth();
  rectMode(CENTER);
  frameRate(20);

  myImage = loadImage("IMG_7743.JPG");
  myImage2 = loadImage("IMG_7743blur.JPG");
  for (int i=0; i< numScrews; i++) {  
    travelA= append(travelA, i*betweenStripsDifference) ;
    travelB= append(travelA, i*betweenStripsDifference) ;
    dirA= append( dirA, 0.1+(speedFactor)/12);
    dirB= append( dirB, 0.1+(speedFactor)/(12+TopBottomDifference)); // aws 2
    // myScrews= (Screw[])append(myScrews, new Screw (shiftX+100+i*factor *12, shiftY+6, factor*9, factor*200, 180, 90, 0.1+float(10)/2));
    float centerX= shiftX+100+(numScrews/2)*factor *12;
    int centerDist= 1200;
    float centerY=shiftY-centerDist;
    float thisY= centerY;
    for (thisY= centerY; thisY< centerDist; thisY++) {
      float thisDist = dist (shiftX+100+i*factor *12, shiftY+thisY, centerX, centerY);
      if (thisDist > centerDist) {
        break;
      }
    }
    //myScrews= (Screw[])append(myScrews, new Screw (shiftX+100+i*factor *12, thisY, factor*9, factor*200, 180, 90, 0.1+float(10)/2));
    myScrews= (Screw[])append(myScrews, new Screw (shiftX+100+i*factor *12, shiftY+12, thisY+20, 
      factor*9, factor*190, 
      180, 90, 0.1+float(10)/2));
  }
}

void draw() {

  pushMatrix();
  lights();
  // pointLight(255,255,255,1,1,1);
  directionalLight(150, 150, 150, 1, 1, -1);
  background (0, 0, 255);

  image(myImage, 0, 0, width, height);
  translate(0, 0, 20);
  translate(width/2, height/2);
  // rotateX(mouseY/100.0);
  // rotateZ(mouseX/100.0);
  translate(-width/2, -height/2);

  println("travelA[0]  " + travelA[0] + "   travelB[0]  " + travelB[0] );
  float ratioA =travelA[0]/ range;
  float ratioB =travelB[0]/ range;
  if (ratioA > 0.5) ratioA= 1-ratioA;
  if (ratioB > 0.5) ratioB= 1-ratioB;

  if (travelA[0]> range &&  signA>0)signA= -1;

  if (travelA[0]< -(0) ) {
    signA= 1;
    travelA[0]=0;
    println("did");
  }

if (travelB[0]> range &&  signB>0)signB= -1;

  if (travelB[0]< -(0) ) {
    signB= 1;
    travelB[0]=0;
    println("did");
  }


  for (int i=0; i< myScrews.length; i++) {



    dirA[i]=  (0.1+(speedFactor)/12) * ratioA;
    dirB[i]=  (0.1+(speedFactor)/(12+TopBottomDifference)) * ratioB;

    dirA[i]*= signA;
    dirB[i]*= signB;
    dirA[i]+= 0.1 * signA;
    dirB[i]+=0.1* signB;

    //if (travelA[0]> range || travelA[0] < -range)dirA[i]= -dirA[i];




   // if (travelB[0]> range &&  dirB[i]>0)dirB[i]= -dirB[i];
    //if (travelB[0]< -range &&  signB<0)dirB[i]= 1;

    //if (travelB[0]> range || travelB[0] < -range )dirB[i]= -dirB[i];
  }
  for (int i=0; i< myScrews.length; i++) {
    travelA[i]+=dirA[i];

    travelB[i]+=dirB[i];


    myScrews[i].drawScrew(travelA[i], travelB[i]);
  }

  println(mouseX, mouseY);
  pushMatrix();
  fill(100);
  translate(654+shiftX -275, 176, -15);
  box(600, 20, 1);                  //top
  popMatrix();


  pushMatrix();
  translate(654+shiftX -275, 625, -15);
  box(600, 20, 1);             // bottom
  popMatrix();


  // top arc
  beginShape(QUAD_STRIP);
  vertex(myScrews[0].screwX-factor *12, myScrews[0].screwY-20, myScrews[0].screwZ+10);
  vertex(myScrews[0].screwX-factor *12, myScrews[0].screwY, myScrews[0].screwZ+10);
  for (int i=0; i< myScrews.length; i++) {
    vertex(myScrews[i].screwX, myScrews[i].screwY-20, myScrews[i].screwZ+20);
    vertex(myScrews[i].screwX, myScrews[i].screwY, myScrews[i].screwZ+20);
  }
  vertex(myScrews[myScrews.length-1].screwX+factor *12, myScrews[myScrews.length-1].screwY-20, myScrews[myScrews.length-1].screwZ+10);
  vertex(myScrews[myScrews.length-1].screwX+factor *12, myScrews[myScrews.length-1].screwY, myScrews[myScrews.length-1].screwZ+10);
  endShape(CLOSE);

  // bottom arc
  float startY=+factor*202;
  beginShape(QUAD_STRIP);
  vertex(myScrews[0].screwX-factor *12, myScrews[0].screwY-20+startY, myScrews[0].screwZ+10);
  vertex(myScrews[0].screwX-factor *12, myScrews[0].screwY+startY, myScrews[0].screwZ+10);
  for (int i=0; i< myScrews.length; i++) {
    vertex(myScrews[i].screwX, myScrews[i].screwY-20+startY, myScrews[i].screwZ+20);
    vertex(myScrews[i].screwX, myScrews[i].screwY+startY, myScrews[i].screwZ+20);
  }
  vertex(myScrews[myScrews.length-1].screwX+factor *12, myScrews[myScrews.length-1].screwY-20+startY, myScrews[myScrews.length-1].screwZ+10);
  vertex(myScrews[myScrews.length-1].screwX+factor *12, myScrews[myScrews.length-1].screwY+startY, myScrews[myScrews.length-1].screwZ+10);
  endShape(CLOSE);



  pushMatrix();
  translate(348+shiftX -275, 401, -9);
  box(20, 468, 20);                // left
  popMatrix();




  pushMatrix();
  translate(962+shiftX -275, 401, -7);

  box(20, 468, 20);
  popMatrix();


  popMatrix();
  translate(0, 0, 60);
  fill(0);
  rect(580, 493, 1250, 12);
  println(mouseY);
}


class Screw {
  float screwX, screwY, screwZ, screwWidth, screwLength, angleA, angleB, speed, numSteps=200;
  Screw(float _screwX, float _screwY, float _screwZ, float _screwWidth, float _screwLength, float _angleA, float _angleB, float _speed) {
    screwX=_screwX; 
    screwY=_screwY; 
    screwZ=_screwZ; 
    screwWidth=_screwWidth; 
    screwLength=_screwLength;
    angleA=_angleA;
    angleB=_angleB;
    speed=_speed;
  }

  void  drawScrew(float newAngleA, float newAngleB) {
    pushMatrix();
    //  if (newAngleA-angleA>speed)angleA+= speed;
    // if (angleA-newAngleA>speed)angleA-= speed;

    // if (newAngleB-angleB>speed)angleB+= speed;
    //  if (angleB-newAngleB>speed)angleB-= speed;
    angleA=newAngleA;
    angleB=newAngleB;
    fill(150);
    noStroke(); 
    translate(screwX, screwY, screwZ );
    float step=screwLength/numSteps;
    float angleStep = (angleB-angleA)/numSteps;
    rotateY(radians(angleA));
    for (float i=0; i<numSteps; i++) {
      rotateY(radians(angleStep));
      translate(0, step);
      fill(255, 255, 255);
      beginShape();
      // texture(myImage2);
      float texScale = 2.5;
      vertex(-screwWidth/2, 0, 0, screwX*texScale, (i*step)*texScale);
      vertex(screwWidth/2, 0, 0, (screwX+20)*texScale, (i*step)*texScale);
      vertex( screwWidth/2, step, 0, (screwX+20)*texScale, +((i+1)*step)*texScale);

      endShape(CLOSE);

      beginShape();
      //texture(myImage2);
      vertex(-screwWidth/2, 0, 0, screwX*texScale, (i*step)*texScale);
      vertex( screwWidth/2, step, 0, (screwX+20)*texScale, +((i+1)*step)*texScale);
      vertex( -screwWidth/2, step, 0, screwX*texScale, +((i+1)*step)*texScale);
      endShape(CLOSE);

      /*
      fill(150, 150, 200);
       beginShape();
       vertex(-screwWidth/2, 0, 1);
       vertex(screwWidth/2, 0, 1);
       vertex( screwWidth/2, step*2, 1);
       vertex( -screwWidth/2, step*2, 1);
       endShape(CLOSE);
       */
    }

    popMatrix();
  }
}
