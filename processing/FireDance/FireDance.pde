// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

int MOVIE_MASK = 1;
int JUST_AN_IMAGE = 2;
int draw_mode = JUST_AN_IMAGE;

boolean just_mask=false;

float jitter_dist = 4;

//import java.lang.Math;
// A list of fireballs
ArrayList<Fireball> fireballs;
int windowSize = 0;
Vector<Float> crowdSquares;
Vector<Float> crowdSquares_added;//use crowdSquares_added instead of corwdSquares
Vector<Float> weight;
//PImage img;
float seekX = 200;
float seekY = 200;

int wiiPort = 9010;
int cameraSensorPort = 9020;
boolean hasWeight;
int numFramesTilGenerate = 20;

//These are the variables that the communication code writes to.  Don't do anything but read from them
//or bad things (sychronization errors) will happen.
float accel = 0;

boolean show_crowd_visualization = false;


import codeanticode.syphon.*;
import processing.video.*;
Movie movie;

PImage img;
PImage imgMask;
PImage background_image;
String backgound_image_file = "firetest1.png";
int w = 400;
int h = 600;
PGraphics maskme;
PGraphics revealedImage;
PGraphics syphonImage;
PShader blur;

SyphonServer server;
int windowWidth = 0;
int windowHeight = 0;

void setup() {
  
  //size(1920,1080,P3D);
  windowWidth = displayWidth;
  windowHeight = displayHeight;
  windowWidth = w;
  windowHeight = h;
  size(windowWidth, windowHeight, P3D);
  
  background_image = loadImage(backgound_image_file);
  //img = loadImage("fire.jpg");
  //texture(img);
  // We are now making random fireballs and storing them in an ArrayList
  fireballs = new ArrayList<Fireball>();
  thread("wiiDataThread");
  thread("cameraSensorDataThread");
  hasWeight=false;
  
  
  
   maskme = createGraphics(w, h, P3D);
   revealedImage = createGraphics(w, h, P3D);
   syphonImage = createGraphics(w, h, P3D);
 
    server = new SyphonServer(this, "Processing Syphon");
   if(draw_mode == MOVIE_MASK)
   {
     movie = new Movie(this, "bubbles.mov");
     movie.play();
   }
  
//  windowSize=3;
//    crowdSquares = new Vector<Float>();
//        for(int i=0; i<windowSize*windowSize; i++)
//        {
//          crowdSquares.add(new Float(0));
//        }
//        crowdSquares.set(0,1.0);
//        
//  setupWeight();
//  calculateWeight();
//  windowSize=0;
}

void movieEvent(Movie m) {
  m.read();
}


float max = 0;
void gotWiiData()
{
  /*
  if(accel > max)
   {
   max = accel;
   println(max);
   }*/

  if (accel > .50)
  {
    //pow
    kickBalls();
  }
  //println(accel);
}

float winner_x = 100;
float winner_y = 100;

void gotCameraSensorData()
{
  println("I HAS DATA");
  //Now a function goes here that lists left and right position... maybe find a winner?
  int x = 0;
  int y = 0;
  float mm = 0;
  int index = 0;
  for (Float val:crowdSquares)
  {
    if (val > mm)
    {
      x = -1 + windowSize - index%windowSize;
      y = index/windowSize;
      mm = val;
    }
    index +=1;
  } 
  println("X:"+x+" "+"Y:"+y);
  float scale_x = float(windowWidth)/float(windowSize);
  float scale_y = float(windowHeight)/float(windowSize);
  //winner_x = (.5+x)*scale_x;
  //winner_y = (.5+y)*scale_y;
  seekX = (.5+x)*scale_x;
  seekY = (.5+y)*scale_y;
  
  if(!hasWeight)
  {
     setupWeight();
     hasWeight=true;
  }
 
  //displayWidth, displayHeight
}


void visualizeWeights()
{
  if (windowSize > 0)
  {
    println("lets draw...");
    float scale_x = float(windowWidth)/float(windowSize);
    float scale_y = float(windowHeight)/float(windowSize);
    int index = 0;
    for (Float val:crowdSquares)
    {

      int x = -1+windowSize - index%windowSize;
      int y = index/windowSize;
      
      color c = color(0, val*255, 0);
      stroke(c);
      fill(c);
      float fx = scale_x*(x+.5);
      float fy = scale_y*(y+.5);
      float serze = 10 + 10*crowdSquares_added.get(index); 
      ellipse(fx, fy, serze, serze);
      index +=1;
    }
  } 
}



