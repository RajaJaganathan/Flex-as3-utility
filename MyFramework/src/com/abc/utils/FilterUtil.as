package com.abc.utils
{
	import mx.controls.DataGrid;

	public class FilterUtil
	{
		public function FilterUtil()
		{
		}		

		public static function filterByAllColumn(row:Object,dataGrid:DataGrid,searchText:String):Boolean
		{
			if(searchText.length == 0){
				return true;
			}

			var columnName:String;
			var columnValue:String;
			var keywords:Array = searchText.split(" ");
			var wordFound:Boolean;

			// Loop Over Words
			for(var word:int = 0; word < keywords.length; word++) {
				wordFound = false;
				// Loop Over Columns
				for( var column:int = 0; column < dataGrid.columnCount; column++){
					columnName = dataGrid.columns[column].dataField;
					if (row[columnName] != null) {
						columnValue = row[columnName];
						columnValue = columnValue.toLowerCase();
						if(columnValue.search(keywords[word].toLowerCase()) >= 0 ) {
							wordFound = true;
							break;
						} 
					}
				}
				if (!wordFound) return false;
			}
			return true;
		}

		public static function filterByColumn(row:Object,dataGrid:DataGrid,searchText:String,includeColumns:Array):Boolean
		{
			if(searchText.length == 0){
				return true;
			}

			var columnName:String;
			var columnValue:String;
			var keywords:Array = searchText.split(" ");
			var wordFound:Boolean;

			// Loop Over Words
			for(var word:int = 0; word < keywords.length; word++) {
				wordFound = false;
				// Loop Over Columns
				for( var column:int = 0; column < dataGrid.columnCount; column++){
					columnName = dataGrid.columns[column].dataField;
					if (row[columnName] != null && includeColumns.indexOf(columnName)!= -1) {
						columnValue = row[columnName];
						columnValue = columnValue.toLowerCase();
						if(columnValue.search(keywords[word].toLowerCase()) >= 0 ) {
							wordFound = true;
							break;
						} 
					}
				}
				if (!wordFound) return false;
			}
			return true;
		}

	}

}

//* USAGE */
/*
var filterOnlyColumn:Array = ['id','name','age'];

private function filterPhrase():void{
	recievedData.filterFunction = filterFirst;
	recievedData.refresh();
}

//if true it show results, if false it shows nothing
private function filterFirst(row:Object):Boolean
{
	return filterByAllColumn(row,dataGridID,"flex");
}

private function filterFirst(row:Object):Boolean
{
	return filterByColumn(row,dataGridID,"flex",filterOnlyColumn);
}
*/

