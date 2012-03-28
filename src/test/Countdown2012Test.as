package test 
{
	import flash.display.Sprite;
	import mvc.Countdown2012;
	/**
	 * ...
	 * @author jingping.shenjp
	 */
	public class Countdown2012Test extends Sprite
	{
		private var countdown2012:Countdown2012;
		
		public function Countdown2012Test() 
		{
			countdown2012 = new Countdown2012(new Date(2012, 11, 12), new Date(2012, 2, 30, 18, 18));
			addChild(countdown2012);
		}
		
	}

}