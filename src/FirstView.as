package
{
	import com.adobe.utils.StringUtil;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import interfaces.IControl;
	import interfaces.ISaveName;
	import util.GlobalUtil;
	
	/**
	 * 初始页面
	 */
	[Frame(factoryClass="Preloader")]
	public class FirstView extends MovieClip
	{
		private var _outputBitmap:BitmapData; // output image bitmap
		private var _fader:Shape; // fader
		private var nameInput:NameInput;
		private var friends:Vector.<String>;
		private var friednsData:XML = GlobalUtil.NAMES;
		private var _inviteLoader:Loader;
		private var _inviteSwf:DisplayObject
		private var _bg:Bitmap
		private var _nameErrorTimer:Timer;
		
		public function FirstView()
		{
			if (stage)
			{
				on_added_to_stage(null);
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, on_added_to_stage);
			}
		}
		
		private function on_added_to_stage(e:Event):void
		{
			trace("on_added_to_stage,");
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			removeEventListener(Event.ADDED_TO_STAGE, on_added_to_stage);
			initBg();
			initNameInput();
			initNameErrorTimer();
			initFriends();
			initLoad();
			stage.addEventListener(MouseEvent.MOUSE_MOVE, on_mouse_move);
		}
		
		private function initLoad():void
		{
			_inviteLoader = new Loader();
			_inviteLoader.load(new URLRequest("invite.swf"));
			_inviteLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, initLoadCompleteHandler);
			_inviteLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler);
		}
		
		private function IOErrorHandler(e:IOErrorEvent):void
		{
			trace("error");
		}
		
		private function initLoadCompleteHandler(e:Event):void
		{
			trace("initLoadCompleteHandler~~~~~~~~~~");
			_inviteLoader.removeEventListener(e.type, arguments.callee);
			_inviteSwf = _inviteLoader.content;
			(_inviteSwf as IControl).loadAssets();
		}
		
		private function initFriends():void
		{
			friends = new Vector.<String>();
			var namesXMLList:XMLList = friednsData..friends;
			var names:Array = [];
			for each (var namesXML:XML in namesXMLList)
			{
				names = namesXML.toString().split(",");
				if (names.length)
				{
					for each (var name:String in names)
					{
						friends.push(StringUtil.trim(name));
					}
				}
			}
			trace(friends.length, friends);
		}
		
		private function initNameInput():void
		{
			nameInput = new NameInput();
			addChild(nameInput);
			nameInput.nameContant.text = "";
			nameInput.x = (GlobalUtil.W - nameInput.width) / 2;
			nameInput.y = (GlobalUtil.H - nameInput.height) / 2;
			hideNameError();
			nameInput.confirmBtn.addEventListener(MouseEvent.CLICK, confirmBtnClickHandler);
		}
		
		private function hideNameError():void
		{
			nameInput.nameError.visible = false;
		}
		
		private function showNameError():void
		{
			nameInput.nameError.visible = true;
		}
		
		private function initNameErrorTimer():void
		{
			_nameErrorTimer = new Timer(1000, 1);
			_nameErrorTimer.addEventListener(TimerEvent.TIMER_COMPLETE, function():void
				{
					hideNameError();
				});
		}
		
		private function confirmBtnClickHandler(e:MouseEvent):void
		{
			var friName:String = StringUtil.trim(nameInput.nameContant.text);
			trace("inputName,", friName);
			if (findSomeOne(friName))
			{
				trace("ok");
				(_inviteSwf as ISaveName).saveName(friName);
				removeEventListener(Event.ENTER_FRAME, on_enter_frame);
				var timer:Timer = new Timer(50, 15);
				timer.addEventListener(TimerEvent.TIMER, function():void
					{
						_bg.alpha -= 0.1;
						nameInput.alpha -= 0.1;
					});
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, function():void
					{
						_bg.visible = false;
						nameInput.visible = false;
						addChild(_inviteSwf);
						(_inviteSwf as IControl).start();
					});
				timer.start();
			}
			else
			{
				nameInput.nameContant.text = "";
				showNameError();
				_nameErrorTimer.stop();
				_nameErrorTimer.reset();
				_nameErrorTimer.start();
				trace("error");
			}
		}
		
		private function findSomeOne(name:String):Boolean
		{
			for each (var friName:String in friends)
			{
				if (friName == name)
				{
					return true;
				}
			}
			return false;
		}
		
		private function initBg():void
		{
			// create bitmap
			_outputBitmap = new BitmapData(GlobalUtil.W, GlobalUtil.H, true, 0x00000000);
			_bg = new Bitmap(_outputBitmap);
			addChild(_bg);
			
			// add a fader
			_fader = new Shape();
			_fader.graphics.beginFill(0x000000, 0.02);
			_fader.graphics.drawRect(0, 0, GlobalUtil.W, GlobalUtil.H);
		}
		
		// save the mouse point
		private function on_mouse_move(e:MouseEvent):void
		{
			
			if (!hasEventListener(Event.ENTER_FRAME))
			{
				addEventListener(Event.ENTER_FRAME, on_enter_frame);
			}
		}
		
		// update the bitmap
		private function on_enter_frame(e:Event):void
		{
			// fade out the bitmap
			_outputBitmap.draw(_fader);
		}
	}

}