package test
{
	import animate.ImgAnimate2;
	import flash.display.Sprite;
	import mx.core.BitmapAsset;
	import net.hires.debug.Stats;
	
	/**
	 * ...
	 * @author jingping.shenjp
	 */
	public class AnimateTest2 extends Sprite 
	{
		[Embed(source="../../assets/wedding.jpg")]
		private var YoyoGif:Class;
		
		public function AnimateTest2() 
		{
			var anim:ImgAnimate2 = new ImgAnimate2();
			anim.drawSource( new YoyoGif());
			anim.start();
			addChild(anim);
			addChild(new Stats());
		}
	}
}