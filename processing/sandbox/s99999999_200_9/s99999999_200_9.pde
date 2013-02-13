/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/3566*@* */
/* !do not delete the line above, required for linking your tweak if you re-upload */
float t, i, z;
void draw() {
    background(0);
    noStroke();
    t++;
    for (i = 0; ++i < 199;) {
        z = n(0) - t;
        z *= z / 99;
        fill(n(7), n(8), n(9), min(60, sq(400 / z)));
        ellipse(n(2), n(3), z, z);
    }
}
float n(float a) {
    return noise(t / 2000 + a + i) * 512;
}

//make it smother


