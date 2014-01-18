package com.abc.utils
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	/**
	 * @author raja.j
	 */
	public class DebuggingUtils
	{
		static public function drawOutline(target:Sprite, color:uint = 0xff00ff):void
		{
			target.graphics.lineStyle(1, color);
			target.graphics.drawRect(0, 0, target.width, target.height);
		}
		static public function drawChildOutline(child:DisplayObject, parent:Sprite, color:uint = 0xff00ff):void
		{
			parent.graphics.lineStyle(1, color);
			parent.graphics.drawRect(child.x, child.y, child.width, child.height);
		}
	}
	
}