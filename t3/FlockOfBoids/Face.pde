public class Face{
  
	Vector v0;
	Vector v1;
	Vector v2;
  

	public Vector getV0()
	{
		return v0;
	}

	public void setV0(Vector v0)
	{
		this.v0 = v0;
	}

	public Vector getV1()
	{
		return v1;
	}

	public void setV1(Vector v1)
	{
		this.v1 = v1;
	}

	public Vector getV2()
	{
		return v2;
	}

	public void setV2(Vector v2)
	{
		this.v2 = v2;
	}

	public Face(Vector v0, Vector v1, Vector v2)
	{
		this.v0 = v0;
		this.v1 = v1;
		this.v2 = v2;
	}

	public void renderFaceImmediate()
	{
		beginShape(TRIANGLES);
		
		vertex(v0.x(),v0.y(),v0.z());
		vertex(v1.x(),v1.y(),v1.z());
		vertex(v2.x(),v2.y(),v2.z());
		
		endShape();
	}
}
