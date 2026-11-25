import processing.opengl.*;

Spoke[] mySpokes= new Spoke[0];
int numOfSpokes= 17;
float[] angs= new float [numOfSpokes];
float zoom=0;
float[] dirs = new float[numOfSpokes];
color fanColors[] = new color[numOfSpokes];
void setup() {
  size(1400, 900, OPENGL);  
  for (int i=0;i<numOfSpokes;i++) {
    angs[i]= i*5;
    dirs[i]=0.5+i/100.0;
    fanColors[i]= color(random(100,150),random(100,150),random(100,150));
    mySpokes= (Spoke[])append(mySpokes, new Spoke(700, 20, 20, 9, width/2, 700, -i*20, i*10+10,i));
  }


  //noStroke();
 // noSmooth();
}


void draw() {
  background(0);
  translate(width/2, 900);
  rotateX((mouseY-400)/100.0);
  rotateY((mouseX-400)/100.0);
  translate(-width/2, -900,zoom);
  
  for (int i=0;i<numOfSpokes;i++) {
    mySpokes[i].spokeDraw(angs[i]);
  }
  
 if (mousePressed) lights();
  
  for (int i=0;i<numOfSpokes;i++) {
    angs[i]+=dirs[i];
    if (angs[i] < 0 || angs[i] > 120)dirs[i]=-dirs[i];
  }
}

class Fan {
  float fanLength, fanBladeWidth, fanBladeCount, fanX, fanY, fanZ, fanStartAngle, fanEndAngle, fanBladeThick;
int myNum;
  Fan(float _fanLength, float _fanBladeWidth, float _fanBladeThick, float _fanBladeCount, float _fanX, float _fanY, float _fanXZ, float _fanStartAngle, float _fanEndAngle, int _myNum) {
    fanLength = _fanLength;
    fanBladeWidth= _fanBladeWidth;
    fanBladeThick= _fanBladeThick;
    fanBladeCount= _fanBladeCount;
    fanX=_fanX;
    fanY=_fanY;
    fanStartAngle=_fanStartAngle;
    fanEndAngle=_fanEndAngle;
    myNum= _myNum;
  }

  void fanDraw(float _fanEndAngle) {
    fanEndAngle=fanStartAngle+_fanEndAngle; 
    fill(fanColors[myNum]);
    stroke(red(fanColors[myNum])*0.9,green(fanColors[myNum])*0.9,blue(fanColors[myNum])*0.9) ;
   // noStroke();
    pushMatrix();
    translate(fanX, fanY, fanZ);
    rotate(radians(fanStartAngle));
    float inc= (fanEndAngle-fanStartAngle)/(fanBladeCount-1);
    float incZ= fanBladeThick/(fanBladeCount-1);
    for (int i=0;i<fanBladeCount;i++) {
      rect(-fanBladeWidth/2, -fanLength/8, fanBladeWidth, fanLength);
      rotateZ(radians(inc)); 
      translate(0, 0, incZ);
    }  
    popMatrix();
  }
}

class Spoke {
  Fan[] myFans= new Fan[0];
  int myNum;
  float spokeLength, spokeBladeWidth, spokeBladeCount, spokeX, spokeY, spokeZ, spokeStartAngle, spokeBladeThick;
  Spoke(float _spokeLength, float _spokeBladeWidth, float _spokeBladeThick, float _spokeBladeCount, float _spokeX, float _spokeY, float _spokeZ, float _spokeStartAngle, int _myNum) {
    spokeLength = _spokeLength;
    spokeBladeWidth= _spokeBladeWidth;
    spokeBladeThick= _spokeBladeThick;
    spokeBladeCount= _spokeBladeCount;
    spokeX=_spokeX;
    spokeY=_spokeY;
    spokeZ=_spokeZ;
    spokeStartAngle=_spokeStartAngle+90;
    myNum= _myNum;
    float fanStartLength=30;
    float fanPlacement= 0;
    for (int i=0;i<spokeBladeCount;i++) {

      myFans= (Fan[])append(myFans, new Fan(fanStartLength, 8, 20, 20, 0, fanPlacement, 0, 0, 1,i));

      fanPlacement +=fanStartLength+10;
      fanStartLength+=i*3;
    }
  }

  void spokeDraw(float _spokeStartAngle) {
    _spokeStartAngle=_spokeStartAngle+90; 
    fill(60, 50, 10);
  noStroke();
    pushMatrix();
    translate(spokeX, spokeY, spokeZ);
    rotate(radians(spokeStartAngle));   
    rect(-spokeBladeWidth/2, -spokeLength/8, spokeBladeWidth, spokeLength);
    translate(0, 100, 0);
    for (int i=0;i<spokeBladeCount;i++) {
      if (mousePressed){
      myFans[i].fanDraw(angs[myNum]);
      }else{
         myFans[i].fanDraw(angs[i*2]);
      }
    }  
    popMatrix();
  }
}
void keyPressed(){
  if (keyCode == UP) zoom+=10;
   if (keyCode == DOWN) zoom-=10;
}
