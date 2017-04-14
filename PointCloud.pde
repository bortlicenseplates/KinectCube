
class Cubes {

  int selector;
  float lLim=0, uLim=900;
  int dir;
  int skip, pLim;
  int w, h;
  int activeX, activeY, activeW, activeH;
  float cWidth, cHeight, cDepth;
  ArrayList<PVector> points;
  float prev[][];
  Cubes(int _w, int _h, int _skip) {
    activeW = width;
    activeH = height;
    w = _w;
    h = _h;
    skip = _skip;
    points = new ArrayList<PVector>();
    cWidth = map(skip, 0, w, 0, width)/2;
    cHeight = map(skip, 0, h, 0, height/2);
    cDepth = (cWidth+cHeight)/2;

    prev = new float[kinectA.getRawDepth().length][5];
  }
  boolean t = true;
  void select() {

    if (mousePressed && t) {
      selector++;
      t=false;
    }
    if (!mousePressed) {
      t = true;
    }
    if (selector%3 == 1) {
      activeX = mouseX*dir;
      activeY = mouseY*dir;
      selector ++;
    } else if (selector%3 == 2) {
      activeW = mouseX*dir-activeX;
      activeH = mouseY*dir-activeY;
    } else {
      selector = 0;
    }

    pushStyle();

    noFill();

    rect(activeX, activeY, activeW, activeH);
    popStyle();
  }
  void scan(int[] depth, int _dir) {
    dir = _dir;
    println(selector);
    select();
    pushMatrix();
    //if (dir == -1) {
    //  translate(-w, 0, -462);
    //}
    noStroke();
    for (int y = 0; y < depth.length/w; y+=skip) {
      for (int x = 0; x < depth.length/h; x+=skip) {
        int current = x+(y*w);
        
        prev[current][0] = map(depth[current], 0, dMax, 0, 1000);
        for(int i = 1; i < prev[0].length; i++){
          prev[current][i] = prev[current][i-1];
        }
        float f = lerp( prev[current][0], 
          prev[current][4],0.0001);
        pushMatrix();
        fill(0,0);
        if (f < uLim && f > lLim) {

          fill(map(depth[current], 0, dMax, 255, 0));
          translate(-cWidth/2 + map(x, 0, w, 0, width), -cHeight/2 + map(y*0.825, 0, h, 0, height), -500 + f);
        } else {
          translate(-cWidth/2 + map(x, 0, w, 0, width), -cHeight/2 + map(y*0.825, 0, h, 0, height), -500);
        }
        box(cWidth, cHeight, 100+f/4);
        popMatrix();
        
      }
    }
    popMatrix();
  }
  

  
  
  float getAverage(float[] n) {
    float avg = 0;
    for (int i = 0; i < n.length; i++) {
      avg+=n[i];
    }
    return avg/n.length;
  }
}