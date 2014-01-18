package com.abc.utils
{

	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.formatters.CurrencyFormatter;
	import mx.utils.ObjectUtil;

	/*        Label Function and SortCompare Function */

	public class LabelFunctionUtil
	{		
		public static var formatterObj:FormatterUtil = FormatterUtil.getInstance();

		public function LabelFunctionClass()
		{

		}		

		public static function price_labelFunc(item:Object, column:DataGridColumn):String {        	

			return formatterObj.formatePrice(item.@price);
		}

		public static function sortCompareNumericFunc(itemA:Object, itemB:Object):int {
			return ObjectUtil.numericCompare(itemA.@price, itemB.@price);
		}

	}
}

