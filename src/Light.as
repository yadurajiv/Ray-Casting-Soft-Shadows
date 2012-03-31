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
	
	/**
	 * ...
	 * @author Yadu Rajiv
	 */
	public class Light extends TPolygon 
	{
		public var color:Number;
		public var range:Number;
		public var falloff:Number;
		
		public function Light(X:Number, Y:Number, Color:uint = 0xFAEFB5, Range:Number = 150, Falloff:Number = 0, Radius:Number = 6) {
			x = X;
			y = Y;
			color = Color;
			range = Range;
			falloff = Falloff;
			radius = Radius;
			
			name = "light";
			
			super(X, Y, null);
		}
		
	}
	
}