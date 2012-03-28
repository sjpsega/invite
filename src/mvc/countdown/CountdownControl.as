package mvc.countdown
{
    
    /**
     * ...
     * @author jianping.shenjp
     */
    public class CountdownControl
    {
        private var _countdownModel:CountdownModel;
        
        public function CountdownControl(countdownModel:CountdownModel)
        {
            _countdownModel = countdownModel;
        }
        
        public function changeLasttime(value:Number):void
        {
            _countdownModel.changeLasttime(value);
        }
    }

}