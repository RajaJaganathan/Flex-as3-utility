
package lde.knobay.datalayer.db
{
	import flash.data.SQLConnection;
	import flash.data.SQLSchemaResult;
	
	public class SQLConnectionManager
	{
		public static var SQL_SCHEMA_RESULT:String = "schema_result";
		public static var SQL_CONNECTION:String = "sql_connection";
		
		private static var connectionMap:Object = new Object();
		private static var schemaResultMap:Object = new Object();
		
		public static function getConnection(name:String):SQLConnection
		{
			return connectionMap[name];
		}
		
		public static function setConnection(name:String, connection:SQLConnection):void
		{
			connectionMap[name] = connection;
		}
		
		public static function getSchemaResult(name:String):SQLSchemaResult
		{
			return schemaResultMap[name];
		}
		
		public static function setSchemaResult(name:String, schemaResult:SQLSchemaResult):void
		{
			schemaResultMap[name] = schemaResult;
		}
	}
}

