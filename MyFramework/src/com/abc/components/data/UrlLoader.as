package bloom.components.data
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	[Event(name="complete", type="flash.events.Event")]
	public class UrlLoader extends EventDispatcher
	{
		protected var loader:flash.net.URLLoader;
		
		private var _url:String;
		[Bindable(event="urlChange")]
		/**
		 *  Url data
		 */
		public function get url():String
		{
			return _url;
		}
		public function set url(value:String):void
		{
			if (_url == value) 
				return;
			_url = value;
			dispatchBindingEvent("urlChange");
		}
		
		private var _format:String = "xml";
		[Inspectable(category="General", enumeration="xml,text,raw", default="xml")]
		[Bindable(event="formatChange")]
		/**
		 *  Format of the result
		 */
		public function get format():String
		{
			return _format;
		}
		public function set format(value:String):void
		{
			if (_format == value) 
				return;
			_format = value;
			dispatchBindingEvent("formatChange");
		}
	
		private var _requestFormat:String = "text";
		[Inspectable(category="General", enumeration="text,binary,variables", default="text")]
		[Bindable(event="requestFormatChange")]
		/**
		 *  How the url request data should come back.
		 */
		public function get requestFormat():String
		{
			return _requestFormat;
		}

		/**
		 *  @private
		 */
		public function set requestFormat(value:String):void
		{
			if (_requestFormat == value) 
				return;
			_requestFormat = value;
			dispatchBindingEvent("requestFormatChange");
		}
		
		private var _result:*;
		[Bindable(event="resultChange")]
		/**
		 *  Resulting data
		 */
		public function get result():*
		{
			return _result;
		}
		public function set result(value:*):void
		{
			_result = value;
			dispatchBindingEvent("resultChange");
		}
		
		public function load():void
		{
			var request:URLRequest = new URLRequest(url);
			loader = new flash.net.URLLoader()
			loader.dataFormat = requestFormat;
			loader.addEventListener(Event.COMPLETE, completeHandler);
			loader.load(request);
		}
		
		protected function completeHandler(event:Event):void
		{
			switch (format) {
				case "xml" :
					result = new XML(loader.data.toString());
					break;
				case "text" :
					result = loader.data.toString();
					break;
				case "raw" :
					result = loader.data;
					break;
			}
			dispatchEvent(event);
		}
		
		protected function dispatchBindingEvent(type:String):void
		{
			if (hasEventListener(type))
				dispatchEvent(new Event(type));
		}
	}
}