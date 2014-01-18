/**
 * @author Mirko Bordjoski http://candymandesign.blogspot.com
 */ 
package com.candymandesign.utils
{
	
	import flash.events.TimerEvent;
	import flash.net.LocalConnection;
	import flash.system.System;
	import flash.utils.Timer;	
	import mx.core.FlexGlobals;

	
	
	
	/**
	 * Force garbage collection.
	 * Use it only in development - NEVER in production.
	 * Usage:
	 * <listing><code>
	 * 
	 * import com.candymandesign.utils.GarbageCollectionRunner;
	 * 
	 * GarbageCollectionRunner.run();
	 * 
	 * </code></listing>
	 */ 
	public class GarbageCollectionRunner
	{		
		
		/**
		 * @private
		 */ 
		private static var _timer:Timer;
		
		
			
		
		/**
		 * Force garbage collection.
		 * This is static class. 
		 * Use it only in development - NEVER in production.
		 * Usage:
		 * <listing><code>
		 * 
		 * import com.candymandesign.utils.GarbageCollectionRunner;
		 * 
	 	 * GarbageCollectionRunner.run();
	 	 * 
	 	 * </code></listing>
		 */ 
		public function GarbageCollectionRunner(){}
		
		
		
		
		
		
		/////////////////////////////// PUBLIC METHODS /////////////////////////////////
		
		
		
		
		/**
		 * Start the engine.
		 * @param timeIntervalInSeconds - Time in seconds. Tell to garbage man when to return back.
		 */ 
		public static function run(timeIntervalInSeconds:Number = 15):void
		{			
			gaForcer();
			var intervalInMiliseconds:Number = timeIntervalInSeconds * 1000;
			_timer = new Timer(intervalInMiliseconds);
			_timer.addEventListener(TimerEvent.TIMER,gaForcer,false,0,true);
			_timer.start();
		}
		
		
		
		
		/**
		 * Stops the engine.
		 */ 
		public static function stop():void
		{
			if(_timer != null){
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER,gaForcer);
				_timer = null;
			}
		}
		
		
		
		
		
		////////////////////////////// PRIVATE METHODS //////////////////////////
		
		
		
		
		/**
		 * @private
		 * Forces garbage collection.
		 */ 
		private static function gaForcer(e:TimerEvent = null):void
		{
			trace("System Memory before forcing: " + System.totalMemory );	
			
			try
			{
				new LocalConnection().connect("GarbageCollectionRunnerHack");
				new LocalConnection().connect("GarbageCollectionRunnerHack");
			}
			catch(e:Error)
			{
				FlexGlobals.topLevelApplication.callLater(memoryDump);
			}
		}
		
		
		/**
		 * @private
		 */ 
		private static function memoryDump():void
		{
			trace("System Memory after garbage collector: " + System.totalMemory);
		}
		
		
	}
}