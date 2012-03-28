package view
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author jingping.shenjp
	 */
	public class SaveBtn extends Sprite
	{
		private var btnView:SaveBtnView;
		private var text:TextField;
		public function SaveBtn()
		{
			btnView = new SaveBtnView(80,20);
			addChild(btnView);
			text = new TextField();
			text.text = "保存请帖";
			text.autoSize = TextFieldAutoSize.LEFT;
			text.selectable = false;
			text.x = (this.width - text.width) / 2;
			text.mouseEnabled = false;
			addChild(text);
			useHandCursor = true;
		}
	}
}
import flash.display.Shape;
import flash.display.SimpleButton;

class SaveBtnView extends SimpleButton
{
	
	private var upColor:uint = 0x1389FF ;
	private var overColor:uint = 0x1569C7;
	private var downColor:uint = 0x1569C7;
	public function SaveBtnView(w:Number,h:Number)
	{
		downState = new ButtonDisplayState(downColor, w,h);
		overState = new ButtonDisplayState(overColor, w,h);
		upState = new ButtonDisplayState(upColor,  w,h);
		hitTestState = new ButtonDisplayState(upColor,  w,h);
	}
}
	
class ButtonDisplayState extends Shape
{
	private var bgColor:uint;
	private var w:Number;
	private var h:Number;
	
	public function ButtonDisplayState(bgColor:uint, w:Number,h:Number)
	{
		this.bgColor = bgColor;
		this.w = w;
		this.h = h;
		draw();
	}
	
	private function draw():void
	{
		graphics.beginFill(bgColor);
		graphics.drawRoundRectComplex(0, 0, w, h, 5, 5, 5, 5);
		graphics.endFill();
	}
}
