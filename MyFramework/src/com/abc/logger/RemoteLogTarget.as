package lde.knobay.logs
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	import mx.logging.AbstractTarget;
	import mx.logging.ILogger;
	import mx.logging.LogEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	import mx.utils.StringUtil;
	
	public class RemoteLogTarget extends AbstractTarget
	{
		/**
		 * Flag to indicate whether remote logging is enabled
		 * or not.  The RemoteTarget will automatically disable
		 * itself if it encounters any errors.
		 */
		private static var enabled:Boolean = true;
		
		public static var bufferLimits:uint = 50;
		
		private static var traceMessagesArr:Array =[];
		private static var forceToWriteLog:Boolean = false;
		
		private static var urlRequest:URLRequest;
		private static var urlLoader:URLLoader;
		private static var vars:URLVariables;
		
		private static var url:String = "http://localhost/logger.php";
		
		/**
		 * Constructor
		 */
		public function RemoteLogTarget()
		{
			super();
		}
		
		override public function logEvent(event:LogEvent):void
		{
			var traceObj:Object = CommonLogTargetUtils.getObjectFromLogEvent(event);
			var traceMsg:String = CommonLogTargetUtils.getTraceMessage(traceObj);
			
			//Console output here
			trace(traceMsg);
			
			traceMessagesArr.push(traceMsg);
			
			if(isAbleToWriteLog)
			{
				writeLog();
			}			
		}
		
		private static function get isAbleToWriteLog():Boolean
		{
			return bufferLimits < traceMessagesArr.length
		}
		
		public static function forceToWriteLogFromBuffer():void
		{
			if(traceMessagesArr.length <= 0)
				return;
			
			writeLog();			
		}
		
		private static function writeLog():void
		{
			// if there has been any issue with remote logging
			if (!enabled)
				return;
			
			// if no url is set then do nothing
			if (!url || StringUtil.trim(url).length == 0)
				return;
			
			if (urlRequest == null) 
			{
				urlRequest = new URLRequest(url);
				urlRequest.method = "POST";
			}
			
			if (urlLoader == null) 
			{
				urlLoader = createLoader();
			}
			
			if (vars == null) 
			{
				vars = new URLVariables();
			}
			
			if(urlLoader && urlRequest && vars)
			{
				vars.message = traceMessagesArr.toString();
				urlRequest.data = vars;	
				urlLoader.load(urlRequest);
				//clear trace messages
				traceMessagesArr = [];
			}
			
		}
		
		/**
		 * Creates a URLLoader with all the appropriate event listeners.
		 */
		private static function createLoader():URLLoader
		{
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler,	false, 0, true);
			loader.addEventListener(Event.COMPLETE,onCompleteHandler,	false, 0, true);
			return loader;
		}
		
		private static function onCompleteHandler(event:Event):void
		{
			trace("log suceesfully on server");			
		}
		
		private static function ioErrorHandler(event:IOErrorEvent):void
		{
			enabled = false;
			trace("ERROR - IO error in RemoteTarget");
			trace(event.text);
		}
		
		private static function securityErrorHandler(event:SecurityErrorEvent):void
		{
			enabled = false;
			trace("ERROR - Security error in RemoteTarget");
			trace(event.text);
		}
	}	
}