class CubicHermite{

  ArrayList<Vector> points;
  float precision;
  
  public CubicHermite(ArrayList<Vector> points, float precision)
  {
    this.points = points;
    this.precision = precision;
  }

  public void draw(){
    int n = points.size();
    
    for(int i = 1 ; i <= n - 3 ; i++)
    {
      Vector m0 = m(i);
      Vector m1 = m(i + 1);

      Vector p0 = points.get(i);
      Vector p1 = points.get(i + 1);

      Vector previousPoint = p0;

      for(float t = 0 ; t < 1 ; t += precision)
      {
        Vector firstHalf = Vector.add (Vector.multiply(p0,h00(t)), Vector.multiply(m0,h10(t)));
        Vector secondHalf = Vector.add (Vector.multiply(p1,h01(t)), Vector.multiply(m1,h11(t)));

        Vector pt = Vector.add( firstHalf, secondHalf );
        vLine( previousPoint, pt );
        previousPoint = pt;
      }

      vLine( previousPoint, p1 );
    }
  }
  
  void vLine(Vector a, Vector b)
  {
    line(a.x(), a.y(), a.z(), b.x(), b.y(), b.z());
  }
  
  private float h00(float t)
  {
    return (1 + 2*t)*(1 - t)*(1 - t);
  }

  private float h10(float t)
  {
    return t*(1 - t)*(1 - t);
  }

  private float h01(float t)
  {
    return t*t*(3 - 2*t);
  }

  private float h11(float t)
  {
    return t*t*(t - 1);
  }

  private Vector m(int k)
  {
    return Vector.multiply(Vector.subtract( points.get(k + 1), points.get(k - 1) ), 0.5);
  }
}
