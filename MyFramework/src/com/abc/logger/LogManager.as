package com.xinote.logger
{
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import mx.controls.Alert;
	import mx.formatters.DateFormatter;
	
	public class LogManager
	{
		private var logStream:FileStream
		private static var logManager:LogManager
		private static var initialzed:Boolean = false
		private static var dateFormatter:DateFormatter =  new DateFormatter();
		
		
		public static const CRITICAL_ERR:String = "Critical Error :: ";
		
		public function LogManager()
		{
			if (initialzed)
			{
				trace("You cannot instantiate this Singleton Static class.")
				trace("Use LogManager.log() from any of your class.")
				return;
			}
			
			var logFolder:File = File.applicationStorageDirectory.resolvePath("logs");
			
			if (!logFolder.exists)
				logFolder.createDirectory();
			
			var date:Date = new Date();			
			dateFormatter.formatString = "DD-MM-YYYY";
			var session:String = dateFormatter.format(date);			
			var logFile:File = logFolder.resolvePath(session + ".log");
			
			logStream = new FileStream();
			logStream.open(logFile, FileMode.APPEND);
			
			initialzed = true;
			
			if (!logManager)
				logManager = this;
		}
		
		public static function log(... args):void
		{
			if (!logManager)
				logManager = new LogManager()
			
			if (logManager.logStream)
			{
				var logMessage:String = "";
				var now:Date = new Date();
				
				
				for (var i:int = 0; i < args.length; i++)
				{
					logMessage += String(args[i]) + " ; ";
				}
				
				logManager.logStream.writeUTFBytes(now.toString() + " :: " + logMessage + "\r\n");
			}
		
		}	
	
	}
}

