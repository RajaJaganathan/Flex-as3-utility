package com.abc.utils
{
	public class Delegate
	{
		// Create a wrapper for a callback function.
		// Tacks the additional args on to any args normally passed to the
		// callback.
		public static function create(handler:Function,...args):Function
		{
			return function(...innerArgs):void
			{
				handler.apply(this,innerArgs.concat(args));
			}
		}
	}
}