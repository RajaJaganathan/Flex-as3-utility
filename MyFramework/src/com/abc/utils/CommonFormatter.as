package com.xinote.utils
{
	import spark.formatters.DateTimeFormatter;
	
	public class CommonFormatter
	{
		private static var instance:CommonFormatter;
		
		public static const DATE_TIME_PATTEN:String	= "yyyy-MM-dd hh:mm:ss";
		
		private var dateTimeFormatter:DateTimeFormatter = new DateTimeFormatter();
		
		
		public function CommonFormatter()
		{
			dateTimeFormatter.dateTimePattern = DATE_TIME_PATTEN;		
		}
		
		public static function getInstance():CommonFormatter
		{
			if(!instance)
				instance = new CommonFormatter();
			return instance;		
		}
		
		//For Sync based date and time (mysql)
		public function formatDate(date:Object):String
		{
			return  dateTimeFormatter.format(date.toString());
		}
	}
}

