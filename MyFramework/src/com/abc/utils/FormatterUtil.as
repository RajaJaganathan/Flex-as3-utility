package com.abc.utils
{
	import mx.formatters.CurrencyFormatter;
	
	import spark.formatters.DateTimeFormatter;
	
	public class FormatterUtil
	{
		public static var formatterUtil:FormatterUtil;		
		public var currencyFormatter:CurrencyFormatter = new CurrencyFormatter();	
		public var dateTimeFormatter:DateTimeFormatter = new DateTimeFormatter();	
		
		public function FormatterUtil()
		{
			formatterUtil = this;
			currencyFormatter.precision=3;
			currencyFormatter.useThousandsSeparator = true;
			currencyFormatter.useNegativeSign = false;
		}
		
//		public static getInstance():FormatterUtil
		
		public static function getInstance():FormatterUtil
		{
			if(formatterUtil !=null)
				return formatterUtil;
			return new FormatterUtil();
		}
		
		public function formatePrice(price:String):String
		{
			return currencyFormatter.format(price);
		}	
		
		public function formatDate(price:String):String
		{
			return dateTimeFormatter.format(price);
		}		
	
	}
}

