package dk.sebb.util
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class ShakeEffect
	{
		private var coordX:Number = 0;  
		private var coordY:Number = 0;
		private var timer:Timer = new Timer(10);
		
		public var offSetX:int = 0;
		public var offSetY:int = 0;
		
		public var magnitude:Number = 5;
		
		public function ShakeEffect() {
			timer.addEventListener(TimerEvent.TIMER, shakeImage);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, stop);
		}
		
		public function start(magnitude:int = 5, delay:int = 5, repeatCount:int = 20):void{
			offSetX = 0;
			offSetY = 0;
			
			this.magnitude = magnitude;
			
			timer.delay = delay;
			timer.repeatCount= repeatCount;
			timer.reset();
			timer.start();
		}
		
		public function stop(evt:Event = null):void{
			timer.stop();
		}
		
		private function shakeImage(event:Event):void {  
			offSetX = coordX+ getMinusOrPlus()*(Math.random()*magnitude);  
			offSetY = coordY+ getMinusOrPlus()*(Math.random()*magnitude); 
		}
		
		private function getMinusOrPlus():int{
			var rand : Number = Math.random()*2;
			if (rand<1) return -1
			else return 1;
		}   
	}
}