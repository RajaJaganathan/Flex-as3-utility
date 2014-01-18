package com.abc.utils
{
	import flash.events.Event;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.FileReferenceList;
	import flash.net.URLRequest;
	
	public class UploadUtils
	{
		public static var imagesFilter:FileFilter = new FileFilter("Images", "*.jpg;*.gif;*.png");
		
		public static const UPLOAD_URL:String = "upload.php"
		
		public function UploadUtils()
		{
		}
		
		private function getImageTypeFilter():FileFilter
		{
			return new FileFilter("Images (*.jpg, *.jpeg, *.gif, *.png)", "*.jpg;*.jpeg;*.gif;*.png");
		}
		
		private function getTextTypeFilter():FileFilter
		{
			return new FileFilter("Text Files (*.txt, *.rtf)", "*.txt;*.rtf");
		}
		
		public static function upload(event:Event):void
		{
			var fileList:Array = FileReferenceList.fileList;
			for (var i:Number = 0; i < fileList.length; i++)
			{
				var urlRequest:URLRequest = new URLRequest(UPLOAD_URL);
				var file:FileReference = FileReference(fileList[i]);
				file.upload(urlRequest);
			}
		}
		
	}
}

/* USAGE



*/

