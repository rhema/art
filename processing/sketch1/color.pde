color[] colorarray=new color[10];
color[] myColors= new color[10];
int colorlookup;



void setupColors()
{
  float input = random(0,1);
  colorarray[0]=color(106, 171, 43,255);
  colorarray[1]=color(123, 140, 59);
  colorarray[2]=color(229, 137, 64,255);
  // 3 and 4 are kinda pink
  colorarray[3] = color(218, 112, 96,255);
  colorarray[4] = color(242, 73, 73,255);
  //northern lights
  colorarray[5] = color(33, 29, 64,255);
  colorarray[6] = color(196, 189, 242,255);
  colorarray[7] = color(86, 106, 166,255);
  colorarray[8] = color(172, 242, 222,255);
  colorarray[9] = color(93, 166, 118,255);
  colorlookup= int(input*colorarray.length) -1;
}

color getColor(float directness)//arg
{
  //remakeColors(directness);
  //remakeColors(directness);
  return colorarray[(int)(10.0*random(0,1))];
}


void remakeColors( float input ) 
{
  myColors = new color[ int( map( input, 0, 1, 2, 500 ) ) ];
  for ( int i=0; i<colorarray.length;i++) 
  {
    myColors[i] = colorarray[((int) random(0, colorlookup))];
  }
}
