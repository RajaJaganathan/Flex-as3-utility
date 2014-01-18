package com.abc.layout
{
	import mx.controls.LinkBar;
	import mx.controls.Button;
	import flash.events.MouseEvent; 
	public class ExtLinkBar extends LinkBar
	{
		public function ExtLinkBar ()
		{
			super();
		}
		override protected function clickHandler(event:MouseEvent):void
		{
			var index:int = getChildIndex(Button(event.currentTarget));			

			if (index == selectedIndex)
				hiliteSelectedNavItem(-1);

			else
				hiliteSelectedNavItem(index);

			super.clickHandler(event);
		} 
	}
}

