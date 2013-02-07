color c1;
color c2;
float n = 0;

void setup()
{
  size(500, 400);
  colorMode(HSB, 100);
  
  c1 = color(random(100), 100, 100); // can put any two colors here
  c2 = color(random(100), 100, 30); // can put any two colors here
  
  for(int y = 0; y < height; y++)
  {
    float n = map(y, 0, height, 0, 1); // y has range from 0 to height and
    // n has a range from 0 to 1
    color newc = lerpColor(c1, c2, n);
    stroke(newc);
    line(0, y, width, y);
    n += 0.01;
  }
}

void draw()
{
}
  
  
