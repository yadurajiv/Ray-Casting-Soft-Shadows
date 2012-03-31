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
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.CapsStyle;
	import flash.display.GradientType;
	import flash.display.GraphicsGradientFill;
	import flash.display.InterpolationMethod;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.ShaderPrecision;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.utils.getTimer;
	
	[SWF(width = "800", height = "600", backgroundColor = "#000000")]
	
	/**
	 * ...
	 * @author Yadu Rajiv
	 */
	public class Main extends Sprite 
	{
		private var _lSprite:Sprite;
		private var _lColor:uint;
		private var _lx:Number;
		private var _ly:Number;
		private var _lsize:Number;
		private var _lrange:Number;
		private var _lalpha:Number;
		private var _lfallOff:Number;
		
		private var _ambientLightColor:uint;
		
		private var timeElapsed:Number;
		private var lastTime:Number;
		
		private var _stageRatio:Number;
		
		private var _shadowMap:Sprite;
		
		private var debug:Sprite;
		private var drawDebugData:Boolean;
		
		private var _lights:Array;
		
		private var _objects:Sprite;
		
		public static var fps:FPS;
		
		[Embed(source = '../data/tile.jpg')] private var bgTile:Class;
		[Embed(source = '../data/trak2_holes1c.png')] private var holeTile:Class;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			Mouse.hide();
			
			createObjects();
			
			stage.addEventListener(Event.ENTER_FRAME, update);
			stage.addEventListener(MouseEvent.CLICK, handleClick);
		}
		
		private function createObjects():void {

			stage.scaleMode = StageScaleMode.NO_SCALE;
			graphics.lineStyle(1, 0x000000, 1, false, LineScaleMode.NONE,CapsStyle.ROUND,JointStyle.ROUND,3);
			
			_stageRatio = Math.sqrt((stage.stageWidth * stage.stageWidth) + (stage.stageHeight * stage.stageHeight));
			
			timeElapsed = 0;
			lastTime = 0;
			
			_ambientLightColor = 0x343434;
			
			createBG();
			setupShadowMap();
			createScreenObjects();
			setupLights();
			setupDebug();
			
			/**
			 * profiler code
			 */
			
			//create instance
			fps = new FPS();
			
			//add it there where you want it
			addChild(fps);
			
			//set text color
			fps.textColor="0xFF";
			//set FPS graph line color
			fps.fpsColor="0xFF0000";
			//set sizes
			fps.graphWidth=200; 
			fps.graphHeight=50;
			
			//set graph background color
			fps.graphBackColor = 0x55000000;
			
			//call this before you can use it
			fps.init();
			
			fps.addToGraph("shadow", 0x00ff00);
			
			// profiler code ends

		}
		
		private function createBG():void {
			var bg:Sprite = new Sprite();

			bg.graphics.beginBitmapFill((new bgTile).bitmapData);
			bg.scrollRect = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			bg.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			bg.graphics.endFill();
			addChild(bg);
		}
		
		private function setupShadowMap():void {
			_shadowMap = new Sprite();
			_shadowMap.scrollRect = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			_shadowMap.blendMode = BlendMode.MULTIPLY;
			_shadowMap.graphics.beginFill(_ambientLightColor);
			_shadowMap.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			_shadowMap.graphics.endFill();
			_shadowMap.filters = [new BlurFilter(4, 4, BitmapFilterQuality.LOW)]; // can this be replaced with a local single/multi pass blur algo?
			addChild(_shadowMap);
		}
		
		private function setupDebug():void {
			debug = new Sprite();
			debug.graphics.lineStyle(1, 0xff0000, 0.5);
			debug.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			addChild(debug);
			drawDebugData = false;
		}
		
		private function setupLights():void {
			_lights = new Array();
			
			_lights.push(new Light(0, 0,0xFAEFB5,200));
			_lights.push(new Light(290, 430, 0xffeeee, 200));
			
			var lt:Light = new Light(0, 40, 0xff0000,200);
			lt.setVelocity(140, 0);
			lt.active = true;
			_lights.push(lt);
			
			//_lights.push(new Light(350, 430, 0xffeeee, 200));
			//lights.push(new Light(410, 430, 0xffeeee, 200));
			//_lights.push(new Light(460, 430, 0xffeeee, 200));
			_lights.push(new Light(620, 500, 0xffeeee, 120));
		}
		
		private function createScreenObjects():void {

			_objects = new Sprite();
			
			_objects.addChild(new TCircle(600, 150,24,40,holeTile));
			
			_objects.addChild(new TBox(100, 350, 25, 600, holeTile));
			
			var box:TBox = new TBox(stage.stageWidth / 2, stage.stageHeight / 2, 200, 50, holeTile);
			box.setRotation(10);
			_objects.addChild(box);
			
			var b:TBox = new TBox(200, 100, 50, 50, holeTile);
			b.setRotation(45);
			_objects.addChild(b);
			_objects.addChild(new TBox(300, 100, 50, 50, holeTile));
			_objects.addChild(new TBox(400, 100, 50, 50, holeTile));
			_objects.addChild(new TBox(500, 100, 50, 50, holeTile));
			
			_objects.addChild(new TBox(200, 200, 50, 50, holeTile));
			_objects.addChild(new TBox(200, 300, 50, 50, holeTile));
			_objects.addChild(new TBox(200, 400, 50, 50, holeTile));
			
			var c:TBox = new TBox(200, 500, 50, 50, holeTile);
			c.setRotation(80);
			_objects.addChild(c);
			_objects.addChild(new TBox(300, 500, 50, 50, holeTile));
			_objects.addChild(new TBox(400, 500, 50, 50, holeTile));
			_objects.addChild(new TBox(500, 500, 50, 50, holeTile));
			
			_objects.addChild(new TEqTriangle(650, 500, 40,40,holeTile));
			
			var poly:TPolygon = new TPolygon( 650, 300,
															new Point(0 + 65, 0 - 10),							
															new Point(0 + 50, 0 - 50),
															new Point(0 - 50, 0 - 50),
															new Point(0 - 50, 0 + 50),
															new Point(0 + 50, 0 + 50)
														);
			poly.setRotation(5);
			poly.fillImage(holeTile);
			_objects.addChild(poly);
			
			addChild(_objects);
		}
		
		/**
		 * 
		 * FRAME FUNCTION - START
		 * 
		 */
		private function update(event:Event):void {
			
			fps.clear();
			
			if(drawDebugData) {
				debugClear();
			}
			
			graphics.clear();
			
			_lights[0].x = stage.mouseX;
			_lights[0].y = stage.mouseY;
			
			
			Light(_lights[2])._update(timeElapsed);
			
			if (_lights[2].x >= stage.stageWidth + (_lights[2].range)) {
				_lights[2].x = 0 - _lights[2].range;
				_lights[2].color = randomRGB();
				
				_lights[1].color = randomRGB();
				_lights[3].color = randomRGB();
				//_lights[4].color = randomRGB();
				//_lights[5].color = randomRGB();
				//_lights[6].color = randomRGB();
			}

			// _lights[1].x = stage.stageWidth/2 + ((stage.stageWidth/2)-_lights[0].x);
			// _lights[1].y = stage.mouseY;
			
			fps.startCounting("shadow");
			lightsAndShadows();
			fps.stopCounting("shadow");
			
			for (var i:uint = 0; i < _objects.numChildren; i++) {
				var tp:TPolygon = TPolygon(_objects.getChildAt(i));
				tp._update(timeElapsed);
				if (drawDebugData) {
					debugDraw(tp);
				}
			}
			
			timeElapsed = (getTimer() - lastTime)/1000;
			lastTime = getTimer();
			
		}
		// FRAME FUNCTION - END
		
		private function lightsAndShadows():void {
			
			var light:Light = null;
			var l:Sprite = null;
			var m:Matrix = null;
			
			_shadowMap.graphics.clear();
			_shadowMap.graphics.beginFill(_ambientLightColor);
			_shadowMap.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			_shadowMap.graphics.endFill();
			
			while (_shadowMap.numChildren > 0) {
				_shadowMap.removeChildAt(0);
			}
			
			for (var j:uint = 0; j < _lights.length; j++) {
				light = _lights[j];
				m = new Matrix();
				m.createGradientBox(light.range * 2, light.range * 2, 0, light.x - light.range, light.y - light.range);
				l = new Sprite();
				l.graphics.beginGradientFill(GradientType.RADIAL, [light.color, light.color], [1, light.falloff], [0, 255],m, SpreadMethod.PAD, InterpolationMethod.LINEAR_RGB);
				l.graphics.drawCircle(light.x, light.y, light.range);
				l.graphics.endFill();
				l.blendMode = BlendMode.ADD;
				for (var i:uint = 0; i < _objects.numChildren; i++) {
						var tp:TPolygon = TPolygon(_objects.getChildAt(i));
						cast(_lights[j], tp, l); // drawing on the light is a huge cpu penality, why?
				}
				_shadowMap.addChild(l);
			}
		}

		private function handleClick(event:MouseEvent):void {
			if (drawDebugData) {
				drawDebugData = false;
				debug.visible = false;
			} else {
				drawDebugData = true;
				debug.visible = true;
			}
		}
		
		private function cast(light:Light,box:TPolygon, surface:Object):void {
			if (box.collideSphere(light.x, light.y, light.range)) {

				var i:uint;
				var c:uint = box.globalVerts.length;
								
				var _wallNormals:Array = new Array();
				var _lightVector:Array = new Array();
				
				// getting the edge normals
				_wallNormals = box.getNormals(false);
				
				var facing:Number = 0;
				var lastIndex:Number = 0;
				
				var lastPoint:Point = null;
				var lastPointIndex:Number = NaN;
				var firstPoint:Point = null;
				var firstPointIndex:Number = NaN;
				
				for (i = 0; i < c; i++) {
					if (drawDebugData) {
						surface.graphics.lineStyle(1, 0xff0000, 1);
						surface.graphics.moveTo(light.x, light.y);
						surface.graphics.lineTo(box.globalVerts[i].x, box.globalVerts[i].y);
					}
					
					_lightVector.push(TPolygon.normalize(new Point(box.globalVerts[i].x -light.x, box.globalVerts[i].y - light.y)));

					// > 0 is front facing!
					if (TPolygon.dot(_wallNormals[i], _lightVector[i]) <= 0) { // back facing
						if (facing == -1) {
							lastPoint = new Point(box.globalVerts[lastIndex].x, box.globalVerts[lastIndex].y);
							lastPointIndex = lastIndex;
						}
						
						facing = 1;
					} else { // front facing
						if (facing == 1) {
							firstPoint = new Point(box.globalVerts[lastIndex].x, box.globalVerts[lastIndex].y);
							firstPointIndex = lastIndex;
						}
						
						facing = -1;
						
						/**
						 * highlight front faces
						 */
						if(drawDebugData) {
							surface.graphics.lineStyle(10, 0xff0000, 0.5);
							if (i - 1 < 0) {
								surface.graphics.moveTo(box.globalVerts[i].x, box.globalVerts[i].y);
								surface.graphics.lineTo(box.globalVerts[c - 1].x, box.globalVerts[c - 1].y);						
								
							} else {
								surface.graphics.moveTo(box.globalVerts[i].x, box.globalVerts[i].y);
								surface.graphics.lineTo(box.globalVerts[i - 1].x, box.globalVerts[i - 1].y);							
								
							}
						}
					}
					
					lastIndex = i;
				}
				
				if (isNaN(lastPointIndex)) {
					lastPointIndex = lastIndex;
				}
				if (isNaN(firstPointIndex)) {
					firstPointIndex = lastIndex;
				}

				if(lastPointIndex !=firstPointIndex) {
					
					/**
					 * drawing shared vertex where shadow starts and ends
					 */
					if(drawDebugData) {
						surface.graphics.lineStyle();
						surface.graphics.beginFill(0xff00ff, 1);
							surface.graphics.drawCircle(box.globalVerts[lastPointIndex].x, box.globalVerts[lastPointIndex].y, 12);
							surface.graphics.drawCircle(box.globalVerts[firstPointIndex].x, box.globalVerts[firstPointIndex].y, 12);
						surface.graphics.endFill();
					}
		
					
					/**
					 * drawing shadow rays
					 */
					
					if(drawDebugData) {
					 
						c = box.globalVerts.length;
						i = firstPointIndex;
						
						surface.graphics.lineStyle(2, 0x000000, 0.5);
						
						while (i != lastPointIndex) {
							
							surface.graphics.moveTo(box.globalVerts[i].x, box.globalVerts[i].y);
							surface.graphics.lineTo(box.globalVerts[i].x + (_lightVector[i].x * _stageRatio), box.globalVerts[i].y + (_lightVector[i].y * _stageRatio));
							
							if (i - 1 < 0) {
								i = c -1;
							} else {
								i--;
							}

						}
						
						surface.graphics.moveTo(box.globalVerts[i].x, box.globalVerts[i].y);
						surface.graphics.lineTo(box.globalVerts[i].x + (_lightVector[i].x * _stageRatio), box.globalVerts[i].y + (_lightVector[i].y * _stageRatio));
					
					}
					
					/**
					 * drawing the shadow volume
					 */
					/**
					 * Draw using near and far + 2 loops
					 */


					
					c = box.globalVerts.length;
					i = firstPointIndex;
					
					var shadowFar:Array = new Array();
					var shadowNear:Array = new Array();
					
					while (i != lastPointIndex) {
						
						shadowNear.push(box.globalVerts[i]);
						shadowFar.push(new Point(box.globalVerts[i].x + _lightVector[i].x * _stageRatio, box.globalVerts[i].y + _lightVector[i].y * _stageRatio));
						
						if (i - 1 < 0) {
							i = c -1;
						} else {
							i--;
						}

					}
					
					// last point
					shadowNear.push(box.globalVerts[i]);
					shadowFar.push(new Point(box.globalVerts[i].x + _lightVector[i].x * _stageRatio, box.globalVerts[i].y + _lightVector[i].y * _stageRatio));
						
					surface.graphics.lineStyle();
					
					if(drawDebugData) {
						surface.graphics.beginFill(0x000000, 0.5);
					} else {
						surface.graphics.beginFill(0x000000, 1);
					}
					
					surface.graphics.moveTo(shadowNear[0].x, shadowNear[0].y);
					
					for (i = 0; i < shadowNear.length; i++) {
						surface.graphics.lineTo(shadowNear[i].x, shadowNear[i].y);
					}
					
					shadowFar.reverse(); // keep this in mind!!
					
					for (i = 0; i < shadowFar.length; i++) {
						surface.graphics.lineTo(shadowFar[i].x, shadowFar[i].y);
					}
					surface.graphics.endFill();
					
					
					/**
					 * Shadow edges
					 */
					
					if(drawDebugData) {
						surface.graphics.lineStyle(2, 0x00ff00, 0.5);
					}
					
					var count:Number = shadowNear.length - 1;
					 
					// get the perp 
					var normalFirst:Point = TPolygon.normalize(TPolygon.getNormal(new Point(light.x, light.y), shadowNear[0]));
					var vecToFirst:Point = TPolygon.normalize(new Point(shadowNear[0].x - box.x, shadowNear[0].y - box.y));
					var outerPenumbraFirst:Point = new Point();
					
					normalFirst.x *= light.radius;
					normalFirst.y *= light.radius;
					
					if (TPolygon.dot(vecToFirst, normalFirst) < 0) { // 
						normalFirst.x *= -1;
						normalFirst.y *= -1;
					}
					
					outerPenumbraFirst = TPolygon.normalize( TPolygon.pointSubtract(new Point(light.x - normalFirst.x,light.y - normalFirst.y), shadowNear[0]));
					var penumbraFirst:Point = new Point(shadowNear[0].x - (outerPenumbraFirst.x * _stageRatio), shadowNear[0].y - (outerPenumbraFirst.y * _stageRatio));
					
					if(drawDebugData) {
						surface.graphics.moveTo(shadowNear[0].x, shadowNear[0].y);
						surface.graphics.lineTo(penumbraFirst.x,penumbraFirst.y);
					
						surface.graphics.moveTo(shadowNear[0].x, shadowNear[0].y);
						surface.graphics.lineTo(shadowNear[0].x + (outerPenumbraFirst.x * _stageRatio), shadowNear[0].y + (outerPenumbraFirst.y * _stageRatio));
					}
					
				}
			}
		}
		
		public function debugDraw(o:TPolygon):void {

			//debug.graphics.lineStyle(1, 0x00ff00, 0.5);
			
			var pt:Point = new Point();
			var normals:Array = o.getNormals();
			
			debug.graphics.lineStyle(1, 0xff0000, 0.5);
			
			pt.x = o.x + (normals[0].x * (o.radius));
			pt.y = o.y + (normals[0].y * (o.radius));
			debug.graphics.moveTo(pt.x, pt.y);
			debug.graphics.lineTo(pt.x + (normals[0].x * 10), pt.y + (normals[0].y * 10));
			
			debug.graphics.moveTo(o.globalVerts[0].x, o.globalVerts[0].y);
			
			
			for (var i:Number = 1; i < o.globalVerts.length;i++) {
				debug.graphics.lineTo(o.globalVerts[i].x, o.globalVerts[i].y);
				
				pt.x = o.x + (normals[i].x * (o.radius));
				pt.y = o.y + (normals[i].y * (o.radius));
				debug.graphics.moveTo(pt.x, pt.y);
				debug.graphics.lineTo(pt.x + (normals[i].x * 10), pt.y + (normals[i].y * 10));
				
				debug.graphics.moveTo(o.globalVerts[i].x, o.globalVerts[i].y);
			}
			debug.graphics.lineTo(o.globalVerts[0].x, o.globalVerts[0].y);

			debug.graphics.lineStyle(1, 0xff00ff, 0.5);
			debug.graphics.drawCircle(o.x, o.y, o.radius);

		}
		
		public function debugClear():void {
			debug.graphics.clear();
		}
		
		static public function randomRGB():uint {
			var r:uint = Math.floor(Math.random() * 254);
			var g:uint = Math.floor(Math.random() * 254);
			var b:uint = Math.floor(Math.random() * 254);
			
			var rgb:uint = r << 16 | g << 8 | b;
			
			return rgb;
		}
	}
	
}