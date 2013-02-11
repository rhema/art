
color[] myColors;
color[] colorarray=new color[10];
//input will be the indirectness value
float input = random(0,1);
int colorlookup;



void setup() 
{
  size(250, 200);
  remakeColors( random(1) );
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

  colorlookup= int(input*colorarray.length);
}

void draw() 
{
  background(0);
  int t=0;
  for ( int y=0;y<height;y+=10) 
  {
    for ( int x=0;x<width;x+=10) 
    {
      if ( t < myColors.length ) 
      {
        fill( myColors[t] );
        rect(x,y,10,10);
        t++;
      }
    }
  }
}

void mouseClicked() {
  remakeColors( random(1) );
}


void remakeColors( float input ) 
{
  myColors = new color[ int( map( input, 0, 1, 2, 500 ) ) ];
  for ( int i=0; i<colorarray.length;i++) 
  {
    myColors[i] = colorarray[(int) random(0, colorlookup)];
  }
}
