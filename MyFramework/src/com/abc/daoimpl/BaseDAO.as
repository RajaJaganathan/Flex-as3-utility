package lde.knobay.datalayer.localdao
{
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLSchemaResult;
	import flash.data.SQLStatement;
	import flash.errors.SQLError;
	import flash.events.Event;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.net.Responder;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	
	import lde.knobay.datalayer.db.KBFlexDocumentModelTranslator;
	import lde.knobay.datalayer.db.SQLCommand;
	import lde.knobay.datalayer.db.SQLConnectionManager;
	import lde.knobay.utils.ValidationUtils;
	
	import mx.collections.ArrayCollection;
	
	public class BaseDAO 
	{
		private var flexDocumentModelTranslator:KBFlexDocumentModelTranslator = new KBFlexDocumentModelTranslator();
		protected var sqlSchemaResult:SQLSchemaResult;
		protected var sqlConnection:SQLConnection;
		protected var currentDAOName:String = "BaseDAO";
		
		private var faultXML:XML =<xml>
									 <errors>
										 <error></error>
										 <sqlError></sqlError>
									 </errors>
								 </xml>;
		
		
		public function BaseDAO()
		{
			sqlConnection = SQLConnectionManager.getConnection(SQLConnectionManager.SQL_CONNECTION);
			sqlSchemaResult = SQLConnectionManager.getSchemaResult(SQLConnectionManager.SQL_SCHEMA_RESULT);
		}			
		
		public function getTypedObject(valueObject:*, o:Object):*
		{			
			var def:XML       = describeType(valueObject);
			var props:XMLList    = def..variable.@name;
			
			props += def..accessor.@name;
			
			for each (var prop:String in props) {
				valueObject[prop] = o[prop]
			}
			
			return valueObject;	//for eg, LoginVO	
		}
		
		protected function setParameters( stmt:SQLStatement, params:Array ):void 
		{
			var param:Object;
			for ( var i:int = 0; i < params.length; i++ ) 
			{
				param = params[i];
				stmt.parameters[ '@' + param.name ] = param.value;
			}
		}	
		
		protected function createSQLStatement():SQLStatement
		{
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			
			return stmt;
		}
		
		protected function toFlexDocumentModel(flatArrayCollection:ArrayCollection, isOutputArrayCollection:Boolean = false):ArrayCollection
		{
			return flexDocumentModelTranslator.toFlexDocumentModel(flatArrayCollection,isOutputArrayCollection);
		}
		
		protected function toSingleFlexDocumentModel(flatArrayCollection:ArrayCollection):ArrayCollection
		{
			return flexDocumentModelTranslator.toSingleFlexDocumentModel(flatArrayCollection);
		}
				
		protected function executeQuery(sqlCommand:SQLCommand, resultHandler:Function=null, faultHandler:Function = null, ...fnArgs):void
		{
			var sqlStatement:SQLStatement 	= new SQLStatement();
			sqlStatement.text 				= sqlCommand.sqlText;
			sqlStatement.sqlConnection 		= sqlConnection;
			
			sqlStatement.addEventListener(SQLEvent.RESULT, resultEventHandler, false, 0, true);
			sqlStatement.addEventListener(SQLErrorEvent.ERROR, sqlErrorEventHandler, false, 0, true);
			
			if(ValidationUtils.isNotNullOrEmpty(sqlCommand.sqlParameters))
			{
				setParameters(sqlStatement,sqlCommand.sqlParameters);
			}
			
			var sqlStatementResponder:Responder = new Responder(
				function(sqlResult:SQLResult):void{
					
					if(resultHandler != null)
						resultHandler(sqlResult);
					
				}, faultResponderHandler);
			
			sqlStatement.execute(-1, sqlStatementResponder);
		}
		
		public function passParameters(	method:Function, additionalArguments:Array):Function
		{
			return function(event:Event):void {
				method.apply(null, [event].concat(additionalArguments));
			}
		}
		
		private function faultResponderHandler(error:SQLError):void
		{
			trace("Error in " + currentDAOName + " Error Id :: " + error.detailID + " :: " + error.details + "\n" + error.message.toString());
			
		}
		
		private function sqlErrorEventHandler(ev:SQLErrorEvent):void
		{
//			ev.target.removeEventListener(SQLErrorEvent.ERROR, sqlErrorEventHandler, false, 0, true);
//			trace("SQLite3::sqlErrorEventHandler()");
		}
		
		private function resultEventHandler(ev:SQLEvent):void
		{
//			ev.target.removeEventListener(SQLEvent.RESULT, resultEventHandler, false, 0, true);
//			trace("SQLite3::resultEventHandler()");
//			callFaultHandler()
		}
		
		protected function callResultHandler(data:*,resultHandler:Function):void
		{
			if(resultHandler!=null)
				resultHandler.call(null,data);
		}
		
		protected function callFaultHandler(faultHandler:Function, error:String, sqlError:String = ""):void
		{			
			if(faultHandler == null)
				return;
			
			var faultObject:Object = {};
			faultObject.fault = {};
			faultObject.fault.faultString = {};
			faultObject.fault.faultString = error;
			faultXML.errors.error = error;
			faultXML.errors.sqlError = sqlError;
			
			faultHandler.call(null, faultObject);			
		}
	}
}