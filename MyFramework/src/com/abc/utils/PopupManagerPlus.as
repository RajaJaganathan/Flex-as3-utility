/**
 * 
 * Class used to create/remove all popup at single place
 * 
 * 
 * 
 * 
 * *****/
package
{
	import flash.display.DisplayObject;
	import mx.core.IFlexDisplayObject;
	import mx.core.IFlexModuleFactory;
	import mx.managers.PopUpManager;

	public class PopupManagerPlus
	{
		private static var _popUps:Vector.<IFlexDisplayObject>=new Vector.<IFlexDisplayObject>();
		
		public function PopupManagerPlus()
		{
		}

		public static function removeAllPopUps():void
		{
			while (_popUps.length > 0)
			{
				PopUpManager.removePopUp(_popUps.pop());
			}
		}

		public static function addPopUp(window:IFlexDisplayObject, parent:DisplayObject, modal:Boolean=false, childList:String=null, moduleFactory:IFlexModuleFactory=null):void
		{
			_popUps.push(window);
			PopUpManager.addPopUp(window, parent, modal, childList, moduleFactory);
		}

		public static function removePopUp(popUp:IFlexDisplayObject):void
		{
			_popUps.splice(_popUps.indexOf(popUp), 1);
			PopUpManager.removePopUp(popUp);
		}

		public static function bringToFront(popUp:IFlexDisplayObject):void
		{
			PopUpManager.bringToFront(popUp);
		}

		public static function centerPopUp(popUp:IFlexDisplayObject):void
		{
			PopUpManager.centerPopUp(popUp);
		}

		public static function get numPopUps():int
		{
			return _popUps.length;
		}
	}
}
