package com.xinote.utils
{
	import com.xinote.images.ImageFactory;
	
	import flash.desktop.DockIcon;
	import flash.desktop.NativeApplication;
	import flash.desktop.NotificationType;
	import flash.desktop.SystemTrayIcon;
	import flash.display.Bitmap;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.NativeWindow;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.core.FlexGlobals;
	
	public class SystemTrayUtil
	{
		private static var _instance:SystemTrayUtil;
		private var xinoteLogo:Bitmap = new ImageFactory.folder_icon;
		
		public static function getInstance():SystemTrayUtil
		{
			if(_instance)
				return _instance;
			return _instance = new SystemTrayUtil();		
		}
		
		public function setSystemTrayIcon():void
		{
			NativeApplication.nativeApplication.icon.bitmaps = [xinoteLogo.bitmapData];
			createMenu();
			createToolTip();
			bounceTimer();		
		}	
		
		public function destroySystemTrayIcon():void
		{
			NativeApplication.nativeApplication.icon.bitmaps = [];			
		}		
		
		private function createMenu():void{
			var dockMenu:NativeMenu = new NativeMenu();
			var minimizeMenu:NativeMenuItem = new NativeMenuItem("Minimize");
			var maximizeMenu:NativeMenuItem = new NativeMenuItem("Maximize");
			var restoreMenu:NativeMenuItem = new NativeMenuItem("Restore");
			var closeMenu:NativeMenuItem = new NativeMenuItem("Close");
			
			minimizeMenu.addEventListener(Event.SELECT, handleMenuClick);
			maximizeMenu.addEventListener(Event.SELECT, handleMenuClick);
			restoreMenu.addEventListener(Event.SELECT, handleMenuClick);
			closeMenu.addEventListener(Event.SELECT, handleMenuClick);
			dockMenu.addItem(minimizeMenu);
			dockMenu.addItem(maximizeMenu);
			dockMenu.addItem(restoreMenu);
			dockMenu.addItem(closeMenu);
			
			if(NativeApplication.supportsSystemTrayIcon) {
				SystemTrayIcon(NativeApplication.nativeApplication.icon).menu = dockMenu;
			}
		}
		
		private function handleMenuClick(e:Event):void{
			var menuItem:NativeMenuItem = e.target as NativeMenuItem;
			if(menuItem.label == "Minimize") FlexGlobals.topLevelApplication.minimize();
			if(menuItem.label == "Maximize") FlexGlobals.topLevelApplication.maximize();
			if(menuItem.label == "Restore") FlexGlobals.topLevelApplication.restore();
			if(menuItem.label == "Close") FlexGlobals.topLevelApplication.close();
		}
		
		private function bounceTimer():void{
			var myTimer:Timer = new Timer(100000, 1);
			myTimer.addEventListener("timer", timerHandler);
			myTimer.start();
		}
		
		private function timerHandler(event:TimerEvent):void {
			if( NativeApplication.supportsDockIcon){
				DockIcon(NativeApplication.nativeApplication.icon).bounce(NotificationType.CRITICAL);
			}			
		}
		
		
		/**
		 * Creating tooptip test here
		 *
		 */		
		private function createToolTip():void{
			if(NativeApplication.supportsSystemTrayIcon){
				SystemTrayIcon(NativeApplication.nativeApplication.icon).tooltip ="xinote";
			}
		}
		
		/**
		 * This function called when deactive() event fired from WindowApplication
		 * @param isCritical
		 *
		 * if isCritical true taskbar of our application tab will be blink with orange colour
		 * else it will be not blink		 *
		 *
		 */			
		public function bounce(isCritical:Boolean):void
		{
			if( NativeWindow.supportsNotification &&
				NativeApplication.supportsSystemTrayIcon)
			{
				var type:String = isCritical ? NotificationType.CRITICAL : NotificationType.INFORMATIONAL;
				FlexGlobals.topLevelApplication.nativeWindow.notifyUser(type);
			}
		}
	
	
	
	/*public function SystemTrayUtil()
	   {
	   throw new Error('You cannot instantiate this Singleton Static class.');
	   }*/
	
	}
}

