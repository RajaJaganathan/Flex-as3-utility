package com.abc.utils
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 *
	 * General Singleton management class. Extend this class to create
	 * a singleton manager.
	 *
	 */
	public class Singleton implements IEventDispatcher
	{
		/**
		 * internal dictionary to keep class instances
		 * @private
		 */
		private static var instanceDict:Dictionary = new Dictionary();
		
		/**
		 * removes the item from the dictionary for garbage collection
		 * @param managementClass
		 *
		 */
		public static function removeInstance(managementClass:Class):void
		{
			var instance:Singleton = instanceDict[managementClass];
			if (instance != null)
			{
				delete instanceDict[managementClass];
			}
		}
		
		/**
		 * Get the single instance
		 * @return the single instance
		 *
		 */
		public static function getInstance(managementClass:Class):*
		{
			var instance:Singleton = instanceDict[managementClass];
			if (instance == null)
			{
				//create a new instance of class managementClass  
				instance = Singleton(new managementClass());
				
				if (instance == null)
				{
					throw("getInstance can only be called for Classes extending Singleton");
				}
			}
			return instance;
		}
		
		/**
		 * Dispatcher to user in singletons
		 */
		protected var dispatcher:EventDispatcher = new EventDispatcher();
		
		/**
		 *
		 * We only want one of these - Singletons are actually more performant than static management classes
		 *
		 */
		public function Singleton()
		{
			onConstructor();
		}
		
		/**
		 * Used to interface with internal dispatcher
		 * @param type
		 * @param listener
		 * @param useCapture
		 * @param priority
		 * @param useWeakReference
		 *
		 */
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		/**
		 * Used to interface with internal dispatcher
		 * @param type
		 * @param listener
		 * @param useCapture
		 *
		 */
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		/**
		 * Used to interface with internal dispatcher
		 * @param event
		 * @return
		 *
		 */
		public function dispatchEvent(event:Event):Boolean
		{
			return dispatcher.dispatchEvent(event);
		}=
		
		/**
		 * Used to interface with internal dispatcher
		 * @param type
		 * @return
		 *
		 */
		public function hasEventListener(type:String):Boolean
		{
			return dispatcher.hasEventListener(type);
		}
		
		/**
		 * Used to interface with internal dispatcher
		 * @param type
		 * @return
		 *
		 */
		public function willTrigger(type:String):Boolean
		{
			return dispatcher.willTrigger(type);
		}
		
		/**
		 *
		 * Conceptually private constructor.
		 * Manages the singleton document dictionary.
		 *
		 */
		protected function onConstructor():void
		{
			var className:String = getQualifiedClassName(this);
			var managementClass:Class = getDefinitionByName(className) as Class;
			if (managementClass == Singleton)
			{
				throw("Singleton is a base class that cannot be instantiated");
			}
			var instance:Singleton = instanceDict[managementClass];
			if (instance != null)
			{
				throw("Classes extending Singleton can only be instantiated once by the getInstance method");
			}
			else
			{
				instanceDict[managementClass] = this;
			}
		}
		;
	}
}


/*


   package com.justinimhoff.library.managers
   {
   public class ViewManager extends Singleton
   {

   }
   }


   var viewManager:ViewManager = Singleton.getInstance(ViewManager);


 */

