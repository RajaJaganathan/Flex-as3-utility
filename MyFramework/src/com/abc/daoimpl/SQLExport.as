/**
 * @author Raja.j
 */

package lde.knobay.datalayer.db
{
	import flash.data.SQLColumnSchema;
	import flash.data.SQLResult;
	import flash.data.SQLSchemaResult;
	import flash.data.SQLTableSchema;
	
	import lde.knobay.datalayer.localdao.BaseDAO;
	
	import mx.utils.StringUtil;

	public class SQLExport extends BaseDAO
	{
		private var _version:int;
		
		public function SQLExport(version:int = 0)
		{
			_version = version;
		}
		
		private var selectQuery:String = "SELECT * FROM {0} "; //WHERE version > {1}
		private var tablesToExport:Array = ['kbr_node','kbr_node_content','kbr_content_field','kbr_node_order','kbr_node_properties']; 
		
		private function canExportTable(tableName:String):Boolean
		{
			return tablesToExport.indexOf(tableName) == -1 ? false:true;
		}
		
		public function getExportData(resultHandler:Function = null):void
		{
			getTableRecords(sqlSchemaResult,function(queryStr:String):void{
				trace(queryStr);
				callResultHandler(queryStr, resultHandler);
			});
		}

		private function getTableRecords(schemaResult:SQLSchemaResult,resultHandler:Function = null):void
		{
			var queryStr:String= "";
			
			getPublishedTableRecordsByPublishFlag(0,{},tablesToExport, function(publishedObj:Object):void
			{
				for each (var tableSchema:SQLTableSchema in schemaResult.tables)
				{
					if(canExportTable(tableSchema.name))
					{
						queryStr += exportTableRecords(tableSchema, publishedObj[tableSchema.name]);
					}
				}	
				
				callResultHandler(queryStr,resultHandler);
			});
		}
		
		private function getPublishedTableRecordsByPublishFlag(index:int, publishedObj:Object, tablesName:Array, resultHandler:Function = null):void
		{
			if(index >= tablesName.length)
			{
				callResultHandler(publishedObj,resultHandler);
				return;
			}
			
			var sqlCommand:SQLCommand = new SQLCommand;
			
			sqlCommand.sqlText = StringUtil.substitute(selectQuery, tablesName[index], _version);
			
			executeQuery(sqlCommand,function(sqlResult:SQLResult):void
			{
				var tableName:String = tablesName[index];
				publishedObj[tableName] = sqlResult.data;
				
				getPublishedTableRecordsByPublishFlag(++index,publishedObj,tablesName,resultHandler);
			});	
			
		}

		private function exportTableRecords(pTable:SQLTableSchema, records:Array ):String
		{
			var queryStr:String = "";

			if (records == null)
				return "";

			var n:int = records.length;

			for (var i:int = 0; i < n; i++)
			{
				var rec:Object = records[i];
				queryStr += exportRecord(pTable, rec);
				queryStr += "\n";
			}

			return queryStr;

		}

		private function exportRecord(tableSchema:SQLTableSchema, pRec:Object):String
		{
			var insertQuery:String = "INSERT OR REPLACE INTO " + tableSchema.name;

			var columnDefinitions:Array = [];
			var columnValues:Array = [];
			var reg:RegExp = new RegExp("'", "gi");

			for (var i:int = 0; i < tableSchema.columns.length; i++)
			{
				var col:SQLColumnSchema = tableSchema.columns[i] as SQLColumnSchema;
				columnDefinitions.push(col.name);

				var value:Object = pRec[col.name];

				if (value is String)
				{
					// we need to escape simple quotes
					value = value.replace(reg, "\\'");
					columnValues.push("'" + value + "'");
				}
				else if (value is XML || value is XMLList)
				{
					columnValues.push((value as XML).toXMLString());
				}
				else
				{
					if (value == null)
						columnValues.push("null");
					else
						columnValues.push(value.toString());
				}
			}

			insertQuery += " (" + columnDefinitions.join(",") + ") VALUES (" + columnValues.join(",") + ");";

			return insertQuery;
		}

	}
}
