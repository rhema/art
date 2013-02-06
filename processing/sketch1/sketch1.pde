DanceBox db = null;

float indirectness = .3;

void setup() {
  size(640, 480);
  initBox();
  //size(displayWidth, displayHeight);
}

void draw()
{
  if(db != null)
  {
    db.display();
  }
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
     //show an x8
     float fac = indirectness+1;
     line(center.x,center.y,center.x+.5*width,center.y+.5*height);
     line(center.x,center.y,center.x-.5*width,center.y+.5*height);
     line(center.x,center.y,center.x+.5*width,center.y-.5*height);
     line(center.x,center.y,center.x-.5*width,center.y-.5*height);
     noFill();
     ellipse(center.x,center.y,width*fac,height*fac);
   }
}
