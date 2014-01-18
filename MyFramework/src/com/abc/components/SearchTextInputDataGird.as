package com.abc.components
{
	import mx.binding.utils.ChangeWatcher;
	import mx.collections.ArrayCollection;
	import mx.controls.DataGrid;
	import mx.events.FlexEvent;
	import mx.events.PropertyChangeEvent;
	import mx.utils.ObjectUtil;

	import spark.components.TextInput;
	import spark.events.TextOperationEvent;

	// we want to expand the TextInput component so that we have all the functionality of that component + those that we put in here.
	public class SearchTextInput extends TextInput
	{
		/*all the variables we will need:
			temp_dp: will be dataProvider for our DataGrid when we only want to show items that contain the match
			original_dp: when we are displaying only resaults that match to our search term, we store original datagrid's dataProvider in this variable
			dg: just to have our datagrid in some variable
			showOnlyResaults: if true we remove items that doesn't match our search term otherwise we only select first item that contain the matching term */
		private var original_dp:ArrayCollection;
		private var temp_dp:ArrayCollection = new ArrayCollection();

		[Bindable] public var dg:DataGrid = new DataGrid();
		[Bindable] public var showOnlyResults:Boolean = true;

//		our constructor function which is created automatically when we create our class
		public function SearchTextInput()
		{
			super();

			/*
			when the class is created we need to listen to the CREATION_COMPLETE event, so that we can bind our datagrid from mxml file to our datagrid in this class.
			Also if we later change the datagrid from outside this class we will detect that since we binded our datagrid
			*/
			this.addEventListener(FlexEvent.CREATION_COMPLETE, appComplete);
//			Another event listener to execute the search when we change the text in the text field of our component
			this.addEventListener(TextOperationEvent.CHANGE, search);
		}

//		function to acctualy bind the dataGrid
		private function appComplete(e:FlexEvent):void
		{
			ChangeWatcher.watch(this,"dg",dg_changed);
		}

//		function that gets called when we change datagrid from outside the class, so we can our original_dp
		private function dg_changed(e:PropertyChangeEvent):void
		{
//			dg.dataProvider.list.source is because of the structure of the dataProvider
			original_dp = new ArrayCollection(dg.dataProvider.list.source);
		}

//		function to call for each search we execute
		private function search(e:TextOperationEvent):void
		{
//			first we need to check if the text field of our component is not empty and if our datagrid's dataprovider acctualy has some data
			if ( this.text != "" && dg.dataProvider != null )
			{
//				now we have to check that our original_dp has some data, if not we copy our datagrid's dataprovider to our original_dp
				if ( original_dp == null )
				{
					original_dp = new ArrayCollection(dg.dataProvider.list.source);
				}

				/*Some temporarly variables:
					temp_array: will be the array of our search resaults.	For each item that has matching term it stores index and value.
					s,i: are for our for loops*/
				var i:int;
				var temp_array:Array = new Array();
				var s:String;

				if ( original_dp != null && this.text != "" )
				{
//					for loop to go trough all our items in the datagrid
					for(i=0;i<original_dp.length;i++)
					{
//						for loop to go trough all properties of our Objects in each of our rows in DataGrid
						for(s in original_dp[i])
						{
							/*we search for our term with indexOf function
							indexOf returns -1 only when our string doesn't contain searched term, otherwise it returns the starting index of the term*/
							if ( String(original_dp[i][s]).indexOf(this.text) != -1 )
							{
//								finally if we find our string we add that item to our resault array
								temp_array.push({index: i,value: String(original_dp[i][s])});
//								if we have two columns that both contain our search term in one row, we need to break for loop so that we don't add the same item twice (once for each found term)
								break;
							}
						}
					}
				}

//				manipulating part of our search function, we have the resaults we now need to show them
//				first we need to check if we want to show only matching rows or all of them (showOnlyResult==true)
				if ( showOnlyResults )
				{
//					we add all the matching items to our temp_dp
					temp_dp = new ArrayCollection();
					for(i=0;i<temp_array.length;i++)
					{
						temp_dp.addItem(original_dp[temp_array[i].index]);
					}

//					and change dataProvider for our DataGrid so that only matching rows are shown
					dg.dataProvider = temp_dp;
				}
//				if showOnlyResault==false than we will display all the items and select the first matching row
				else
				{
//					since we don't use for loop here, we have to first check if we have any resalty (length of temp_array > 0)
					if ( temp_array.length > 0 )
					{
//						simply selecting the first matching row and scrolling to that index
						dg.selectedIndex = temp_array[0].index;
						dg.scrollToIndex(temp_array[0].index);
					}
					else
					{
//						if we don't have any mathing rows we want to deselect any selected item... It happens when we end our search (clear the searching text field)
						dg.selectedIndex = -1;
					}
				}
			}
//			if we clear the searching text field and we have showOnlyResults==true we want to put original dataProvider to our DataGrid otherwise we will get empty datagrid because we aren't searching if the searching text field is empty
			else if ( showOnlyResults )
			{
				dg.dataProvider = original_dp;
			}
		}
	}
}


/*

USAGE
-----------------
<fx:Declarations>
	<!-- Place non-visual elements (e.g., services, value objects) here -->
</fx:Declarations>

<fx:Script>
	<![CDATA[
		import mx.collections.ArrayCollection;

//			data provider for out datagrid ( so we have some data to search for:))
		[Bindable] private var dp:ArrayCollection = new ArrayCollection([{column1: "abc1",column2: "abc2",column3: "abc3"},{column1: "bcd1",column2: "bcd2",column3: "bcd3"},{column1: "cde1",column2: "cde2",column3: "cde3"},{column1: "def1",column2: "def2",column3: "def3"},{column1: "efg1",column2: "efg2",column3: "efg3"},{column1: "fgh1",column2: "fgh2",column3: "fgh3"},{column1: "ghi1",column2: "ghi2",column3: "ghi3"}]);

	]]>
</fx:Script>

<!-- Our new component which has all the properties of normal spark TextInput + custom properties: dg and showOnlyResults (this one is not required)-->
<s:Label text="Search:" left="10" top="15"/><components:SearchTextInput dg="{data_grid}" left="55" top="10"/>

<mx:DataGrid id="data_grid" dataProvider="{dp}" left="10" top="50" right="10">
	<mx:columns>
		<mx:DataGridColumn dataField="column1"/>
		<mx:DataGridColumn dataField="column2"/>
		<mx:DataGridColumn dataField="column3"/>
	</mx:columns>
</mx:DataGrid>

*/

