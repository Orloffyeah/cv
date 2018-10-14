class Bezier{
  
  ArrayList<Vector> points;
  float precision;

  public Bezier(ArrayList<Vector> points, float precision)
  {
    this.points = points;
    this.precision = precision;
  }

  public void draw()
  {
    Vector a = points.get(0);
    Vector b = null;
    
    for(float i = precision; i <= 1; i += precision)
    {
      b = bezier(i);
      vLine(a, b);
      a = b;
    }
  }

  private Vector bezier(final float t)
  {
    int n = points.size();
    
    Vector ans = new Vector(0, 0, 0);
    
    for(int i = 0; i < n; i++)
    {
      ans.add(Vector.multiply(points.get(i), bernsteinPolinomial(n-1,i,t)));
    }
    
    return ans;
  }
  
  void vLine(Vector a, Vector b)
  {
    line(a.x(), a.y(), a.z(), b.x(), b.y(), b.z());
  }
  
  private float bernsteinPolinomial(final int n, final int i, final float t)
  {
    return binomial(n,i) * pow(t, i) * pow(1-t, n-i);
  }

  private int binomial(final int n, final int k)
  {
    int num = 1, den = 1;
    
    for(int i = n; i > k; i--)
    {
      num*=i;
    }
      
    for(int i = 1; i <= (n-k); i++ )
    {
      den *= i;
    }
    
    return num/den;
  }
}
