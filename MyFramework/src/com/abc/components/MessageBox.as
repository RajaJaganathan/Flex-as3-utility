package knobay.authoring.utils
{
	import flash.display.DisplayObject;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.core.FlexGlobals;
	
	public class MessageBox
	{
		private static var parentApp:* = FlexGlobals.topLevelApplication;
		private static var timer:Timer;
		
		public function MessageBox(){
			throw Error('This class is singleton class don\'t create instance of the class');
		}
		
		public static function show(value:String):void		
		{
			timer = new Timer(2500);
			timer.addEventListener(TimerEvent.TIMER,onTimerHandler);
			parentApp['borderContainerNotification'].visible = true;
			parentApp['borderContainerNotification'].includeInLayout = true;		
			parentApp['lblMessge'].text = value;	
			timer.start();
		}
		
		private static function onTimerHandler(event:TimerEvent):void		
		{		
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER,onTimerHandler);
			closeMessageBox();
		}
		
		private static function closeMessageBox():void		
		{		
			parentApp['borderContainerNotification'].visible = false;
			parentApp['borderContainerNotification'].includeInLayout = false;		
			parentApp['lblMessge'].text = '';			
		}
	}
}

/***
 * 
 * <s:Application>
 * IT SHOULD BE LAST TAG
 * <s:BorderContainer id="borderContainerNotification" x="{appBar.x}" y="{appBar.y+appBar.height-3}"  
						   visible="false" includeInLayout="false"
						   width="70%" height="23" borderColor="#CCCCCC" backgroundColor="#E8F2FE">	
			
			<s:Label id="lblMessge" maxDisplayedLines="1" width="{borderContainerNotification.width-50}" 				 
					 verticalCenter="0" fontSize="12" />
			
		</s:BorderContainer>
	</s:Application>
 * 
 * 
 * 
 * 
 * 
 * */