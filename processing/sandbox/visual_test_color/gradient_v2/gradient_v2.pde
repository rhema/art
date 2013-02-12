color[] colorarray=new color[12];

float indirectness = random(0,1);
int colorlookup;
float n = 0;
color newc;
color c1;
color c2;

void setup()
{
  size(800, 600);
  colorMode(HSB, 360, 100, 100);
  
  //HSV values 
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
  
}

void draw()
{
    for(int y = 0; y < height; y++)
    {
    float n = map(y, 0, height, 0, 1); // y has range from 0 to height and
    // n has a range from 0 to 1
      for(int j=0; j< 11; j++)
      {
        c1= colorarray[j];
        c2 = colorarray[j+1];
              newc = lerpColor(c1, c2, n);
        stroke(newc);
      line(0, y, width, y);
      n += 0.01;
      }

    }
}  
  
