import java.awt.Point;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;

//from  https://code.google.com/p/convex-hull/source/browse/Convex+Hull/src/algorithms/FastConvexHull.java?r=4
class FastConvexHull
{
        Vector<PVector> getConvexHullBox(List<PVector> points)
        {
           Vector<PVector> conv = getConvexHull(points);
           Vector<PVector> ret = new Vector<PVector>();
           float max_x = -1000000000;
           float max_y = -1000000000;
           float min_x = 1000000000;
           float min_y = 1000000000;
           for(PVector p:conv)
           {
             max_x = max(max_x,p.x);
             max_y = max(max_y,p.y);
             min_x = min(min_x,p.x);
             min_y = min(min_y,p.y);
           }
           ret.add(new PVector(min_x,max_y));
           ret.add(new PVector(max_x,max_y));
           ret.add(new PVector(max_x,min_y));
           ret.add(new PVector(min_x,min_y));
           return ret;
        }
        
        
        Vector<PVector> getConvexHull(List<PVector> points)
        {
          //convert to Points
          Vector<PVector> ret = new Vector<PVector>();
          ArrayList<Point> converted = new ArrayList<Point>();
          for(PVector p:points)
          {
            Point pp = new Point();
            pp.setLocation(p.x,p.y);
            converted.add(pp);
          }
          
          converted = execute(converted);
          
          for(Point p:converted)
          {
            ret.add(new PVector((float)p.getX(), (float)p.getY()));
          }
          
          return ret;
        }
        
        ArrayList<Point> execute(ArrayList<Point> points) 
        {
                ArrayList<Point> xSorted = (ArrayList<Point>) points.clone();
                Collections.sort(xSorted, new XCompare());
                
                int n = xSorted.size();
                
                Point[] lUpper = new Point[n];
                
                lUpper[0] = xSorted.get(0);
                lUpper[1] = xSorted.get(1);
                
                int lUpperSize = 2;
                
                for (int i = 2; i < n; i++)
                {
                        lUpper[lUpperSize] = xSorted.get(i);
                        lUpperSize++;
                        
                        while (lUpperSize > 2 && !rightTurn(lUpper[lUpperSize - 3], lUpper[lUpperSize - 2], lUpper[lUpperSize - 1]))
                        {
                                // Remove the middle point of the three last
                                lUpper[lUpperSize - 2] = lUpper[lUpperSize - 1];
                                lUpperSize--;
                        }
                }
                
                Point[] lLower = new Point[n];
                
                lLower[0] = xSorted.get(n - 1);
                lLower[1] = xSorted.get(n - 2);
                
                int lLowerSize = 2;
                
                for (int i = n - 3; i >= 0; i--)
                {
                        lLower[lLowerSize] = xSorted.get(i);
                        lLowerSize++;
                        
                        while (lLowerSize > 2 && !rightTurn(lLower[lLowerSize - 3], lLower[lLowerSize - 2], lLower[lLowerSize - 1]))
                        {
                                // Remove the middle point of the three last
                                lLower[lLowerSize - 2] = lLower[lLowerSize - 1];
                                lLowerSize--;
                        }
                }
                
                ArrayList<Point> result = new ArrayList<Point>();
                
                for (int i = 0; i < lUpperSize; i++)
                {
                        result.add(lUpper[i]);
                }
                
                for (int i = 1; i < lLowerSize - 1; i++)
                {
                        result.add(lLower[i]);
                }
                
                return result;
        }
        
        private boolean rightTurn(Point a, Point b, Point c)
        {
                return (b.x - a.x)*(c.y - a.y) - (b.y - a.y)*(c.x - a.x) > 0;
        }

        private class XCompare implements Comparator<Point>
        {
                @Override
                public int compare(Point o1, Point o2) 
                {
                        return (new Integer(o1.x)).compareTo(new Integer(o2.x));
                }
        }
}
