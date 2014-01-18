package com.abc.components
{
	import mx.controls.TextInput;
	import mx.controls.Image;

	public class SearchTextInput extends TextInput
	{
		[Embed(source='find.png')]
		private var searchIcon:Class;   
		private var searchImg:Image;        

		override protected function createChildren():void
		{
			super.createChildren();
			searchImg = new Image();
			searchImg.source = searchIcon;
			searchImg.width=16;
			searchImg.height=16;
			searchImg.x = 2;
			searchImg.y = 3;

			setStyle("paddingLeft",searchImg.width+2);
			addChild(searchImg);

		}
	}
}

