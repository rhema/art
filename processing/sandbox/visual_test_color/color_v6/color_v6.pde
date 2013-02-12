
// random color loop, did not use a dynamic array

color[] colorarray=new color[12];

float indirectness=random(0,1);
int colorlookup;

void setup()
{
size(640, 480);

colorMode(HSB, 360, 100, 100); 
//HSV values 
//0 and 1 are direct colors
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

/*rgb values 
//black and white
colorarray[0]=color(0, 0, 0);
colorarray[1]=color(209, 211, 212);
//aurora
colorarray[2]=color(106, 171, 43);
colorarray[3]=color(123, 140, 59);
colorarray[4]=color(229, 137, 64);
//are kinda pink
colorarray[5] = color(218, 112, 96);
colorarray[6] = color(242, 73, 73);
//northern lights
colorarray[7] = color(33, 29, 64);
colorarray[8] = color(196, 189, 242);
colorarray[9] = color(86, 106, 166);
colorarray[10] = color(172, 242, 222);
colorarray[11] = color(93, 166, 118);
*/

colorlookup= int(indirectness*colorarray.length);
//colorlookup = indirect*colorarray.size, if we use arraylist()

}

void draw()
{
  //indirectness=mouseX/width;
  for(int i=0; i < colorlookup; i++)
  {
    color currentcolor = colorarray[(int) random(0, colorlookup)];
    fill(currentcolor);

    rect(i*width/colorlookup,i*height/colorlookup,width/colorlookup,height/colorlookup);
      //strokeWeight(random(3, 10));
  //stroke(currentcolor); // HSB Hue Saturation Brightness
  //float rainbow_size = random(200, 270);
  //ellipse(150, 350, rainbow_size, rainbow_size);
  }

} 

