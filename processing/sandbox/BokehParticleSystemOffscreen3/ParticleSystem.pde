// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 

class ParticleSystem {

  ArrayList particles;    // An arraylist for all the particles
  PVector origin;        // An origin point for where particles are born
  
  // just make an empty particle system
  ParticleSystem() {
    particles = new ArrayList();              // Initialize the arraylist
  }
  
  // modified run to pass destination Offscreen to particle
  void run(GLGraphicsOffScreen dest) {
    // Cycle through the ArrayList backwards b/c we are deleting
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = (Particle) particles.get(i);
      p.run(dest);
      if (p.dead()) {
        particles.remove(i);
      }
    }
  }
  
  // added function to pass more parameters like r, v and the texture
  void addParticle(float x, float y, float r, float v, GLTexture t) {
    particles.add(new Particle(new PVector(x,y), r, v, t));
  }

  void addParticle(Particle p) {
    particles.add(p);
  }

  // A method to test if the particle system still has particles
  boolean dead() {
    if (particles.isEmpty()) {
      return true;
    } else {
      return false;
    }
  }

}

