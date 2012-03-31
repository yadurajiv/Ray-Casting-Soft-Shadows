/**
Copyright (c) 2011 Yadu Rajiv

This software is provided 'as-is', without any express or implied
warranty. In no event will the authors be held liable for any damages
arising from the use of this software.

Permission is granted to anyone to use this software for any purpose,
including commercial applications, and to alter it and redistribute it
freely, subject to the following restrictions:

   1. The origin of this software must not be misrepresented; you must not
   claim that you wrote the original software. If you use this software
   in a product, an acknowledgment in the product documentation would be
   appreciated but is not required.

   2. Altered source versions must be plainly marked as such, and must not be
   misrepresented as being the original software.

   3. This notice may not be removed or altered from any source
   distribution.
 */
   
/**
 * Some parts of this project uses code written by others, where mentioned.
 */

 /**
  * Yadu Rajiv
  * yadurajiv@gmail.com
  * @yadurajiv
  * http://www.chronosign.com
  */

package
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	
	/**
	 * ...
	 * @author Yadu Rajiv
	 */
	public class TCircle extends TPolygon
	{
	
		public function TCircle(X:Number, Y:Number, Segments:Number = 10, Radius:Number = 20, image:Class = null) {
			
			if (Segments < 3)
			Segments = 3;
			
			var m:Number = (Math.PI * 2) / Segments;
			var pts:Array = new Array();
			
			for (var i:uint = 0; i < Segments;i++) {
				pts.push(new Point((Math.sin(m * i)) * Radius, (Math.cos(m * i)) * Radius));
			}

			super(X, Y, pts);
			
			if (image != null) {
				super.fillImage(image);
			}

		}
		
	}
	
}