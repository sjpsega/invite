package mvc.countdown
{
    import flash.display.Sprite;
    import flash.events.Event;
	import flash.text.AntiAliasType;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    
    /**
     * ...
     * @author jianping.shenjp
     */
    public class Countdown extends Sprite
    {
        static public const COLOR:uint = 0x3eaf1b;
        private var _hourTxt:TextField;
        private var _minTxt:TextField;
        private var _secTxt:TextField;
        
        private var _hourStrTxt:TextField;
        private var _minStrTxt:TextField;
        private var _secStrTxt:TextField;
        
        private var _countdownModel:CountdownModel;
        private var _countdownControl:CountdownControl;
        
        public function Countdown(countdownModel:CountdownModel = null, countdownControl:CountdownControl = null)
        {
            _countdownModel = countdownModel || new CountdownModel();
            _countdownControl = countdownControl || new CountdownControl(_countdownModel);
            mouseChildren = false;
            mouseEnabled = false;
            init();
        }
        
        private function init():void
        {
            _countdownModel.addEventListener(CountdownModel.TIME_CHANGE, timeChangeHandler);
            _countdownModel.addEventListener(CountdownModel.TIME_END, timeEndHandler);
            
            _hourTxt = getNewTimeTextField();
            _hourTxt.text = "0000";
            addChild(_hourTxt);
            
            _hourStrTxt = getNewTimeTextField();
            _hourStrTxt.text = "时";
            appendTextField(_hourStrTxt, _hourTxt);
            
            _minTxt = getNewTimeTextField();
            _minTxt.text = "00";
            appendTextField(_minTxt, _hourStrTxt);
            
            _minStrTxt = getNewTimeTextField();
            _minStrTxt.text = "分";
            appendTextField(_minStrTxt, _minTxt);
            
            _secTxt = getNewTimeTextField();
            _secTxt.text = "00";
            appendTextField(_secTxt, _minStrTxt);
            
            _secStrTxt = getNewTimeTextField();
            _secStrTxt.text = "秒";
            appendTextField(_secStrTxt, _secTxt);
        }
        
        public function get countdownModel():CountdownModel
        {
            return _countdownModel;
        }
        
        public function get countdownControl():CountdownControl
        {
            return _countdownControl;
        }
        
        public function getFormatEndTime():String
        {
            return _hourTxt.text + "时" + _minTxt.text + "分" + _secTxt.text + "秒";
        }
        
        private function appendTextField(textField:TextField, frontTextField:TextField):void
        {
            addChild(textField);
            textField.x = frontTextField.x + frontTextField.textWidth;
        }
        
        private function timeEndHandler(e:Event):void
        {
            _countdownModel.removeEventListener(CountdownModel.TIME_CHANGE, timeChangeHandler);
        }
        
        private function timeChangeHandler(e:Event):void
        {
            timeFormat(_countdownModel.lasttime);
        }
        
        private function timeFormat(lastTime:Number):void
        {
            var temp:Number = lastTime / 1000;
            var hour:int = temp / (60 * 60);
            temp -= hour * 60 * 60;
            var min:int = temp / 60;
            temp -= min * 60;
            var sec:int = temp >> 0;
            
            _hourTxt.text = timestrFormat(hour);
            _minTxt.text = timestrFormat(min);
            _secTxt.text = timestrFormat(sec);
        }
        
        private function timestrFormat(value:int):String
        {
            var returnValue:String = "";
            if (value < 10)
            {
                returnValue = "0" + value
            }
            else
            {
                returnValue = value + "";
            }
            return returnValue;
        }
        
        static public function getNewTimeTextField():TextField
        {
            var text:TextField = new TextField();
            text.defaultTextFormat = getTextFormat();
            text.selectable = false;
			//这里很奇怪，使用embedFonts = true，嵌入字体失败，不设置嵌入字体成功；跟之前的经验不一样……
            //text.embedFonts = true;
            text.antiAliasType = AntiAliasType.ADVANCED;
            text.autoSize = TextFieldAutoSize.LEFT;
            return text;
        }
        
        static public function getTextFormat(size:int = 28, color:uint = Countdown.COLOR):TextFormat
        {
            var textFormat:TextFormat = new TextFormat();
            textFormat.size = size;
            textFormat.color = color;
            textFormat.bold = true;
            textFormat.leftMargin = 12;
            textFormat.font = "DS-Digital";
            return textFormat;
        }
    }

}