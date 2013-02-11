

color[] colorarray=new color[12];

float indirectness = random(0,1);
int colorlookup;

void setup()
{
size(640, 480);

//colorMode(HSB); using HSB did not give same colors as kuler
//will have to look into
// for now just using a standard array
//aurora
colorarray[0]=color(106, 171, 43);
colorarray[1]=color(123, 140, 59);
colorarray[2]=color(229, 137, 64);
// 3 and 4 are kinda pink
colorarray[3] = color(218, 112, 96);
colorarray[4] = color(242, 73, 73);
//northern lights
colorarray[5] = color(33, 29, 64);
colorarray[6] = color(196, 189, 242);
colorarray[7] = color(86, 106, 166);
colorarray[8] = color(172, 242, 222);
colorarray[9] = color(93, 166, 118);
//colorarray[10] = color(55, 100, 100);
//colorarray[11] = color(35, 100, 100);

colorlookup= int(indirectness*colorarray.length);
//colorlookup = indirect*colorarray.size, if we use arraylist()

}

void draw()
{
  for(int i=0; i < colorlookup; i++)
  {

    color currentcolor = colorarray[(int) random(0, colorlookup)];
    fill(currentcolor);
  rect(i*width/colorlookup,i*height/colorlookup,width/colorlookup,height/colorlookup);
    

  }

} 

