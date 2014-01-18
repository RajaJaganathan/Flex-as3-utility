package com.abc.controls
{

	import mx.collections.ArrayCollection;

	public class ArrayCollectionExtended extends ArrayCollection
	{
		private var _filterFunctions:Array;

		public function ArrayCollectionExtended( source:Array = null )
		{
			super(source);
		}
		public function set filterFunctions( filtersArray:Array ):void
		{
			_filterFunctions = filtersArray;
			this.filterFunction = complexFilter;
		}
		public function get filterFunctions():Array
		{
			return _filterFunctions;
		}

		protected function complexFilter( item:Object ):Boolean
		{
			var filterFlag:Boolean = true;
			var filter:Function;
			for each(filter in filterFunctions)
			{
				filterFlag = filter( item );
				if( !filterFlag )
					break;
			}

			return filterFlag;
		}
	}
}


/*private function creationCompleteHandler():void
	   {

		   productsCollection.filterFunctions =
			   [
				   filterByPrice, filterByType,
				   filterByCondition, filterByVendor
			   ]
		   productsCollection.refresh();
	   }

	   // your classic filter functions
	   private function filterByPrice( item:Object ):Boolean
	   {
		   if( selectedMinPrice <= item.productPrice && selectedMaxPrice > item.productPrice )
			   return true;
		   return false;
	   }

	   private function filterByType( item:Object ):Boolean
	   {
		   if( item.productType == selectedType || selectedType == "all" )
			   return true;
		   return false;
	   }

	   private function filterByCondition( item:Object ):Boolean
	   {
		   if( item.productCondition == selectedCondition || selectedCondition == "all" )
			   return true;
		   return false;
	   }

	   private function filterByVendor( item:Object ):Boolean
	   {
		   if( item.productVendor == selectedVendor || selectedVendor == "all" )
			   return true;
		   return false;
	   }*/

