/**
 * Functions to determine whether or not a polygon (2D) has its vertices ordered
 * clockwise or counterclockwise and also for testing whether a polygon is convex 
 * or concave
 * 
 * This code is a very quick port of the C functions written by Paul Bourke 
 * found here - http://debian.fmi.uni-sofia.bg/~sergei/cgsr/docs/clockwise.htm
 * 
 * ported to actionscript by @yadurajiv
 * http://chronosign.com/rant
 */

package 
{
	public class Bourke
	{
		
		public static const CLOCKWISE:int = 1;
		public static const COUNTERCLOCKWISE:int = -1;
		
		public static const CONCAVE:int = -1;
		public static const CONVEX:int = 1;
		
		/*
		   Return the clockwise status of a curve, clockwise or counterclockwise
		   n vertices making up curve p
		   return 0 for incomputables eg: colinear points
				  CLOCKWISE == 1
				  COUNTERCLOCKWISE == -1
		   It is assumed that
		   - the polygon is closed
		   - the last point is not repeated.
		   - the polygon is simple (does not intersect itself or have holes)
		*/
		
		public static function ClockWise(p:Array):int {
		   var i:int;
		   var j:int;
		   var k:int;
		   var count:int = 0;
		   
		   var z:Number;
		   
		   var n:int = p.length;

		   if (n < 3)
			  return(0);

		   for (i=0;i<n;i++) {
			  j = (i + 1) % n;
			  k = (i + 2) % n;
			  z  = (p[j].x - p[i].x) * (p[k].y - p[j].y);
			  z -= (p[j].y - p[i].y) * (p[k].x - p[j].x);
			  if (z < 0)
				 count--;
			  else if (z > 0)
				 count++;
		   }
		   if (count > 0)
			  return(COUNTERCLOCKWISE);
		   else if (count < 0)
			  return(CLOCKWISE);
		   else
			  return(0);
		}
		
		/*
		   Return whether a polygon in 2D is concave or convex
		   return 0 for incomputables eg: colinear points
				  CONVEX == 1
				  CONCAVE == -1
		   It is assumed that the polygon is simple
		   (does not intersect itself or have holes)
		*/
		   
		public static function Convex(p:Array):int	{
		   var i:int;
		   var j:int;
		   var k:int;
		   var flag:int = 0;
		   var z:Number;

		   var n:int = p.length;
		   
		   if (n < 3)
			  return(0);

		   for (i=0;i<n;i++) {
			  j = (i + 1) % n;
			  k = (i + 2) % n;
			  z  = (p[j].x - p[i].x) * (p[k].y - p[j].y);
			  z -= (p[j].y - p[i].y) * (p[k].x - p[j].x);
			  if (z < 0)
				 flag |= 1;
			  else if (z > 0)
				 flag |= 2;
			  if (flag == 3)
				 return(CONCAVE);
		   }
		   if (flag != 0)
			  return(CONVEX);
		   else
			  return(0);
		}


	}
	
}