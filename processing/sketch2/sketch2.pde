Boolean useBinary = true;//Use binary or raw format
int incomingPort = 7777;

Random rnums = new Random();
float indirectness = .3;
float next_indirectness = .3;

PVector root_position = new PVector(0,0,0);
PVector rootPOld = new PVector(0,0);
PVector rootP = new PVector(0,0);
Vector<PVector> all_positions = new Vector<PVector>(21);
Vector<PVector> all_positions_p = new Vector<PVector>(21);

PGraphics canvas;

void setup() {
  //size(640, 480);
  size(displayWidth, displayHeight,P3D);
  canvas = createGraphics(displayWidth, displayHeight,P3D);
  int points_in_skel = 21;
  if(useBinary)
  {
    points_in_skel -= 1;
  }
  
  for(int i=0; i<points_in_skel; i++)
  {
    all_positions.add(new PVector(0,0,0));
    all_positions_p.add(new PVector(0,0)); 
  }
  thread("feedMeData");
}

float blah = 3;
void draw()
{
  background(0x334455);
  
  canvas.beginDraw();
  canvas.background(127);
  canvas.ellipse(24,blah,24,24);
  canvas.lights();
  canvas.translate(width/2, height/2);
  canvas.rotateX(frameCount * 0.01);
  canvas.rotateY(frameCount * 0.01);
    
  canvas.endDraw();
  image(canvas, 0, 0);
}
PVector kinectToPV(PVector k)
{
  PVector p = new PVector(k.x*200+400,-k.y*200+500);
  return p;
}

void dancerPositionAlteredEvent()
{
  rootPOld = rootP;
  rootP = kinectToPV(root_position);
  
  int i = 0;
  for(PVector p:all_positions)
  {
    all_positions_p.get(i).set(kinectToPV(p));
    i+=1;
  }
}
