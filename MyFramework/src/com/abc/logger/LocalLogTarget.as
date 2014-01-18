package lde.knobay.logs
{
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.sampler.getSize;
	
	import mx.formatters.DateFormatter;
	import mx.logging.AbstractTarget;
	import mx.logging.ILogger;
	import mx.logging.LogEvent;
	import mx.logging.LogEventLevel;
	import mx.utils.StringUtil;
	
	public class LocalLogTarget extends AbstractTarget
	{
		
		public static var bufferLimits:uint = 50;
		
		private static var logFile:File;
		
		private static var enabled:Boolean = true;
		
		private static var initialzed:Boolean = false;
		
		private static var traceMessagesArr:Array =[];
		private static var forceToWriteLog:Boolean = false;
		
		private static var logStream:FileStream;
		
		public function LocalLogTarget(level:uint)
		{
			super();
			this.level=level;
			initializeFileStream();
		}
		
		private function initializeFileStream():void
		{
			if(initialzed)
			{
				trace("------------------ logs folder and log files has been created --------------");
				return;
			}
			
			initialzed = true;
			
			var logFolder:File = File.applicationStorageDirectory.resolvePath("logs");
			
			if (!logFolder.exists)
				logFolder.createDirectory();
			
			var date:Date = new Date();			
			
			var session:String = CommonLogTargetUtils.logDateFormatter.format(date);			
			logFile = logFolder.resolvePath(session + ".log");
			
			logStream = new FileStream();
			logStream.open(logFile, FileMode.APPEND);	
		}
		
		/**
		 * @private
		 */
		override public function logEvent(event:LogEvent):void
		{
			writeLog(CommonLogTargetUtils.getObjectFromLogEvent(event));
		}
		
		private function writeLog(logData:Object):void
		{
			if (!enabled)
			{
				trace("---- Sorry not able to write log to file .Something went wrong ...! ------------");
				return;
			}		
			
			var traceMessage:String = CommonLogTargetUtils.getTraceMessage(logData);
			
			trace(traceMessage);
			
			//add to buffer array
			traceMessagesArr.push(traceMessage);
			
			var isNotWrite:Boolean = !(traceMessagesArr.length > bufferLimits || forceToWriteLog);
			
			if (isNotWrite && logStream)
			{
				return;
			}
			else
			{			
				writeLogFromBuffer();
			}
		}	
		
		/**
		 * 
		 * Call method when deactive flashplayer or when we want to write log from buffer we call this method 
		 * 
		 */		
		public static function forceToWriteLogFromBuffer():void
		{
			writeLogFromBuffer();
		}
		
		private static function writeLogFromBuffer():void
		{
			try
			{
				logStream.open(logFile, FileMode.APPEND);	
				
				for each (var traceStr:String in traceMessagesArr) 
				{
					logStream.writeUTFBytes(traceStr + "\r\n");						
				}
				
				// Clear trace message after write on files
				traceMessagesArr = [];	
				forceToWriteLog = false;
			}			
			catch (e:Error)
			{
				enabled = false;
				trace(e.message);
				trace(e.getStackTrace());
			}
			finally
			{
				logStream.close();
			}
		}		
	}
}