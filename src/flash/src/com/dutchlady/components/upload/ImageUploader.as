package com.dutchlady.components.upload {
	import com.dutchlady.common.Configuration;
	import com.dutchlady.components.upload.events.ImageUploadEvent;
	import com.dutchlady.constants.QueryParameter;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Hai Nguyen
	 */
	public class ImageUploader extends EventDispatcher {
		private var fileRef				: FileReference;
		private var imageTypes			: Array;
		
		private var uploadedImageUrl	: String;
		private var imageSelected		: Boolean = false;
		
		public var imageGuid			: String;
		
		public function ImageUploader() {
			var imagesType: FileFilter = new FileFilter("Images (*.jpg, *.png, *.gif)", "*.jpg;*.png;*.gif");
			imageTypes = [imagesType];
			
			fileRef = new FileReference();
			fileRef.addEventListener(Event.SELECT, imageSelectHanlder);
			fileRef.addEventListener(Event.COMPLETE, imageUploadCompleteHanlder);
		}
		
		private function imageUploadCompleteHanlder(event: Event): void {
			trace("imageUploadCompleteHanlder");
			dispatchEvent(new ImageUploadEvent(ImageUploadEvent.UPLOAD_COMPLETE, fileRef.name, uploadedImageUrl));
		}
		
		private function imageSelectHanlder(event: Event): void {
			imageSelected = true;
			upload();
		}
		
		public function browserAndUpload():void {
			fileRef.browse(imageTypes);
		}
		
		private function upload():void {
			dispatchEvent(new ImageUploadEvent(ImageUploadEvent.UPLOAD_START, fileRef.name, ""));
			//if (fileRef.size > 30000)
			
			var params: URLVariables = new URLVariables();
			params[QueryParameter.FILE_NAME] = "";
			
			imageGuid = GUID.create();
			//var request: URLRequest = new URLRequest("http://localhost:64293/FlashAPI/UploadImage.aspx?Guid=" + guid);
			uploadedImageUrl = Configuration.instance.uploadedImageBaseUrl + "originals/" + imageGuid + ".png";
			var request: URLRequest = new URLRequest(Configuration.instance.imageUploadServiceUrl + "?Guid=" + imageGuid);
			request.method = URLRequestMethod.POST;
			
			fileRef.upload(request);
		}
		
		public function saveImage(data: ByteArray, guid: String):void {
			var header: URLRequestHeader = new URLRequestHeader("Content-type", "application/octet-stream");
			var uploadedImageFileName: String = guid + ".jpg";
			var request: URLRequest = new URLRequest(Configuration.instance.saveImageServiceUrl + "?Guid=" + guid);
			request.requestHeaders.push(header);
			request.method = URLRequestMethod.POST;
			request.data = data;
			trace(request.url);
			var loader: URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, saveImageCompleteHandler);
			loader.load(request);
		}
		
		private function saveImageCompleteHandler(event: Event): void {
			dispatchEvent(new ImageUploadEvent(ImageUploadEvent.SAVE_IMAGE_COMPLETE, "", ""));
		}
	}
}