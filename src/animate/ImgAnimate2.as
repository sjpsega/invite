package animate
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import interfaces.IDispse;
	import util.GlobalUtil;
	
	/**
	 * 使用BitMapData移动，Bitmap绘制图像
	 * 该方法效率高，但是透明效果不太好
	 * @author jingping.shenjp
	 */
	public class ImgAnimate2 extends Sprite implements IDispse
	{
		static public const ANIMATE_END:String = "animateEnd";
		private const SLICE_W:int = 10;
		private const SLICE_H:int = 10;
		private var _cacheBmp:Vector.<Vector.<PositionBitMapData>>
		private var sourceBmd:BitmapData;
		private var _showBmd:BitmapData;
		private var _showBmp:Bitmap;
		
		public function ImgAnimate2()
		{
		}
		
		public function drawSource(disObj:DisplayObject):void
		{
			sourceBmd = new BitmapData(GlobalUtil.W, GlobalUtil.H);
			sourceBmd.draw(disObj);
		}
		
		public function start():void
		{
			initBitmapData();
			randomBmdXY();
			_showBmd = new BitmapData(GlobalUtil.W, GlobalUtil.H);
			_showBmp = new Bitmap(_showBmd);
			addChild(_showBmp);
			addEventListener(Event.ENTER_FRAME, move);
		}
		
		public function dispose():void
		{
			if (sourceBmd)
			{
				sourceBmd.dispose();
				sourceBmd = null;
			}
			if (_cacheBmp)
			{
				for each (var vect:Vector.<PositionBitMapData>in _cacheBmp)
				{
					for each (var bmd:PositionBitMapData in vect)
					{
						bmd.dispose();
					}
				}
				_cacheBmp.length = 0;
				_cacheBmp = null;
			}
		}
		
		private function initBitmapData():void
		{
			_cacheBmp = new Vector.<Vector.<PositionBitMapData>>();
			var bmp_w:int = sourceBmd.width;
			var bmp_h:int = sourceBmd.height;
			var temp_w:int = 0;
			var temp_h:int = 0;
			var count_w:int = 0;
			var count_h:int = 0;
			var slice_bmd:PositionBitMapData;
			var pos:Point;
			while (temp_w < bmp_w)
			{
				_cacheBmp[count_w] = new Vector.<PositionBitMapData>();
				count_h = 0;
				temp_h = 0;
				while (temp_h < bmp_h)
				{
					slice_bmd = new PositionBitMapData(SLICE_W, SLICE_H);
					pos = new Point(SLICE_W * count_w, SLICE_H * count_h);
					slice_bmd.copyPixels(sourceBmd, new Rectangle(pos.x, pos.y, SLICE_W, SLICE_H), new Point(), null, new Point(), false);
					slice_bmd.position = pos;
					slice_bmd.mass = 1 + Math.random() * 5;
					slice_bmd.x = pos.x;
					slice_bmd.y = pos.y;
					_cacheBmp[count_w][count_h] = slice_bmd;
					temp_h += SLICE_H;
					count_h++;
				}
				temp_w += SLICE_W;
				count_w++;
			}
		}
		
		private function randomBmdXY():void
		{
			var inViewRange:Rectangle = new Rectangle(0, 0, GlobalUtil.W, GlobalUtil.H);
			var tempPos:Point = new Point();
			for each (var vect:Vector.<PositionBitMapData>in _cacheBmp)
			{
				for each (var bmp:PositionBitMapData in vect)
				{
					tempPos = randomPos(GlobalUtil.W, GlobalUtil.H);
					while (inViewRange.contains(tempPos.x, tempPos.y))
					{
						tempPos = randomPos(GlobalUtil.W, GlobalUtil.H);
					}
					bmp.x = tempPos.x;
					bmp.y = tempPos.y;
					bmp.isGetAim = false;
				}
			}
		}
		
		private function randomPos(w:Number, h:Number):Point
		{
			return new Point(w * 2.5 - Math.random() * w * 5, h * 2.5 - Math.random() * h * 5);
		}
		
		private function move(e:Event = null):void
		{
			var pos:Point;
			var isAllGetAim:Boolean = true;
			var alphaFillColor:uint = 0xFFFFFFFF;
			_showBmd.fillRect(new Rectangle(0, 0, GlobalUtil.W, GlobalUtil.H), alphaFillColor);
			var alphaBitmapData:BitmapData = new BitmapData(SLICE_W, SLICE_W, true, alphaFillColor);
			var alpha:Number = 0;
			for each (var vect:Vector.<PositionBitMapData> in _cacheBmp)
			{
				for each (var bmp:PositionBitMapData in vect)
				{
					if (!bmp.isGetAim)
					{
						pos = bmp.position;
						bmp.vx = (pos.x - bmp.x) / (bmp.mass * 3);
						bmp.vy = (pos.y - bmp.y) / (bmp.mass * 3);
						bmp.x += bmp.vx;
						bmp.y += bmp.vy;
						alpha = 50 / Math.sqrt(((pos.x - bmp.x) * (pos.x - bmp.x) + (pos.y - bmp.y) * (pos.y - bmp.y)));
						if ((Math.abs((pos.x - bmp.x)) < 1) && (Math.abs((pos.y - bmp.y)) < 1))
						{
							bmp.x = pos.x;
							bmp.y = pos.y;
							bmp.isGetAim = true;
							alpha = 1;
						}
						if (alpha > 1)
						{
							alpha = 1;
						}
						alphaFillColor = ((0xFF * alpha) << 24) + 0xFFFFFF;
						alphaBitmapData.fillRect(new Rectangle(0, 0, SLICE_W, SLICE_H), alphaFillColor);
						isAllGetAim = false;
					}
					_showBmd.copyPixels(bmp, new Rectangle(0, 0, SLICE_W, SLICE_H), new Point(bmp.x, bmp.y), alphaBitmapData, new Point());
				}
			}
			if (isAllGetAim)
			{
				trace(ANIMATE_END + "!!!!!!!");
				dispatchEvent(new Event(ANIMATE_END, true));
				removeEventListener(e.type, arguments.callee);
			}
		}
	
	}
}