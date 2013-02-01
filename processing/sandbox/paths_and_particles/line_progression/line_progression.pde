import processing.opengl.*;


ParticleSystem ps;
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
    stroke(255, 255);
    fill(255, 255);
    ellipse(location.x, location.y, 8, 8);

    int ax = 50;
    int ay = 50;

    noFill();

    line(location.x, location.y, location.x+range, location.y);

    //stroke(255, 102, 0);
    //curve(location.x+50, location.y+50, location.x-25, location.y+25,  location.x, location.y, location.x, location.y);
    //stroke(0); 
    //curve(5, 26, 73, 24, 73, 61, 15, 65); 
    //stroke(255, 102, 0);
    //curve(73, 24, 73, 61, 15, 65, 15, 65);
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

class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;

  ParticleSystem(PVector location) {
    origin = location.get();
    particles = new ArrayList<Particle>();
  }

  void addParticle() {
    particles.add(new Particle(origin));
  }

  void run() {
    Iterator<Particle> it = particles.iterator();
    while (it.hasNext ()) {
      Particle p = it.next();
      p.run();
      if (p.isDead()) {
        it.remove();
      }
    }
  }
}



// A simple Particle class

class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan;

  Particle(PVector l) {
    acceleration = new PVector(0, 0.05);
    velocity = new PVector(random(-3, 1), random(-2, 0));
    location = l.get();
    lifespan = 120.0;
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
  }

  // Method to display
  void display() {
    stroke(255, lifespan);
    fill(255, lifespan);
    ellipse(location.x, location.y, 8, 8);

    int ax = 50;
    int ay = 50;

    noFill();
    stroke(255, 102, 0);
    curve(location.x+50, location.y+50, location.x-25, location.y+25, location.x, location.y, location.x, location.y);
    //stroke(0); 
    //curve(5, 26, 73, 24, 73, 61, 15, 65); 
    //stroke(255, 102, 0);
    //curve(73, 24, 73, 61, 15, 65, 15, 65);
  }

  // Is the particle still useful?
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } 
    else {
      return false;
    }
  }
}

