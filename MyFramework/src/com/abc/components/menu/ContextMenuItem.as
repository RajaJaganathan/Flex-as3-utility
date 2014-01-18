// =================================================================
/*
 *  Copyright (c) 2009
 *  Lance Pollard
 *  http://www.viatropos.com
 *  lancejpollard at gmail dot com
 *  
 *  Permission is hereby granted, free of charge, to any person
 *  obtaining a copy of this software and associated documentation
 *  files (the "Software"), to deal in the Software without
 *  restriction, including without limitation the rights to use,
 *  copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the
 *  Software is furnished to do so, subject to the following
 *  conditions:
 * 
 *  The above copyright notice and this permission notice shall be
 *  included in all copies or substantial portions of the Software.
 * 
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 *  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 *  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 *  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 *  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 *  OTHER DEALINGS IN THE SOFTWARE.
 */
// =================================================================

package bloom.components.menu
{
	import flash.events.ContextMenuEvent;
	import flash.events.EventDispatcher;
	import flash.ui.ContextMenuItem;
	
	import style.core.metadata;
	
	use namespace metadata;
	
	[Event(name="menuItemSelect", type="flash.events.ContextMenuEvent")]
	/**
	 *	ContextMenuItem
	 */
	public class ContextMenuItem extends EventDispatcher
	{
		public var item:flash.ui.ContextMenuItem = new flash.ui.ContextMenuItem('');
		
		/**
		 *  Whether or not it appears in the menu
		 */
		public function get visible():Boolean
		{
			return item.visible;
		}
		public function set visible(value:Boolean):void
		{
			item.visible = value;
		}
		
		/**
		 *  
		 */
		public function get caption():String
		{
			return item.caption;
		}
		public function set caption(value:String):void
		{
			item.caption = value;
		}
		
		/**
		 *  
		 */
		public function get separatorBefore():Boolean
		{
			return item.separatorBefore;
		}
		public function set separatorBefore(value:Boolean):void
		{
			item.separatorBefore = value;
		}
		
		/**
		 *	ContextMenuItem Constructor
		 */
		public function ContextMenuItem()
		{
			super();
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelect);
		}
		
		public function getItem():flash.ui.ContextMenuItem
		{
			return item;
		}
		
		metadata function menuItemSelect(event:ContextMenuEvent):void
		{
			dispatchEvent(event);
		}
	}
}