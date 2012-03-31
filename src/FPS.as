/**
 *  Profiler class by wonderwhy-er
 * 	more : http://blog.wonderwhy-er.com/as3-simple-fpsprofiler-class/
 */

package {
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.ColorTransform;
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.system.System;
	import flash.utils.*;

	public class FPS extends Sprite {
		
		public var fps:TextField;
		public var ms:TextField;
		public var mem:TextField;
		public var output:TextField;
		private var startPoints:Object;
		private var collectedTime:Object;
		private var lastTime:Object;
		private var graphColors:Object;
		public var textColor:String="0xFF";
		public var fpsColor:String="0xFF0000";
		public var graphWidth:uint=200;
		public var graphHeight:uint=50;
		public var graphBackColor:uint = 0x44000000;
		private var maxFPS:uint;
		private var col:int;
		private var iFPScolor:uint;
		private var fpsMultiply:Number;
		private var countersMultiply:Number;
		private var tt:int;
		private var pt:int;
		private var bmd:BitmapData;
		private var bmp:Bitmap;
		private var m:Matrix;
		private var tmp:BitmapData;
		private var sp:Sprite;
		private var g:Graphics;
		private var lfp:Number;

		public function FPS() {}

		public function init():void {
			graphics.beginFill(graphBackColor,(graphBackColor>>>24)/255);
			graphics.drawRect(0,0,graphWidth,graphHeight+20);
			mouseChildren=false;
			fps = new TextField();
			fps.width=55;
			addChild(fps);	
			
			ms = new TextField();
			ms.width=35;
			ms.x=55;
			addChild(ms);	
			
			mem = new TextField();
			mem.width=80;
			mem.x=90;
			addChild(mem);		
			
			output = new TextField();
			output.width=170;
			addChild(output);
			maxFPS=stage.frameRate;
			col=int(textColor);
			iFPScolor=uint(fpsColor);
			fpsMultiply = graphHeight/(maxFPS*1.2);
			countersMultiply=maxFPS*graphHeight/1050;
			startPoints={};
			collectedTime={};
			graphColors={};
			lastTime={};
			tt=pt=getTimer();
			var ct:ColorTransform = new ColorTransform(1,1,1,1,(col>>16)%256,(col>>8)%256,col%256,0);
			fps.transform.colorTransform=ct;
			ms.transform.colorTransform=ct;
			mem.transform.colorTransform=ct;
			output.transform.colorTransform=ct;
			output.x=0;
			output.autoSize=flash.text.TextFieldAutoSize.LEFT;
			output.y=20+graphHeight+10;
			pt=tt;
			bmd=new BitmapData(graphWidth,graphHeight,true,0);
			bmp=new Bitmap(bmd);
			addChild(bmp);
			bmp.y=20;
			m = new Matrix();
			m.tx=-1;
			tmp=new BitmapData(bmd.width,bmd.height,true,0);
			sp = new Sprite();
			g=sp.graphics;
			lfp=0;
			addEventListener(Event.ENTER_FRAME,frame);
			
		}
		public function startCounting(name:String):void {
			if (! startPoints.hasOwnProperty(name)) {
				startPoints[name]=0;
				collectedTime[name]=0;
				lastTime[name]=0;
			}
			startPoints[name]=getTimer();
		}
		public function stopCounting(name:String):void {
			var t:int=getTimer();
			collectedTime[name]+=getTimer()-startPoints[name];
			startPoints[name]=getTimer();
			//trace(collectedTime[name]);
		}

		public function getData(name:String):Number {
			return collectedTime[name];
		}

		public function clear():void {
			for (var name:String in collectedTime) {
				lastTime[name]=collectedTime[name];
				collectedTime[name]=0;
			}
		}

		public function addToGraph(name:String,color:uint):void {
			if (graphColors==null) {
				init();
			}
			graphColors[name]=color;
		}
		public function removeFromGraph(name:String,color:uint):void {
			if (graphColors.hasOwnProperty(name)) {
				graphColors[name]=null;
			}
		}
		public function frame(evt:Event):void {
			tt=getTimer();
			var dt:int=tt-pt;
			var fp:Number=Math.round((10000/dt))/10;
			fps.text="FPS: "+fp.toString()+" /";
			ms.text=(dt).toString()+" ms";
			mem.text="mem: "+Math.round(100*System.totalMemory/1048576)/100+" Mb";
			output.text="";
			for (var name:String in lastTime) {
				output.appendText(name+" : "+lastTime[name]+"\n");
			}
			tmp.fillRect(tmp.rect,0);
			tmp.draw(bmd,m);
			bmd.copyPixels(tmp,tmp.rect,new Point());
			g.clear();
			g.lineStyle(0,iFPScolor);
			g.moveTo(bmd.width-2,bmd.height-lfp*fpsMultiply);
			g.lineTo(bmd.width-1,bmd.height-fp*countersMultiply);
			pt=tt;
			lfp=fp;
			for (name in graphColors) {
				if (graphColors[name]!=null) {
					g.lineStyle(0,graphColors[name]);
					g.moveTo(bmd.width-2,bmd.height-lastTime[name]*countersMultiply);
					g.lineTo(bmd.width-1,bmd.height-collectedTime[name]*countersMultiply);
				}
			}
			bmd.draw(sp);
		}
	}
}