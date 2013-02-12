color[] colorarray=new color[22];
color[] myColors= new color[22];
int colorlookup;


void setupColors()
{
  float input = random(0,1);
  colorMode(HSB, 360, 100, 100); 
  
  //HSV values 
  colorarray[0]= color(0,0,0);
  colorarray[1]= color(200,1,83);
  //brownberry
  colorarray[2] = color(233, 40, 32);
  colorarray[3] = color(236, 59, 26);
  colorarray[4] = color(47, 5, 53);
  colorarray[5] = color(54, 18, 100); //white
  colorarray[6] = color(32, 52, 32); //gray
  //northern lights by aguanno
  colorarray[7] = color(247, 55, 25);
  colorarray[8] = color(248, 22, 95);
  colorarray[9] = color(225, 48, 65);
  colorarray[10] = color(163, 29, 95);
  colorarray[11] = color(141, 44, 65);
  //aurora6
  colorarray[12] = color(195, 61, 56);
  colorarray[13] = color(54, 38, 98);
  colorarray[14] = color(19, 62, 98);
  colorarray[15] = color(4, 75, 89);
  colorarray[16] = color(209, 100, 20);
  //psychedelic by nobu
  colorarray[17] = color(354, 100, 100);
  colorarray[18] = color(54, 100, 100);
  colorarray[19] = color(79, 93, 85);
  colorarray[20] = color(204, 100, 100);
  colorarray[21] = color(341, 89, 97);
  
  colorlookup= int(input*colorarray.length) -1;
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
