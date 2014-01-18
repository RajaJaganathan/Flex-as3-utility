package com.abc.renderers
{
	import mx.controls.Label;
	import mx.controls.listClasses.*;

	public class PriceLabel extends Label
	{

		private const POSITIVE_COLOR:uint = 0x000000; // Black

		private const NEGATIVE_COLOR:uint = 0xFF0000; // Red 

		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);

			/* Set the font color based on the item price. */
			setStyle("color", (data.@price <= 0) ? NEGATIVE_COLOR : POSITIVE_COLOR);
		}
	}
}


