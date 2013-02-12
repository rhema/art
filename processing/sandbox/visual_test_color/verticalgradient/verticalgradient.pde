PImage grad;
 
void setup() {
  size(640, 240);
  color c1 = color(255, 0, 0);
  color c2 = color(0, 255, 0);
  grad = generateGradient(c1, c2, 500, 200);
}
 
void draw() {
  background(255);
  image(grad, mouseX, mouseY); 
}
 
// Generate a vertical gradient image
PImage generateGradient(color top, color bottom, int w, int h) {
  int tR = (top >> 16) & 0xFF;
  int tG = (top >> 8) & 0xFF;
  int tB = top & 0xFF;
  int bR = (bottom >> 16) & 0xFF;
  int bG = (bottom >> 8) & 0xFF;
  int bB = bottom & 0xFF;
 
  PImage bg = createImage(w,h,RGB);
  bg.loadPixels();
  for(int i=0; i < bg.pixels.length; i++) {
    int y = i/bg.width;
    float n = y/(float)bg.height;
    // for a horizontal gradient:
    // float n = x/(float)bg.width;
    bg.pixels[i] = color(
    lerp(tR,bR,n), 
    lerp(tG,bG,n), 
    lerp(tB,bB,n), 
    255); 
  }
  bg.updatePixels();
  return bg;
}
