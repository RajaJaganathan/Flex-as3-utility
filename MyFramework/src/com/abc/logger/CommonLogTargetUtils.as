package lde.knobay.logs
{
	import mx.formatters.DateFormatter;
	import mx.logging.ILogger;
	import mx.logging.LogEvent;
	import mx.logging.LogEventLevel;
	import mx.rpc.http.HTTPService;

	public class CommonLogTargetUtils
	{
		public static const logFileDatePattern:String = "DD-MM-YYYY";
		public static const logDateTimePattern:String = "DD-MM-YYYY HH:NN:SS AA";
		
		public static var logDateFormatter:DateFormatter = new DateFormatter();
		public static var logDateTimeFormatter:DateFormatter =  new DateFormatter();
		
		// Static initializer
		{
			logDateFormatter.formatString = logFileDatePattern;
			logDateTimeFormatter.formatString = logDateTimePattern;
		}
		
		public function CommonLogTargetUtils()
		{
			
		}
		
		public static function getObjectFromLogEvent(event:LogEvent):Object
		{
			var logData:Object = {};	
			
			logDateTimeFormatter.formatString = logDateTimePattern;
			
			logData.level =  event.level;
			logData.category = ILogger(event.target).category;
			logData.timestamp = logDateTimeFormatter.format(new Date());
			logData.message = event.message;
			
			return logData;			
		}
		
		public static function getTraceMessage(logMessageObj:Object):String
		{
			return logMessageObj.timestamp + " [" + CommonLogTargetUtils.getLevelString(logMessageObj.level)  + "]  "  + logMessageObj.category  + " " + logMessageObj.message ;		
		}
		
		
		public static function getLevelString(level:uint):String
		{
			switch(level)
			{
				case LogEventLevel.ALL:
					return "ALL";
				case LogEventLevel.DEBUG:
					return "DEBUG";
				case LogEventLevel.ERROR:
					return "ERROR";
				case LogEventLevel.FATAL:
					return "FATAL";
				case LogEventLevel.INFO:
					return "INFO";
				case LogEventLevel.WARN:
					return "WARN";
				default:
					return "ALL";
			}			
		}
	}
}