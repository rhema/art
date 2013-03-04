import codeanticode.syphon.*;

Boolean useBinary = true;//Use binary or raw format
int incomingPort = 7777;

Random rnums = new Random();
float indirectness = .3;
float next_indirectness = .3;

PVector root_position = new PVector(0, 0, 0);
PVector rootPOld = new PVector(0, 0);
PVector rootP = new PVector(0, 0);
Vector<PVector> all_positions = new Vector<PVector>(21);
Vector<PVector> all_positions_p = new Vector<PVector>(21);

PGraphics canvas;
PGraphics canvas2;
SyphonServer server;


//Add 30 second timer count down...

PImage img;
Vector<PImage> trees = new Vector<PImage>();

PImage sky;

PImage grass;
PImage grassv2;


void setup() {
  int swidth = 640;//displayWidth
  int sheight = 480;//displayHeight
  size(swidth, sheight, P3D);
  for (int i=1;i<5;i++)
  {
    trees.add(loadImage("images/tree_k"+i+".png"));
  }
  sky = loadImage("images/sky.png");
  grass = loadImage("images/grass.png");
  grassv2 = loadImage("images/grassv2.png");
  canvas = createGraphics(swidth, sheight, P3D);
  canvas2 = createGraphics(swidth, sheight, P3D);

  server = new SyphonServer(this, "Processing Syphon");

  int points_in_skel = 21;
  if (useBinary)
  {
    points_in_skel -= 1;
  }

  for (int i=0; i<points_in_skel; i++)
  {
    all_positions.add(new PVector(0, 0, 0));
    all_positions_p.add(new PVector(0, 0));
  }
  
  setup2(canvas);
  thread("feedMeData");
}

float blah = 3;

/*
void draw()
 {
 background(0x334455);
 
 canvas.beginDraw();
 canvas.background(127);
 canvas.lights();
 canvas.translate(width/2, height/2,-1*frameCount);
 canvas.rect(0,0,10,10);
 canvas.rotateZ(.8);
 canvas.rotateX(frameCount * 0.01);
 canvas.rotateY(frameCount * 0.01);
 canvas.endDraw();
 image(canvas, 0, 0);
 }
 */

/*
void draw()  {
 background(0x334455);
 canvas.beginDraw();
 if(mousePressed) {
 float fov = PI/3.0; 
 float cameraZ = (height/2.0) / tan(fov/2.0); 
 canvas.perspective(fov, float(width)/float(height), cameraZ/2.0, cameraZ*2.0); 
 } else {
 canvas.ortho(0, width, 0, height); 
 }
 canvas.translate(width/2, height/2, 0);
 canvas.rotateX(-PI/6); 
 canvas.rotateY(PI/3); 
 canvas.box(160); 
 
 canvas.endDraw();
 image(canvas, 0, 0);
 }*/

/*
void draw() {
 background(0);
 camera(mouseY, height/2, (height/2) / tan(PI/6), mouseY, height/2, 0, 0, 1, 0);
 translate(width/2, height/2, -100);
 stroke(255);
 noFill();
 box(200);
 
 noStroke();
 beginShape();
 texture(img);
 vertex(-100, -100, 0, 0,   0);
 vertex( 100, -100, 0, 990, 0);
 vertex( 100,  100, 0, 990, 742);
 vertex(-100,  100, 0, 0,   742);
 endShape();
 
 }*/


float x=0;
float y=0;
float z=-400;
float total_time=10.0;
float mid_dur = 2;
 

