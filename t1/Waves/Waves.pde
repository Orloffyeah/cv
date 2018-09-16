int xspacing = 16; 
int w;

float theta = 0.0;
float amplitude = 75.0;
float period = 500.0;
float dx;
float[] yvalues;

void setup() {
  size(640, 360);
  w = width+16;
  dx = (TWO_PI / period) * xspacing;
  yvalues = new float[w/xspacing];
}

void draw() {
  background(0);
  calcWave();
  renderWave();
}

void calcWave() {
  theta += 0.02;

  float x = theta;
  for (int i = 0; i < yvalues.length; i++) {
    yvalues[i] = sin(x*2)*amplitude;
    x+=dx;
  }
}

void renderWave() {
  noStroke();
  fill(255);
  for (int x = 0; x < yvalues.length; x++) {
    ellipse(x*xspacing, height/2+yvalues[x], 16+(abs(yvalues[x]))/50, 16);
  }
}