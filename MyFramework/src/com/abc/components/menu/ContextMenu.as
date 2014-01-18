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
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenu;
	
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	import style.controllers.Controller;
	
	[Event(name="menuSelect", type="flash.events.ContextMenuEvent")]
	[DefaultProperty("contextMenuItems")]
	/**
	 *	ContextMenu
	 */
	public class ContextMenu extends Controller
	{
		protected var originalContextMenu:flash.ui.ContextMenu;
		
		private var _contextMenuItems:Array;
		[ArrayElementType("bloom.components.menu.ContextMenuItem")]
		/**
		 *  
		 */
		public function get contextMenuItems():Array
		{
			return _contextMenuItems;
		}
		public function set contextMenuItems(value:Array):void
		{
			_contextMenuItems = value;
			updateTarget();
		}
		
		private var _target:DisplayObjectContainer;
		[Bindable(event="targetChange")]
		/**
		 *  
		 */
		public function get target():DisplayObjectContainer
		{
			return _target;
		}
		public function set target(value:DisplayObjectContainer):void
		{
			if (_target == value) 
				return;
			_target = value;
			dispatchBindingEvent("targetChange");
		}
		
		public function get application():UIComponent
		{
			return FlexGlobals.topLevelApplication as UIComponent;
		}
		
		public var hideBuiltInItems:Boolean = true;
	
		/**
		 *	ContextMenu Constructor
		 */
		public function ContextMenu()
		{
			super();
		}
		
		override public function attach(target:Object):void
		{
			if (target is DisplayObject)
			{
				originalContextMenu = target.contextMenu;
				this.target = target as DisplayObjectContainer;
				if (!application.initialized)
					application.addEventListener(FlexEvent.CREATION_COMPLETE, application_creationCompleteHandler);
				else
					updateTarget();
			}
		}
		
		protected function application_creationCompleteHandler(event:FlexEvent):void
		{
			application.removeEventListener(FlexEvent.CREATION_COMPLETE, application_creationCompleteHandler);
			updateTarget();
		}
		
		override public function detach(target:Object):void
		{
			if (this.target == target && originalContextMenu)
				target.contextMenu = originalContextMenu;
			this.target = null;
		}
		
		protected function updateTarget():void
		{
			if (target)
			{
				if (contextMenuItems)
				{
					var menu:flash.ui.ContextMenu = target.contextMenu ? target.contextMenu : new flash.ui.ContextMenu();
					var menuItems:Array = [];
					var i:int = 0, n:int = contextMenuItems.length;
					for (i; i < n; i++)
					{
						menuItems.push(contextMenuItems[i].getItem());
					}
					menu.customItems = menuItems;
					if (hideBuiltInItems)
						menu.hideBuiltInItems();
					target.contextMenu = menu;
					menu.addEventListener(ContextMenuEvent.MENU_SELECT, menuSelectHandler);
				}
			}
		}
		
		protected function menuSelectHandler(event:ContextMenuEvent):void
		{
			dispatchEvent(event);
		}
	}
}