// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

class Fireball {

  // All the usual stuff
  PVector location;
  PVector velocity;
  PVector acceleration;
  float   r;
  float   maxforce;       // Maximum steering force
  float   maxspeed;       // Maximum speed
  float   maxspeeddecay;  // bb //speed at witch maxspeed goes back to normal speed
  float   normalspeed;    // bb speed with no kick
  float   kickspeed;      // bb with kick, set max speed, then decay max speed
  PVector decay;          // bb // decay value for acceleration
  PVector kick;           // bb // force to apply big kick to velocity on an eventb
  int     fadeout;        //  Alpha fades from 255 to 0.
  color   c;              // bb // color of the object
  int     alpha;          // bb
  PImage img;             //Texture the circles.

    // Constructor initialize all values
  Fireball(float x, float y, color cc) {
    location     = new PVector(x, y);
    r            = 12;
    normalspeed  = 5;                 //bb
    maxspeed     = normalspeed;       //bb
    maxspeeddecay= 0.2;               //bb
    kickspeed    = 10;                //bb
    maxforce     = 0.2;
    acceleration = new PVector(0, 0);
    velocity     = new PVector(0, 0);
    decay        = new PVector(0, 0);  //bb
    kick         = new PVector(0, 0);  //bb
    fadeout      = 0;
    c            = cc; //bb
    alpha        = 255; //bb
    img = loadImage("fire.jpeg");
    
  }
  
  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }
  
  void fadeout() {
     if (fadeout != 0){
       color cc = color(c);
       //int alpha = (cc >> 24) & 0xFF;
       int red   = (cc >> 16) & 0xFF;
       int green = (cc >> 8)  & 0xFF;
       int blue  =  cc        & 0xFF;
       alpha = alpha - 1;
       c = color(red,green,blue,alpha);
     }
  }

  
  
  //bb
  void decaySpeed() {
    //print("MaxSpeed "); print(maxspeed); print(" NormalSpeed "); println(normalspeed);
    if(maxspeed > normalspeed){
      maxspeed = maxspeed - maxspeeddecay;  //bb 
    }
  }
  
  void applyBehaviors(ArrayList<Fireball> fireballs) {
     PVector separateForce = separate(fireballs);
     PVector seekForce = seek(new PVector(mouseX,mouseY));
     separateForce.mult(2);
     seekForce.mult(1);
     applyForce(separateForce);
     applyForce(seekForce); 
     decaySpeed();
     applyForce(kick);  //bb
     fadeout();         //bb
  }
  
  // A method that calculates a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target,location);  // A vector pointing from the location to the target
    
    // Normalize desired and scale to maximum speed
    desired.normalize();
    //println(maxspeed);
    desired.mult(maxspeed);
    // Steering = Desired minus velocity
    PVector steer = PVector.sub(desired,velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    
    return steer;
  }

  // Separation
  // Method checks for nearby fireballs and steers away
  PVector separate (ArrayList<Fireball> fireballs) {
    float desiredseparation = r*2;
    PVector sum = new PVector();
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Fireball other : fireballs) {
      float d = PVector.dist(location, other.location);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(location, other.location);
        diff.normalize();
        diff.div(d);        // Weight by distance
        sum.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      sum.div(count);
      // Our desired vector is the average scaled to maximum speed
      sum.normalize();
      sum.mult(maxspeed);
      // Implement Reynolds: Steering = Desired - Velocity
      sum.sub(velocity);
      sum.limit(maxforce);
    }
    return sum;
  }


  // Method to update location
  void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    location.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
    kick.mult(0);  // bb
  }

  void display() {
    noStroke();
    fill(c);
    stroke(0);
    pushMatrix();
    //image(img, location.x, location.y);
    translate(location.x, location.y);
    ellipse(0, 0, r, r);
    popMatrix();
  }

}






