package test
{
	import animate.ImgAnimate;
	import flash.display.Sprite;
	import mx.core.BitmapAsset;
	import net.hires.debug.Stats;
	
	/**
	 * ...
	 * @author jingping.shenjp
	 */
	public class AnimateTest extends Sprite 
	{
		[Embed(source="../../assets/wedding.jpg")]
		private var YoyoGif:Class;
		
		public function AnimateTest() 
		{
			var anim:ImgAnimate = new ImgAnimate();
			anim.drawSource( new YoyoGif());
			anim.start();
			addChild(anim);
			addChild(new Stats());
		}
		
	}

}