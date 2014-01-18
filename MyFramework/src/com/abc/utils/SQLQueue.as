package com.xinote.utils
{
	import mx.collections.ArrayCollection;
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.events.SQLEvent;
	import flash.events.SQLErrorEvent;
	import flash.data.SQLTransactionLockType;
	import mx.rpc.http.HTTPService;
	import mx.rpc.AsyncToken;
	import mx.rpc.Responder;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.events.FaultEvent;
	import mx.controls.Alert;
	
	public class SQLQueue
	{
		private var queue:ArrayCollection = new ArrayCollection();
		private var _errors:ArrayCollection;
		private var connection:SQLConnection;
		private var resultHandler:Function;
		private var faultHandler:Function;
		
		public function executeFromFile(connection:SQLConnection, sqlFile:String, resultHandler:Function=null, faultHandler:Function=null):void
		{
			var srv:HTTPService = new HTTPService();
			srv.url = sqlFile;
			var token:AsyncToken = srv.send();
			token.addResponder(new mx.rpc.Responder(
				function (event:ResultEvent):void
				{
					if (!event.result || !event.result.sql.statement.length>0)
					{
						return;
					}
					var statements:ArrayCollection = event.result.sql.statement;
					for (var i:int=0; i<statements.length; i++)
					{
						addItem(statements.getItemAt(i));
					}
					execute(connection, resultHandler, faultHandler);
				},
				function (event:FaultEvent):void
				{
					Alert.show(event.fault.faultString, "Error");
				}));
		}
		
		public function addItem(sql:String, parameters:Array=null, stopOnError:Boolean=true):void
		{
			queue.addItem({sql: sql, parameters: parameters, stopOnError: stopOnError});	
		}
		
		public function execute(connection:SQLConnection, resultHandler:Function=null, faultHandler:Function=null):void
		{
			this.connection = connection;
			this.resultHandler = resultHandler;
			this.faultHandler = faultHandler;
			connection.begin();
			executeStatement(0);
		}
		
		public function get errors():ArrayCollection
		{
			return _errors;
		}
		
		private function executeStatement(index:int):void
		{
			if (index >= queue.length)
			{
				connection.commit();
				if (resultHandler != null) resultHandler.call(this);
				return;
			}
			
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = connection;
			var item:Object = queue.getItemAt(index);
			stmt.text = item.sql;
			setParameters(stmt, item.parameters);			
			stmt.addEventListener(SQLEvent.RESULT,
				function (event:SQLEvent):void
				{
					executeStatement(++index);						
				}
				);
			stmt.addEventListener(SQLErrorEvent.ERROR,
				function (event:SQLErrorEvent):void
				{
					if (_errors == null)
					{
						_errors = new ArrayCollection();
					}
					_errors.addItem(stmt.text + "---" + event.error);
					if (item.stopOnError)
					{
						connection.rollback();
						if (faultHandler != null) faultHandler.call(this, _errors);
						return;
					}
					else
					{
						executeStatement(++index);						
					}
				}
				);
			stmt.execute();			
		}
		
		private function setParameters(stmt:SQLStatement, params:Array):void
		{
			if (params == null || params.length == 0)
			{
				return
			}
			for (var i:int=0; i<params.length; i++)
			{
				stmt.parameters[i+1] = params[i];
			}
		}
	}
}