//PImage reallyrevealedImage = null;

void draw() {

  background(0);
  //image(img, width/2, height/2);
  calculateWeight();
  if(show_crowd_visualization)
  {
    visualizeWeights();
  }
  
  
  maskme.beginDraw();
  maskme.pushMatrix();
  maskme.scale(1,-1);
  maskme.translate(0,-h);
  maskme.fill(0,0,0,255);
  maskme.rect(0,0,w,h);
  for (Fireball f: fireballs) {
    // Path following and separation are worked on in this function
    f.applyBehaviors(fireballs);
    // Call the generic run method (update, borders, display, etc.)update();
    f.update();
    f.display(maskme);
  }
  maskme.popMatrix();
  maskme.endDraw();
  
  revealedImage.beginDraw();
  
  if(draw_mode == MOVIE_MASK)
  {
    revealedImage.image(movie, 0,0,w,h);
  }
  
  if(draw_mode == JUST_AN_IMAGE)
  {
    revealedImage.image(background_image, 0,0,w,h);
    
  }
  
  
  revealedImage.endDraw();
  
  //reallyrevealedImage.mask(maskme);
  //revealedImage.image(background_image, 0,0,w,h);
  ///
  
  revealedImage.blend(maskme,0,0, w,h, 0,0,w,h,MULTIPLY);

  
  syphonImage.beginDraw();
  syphonImage.background(0);
 
 if(!just_mask)
{ 
  syphonImage.image(revealedImage, 0,0,w,h);
}
else
{
  syphonImage.scale(1,-1);
  syphonImage.translate(0,-h);
  syphonImage.image(maskme, 0,0,w,h);
}
 // syphonImage.image(revealedImage, 0,0,w,h);
 
  syphonImage.endDraw();
  
   image(syphonImage,0,0);
 server.sendImage(syphonImage);
  
  
  ArrayList<Fireball> fireballsTemp =  new ArrayList<Fireball>();//remove dead fireballs
  for (Fireball f: fireballs) {
    if(f.life > 0)
    {
      fireballsTemp.add(f);
    }
  }
  fireballs = fireballsTemp;

  // Instructions
  fill(0);
  //text("Drag the mouse to generate new fireballs.", 10, height-16);
  
  if(frameCount % numFramesTilGenerate == 0)
     fireballs.add(new Fireball(random(width), random (height), color(0,0,0)));
  
}


//void mouseDragged() {
//  fireballs.add(new Fireball(mouseX,mouseY));
//}

void kickBalls()
{
  for (Fireball f: fireballs) 
  {
    f.kick = new PVector(random(-1*f.kickspeed, f.kickspeed), random(-1*f.kickspeed, f.kickspeed));
    f.maxspeed = f.kickspeed;
  }
}

void keyPressed() {
  int count = 0;
  int kick  = 0; //bb
  color cc  = color(255, 204, 0);
  int fadeout = 0;

  //This allows the user to have three balls on 1, 10 balls on 2, and 20 balls on 3
  if(key == 'v')
    show_crowd_visualization = !show_crowd_visualization;
  if(key == 'm')
    just_mask = !just_mask;
  if (key == '0') {
    count = 0;
  } 
  else if (key == '1') {
    count = 3;
    cc  = color(255, 0, 0);
  } 
  else if (key == '2') {
    count = 10; 
    cc  = color(0, 0, 255);
  } 
  else if (key == '3') {
    count = 20; 
    cc  = color(0, 255, 0);
  } 
  else if (key == '4') { //bb
    kick = 1;
  }
  else if (key == '5') {
    fadeout = 1;
  }

/*

  if (count != 0 ) { //bb
    //This allows us to go up and down in crowd sizes (hopefully according to movement)
    if (count > fireballs.size()) {
      int difference = count - fireballs.size();
      for (int i = 0; i < difference; i++) {
        fireballs.add(new Fireball(random(width), random (height), cc));
      }
    }
    else if (count < fireballs.size()) {
      int difference = fireballs.size() - count;
      for (int i = 0; i < difference; i++) {
        fireballs.remove(fireballs.size()-1);
      }
    }
  }
  */

  print("Count: "); 
  print(count); 
  print(" Size: "); 
  println(fireballs.size());

  // bb
  for (Fireball f: fireballs) {
    //f.maxspeed = count * 100; 

    if (fadeout == 1) {
      f.fadeout = 1;
    }
  } 

  if (kick == 1) {
    kickBalls();
  }
}






