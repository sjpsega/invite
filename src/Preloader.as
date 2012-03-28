package 
{
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	import util.GlobalUtil;
	
	/**
	 * ...
	 * @author jingping.shenjp
	 */
	public class Preloader extends MovieClip 
	{
		private var _loading:Shape;
		private var _loader_txt:TextField;
		static private const LOADING_W:Number = 600;
		static private const LOADING_H:Number = 50;
		public function Preloader() 
		{
			if (stage) {
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
			}
			addEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			// TODO show loader
			_loading = new Shape();
			var g:Graphics = _loading.graphics;
			var matr:Matrix = new Matrix();
			matr.createGradientBox(LOADING_W, LOADING_H);
			g.beginGradientFill(GradientType.LINEAR, [0xD9EDF7, 0x3A87AD], [1, 1], [0, 255], matr);
			g.drawRect(0, 0, LOADING_W, LOADING_H);
			g.endFill();
			addChild(_loading);
			_loading.x = (GlobalUtil.W - LOADING_W) * 0.5;
			_loading.y = (GlobalUtil.H - LOADING_H) * 0.5;
			
			_loader_txt = new TextField();
			_loader_txt.x = (GlobalUtil.W - _loader_txt.width) * 0.5;
			_loader_txt.y = _loading.y +LOADING_H+ 10;
			addChild(_loader_txt);
		}
		
		private function ioError(e:IOErrorEvent):void 
		{
			trace(e.text);
		}
		
		private function progress(e:ProgressEvent):void 
		{
			// TODO update loader
			var loaded:Number = e.bytesLoaded;
			var total:Number = e.bytesTotal;
			_loading.scaleX = loaded / total;
			_loader_txt.text =  Math.floor((loaded / total) * 100) + "%";
		}
		
		private function checkFrame(e:Event):void 
		{
			if (currentFrame == totalFrames) 
			{
				stop();
				loadingFinished();
			}
		}
		
		private function loadingFinished():void 
		{
			removeEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			// TODO hide loader
			removeChild(_loading);
			removeChild(_loader_txt);
			startup();
		}
		
		private function startup():void 
		{
			var mainClass:Class = getDefinitionByName("FirstView") as Class;
			addChild(new mainClass() as DisplayObject);
		}
		
	}
	
}