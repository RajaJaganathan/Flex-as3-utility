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

package bloom.components.browser
{
	import aw.external.JSInterface;
	import aw.external.jsinterface.*;
	import aw.external.jsinterface.objects.JSWindow;
	
	import bloom.events.BrowserEvent;
	import bloom.utils.BrowserUtil;
	
	import flash.display.StageDisplayState;
	import flash.events.Event;
	
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	import mx.managers.SystemManagerGlobals;
	
	import spark.components.Group;
	
	use namespace mx_internal;
	
	[Event(name="exit", type="bloom.events.BrowserEvent")]
	[Event(name="resize", type="bloom.events.BrowserEvent")]
	[Event(name="move", type="bloom.events.BrowserEvent")]
	[Event(name="focusIn", type="bloom.events.BrowserEvent")]
	[Event(name="focusOut", type="bloom.events.BrowserEvent")]
	[Event(name="scroll", type="bloom.events.BrowserEvent")]
	/**
	 *	BrowserManager allows you to drag and drop files from anywhere into a
	 *	Flex application in the Browser, and to mess with the browser from flex
	 */
	public class Browser extends Group
	{
		private static var _instance:Browser;
		public static function get instance():Browser
		{
			if (!_instance)
			{
				_instance = new Browser();
				//FlexGlobals.topLevelApplication.addElementAt(_instance, 0);
			}

			return _instance;
		}
		
		/**
		 *  Browser fullscreenness
		 */
		public static function get fullScreen():Boolean
		{
			return instance.fullScreen;
		}
		public static function set fullScreen(value:Boolean):void
		{
			instance.fullScreen = value;
		}
		
		private var fullScreenChanged:Boolean;
		private var _fullScreen:Boolean = false;
		/**
		 *  Browser fullscreenness
		 */
		public function get fullScreen():Boolean
		{
			return _fullScreen;
		}
		public function set fullScreen(value:Boolean):void
		{
			_fullScreen = value;
			fullScreenChanged = true;
			updateScreen();
		}
		
		public static function get applicationName():String
		{
			return JSCore.name;
		}
		
		public static function get name():String
		{
			return instance.baseName;
		}
		
		/**
		 *  Title of the browser
		 */
		public static function get title():String
		{
			return instance.title;
		}
		public static function set title(value:String):void
		{
			instance.title = value;
		}
		
		private var _title:String = "";

		[Bindable(event="titleChange")]
		/**
		 *  Title of the browser
		 */
		public function get title():String
		{
			return JSInterface.getTitle();
		}

		/**
		 *  @private
		 */
		public function set title(value:String):void
		{
			if (_title == value) 
				return;
			_title = value;
			JSInterface.setTitle(value);
			dispatchBindingEvent("titleChange");
		}
		
		private var _baseName:String;
		/**
		 *  Base title of the website
		 */
		public function get baseName():String
		{
			return _baseName;
		}
		public function set baseName(value:String):void
		{
			_baseName = value;
			JSInterface.setTitle(value);
		}
		
		private var _containerId:String;
		/**
		 *  Flash container id in javascript/html
		 */
		public function get containerId():String
		{
			if (!_containerId)
				_containerId = BrowserUtil.getFlashId();
			return _containerId;
		}
		public function set containerId(value:String):void
		{
			_containerId = value;
		}
		
		protected var handlers:Object = {};
		protected var handlersCount:Object = {};
		
		public function Browser():void
		{
			if (_instance != null)
				throw new Error("Only one Browser at a time, please use Browser.instance");
			if (!_instance)
			{
				_instance = this;
				install();
			}
			mouseEnabled = false;
			includeInLayout = false;
		}
		
		private var _horizontalScrollPosition:Number = 0;

		[Bindable(event="horizontalScrollPositionChange")]
		/**
		 *  Scrolling the browser
		 */
		override public function get horizontalScrollPosition():Number
		{
			return _horizontalScrollPosition;
		}
		
		/**
		 *  @private
		 */
		override public function set horizontalScrollPosition(value:Number):void
		{
			if (_horizontalScrollPosition == value) 
				return;
			_horizontalScrollPosition = value;
			window.scrollTo(value, _verticalScrollPosition);
			dispatchBindingEvent("horizontalScrollPositionChange");
		}
		
		private var _verticalScrollPosition:Number = 0;

		[Bindable(event="verticalScrollPositionChange")]
		/**
		 *  Scrolling the browser
		 */
		override public function get verticalScrollPosition():Number
		{
			return _verticalScrollPosition;
		}

		/**
		 *  @private
		 */
		override public function set verticalScrollPosition(value:Number):void
		{
			if (value < 0)
				value = 0;
			else if (value > contentHeight - height)
				value = contentHeight - height;
			_verticalScrollPosition = value;
			window.scrollTo(_horizontalScrollPosition, value);
			dispatchBindingEvent("verticalScrollPositionChange");
		}
		
		public function scroll(x:Number, y:Number):void
		{
			window.scrollTo(x, y);
		}
		
		public function get screenWidth():Number
		{
			return 1000;
		}
		
		public function get screenHeight():Number
		{
			return 1000;
		}
		
		private var _contentWidth:Number = 0;

		[Bindable(event="contentWidthChange")]
		/**
		 *  Width of the content, beneath the scroll bars
		 */
		override public function get contentWidth():Number
		{
			return _contentWidth;
		}

		/**
		 *  @private
		 */
		public function set contentWidth(value:Number):void
		{
			if (_contentWidth == value) 
				return;
			_contentWidth = value;
			dispatchBindingEvent("contentWidthChange");
		}
		
		private var _contentHeight:Number = 0;

		[Bindable(event="contentHeightChange")]
		/**
		 *  Height of the content beneath the scrollbars
		 */
		override public function get contentHeight():Number
		{
			return _contentHeight;
		}

		/**
		 *  @private
		 */
		public function set contentHeight(value:Number):void
		{
			if (_contentHeight == value) 
				return;
			_contentHeight = value;
			dispatchBindingEvent("contentHeightChange");
		}
		
		override public function setContentSize(width:Number, height:Number):void
		{
			contentWidth = width;
			contentHeight = height;
		}
		
		override public function set minHeight(value:Number):void
		{
			if (super.minHeight == value)
				return;
			super.minHeight = value;
			dispatchBrowserEvent(BrowserEvent.RESIZE);
		}
		
		// =======================================================
		// Overrides
		// =======================================================
		
		override public function get name():String
		{
			return BrowserUtil.browserType;
		}
		/*
		[Bindable(event="resize")]
		override public function get width():Number
		{
			return window.outerWidth;
		}
		
		override public function set width(value:Number):void
		{
			super.width = value;
			window.resizeTo(value, height);
		}
		
		[Bindable(event="resize")]
		override public function get height():Number
		{
			return window.outerHeight;
		}
		
		override public function set height(value:Number):void
		{
			super.height = value;
			window.resizeTo(width, value);
		}*/
		/*
		override public function setActualSize(width:Number, height:Number):void
		{
			window.resizeTo(width, height);
			super.setActualSize(width, height);
		}
		
		override public function get x():Number
		{
			return window.outerWidth;
		}
		
		override public function set x(value:Number):void
		{
			super.x = value;
			window.moveTo(value, y);
		}
		
		override public function get y():Number
		{
			return window.outerHeight;
		}
		
		override public function set y(value:Number):void
		{
			super.y = value;
			window.resizeTo(x, value);
		}
		
		override public function move(x:Number, y:Number):void
		{
			window.moveTo(x, y);
			super.move(x, y);
		}*/
		
		// =======================================================
		// Extras
		// =======================================================
		
		public function alert(message:String):void
		{
			JSInterface.window.alert(message);
		}
		
		public function get window():JSWindow
		{
			return JSInterface.window;
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			updateScreen();
		}
		
		protected function updateScreen():void
		{
			if (fullScreenChanged)
			{
				fullScreenChanged = false;
				try {
					if (fullScreen)
						FlexGlobals.topLevelApplication.stage.displayState = StageDisplayState.FULL_SCREEN;
					else
						FlexGlobals.topLevelApplication.stage.displayState = StageDisplayState.NORMAL;
				} catch (error:Error) {
					// nothin
				}
			}
		}
		
		override public function addEventListener(type:String, handler:Function,
			useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			super.addEventListener(type, handler, useCapture, priority, useWeakReference);
			switch (type)
			{
				case BrowserEvent.EXIT:
					addJavaScriptEventListener(BrowserEvent.UNLOAD);
				case BrowserEvent.RESIZE:
				case BrowserEvent.MOVE:
				case BrowserEvent.FOCUS_IN:
				case BrowserEvent.FOCUS_OUT:
				case BrowserEvent.SCROLL:
				case BrowserEvent.KEY_DOWN:
				case BrowserEvent.KEY_UP:
				case BrowserEvent.KEY_PRESS:
					addJavaScriptEventListener(type);
					break;
			}
		}
		
		override public function removeEventListener(type:String, handler:Function, useCapture:Boolean = false):void
		{
			super.removeEventListener(type, handler, useCapture);
			switch (type)
			{
				case BrowserEvent.EXIT:
				case BrowserEvent.RESIZE:
				case BrowserEvent.MOVE:
				case BrowserEvent.FOCUS_IN:
				case BrowserEvent.FOCUS_OUT:
				case BrowserEvent.SCROLL:
				case BrowserEvent.KEY_DOWN:
				case BrowserEvent.KEY_UP:
				case BrowserEvent.KEY_PRESS:
					removeJavaScriptEventListener(type);
					break;
			}
		}
		
		protected function addJavaScriptEventListener(type:String):void
		{
			var jsType:String = type.toLowerCase();//"on" + type.toLowerCase();
			
			if (isNaN(handlersCount[type]))
				handlersCount[type] == 1;
			else
				handlersCount[type]++;
			
			if (handlers[jsType])
				return;
				
			var method:Function = function(event:JSDynamic = null):void
			{
				dispatchBrowserEvent(type, event);
			}
			handlers[type] = method;
			JSInterface.window.addEventListener(jsType, method, false);
		}
		
		protected function removeJavaScriptEventListener(type:String):void
		{
			var jsType:String = "on" + type.toLowerCase();
			
			handlersCount[type]--;
			
			if (handlersCount[type] == 0 && jsType in handlers)
			{
				handlers[type] = null;
				delete handlersCount[type];
				delete handlers[type];
				JSInterface.window[jsType] = null;
			}
		}
		
		protected function install():void
		{	
			var stage:* = SystemManagerGlobals.topLevelSystemManagers[0].stage;
						
			JSInterface.initialize(stage);
		}
		
		protected function dispatchBindingEvent(type:String):void
		{
			if (hasEventListener(type))
				dispatchEvent(new Event(type));
		}
		
		protected function dispatchBrowserEvent(type:String, event:* = null):void
		{
			if (hasEventListener(type))
				dispatchEvent(new BrowserEvent(type, event));
		}
	}
}