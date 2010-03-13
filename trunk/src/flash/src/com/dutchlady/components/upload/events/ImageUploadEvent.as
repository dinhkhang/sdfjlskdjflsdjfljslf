package com.dutchlady.components.upload.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Hai Nguyen
	 */
	public class ImageUploadEvent extends Event {
		public static const UPLOAD_START				: String = "imageUploadStart";
		public static const UPLOAD_COMPLETE				: String = "imageUploadComplete";
		
		public static const SAVE_IMAGE_COMPLETE			: String = "saveImageComplete";
		
		public static const SAVE_IMAGE_PROFILE_COMPLETE : String = "saveImageProfileComplete";
		
		public var fileName						: String = "";
		public var uploadedImageUrl				: String = "";
		
		public function ImageUploadEvent(type:String, fileName: String, uploadedImageUrl: String, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
			this.fileName = fileName;
			this.uploadedImageUrl = uploadedImageUrl;
		} 
		
		public override function clone():Event { 
			return new ImageUploadEvent(type, fileName, uploadedImageUrl, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("ImageUploadEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}