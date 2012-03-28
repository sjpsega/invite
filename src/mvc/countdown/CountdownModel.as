package mvc.countdown
{
    import flash.events.Event;
    import flash.events.EventDispatcher;
    
    /**
     * ...
     * @author jianping.shenjp
     */
    public class CountdownModel extends EventDispatcher
    {
        static public const TIME_CHANGE:String = "time_change";
        static public const TIME_END:String = "time_end";
        private var _targetTime:Number = -1; //倒计时目标时间点，到该事件就不再进行倒计时
        private var _lasttime:Number = 0.0;
        private var _isGetTargetTime:Boolean = false;
		
        public function CountdownModel()
        {
        
        }
        
        public function changeLasttime(value:Number):void
        {
            //若有倒计目标时间点， 且被设置，倒计时小于该时间时，倒计时时间==倒计目标时间点
            if (_targetTime && lasttime < _targetTime)
            {
                lasttime = _targetTime;
				_isGetTargetTime = true;
                return;
            }
			if (!_isGetTargetTime)
			{
				lasttime -= value;
			}
        }
        
        public function get lasttime():Number
        {
            return _lasttime;
        }
        
        public function set targetTime(value:Number):void
        {
            _targetTime = value;
        }
        
        public function set lasttime(value:Number):void
        {
            if (_lasttime == value)
            {
                return;
            }
            _lasttime = value;
            dispatchEvent(new Event(CountdownModel.TIME_CHANGE));
            if (_lasttime <= 0.0)
            {
                dispatchEvent(new Event(CountdownModel.TIME_END));
            }
        }
    }

}