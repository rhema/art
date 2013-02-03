import processing.opengl.*;


LabanSystem ls;

import java.util.Iterator;

void setup() {
  size(640, 360);
  smooth();
  //ps = new ParticleSystem(new PVector(width/10,50));
  ls = new LabanSystem(new PVector(width/10, 30));
  //ls.addLine();
  for (float d=0; d<01.1; d+=.1)
  {
    ls.addLine(new PVector(0, d*300), d);
  }
}

void draw() {
  background(0);
  //print("test");
  //ps.addParticle();
  //ps.run();
  ls.run();
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
  }

  // Method to display
  void display() {
    stroke(0, 255, 0, 255);
    //fill(255, 255);
    ellipse(location.x, location.y, 8, 8);
    stroke(255, 255, 255, 255);
    int ax = 50;
    int ay = 50;

    noFill();

    line(location.x, location.y, location.x+range, location.y);

    float dist = range;
    float delta = 150;
    PVector now = new PVector();
    PVector last = new PVector();
    last.set(location);
    now.set(location);

    while (dist > 0)
    {
      //stroke(0, 0, 255, 255);
      

      //move the now
      now.x += delta;
//      now.y += delta;

      

      dist -= delta;
      //line(last.x, last.y, now.x, now.y);
      
      PVector a1 = PVector.mult( PVector.add(now, last), .5);
      PVector a2 = PVector.mult( PVector.add(now, last), .5);
      a1.y -= 100*indirectness;
      a2.y += 100*indirectness;
      
      stroke(0, 255, 255, 255);
      ellipse(a1.x, a1.y, 5, 5);

      stroke(255, 200, 24, 255);
      ellipse(a2.x, a2.y, 5, 5);

      stroke(255, 50, 50, 255);
      bezier( last.x, last.y,
              a1.x-20, a1.y, 
              a2.x+20, a2.y,
              now.x, now.y);
      stroke(255, 50, 50, 255);
      ellipse(now.x, now.y, 9, 9);
      ellipse(last.x, last.y, 9, 9);
      last.set(now);
      //break;
    }
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

