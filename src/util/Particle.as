package util 
{
	/**
     * ...
     * @author jingping.shenjp
     */
    public class Particle 
    {
        public var color:uint;
        public var x:Number;
        public var y:Number;
        public var vx:Number;
        public var vy:Number;
        public var va:Number;
        
        public function Particle(color:uint,x:Number,y:Number, vx:Number = 0.5,vy:Number = 0.5, va:Number = -0.1) 
        {
            this.color = color;
            this.x = x;
            this.y = y;
            this.vx = vx;
            this.vy = vy;
            this.va = va;
        }
    }
}