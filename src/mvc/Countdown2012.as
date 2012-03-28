package mvc
{
    import flash.display.Graphics;
    import flash.display.GraphicsPathCommand;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.TimerEvent;
    import flash.text.TextField;
    import flash.utils.Timer;
    import mvc.countdown.Countdown;
    import util.GlobalUtil;
    
    /**
     * ...
     * @author jianping.shenjp
     */
    public class Countdown2012 extends Sprite
    {
        private var _countdown:Countdown; //倒计时
        private var _countdownTimer:Timer; //倒计时计时器
        
        private var _titleTxt:TextField;
        private var _endTime:Date; //倒计时最终时间点
        private var _targetTime:Date; //倒计时目标时间点，到该事件就不再进行倒计时
        
        public function Countdown2012(endTime:Date, targetTime:Date = null)
        {
            super();
            _endTime = endTime;
            _targetTime = targetTime;
            addTitle();
            addCountdownAndTimer();
            addBorder();
        }
        
        public function getFormatEndTime():String
        {
            return _countdown.getFormatEndTime();
        }
        
        private function addCountdownAndTimer():void
        {
            _countdown = new Countdown();
            _countdown.countdownModel.lasttime = _endTime.getTime() - (new Date()).getTime();
            if (_targetTime)
            {
                _countdown.countdownModel.targetTime = _endTime.getTime() - _targetTime.getTime();
            }
            addChild(_countdown);
            _countdown.y = _titleTxt.textHeight;
            _countdownTimer = new Timer(GlobalUtil.TIMER_DELAY);
            _countdownTimer.addEventListener(TimerEvent.TIMER, countdownTimerHandler);
            _countdownTimer.start();
        }
        
        private function countdownTimerHandler(e:TimerEvent):void
        {
            _countdown.countdownModel.changeLasttime(GlobalUtil.TIME_NUMBER);
        }
        
        private function addTitle():void
        {
            _titleTxt = Countdown.getNewTimeTextField();
            _titleTxt.text = "2012世界末日倒计时:"
            addChild(_titleTxt);
        }
        
        private function addBorder():void
        {
            var shape:Shape = new Shape();
            var g:Graphics = shape.graphics;
            g.lineStyle(3, Countdown.COLOR);
            g.drawRect(0, 0, this.width, this.height);
            g.endFill();
            addChild(shape);
        }
    }

}