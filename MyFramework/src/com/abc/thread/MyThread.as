package
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class MyThread
	{
		private var timer:Timer;
		
		private var minLoopTimes:int = 0;		
		private var maxLoopTimes:int;		
		public var callFunc:Function;
		
		public function MyThread(maxLoopTimes:int)
		{
			this.maxLoopTimes = maxLoopTimes;
			timer = new Timer(1,0);
			timer.addEventListener(TimerEvent.TIMER,onTimerEvent);
		}
		
		private function onTimerEvent(event:TimerEvent):void
		{
			minLoopTimes ++;
			if(minLoopTimes > maxLoopTimes)
				timer.stop();
			
			callFunc.call();
		}		
		
		public function start(callFunc:Function):void
		{
			this.callFunc = callFunc;
			timer.start();
		}
	}
}