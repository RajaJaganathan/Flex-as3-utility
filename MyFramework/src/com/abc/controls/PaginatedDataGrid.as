package com.abc.controls
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.mx_internal;
	import mx.events.DataGridEvent;

	use namespace mx_internal;

	/**
	 * PaginatedDataGrid is a DataGrid that displays in pages instead of a single list.
	 */
	public class PaginatedDataGrid extends DataGrid {

		private var _page:int = 0;

		[Bindable(event="pageChanged")]
		public function get page():int {
			return _page;
		}

		public function set page(value:int):void {
			_page = Math.max(Math.min(value, pageCount - 1), 0);
			populatePage(_page);
			dispatchEvent(new Event("pageChanged"));
			dispatchEvent(new Event("isFirstPageChanged"));
			dispatchEvent(new Event("isLastPageChanged"));
		}

		[Bindable(event="isFirstPageChanged")]
		public function get isFirstPage():Boolean {
			return (page == 0);
		}

		[Bindable(event="isLastPageChanged")]
		public function get isLastPage():Boolean {
			return (page == (pageCount - 1));
		}
		
		[Bindable(event="pageCountChanged")]
		public function get pageCount():int {
			var count:int = 0;
			if (_entireDataProvider) {
				count = Math.max(Math.ceil(_entireDataProvider.length / pageSize), 0); 
			}
			return count;
		}

		[Bindable]
		public function get pageSize():int {
			return rowCount;
		}

		public function set pageSize(value:int):void {
			rowCount = value;
		}

		protected var _entireDataProvider:Array; 		

		/**
		 * Use entireDataProvider instead of dataProvider as dataProvider is used internally to
		 * represent data for a single page. entireDataProvider currently only supports Arrays.
		 */
		[Bindable]
		public function get entireDataProvider():Array {
			return _entireDataProvider;
		}

		public function set entireDataProvider(value:Array):void {
			_entireDataProvider = value;
			_entireCollection.source = value;
			dispatchEvent(new Event("pageCountChanged"));
			page = 0;
		}

		override public function set dataProvider(value:Object):void {
			throw new Error("dataProvider is set internally by PaginatedDataGrid. Use entireDataProvider.");
		}

		protected var _entireCollection:ArrayCollection;

		protected var _pageDataProvider:Array;

		protected var _savedSortIndex:int;

		protected var _savedSortDirection:String;

		public function PaginatedDataGrid() {
			super();
			_entireCollection = new ArrayCollection();
			_pageDataProvider = new Array();
			addEventListener(DataGridEvent.HEADER_RELEASE, headerReleaseHandler);
		}

		/**
		 * Populates the dataProvider with data for the given page from entireDataProvider.
		 */
		protected function populatePage(pageNum:int):void {
			if (_entireDataProvider == null) {
				return;
			}
			var start:int = pageNum * pageSize;
			var end:int = start + pageSize;
			end = Math.min(_entireCollection.length, end);
			_pageDataProvider.splice(0);
			for (var i:int = start; i < end; i++) {
				_pageDataProvider.push(_entireCollection.getItemAt(i));
			}
			super.dataProvider = _pageDataProvider;
			// apply sorting that was lost due to dataProvider change
			if (_savedSortDirection != null) {
				sortIndex = _savedSortIndex;	
				sortDirection = _savedSortDirection;
			}
		}

		protected function headerReleaseHandler(event:DataGridEvent):void {
			event.preventDefault();
			sortByColumn(event.columnIndex);
		}

		protected function sortByColumn(index:int):void {
			/*
			 * Logic nearly entirely taken from DataGrid.sortByColumn().
			 */

			var c:DataGridColumn = columns[index];
			var desc:Boolean = c.sortDescending;

			// do the sort if we're allowed to
			if (c.sortable) {
				var s:Sort = _entireCollection.sort;
				var f:SortField;
				if (s) {
					s.compareFunction = null;
					// analyze the current sort to see what we've been given
					var sf:Array = s.fields;
					if (sf) {
						for (var i:int = 0; i < sf.length; i++) {
							if (sf[i].name == c.dataField) {
								// we're part of the current sort
								f = sf[i]
								// flip the logic so desc is new desired order
								desc = !f.descending;
								break;
							}
						}
					}
				} else {
					s = new Sort;
				}
				if (!f) {
					f = new SortField(c.dataField);
				}

				c.sortDescending = desc;
				var dir:String = (desc) ? "DESC" : "ASC";
				sortDirection = dir;

				// set the grid's sortIndex
				lastSortIndex = sortIndex;
				sortIndex = index;

				// save sort information to be applied when dataProvider changes
				_savedSortIndex = sortIndex;
				_savedSortDirection = sortDirection;

				// if you have a labelFunction you must supply a sortCompareFunction
				f.name = c.dataField;
				if (c.sortCompareFunction != null) {
					f.compareFunction = c.sortCompareFunction;
				} else {
					f.compareFunction = null;
				}
				f.descending = desc;
				s.fields = [f];
			}
			_entireCollection.sort = s;
			_entireCollection.refresh();
			populatePage(page);

		}

	}
}




/* <mx:VBox verticalCenter="0" horizontalCenter="0" width="500" height="500">
	<mx:HBox width="100%">
		<mx:Label text="Page {dataGrid.page + 1} of {dataGrid.pageCount}"/>
		<mx:Spacer width="100%"/>
		<mx:Button label="Previous"
				enabled="{!dataGrid.isFirstPage}"
				click="{dataGrid.page--}"/>
		<mx:Button label="Next"
				enabled="{!dataGrid.isLastPage}"
				click="{dataGrid.page++}"/>
		<mx:Button label="Go To:"
				click="{dataGrid.page = int(goToPageInput.text) - 1}"/>
		<mx:TextInput id="goToPageInput" width="50"/>
	</mx:HBox>
	<controls:PaginatedDataGrid id="dataGrid" width="100%"
			draggableColumns="false"
			entireDataProvider="{_players}"
			pageSize="5">
		<controls:columns>
			<mx:DataGridColumn dataField="number" width="100"/>
			<mx:DataGridColumn dataField="first"/>
			<mx:DataGridColumn dataField="last"/>
		</controls:columns>
	</controls:PaginatedDataGrid>
</mx:VBox>	*/

