package com.abc.utils
{
	
	//source : http://justinimhoff.com/data-management-utilit/
	//com.justinimhoff.library.managers
	import flash.net.ObjectEncoding;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.utils.describeType;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ListCollectionView;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.utils.ObjectUtil;
	
	/**
	 *
	 *  The DataCollectionManager class is a utility class that allows for the management of
	 *  Array, ArrayCollection, and Object. In cases where items need to be copied or cloned from multiple
	 *  items, it is better to use this class because it impliments best practices for looping
	 *  and event management.
	 *
	 * @see mx.collections.ArrayCollection
	 *
	 */
	public class DataCollectionManager extends Singleton
	{
		
		/**
		 * Copies objects from one array to another and is left to the user to manage refresh or events if using source of ArrayCollection.
		 *
		 * @param sourceCollection The collection of all the inforamation that needs to be copied
		 * @param targetCollection The collection to add to
		 *
		 */
		public function copyItemsToCollection(sourceCollection:Array, targetCollection:Array):void
		{
			var i:int = 0;
			var len:int = sourceCollection.length;
			for (; i < len; i++)
			{
				targetCollection.push(sourceCollection[i]);
			}
		}
		
		/**
		 * Removes objects from a targeted collection. The items must be of the same object memory allocation
		 *
		 * @param itemsToRemove The Array of items to be removed
		 * @param targetCollection The collection of where the items reside
		 *
		 */
		public function removeItemsFromCollection(itemsToRemove:Array, targetCollection:Array):void
		{
			var i:int = 0;
			var len:int = itemsToRemove.length;
			var itemIndex:int;
			for (; i < len; i++)
			{
				itemIndex = targetCollection.indexOf(itemsToRemove[i]);
				if (itemIndex < targetCollection.length + 1)
				{
					targetCollection.splice(itemIndex, 1);
				}
			}
		}
		
		
		/**
		 * Clones source of an ArrayCollection or Array into a target collection and manages the event lifecycle by dispatching one update.
		 *
		 * @param sourceCollection The collection of all the inforamation that needs to be copied
		 * @param targetCollection The collection to add to
		 *
		 */
		public function cloneArrayToArrayCollection(sourceCollection:Array, targetCollection:ArrayCollection):void
		{
			targetCollection.disableAutoUpdate();
//			targetCollection.removeAll();
			targetCollection.source = [];
			targetCollection.source = sourceCollection;
			targetCollection.enableAutoUpdate();
			targetCollection.refresh();
		}
		
		/**
		 * Clones source of an ArrayCollection or Array into a target collection and cast the object by the provided type.
		 * Also manages the event lifecycle by dispatching one update.
		 *
		 * @param sourceCollection The collection of all the inforamation that needs to be copied
		 * @param targetCollection The collection to add to
		 * @param classType The class to case each object as
		 *
		 */
		public function cloneArrayToArrayCollectionClassType(sourceCollection:Array, targetCollection:ArrayCollection, classType:Class):void
		{
			targetCollection.disableAutoUpdate();
			targetCollection.removeAll();
			var i:int = 0;
			var len:int = sourceCollection.length;
			for (; i < len; i++)
			{
				try
				{
					targetCollection.addItem(sourceCollection[i] as classType);
				}
				catch (err:Error)
				{
					trace('An error has occured in casting the object: ' + String(err.message));
				}
			}
			targetCollection.enableAutoUpdate();
			targetCollection.refresh();
		}
		
		/**
		 * Converts a vector object to array for easy handling and also for instances where
		 * switchng between mxml and spark components selected items.
		 *
		 * @param v The vector to copy into an Array
		 * @return An array of items that where part of the vector
		 *
		 */
		public function convertVectorToArray(vector:Object):Array
		{
			var vec:Vector.<Object> = Vector.<Object>(vector);
			var arr:Array = [];
			for each (var i:Object in vec)
			{
				arr.push(i);
			}
			return arr;
		}
		
		/**
		 * Recurively flatten nested objects and keep the property identifier and value of the property
		 *
		 * @param source The object that has information to copy
		 * @param pushTo The clean object to push properties and value into
		 *
		 */
		public function pushToFlatObject(source:Object, pushTo:Object):void
		{
			var objectInfo:Object;
			var i:int;
			var len:int;
			for each (var item:* in source)
			{
				if (ObjectUtil.isSimple(item))
				{
					objectInfo = ObjectUtil.getClassInfo(source);
					i = 0;
					len = objectInfo.properties.length;
					for (; i < len; i++)
					{
						//Show the name and the value 
						if (source[objectInfo.properties[i].localName] == item)
						{
							pushTo[objectInfo.properties[i].localName] = item;
						}
					}
				}
				else
				{
					pushToFlatObject(item, pushTo);
				}
			}
		}
		
		
		/**
		 * Converts a plain object to be an instance of the class
		 * passed as the second variable.  This is not a recursive funtion
		 * and will only work for the first level of nesting.  When you have
		 * deeply nested objects, you first need to convert the nested
		 * objects to class instances, and then convert the top level object.
		 *
		 * @param object The plain object that should be converted
		 * @param clazz The type to convert the object to
		 */
		public function objectToInstance(object:Object, clazz:Class):*
		{
			var bytes:ByteArray = new ByteArray();
			bytes.objectEncoding = ObjectEncoding.AMF0;
			
			// Write out the bytes of the original object
			var objBytes:ByteArray = new ByteArray();
			objBytes.objectEncoding = ObjectEncoding.AMF0;
			objBytes.writeObject(object);
			
			// Register all of the classes so they can be decoded via AMF
			var typeInfo:XML = describeType(clazz);
			var fullyQualifiedName:String = typeInfo.@name.toString().replace(/::/, ".");
			registerClassAlias(fullyQualifiedName, clazz);
			
			// Write the new object information starting with the class information
			var len:int = fullyQualifiedName.length;
			bytes.writeByte(0x10); // 0x10 is AMF0 for "typed object (class instance)"
			bytes.writeUTF(fullyQualifiedName);
			// After the class name is set up, write the rest of the object
			bytes.writeBytes(objBytes, 1);
			
			// Read in the object with the class property added and return that
			bytes.position = 0;
			var result:* = bytes.readObject();
			return result;
		}
		
		/**
		 * Copies properties from one object to another
		 *
		 * @param copyTo The object to copy to
		 * @param copyFrom The object to copy from = the source
		 *
		 */
		public function copyPropertiesToObject(copyTo:Object, copyFrom:Object):void
		{
			var objectInfo:Object = ObjectUtil.getClassInfo(copyFrom);
			var i:int = 0;
			var len:int = objectInfo.properties.length;
			for (; i < len; i++)
			{
				//Show the name and the value 
				if (copyTo.hasOwnProperty([ objectInfo.properties[i].localName ]))
				{
					copyTo[objectInfo.properties[i].localName] = copyFrom[objectInfo.properties[i].localName];
				}
			}
		}
		
		/**
		 * Allows the creation of multiple complex sorting for a provided collection. Provides the ability to customize the type of sort
		 * and provides support for multiple sort fields.
		 *
		 * @param collection Supports Array and ListCollectionView.
		 * @param sortItems An array of item identifiers to sort against, should be in an array of strings.
		 * @param caseInsensitive When sorting strings, tells the comparitor whether to ignore the case of the values.
		 * @param descending Tells the comparator whether to arrange items in descending order.
		 * @param numeric Tells the comparitor whether to compare sort items as numbers, instead of alphabetically.
		 *
		 */		
		public function createSort(collection:*, sortItems:Array,caseInsensitive:Boolean=false,descending:Boolean=false,numeric:Object=null):void{
			var newSortField:SortField;
			var sortFieldList:Array = [];
			//Create sort fields
			for each(var sortItem:String in sortItems){
				newSortField = new SortField(sortItem,caseInsensitive,descending,numeric);
				sortFieldList.push(newSortField);
			}
			//Create sort and assign to correct dataprovider
			var collectionSort:Sort = new Sort();
			collectionSort.fields = sortFieldList;
			if(collection is Array){
				collection.sort = collectionSort;
			}else if(collection is ListCollectionView){
				collection.sort = collectionSort;
				collection.refresh();
			}
		}
	}
}

