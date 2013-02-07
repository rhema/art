
//using Huse, saturation, and brightness since this will give
//better values than RGB
// leaving Saturation and brightness constant for now




//

  int[] hval;
int i;
int sval=100;
int bval=100;
int xval=0;
int yval=0;
int j;

void setup()
{
 colorMode(HSB);
  size(360, 360);
  hval = new int[width];
  //setting hvalues in the array, leaving Saturation and brightness constant
  // for now
  for (int i= 0; i < 360; i++)
  {
    hval[i] = i; 
      }
}

void draw()
{

      for (int j = 0; j < hval.length; j++);
      {
 //HSB maximizing saturation and brightness
  // only thing changing is the hue
      fill (hval[j], sval, bval);
      rect(j, j, 50, 50);
      j=j+1;     
    }


}
    
  
  
