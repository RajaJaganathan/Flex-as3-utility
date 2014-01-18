package com.abc.RemoteService
{
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.Operation;
	import mx.rpc.remoting.mxml.RemoteObject;

	public class xRemoteService
	{		
		protected static var _remoteService:xRemoteService = new xRemoteService();               
		protected var _destination:String;		
		protected var _remoteObject:RemoteObject;

		public function xRemoteService(destination:String)
		{
			this._destination = destination;
			this._remoteObject = new RemoteObject();
			this._remoteObject.destination = destination;
		}

		public static function getInstance():xRemoteService
		{
			return _remoteService;
		}

		public function getOperation(operationName:String, onResult:Function, onError:Function) : Operation {
			var operation:Operation = _remoteObject.getOperation(operationName) as Operation;				
			operation.addEventListener(ResultEvent.RESULT, onResult);
			operation.addEventListener(FaultEvent.FAULT, onError);
			return operation;
		}
	}
}


/* public class TestProxy
{
		public static const NAME:String = "TestProxy";

				protected var _remoteService:RemoteService;

		public function TestProxy(){
			super(NAME);
						_remoteService = RemoteService.getInstance();
		}

		public function testOperation():void
		{
			var operation:Operation = _remoteService.getOperation("testOperationName", onTestResult, onTestFault);
			operation.send();
		}
} */

