package lde.knobay.plugins.common
{
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	public class DelayedCall
	{
		protected static var scheduledCalls:Dictionary = new Dictionary();
		
		protected var func:Function = null;
		
		protected var args:Array = null;
		
		protected var scope:Object = null;

		public function DelayedCall()
		{
			super();
		}
		
		/**
		 * Schedule a delayed function or method call.
		 * 
		 * @param func  The function or class method to call.
		 * @param args  The parameters to pass to the function / class method.
		 * @param delay The time in milliseconds to delay before making the function / class method call.
		 */
		public static function schedule( func:Function, args:Array, delay:Number, scope:Object=null ):void
		{
			var call:DelayedCall = new DelayedCall();
			
			call.initiate( func, args, delay, scope );
			
			// Grab a reference so the call doesn't get prematurely garbage-collected
			
			scheduledCalls[ call ] = call;
		}
		
		/**
		 * Release reference to a completed DelayedCall instance.
		 */
		protected static function release( call:DelayedCall ):void
		{
			// Release reference so that call can be garbage-collected
			
			delete scheduledCalls[ call ];
		}
		
		/**
		 * Initiate a delayed call.
		 */
		protected function initiate( func:Function, args:Array, delay:Number, scope:Object=null ):void
		{
			this.func = func;
			this.args = args || [ ];
			this.scope= scope;
			
			// Create and start a timer
			
			var timer:Timer = new Timer( delay, 1 );
			timer.addEventListener( TimerEvent.TIMER_COMPLETE, timerCompleteHandler );
			
			timer.start();		
		}
		
		/**
		 * Handle TimerEvent.TIMER_COMPLETE - execute the delayed call.
		 */
		protected function timerCompleteHandler( event:TimerEvent ):void
		{
			var timer:Timer = event.target as Timer;
			timer.removeEventListener( TimerEvent.TIMER_COMPLETE, timerCompleteHandler );
			
			// Execute the delayed function call
			
			if ( func != null )
				func.apply( scope, args );
			
			release( this );
		}
	}
}