package com.abc.RemoteService
{
	import mx.rpc.remoting.RemoteObject;

	public class Service
	{
		private var remoteObject:RemoteObject;

		public static function get getInstance():Service
		{
			return new Service();
		}

		public function Service()
		{
			this.remoteObject = new RemoteObject();
			this.remoteObject.endpoint = "http://localhost/amfphp/gateway.php";
			this.remoteObject.destination = "amfphp";
			this.remoteObject.source = "source";
			this.remoteObject.showBusyCursor = true;
		}

		public function getEmployeeData(id:String, resultHandler:Function, faultHandler:Function):void
		{
			remoteObject.getEmployeeData.addEventListener(ResultEvent.RESULT, resultHandler);
			remoteObject.getEmployeeData.addEventListener(FaultEvent.FAULT, faultHandler);
			remoteObject.getEmployeeData(id);
		}

	}
}
/**
 *
 *
 * USAGE
 *
 *
		private function initApp():void
		{
			Service.getInstance.getEmployeeData(id, resultHandler, faultHandler);
		}

		public function faultHandler(event:FaultEvent):void
		{
			Alert.show("Error:" + event.fault.message);
		}

		public function resultHandler(event:ResultEvent):void
		{
			Alert.show(event.result as ArrayCollection.toString());
		}
*
 */
/**/

