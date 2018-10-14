public class FaceVertex{

    List<Face> faceList;
    List<Vector> vertexList;
    HashMap<Vector, Face[]> neighbors;
    
    public FaceVertex(List<Face> faceList, List<Vector> vertexList, HashMap<Vector, Face[]> neighbor_faces)
    {
      this.faceList = faceList;
      this.vertexList = vertexList;
      this.neighbors = neighbor_faces;
    }
    
    public List<Face> getFaceList()
	  {
      return faceList;
    }

    public void setFaceList(List<Face> faceList)
	  {
      this.faceList = faceList;
    }

    public List<Vector> getVertexList()
	  {
      return vertexList;
    }

    public void setVertexList(List<Vector> vertexList)
	  {
      this.vertexList = vertexList;
    }

    void renderMeshImmediate()
	  {        
  		for(Face face : faceList)
  		{
  			face.renderFaceImmediate();
  		}
  
      faceList = null;
      vertexList = null;
    }
    
    PShape renderMeshRetained()
  	{
  		PShape faceShape = createShape();
  		faceShape.beginShape();
  
  		for(Face face : faceList)
  		{
  			faceShape.vertex(face.v0.x(), face.v0.y(), face.v0.z());
  			faceShape.vertex(face.v1.x(), face.v1.y(), face.v1.z());
  			faceShape.vertex(face.v2.x(), face.v2.y(), face.v2.z());
  		}
  
  		faceShape.endShape();
  		return faceShape;
    }

}
