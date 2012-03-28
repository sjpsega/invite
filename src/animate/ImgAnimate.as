package animate
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import interfaces.IDispse;
	import util.GlobalUtil;
	
	/**
	 * 使用BitMap移动，绘制图像
	 * @author jingping.shenjp
	 */
	public class ImgAnimate extends Sprite implements IDispse
	{
		static public const ANIMATE_END:String = "animateEnd";
		private const SLICE_W:int = 10;
		private const SLICE_H:int = 10;
		private var _cacheBmp:Vector.<Vector.<PositionBitMap>>
		private var sourceBmd:BitmapData;
		
		public function ImgAnimate()
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
				for each (var vect:Vector.<PositionBitMap>in _cacheBmp)
				{
					for each (var bmp:PositionBitMap in vect)
					{
						bmp.bitmapData.dispose();
					}
				}
				_cacheBmp.length = 0;
				_cacheBmp = null;
			}
		}
		
		private function initBitmapData():void
		{
			_cacheBmp = new Vector.<Vector.<PositionBitMap>>();
			var bmp_w:int = sourceBmd.width;
			var bmp_h:int = sourceBmd.height;
			var temp_w:int = 0;
			var temp_h:int = 0;
			var count_w:int = 0;
			var count_h:int = 0;
			var slice_bmd:BitmapData;
			var slice_bmp:PositionBitMap;
			var pos:Point;
			while (temp_w < bmp_w)
			{
				_cacheBmp[count_w] = new Vector.<PositionBitMap>();
				count_h = 0;
				temp_h = 0;
				while (temp_h < bmp_h)
				{
					slice_bmd = new BitmapData(SLICE_W, SLICE_H);
					pos = new Point(SLICE_W * count_w, SLICE_H * count_h);
					slice_bmd.copyPixels(sourceBmd, new Rectangle(pos.x, pos.y, SLICE_W, SLICE_H), new Point(), null, new Point(), false);
					slice_bmp = new PositionBitMap(slice_bmd);
					slice_bmp.position = pos;
					slice_bmp.mass = 1 + Math.random() * 5;
					slice_bmp.x = pos.x;
					slice_bmp.y = pos.y;
					_cacheBmp[count_w][count_h] = slice_bmp;
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
			for each (var vect:Vector.<PositionBitMap>in _cacheBmp)
			{
				for each (var bmp:PositionBitMap in vect)
				{
					tempPos = randomPos(GlobalUtil.W, GlobalUtil.H);
					while (inViewRange.contains(tempPos.x, tempPos.y))
					{
						tempPos = randomPos(GlobalUtil.W, GlobalUtil.H);
					}
					bmp.x = tempPos.x;
					bmp.y = tempPos.y;
					bmp.isGetAim = false;
					bmp.alpha = 0;
					addChild(bmp);
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
			for each (var vect:Vector.<PositionBitMap> in _cacheBmp)
			{
				for each (var bmp:PositionBitMap in vect)
				{
					if (!bmp.isGetAim)
					{
						pos = bmp.position;
						bmp.vx = (pos.x - bmp.x) / (bmp.mass * 3);
						bmp.vy = (pos.y - bmp.y) / (bmp.mass * 3);
						bmp.x += bmp.vx;
						bmp.y += bmp.vy;
						bmp.alpha = 5 / Math.sqrt(((pos.x - bmp.x) * (pos.x - bmp.x) + (pos.y - bmp.y) * (pos.y - bmp.y)));
						
						if ((Math.abs((pos.x - bmp.x)) < 1) && (Math.abs((pos.y - bmp.y)) < 1))
						{
							bmp.x = pos.x;
							bmp.y = pos.y;
							bmp.alpha = 1;
							bmp.isGetAim = true;
						}
						isAllGetAim = false;
					}
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