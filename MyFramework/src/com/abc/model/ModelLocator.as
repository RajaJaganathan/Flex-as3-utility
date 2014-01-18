package com.xinote.models
{
	import com.abc.model.domain.Customer;
	
	import mx.collections.ArrayCollection;
	
	[Bindable]
	public class ModelLocator
	{	
	    //NEED NOT ALL VARIABLE IN MODELLOCATOR CLASS
	    //These class contains values for binding to view(mxml) component 
		//Access like modelLocator.customer.firstName
		public var customer:Customer = new Customer();
		
		private static var modelLocator:ModelLocator;
		
		public function ModelLocator()
		{
			//if(modelLocator)
			//throw new Error("This is singleton class don't create instance")
		}
		
		public static function getInstance():ModelLocator
		{
			if (modelLocator == null)
			{
				modelLocator = new ModelLocator();
			}
			
			return modelLocator;
		}
	
	}
}

