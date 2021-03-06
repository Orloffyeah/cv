/**
 * Flock of Boids
 * by Jean Pierre Charalambos.
 * 
 * This example displays the famous artificial life program "Boids", developed by
 * Craig Reynolds in 1986 [1] and then adapted to Processing by Matt Wetmore in
 * 2010 (https://www.openprocessing.org/sketch/6910#), in 'third person' eye mode.
 * Boids under the mouse will be colored blue. If you click on a boid it will be
 * selected as the scene avatar for the eye to follow it.
 * 
 * 1. Reynolds, C. W. Flocks, Herds and Schools: A Distributed Behavioral Model. 87.
 * http://www.cs.toronto.edu/~dt/siggraph97-course/cwr87/
 * 2. Check also this nice presentation about the paper:
 * https://pdfs.semanticscholar.org/73b1/5c60672971c44ef6304a39af19dc963cd0af.pdf
 * 3. Google for more...
 *
 * Press ' ' to switch between the different eye modes.
 * Press 'a' to toggle (start/stop) animation.
 * Press 'p' to print the current frame rate.
 * Press 'm' to change the boid visual mode.
 * Press 'v' to toggle boids' wall skipping.
 * Press 's' to call scene.fitBallInterpolation().
 */

import frames.primitives.*;
import frames.core.*;
import frames.processing.*;
import java.util.List;

Scene scene;

// Curves Rendering
Interpolator curve;
float precision = 0.01;
ArrayList<Frame> ctrlBoids = new ArrayList<Frame>();
ArrayList<Vector> points = new ArrayList<Vector>();
ArrayList<Vector> cubicBPoints = new ArrayList<Vector>(); // Reduced Array for Cubic Bezier
CubicHermite hermite;
Bezier bezier7;
Bezier bezier3;

//flock bounding box
int flockWidth = 1280;
int flockHeight = 720;
int flockDepth = 600;
boolean avoidWalls = true;

int representationMode = 0;  // 0 -> Vertex-Vertex, 1 -> Face-Vertex

int renderMode = 0;  // 0 -> Immediate, 1 -> Retained

int initBoidNum = 900; // amount of boids to start the program with
ArrayList<Boid> flock;
Frame avatar;
boolean animate = true;

void setup() {
  size(1000, 800, P3D);
  scene = new Scene(this);
  scene.setBoundingBox(new Vector(0, 0, 0), new Vector(flockWidth, flockHeight, flockDepth));
  scene.setAnchor(scene.center());
  scene.setFieldOfView(PI / 3);
  scene.fitBall();
  curve = new Interpolator(scene);
  // create and fill the list of boids
  flock = new ArrayList();
  for (int i = 0; i < initBoidNum; i++)
	  flock.add(new Boid(new Vector(flockWidth / 2, flockHeight / 2, flockDepth / 2), representationMode, renderMode));
  getControlPoints();
  //hermite = new CubicHermite(points, 0.01);
}

void draw() {
  background(10,50,25);
  ambientLight(128, 128, 128);
  directionalLight(255, 255, 255, 0, 1, -100);
  walls();
  scene.traverse();
  stroke(255, 0, 0);
  updateControlPoints();
  hermite = new CubicHermite(points, precision);
  hermite.draw();
  stroke(255,165,0);
  bezier7 = new Bezier(points, precision);
  bezier7.draw();
  stroke(0,255,255);
  bezier3 = new Bezier(cubicBPoints, precision);
  bezier3.draw();
  //scene.drawPath(curve);
  // uncomment to asynchronously update boid avatar. See mouseClicked()
  // updateAvatar(scene.trackedFrame("mouseClicked"));
}

void walls() {
  pushStyle();
  noFill();
  stroke(255, 255, 0);

  line(0, 0, 0, 0, flockHeight, 0);
  line(0, 0, flockDepth, 0, flockHeight, flockDepth);
  line(0, 0, 0, flockWidth, 0, 0);
  line(0, 0, flockDepth, flockWidth, 0, flockDepth);

  line(flockWidth, 0, 0, flockWidth, flockHeight, 0);
  line(flockWidth, 0, flockDepth, flockWidth, flockHeight, flockDepth);
  line(0, flockHeight, 0, flockWidth, flockHeight, 0);
  line(0, flockHeight, flockDepth, flockWidth, flockHeight, flockDepth);

  line(0, 0, 0, 0, 0, flockDepth);
  line(0, flockHeight, 0, 0, flockHeight, flockDepth);
  line(flockWidth, 0, 0, flockWidth, 0, flockDepth);
  line(flockWidth, flockHeight, 0, flockWidth, flockHeight, flockDepth);
  popStyle();
}