void drawTrees(PGraphics canvas)
{
   float squish = ((float)(mouseY))/((float)(canvas.height+1));
  println(squish+ "   "+mouseY);
  float scaleDiff = 2.0 - 2.0*squish;
  //from -1 to +1
  
  scaleDiff = ((millis()/1000.0)/total_time)*2;
  println(scaleDiff);

  float sub = (squish*.5*((float)canvas.height));

  canvas.pushMatrix();
  canvas.translate(-width/2, -height/2, -400);
  canvas.scale(2, 2, 2);
  canvas.image(sky, 0, 0);
  canvas.popMatrix();


  canvas.pushMatrix();
  canvas.rotateX(PI/180.0*90.0);
  canvas.translate(-width/2, -height, -450);
  canvas.scale(2, 2, 2);
  canvas.image(grass, 0, 0);
  canvas.popMatrix();

  //canvas.camera(mouseY, height/2, (height/2) / tan(PI/6), mouseY, height/2, 0, 0, 1, 0);
  canvas.translate(width/2, height/2, -100);

  canvas.pushMatrix();
  canvas.translate(x, y, z);

  //  canvas.stroke(255);
  //  canvas.noFill();
  //  canvas.box(200);

  canvas.pushMatrix();

  int derFrame = 700 + frameCount%(1500);
  //copy and cycle...
  float ydiff = -(1+scaleDiff)*210*.5 + 240;
  canvas.translate(0, ydiff, 0);
  for (int layer=0;layer<5;layer++)
  {
    for (int i=0;i<25;i++)
    {
      img = trees.get((i+layer*13)%trees.size());

      canvas.pushMatrix();
      canvas.translate((((float)layer)/5.0)*400*i-derFrame/2, 0, 100*layer);
      canvas.scale(1, scaleDiff+1, 1);
      canvas.noStroke();
      canvas.beginShape();
      canvas.noFill();
      canvas.noStroke();
      canvas.texture(img);
      canvas.vertex(-100, -100, 0, 0, 0);
      canvas.vertex( 100, -100, 0, 990, 0);
      canvas.vertex( 100, 100, 0, 990, 742);
      canvas.vertex(-100, 100, 0, 0, 742);
      canvas.endShape();
      canvas.popMatrix();
    }
  }
  canvas.popMatrix();

  for (int layer=4;layer<5;layer++)
  {
    for (int i=0;i<25;i++)
    {
      img = trees.get((i+layer*13)%trees.size());

      canvas.pushMatrix();
      canvas.translate((((float)layer)/5.0)*200*i-derFrame/2, 0, 100*layer);
      canvas.scale(1, 3, 1);
      canvas.noStroke();
      canvas.beginShape();
      canvas.noFill();
      canvas.noStroke();
      canvas.texture(grassv2);
      canvas.vertex(-100, -100, 0, 0, 0);
      canvas.vertex( 100, -100, 0, 990, 0);
      canvas.vertex( 100, 100, 0, 990, 742);
      canvas.vertex(-100, 100, 0, 0, 742);
      canvas.endShape();
      canvas.popMatrix();
    }
  }


  canvas.popMatrix();
}

boolean treeson = true;//false;

void draw() {

  canvas.beginDraw();
  canvas.background(0);
  if(treeson){
     drawTrees(canvas);
  }
  else
  {
     draw2(canvas); 
  }
  canvas.endDraw();

  //  canvas2.beginDraw();
  //  canvas2.background(0);
  //    canvas2.image(canvas, 0, sub/2.0, canvas.width, canvas.height-sub);
  //  canvas2.endDraw();
  float seconds = (millis()/1000.0);

  float offsett = 0;
  if(seconds > total_time && treeson == true)
  {
    offsett = (seconds-total_time)/mid_dur*480.0;
   if(seconds > (total_time + mid_dur))
      treeson = false; 
  }
  
  canvas2.beginDraw();
  canvas2.background(0);
  canvas2.image(canvas, 0, -offsett);
  canvas2.endDraw();
  image(canvas2, 0, 0);
  
  server.sendImage(canvas2);
}



PVector kinectToPV(PVector k)
{
  PVector p = new PVector(k.x*200+400, -k.y*200+500);
  return p;
}

void dancerPositionAlteredEvent()
{
  rootPOld = rootP;
  rootP = kinectToPV(root_position);

  int i = 0;
  for (PVector p:all_positions)
  {
    all_positions_p.get(i).set(kinectToPV(p));
    i+=1;
  }
}








