package
{
	import com.greensock.data.TweenLiteVars;
	import com.greensock.easing.Cubic;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.plugins.VolumePlugin;
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.setTimeout;
	import interfaces.IControl;
	import interfaces.ISaveName;
	import mvc.Countdown2012;
	import util.GlobalUtil;
	import util.TypeWriter;
	
	/**
	 * 主界面
	 * @author jianping.shenjp
	 */
	public class Main extends Sprite implements IControl,ISaveName
	{
		private var w:Number = GlobalUtil.W;
		private var h:Number = GlobalUtil.H;
		private var _beginSound:Sound;
		private var _bgeinMusic:SoundChannel;
		private var countdown2012:Countdown2012;
		private var typeWriter:TypeWriter;
		private var text:TextField;
		private var bg:Shape;
		private var timeline:TimelineLite;
		private var invitation:Invitation;
		private var _isStart:Boolean = false;
		private var _beginMusicLoaded:Boolean = false;
		private var _saveName:String;
		private var _loading:Loading;
		
		
		public function Main()
		{
			//loadAssets();
			//start();
			newLoading();
		}
		
		public function addStageCenter(dis:DisplayObject):void
		{
			dis.x = (w - dis.width) / 2;
			dis.y = (h - dis.height) / 2;
			addChild(dis);
		}
		
		public function loadAssets():void 
		{
			loadBeginMusic();
		}
		
		public function start():void 
		{
			_isStart = true;
			init(null);
			if (_beginMusicLoaded)
			{
				playContant();
			}
		}
		
		public function saveName(name:String):void 
		{
			_saveName = name;
		}
		
		private function init(e:Event = null):void
		{
			deployTweenPlugin();
		}
		
		private function newLoading():void 
		{
			_loading = new Loading();
			addStageCenter(_loading);
		}
		
		private function addGradientBg():void
		{
			bg = new Shape();
			var g:Graphics = bg.graphics;
			var mtx:Matrix = new Matrix();
			mtx.createGradientBox(w, h, 0, 0, 0);
			g.beginGradientFill(GradientType.RADIAL, [0x666666, 0x333333], [1, 1], [0, 255], mtx);
			g.drawRect(0, 0, w, h);
			g.endFill();
			addStageCenter(bg);
		}
		
		private function deployTweenPlugin():void
		{
			TweenPlugin.activate([AutoAlphaPlugin,VolumePlugin]);
		}
		
		private function loadBeginMusic():void
		{
			_beginSound = new Sound();
			_beginSound.load(new URLRequest("../assets/begin.mp3"));
			_beginSound.addEventListener(Event.COMPLETE, loadBeginMusicCompleteHandler);
		}
		
		private function loadBeginMusicCompleteHandler(e:Event = null):void
		{
			removeChild(_loading);
			_loading = null;
			_beginMusicLoaded = true;
			newInvitationAndLoad();
			if (_isStart)
			{
				playContant();
			}
		}
				
		private function playContant():void 
		{
			invitation.saveName(_saveName);
			_bgeinMusic = _beginSound.play();
			addGradientBg();
			addCountdown2012();
			addTypeWriter();
			tween();
		}
		
		private function newInvitationAndLoad():void 
		{
			invitation = new Invitation();
			invitation.loadAssets();
		}
		
		private function addCountdown2012():void
		{
			countdown2012 = new Countdown2012(new Date(2012, 11, 12), new Date(2012, 2, 30, 18, 18));
			addStageCenter(countdown2012);
		}
		
		private function addTypeWriter():void
		{
			text = new TextField();
			text.width = w * 0.9;
			text.height = h / 2;
			text.defaultTextFormat = getDefaultFormat();
			text.text = GlobalUtil.TEXT;
			addStageCenter(text);
			text.visible = false;
			typeWriter = new TypeWriter(text);
		}
		
		private function getDefaultFormat():TextFormat
		{
			var tf:TextFormat = new TextFormat();
			tf.bold = true;
			tf.align = TextFormatAlign.LEFT;
			tf.size = 20;
			tf.color = 0xA9EDF7;
			return tf;
		}
		
		private function tween():void
		{
			timeline = new TimelineLite();
			timeline.append(TweenLite.from(bg, 1, new TweenLiteVars().autoAlpha(0)));
			timeline.append(new TweenLite(countdown2012, 5, new TweenLiteVars()));
			timeline.append(new TweenLite(countdown2012, 0.3, new TweenLiteVars().ease(Cubic.easeInOut).autoAlpha(0.1)));
			timeline.append(new TweenLite(countdown2012, 0.4, new TweenLiteVars().ease(Cubic.easeInOut).autoAlpha(1)));
			timeline.append(new TweenLite(countdown2012, 0.3, new TweenLiteVars().ease(Cubic.easeInOut).autoAlpha(0.1)));
			timeline.append(new TweenLite(countdown2012, 0.4, new TweenLiteVars().ease(Cubic.easeInOut).autoAlpha(1)));
			timeline.append(new TweenLite(countdown2012, 0.6, new TweenLiteVars().autoAlpha(0)));
			timeline.append(new TweenLite(text, 1, {onStart: function():void
				{
					text.text = GlobalUtil.TEXT.replace("#EndTime#", countdown2012.getFormatEndTime());
					text.visible = true;
					typeWriter.init();
					typeWriter.addEventListener(Event.COMPLETE, typeWriterCompleteHandler);
				}}));
		}
		
		private function typeWriterCompleteHandler(e:Event):void
		{
			timeline.clear();
			timeline = new TimelineLite();
			timeline.append(new TweenLite(text, 1, new TweenLiteVars().autoAlpha(0)));
			timeline.append(new TweenLite(bg, 1, new TweenLiteVars().autoAlpha(0.4).onStart(function():void
			{
				TweenLite.to(_bgeinMusic, 2, { volume:0 } );
				//请帖中的音乐前奏较长，故提前start时间
				addChild(invitation);
				invitation.start();
			})));
		}
	}
}