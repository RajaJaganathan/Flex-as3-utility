package bloom.components.data
{	
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.*;
	
	import form.models.files.File;
	
	import mx.core.IMXMLObject;
	
	import org.restfulx.utils.RxFileReference;
	
	import bloom.utils.FileUtil;
	
	[Event(name="select", type="flash.events.Event")]
	[Event(name="complete", type="flash.events.Event")]
	[Event(name="progress", type="flash.events.ProgressEvent")]

	public class FileLoader extends EventDispatcher
	{
		
		public var fileReference:RxFileReference;
		public var fileReferences:FileReferenceList;
		
		public var filesToUpload:Array = [];
		public var name:String;
		
		private var _url:String = '';
		[Bindable(event="urlChange")]
		/**
		 *  Url
		 */
		public function get url():String
		{
			return _url;
		}
		public function set url(value:String):void
		{
			if (_url == value) 
				return;
			_url = value;
			dispatchEvent(new Event("urlChange"));
		}
		
		[Bindable]
		/**
		 *  The current file
		 */
		public var file:FileReference;
		public var fileTag:String;
		/**
		 *  If set to true, it will load the file
		 */
		public var preview:Boolean = true;
		
		[Bindable]
		/**
		 *  The file data, uploaded ByteArray data for example
		 */
		public var data:*;
		
		public function FileLoader(tag:String = "attachment")
		{
			this.fileTag = tag;
		}
		
		// =======================================================
		// File Uploading
		// =======================================================
		
		public function browse(type:String = "image", multiple:Boolean = false):void
		{
			if (multiple)
			{
				addMultipleFiles();
			}
			else
			{
				
				fileReference = new RxFileReference(fileTag);
		        fileReference.reference.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
		        fileReference.reference.addEventListener(Event.SELECT, selectFile, false, 0, true);
		        fileReference.reference.addEventListener(Event.CANCEL, cancelBrowse, false, 0, true);
				fileReference.reference.addEventListener(ProgressEvent.PROGRESS, progressHandler);
		        fileReference.reference.browse(FileUtil.getFilters([type]));
			}
		}
		
		public function download(url:String):void
		{
			fileReference = new RxFileReference(fileTag);
	        fileReference.reference.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
	        fileReference.reference.addEventListener(Event.CANCEL, cancelBrowse, false, 0, true);
			fileReference.reference.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			fileReference.reference.addEventListener(Event.COMPLETE, downloadCompleteHandler);
			fileReference.reference.download(new URLRequest(url));
		}
		
		public function load(fileOrUrl:* = null):void
		{
			if (!fileOrUrl)
				fileOrUrl = this.file;
			if (!fileOrUrl)
				return;
			if (fileOrUrl is FileReference)
			{
				fileOrUrl.addEventListener(Event.COMPLETE, loadCompleteHandler);
				fileOrUrl.load();
			}
			else
			{
				
			}
		}
		
		protected function progressHandler(event:ProgressEvent):void
		{
			dispatchEvent(event);
		}
		
		protected function loadCompleteHandler(event:Event):void
		{
			data = event.target.data;
			dispatchEvent(event);
		}
		
		protected function downloadCompleteHandler(event:Event):void
		{
			data = event.target.data;
			dispatchEvent(event);
		}

		protected function fileSelected(event:Event):void
		{
			name = event.target.name;
			if (preview)
				load(event.target);
			dispatchEvent(event);
		}

		protected function ioErrorHandler(event:Event):void
		{
			//fileErrorString = "Failed to selected a file. Please try again.";
		}

		protected function selectFile(event:Event):void
		{
			fileSelected(event);
		}

		public function cancelBrowse(event:Event):void
		{
			file = null;
		}

		protected function uploadCompleteHandler(event:Event):void
		{
			//uploadFiles();
		}
		
		protected function uploadIOErrorHandler(event:IOErrorEvent):void
		{
			
		}
		
		protected function uploadSecurityErrorHandler(event:SecurityErrorEvent):void
		{
			
		}
		
		// =======================================================
		// Loading Multiple Files
		// =======================================================
		
		public function addMultipleFiles():void
		{
			fileReferences = new FileReferenceList();
			fileReferences.addEventListener(Event.SELECT, selectFiles);
			fileReferences.browse();
		}
		
		protected function selectFiles(event:Event):void
		{ 
			var alreadyAddedFiles:Array = [];
			// Get list of files from fileList, make list of files already on upload list
			var i:int = 0, n:int = filesToUpload.length;
			for (i; i < n; i++)
			{
				for (var j:int = 0; j < fileReferences.fileList.length; j++) {
					if (filesToUpload[i].name == fileReferences.fileList[j].name) {
						alreadyAddedFiles.push(fileReferences.fileList[j].name);
						fileReferences.fileList.splice(j, 1);
						j--;
					}
				}
			}
			if (fileReferences.fileList.length >= 1) {				
				for (var k:int = 0; k < fileReferences.fileList.length; k++) {
					filesToUpload.push(new File(
						fileReferences.fileList[k].name,
						Number(FileUtil.formatFileSize(fileReferences.fileList[k].size)),
						fileReferences.fileList[k]
					));
				}
			}
			
			if (alreadyAddedFiles.length >= 1) {
				dispatchEvent(new Event("alreadyUploaded"));
			//	Alert.show("The file(s): \n\n• " + alreadyAddedFiles.join("\n• ") + "\n\n...are already on the upload list. Please change the name(s) or pick a different file.", "File(s) already on list");
			}
		}
		
		public function removeFiles(selectedFiles:Array):Array
		{
			if (selectedFiles.length >= 1) {
				var n:int = selectedFiles.length;
				for (var i:int = 0; i < n; i++) {
					filesToUpload[Number(selectedFiles[i])] = null;
				}
				for (var j:int = 0; j < filesToUpload.length; j++) {
					if (filesToUpload[j] == null) {
						filesToUpload.splice(j, 1);
						j--;
					}
				}
			}
			return filesToUpload;
		}
		
		public function uploadFiles(files:Array = null):void
		{
			if (files == null)
				files = filesToUpload;
			if (files.length == 0)
				return;
		    fileReference = new RxFileReference(fileTag);
		    fileReference.reference = filesToUpload.pop().file;
		}
	}	
}