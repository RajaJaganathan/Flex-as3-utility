package com.xinote.utils
{
	
	import com.adobe.utils.ArrayUtil;
	import com.xinote.constants.ApplicationConstants;
	import com.xinote.controls.ExtendedList;
	import com.xinote.lib.crypto.MD5;
	import com.xinote.models.ModelLocator;
	
	import flash.utils.ByteArray;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.rpc.xml.SimpleXMLEncoder;
	import mx.utils.ObjectUtil;
	
	import spark.layouts.RowAlign;
	
	public class XinoteUtil
	{		
		public static const SECTION_LIST:String = "sectionListTabBar";
		public static const PAGE_LIST:String = "pageListTabBar";
		public static const XINOTE_DB_PWD:String = "Passw0rd";
		
		public static function findIndex(whichArray:ArrayCollection,whichProperty:String, whichItem:String):int
		{			
			var lengthAC:int = whichArray.length;
			
			for(var index:uint = 0; index < lengthAC; index++)
			{
				if(whichArray[index][whichProperty] == whichItem)
				{
					return index;
				}
				/*if(!whichArray[index].hasOwnProperty(whichProperty))
				   {
				   Alert.show(whichProperty +  'not in object','XinoteUtil - findIndex');
				   return -1;
				   }*/
			}
			return -1;
		}
		
		public static function refreshList(list:ExtendedList):void
		{			
			if(!list)
				return;
			
			list.invalidateProperties();
			list.invalidateDisplayList();
			list.invalidateSize();
			list.invalidateSkinState();
			list.validateNow();
		}
		
		public static function refreshDataProvider(list:ExtendedList,ac:ArrayCollection):void
		{			
			//list.dataProvider = null;
			//list.dataProvider = ac;		
		}
		
		
		public static function updateColorInArrayCollection(data:Object, color:uint, sectionAC:ArrayCollection, pageAC:ArrayCollection):void
		{
			var lengthAC:int = sectionAC.length;
			var requiredSection:Object = null;
			//var indexOfSection:int = sectionAC.getItemIndex(data);
			var indexOfSection:int = findIndex(sectionAC,'section_id',data.section_id);
			
			if (indexOfSection == -1)
			{
				Alert.show('I cannot get object from section :: '+ObjectUtil.toString(data))
				Alert.show('selected section :: '+ObjectUtil.toString(sectionAC));				
				return;
			}
			
			requiredSection = sectionAC.getItemAt(indexOfSection);
			
			if(!requiredSection.hasOwnProperty('color'))
				return;
			
			sectionAC.getItemAt(indexOfSection)['color'] = color;
			
			//sectionAC.refresh(); //Don't refresh here because states goes to normal from selected in sectionTabBar
			
			if (pageAC == null || pageAC.length == 0)
				return;
			
			lengthAC = pageAC.length;
			
			//pageAC.disableAutoUpdate();			
			
			for (var index:int = 0; index < lengthAC; index++)
			{
				if (pageAC[index]['section_id'] == requiredSection.section_id && pageAC[index].hasOwnProperty('color'))
				{
					pageAC[index]['color'] = color;
					
				}
			}
			
			pageAC.refresh();			
		
		}
		
		public static function updateColorInArrayCollection123(data:Object,color:uint,ac:ArrayCollection):void
		{
			var lengthAC:int  = ac.length;
			
			if (!ac && lengthAC == 0)
				return;	
			ac.disableAutoUpdate();
			
			for (var index:int = 0; index < lengthAC; index++)
			{
				if(ac.hasOwnProperty('color'))
				{
					ac[index]['color'] = color;
				}
				
			}
			
			ac.enableAutoUpdate();
			ac.refresh();		
		}
		
		
		/**
		 *
		 * @param rest
		 *
		 */		
		public static function clearArrayCollection(... rest):void
		{
			for (var index:int = 0; index < rest.length; index++)
			{
				var ac:ArrayCollection = rest[index] as ArrayCollection;
				if(!ac && ac.length==0)
					return;				
				ac.disableAutoUpdate();
				ac.source = [];
				ac.enableAutoUpdate();
				ac.refresh();				
			}		
		}
		
		/**
		 * This function for when delete the item we have to  select next item based on deleted Index value
		 * @param deletedIndex
		 * @param ac
		 * @return
		 *
		 */		
		public static function findNextSelectedIndex(deletedIndex:int,ac:ArrayCollection):int
		{
			//To select next section	
			if (deletedIndex == 0) //assume zero if we delete first tab section
			{
				deletedIndex =  -1;
				if (ac.length > 0)
				{
					deletedIndex = 0;								
				}							
			}
			else if (deletedIndex > 0) // if gt zero then select next section tab (last-1)
			{
				deletedIndex = deletedIndex - 1;
			}
			
			return deletedIndex;
		}
		
		
		/**
		 *
		 * @param password
		 * @return
		 *
		 */
		public static function createEncryptionKey(password:String):ByteArray
		{
			var ba:ByteArray = new ByteArray();
			ba.writeUTFBytes(password);
			var md5:MD5 = new MD5();
			var output:ByteArray = md5.hash(ba);
			return output;
		}
		
		/**
		 *
		 * @param targetList
		 *
		 */
		
		public static function dragAndDropOnlyOnTarget(targetList:String):void
		{
			var pageTabBar:ExtendedList = ModelLocator.getInstance().pageTabBar;
			var sectionTabBar:ExtendedList = ModelLocator.getInstance().sectionTabBar;
			
			switch (targetList)
			{
				case SECTION_LIST:
					
					if (pageTabBar && sectionTabBar)
					{
						pageTabBar.dragEnabled = true
						pageTabBar.dragMoveEnabled = false;
						pageTabBar.dropEnabled = false;
						sectionTabBar.dragEnabled = true
						sectionTabBar.dragMoveEnabled = true;
						sectionTabBar.dropEnabled = true;
					}
					break;
				
				case PAGE_LIST:
					
					if (pageTabBar && sectionTabBar)
					{
						pageTabBar.dragEnabled = true
						pageTabBar.dragMoveEnabled = true;
						pageTabBar.dropEnabled = true;
						sectionTabBar.dragEnabled = true
						sectionTabBar.dragMoveEnabled = false;
						sectionTabBar.dropEnabled = false;
					}
					
					break;
				
			}
		}
		
		public static function toggleDragAndDropPageList(enable:Boolean):void
		{
			var pageTabBar:ExtendedList = ModelLocator.getInstance().pageTabBar;
			if(pageTabBar)
			{
				pageTabBar.dragEnabled = enable;
				pageTabBar.dragMoveEnabled = enable;
				pageTabBar.dropEnabled = enable;				
			}			
		}
		
		public static function updateOrderInCollection(collection:ArrayCollection,propertyName:String):void
		{
			var collectionLength:int = collection.length;				
			
			//To avoid frequent update on arraycollection
			collection.disableAutoUpdate();	
			
			for (var iIndex:int = 0; iIndex < collectionLength; iIndex++)
			{
				var currentSectionObj:Object = collection.getItemAt(iIndex);
				
				if (currentSectionObj && currentSectionObj.hasOwnProperty(propertyName))
				{
					currentSectionObj[propertyName] = iIndex;					
				}
			}		
			
			collection.enableAutoUpdate();		
		}
		
		
		
		
		/**
		 *
		 * @param sourceCollection
		 * @param checkBy
		 * @return
		 *
		 */
		
		public static function isDuplicateExist(sourceCollection:ArrayCollection, checkBy:String):Boolean
		{
			var sourceArray:Array = sourceCollection.toArray();
			var tmpArray:Array = [];
			var value:int;
			var startIndex:int;
			var endIndex:int;
			
			for (var index:int = 0; index < sourceArray.length; index++)
			{
				//Check property exist in collection otherwise skip that particluar object
				if (!sourceArray[index].hasOwnProperty(checkBy))
					continue;
				value = sourceArray[index][checkBy];
				tmpArray.push(value);
				startIndex = tmpArray.indexOf(value);
				endIndex = tmpArray.lastIndexOf(value);
				
				if (startIndex != endIndex)
				{
					return true
				}
			}
			return false;
		}
		
		/**
		 *
		 * @param obj
		 * @return
		 *
		 */				
		public static function objectToXML(obj:Object):XML 
		{
			var qName:QName = new QName("root");
			var xmlDocument:XMLDocument = new XMLDocument();
			var simpleXMLEncoder:SimpleXMLEncoder = new SimpleXMLEncoder(xmlDocument);
			var xmlNode:XMLNode = simpleXMLEncoder.encodeValue(obj, qName, xmlDocument);
			var xml:XML = new XML(xmlDocument.toString());
			
			return xml;
		}
		
		public static function constructHierarchicalXML(ac:ArrayCollection):XML
		{
			//return objectToXML(ac);
			
			var hcXML:XML=<notebooks/>;			
			var length:int = ac.length;
			
			for(var index:int=0;index<length;index++)
			{
				var noteBookXML:XML = <notebook></notebook>;
				var sectionXML:XML = <section></section>;
				var pageXML:XML = <page></page>;
				var rowObj:Object = ac.getItemAt(index);
				
				noteBookXML.@notebook_id=rowObj.notebook_id;
				noteBookXML.@title=rowObj.notebook_title;
				
				sectionXML.@section_id=rowObj.section_id;
				sectionXML.@title=rowObj.section_title;
				
				pageXML.@page_id=rowObj.page_id;
				pageXML.@title=rowObj.title;
				
				noteBookXML.appendChild(sectionXML.appendChild(pageXML));
				hcXML.appendChild(noteBookXML);
				
			}			
			
			return hcXML;
		}
	
	/*public static function constructHierarchicalArrayCollection(ac:ArrayCollection):ArrayCollection
	   {
	   var hcArrayCollection:ArrayCollection;
	   var length:int = ac.length;
	
	   for(var index:int=0;index<length;index++)
	   {
	   var noteBookAC:ArrayCollection;
	   var sectionAC:ArrayCollection;
	   var pageAC:ArrayCollection;
	
	   var rowObj:Object = ac.getItemAt(index);
	
	   // Wrap each top-level node in an ArrayCollection.
	   col1 = new ArrayCollection(nestArray1);
	   col2 = new ArrayCollection(nestArray2);
	
	
	   var obj:Object = {};
	
	   obj.notebook_id = rowObj.notebook_id;
	   obj.title = rowObj.notebook_title;
	
	
	   }
	
	   return hcArrayCollection;
	   }*/
	
	}
}



