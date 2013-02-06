DanceBox db = null;

float indirectness = .3;
LabanSystem ls;
FastConvexHull hm = new FastConvexHull();

PVector root_position = new PVector(0,0,0);
PVector rootPOld = new PVector(0,0);
PVector rootP = new PVector(0,0);
Vector<PVector> all_positions = new Vector<PVector>(21);
Vector<PVector> all_positions_p = new Vector<PVector>(21);


Vector<PShape> leafs = new Vector<PShape>();


void setup() {
  size(640, 480);
  initBox();
  ls = new LabanSystem(new PVector(0, 0));
  for(int i=0; i<21; i++)
  {
    all_positions.add(new PVector(0,0,0));
    all_positions_p.add(new PVector(0,0)); 
  }
  initLeafs();
  thread("feedMeData");
  //size(displayWidth, displayHeight);
}

void initLeafs()
{
  for(int i=1; i<14;i++)
  leafs.add( loadShape("images/leaf"+i+".svg"));
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

void triggerParticles()
{
  print("triggering particles");
  PVector v = new PVector(rootP.x-rootPOld.x, rootP.y-rootPOld.y);
  v.mult(.5);
  PVector a = new PVector(0,0);
  ls.addLine(db.center, indirectness, v,a);
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
    triggerParticles();
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
  if(frame%30 == 0)
  {
    triggerParticles();
  }
}

void initBox()
{
  db = new DanceBox(new PVector(300,300),30,60);
}

PVector kinectToPV(PVector k)
{
  PVector p = new PVector(k.x*100+200,-k.y*100+300);
  return p;
}

class DanceBox//just a visualization?
{
   PVector center;
   float width;
   float height;
   //maybe should be a box set
   
   DanceBox(PVector center, float width, float height)
   {
     this.center = center;
     this.height = height;
     this.width = width;
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
     
     Vector<PVector> conv = hm.getConvexHull(all_positions_p);
     PVector oldp = conv.get(conv.size()-1);
     for(PVector p:conv)
     {
       line(oldp.x,oldp.y,p.x,p.y);
       oldp = p;
     }
     
   }
}
