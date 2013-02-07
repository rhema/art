color[] palette=new color[10];
palette[0]=color(128,0,0);
palette[1]=color(255,0,0);

// and so on

int[] hval = new int[360];
int count;
int indirectness;

//may want to expand to 2d array int[][]
void setup()
{
  colorMode(HSB);
  
  //need to round up indirectness value and convert to an int
  expand(palette, indirectness);
  println(palette.length);  // Prints length of array
  //but how would we shrink the array?
  //what about arrayList?
}

void draw()
{
  hval[count] =
  
  count++;
  if
