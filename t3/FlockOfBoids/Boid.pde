class Boid{
  Frame frame;
  // fields
  Vector position, velocity, acceleration, alignment, cohesion, separation;
  // a vector datatype
  float neighborhoodRadius; // radius in which it looks for fellow boids
  float maxSpeed = 4; // maximum magnitude for the velocity vector
  float maxSteerForce = .1f; // maximum magnitude of the steering vector
  float sc = 4; // scale factor for the render of the boid
  float flap = 0;
  float t = 0;
  
  int representationMode;
  int renderMode;
  
  List<Face> faceList = new ArrayList<Face>(); // Face-Vertex Faces List
  List<Vector> vertexList = new ArrayList<Vector>(); // Face-Vertex Vertices List
  
  Face f0, f1, f2, f3;		// Boid faces
  Vector v0, v1, v2, v3;	// Boid vertices
  
  VertexVertex vertexVertexMesh;
  FaceVertex faceVertexMesh;
  PShape shapeBoid;

  Boid(Vector inPos, int repMode, int renMode) {
    
    representationMode = repMode;
    renderMode = renMode;
    
    position = new Vector();
    position.set(inPos);
    frame = new Frame(scene) {
      // Note that within visit() geometry is defined at the
      // frame local coordinate system.
      @Override
      public void visit() {
        if (animate)
          run(flock);
        // Comment render() to only see the splines
        render();
      }
    };
    frame.setPosition(position);
    velocity = new Vector(random(-1, 1), random(-1, 1), random(1, -1));
    acceleration = new Vector();
    neighborhoodRadius = 100;
  }

  public void run(ArrayList<Boid> bl) {
    t += .1;
    flap = 10 * sin(t);
    // acceleration.add(steer(new Vector(mouseX,mouseY,300),true));
    // acceleration.add(new Vector(0,.05,0));
    if (avoidWalls) {
      acceleration.add(Vector.multiply(avoid(new Vector(position.x(), flockHeight, position.z())), 5));
      acceleration.add(Vector.multiply(avoid(new Vector(position.x(), 0, position.z())), 5));
      acceleration.add(Vector.multiply(avoid(new Vector(flockWidth, position.y(), position.z())), 5));
      acceleration.add(Vector.multiply(avoid(new Vector(0, position.y(), position.z())), 5));
      acceleration.add(Vector.multiply(avoid(new Vector(position.x(), position.y(), 0)), 5));
      acceleration.add(Vector.multiply(avoid(new Vector(position.x(), position.y(), flockDepth)), 5));
    }
    flock(bl);
    move();
    checkBounds();
  }

  Vector avoid(Vector target) {
    Vector steer = new Vector(); // creates vector for steering
    steer.set(Vector.subtract(position, target)); // steering vector points away from
    steer.multiply(1 / sq(Vector.distance(position, target)));
    return steer;
  }

  //-----------behaviors---------------

  void flock(ArrayList<Boid> boids) {
    //alignment
    alignment = new Vector(0, 0, 0);
    int alignmentCount = 0;
    //cohesion
    Vector posSum = new Vector();
    int cohesionCount = 0;
    //separation
    separation = new Vector(0, 0, 0);
    Vector repulse;
    for (int i = 0; i < boids.size(); i++) {
      Boid boid = boids.get(i);
      //alignment
      float distance = Vector.distance(position, boid.position);
      if (distance > 0 && distance <= neighborhoodRadius) {
        alignment.add(boid.velocity);
        alignmentCount++;
      }
      //cohesion
      float dist = dist(position.x(), position.y(), boid.position.x(), boid.position.y());
      if (dist > 0 && dist <= neighborhoodRadius) {
        posSum.add(boid.position);
        cohesionCount++;
      }
      //separation
      if (distance > 0 && distance <= neighborhoodRadius) {
        repulse = Vector.subtract(position, boid.position);
        repulse.normalize();
        repulse.divide(distance);
        separation.add(repulse);
      }
    }
    //alignment
    if (alignmentCount > 0) {
      alignment.divide((float) alignmentCount);
      alignment.limit(maxSteerForce);
    }
    //cohesion
    if (cohesionCount > 0)
      posSum.divide((float) cohesionCount);
    cohesion = Vector.subtract(posSum, position);
    cohesion.limit(maxSteerForce);

    acceleration.add(Vector.multiply(alignment, 1));
    acceleration.add(Vector.multiply(cohesion, 3));
    acceleration.add(Vector.multiply(separation, 1));
  }

  void move() {
    velocity.add(acceleration); // add acceleration to velocity
    velocity.limit(maxSpeed); // make sure the velocity vector magnitude does not
    // exceed maxSpeed
    position.add(velocity); // add velocity to position
    frame.setPosition(position);
    frame.setRotation(Quaternion.multiply(new Quaternion(new Vector(0, 1, 0), atan2(-velocity.z(), velocity.x())),
      new Quaternion(new Vector(0, 0, 1), asin(velocity.y() / velocity.magnitude()))));
    acceleration.multiply(0); // reset acceleration
  }

  void checkBounds() {
    if (position.x() > flockWidth)
      position.setX(0);
    if (position.x() < 0)
      position.setX(flockWidth);
    if (position.y() > flockHeight)
      position.setY(0);
    if (position.y() < 0)
      position.setY(flockHeight);
    if (position.z() > flockDepth)
      position.setZ(0);
    if (position.z() < 0)
      position.setZ(flockDepth);
  }

  void render() {
    pushStyle();
	
    // uncomment to draw boid axes
    //scene.drawAxes(10);

    strokeWeight(2);
    stroke(color(40, 255, 40));
    fill(color(0, 255, 0, 125));
	
    // highlight boids under the mouse
    if (scene.trackedFrame("mouseMoved") == frame) {
      stroke(color(0, 0, 255));
      fill(color(0, 0, 255));
    }

    // highlight avatar
    if (frame ==  avatar) {
      stroke(color(255, 0, 0));
      fill(color(255, 0, 0));
    }

    initializeMeshValues();
    createMeshAndRender();
    setNullUnnecesaryReferences();
	
	  if (renderMode == 1)
	  {
      display();
    }
	
	  popStyle();
  }

	public void createMeshAndRender()
	{
		if(representationMode == 0)
		{
			HashMap <Integer, Integer[]> neighbors_list = new HashMap<Integer, Integer[]>();
			neighbors_list.put(0, new Integer[]{1, 2, 3});
			neighbors_list.put(1, new Integer[]{0, 2, 3});
			neighbors_list.put(2, new Integer[]{0, 1, 3});
			neighbors_list.put(3, new Integer[]{0, 1, 2});

			VertexVertex vertexVertexMesh = new VertexVertex(vertexList, neighbors_list);

			if(this.renderMode == 0)
			{
				vertexVertexMesh.renderMeshImmediate();
				vertexVertexMesh = null;
			}
			else
			{
				this.shapeBoid = vertexVertexMesh.renderMeshRetained();
			}
		}
		else if(representationMode == 1)
		{
			HashMap <Vector, Face[]> neighbor_faces = new HashMap<Vector, Face[]>();
			neighbor_faces.put(vertexList.get(0), new Face[]{f1, f2, f3});
			neighbor_faces.put(vertexList.get(1), new Face[]{f0, f2, f3});
			neighbor_faces.put(vertexList.get(2), new Face[]{f0, f1, f3});
			neighbor_faces.put(vertexList.get(3), new Face[]{f0, f1, f2});            
			
			faceVertexMesh = new FaceVertex(faceList, vertexList, neighbor_faces);        
			if(this.renderMode == 1){
				this.shapeBoid = faceVertexMesh.renderMeshRetained();          
			}
			else
			{
				faceVertexMesh.renderMeshImmediate();
				faceVertexMesh = null;
			}  
		}    
	}

	void display()
	{
	  shape(shapeBoid);
	}
	
	void setListsToNull()
	{
		faceList = null;
		vertexList = null;
	}
	
	void setFacesToNull()
	{
		f0 = null;
		f1 = null;
		f2 = null;
		f3 = null;
	}

	void setVertexToNull()
	{
		v0 = null;
		v1 = null;
		v2 = null;
		v3 = null;
	}
	
	void setNullUnnecesaryReferences()
	{
		setFacesToNull();
		setVertexToNull();
	}

	void initializeMeshValues()
	{
		v0 = new Vector(3 * sc, 0, 0);
		v1 = new Vector(-3 * sc, 2 * sc, 0);
		v2 = new Vector(-3 * sc, -2 * sc, 0);
		v3 = new Vector(-3 * sc, 0, 2 * sc);
		addVertexesToList();

		f0 = new Face(v0, v1, v2);
		f1 = new Face(v0, v1, v3);
		f2 = new Face(v0, v3, v2);
		f3 = new Face(v3, v1, v2);
		addFacesToList();
	}

	void addFacesToList()
	{
		faceList.add(f0);
		faceList.add(f1);
		faceList.add(f2);
		faceList.add(f3);
	}

	void addVertexesToList()
	{
		vertexList.add(v0);
		vertexList.add(v1);
		vertexList.add(v2);
		vertexList.add(v3);
	}
}
