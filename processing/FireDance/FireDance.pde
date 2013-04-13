// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com


//import java.lang.Math;
// A list of fireballs
ArrayList<Fireball> fireballs;
int windowSize = 0;
Vector<Float> crowdSquares;
Vector<Float> crowdSquares_added;
Vector<Float> weight;
//PImage img;
float seekX = 200;
float seekY = 200;

int wiiPort = 9010;
int cameraSensorPort = 9020;
bool hasWeight;

//These are the variables that the communication code writes to.  Don't do anything but read from them
//or bad things (sychronization errors) will happen.
float accel = 0;

void setup() {

  //size(1920,1080,P3D);
  size(displayWidth, displayHeight, P3D);
  //img = loadImage("fire.jpg");
  //texture(img);
  // We are now making random fireballs and storing them in an ArrayList
  fireballs = new ArrayList<Fireball>();
  thread("wiiDataThread");
  thread("cameraSensorDataThread");
  hasWeight=false;
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
  float scale_x = float(displayWidth)/float(windowSize);
  float scale_y = float(displayHeight)/float(windowSize);
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




void draw() {

  background(255);
  //image(img, width/2, height/2);
 
 
 calculateWeight();
  if (windowSize > 0)
  {
    println("lets draw...");
    float scale_x = float(displayWidth)/float(windowSize);
    float scale_y = float(displayHeight)/float(windowSize);
    int index = 0;
    for (Float val:crowdSquares)
    {

      int x = -1+windowSize - index%windowSize;
      int y = index/windowSize;

      fill(color(0, val*255, 0));
      float fx = scale_x*(x+.5);
      float fy = scale_y*(y+.5);
      ellipse(fx, fy, 100, 100);
      index +=1;
    }
  } 
 
 
  
  for (Fireball f: fireballs) {
    // Path following and separation are worked on in this function
    f.applyBehaviors(fireballs);
    // Call the generic run method (update, borders, display, etc.)update();
    f.update();
    f.display();
  }

  // Instructions
  fill(0);
  text("Drag the mouse to generate new fireballs.", 10, height-16);
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






