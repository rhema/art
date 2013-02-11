


int aCount, bCount;
color[] paletteA = new color[12]; // 
color[] paletteB = new color[12]; // Evenly spaced sample of 6 colors across the entire spectrum
color[] colorarray=new color[12];

void setup(){
  //frameRate(2);

  textMode(SCREEN);
  rectMode(CORNERS);
  noStroke();
  size(1200,600);
  colorMode(HSB, 360, 100, 100);
  
  //HSV values 
  //direct color
  colorarray[0]= color(0,0,0);
  colorarray[1]= color(200,1,83);
  //colors of aurora
  colorarray[2]= color(90, 75, 67);
  colorarray[3]=color(73, 58, 55);
  colorarray[4]=color(27, 72, 90);
  //  are kinda pink
  colorarray[5] = color(8, 56, 85);
  colorarray[6] = color(0, 70, 95);
  //northern lights by aguanno
  colorarray[7] = color(247, 55, 25);
  colorarray[8] = color(248, 22, 95);
  colorarray[9] = color(225, 48, 65);
  colorarray[10] = color(163, 29, 95);
  colorarray[11] = color(141, 44, 65);
  
  aCount = 0;
  bCount = 0;
  
  for (int i = 0; i < 12; i++) {           // Define palette A
    paletteA[aCount] = colorarray[i]; 
    aCount = aCount + 1;
  }
  for (int j = 0; j < 12; j++) {             // Define palette B
    paletteB[j] = colorarray[j];
  }
drawPaletteA();
  //drawPaletteB();

}

void drawPaletteA() 
{
 // top bar
  for (int j = 0; j < 12; j++) {
    fill(paletteA[j]);
    rect(j * 6, 0, j * 6 + 6, 200);
  }
  
// fill(colorarray[0]);
 //rect(0, 200, 50, 400);
 
//middle bar
 for (int j = 0; j < 12; j++) {
    fill(colorarray[j]);
    paletteB[j] = colorarray[j];
    rect(j * 100 - 50, 200, j * 100 + 50, 400);
  }
  
//  fill(colorarray[0]);
 // rect(550, 200, 600, 400);
}

void draw() 
{
  for (int j = 0; j < 12; j++) 
  {             // Define palette B
    aCount = j * 2 + bCount; //offset speed
    aCount = aCount - (floor(aCount / 12) *12);
    paletteB[j] = paletteA[aCount];
    //mouseX;
  }

//  fill(paletteB[0]);
//  rect(0, 400, 50, 600);

//offset bar
  for (int j = 0; j < 12; j++) 
  {
    fill(paletteB[j]);
    rect(j * 100 - 50, 400, j * 100 + 50, 600);
  }
  
//  fill(paletteB[0]);
//  rect(550, 400, 600, 600);
  if(bCount > 12) {
    bCount = 0;
  } else {
    bCount = bCount + 1;
  }

}
