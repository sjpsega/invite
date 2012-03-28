package test 
{
	import animate.HeartShow;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author jingping.shenjp
	 */
	public class HeartTest extends Sprite 
	{
		
		public function HeartTest() 
		{
			var heart:HeartShow = new HeartShow();
			heart.start();
			addChild(heart);
		}
		
	}

}