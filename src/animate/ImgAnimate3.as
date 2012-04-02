package animate
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import interfaces.IDispse;
	import util.GlobalUtil;
	
	/**
	 * 使用getPixels\setPixels绘制图像
	 * 该方法效率高，没有透明效果
	 * @author jingping.shenjp
	 */
	public class ImgAnimate3 extends Sprite implements IDispse
	{
		static public const ANIMATE_END:String = "animateEnd";
		private const SLICE_W:int = 4;
		private const SLICE_H:int = 4;
		private var _cacheBmp:Vector.<Vector.<PositionByteArray>>
		private var sourceBmd:BitmapData;
		private var _showBmd:BitmapData;
		private var _showBmp:Bitmap;
		
		public function ImgAnimate3()
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
				for each (var vect:Vector.<PositionByteArray> in _cacheBmp)
				{
					for each (var btye:PositionByteArray in vect)
					{
						btye.byte.clear();
					}
				}
				_cacheBmp.length = 0;
				_cacheBmp = null;
			}
		}
		
		private function initBitmapData():void
		{
			_cacheBmp = new Vector.<Vector.<PositionByteArray>>();
			var bmp_w:int = sourceBmd.width;
			var bmp_h:int = sourceBmd.height;
			var temp_w:int = 0;
			var temp_h:int = 0;
			var count_w:int = 0;
			var count_h:int = 0;
			var slice_byte:PositionByteArray;
			var byte:ByteArray;
			var pos:Point;
			while (temp_w < bmp_w)
			{
				_cacheBmp[count_w] = new Vector.<PositionByteArray>();
				count_h = 0;
				temp_h = 0;
				while (temp_h < bmp_h)
				{
					slice_byte = new PositionByteArray();
					pos = new Point(SLICE_W * count_w, SLICE_H * count_h);
					byte = sourceBmd.getPixels(new Rectangle(pos.x, pos.y, SLICE_W, SLICE_H));
					slice_byte.byte = byte;
					slice_byte.dataPosition = pos;
					slice_byte.mass = 1 + Math.random() * 5;
					slice_byte.x = pos.x;
					slice_byte.y = pos.y;
					_cacheBmp[count_w][count_h] = slice_byte;
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
			for each (var vect:Vector.<PositionByteArray> in _cacheBmp)
			{
				for each (var bmp:PositionByteArray in vect)
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
			_showBmd.fillRect(new Rectangle(0, 0, GlobalUtil.W, GlobalUtil.H), 0x00000000);
			var byteArray:ByteArray;
			_showBmd.lock();
			for each (var vect:Vector.<PositionByteArray>in _cacheBmp)
			{
				for each (var byte:PositionByteArray in vect)
				{
					if (!byte.isGetAim)
					{
						pos = byte.dataPosition;
						byte.vx = (pos.x - byte.x) / (byte.mass * 3);
						byte.vy = (pos.y - byte.y) / (byte.mass * 3);
						byte.x += byte.vx;
						byte.y += byte.vy;
						if ((Math.abs((pos.x - byte.x)) < 1) && (Math.abs((pos.y - byte.y)) < 1))
						{
							byte.x = pos.x;
							byte.y = pos.y;
							byte.isGetAim = true;
						}
						isAllGetAim = false;
					}
					byteArray = byte.byte;
					byteArray.position = 0;
					_showBmd.setPixels(new Rectangle(byte.x, byte.y, SLICE_W, SLICE_H), byteArray);
				}
			}
			_showBmd.unlock();
			if (isAllGetAim)
			{
				trace(ANIMATE_END + "!!!!!!!");
				dispatchEvent(new Event(ANIMATE_END, true));
				removeEventListener(e.type, arguments.callee);
			}
		}
	
	}
}