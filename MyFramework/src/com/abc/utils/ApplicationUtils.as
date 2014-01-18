package com.abc.utils
{
	import flash.display.DisplayObject;
	import mx.containers.Canvas;

	public class ApplicationUtils
	{

	}

	/**
	* Function	:	alignCenterPopup
	* Arugments	:	DisplayObject
	*/	

	public static function alignCenterPopup(disObject:DisplayObject)
	{
		var nScrollYPos:Number = ExternalInterface.call("getScrollYPosition");
		var nBrowerHeight:Number = ExternalInterface.call("getBrowerHeight");
		var yPos:Number = nScrollYPos + (nBrowerHeight /2) - (disObject.height/2) + 20;

		//if negative value comes set to default center bacause negative value hide popup.
		//Unless set to visible porition.

		if(yPos < 0 || nBrowerHeight == NaN || nScrollYPos == NaN)
			PopUpManager.centerPopUp(disObject);
		else
		{
			disObject.x = (Application.application.width /2) - (disObject.width/2);
			disObject.y = nScrollYPos + (nBrowerHeight /2) - (disObject.height/2) + 20;
		}
	} 

	/**
	* Function 	: scrollIntoView
	* Arguments	: FocusEvent e.g)
	* Application.application.addEventListener(FocusEvent.KEY_FOCUS_CHANGE,scrollIntoView)
	*/	
	public static function scrollIntoView(event:FocusEvent):void
	{
		var pt:Point = new Point();
		var nScrollYPos:Number = ExternalInterface.call("getScrollYPosition");
		var nBrowerHeight:Number = ExternalInterface.call("getBrowerHeight");
		var targetObjHeight:Number = DisplayObject(event.target).height;

		pt = DisplayObject(event.target).localToGlobal(pt);

		if(nPreviousYPosition < pt.y + targetObjHeight || nBrowerHeight > pt.y + targetObjHeight)
		{
			ExternalInterface.call("scrollToVisible",pt.y,targetObjHeight+30);	
			nPreviousYPosition = pt.y + targetObjHeight;
		}		
		return;
	}	

	/**
	* Function	:	notificationMakeVisible
	* Arg		:	FlexEvent e.g)
	* notifier.addEventListener(FlexEvent.SHOW,notificationMakeVisible) [notifier is canvas]
	*/	
	public static function notificationMakeVisible(event:FlexEvent = null):void
	{	
		var iYPos:Number = ExternalInterface.call("getScrollYPosition");		
		canNotifier.y = iYPos //> m_getNotifierYPos ? iYPos : m_getNotifierYPos ;	
	}	
}



/**
*  Javascript function
*/

/* function getScrollXPosition(){
	return window.pageXOffset ? window.pageXOffset : document.documentElement.scrollLeft ? document.documentElement.scrollLeft : 						document.body.scrollLeft;
}
function getScrollYPosition() {
	return window.pageYOffset ? window.pageYOffset : document.documentElement.scrollTop ? document.documentElement.scrollTop : 					document.body.scrollTop;
}
function getBrowerHeight() {
	return window.innerHeight;//document.documentElement.clientHeight;
}

function scrollToVisible(pt,targetObjHeight) {
	var nScrollYPos = getScrollYPosition();
	var nBrowerHeight = getBrowerHeight();
	window.scrollTo(0,((pt + targetObjHeight) - nBrowerHeight));
}
 */

