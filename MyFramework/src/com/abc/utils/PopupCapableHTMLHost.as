package com.xinote.htmlutils
{	
		import flash.display.NativeWindowInitOptions;
		import flash.display.StageDisplayState;
		import flash.geom.Rectangle;
		import flash.html.HTMLHost;
		import flash.html.HTMLWindowCreateOptions;
		import flash.net.URLRequest;
		import flash.html.HTMLLoader;
		import flash.display.Loader;				
		
		// Allows popups to be spawned from the javascript functions and window targets.
		public class PopupCapableHTMLHost extends HTMLHost {
			public function PopupCapableHTMLHost(parent:Object = null) {
				super(true);
				this.parent = parent;
			}
			
			private var parent:Object;
			
			override public function createWindow(windowCreateOptions:HTMLWindowCreateOptions):HTMLLoader { 
				var initOptions:NativeWindowInitOptions = new NativeWindowInitOptions();
				var bounds:Rectangle = new Rectangle(windowCreateOptions.x, windowCreateOptions.y,  
					windowCreateOptions.width, windowCreateOptions.height); 
				var htmlControl:HTMLLoader = HTMLLoader.createRootWindow(true, initOptions, 
					windowCreateOptions.scrollBarsVisible, bounds); 
				htmlControl.htmlHost = new PopupCapableHTMLHost();
				if(windowCreateOptions.fullscreen){ 
					htmlControl.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE; 
				} 
				return htmlControl; 
			}
			
			override public function updateLocation(locationURL:String):void { 
				htmlLoader.load(new URLRequest(locationURL)); 
			}
			
			override public function set windowRect(value:Rectangle):void { 
				htmlLoader.stage.nativeWindow.bounds = value; 
			}
			
			override public function updateTitle(title:String):void { 
				(htmlLoader as Object).label = title; 
			} 
		}
	}
}

/*

You can use this component like this:
You now have an embeddable browser component that will spawn new windows when popups are clicked.

var browser:HTML = new HTML();
browser.htmlHost = new PopupCapableHTMLHost(this);

*/


//Source :http://dmartin.org/weblog/html-component-adobe-air-supports-popup-windows
//Source :http://help.adobe.com/en_US/AIR/1.5/devappsflex/WS5b3ccc516d4fbf351e63e3d118666ade46-7e74.html