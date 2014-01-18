package lde.knobay.logs
{
	import flash.utils.getQualifiedClassName;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.logging.LogEventLevel;
	
	public class LoggerFactory
	{
		public function LoggerFactory()
		{
		}
		
		public static function getLogger(c:Class):ILogger 
		{
			var className:String =  getQualifiedClassName(c).replace("::", ".")
			return Log.getLogger(className);
		}	
	}
}

/*   USAGE


	Listen deactivate event
-------------------------------

	RemoteLogTarget.forceToWriteLogFromBuffer();
	LocalLogTarget.forceToWriteLogFromBuffer();


	private static const log:ILogger = LoggerFactory.getLogger(ClassName);

	private function preinitialzeRemoteTarget():void
	{
		var target:RemoteLogTarget = new RemoteLogTarget();
		RemoteLogTarget.bufferLimits = 50;
		target.level = LogEventLevel.ALL;
		Log.addTarget(target);
	}

	private function preinitialzeLocalTarget():void
	{
		var target:LocalLogTarget = new LocalLogTarget();
		LocalLogTarget.bufferLimits = 50;
		target.level  = LogEventLevel.ALL;
		Log.addTarget(target);
	}

	public function onCreationComplete():void
	{
		for (var i:int = 0; i < 100; i++) 
		{
			log.info("------ My local trace message ------{0}-------",i);
		}
	}
 

*/