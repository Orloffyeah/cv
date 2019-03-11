import frames.core.*;
import frames.core.constraint.*;
import frames.primitives.*;
import frames.processing.*;
import frames.timing.*;

PVector lightDir = new PVector();
PShader defaultShader;
PGraphics shadowMap;
int landscape = 1;
Scene scene;
Frame sceneEye;
 
int w = 1000;
int h = 1000;
int speed = 1;

boolean trackSun = false;
 
void setup() {
    size(800, 800, P3D);
    scene = new Scene(this);
    scene.setEye(new Frame());
    scene.setRadius(200);
    scene.fit();
    
    scene.spin(new Point(0,0), new Point(0,-2500));
    
    sceneEye = new Frame(scene);
    sceneEye.setPosition(new Vector(lightDir.x, lightDir.y, lightDir.z));
    
    initShadowPass();
    initDefaultPass();
}
 
void draw() {
 
    // Determinar dirección de la luz
    float lightAngle = frameCount * 0.002;
    lightDir.set(sin(lightAngle) * 160, 160, cos(lightAngle) * 160);
 
    // Renderizar sombras en este instante
    shadowMap.beginDraw();
    shadowMap.camera(lightDir.x, lightDir.y, lightDir.z, 0, 0, 0, 0, 1, 0);
    shadowMap.background(255, 255, 255); // Will set the depth to 1.0 (maximum depth)
    renderLandscape(shadowMap);
    shadowMap.endDraw();
    shadowMap.updatePixels();
    
    // Actualizar la matriz de transformación de las sombras,
    // la dirección de la luz y el shadow map con el shader predeterminado
    updateDefaultShader();
 
    // Renderizar los objetos
    background(34, 34, 34);
    renderLandscape(g);
 
    // Renderizar la luz
    pushMatrix();
    fill(255,255,0);
    translate(lightDir.x, lightDir.y, lightDir.z);
    sphere(5);
    popMatrix();
    
    // Mover la camara dependiendo del modo de vista
    if(trackSun)
    {
      scene.eye().setPosition(new Vector(lightDir.x -50, lightDir.y, lightDir.z));
      scene.fit(sceneEye, 1);
    }
}
 
public void initShadowPass() {
    shadowMap = createGraphics(2048, 2048, P3D);
    // Se usa noSmooth porque el antialiasing hace que se vea raro
    shadowMap.noSmooth();
    shadowMap.beginDraw();
    shadowMap.noStroke();
    PShader initialShader;
    initialShader = loadShader("initShadowMapFragment.glsl", "initShadowMapVertex.glsl");
    shadowMap.shader(initialShader);
    // Crear matriz de vista ortogonal para la fuente de luz
    shadowMap.ortho(-200, 200, -200, 200, 10, 400); 
    shadowMap.endDraw();
}
 
public void initDefaultPass() {
    defaultShader = loadShader("defaultShadowMapFragment.glsl", "defaultShadowMapVertex.glsl");
    shader(defaultShader);
    noStroke();
    perspective(60 * DEG_TO_RAD, (float)width / height, 10, 1000);
}
 
void updateDefaultShader() {
 
    // Matriz "bias" para mover las coordenadas de la sombra al espacio de textura UV
    PMatrix3D shadowTransform = new PMatrix3D(
        0.5, 0.0, 0.0, 0.5, 
        0.0, 0.5, 0.0, 0.5, 
        0.0, 0.0, 0.5, 0.5, 
        0.0, 0.0, 0.0, 1.0
    );
 
    // Aplicar la matriz projmodelview generada al calcular las nuevas sombras
    shadowTransform.apply(((PGraphicsOpenGL)shadowMap).projmodelview);
    
    // Aplicar la matriz inversa a movelview obtenida al crear las sombras predeterminadas, para obtener la posición original de los vértices.
    PMatrix3D modelviewInv = ((PGraphicsOpenGL)g).modelviewInv;
    shadowTransform.apply(modelviewInv);
    
    // Convertir PMatrix a GLMatrix y enviar al shader
    defaultShader.set("shadowTransform", new PMatrix3D(
        shadowTransform.m00, shadowTransform.m10, shadowTransform.m20, shadowTransform.m30, 
        shadowTransform.m01, shadowTransform.m11, shadowTransform.m21, shadowTransform.m31, 
        shadowTransform.m02, shadowTransform.m12, shadowTransform.m22, shadowTransform.m32, 
        shadowTransform.m03, shadowTransform.m13, shadowTransform.m23, shadowTransform.m33
    ));
    
    // Calcular la dirección de la luz (traspuesta de la inversa de modelview)
    float lightNormalX = lightDir.x * modelviewInv.m00 + lightDir.y * modelviewInv.m10 + lightDir.z * modelviewInv.m20;
    float lightNormalY = lightDir.x * modelviewInv.m01 + lightDir.y * modelviewInv.m11 + lightDir.z * modelviewInv.m21;
    float lightNormalZ = lightDir.x * modelviewInv.m02 + lightDir.y * modelviewInv.m12 + lightDir.z * modelviewInv.m22;
    float normalLength = sqrt(lightNormalX * lightNormalX + lightNormalY * lightNormalY + lightNormalZ * lightNormalZ);
    defaultShader.set("lightDirection", lightNormalX / -normalLength, lightNormalY / -normalLength, lightNormalZ / -normalLength);
 
    // Aplicar el shadow mapping en el shader usado
    defaultShader.set("shadowMap", shadowMap);
 
}

