package
{
	import flash.display.Sprite;
	import flash.events.Event;

	public class NextFrameCommand
	{
		private static var functionToCall : Function;
		private static var sprite:Sprite = new Sprite();
		private static var args:Array;
		
		public function NextFrameCommand() {			
		}
		
		public static function start(func : Function,...args:Array) : void {
			functionToCall = func;
			args = args;
			sprite.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private static function onEnterFrame(e:Event) : void {
			sprite.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			functionToCall.apply(null,args);
		}
	}
}