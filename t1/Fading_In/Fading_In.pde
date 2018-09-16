int size;
color blue = color(197, 224, 251);

void setup()
{
    size(400, 400);
    background(255);
    noFill();
    noLoop();
    
    size = 350;
}

void draw()
{  
  float alpha = 200;
  for(int i=0; i<=100; i++)
  {
    stroke(blue, alpha);
    ellipse(200,200,size-i*2,size-i*2);
    alpha -= 20;
  }
  
  alpha = 200;
  for(int i=0; i<=10; i++)
  {
    stroke(blue, alpha);
    ellipse(200, 200, size+i*2,size+i*2);
    alpha -= 20;
  }
  
  fill(255,0,0);
  ellipse(200,200,5,5);
}
