int interval = 1000;
int lastTime;
boolean circles;

void setup()
{
  size(720, 720);
  background(204);
  noStroke();
  lastTime = millis();
  circles = true;
}

void draw()
{
  background(204);
  line(360,335,360,385);
  line(335,360,385,360);
  if(circles)
  {
    drawColored();
  }
  else
  {
    drawEdges();
  }
  getTime();
}

void drawColored()
{
  noStroke();
  // Rojo, Morado, Azul, Verde
  color[] colors = {#E1A5AD, #B49CB8, #80C3B9, #9ACE48};
  int[] posX = {200,520,200,520};
  int[] posY = {200,200,520,520};
  
  for(int i=0; i<4; i++)
  {
    int x = posX[i];
    int y = posY[i];
    int size = 250;
    int reduction = 50;
    
    for(int j=0; j<4; j++)
    {
      fill(colors[j]);
      ellipse(x, y, size, size);
      size -= reduction;
    }
  }
  
  stroke(0);
}

void drawEdges()
{
  noFill();
  stroke(0);
  ellipse(200,200,150,150);
  ellipse(520,200,200,200);
  ellipse(200,520,100,100);
  ellipse(520,520,250,250);
}

void getTime()
{
  if (millis() - lastTime >= interval) // Time to display next image
  {
    lastTime = millis();
    circles = !circles;
  }
}
