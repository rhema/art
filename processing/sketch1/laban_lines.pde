import processing.opengl.*;
import java.util.Random;



import java.util.Iterator;
PShape s;

class LabanSystem {
  ArrayList<LabanLine> lines;
  PVector origin;

  LabanSystem(PVector location) {
    origin = location.get();
    lines = new ArrayList<LabanLine>();
  }

  void addLine(PVector offset, float indirectness) {
    lines.add(new LabanLine(PVector.add(origin, offset), indirectness));
  }
  
  void addLine(PVector offset, float indirectness, PVector v, PVector a) {
    lines.add(new LabanLine(PVector.add(origin, offset), indirectness,v,a));
  }

  void addLine() {
    float n = 0;
    lines.add(new LabanLine(origin, n));
  }

  void run() {
    Iterator<LabanLine> it = lines.iterator();
    while (it.hasNext ()) {
      LabanLine p = it.next();
      p.run();
      if (p.isDead()) {
        it.remove();
      }
    }
  }
}



// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 

class LabanLine {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  float indirectness;
  float range;
  float frames = 0;
  float angleOffset = 0;
  int[] leafOrder = new int[3];
  color c;

  LabanLine(PVector l, float indirectness) {
    indirectness = max(0,indirectness);
    indirectness = min(1,indirectness);
    acceleration = new PVector(0,0.05);
    velocity = new PVector(random(-3,1),random(-2,0));
    lifespan = 100.0;
    this.indirectness = indirectness;
    range = 300;
    l.x -= range*.5;
    location = l.get();
    for(int i=0; i<3; i++)
      leafOrder[i] = rnums.nextInt()%leafs.size();
  }
  LabanLine(PVector l, float indirectness, PVector v, PVector a) {
    this(l,indirectness);
    c = getColor(indirectness);
    acceleration = a;
    velocity = v;
    angleOffset = rnums.nextFloat();
  }

  void run() {
    update();
    display();
  }

  // Method to update location
  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    lifespan -= 1.0;
    indirectness += .001;
//    frames += 1;
//    indirectness = max(sin(frames*.01)*.5 +.5,.05);//go from 0 to 1 and back
//    if(indirectness > 1)
//       indirectness = 0;
  }
  
    // Is the particle still useful?
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
  
  PVector between(PVector a, PVector b, float t)
  {
    PVector delta = PVector.sub(b,a);
    return PVector.add(a,PVector.mult(delta,t)); 
  }

  void spiral(PVector startOriginal, PVector endOriginal, float points, float turns)
  {
    strokeWeight(3);
    PVector start = (new PVector());
    PVector end = (new PVector());
    
    float r = dist(startOriginal.x,startOriginal.y,endOriginal.x,endOriginal.y)/2;
    PVector center = between(startOriginal,endOriginal,.5);
    float totalAngluarDist = 2*PI*turns;
    float angleShrink = totalAngluarDist/points;
    float radialShrink = r/points;
    float angle = PI;
    
    
    pushMatrix();
    translate(location.x,location.y);
    rotate(angleOffset*20);
    print("ANGLE OFFSET!!!----->"+angleOffset);
    translate(-location.x,-location.y);
    
    
    //stroke(25, 200, 25, ((int)(((float)lifespan/100.0))*255.0));
    stroke(c);
    fill(c);
    int i = 0;
    while(r > 0)
    {
      i+=1;
      start.x = center.x+r*sin(angle+angleOffset);
      start.y = center.y+r*cos(angle+angleOffset); 
      r -= radialShrink;
      angle += angleShrink;
      end.x = center.x+r*sin(angle+angleOffset);
      end.y = center.y+r*cos(angle+angleOffset);    
      line(start.x,start.y, end.x,end.y);
      pushMatrix();
      translate(start.x, start.y);
      rotate(angle);
      int lsize = 15; 
      PShape s = leafs.get(i%3);
      s.disableStyle();
      stroke(c);
      fill(c);
      //stroke(25, 200, 25, (((float)lifespan/100.0))*255.0);
      //fill(25, 200, 25, (((float)lifespan/100.0))*255.0);
      
      shape(s,-lsize,-lsize, lsize, lsize);
      popMatrix();
    }
    popMatrix();
  }

  void filligree(PVector startOriginal, PVector endOriginal, float turns)
  {
    float takeIn = 1.0/4.0;
    //don't modify contents of vectors
    PVector start = (new PVector());
    start.set(startOriginal);
    PVector end = (new PVector());
    end.set(endOriginal);
    
    stroke(255, 50, 50, 255);
    ellipse(start.x, start.y, 9, 9);
    ellipse(end.x, end.y, 9, 9);
    
    float tempRange = range;
    float turnsOffset = int(turns/.5)%2;
    while(turns > 0)
    {
      PVector c1 = between(start, end, 0);
      PVector c2 = between(start, end, 1);
      float direction = 1;
      if(int( turns/.5 + turnsOffset)%2 == 1)
         direction = -1;
      c1.y+=tempRange*min(turns,1)*direction;
      c2.y+=tempRange*min(turns,1)*direction;
      stroke(0, 255, 255, 255);
      ellipse(c1.x, c1.y, 5, 5);
      ellipse(c2.x, c2.y, 5, 5);
      
      bezier( start.x, start.y,
            c1.x, c1.y, 
            c2.x, c2.y,
            end.x, end.y);
      if(turns <= .5)
      {
        break;
      }
      turns -= .5;
      PVector tempStart = new PVector();
      tempStart.set(start);
      start.set(end);
      end = between(tempStart,end,takeIn);//starts at the last end
      tempRange -= tempRange*takeIn;
    }
  }
  // Method to display
  void display() {
   // text("lev:"+indirectness,10,10);
    //stroke(0, 255, 0, 255);
    //ellipse(location.x, location.y, 8, 8);
    //stroke(255, 255, 255, 255);
    noFill();
    //line(location.x, location.y, location.x+range, location.y);
    PVector now = new PVector();
    PVector last = new PVector();
    last.set(location);
    now.set(location);
    now.x += range;
    spiral(last,now,45*indirectness,6*indirectness*indirectness);
  }
}


