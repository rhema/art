  PImage []imgs;
  object []boxes;
  int boxNum;
  int boxSize;
  int imageNum;
  float []zVal;
  
  int eyeID;//0:open, 1:closed
  int eyeBlinkSpeed=100;
  
   PImage []eyes;
  PImage pointer;
float currentSpeed;
  int cameraY;
  
  void prepareTextures()
  {
    imageNum=2;
    imgs=new PImage[10];
    imgs[0]=loadImage("clock.png");
    imgs[1]=loadImage("bluedoor.png");
    imgs[2]=loadImage("hotpinkbiscuit.png");
    imgs[3]=loadImage("purpledoor.png");
    imgs[4]=loadImage("teacup.png");
    imgs[5]=loadImage("teapot.png");
    
    pointer=loadImage("teapot.png");
    
    eyes=new PImage[2];
    eyes[0]=loadImage("eyeOpen.png");
    eyes[1]=loadImage("eyeClosed.png");
  }
  
     void drawEyes(float x,float y,float z,float thetax,float thetay,float thetaz)
    {
      pushMatrix();
      translate(x, y, z);
      rotateX(thetax);
      rotateY(thetay);
      rotateZ(thetaz);
      //scale(size);
      noStroke();
      
      int w,h;
      w=0;
      h=0;
       beginShape();
       if(eyeID<eyeBlinkSpeed*0.9)
       {
         texture(eyes[0]);
         w=eyes[0].width;
         h=eyes[0].height;
        
       }
        else 
       {
         texture(eyes[1]);
         w=eyes[1].width;
         h=eyes[0].height;
       }
        eyeID=(eyeID+1)%eyeBlinkSpeed;
        
        int sizeH=(int)((float)boxSize*(float)h/((float)w));
        vertex(-boxSize, -sizeH, 0, 0, 0);
        vertex(boxSize, -sizeH, 0, w, 0);
        vertex(boxSize, sizeH, 0, w, h);
        vertex(-boxSize, sizeH, 0, 0, h);
        endShape();
        popMatrix();
    }
    
  void setup() {
    int w=640;
    int h=480;
    boxSize=50;
    boxNum=60;
    cameraY=0;
    prepareTextures();
    size(w, h, P3D);
    eyeID=0;
    
    zVal=new float[boxNum];
    for(int i=0;i<boxNum;i++)
    {
        zVal[i]=random(0,260);
    }
    zVal=sort(zVal);
    
    boxes=new object[boxNum];
    for(int i=0;i<boxNum;i++)
    {
      boxes[i]=new object(w,h,i);
    }
  currentSpeed=2;
    noStroke();
  }
  
  void draw() {

    background(0);
      drawEyes(300,100,30,0,0,0);
    camera(width/2, height/2+cameraY, (height/2) / tan(PI/6), width/2, height/2+cameraY, 0, 0, 1, 0);
    
  //  pushMatrix();
 
   
     for(int i=0;i<boxNum;i++)
     {
       boxes[i].display();
     }
   //  popMatrix();
//    cameraY+=currentSpeed;
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
     int imageID;
   float x,y,z,thetax,thetay,thetaz,size;
    int w,h;
    int rotateDirection;
    float rotationSpeed;
    float life;
    
    float pointRotation;
   
    object(int _w,int _h,int zIndex) {
      w=_w;
      h=_h;
      pointRotation=0;
  
  generate(zIndex);
    
    }
    
    void generate(int zIndex)
    {
      imageID=(int)random(0,imageNum);
        this.image=imgs[imageID];
        x=random(-w/3,w/3)+w/2;
    //y=random(-h/3,h/3)+h/2;
    y=random(0,10*h);
    z=zVal[zIndex];
 
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
    
    void drawBox(float x,float y,float z,float thetax,float thetay,float thetaz,float size,int w,int h)
    {
      pushMatrix();
      translate(x, y, z);
      rotateX(thetax);
      rotateY(thetay);
      rotateZ(thetaz);
      //scale(size);
      noStroke();
       beginShape();
       
        texture(imgs[imageID]);
        vertex(-boxSize, -boxSize, 0, 0, 0);
        vertex(boxSize, -boxSize, 0, w, 0);
        vertex(boxSize, boxSize, 0, w, h);
        vertex(-boxSize, boxSize, 0, 0, h);
        endShape();
        popMatrix();
    }
  
    void display() {

      if(y<(cameraY-10)||y>(cameraY+h+10))
      return;
     drawBox(x,y,z,thetax,thetay,thetaz,size,pointer.width,pointer.height);
     if(imageID==0)
     {
       drawPointer(x,y,z,thetax,thetay,thetaz,size,imgs[imageID].width,imgs[imageID].height);
     }
 //  thetaz=thetaz+rotationSpeed*rotateDirection;
    }
    
    void drawPointer(float x,float y,float z,float thetax,float thetay,float thetaz,float size,int w,int h)
    {
         pushMatrix();
      translate(x, y, z);
      rotateX(thetax);
      rotateY(thetay);
      rotateZ(thetaz+pointRotation);
      //scale(size);
      noStroke();
       beginShape();
       
        texture(pointer);
        vertex(-boxSize, -boxSize, 0, 0, 0);
        vertex(boxSize, -boxSize, 0, w, 0);
        vertex(boxSize, boxSize, 0, w, h);
        vertex(-boxSize, boxSize, 0, 0, h);
        endShape();
        popMatrix();
        pointRotation+=PI/300;
    }
    
  
  }
