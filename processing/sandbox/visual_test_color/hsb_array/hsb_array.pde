int pages = 50;
int p;
int[] hval = new int[pages];
int[] sval = new int[pages];
int[] bval = new int[pages];
int xval;
int yval;

void setup() {
  size(500, 400);


}

void draw()
{
    for(int p = 0; p<pages; p++) {
    hval[p] = int(random(0, 255));
    sval[p] = int(random(0, 255));
    bval[p] = int(random(0, 255));
  } 
  fill (hval[p], sval[p], bval[p]);
  rect(xval, yval, 50, 50);
  xval=xval+1;
  yval=yval+1;
}
