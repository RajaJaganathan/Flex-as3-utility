/**
 * @author Raja.J 
 */
package lde.knobay.datalayer.utils
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class AutoSaveCommand
	{
		private var TIME_INTERVAL:int = 20000;
		private var timer:Timer;
		private var callback:Function;
		private var args:Array;
		
		public function AutoSaveCommand(callback:Function, ...args)
		{
			timer = new Timer(TIME_INTERVAL,0);
			timer.addEventListener(TimerEvent.TIMER, onTimerCompleteHandler);
			this.callback = callback;
			this.args = args;
		}
		
		public function start():void
		{
			if(timer)
				timer.start();
		}
		
		public function stop():void
		{
			if(timer)
				timer.stop();
		}
		
		public function dispose():void
		{
			if(timer)
			{
				timer.stop();
				timer = null;
			}
		}
		
		protected function onTimerCompleteHandler(event:TimerEvent):void
		{
			if(callback!=null)
				callback.apply(null,args);
		}
	}
}