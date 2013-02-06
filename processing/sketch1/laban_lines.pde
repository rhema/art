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
    
    
    stroke(25, 200, 25, ((int)(((float)lifespan/100.0))*255.0));
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
      stroke(25, 200, 25, (((float)lifespan/100.0))*255.0);
      fill(25, 200, 25, (((float)lifespan/100.0))*255.0);
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






