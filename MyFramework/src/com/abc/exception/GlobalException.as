package lde.desktop.exception
{
	import flash.events.ErrorEvent;
	import flash.events.UncaughtErrorEvent;
	
	import lde.desktop.com.Alert;
	
	import mx.core.UIComponent;
	import mx.managers.ISystemManager;

	public class GlobalException
	{
		public function GlobalException(){
		}
		
		public static function initializeGlobalException(systemManager:ISystemManager):void	{		
			systemManager.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtErrorHandler);
		}
		
		public static function onUncaughtErrorHandler(e:UncaughtErrorEvent):void {
			//To prevent show the runtime exception window at production
			CONFIG::release
			{
				e.preventDefault();
			}
			
			var errorString:String="";
			
			if (e.error is Error){
				var error:Error = e.error as Error;
				errorString = error.getStackTrace().toString(); 
			}
			else {
				var errorEvent:ErrorEvent = e.error as ErrorEvent;
				errorString = errorEvent.errorID +"\n" + errorEvent.text;
			}
			
//			Alert.showAlert(s,"Error");
		}		
		
	}
}
/*
*  USAGE
 * In main application having system manager
* addedToStage="initializeGlobalException()"
* private function initializeGlobalException():void
*	{			
*	    GlobalException.initializeGlobalException(systemManager);
*	}
*
**/