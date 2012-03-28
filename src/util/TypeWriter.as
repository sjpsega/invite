package util
{
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.TimerEvent;
    import flash.text.TextField;
    import flash.utils.Timer;
    
    /**
     * ...
     * @author jingping.shenjp
     */
    public class TypeWriter extends EventDispatcher
    {
        private var _text:TextField;
        private var _timer:Timer;
        private var _textCopy:String;
        private var _index:int;
        private var _pause:Boolean;
        
        public function TypeWriter(text:TextField)
        {
            _text = text;
        }
        
        public function init():void
        {
            _timer = new Timer(GlobalUtil.TYPEWRITER_TIMER);
            _timer.addEventListener(TimerEvent.TIMER, timerHandler);
            _timer.start();
            _textCopy = _text.text;
            _text.text = "";
        }
        
        private function timerHandler(e:TimerEvent):void
        {
            _pause = false;
            var tempStr:String = _textCopy.substr(_index, 1);
            if (tempStr == "\r" && !_pause)
            {
                _pause = true;
            }
            _text.text = _textCopy.substring(0, _index) + (_index & 1 ? "_" : "");
            _index++;
            if (_index == _textCopy.length - 1)
            {
                _timer.removeEventListener(TimerEvent.TIMER, timerHandler);
                dispatchEvent(new Event(Event.COMPLETE, true));
            }
        }
    
    }

}