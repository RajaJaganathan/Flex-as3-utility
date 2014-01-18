package ro.badu.utils.xml
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
		
	CONFIG::DEBUG
	{
		import ro.badu.utils.debug.Tracer;
	}
	
	public class XMLService extends URLLoader
	{
		private var _callback : Function;
		
		private var _result : XML;

		public function get result():XML
		{
			return _result;
		}		
		
		public function XMLService(request:URLRequest=null)
		{
			super(request);
		}
		
		public function get( file : String , callback : Function = null ):void
		{
			var _request : URLRequest = new URLRequest(file);
			dataFormat = URLLoaderDataFormat.TEXT;
			_callback = callback;
			mountListeners(true);
			load(_request);
		}
		
		protected function mountListeners( isMount : Boolean = false ):void
		{
			if (isMount)
			{
				addEventListener(IOErrorEvent.IO_ERROR , onIoError);
				addEventListener(Event.COMPLETE , onComplete);
				addEventListener(SecurityErrorEvent.SECURITY_ERROR , onSecurityError);
			}
			else
			{
				removeEventListener(IOErrorEvent.IO_ERROR , onIoError);
				removeEventListener(Event.COMPLETE , onComplete);
				removeEventListener(SecurityErrorEvent.SECURITY_ERROR , onSecurityError);
			}
		}
		
		protected function onIoError(e:IOErrorEvent):void
		{
			mountListeners();
				trace(new Error() , "ERROR :"+ e.text);
			}
		
		protected function onSecurityError(e:SecurityErrorEvent):void
		{
			mountListeners();
			if (CONFIG::DEBUG)
			{
				Tracer.log(new Error(), "ERROR :"+ e.text);
			}
		}
		
		protected function onComplete(e:Event):void
		{			
			mountListeners();
			try
			{
				_result = XML(data);
			}
			catch(er:Error)
			{
				//probably a malformed XML
				if (CONFIG::DEBUG)
				{
					Tracer.log(new Error(), "ERROR :"+ er.message);
				}		
			}
			if(_callback!=null) _callback.call(null,this);
		}
	}
}


/* USAGE

	var _service : XMLService = new XMLService();
	_service.get( configFile , getXMLResultHandler);
				
	function getXMLResultHandler(loader:XMLService):void
	{
		var xml:XML = loader.result;
	}

*/