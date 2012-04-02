package animate
{
	import flash.geom.Point;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author jingping.shenjp
	 */
	public class PositionByteArray
	{
		private var _byte:ByteArray;
		private var _dataPosition:Point; //目标位置
		private var _vx:Number;
		private var _vy:Number;
		private var _x:Number;
		private var _y:Number;
		private var _mass:Number;
		private var _isGetAim:Boolean = true; //是否到达目标点
		
		public function PositionByteArray()
		{
			super();
		}
		
		public function get dataPosition():Point
		{
			return _dataPosition.clone();
		}
		
		public function set dataPosition(value:Point):void
		{
			_dataPosition = value;
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
		
		public function get x():Number
		{
			return _x;
		}
		
		public function set x(value:Number):void
		{
			_x = value;
		}
		
		public function get y():Number
		{
			return _y;
		}
		
		public function set y(value:Number):void
		{
			_y = value;
		}
		
		public function get byte():ByteArray 
		{
			return _byte;
		}
		
		public function set byte(value:ByteArray):void 
		{
			_byte = value;
		}
	}

}