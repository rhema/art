import processing.opengl.*;
import java.util.*;
PShape s;

Vector<GrowLine> glines;

float wwidth = displayWidth;
float wheight = displayHeight;

void setup() {
   wwidth = displayWidth*.7;
   wheight = displayHeight*.7;
  size(((int)wwidth), ((int)wheight));
  smooth();
  s = loadShape("images/leaf1.svg");
  glines = new Vector<GrowLine>();
  add_lines();
}

int frames=0;
void draw() {
  if(frames > 10)
    return;
  background(100,100,100);
  for(GrowLine g:glines)
     g.run();
  frames += 1;
}
void add_lines()
{
   //flair from center and extend out
   PVector center = new PVector(wwidth*.5,wheight*.5);
   float rad = .5*wheight;
   int numberToDraw = 10;
   float deltaAngle = (2.0*PI)/((float)numberToDraw);
   float angle=0;
   for(int i=0; i<numberToDraw; i+= 1)
   {
     PVector end = new PVector(center.x+rad*cos(angle),center.y+rad*sin(angle));
     glines.add(new GrowLine(center,end));
     angle += deltaAngle;
   }
}



class GrowLine {
  PVector start;
  PVector end;

  GrowLine(PVector start, PVector end) {
    this.start = start;
    this.end = end;
  }

  void run() {
    update();
    display();
  }

  void update() {
  }
  
  void curveTest()
  {
    //something random based on size
    float d = PVector.dist(start,end);
    PVector c1 = PVector.lerp(start,end,.5);
    c1.add(PVector.mult(PVector.random2D(),.5*d));
    PVector c2 = PVector.lerp(start,end,.5);
    c2.add(PVector.mult(PVector.random2D(),.5*d));
    noFill();
    curve(c1.x,c1.y,start.x,start.y, end.x,end.y, c2.x,c2.y);
  }
  
  void curve2()
  {
    stroke(255, 255, 255, 255);
    ellipse(start.x,start.y,15,15);
    ellipse(end.x,end.y,15,15);
    float d = PVector.dist(start,end);
    int np = 5;
    float tdelta = 1.0/((float)np);
    Vector<PVector> controlPoints = new Vector<PVector>();
    controlPoints.add(PVector.mult(start,1));
    controlPoints.add(PVector.mult(start,1));
    for(float t=0;t<=1;t+=tdelta)
    {
      PVector c1 = PVector.lerp(start,end,t);
      c1.add(PVector.mult(PVector.random2D(),.07*d));
      controlPoints.add(c1);
    }
    controlPoints.add(PVector.mult(end,1));
    controlPoints.add(PVector.mult(end,1));
    
    noFill();
    stroke(0);
    beginShape();
    for(PVector p:controlPoints)
    {
      curveVertex(p.x, p.y); // the first control point
      ellipse(p.x,p.y,3,3);
    }
    endShape();
    
    //tangents...  mirror of earlier loop...
    stroke(255, 25, 25, 255);
    for(int i=2;i<controlPoints.size()-2; i++)
    {
      float t = tdelta*((float)i);
      float tx = curveTangent(controlPoints.get(i-1).x, controlPoints.get(i).x, controlPoints.get(i+1).x, controlPoints.get(i+2).x, t);//like 4 of these...???
      float ty = curveTangent(controlPoints.get(i-1).y, controlPoints.get(i).y, controlPoints.get(i+1).y, controlPoints.get(i+2).y, t);//like 4 of these...???
      int of = 1;
      line(controlPoints.get(i+of).x,controlPoints.get(i+of).y,controlPoints.get(i+of).x+tx,controlPoints.get(i+of).y+ty);
      int lsize=25;
      translate(controlPoints.get(i+of).x,controlPoints.get(i+of).y);
      float rott = (new PVector(tx,ty)).heading()+(11*(PI/4.0));
      rotate(rott);
      shape(s,-lsize,-lsize, lsize, lsize);
      rotate(-rott);
      translate(-controlPoints.get(i+of).x,-controlPoints.get(i+of).y);
    }
    /*
    //generate some set of control point along the line...
    int[ ] coords = {
    40, 40, 80, 60, 100, 100, 60, 120, 50, 150
  };
  int i;
    
    noFill();
    stroke(0);
    beginShape();
    curveVertex(40, 40); // the first control point
    curveVertex(40, 40); // is also the start point of curve
    curveVertex(80, 60);
    curveVertex(100, 100);
    curveVertex(60, 120);
    curveVertex(50, 150); // the last point of curve
    curveVertex(50, 150); // is also the last control point
    endShape();
    
    // use the array to keep the code shorter;
    // you already know how to draw ellipses!
    fill(255, 0, 0);
    noStroke();
    for (i = 0; i < coords.length; i += 2)
    {
      ellipse(coords[i], coords[i + 1], 3, 3);
    }
    */
  }
  
  void guideLine()
  {
    stroke(255, 255, 255, 255);
    ellipse(start.x, start.y, 8, 8);
    ellipse(end.x, end.y, 8, 8);
    line(start.x,start.y,end.x,end.y);
  }
  
  
  void display() {
    curve2();
  }
}
