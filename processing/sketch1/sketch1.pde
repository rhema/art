DanceBox db = null;

float indirectness = .3;
LabanSystem ls;

PVector root_position = new PVector(0,0,0);

void setup() {
  size(640, 480);
  initBox();
  ls = new LabanSystem(new PVector(0, 0));
  thread("feedMeData");
  //size(displayWidth, displayHeight);
}


void triggerParticles()
{
  print("triggering particles");
  ls.addLine(db.center, indirectness);
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

void draw()
{
  background(0);
  if(db != null)
  {
    db.display();
  }
  ls.run();
}

void initBox()
{
  db = new DanceBox(new PVector(300,300),30,60);
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
     center.x = root_position.x*300+500;
     center.y = root_position.z*400+400;
     //show an x8
     stroke(255,255,255);
     color(1);
     float fac = indirectness+1;
     line(center.x,center.y,center.x+.5*width,center.y+.5*height);
     line(center.x,center.y,center.x-.5*width,center.y+.5*height);
     line(center.x,center.y,center.x+.5*width,center.y-.5*height);
     line(center.x,center.y,center.x-.5*width,center.y-.5*height);
     noFill();
     ellipse(center.x,center.y,width*fac,height*fac);
   }
}
