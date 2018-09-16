PShape bean;
float size_x, size_y;
int spacing_x, spacing_y;

void setup()
{
  size(1000, 500);
  color green = color(#548900);
  background(green);
  noStroke();
  
  size_x = 50*0.7;
  size_y = 30*0.7;
  
  spacing_x=30;
  spacing_y = 50;
  
  bean = createShape(GROUP);
  
  PShape black = createShape(ARC,0, 0, size_x, size_y, 0, PI);
  black.setFill(0);
  
  PShape white = createShape(ARC,0, 0, size_x, size_y, PI, TWO_PI);
  white.setFill(255);
  
  PShape brown = createShape(ELLIPSE,0, 0, size_x-5, size_y-5);
  brown.setFill(color(97,41,0));
  
  stroke(0);
  PShape line = createShape(LINE,0-(size_x/2), 0, 0+(size_x/2), 0);
  line.setFill(0);
  line.setStroke(0);
  
  bean.addChild(black);
  bean.addChild(white);
  bean.addChild(brown);
  bean.addChild(line);
}

void draw()
{
  float posx = 50, posy, last_posx, last_posy;
  int counter;
  // Izquierda
  posy = 80;
  counter = 0;
  
  for(int i=7; i>=1; i--)
  {
    for(int j=0; j<i; j++){
      posx = 50+(counter*spacing_x);
      pushMatrix();
      translate(posx,posy+(j*spacing_y));
      rotate(-(PI/2));
      shape(bean,0,0);
      popMatrix();
    }
    posy += size_x/2 + spacing_y/6;
    counter += 1;
  }
  
  // Derecha
  last_posx = posx + size_x + 20;
  last_posy = posy;
  
  posy = last_posy - size_x/2 - spacing_y/6;
  counter = 0;
  
  for(int i=1; i<=7; i++)
  {
    for(int j=0; j<i; j++){
      posx = last_posx+(counter*spacing_x);
      pushMatrix();
      translate(posx,posy+(j*spacing_y));
      rotate(PI/2);
      shape(bean,0,0);
      popMatrix();
    }
    posy -= size_x/2 + spacing_y/6;
    counter += 1;
  }
  
  // Arriba  
  posx = 105;
  counter = 0;
  
  for(int i=7; i>=1; i--)
  {
    for(int j=0; j<i; j++){
      posy = 20+(counter*spacing_x);
      pushMatrix();
      translate(posx+(j*spacing_y),posy);
      rotate(0);
      shape(bean,0,0);
      popMatrix();
    }
    posx += size_x/2 + spacing_y/6;
    counter += 1;
  }
  
  // Abajo
  last_posx = posx;
  last_posy = posy + size_x + 30;
  
  posx = last_posx - size_x/2 - spacing_y/6;
  counter = 0;
  
  for(int i=1; i<=7; i++)
  {
    for(int j=0; j<i; j++){
      posy = last_posy+(counter*spacing_x);
      pushMatrix();
      translate(posx+(j*spacing_y),posy);
      rotate(0);
      shape(bean,0,0);
      popMatrix();
    }
    posx -= size_x/2 + spacing_y/6;
    counter += 1;
  }
  
  // Segundo "Cuadrado"
  
  // Izquierda
  posx = 525;
  posy = 80;
  counter = 0;
  
  for(int i=7; i>=1; i--)
  {
    for(int j=0; j<i; j++){
      posx = 525+(counter*spacing_x);
      pushMatrix();
      translate(posx,posy+(j*spacing_y));
      rotate(-(PI/2));
      shape(bean,0,0);
      popMatrix();
    }
    posy += size_x/2 + spacing_y/6;
    counter += 1;
  }
  
  // Derecha
  last_posx = posx + size_x + 20;
  last_posy = posy;
  
  posy = last_posy - size_x/2 - spacing_y/6;
  counter = 0;
  
  for(int i=1; i<=7; i++)
  {
    for(int j=0; j<i; j++){
      posx = last_posx+(counter*spacing_x);
      pushMatrix();
      translate(posx,posy+(j*spacing_y));
      rotate(PI/2);
      shape(bean,0,0);
      popMatrix();
    }
    posy -= size_x/2 + spacing_y/6;
    counter += 1;
  }
  
  // Arriba  
  posx = 580;
  counter = 0;
  
  for(int i=7; i>=1; i--)
  {
    for(int j=0; j<i; j++){
      posy = 20+(counter*spacing_x);
      pushMatrix();
      translate(posx+(j*spacing_y),posy);
      rotate(0);
      shape(bean,0,0);
      popMatrix();
    }
    posx += size_x/2 + spacing_y/6;
    counter += 1;
  }
  
  // Abajo
  last_posx = posx;
  last_posy = posy + size_x + 30;
  
  posx = last_posx - size_x/2 - spacing_y/6;
  counter = 0;
  
  for(int i=1; i<=7; i++)
  {
    for(int j=0; j<i; j++){
      posy = last_posy+(counter*spacing_x);
      pushMatrix();
      translate(posx+(j*spacing_y),posy);
      rotate(0);
      shape(bean,0,0);
      popMatrix();
    }
    posx -= size_x/2 + spacing_y/6;
    counter += 1;
  }
}
