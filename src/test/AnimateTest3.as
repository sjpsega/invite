package test
{
	import animate.ImgAnimate3;
	import flash.display.Sprite;
	import net.hires.debug.Stats;
	
	/**
	 * ...
	 * @author jingping.shenjp
	 */
	public class AnimateTest3 extends Sprite
	{
		
		[Embed(source="../../assets/wedding.jpg")]
		private var YoyoGif:Class;
		
		public function AnimateTest3()
		{
			var anim:ImgAnimate3 = new ImgAnimate3();
			anim.drawSource(new YoyoGif());
			anim.start();
			addChild(anim);
			addChild(new Stats());
		}
	}

}