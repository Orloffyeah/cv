float rect_x = 0;

void setup()
{
  size(1280, 720);
  background(255);
  noStroke();
}

void draw()
{
  drawBackground();
  
  color yellow = color(255,255,0);
  fill(yellow);
  rect(rect_x,300,80,40);
  
  color blue = color(0,0,155);
  fill(blue);
  rect(rect_x,420,80,40);
  
  rect_x += 3;
}

void drawBackground()
{
  background(255);
  fill(0);
  for(int i=0; i<width/20; i++)
  {
    rect(i*40, 0, 20, 720);
  }
  
}
