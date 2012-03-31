package
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	
	/**
	 * ...
	 * @author Yadu Rajiv
	 */
	public class TEqTriangle extends TPolygon
	{
		public function TEqTriangle(X:Number, Y:Number, Width:Number, Height:Number, image:Class = null) {
			
			var w:Number = ((Width / 2) - (lineThickness / 2));
			var h:Number = ((Height / 2) - (lineThickness / 2))
			
			super(	X, Y,
					new Point( -w, h),
					new Point(w, h),
					new Point( 0, -h)
				);
			if (fillImage != null) {
				super.fillImage(image);
			}
		}
		
	}
	
}