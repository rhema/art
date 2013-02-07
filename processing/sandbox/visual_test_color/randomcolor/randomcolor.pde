void setup()
{
  size(640, 480);
  colorMode(HSB);
}

void draw()
{
  strokeWeight(random(3,10));
  stroke(random(255), 255, 255); //HSB maximizing saturation and brightness
  // only thing changing is the hue
  float rainbow_size =random(200,270);
  ellipse(150, 350, rainbow_size, rainbow_size);
}
