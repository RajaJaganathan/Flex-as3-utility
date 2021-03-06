package com.abc.RemoteService
{
	import mx.rpc.AsyncToken;
	import mx.rpc.remoting.RemoteObject;

	public interface IRemoteServices
	{
		//function configure(config:Object):void;

		function getRemoteObject(remoteObjectId:String):RemoteObject;

		function executeAsyncToken(token:AsyncToken, resultHandler:Function, faultHandler:Function):void;

		function execute(serviceId:String, methodName:String, args:Array = null, resultHandler:Function = null, faultHandler:Function = null):void;
	}
}

