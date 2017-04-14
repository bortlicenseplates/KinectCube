
class Mesh {


  int selector;
  float lLim=100, uLim=800;
  int dir;
  int skip, pLim;
  int w, h;
  int activeX, activeY, activeW, activeH;
  float cWidth, cHeight, cDepth;
  PVector[] points;

  Mesh(int _w, int _h, int _skip) {


    activeW = width;
    activeH = height;
    w = _w;
    h = _h;
    skip = _skip;
    cWidth = map(skip, 0, w, 0, width)/2;
    cHeight = map(skip, 0, h, 0, height/2);
    cDepth = (cWidth+cHeight)/2;
    points = new PVector[kinectA.getRawDepth().length / skip];
    for (int i = 0; i < points.length; i++) {
      points[i] = new PVector(0, 0, 0);
    }
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
    for (int y = 1; y < depth.length/w; y+=skip) {
      for (int x = 1; x < depth.length/h; x+=skip) {
        float d[] = {
          map(depth[(x-skip)+((y-skip)*w)], 0, dMax, 0, 1000), 
          map(depth[(x-(skip/2))+((y-skip)*w)], 0, dMax, 0, 1000), 
          map(depth[(x)+((y-skip)*w)], 0, dMax, 0, 1000), 
          map(depth[(x-skip)+((y-(skip/2))*w)], 0, dMax, 0, 1000), 
          map(depth[(x-(skip/2))+((y-(skip/2))*w)], 0, dMax, 0, 1000), 
          map(depth[(x)+((y-(skip/2))*w)], 0, dMax, 0, 1000), 
          map(depth[(x-skip)+((y)*w)], 0, dMax, 0, 1000), 
          map(depth[(x-(skip/2))+((y)*w)], 0, dMax, 0, 1000), 
          map(depth[(x)+((y)*w)], 0, dMax, 0, 1000), 
        };
        float f = getAverage(d);

        pushMatrix();
        fill(0);

        if (f < uLim && f > lLim) {

          points[(x+(y*w))/skip] = new PVector(-cWidth/2 + map(x, 0, w, 0, width), -cHeight/2 + map(y*0.825, 0, h, 0, height), -1000 + f/2);
        } else {
          points[(x+(y*w))/skip] = new PVector(-cWidth/2 + map(x, 0, w, 0, width), -cHeight/2 + map(y*0.825, 0, h, 0, height), -1000);
        }

        popMatrix();
        beginShape();
        vertex(points[((x-1)+((y-1)*w))/skip].x, points[((x-1)+((y-1)*w))/skip].y, points[((x-1)+((y-1)*w))/skip].z);
        vertex(points[((x-1)+((y)*w))/skip].x, points[((x-1)+((y)*w))/skip].y, points[((x-1)+((y)*w))  /skip].z);
        vertex(points[((x)+((y-1)*w))/skip].x, points[((x)+((y-1)*w))/skip].y, points[((x)+((y-1)*w))  /skip].z);
        endShape();
        beginShape();
        vertex(points[((x-1)+((y)*w))/skip].x, points[((x-1)+((y)*w))/skip].y, points[((x-1)+((y)*w))  /skip].z);
        vertex(points[((x)+((y-1)*w))/skip].x, points[((x)+((y-1)*w))/skip].y, points[((x)+((y-1)*w))  /skip].z);
        vertex(points[((x)+((y)*w))/skip].x, points[((x)+((y)*w))/skip].y, points[((x)+((y)*w))    /skip].z);
        endShape();
        point(points[((x)+((y)*w))/skip].x, points[((x)+((y)*w))/skip].y, points[((x)+((y)*w))/skip].z);
        
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