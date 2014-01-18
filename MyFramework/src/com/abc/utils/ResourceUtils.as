package com.xinote.utils
{
	
	import mx.containers.FormItem;
	import mx.core.UIComponent;
	import mx.resources.ResourceManager;
	
	public class ResourceUtils
	{
		private var _bundleName:String;
		
		public function ResourceUtils( bundleName:String )
		{
			_bundleName = bundleName;
		}
		
		public function getString( key:String ):String
		{
			return ResourceManager.getInstance().getString( _bundleName, key );
		}
		
		public static function setLabels( container:UIComponent, bundleName:String = null ):void
		{
			if (!bundleName)
			{
				bundleName = container.className;
			}
			
			setChildLabels( container, bundleName );
		}
		
		private static function setChildLabels( container:UIComponent, bundleName:String ):void
		{
			for (var x:uint; x < container.numChildren; x++)
			{
				var child:Object = container.getChildAt( x );
				
				if (child is UIComponent)
				{
					ResourceUtils.setChildLabels( child as UIComponent, bundleName );
					
					var label:String = ResourceManager.getInstance().getString( bundleName, child.id );
					
					if (!label)
					{
						continue;
					}
					
					if (UIComponent( child ).parent is FormItem)
					{
						var formItem:FormItem = UIComponent( child ).parent as FormItem;
						formItem.label = label;
					}
					else if (child.hasOwnProperty( "prompt" ))
					{
						child.prompt = label;
					}
					else if (child.hasOwnProperty( "label" ))
					{
						child.label = label;
					}
					else if (child.hasOwnProperty( "text" ))
					{
						child.text = label;
					}
				}
			}
		}
	}
}

//http://hillelcoren.com/2008/09/12/resource-bundles-in-flex-wo-lots-of-extra-code/

