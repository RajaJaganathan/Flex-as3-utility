package com.clipboard.common.classes
{
	import mx.collections.ArrayCollection;
	
	public class CommonHelper
	{
		public function CommonHelper()
		{
			
			
		}
		[Bindable]
		public static var countryList:ArrayCollection= new ArrayCollection([
			{countryID:"US", name:"US"}]);

	}
}