void updateAvatar(Frame frame) {
  if (frame != sceneEye) {
    sceneEye = frame;
    if (sceneEye != null)
      thirdPerson();
    else if (scene.eye().reference() != null)
      resetEye();
  }
}

// Sets current avatar as the eye reference and interpolate the eye to it
void thirdPerson() {
  sceneEye.setPosition(new Vector(lightDir.x, lightDir.y, lightDir.z));
  scene.eye().setReference(sceneEye);
  scene.fit(sceneEye, 1);
}

// Resets the eye
void resetEye() {
  // same as: scene.eye().setReference(null);
  scene.eye().resetReference();
  scene.lookAt(scene.center());
  scene.fit(1);
}

public void keyPressed() {
    if(key != CODED) {
        if(key >= '1' && key <= '3')
            landscape = key - '0';
        else if(key == 'd') {
            shadowMap.beginDraw(); shadowMap.ortho(-200, 200, -200, 200, 10, 400); shadowMap.endDraw();
        } else if(key == 's') {
            shadowMap.beginDraw(); shadowMap.perspective(60 * DEG_TO_RAD, 1, 10, 1000); shadowMap.endDraw();
        }
    }
    switch (key) {
      case ' ':
      /*if (scene.eye().reference() != null)
        resetEye();
      else if (sceneEye != null)
        println("Third Person");
        thirdPerson();*/
      trackSun = !trackSun;
      if(!trackSun)
      {
        scene.fit(1);
      }
      break;
      case 'q':
        speed = 1;
      break;
      case 'w':
        speed = 2;
      break;
      case 'e':
        speed = 5;
      break;
    }
}
 
public void renderLandscape(PGraphics canvas) {
    switch(landscape) {
        case 1: {
            float offset = (-frameCount * 0.01) * speed;
            canvas.fill(255, 85, 0);
            for(int z = -5; z < 10; ++z)
                for(int x = -5; x < 10; ++x) {
                    canvas.pushMatrix();
                    canvas.translate(x * 12, sin(offset + x) * 20 + cos(offset + z) * 20, z * 12);
                    canvas.sphere(5);
                    canvas.popMatrix();
                }
        } break;
        case 2: {
            float angle = (-frameCount * 0.0015) * speed, rotation = TWO_PI / 20;
            canvas.fill(255, 85, 0);
            for(int n = 0; n < 20; ++n, angle += rotation) {
                canvas.pushMatrix();
                canvas.translate(sin(angle) * 80, sin(angle * 2) * 50, cos(angle) * 80);
                canvas.sphere(10);
                canvas.popMatrix();
            }
            canvas.fill(0, 85, 255);
            canvas.box(100, 100, 100);
        } break;
        case 3: {
            float angle = (-frameCount * 0.0015) * speed, rotation = TWO_PI / 20;
            canvas.fill(255, 85, 0);
            for(int n = 0; n < 20; ++n, angle += rotation) {
                canvas.pushMatrix();
                canvas.translate(sin(angle) * 70, cos(angle) * 70, -30);
                canvas.box(10, 10, 10);
                canvas.popMatrix();
                
                canvas.pushMatrix();
                canvas.translate(sin(angle) * 100, cos(angle) * -100, 0);
                canvas.box(10, 10, 10);
                canvas.popMatrix();
                
                canvas.pushMatrix();
                canvas.translate(sin(angle) * -70, cos(angle) * -70, 30);
                canvas.box(10, 10, 10);
                canvas.popMatrix();
            }
            canvas.fill(0, 255, 85);
            canvas.sphere(50);
        }
    }
    canvas.fill(34, 34, 34);
    canvas.box(360, 5, 360);
}

void mouseMoved() {
  scene.cast();
}

void mouseDragged() {
  if (mouseButton == LEFT)
    scene.spin();
  else if (mouseButton == RIGHT)
    scene.translate();
  else
    scene.scale(mouseX - pmouseX);
}

void mouseWheel(MouseEvent event) {
  scene.moveForward(event.getCount() * 20);
}
