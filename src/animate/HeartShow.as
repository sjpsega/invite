package animate
{
	import flash.display.Sprite;
	import flash.events.Event;
	import util.GlobalUtil;
	import view.Heart;
	
	/**
	 * ...
	 * @author jingping.shenjp
	 */
	public class HeartShow extends Sprite
	{
		private var _hearts:Vector.<Heart>;
		
		public function HeartShow()
		{
		
		}
		
		public function start():void
		{
			initHearts();
			initMove();
		}
		
		private function initHearts():void
		{
			_hearts = new Vector.<Heart>();
			var heart:Heart;
			for (var i:int = 0; i < 15; i++)
			{
				heart = returnNewHeart();
				_hearts.push(heart);
				addChild(heart);
			}
		}
		
		private function returnNewHeart():Heart
		{
			var heart:Heart = new Heart();
			resetHeart(heart);
			heart.vx = -1 - Math.random() * 2;
			heart.vy = 2 + Math.random() * 2;
			var random:Number = Math.random();
			heart.scaleX = heart.scaleY = random;
			heart.alpha = random;
			return heart;
		}
		
		private function resetHeart(heart:Heart):void
		{
			heart.x = Math.random() * GlobalUtil.W * 1.5;
			heart.y = -heart.height;
		}
		
		private function initMove():void
		{
			addEventListener(Event.ENTER_FRAME, move);
		}
		
		private function move(e:Event):void
		{
			if (_hearts.length < 100)
			{
				if (Math.random() * 1 > 0.4)
				{
					_hearts.push(returnNewHeart());
				}
			}
			for each (var heart:Heart in _hearts)
			{
				heart.update();
				if (heart.x + heart.width < 0 || heart.y > GlobalUtil.H)
				{
					resetHeart(heart);
				}
			}
		}
	}
}