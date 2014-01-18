
package com.xinote.utils
{
	import flash.data.SQLConnection;

	public class SQLConnectionManager
	{
		private static var connectionMap:Object = new Object();

		public static function getConnection(name:String):SQLConnection
		{
			return connectionMap[name];
		}

		public static function setConnection(name:String, connection:SQLConnection):void
		{
			connectionMap[name] = connection;
		}
	}
}

