PImage []imgs;
object []boxes;
Eyes []catEye;
int boxNum;
int eyeNum;
int boxSize;
int imageNum;
float []zVal;
float previousSpeed;

int eyeBlinkSpeed=100;
  
PImage []eyes;
PImage pointer;
float currentSpeed;
  int cameraY;
  
  void prepareTextures()
  {
    imageNum=3;
    imgs=new PImage[10];
    imgs[0]=loadImage("images/clock.png");
    imgs[1]=loadImage("images/bluedoor.png");
    imgs[2]=loadImage("images/hotpinkbiscuit.png");
    imgs[3]=loadImage("images/purpledoor.png");
    imgs[4]=loadImage("images/teacup.png");
    imgs[5]=loadImage("images/teapot.png");
    
    pointer=loadImage("images/teapot.png");
    
    eyes=new PImage[2];
    eyes[0]=loadImage("images/eyeOpen.png");
    eyes[1]=loadImage("images/eyeClosed.png");
  }
  

    
  void setup2(PGraphics canvas) {
    int w=640;
    int h=480;
    boxSize=50;
    boxNum=60;
    eyeNum=10;
    cameraY=0;
    prepareTextures();
//    size(w, h, P3D);

    
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
      boxes[i].myCanvas = canvas;
    }
    catEye=new Eyes[eyeNum];
     for(int i=0;i<eyeNum;i++)
    {
      catEye[i]=new Eyes(w,h);
      catEye[i].myCanvas = canvas;
    }
    
  currentSpeed=2;
    //noStroke();
  }
  
  void keyPressed() {
     if (key == 's' || key == 'S') {
       if(currentSpeed>0)
       {
         previousSpeed=currentSpeed;
          currentSpeed=0;
       }
          else
          currentSpeed=previousSpeed;
    }
    else if (key == 'q' || key == 'Q')
         currentSpeed+=1;
      else if (key == 'e' || key == 'E')
      {
         currentSpeed-=1;   
       if(currentSpeed<1)
            currentSpeed=1;  
      }
}
  
  void draw2(PGraphics canvas) {

//    if (keyPressed) {
//    if (key == 's' || key == 'S') {
//       if(currentSpeed>0)
//       {
//         previousSpeed=currentSpeed;
//          currentSpeed=0;
//       }
//          else
//          currentSpeed=previousSpeed;
//    }
//    else if (key == 'q' || key == 'Q')
//         currentSpeed+=0.2;
//      else if (key == 'e' || key == 'E')
//      {
//         currentSpeed-=0.2;   
//       if(currentSpeed<1)
//            currentSpeed=1;  
//      }
//  }
  
   //background(0);
     
    canvas.camera(width/2, height/2+cameraY, (height/2) / tan(PI/6), width/2, height/2+cameraY, 0, 0, 1, 0);
    
  //  pushMatrix();
 
    for(int i=0;i<eyeNum;i++)
    {
        catEye[i].display();
    }
     for(int i=0;i<boxNum;i++)
     {
       boxes[i].display();
     }
   //  popMatrix();
    cameraY+=currentSpeed;
  //  beginShape();
  //      texture(img);
  //      vertex(-100, -100, 0, 0, 0);
  //      vertex(100, -100, 0, img.width, 0);
  //      vertex(100, 100, 0, img.width, img.height);
  //      vertex(-100, 100, 0, 0, img.height);
  //      endShape();
  }
  
  class Eyes
  {
    PGraphics myCanvas;
     float x,y,z,thetax,thetay,thetaz,size;
     int w, h;
       int eyeID;//0:open, 1:closed
        Eyes(int _w,int _h) {
      w=_w;
      h=_h;
  eyeID=(int)random(eyeBlinkSpeed);
  
  generate();
    
    }
    
     void generate()
    {
     
        x=random(-w/3,w/3)+w/2;
    //y=random(-h/3,h/3)+h/2;
    y=random(0,10*h);
    z=0;
 
    thetax=thetay=thetaz=0;

    thetaz=random(-PI/4,PI/4);
    size=random(0.5,3);
    }
    void display()
    {
      if(y<(cameraY-10))
      {
         y+=h*10+random(h*0.2,h*0.5);
     
      }
         
         if(y<(cameraY-10)||y>(cameraY+h+10))
      return;
      drawEyes(x,y,z,thetax,thetay,thetaz);
    }
         void drawEyes(float x,float y,float z,float thetax,float thetay,float thetaz)
    {
      myCanvas.pushMatrix();
      myCanvas.translate(x, y, z);
      myCanvas.rotateX(thetax);
      myCanvas.rotateY(thetay);
      myCanvas.rotateZ(thetaz);
      //scale(size);
      myCanvas.noStroke();
      
      int w,h;
      w=0;
      h=0;
       myCanvas.beginShape();
       if(eyeID<eyeBlinkSpeed*0.9)
       {
         myCanvas.texture(eyes[0]);
         w=eyes[0].width;
         h=eyes[0].height;
        
       }
        else 
       {
         myCanvas.texture(eyes[1]);
         w=eyes[1].width;
         h=eyes[1].height;
       }
        eyeID=(eyeID+1)%eyeBlinkSpeed;
        
        int sizeH=(int)((float)boxSize*(float)h/((float)w));
        myCanvas.vertex(-boxSize, -sizeH, 0, 0, 0);
        myCanvas.vertex(boxSize, -sizeH, 0, w, 0);
        myCanvas.vertex(boxSize, sizeH, 0, w, h);
        myCanvas.vertex(-boxSize, sizeH, 0, 0, h);
        myCanvas.endShape();
        myCanvas.popMatrix();
    }
  }
  
  
  
  
  
  class object
  {
    PGraphics myCanvas;
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
    
    float tmp=random(3);
    if(tmp>2)
    rotateDirection=1;
    else if(tmp>1)
    rotateDirection=0;
    else
    rotateDirection=-1;
    rotationSpeed=random(PI/800,PI/600);
    life=random(10,30);
    }
    
    void drawBox(float x,float y,float z,float thetax,float thetay,float thetaz,float size,int w,int h)
    {
      myCanvas.pushMatrix();
      myCanvas.translate(x, y, z);
      myCanvas.rotateX(thetax);
      myCanvas.rotateY(thetay);
      myCanvas.rotateZ(thetaz);
      //scale(size);
      myCanvas.noStroke();
       myCanvas.beginShape();
       
        myCanvas.texture(imgs[imageID]);
        myCanvas.vertex(-boxSize, -boxSize, 0, 0, 0);
        myCanvas.vertex(boxSize, -boxSize, 0, w, 0);
        myCanvas.vertex(boxSize, boxSize, 0, w, h);
        myCanvas.vertex(-boxSize, boxSize, 0, 0, h);
        myCanvas.endShape();
        myCanvas.popMatrix();
    }
  
    void display() {

      if(y<(cameraY-10))
           y+=h*10+random(h*0.2,h*0.5);
      if(y<(cameraY-10)||y>(cameraY+h+10))
      return;
     drawBox(x,y,z,thetax,thetay,thetaz,size,pointer.width,pointer.height);
//     if(imageID==0)
//     {
//       drawPointer(x,y,z,thetax,thetay,thetaz,size,imgs[imageID].width,imgs[imageID].height);
//     }
     thetaz=thetaz+rotationSpeed*rotateDirection;
    }
    
    void drawPointer(float x,float y,float z,float thetax,float thetay,float thetaz,float size,int w,int h)
    {
      myCanvas.pushMatrix();
      myCanvas.translate(x, y, z);
      myCanvas.rotateX(thetax);
      myCanvas.rotateY(thetay);
      myCanvas.rotateZ(thetaz+pointRotation);
      //scale(size);
      myCanvas.noStroke();
       myCanvas.beginShape();
       
        myCanvas.texture(pointer);
        myCanvas.vertex(-boxSize, -boxSize, 0, 0, 0);
        myCanvas.vertex(boxSize, -boxSize, 0, w, 0);
        myCanvas.vertex(boxSize, boxSize, 0, w, h);
        myCanvas.vertex(-boxSize, boxSize, 0, 0, h);
        myCanvas.endShape();
        myCanvas.popMatrix();
        pointRotation+=PI/300;
    }
  }
