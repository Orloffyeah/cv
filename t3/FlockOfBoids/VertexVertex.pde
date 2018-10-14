public class VertexVertex{
    
    HashMap<Integer, Integer[]> neighbors;
    List<Vector> vertexList;
    PShape vertexShape = createShape();

    public VertexVertex(List<Vector> vertexList, HashMap<Integer, Integer[]> neighbors)
	  {
      this.vertexList = vertexList;
      this.neighbors = neighbors;
    }

    void renderMeshImmediate()
	  {
  		for(int currentVertex : neighbors.keySet())
  		{
        Integer[] currentNeighbors = neighbors.entrySet().iterator().next().getValue();
        
        for(int neighbors: currentNeighbors)
  			{
          line(vertexList.get(currentVertex).x(), vertexList.get(currentVertex).y(), vertexList.get(currentVertex).z(),
               vertexList.get(neighbors).x(),vertexList.get(neighbors).y(),vertexList.get(neighbors).z());
        }
      }
    }
    
    
  PShape renderMeshRetained()
	{
		vertexShape.beginShape(TRIANGLE);

		for(int currentVertex: neighbors.keySet())
		{
      Integer[] currentNeighbors = neighbors.entrySet().iterator().next().getValue();
      
      for(int neighbors: currentNeighbors)
			{
        vertexShape.vertex(vertexList.get(currentVertex).x(), vertexList.get(currentVertex).y(), vertexList.get(currentVertex).z());
        vertexShape.vertex(vertexList.get(neighbors).x(),vertexList.get(neighbors).y(),vertexList.get(neighbors).z());
      }
    }
    
    vertexShape.endShape();        
    return vertexShape;
  }
}
