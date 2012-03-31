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
	public class TBox extends TPolygon
	{

		public function TBox(X:Number, Y:Number, Width:Number = 100, Height:Number = 100, image:Class = null) {
			super(	X,Y,
					new Point(0 - ((Width / 2) - (lineThickness / 2)), 0 - ((Height / 2) - (lineThickness / 2))),
					new Point(0 + ((Width / 2) - (lineThickness / 2)), 0 - ((Height / 2) - (lineThickness / 2))),
					new Point(0 + ((Width / 2) - (lineThickness / 2)), 0 + ((Height / 2) - (lineThickness / 2))),
					new Point(0 - ((Width / 2) - (lineThickness / 2)), 0 + ((Height / 2) - (lineThickness / 2)))
				);
			if (fillImage != null) {
				super.fillImage(image);
			}
		}
	}
	
}