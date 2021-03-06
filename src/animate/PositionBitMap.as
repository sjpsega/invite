package animate
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author jingping.shenjp
	 */
	public class PositionBitMap extends Bitmap
	{
		private var _position:Point;//目标位置
		private var _vx:Number;
		private var _vy:Number;
		private var _mass:Number;
		private var _isGetAim:Boolean = true;//是否到达目标点

		public function PositionBitMap(bitmapData:BitmapData = null, pixelSnapping:String = "auto", smoothing:Boolean = false)
		{
			super(bitmapData, pixelSnapping, smoothing);
		}
		
		public function get position():Point
		{
			return _position.clone();
		}
		
		public function set position(value:Point):void
		{
			_position = value;
		}
		
		public function get vx():Number 
		{
			return _vx;
		}
		
		public function set vx(value:Number):void 
		{
			_vx = value;
		}
		
		public function get vy():Number 
		{
			return _vy;
		}
		
		public function set vy(value:Number):void 
		{
			_vy = value;
		}
		
		public function get isGetAim():Boolean 
		{
			return _isGetAim;
		}
		
		public function set isGetAim(value:Boolean):void 
		{
			_isGetAim = value;
		}
		
		public function get mass():Number 
		{
			return _mass;
		}
		
		public function set mass(value:Number):void 
		{
			_mass = value;
		}
	}

}