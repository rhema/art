Boolean useBinary = true;//Use binary or raw format
int incomingPort = 7777;

DanceBox db = null;
Random rnums = new Random();
float indirectness = .3;
LabanSystem ls;
FastConvexHull hm = new FastConvexHull();
Vector<PVector> conv = new Vector<PVector>();

PVector root_position = new PVector(0,0,0);
PVector rootPOld = new PVector(0,0);
PVector rootP = new PVector(0,0);
Vector<PVector> all_positions = new Vector<PVector>(21);
Vector<PVector> all_positions_p = new Vector<PVector>(21);
Vector<GrowLine> box = new Vector<GrowLine>();



Vector<PShape> leafs = new Vector<PShape>();


void setup() {
  //size(640, 480);
  size(displayWidth, displayHeight);
  setupColors();
  initBox();
  int points_in_skel = 21;
  if(useBinary)
  {
    points_in_skel -= 1;
  }
  
  ls = new LabanSystem(new PVector(0, 0));
  for(int i=0; i<points_in_skel; i++)
  {
    all_positions.add(new PVector(0,0,0));
    all_positions_p.add(new PVector(0,0)); 
  }
  initLeafs();
  thread("feedMeData");
}

void initLeafs()
{
  for(int i=0; i<4; i++)
    box.add(new GrowLine(new PVector(0,0), new PVector(100,100)));
  
  for(int i=1; i<14;i++)
    leafs.add( loadShape("images/leaf"+i+".svg"));
}

PVector velP = new PVector(0,0);
PVector velPOld = new PVector(0,0);

void dancerPositionAlteredEvent()
{
  rootPOld = rootP;
  rootP = kinectToPV(root_position);
//  velPOld.set(velP);
//velP.set(rootPOld);
//velP.sub(rootP);
//  PVector accel = new PVector(0,0);
//  accel.set(velPOld);
//  accel.sub(velP);
//  print("eahhhhh....");
//  print(accel);
  
  int i = 0;
  for(PVector p:all_positions)
  {
    all_positions_p.get(i).set(kinectToPV(p));
    i+=1;
  }
}

PVector runningV = new PVector(0,0);
  PVector between(PVector a, PVector b, float t)
  {
    PVector delta = PVector.sub(b,a);
    return PVector.add(a,PVector.mult(delta,t)); 
  }
void triggerParticles(boolean really)
{
  //print("triggering particles");
  //PVector v = new PVector(rootP.x-rootPOld.x, rootP.y-rootPOld.y);
  //PVector a = new PVector(0,.1*(1-indirectness));
  PVector v = new PVector(0,0);
  PVector a = new PVector(0,0);
  PVector start = new PVector(0,0);
  runningV = between(runningV,v,.8);
  //print(runningV);
  if(really == false && ! (abs(runningV.x) > 1.6))
     return; 
  if(conv.size() > 0)//make random point on outside be the start point
  {
    int num = abs(rnums.nextInt());
    int number_on_conv = conv.size();
    int index = num%(conv.size()-1);
    print("Count,"+number_on_conv+" rand,"+num+" picked,"+index);
    start.set(conv.get(index));
  }
  else
  {
    start.set(db.center);
  }
  print(runningV);
  ls.addLine(start, indirectness, runningV,a);
}

void key_controler()
{
  if(keyPressed)
  {
    print("key "+key+" was pressed");
  }
  if(key == 'w')
    indirectness += .1;
  if(key == 's')
    indirectness -= .1;
  if(key == ' ')
    triggerParticles(true);
}

void keyPressed()
{
  key_controler();
}

int frame = 0;
void draw()
{
  frame += 1;
  background(0);
  if(db != null)
  {
    db.display();
  }
  ls.run();
  if(frame%4 == 0)
  {
    triggerParticles(false);
  }
}

void initBox()
{
  db = new DanceBox(new PVector(300,300),30,60);
}

PVector kinectToPV(PVector k)
{
  PVector p = new PVector(k.x*200+400,-k.y*200+500);
  return p;
}

class DanceBox//just a visualization?
{
   PVector center;
   float width;
   float height;
   color c;
   //maybe should be a box set
   
   DanceBox(PVector center, float width, float height)
   {
     this.center = center;
     this.height = height;
     this.width = width;
     c = getColor(.3);
   }
   
   void display()
   {
     //center.x = root_position.x*300+500;
     //center.y = root_position.z*300+400;
     center = kinectToPV(root_position);
     //show an x8
     stroke(255,255,255);
     color(1);
     float fac = indirectness+1;
//     line(center.x,center.y,center.x+.5*width,center.y+.5*height);
//     line(center.x,center.y,center.x-.5*width,center.y+.5*height);
//     line(center.x,center.y,center.x+.5*width,center.y-.5*height);
//     line(center.x,center.y,center.x-.5*width,center.y-.5*height);
//     noFill();
//     ellipse(center.x,center.y,width*fac,height*fac);
     for(PVector pos:all_positions)
     {
       PVector p = kinectToPV(pos);
       ellipse(p.x,p.y,3,3);
     }
     
     conv = hm.getConvexHullBox(all_positions_p);
     float expansionFactor = 1 + 4*indirectness;
          for(PVector p:conv)
     {
       p.x -= rootP.x;
       p.y -= rootP.y;
       p.x *= expansionFactor;
       p.y *= expansionFactor;
       p.x += rootP.x;
       p.y += rootP.y;
     }
     PVector oldp = conv.get(conv.size()-1);
     int i = 0;
     for(PVector p:conv)
     {
       GrowLine g = box.get(i);//new GrowLine(new PVector(oldp.x,oldp.y), new PVector(p.x,p.y));
       g.start.x = oldp.x;
       g.start.y = oldp.y;
       g.end.x = p.x;
       g.end.y = p.y;
       stroke(c);//255,255,255,255);
       g.display();
       //line(oldp.x,oldp.y,p.x,p.y);
       oldp = p;
       i+=1;
     }
     
   }
}
