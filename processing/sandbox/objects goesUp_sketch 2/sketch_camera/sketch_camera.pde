  PImage img;
  object []boxes;
  int boxNum;
  int boxSize;
  
float currentSpeed;
  int cameraY;
  
  void setup() {
    int w=640;
    int h=480;
    boxSize=50;
    boxNum=60;
    cameraY=0;
    size(w, h, P3D);
    img = loadImage("clock.png");
    boxes=new object[boxNum];
    for(int i=0;i<boxNum;i++)
    {
      boxes[i]=new object(img,w,h);
    }
  currentSpeed=5;
    noStroke();
  }
  
  void draw() {

    background(0);
    camera(width/2, height/2+cameraY, (height/2) / tan(PI/6), width/2, height/2+cameraY, 0, 0, 1, 0);
     for(int i=0;i<boxNum;i++)
     {
       boxes[i].display();
     }
    cameraY+=2;
  //  beginShape();
  //      texture(img);
  //      vertex(-100, -100, 0, 0, 0);
  //      vertex(100, -100, 0, img.width, 0);
  //      vertex(100, 100, 0, img.width, img.height);
  //      vertex(-100, 100, 0, 0, img.height);
  //      endShape();
  }
  
  class object
  {
      PImage image;
   float x,y,z,thetax,thetay,thetaz,size;
    int w,h;
    int rotateDirection;
    float rotationSpeed;
    float life;
   
    object(PImage image,int _w,int _h) {
      w=_w;
      h=_h;
    this.image=image;
  generate();
    
    }
    
    void generate()
    {
        x=random(-w/3,w/3)+w/2;
    //y=random(-h/3,h/3)+h/2;
    y=random(0,10*h);
    z=random(0,260);
 
    thetax=thetay=thetaz=0;
    thetay=random(-PI/4,PI/4);
    thetaz=random(-PI/2,PI/2);
    size=random(0.5,3);
   //fallSpeed=random(3,6);
    
    float tmp=random(-1,1);
    if(tmp>0)
    rotateDirection=1;
    else
    rotateDirection=-1;
    rotationSpeed=random(PI/200,PI/80);
    life=random(10,30);
    }
    
    void drawBox(float x,float y,float z,float thetax,float thetay,float thetaz,float size)
    {
      pushMatrix();
      translate(x, y, z);
      rotateX(thetax);
      rotateY(thetay);
      rotateZ(thetaz);
      //scale(size);
      noStroke();
       beginShape();
        texture(image);
        vertex(-boxSize, -boxSize, 0, 0, 0);
        vertex(boxSize, -boxSize, 0, img.width, 0);
        vertex(boxSize, boxSize, 0, img.width, img.height);
        vertex(-boxSize, boxSize, 0, 0, img.height);
        endShape();
        popMatrix();
    }
  
    void display() {

      if(y<(cameraY-10)||y>(cameraY+h+10))
      return;
     drawBox(x,y,z,thetax,thetay,thetaz,size);
   thetaz=thetaz+rotationSpeed*rotateDirection;
    }
    
  
  }
