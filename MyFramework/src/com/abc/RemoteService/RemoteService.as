package com.abc.RemoteService
{
	import mx.rpc.AsyncToken;
	import mx.rpc.Responder;
	import mx.rpc.http.HTTPService;
	import mx.rpc.remoting.Operation;
	import mx.rpc.remoting.RemoteObject;
	
	public class RemoteService implements IRemoteServices
	{
		private var configObj:Object;
		
		public function set configure(config:Object):void
		{
			if (config is Class)
				configObj = new config();
			else
				configObj = config;
		}       
		
		public function getRemoteObject(remoteObjectId:String):RemoteObject
		{
			if (configObj)
				return configObj[remoteObjectId];
			return null;
		}
		
		public function getHTTPService(remoteObjectId:String):HTTPService
		{
			if (configObj)
				return configObj[remoteObjectId];
			return null;
		}
		
		public function executeAsyncToken(token:AsyncToken, resultHandler:Function, faultHandler:Function):void
		{
			token.addResponder(new Responder(resultHandler, faultHandler));
		}
		
		public function executeHttpService(httpServiceId:String, args:Object = null, resultHandler:Function = null, faultHandler:Function = null):void
		{
			var httpService:HTTPService = getHTTPService(httpServiceId);
			
			if (!httpService)
				throw new Error(httpServiceId + " not configured!");
			
			if(args)
				executeAsyncToken(httpService.send(args), resultHandler, faultHandler);
			else
				executeAsyncToken(httpService.send(), resultHandler, faultHandler);
		}
		
		public function execute(remoteObjectId:String, methodName:String, args:Array = null, resultHandler:Function = null, faultHandler:Function = null):void
		{
			var remoteObject:RemoteObject = getRemoteObject(remoteObjectId);
			if (!remoteObject)
				throw new Error(remoteObjectId + " not configured!");
			
			var method:Operation = remoteObject[methodName];
			method.arguments = args;
			executeAsyncToken(method.send(), resultHandler, faultHandler);
		}
	}
}

/**
 *
 *
 *
 * remoteService.executeAsyncToken(myRemoteObject.remoteMethod(param), remoteMethod_resultHandler, remoteMethod_faultHandler);
 *
 * private function remoteMethod_resultHandler(event:ResultEvent):void
 * 	{
 * 		// Handle remote method call result
 *  }
 * private function remoteMethod_faultHandler(event:ResultEvent):void
 * {
 *   // Handle remote method call fault
 * }
 *
 *
 *
 * */


