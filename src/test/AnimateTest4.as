package test 
{
	import animate.ImgAnimate4;
	import flash.display.Sprite;
	import net.hires.debug.Stats;
	
	/**
	 * ...
	 * @author jingping.shenjp
	 */
	public class AnimateTest4 extends Sprite 
	{
		
		[Embed(source="../../assets/wedding.jpg")]
		private var YoyoGif:Class;
		
		public function AnimateTest4()
		{
			var anim:ImgAnimate4 = new ImgAnimate4();
			anim.drawSource(new YoyoGif());
			anim.start();
			addChild(anim);
			addChild(new Stats());
		}
	}

}