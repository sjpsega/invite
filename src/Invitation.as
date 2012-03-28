package
{
	import animate.HeartShow;
	import animate.ImgAnimate;
	import animate.ImgAnimate2;
	import com.adobe.images.JPGEncoder;
	import com.greensock.data.TweenLiteVars;
	import com.greensock.data.TweenMaxVars;
	import com.greensock.easing.Elastic;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	import interfaces.IControl;
	import interfaces.ISaveName;
	import util.GlobalUtil;
	import view.SaveBtn;
	
	/**
	 * 请帖页面
	 * @author jingping.shenjp
	 */
	public class Invitation extends Sprite implements IControl, ISaveName
	{
		private var w:Number = GlobalUtil.W;
		private var h:Number = GlobalUtil.H;
		private const IMG_ADDRESS:String = "../assets/wedding.jpg";
		private const MUSIC_ADDRESS:String = "../assets/perfect moment.mp3";
		private var _img:DisplayObject;
		private var _imgLoad:Loader;
		private var _musicLoad:Sound;
		private var invitationContainer:Sprite;
		private var saveBtn:SaveBtn;
		private var imgAnimate:ImgAnimate2;
		private var _saveName:String = "";
		private var _music:SoundChannel;
		private var _isStart:Boolean;
		private var _loading:Loading;
		
		public function Invitation()
		{
			TweenPlugin.activate([AutoAlphaPlugin]);
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
			loadMusic();
		}
		
		public function start():void
		{
			_isStart = true;
			playMusic();
			setTimeout(playImg, 5000);
		}
		
		public function saveName(name:String):void
		{
			_saveName = name;
		}
		
		private function newLoading():void 
		{
			_loading = new Loading();
			addStageCenter(_loading);
		}
		
		private function addSaveBtn():void
		{
			saveBtn = new SaveBtn();
			saveBtn.x = w - saveBtn.width - 30;
			saveBtn.y = h - saveBtn.height - 10;
			addChild(saveBtn);
			saveBtn.addEventListener(MouseEvent.CLICK, saveInviatationHandler);
		}
		
		private function saveInviatationHandler(e:MouseEvent):void
		{
			var bpd:BitmapData = new BitmapData(w, h);
			bpd.draw(invitationContainer);
			var ba:ByteArray = (new JPGEncoder(80)).encode(bpd);
			var file:FileReference = new FileReference();
			file.save(ba, "沈剑平 魏超君请帖for" + _saveName + ".jpg");
		}
		
		private function loadImg():void
		{
			_imgLoad = new Loader();
			_imgLoad.contentLoaderInfo.addEventListener(Event.COMPLETE, imgComplateHanlder);
			_imgLoad.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHanlder);
			_imgLoad.load(new URLRequest(IMG_ADDRESS));
		}
		
		private function ioErrorHanlder(e:IOErrorEvent):void
		{
			trace("io:", e.toString());
		}
		
		private function imgComplateHanlder(e:Event):void
		{
			removeChild(_loading);
			_loading = null;
			_img = _imgLoad.content;
			if (_isStart)
			{
				playImg();
			}
		}
		
		private function loadMusic():void
		{
			_musicLoad = new Sound();
			_musicLoad.addEventListener(Event.COMPLETE, musicCompleteHandler);
			_musicLoad.load(new URLRequest(MUSIC_ADDRESS));
		}
		
		private function musicCompleteHandler(e:Event):void
		{
			if (_isStart)
			{
				playMusic();
			}
			loadImg();
		}
		
		private function playImg():void
		{
			if (!imgAnimate)
			{
				imgAnimate = new ImgAnimate2();
				imgAnimate.drawSource(_img);
				addChild(imgAnimate);
				imgAnimate.start();
				imgAnimate.addEventListener(ImgAnimate.ANIMATE_END, next);
			}
		}
		
		private function next(e:Event):void
		{
			imgAnimate.dispose();
			removeChild(imgAnimate);
			imgAnimate = null;
			addSaveBtn();
			invitationContainer = new Sprite();
			invitationContainer.mouseEnabled = false;
			addChild(invitationContainer);
			_img.alpha = 0.3;
			invitationContainer.addChild(_img);
			var contant:InvitationContant = new InvitationContant();
			contant.x = (w - contant.width) / 2;
			contant.y = (h - contant.height) / 2;
			invitationContainer.addChild(contant);
			
			contant.toContant.text = _saveName;
			var format:TextFormat = new TextFormat();
			format.bold = true;
			contant.toContant.setTextFormat(format);
			
			var timeline:TimelineLite = new TimelineLite();
			timeline.append(TweenLite.from(_img, 1, new TweenLiteVars().autoAlpha(1)));
			timeline.insertMultiple(TweenMax.allFrom(getChildren(contant.bigtitle), 0.5, new TweenMaxVars().y(-30).autoAlpha(0).ease(Elastic.easeOut), 0.04), timeline.duration);
			timeline.insertMultiple(TweenMax.allFrom(getChildren(contant.to), 0.5, new TweenMaxVars().y(-30).autoAlpha(0).ease(Elastic.easeOut), 0.04), timeline.duration + 0.5);
			timeline.insertMultiple(TweenMax.allFrom(getChildren(contant.time), 0.5, new TweenMaxVars().y(-30).autoAlpha(0).ease(Elastic.easeOut), 0.04), timeline.duration);
			timeline.insertMultiple(TweenMax.allFrom(getChildren(contant.address), 0.5, new TweenMaxVars().y(-30).autoAlpha(0).ease(Elastic.easeOut), 0.04), timeline.duration);
			timeline.insertMultiple(TweenMax.allFrom(getChildren(contant.addressTo), 0.5, new TweenMaxVars().y(-30).autoAlpha(0).ease(Elastic.easeOut), 0.04), timeline.duration);
			timeline.insertMultiple(TweenMax.allFrom(getChildren(contant.from), 0.5, new TweenMaxVars().y(-30).autoAlpha(0).ease(Elastic.easeOut), 0.04), timeline.duration);
			var contants:Array = [];
			contants.push(contant.toContant);
			contants.push(contant.timeContant);
			contants.push(contant.addressContant);
			contants.push(contant.addressToContant);
			contants.push(contant.fromContant);
			timeline.insertMultiple(TweenMax.allFrom(contants, 1, new TweenMaxVars().x(30).autoAlpha(0), 0.5), timeline.duration);
			timeline.append(TweenLite.from(saveBtn, 1, new TweenLiteVars().autoAlpha(0).delay(1).onComplete(function():void
				{
					var heart:HeartShow = new HeartShow();
					heart.start();
					addChild(heart);
				})));
		}
		
		private function playMusic():void
		{
			if (!_music)
			{
				_music = _musicLoad.play();
			}
		}
		
		private function getChildren(doc:DisplayObjectContainer):Array
		{
			var children:Array = [];
			for (var i:int = doc.numChildren - 1; i >= 0; i--)
			{
				children.push(doc.getChildAt(i));
			}
			return children;
		}
	}

}