class GrowLine {
  PVector start;
  PVector end;
  color c;
  
  Vector<PVector> savedRandomPoints = new Vector<PVector>();
  GrowLine(PVector start, PVector end) {
    this.start = start;
    this.end = end;
    c = color(255,255,255,255);
    c = getColor(.6);
    float scale = 1000;
    for(int i=0;i<200;i++)
      //savedRandomPoints.add(PVector.random2D());
      {
      savedRandomPoints.add(new PVector(noise(i*1000+1)*2.0-1.0,(noise(i*1000+1.0)*2.0-1.0)));
      println(savedRandomPoints.get(i));
      }
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
  
  void curve2(int offset)
  {
    
    //color alphaMask = color(255,255,255,100);
    //(c*alphaMask);
    color c = this.c;
    colorMode(RGB);
    color alphaMask = color(255,255,255,80);
    c = c&alphaMask;
    //(c*alphaMask);
    //stroke(color(255,255,255,255));
    float d = PVector.dist(start,end);
    int np = 3+(int)((1+savedRandomPoints.get(2).x)*10.0);
    //println("NP IS "+np);
    float tdelta = 1.0/((float)np);
    Vector<PVector> controlPoints = new Vector<PVector>();
    controlPoints.add(PVector.mult(start,1));
    controlPoints.add(PVector.mult(start,1));
    int i1 = 0;
    for(float t=0;t<=1;t+=tdelta)
    {
      PVector c1 = PVector.lerp(start,end,t);
      c1.add(PVector.mult(savedRandomPoints.get(i1+offset),.07*d));
      controlPoints.add(c1);
      i1+=1;
    }
    controlPoints.add(PVector.mult(end,1));
    controlPoints.add(PVector.mult(end,1));
    
    noFill();
    //stroke(0);
    beginShape();
    for(PVector p:controlPoints)
    {
      curveVertex(p.x, p.y); // the first control point
      ellipse(p.x,p.y,3,3);
    }
    endShape();
    
    //tangents...  mirror of earlier loop...
    //draw one spiral
    
    for(int i=2;i<controlPoints.size()-2; i++)
    {
      float t = tdelta*((float)i);
      float tx = curveTangent(controlPoints.get(i-1).x, controlPoints.get(i).x, controlPoints.get(i+1).x, controlPoints.get(i+2).x, t);//like 4 of these...???
      float ty = curveTangent(controlPoints.get(i-1).y, controlPoints.get(i).y, controlPoints.get(i+1).y, controlPoints.get(i+2).y, t);//like 4 of these...???
      int of = 1;
      //line(controlPoints.get(i+of).x,controlPoints.get(i+of).y,controlPoints.get(i+of).x+tx,controlPoints.get(i+of).y+ty);
      int lsize=(int)((savedRandomPoints.get(i).y+1)*16.0);
      translate(controlPoints.get(i+of).x,controlPoints.get(i+of).y);
      float rott = (new PVector(tx,ty)).heading()+(11*(PI/4.0));
      rotate(rott);
//      PShape leaf = leafs.get(0);
//      leaf.disableStyle();
//      leaf.fill(c);
//      stroke(c);
//      shape(leaf,-lsize,-lsize, lsize, lsize);
//      
      PShape leaf = leafs.get(0);
      leaf.disableStyle();
      stroke(c);
      fill(c);
      shape(leaf,-lsize,-lsize, lsize, lsize);
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
    for(int i=0; i<3; i+=1)
    {
      curve2(i*30);
    }
  }
  
}