void updateAvatar(Frame frame) {
  if (frame != avatar) {
    avatar = frame;
    if (avatar != null)
      thirdPerson();
    else if (scene.eye().reference() != null)
      resetEye();
  }
}

// Sets current avatar as the eye reference and interpolate the eye to it
void thirdPerson() {
  scene.eye().setReference(avatar);
  scene.interpolateTo(avatar);
}

// Resets the eye
void resetEye() {
  // same as: scene.eye().setReference(null);
  scene.eye().resetReference();
  scene.lookAt(scene.center());
  scene.fitBallInterpolation();
}

// picks up a boid avatar, may be null
void mouseClicked() {
  // two options to update the boid avatar:
  // 1. Synchronously
  updateAvatar(scene.track("mouseClicked", mouseX, mouseY));
  // which is the same as these two lines:
  // scene.track("mouseClicked", mouseX, mouseY);
  // updateAvatar(scene.trackedFrame("mouseClicked"));
  // 2. Asynchronously
  // which requires updateAvatar(scene.trackedFrame("mouseClicked")) to be called within draw()
  // scene.cast("mouseClicked", mouseX, mouseY);
}

// 'first-person' interaction
void mouseDragged() {
  if (scene.eye().reference() == null)
    if (mouseButton == LEFT)
      // same as: scene.spin(scene.eye());
      scene.spin();
    else if (mouseButton == RIGHT)
      // same as: scene.translate(scene.eye());
      scene.translate();
    else
      // same as: scene.zoom(mouseX - pmouseX, scene.eye());
      scene.zoom(mouseX - pmouseX);
}

// highlighting and 'third-person' interaction
void mouseMoved(MouseEvent event) {
  // 1. highlighting
  scene.cast("mouseMoved", mouseX, mouseY);
  // 2. third-person interaction
  if (scene.eye().reference() != null)
    // press shift to move the mouse without looking around
    if (!event.isShiftDown())
      scene.lookAround();
}

void mouseWheel(MouseEvent event) {
  // same as: scene.scale(event.getCount() * 20, scene.eye());
  scene.scale(event.getCount() * 20);
}

void getControlPoints()
{
  for(int i=0; i<8; i++)
  {
    int randomPoint = int(random(0, flock.size()));
    Frame randomBoid = flock.get(randomPoint).frame;
    ctrlBoids.add(randomBoid);
    points.add(randomBoid.position());
    //curve.addKeyFrame(randomBoid);
    if(i == 0 || i == 3 || i == 4 || i == 7)
    {
      cubicBPoints.add(ctrlBoids.get(i).position());
    }
  }
}

void updateControlPoints()
{
  for(int i=0; i<8; i++)
  {
    points.set(i, ctrlBoids.get(i).position());
    //curve.addKeyFrame(randomBoid);
    switch(i)
    {
      case 0:
        cubicBPoints.set(0, ctrlBoids.get(i).position());
        break;
      case 3:
        cubicBPoints.set(1, ctrlBoids.get(i).position());
        break;
      case 4:
        cubicBPoints.set(2, ctrlBoids.get(i).position());
        break;
      case 7:
        cubicBPoints.set(3, ctrlBoids.get(i).position());
        break;
    }
  }
}

void keyPressed() {
  switch (key) {
  case 'a':
    animate = !animate;
    break;
  case 's':
    if (scene.eye().reference() == null)
      scene.fitBallInterpolation();
    break;
  case 't':
    scene.shiftTimers();
    break;
  case 'p':
    println("Frame rate: " + frameRate);
    break;
  case 'v':
    avoidWalls = !avoidWalls;
    break;
  case ' ':
    if (scene.eye().reference() != null)
      resetEye();
    else if (avatar != null)
      thirdPerson();
    break;
  }
}
