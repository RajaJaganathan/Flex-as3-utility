package com.abc.events
{
	import flash.events.Event;
	
	public class CustomEvent extends Event
	{
		private var data:*;
		
		public function CustomEvent(type:String,data:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{			
			super(type, bubbles, cancelable);
			this.data = data;			
		}		
		
	}
}