import processing.opengl.*;

LabanSystem ls;

import java.util.Iterator;
PShape s;







void setup() {
  size(640, 480);
  smooth();
  s = loadShape("images/placeholder.svg");
  //ps = new ParticleSystem(new PVector(width/10,50));
  ls = new LabanSystem(new PVector(width/10, 30));
  //ls.addLine();
  
  
  ls.addLine(new PVector(0, .5*300), .5);
  
  /*
  for (float d=0; d<01.1; d+=.1)
  {
    ls.addLine(new PVector(0, d*300), d);
  }
  */
}

void draw() {
  background(255,255,255);
  //print("test");
  //ps.addParticle();
  //ps.run();
  ls.run();
  //shape(s, 50, 50, 80, 80);
}


// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 

class LabanLine {
  PVector location;
  //PVector velocity;
  //PVector acceleration;
  //float lifespan;
  float indirectness;
  float range;
  float frames = 0;

  LabanLine(PVector l, float indirectness) {
    //acceleration = new PVector(0,0.05);
    //velocity = new PVector(random(-3,1),random(-2,0));
    location = l.get();
    //lifespan = 120.0;
    this.indirectness = indirectness;
    range = 300;
  }

  void run() {
    update();
    display();
  }

  // Method to update location
  void update() {
    //velocity.add(acceleration);
    //location.add(velocity);
    //lifespan -= 1.0;
    frames += 1;
    indirectness = sin(frames*.01)*.5 +.5;//go from 0 to 1 and back
    if(indirectness > 1)
       indirectness = 0;
  }
  
  PVector between(PVector a, PVector b, float t)
  {
    PVector delta = PVector.sub(b,a);
    return PVector.add(a,PVector.mult(delta,t)); 
  }

//the intuition here is to draw tighter and tigher curves moving in by 1/6 each time.
//
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
            //arc f,f,f,f,f,f,i
    
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
    
    text("lev:"+indirectness,10,10);
    
    stroke(0, 255, 0, 255);
    //fill(255, 255);
    ellipse(location.x, location.y, 8, 8);
    stroke(255, 255, 255, 255);
    int ax = 50;
    int ay = 50;

    noFill();

    line(location.x, location.y, location.x+range, location.y);

    float dist = range;
    float delta = 50;
    float max_height = 100;
    PVector now = new PVector();
    PVector last = new PVector();
    last.set(location);
    now.set(location);
    now.x += range;

    filligree(last,now,10*indirectness);
    
    /*
    float direction = 1;
    while (dist > 0)
    {
      //stroke(0, 0, 255, 255);
      direction = direction*-1;
      //move the now
      now.x += delta;
//      now.y += delta;
      dist -= delta;
      //line(last.x, last.y, now.x, now.y);
      
      PVector a1 = PVector.mult( PVector.add(now, last), .5);
      PVector a2 = PVector.mult( PVector.add(now, last), .5);
      a1.y += max_height*indirectness*direction;
      a2.y += max_height*indirectness*direction;
      
      stroke(0, 255, 255, 255);
      ellipse(a1.x, a1.y, 5, 5);

      stroke(255, 200, 24, 255);
      ellipse(a2.x, a2.y, 5, 5);

      stroke(255, 50, 50, 255);
      bezier( last.x, last.y,
              a1.x, a1.y, 
              a2.x, a2.y,
              now.x, now.y);
      stroke(255, 50, 50, 255);
      ellipse(now.x, now.y, 9, 9);
      ellipse(last.x, last.y, 9, 9);
      last.set(now);
      //break;
    }
    */
  }
  

  // Is the particle still useful?
  boolean isDead() {
    //    if (lifespan < 0.0) {
    //      return true;
    //    } else {
    //      return false;
    //    }
    return false;
  }
}




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

