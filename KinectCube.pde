

import ComputationalGeometry.*;
import quickhull3d.*;
import template.library.*;
PShader blur;
import queasycam.*;

//Libraries

import org.openkinect.freenect.*;
import org.openkinect.freenect2.*;
import org.openkinect.processing.*;
import org.openkinect.tests.*;

//Processing + 3rd party
PGraphics inputA;
PGraphics inputB;
PImage depthImageA;
PImage depthImageB;
Kinect2 kinectA;
Kinect2 kinectB;
color selectCol = color(100, 200, 255);

QueasyCam cam;

//My classes
Cubes cubesA;
Cubes cubesB;
Mesh mesh;

IsoWrap wrap;

//ControlWindow
//Controller controls;
final int dMax = 2048;

void settings() {
  size(1920, 1080, P3D);
  PJOGL.profile = 1;
}

void setup() {
  blur = loadShader("blurFrag.glsl"); 
  //cam = new QueasyCam(this);
  //cam.sensitivity = 0.1;
  //cam.speed = 10;
  //controls = new Controller();
  stroke(255);
  strokeWeight(2);
  depthImageA = loadImage("data/depth.png");
  depthImageB = loadImage("data/depth.png");

  kinectA = new Kinect2(this);
  kinectA.initDepth();
  kinectA.initIR();
  kinectA.initVideo();
  kinectA.initDevice(0);

  kinectB = new Kinect2(this);
  kinectB.initDepth();
  kinectB.initIR();
  kinectB.initVideo();
  kinectB.initDevice(1);

  inputA = createGraphics(kinectA.depthWidth, kinectA.depthHeight, P3D);
  inputB = createGraphics(kinectB.depthWidth, kinectB.depthHeight, P3D);

  //My stuff
  cubesA = new Cubes(kinectA.depthWidth, kinectA.depthHeight, 10 );
  mesh = new Mesh(kinectA.depthWidth, kinectA.depthHeight, 4 );
  cubesB = new Cubes(kinectB.depthWidth, kinectB.depthHeight, 1);
}

float r;
float tempr;
void mRot() {

  if (mousePressed) {
    r = map(tempr, 0, width, 0, TWO_PI);
  } else {
    tempr = mouseX;
  }
}
void test() {
  lights();
  pushMatrix();
  image(kinectA.getDepthImage(), 0, 0, kinectA.depthWidth, kinectA.depthHeight);

  rotateY(PI);
  translate(-kinectA.depthWidth, 0);
  image(kinectB.getDepthImage(), 0, 0);
  popMatrix();
}
void draw() {
  if (keyPressed) {
    filter(blur);
  }
  //perspective(HALF_PI, width/height, mouseY, 100000);
  pushMatrix();
  rotate(frameCount*0.01);
  pointLight(255, 0, 255, 0, height/2, 0);
  pointLight(0, 255, 255, width, height/2, 0);
  popMatrix();
  pushMatrix();
  noStroke();
  background(0);
  drawA();
  popMatrix();
  
}

void drawA() {
  cubesA.scan(kinectA.getRawDepth(), 1);
}

void drawB() {
  cubesB.scan(kinectB.getRawDepth(), -1);
}