package view
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author jingping.shenjp
	 */
	public class Heart extends Sprite
	{
		[Embed(source="../../assets/heart.png")]
		private var _heart:Class;
		private var _vx:Number;
		private var _vy:Number;
		private var _mass:Number;
		
		public function Heart()
		{
			addChild(new _heart());
			mouseEnabled = false;
		}
		
		public function update():void
		{
			this.x += vx;
			this.y += vy;
			this.rotationZ += ( -0.5 + Math.random() * 1);
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
	
	}

}