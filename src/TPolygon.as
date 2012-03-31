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
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Yadu Rajiv
	 */
	public class TPolygon extends Sprite 
	{
		private var _ready:Boolean;
		private var _vertices:Array;
		
		public var lineThickness:Number
		public var lineColor:uint;
		public var lineAlpha:Number;
		
		private var _doFill:Boolean;
		public var fillColor:uint;
		
		private var _timeElapsed:Number;
		
		private var _rotation:Number;
		
		private var _velX:Number;
		
		private var _velY:Number;
		
		public var globalVerts:Array;
		
		public const PIDiv180:Number = 0.017453292519943295769236907684886;
		
		public var radius:Number;
		
		private var _doBMPFill:Boolean;
		private var _fillBMP:BitmapData;
		private var _fm:flash.geom.Matrix;
		private var _fillRepeat:Boolean
		private var _fillSmooth:Boolean;
		
		public function TPolygon(X:Number, Y:Number, ...arguments) {

			this.x = X;
			this.y = Y;
			
			_velX = 0;
			_velY = 0;
			_rotation = 0;
			_timeElapsed = 0;
			radius = 0;
			
			globalVerts = new Array();
			
			if (arguments[0] is Point) {
				drawSettings();
				fillSettings();
				createPolygon(arguments);
				_ready = true;
			} else if (arguments[0] is Array) {
				drawSettings();
				fillSettings();
				createPolygon(arguments[0]);
				_ready = true;
			}else {
				drawSettings();
				fillSettings();
				_ready = false;
			}
			
		}
		
		public function fillImage(Graphic:Class):void {
			_fillBMP = (new Graphic).bitmapData;
			fillImageSettings();
			_doFill = true;
			_doBMPFill = true;
			lineThickness = 0;
			lineAlpha = 0;
			lineColor = 0;
			createPolygon(_vertices);
		}
		
		public function fillImageSettings(fillRepeat:Boolean = true, fillSmooth:Boolean = false, fillMatrix:Matrix=null):void {
			if (fillMatrix == null) {
				_fm = new Matrix();
			} else {
				_fm = fillMatrix;
			}
			
			_fillRepeat = fillRepeat;
			_fillSmooth = fillSmooth
		}
		
		public function drawSettings(Thickeness:Number = 2, Color:uint = 0x000000, Alpha:Number = 1):void {
			lineThickness = Thickeness;
			lineColor = Color;
			lineAlpha = Alpha;
		}
		
		public function fillSettings(doFill:Boolean = true, Color:uint = 0xc0c0c0):void {
			fillColor = Color;
			_doFill = doFill;
		}
		
		public function createPolygon(points:Array):void {
			
			var maxX:Number;
			var minX:Number;
			var maxY:Number;
			var minY:Number;
			
			globalVerts = new Array();
			_vertices = new Array();
			
			if (_doFill) {
				if(_doBMPFill) {
					graphics.beginBitmapFill(_fillBMP, _fm, _fillRepeat, _fillSmooth);
				} else {
					graphics.beginFill(fillColor, lineAlpha);
				}
			}
			graphics.lineStyle(lineThickness, lineColor, lineAlpha);
			
			graphics.moveTo(points[0].x, points[0].y)
			maxX = points[0].x; 
			minX = points[0].x; 
			maxY = points[0].y;
			minY = points[0].y;
			
			_vertices.push(points[0]);
			globalVerts.push(new Point(x + points[0].x, y + points[0].y));
			
			for (var i:Number = 1; i < points.length;i++) {
				_vertices.push(points[i]);
				globalVerts.push(new Point(x + points[i].x, y + points[i].y));
				graphics.lineTo(points[i].x, points[i].y);
				if (points[i].x > maxX) maxX = points[i].x; 
				if (points[i].x < minX) minX = points[i].x; 
				if (points[i].y > maxY) maxY = points[i].y; 
				if (points[i].y < minY) minY = points[i].y; 
			}
			
			if (Bourke.ClockWise(_vertices) == Bourke.CLOCKWISE) {
				_vertices.reverse();
				globalVerts.reverse();
			}
			
			graphics.lineTo(points[0].x, points[0].y);
			
			if(_doFill) {
				graphics.endFill();
			}
			
			var tx:Number = (maxX - minX) >> 1;
			var ty:Number = (maxY - minY) >> 1;
			
			radius = tx + ty - (Math.min(tx, ty) >> 1);
			
			_ready = true;

		}
		
		public function set active(b:Boolean):void {
			_ready = b;
		}
		
		public function get active():Boolean {
			return _ready;
		}
		
		override public function get rotation():Number { return super.rotation; }
		
		override public function set rotation(value:Number):void 
		{
			if(value != rotation) {
				if(_rotation == 0) {
					for (var i:Number = 0; i < globalVerts.length; i++) {
						globalVerts[i] = rotatePoint(globalVerts[i], new Point(x, y), value * PIDiv180);
					}
					super.rotation = value;
				} else {
					super.rotation = value;
				}
			}
		}

		
		public function _update(elapsed:Number):void {
			if(_ready) {
				_timeElapsed = elapsed;
				updateMotion();
				update();
			}
		}
		
		public function update():void {

		}
		
		public function setRotation(v:Number):void {
			_rotation = v;
		}
		
		public function setVelocity(vx:Number, vy:Number):void {
			_velX = vx;
			_velY = vy;
		}
		
		public function getVelocityX():Number {
			return _velX;
		}
		
		public function getVelocityY():Number {
			return _velY;
		}
		
		public function getRotation():Number {
			return _rotation;
		}
		
		public function updateMotion():void {
			
			var transX:Number = _velX * _timeElapsed;
			var transY:Number = _velY * _timeElapsed;
			var rotVal:Number = _rotation * _timeElapsed;
			
			x += transX;
			y += transY;
			
			rotation += rotVal;
			
			if(_velX !=0 || _velY != 0 || _rotation != 0) {
				for (var i:Number = 0; i < globalVerts.length; i++) {
					if(_velX !=0 || _velY != 0) {
						globalVerts[i].x += transX;
						globalVerts[i].y += transY;
					}
					if(_rotation != 0) {
						globalVerts[i] = rotatePoint(globalVerts[i], new Point(x, y), rotVal * PIDiv180);
					}
				}
			}
		}
		
		public static function rotatePoint(pt:Point, origin:Point, theta:Number):Point {
			var p:Point = new Point();
			p.x = Math.cos(theta) * (pt.x - origin.x) - Math.sin(theta) * (pt.y - origin.y) + origin.x;
			p.y = Math.sin(theta) * (pt.x - origin.x) + Math.cos(theta) * (pt.y - origin.y) + origin.y;
			return p;
		}
		
		/**
		 * returns an array of normals for all the edges in the polygon
		 * @return returns an array of normals
		 */
		public function getNormals(positiveY:Boolean = true):Array {
			var axes:Array = new Array();
			var c:Number = globalVerts.length;
			for (var i:uint=0; i < c; i++) {
				if (i - 1 < 0) {
					axes.push(getNormal(globalVerts[i], globalVerts[c - 1],positiveY));
				} else {
					axes.push(getNormal(globalVerts[i], globalVerts[i - 1],positiveY));
				}
			}
			
			return axes;
		}
		
		public static function getNormal(pt1:Point, pt2:Point, positiveY:Boolean = true):Point {
			if (positiveY) {
				return normalize(new Point( -(pt2.y - pt1.y), (pt2.x - pt1.x)));
			} else {
				return normalize(new Point( (pt2.y - pt1.y), -(pt2.x - pt1.x)));
			}
		}
		
		/**
		 * point 2 is subtracted from point 1 and a new point is returned
		 * @param	pt1 is the first point from which point 2 needs to be subtracted from
		 * @param	pt2 is the point to be subtracted from point 1
		 * @return
		 */
		public static function pointSubtract(pt1:Point, pt2:Point):Point {
			return new Point(pt1.x - pt2.x, pt1.y - pt2.y);
		}
		
		public static function pointAdd(pt1:Point, pt2:Point):Point {
			return new Point(pt1.x + pt2.x, pt1.y + pt2.y);
		}
		
		public static function normalize(pt:Point):Point {
			var tmp:Number = Math.sqrt(pt.x * pt.x + pt.y * pt.y);
			return new Point(pt.x / tmp, pt.y / tmp);
		}
		
		public static function dot(pt1:Point, pt2:Point):Number {
			return (pt1.x * pt2.x + pt1.y * pt2.y);
		}
		
		public function project(shape:Array,axis:Point,vOffset:Point):Point {
			var min:Number;
			var max:Number;
			min = max = dot(shape[0], axis);
			
			for (var i:Number = 1; i < shape.length; i++) {
				var tmp:Number = dot(shape[i], axis);
				if (tmp > max)
					max = tmp;
				else if (tmp < min)
					min = tmp;
			}
			
			var sOffset:Number = dot(vOffset, axis);
			min += sOffset;
			max += sOffset;
			
			return new Point(min, max);
		}
		
		public function overlap(pt1:Point, pt2:Point):Number {
			if (pt1.y > pt2.x) {
				return (pt1.y - pt2.x);
			} else if (pt1.x > pt2.y) {
				return (pt1.x - pt2.y)
			}
			return 0;
		}
		
		public function collide(other:TPolygon):Number {
			
			if (_ready) {
				
				if(sphereCollision(x,y,radius,other.x,other.y, other.radius)) {
				
					var axes1:Array = getNormals();
					var axes2:Array = other.getNormals();
					
					var vOffset:Point = pointSubtract(new Point(x, y), new Point(other.x, other.y));
					
					var magnitude:Number = Number.MAX_VALUE;
					var o:Number = 0;
					
					for (var i:Number = 0; i < axes1.length; i++) {
						var projA1:Point = project(globalVerts, axes1[i], vOffset);
						var projA2:Point = project(other.globalVerts, axes1[i], vOffset);
						
						o = overlap(projA1, projA2);
						if (!o) {
							return 0;
						} else {
							if (o < magnitude) {
								magnitude = o;
							}
						}
					}
					
					for (var j:Number = 0; i < axes2.length; i++) {
						var projB1:Point = project(globalVerts, axes2[j], vOffset);
						var projB2:Point = project(other.globalVerts, axes2[j], vOffset);
						
						o = overlap(projB1, projB2);
						if (!o) {
							return 0;
						} else {
							if (o < magnitude) {
								magnitude = o;
							}
						}
					}
					return magnitude;
				}
				return 0;
			}
			return 0;
		}
		
		public function collideSphere(X:Number, Y:Number, Radius:Number):Boolean {
			return sphereCollision(x, y, radius, X, Y, Radius);
		}
		
		public static function distanceSq(x1:Number,y1:Number, x2:Number, y2:Number):Number {
			return (((x1 - x2) * (x1 - x2)) + ((y1 - y2) * (y1 - y2)));
		}
		
		public static function distance(x1:Number,y1:Number, x2:Number, y2:Number):Number {
			return Math.sqrt(((x1 - x2) * (x1 - x2)) + ((y1 - y2) * (y1 - y2)));
		}

		public static function sphereCollision(x1:Number, y1:Number, r1:Number, x2:Number, y2:Number, r2:Number):Boolean {
			return (distanceSq(x1,y1,x2,y2) <= ((r1+r2)*(r1+r2)));
		}
	}
	
}