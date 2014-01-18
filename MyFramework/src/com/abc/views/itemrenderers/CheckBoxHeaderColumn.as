package com.abc.renderers
{
	import mx.controls.dataGridClasses.DataGridColumn;

	[Event(name="click", type="flash.events.MouseEvent")]

	public class CheckBoxHeaderColumn extends DataGridColumn
	{

		/**is the checkbox selected**/
		public var selected:Boolean = false;

		public function CheckBoxHeaderColumn(columnName:String=null)
		{
			super(columnName);
		}		
	}
}

