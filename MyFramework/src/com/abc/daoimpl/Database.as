package lde.knobay.datalayer.db
{
	import flash.data.SQLConnection;
	import flash.data.SQLSchemaResult;
	import flash.data.SQLStatement;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	
	import lde.knobay.datalayer.db.SQLConnectionManager;
	import lde.knobay.datalayer.db.SQLQueue;
	import lde.knobay.logs.KBLoggerFactory;
	
	import mx.logging.ILogger;
	
	[Event(name="databaseCreatedCompleteEvent", type="flash.events.Event")]
	
	public class Database extends EventDispatcher
	{
		private static const log:ILogger = KBLoggerFactory.getLogger(Database);
		private var sqlConnection:SQLConnection;
		private var dbFile:File;	
		
		public function Database(){
		}
		
		public function initializeDatabase():void
		{
			dbFile = new File("app-storage:/" + "localdb.db");
			sqlConnection = new SQLConnection();
			// Register the connection with the SQLConnectionManager so that other components in the app
			// can use it.
			SQLConnectionManager.setConnection(SQLConnectionManager.SQL_CONNECTION, sqlConnection);
			// When the connection is opened, execute SQL statements to create 
			// tables in the local database if they don't already exist
			
			sqlConnection.addEventListener(SQLEvent.OPEN, onOpenDatabaseHandler);
			sqlConnection.addEventListener(SQLErrorEvent.ERROR, onSQLErroHandler);
			sqlConnection.openAsync(dbFile);
		}
		
		private function onOpenDatabaseHandler(event:SQLEvent):void
		{
			log.info("database opened successfully");
			trace("database opened successfully");
			// When we have a connection to the database and we have made sure the required tables exist			
			var q:SQLQueue = new SQLQueue();
			q.executeFromFile(sqlConnection, "data/startupdb.xml", onDatabaseCreationComplete);
		}
		private function onSQLErroHandler(event:SQLErrorEvent):void
		{
			// If a transaction is happening, roll it back
			if (sqlConnection.inTransaction)
			{
				sqlConnection.addEventListener(SQLEvent.ROLLBACK, onRollbackHandler);
				sqlConnection.rollback();
			}
		}
		
		// Called when the transaction is rolled back
		private function onRollbackHandler(event:SQLEvent):void
		{
			sqlConnection.removeEventListener(SQLEvent.ROLLBACK, onRollbackHandler);				
			// add additional error handling, close the database, etc.
		}
		
		private function onDatabaseCreationComplete():void
		{
			var statement:SQLStatement = new SQLStatement();
			statement.sqlConnection = sqlConnection;
			statement.sqlConnection.addEventListener(SQLEvent.SCHEMA, onLoadHandleSchema)
			statement.sqlConnection.loadSchema();			
		}
		
		protected function onLoadHandleSchema(event:SQLEvent):void
		{
			var sqlSchemaResult:SQLSchemaResult = (event.target as SQLConnection).getSchemaResult();	
			SQLConnectionManager.setSchemaResult(SQLConnectionManager.SQL_SCHEMA_RESULT, sqlSchemaResult);
			log.info("database created successfully");
			trace("database created successfully");
			dispatchEvent(new Event("databaseCreatedCompleteEvent"));
		}
		
	}
}
