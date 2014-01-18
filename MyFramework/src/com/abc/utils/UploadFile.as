package 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	
	[Event(name="fileSelected", type="flash.events.Event")]
	
	public class UploadFile extends Sprite
	{
		private const LOCAL_PREVIEW:String = "local_preview";
		private const UPLOAD_COMPLETE:String = "start_upload";
		
		public static const UPLOAD_URL:String = "http://localhost/upload.php"
		
		private var fileReference:FileReference;
		private var _status:String = LOCAL_PREVIEW;
		
		private var _anime:MovieClip;
		
		public function UploadFile()
		{
			trace("init");
			fileReference = new FileReference();
			addEvent()
		}
		
		private function addEvent():void
		{			
			fileReference.addEventListener(Event.SELECT, fileHandler);
			fileReference.addEventListener(Event.CANCEL, fileHandler);
			fileReference.addEventListener(Event.OPEN, fileHandler);
			fileReference.addEventListener(Event.SELECT, fileHandler);
			fileReference.addEventListener(Event.COMPLETE, fileHandler);
            
			fileReference.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, uploadCompleteHandler);
			fileReference.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			fileReference.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            fileReference.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            fileReference.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			
		}
		
		private var filterType:FileFilter;
		
		public function browseFile():void
		{	
			fileReference.browse([filterType]);
		}
		
		private function getImageTypeFilter():FileFilter
		{
			return new FileFilter("Images (*.jpg, *.jpeg, *.gif, *.png)", "*.jpg;*.jpeg;*.gif;*.png");
		}
		
		private function getTextTypeFilter():FileFilter
		{
			return new FileFilter("Text Files (*.txt, *.rtf)", "*.txt;*.rtf");
		}
		
		public function set fileFilterType(value:String):void
		{
			if(value == "image")
				filterType = getImageTypeFilter();
			else
				filterType = getTextTypeFilter();				
		}
		
		public function cancel():void
		{
			fileReference.cancel();
			dispatchEvent(new Event(Event.CANCEL));
		}
		
		
		private var uploadURL:URLRequest;
		private var _tempFileName:String = "music";
		
		public function upload(url:String):void
		{
			uploadURL = new URLRequest(url);
			
			var newName:String = _tempFileName;
			var vars:URLVariables = new URLVariables();
				vars.file_name = newName;
				
			uploadURL.data = vars;
			uploadURL.method = URLRequestMethod.POST;
			fileReference.upload(uploadURL);
		}
				
		private function fileHandler(event:Event):void 
		{
			switch(event.type) {  
                case Event.COMPLETE:
					if (_status == UPLOAD_COMPLETE) {
						trace("sound has uploaded.");						
						_tempFileName = escape(event.target.name);
					}
					break;  
                case Event.SELECT:
					trace("select");
					_status = LOCAL_PREVIEW;
					dispatchEvent(new Event(Event.SELECT));
					dispatchEvent(new Event("fileSelected"));
					//loader.getSound(fileReference);
                    break;  
                case Event.OPEN:
					trace("open");
                    break; 
				case Event.CANCEL:
					trace("cancel");	
					break;
			}
        }
		
		private function uploadCompleteHandler(event:DataEvent):void {
            // trace("upload_complete_data");
			_status = UPLOAD_COMPLETE;
			dispatchEvent(new Event(Event.COMPLETE));
        }
		
		private function httpStatusHandler(event:HTTPStatusEvent):void {
             trace("httpStatusHandler: " + event + " ,status" + event.status);
        }
        
        private function ioErrorHandler(event:IOErrorEvent):void {
             trace("ioErrorHandler: " + event);
        }
		private function securityErrorHandler(event:SecurityErrorEvent):void {
            trace("securityErrorHandler: " + event);
        }

		private function progressHandler(event:ProgressEvent):void {
			trace("sound is uploading now.");
			if (hasAnimeMovie){
				var percentage:Number = (Math.floor((event.bytesLoaded / event.bytesTotal) * 100));
				_anime.info_txt.text = "File is uploading now, wait a moment please.\nLoading..." + percentage + "%";
				_anime.bar_mc.scaleX = percentage / 100;
			}
        }
		
		

		
		public function getTempSoundName():String
		{
			return _tempFileName;
		}
		
		private var hasAnimeMovie:Boolean = false;
		public function setAnime(mc:MovieClip):void
		{
			hasAnimeMovie = true;
			_anime = mc;
		}
		
		public function getInfo():String
		{
			var creator:String = (fileReference.creator == null)? "":fileReference.creator;
			var time:Date  = fileReference.modificationDate;
			var year:String  = String(time.fullYear);
			var month:String = String(time.month +1);
			var day:String   = String(time.day);
			var size:String  = (fileReference.size > 1024 * 1024)? Math.round(fileReference.size * 100 / (1024 * 1024)) / 100 + "MB":Math.round(fileReference.size * 10 / 1024) / 10 + "KB";

			var str:String = "creator : " + creator;
				//str += "" + fileReference.data;
				str += "\nyear： " + year + "." + month + "." + day;
				str += "\nname： " + fileReference.name;
				str += "\nsize： " + size;
			
			return str;
		}
		
		
		
	}
}


/* USAGE

	private var uploadFile:UploadFile = new UploadFile();

	private function init():void
	{
	}

	protected function onClickHandler(event:MouseEvent):void
	{
		uploadFile.fileFilterType = "image1";
		uploadFile.browseFile();
		uploadFile.addEventListener("fileSelected",onFileSelectionHandler);
	}
	
	protected function uploadData(event:MouseEvent=null):void
	{
		uploadFile.upload(UploadFile.UPLOAD_URL);
	}
	
	protected function onFileSelectionHandler(event:Event):void
	{
		uploadData();				
	}

*/


