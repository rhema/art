color[] colorarray=new color[22];
color[] myColors= new color[22];
int colorlookup;
float satval;

void setupColors()
{
  float input = random(0,1); 
  colorMode(HSB, 360, 100, 100); //why would you set different maxes?
  colorlookup= int(input*colorarray.length) -1;
  satval = int(input*100);
  
  //HSV values 
  colorarray[0]= color(0, satval, 0); // 0 sat val
  colorarray[1]= color(200, satval, 83); // 1 sat val
  //brownberry
  colorarray[2] = color(233, satval, 32); //40 sat val
  colorarray[3] = color(236, satval, 26); //59
  colorarray[4] = color(47, satval, 53); // 5
  colorarray[5] = color(54, satval, 100); //white 18 sat val
  colorarray[6] = color(32, satval, 32); //gray   52 sat val
  //northern lights by aguanno
  colorarray[7] = color(247, satval, 25); // 55 sat val
  colorarray[8] = color(248, satval, 95); //22 sat val
  colorarray[9] = color(225, satval, 65); // 48 sat val
  colorarray[10] = color(163, satval, 95); // 29 sat val
  colorarray[11] = color(141, satval, 65); // 44 sat val
  //aurora6
  colorarray[12] = color(195, satval, 56); // 61 sat val
  colorarray[13] = color(54, satval, 98); //38 sat val
  colorarray[14] = color(19, satval, 98); // 62 sat val
  colorarray[15] = color(4, satval, 89); //75 sat val
  colorarray[16] = color(209, satval, 20); // 100 sat val
  //psychedelic by nobu
  colorarray[17] = color(354, satval, 100); //100 sat val
  colorarray[18] = color(54, satval, 100); //100 sat val
  colorarray[19] = color(79, satval, 85); //93 sat val
  colorarray[20] = color(204, satval, 100); //100 sat val
  colorarray[21] = color(341, satval, 97); //89 sat val
  

  //if using arraylist use colorarray.size
  
/*RGB values  
  colorarray[0]=color(106, 171, 43, 255);
  colorarray[1]=color(123, 140, 59, 255);
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
  */

}

color getColor(float directness)//arg
{
  //remakeColors(directness);
  //remakeColors(directness);
  
  
    
  return colorarray[(int) random(0, colorlookup)];
    
  //return colorarray[(int)(10.0*random(0,1))];
}


void remakeColors( float input ) 
{
  myColors = new color[ int( map( input, 0, 1, 2, 500 ) ) ];
  for ( int i=0; i<colorarray.length; i++) 
  {
    myColors[i] = colorarray[((int) random(0, colorlookup))];
  }
}
