package com.xinote.utils
{
	import com.xinote.constants.ApplicationConstants;
	import com.xinote.controls.NotificationBar;
	
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.data.SQLTransactionLockType;
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.utils.ObjectUtil;
	
	public class SQLUtil
	{
		public function executeBatch(file:File, connection:SQLConnection):void
		{
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.READ);
			var xml:XML = XML(stream.readUTFBytes(stream.bytesAvailable));
			stream.close();
			
			connection.begin(SQLTransactionLockType.IMMEDIATE);
			
			for each (var statement:XML in xml.statement)
			{
				var stmt:SQLStatement = new SQLStatement();
				stmt.sqlConnection = connection;
				stmt.text = statement;
				stmt.execute();			
			}
			connection.commit();
		}
		
		
		public static function updateSectionsOrder(sectionCollection:ArrayCollection, connection:SQLConnection):void
		{			
			var sectionNewOrder:Array = sectionCollection.toArray();
			
			connection.begin(SQLTransactionLockType.IMMEDIATE);
			
			for (var i:uint = 0; i < sectionNewOrder.length; i++){
				var _updateOrderStmt:SQLStatement = new SQLStatement();
				_updateOrderStmt.sqlConnection = connection;
				_updateOrderStmt.text = "UPDATE section SET [order]=@order WHERE section_id = @section_id";
				_updateOrderStmt.parameters["@order"] = int(sectionNewOrder[i].order);
				_updateOrderStmt.parameters["@section_id"] = int(sectionNewOrder[i].section_id);				
				_updateOrderStmt.execute();
			}
			
			connection.commit();	
		
		}	
		
		public static function updatePagesOrder(pagesCollection:ArrayCollection, connection:SQLConnection):void
		{	
			//FlexGlobals.topLevelApplication.enabled = false;
			var pagesNewOrder:Array = pagesCollection.toArray();			
			
			connection.begin(SQLTransactionLockType.IMMEDIATE);			
			
			for (var i:uint = 0; i < pagesNewOrder.length; i++){				
				var _updateStmt:SQLStatement = new SQLStatement();
				_updateStmt.sqlConnection = connection;
				_updateStmt.text = "UPDATE page SET [order]=@order WHERE page_id = @page_id";
				_updateStmt.parameters["@order"] = int(pagesNewOrder[i].order);
				_updateStmt.parameters["@page_id"] = int(pagesNewOrder[i].page_id);				
				_updateStmt.execute();
			}		
		
			//FlexGlobals.topLevelApplication.enabled = true;			
		
			//connection.commit();	
		}
	
	}
}

