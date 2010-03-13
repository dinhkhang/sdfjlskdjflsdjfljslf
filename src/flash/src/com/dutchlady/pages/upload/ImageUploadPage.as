package com.dutchlady.pages.upload {
	import com.adobe.images.JPGEncoder;
	import com.dutchlady.common.Configuration;
	import com.dutchlady.components.upload.events.ImageUploadEvent;
	import com.dutchlady.components.upload.ImageFrame;
	import com.dutchlady.components.upload.ImageUploader;
	import com.dutchlady.components.upload.ImageUploadForm;
	import com.dutchlady.components.upload.ImageUploadResult;
	import com.dutchlady.components.upload.SendImageToFriend;
	import com.dutchlady.events.PageEvent;
	import com.dutchlady.pages.BasePage;
	import fl.transitions.easing.None;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Hai Nguyen
	 */
	public class ImageUploadPage extends BasePage {
		public var imageFrameContainerMovie		: MovieClip;
		public var uploadFormMovie				: ImageUploadForm;
		public var uploadResultMovie			: ImageUploadResult;
		public var sendToFriendMovie			: SendImageToFriend;
		
		public var uploadedImageFileName: String = "";
		
		public function ImageUploadPage() {
			uploadResultMovie.visible = false;
			sendToFriendMovie.visible = false;
			
			uploadFormMovie.addEventListener(ImageUploadEvent.UPLOAD_COMPLETE, imageUploadCompleteHandler);
			uploadFormMovie.addEventListener(ImageUploadEvent.SAVE_IMAGE_PROFILE_COMPLETE, saveImageProfileCompleteHandler);
		}
		
		private function saveImageProfileCompleteHandler(event: ImageUploadEvent): void {
			uploadFormMovie.visible = false;
			sendToFriendMovie.visible = false;
			uploadResultMovie.visible = true;
			uploadResultMovie.uploadedImageUrl = event.uploadedImageUrl;
		}
		
		private function imageUploadCompleteHandler(event: ImageUploadEvent): void {
			imageFrameContainerMovie.imageFrameMovie.changeImage(event.uploadedImageUrl);
		}
		
		private function reset():void {
			uploadFormMovie.visible = true;
			sendToFriendMovie.visible = true;
			uploadResultMovie.visible = false;
	
			uploadFormMovie.reset();
			sendToFriendMovie.reset();
			
			//
			//uploadFormMovie.visible = false;
			//sendToFriendMovie.visible = true;
			
		}
		
		// OVERRIDE
		
		override public function startBeginPage(): void {
			reset();
			this.dispatchEvent(new PageEvent(PageEvent.STAR_BEGIN_PAGE));
			completeBeginPage();
		}
		
		override public function completeBeginPage():void {
			this.dispatchEvent(new PageEvent(PageEvent.COMPLETE_BEGIN_PAGE));
			
		}
		
		override public function startEndPage():void {
			this.dispatchEvent(new PageEvent(PageEvent.STAR_BEGIN_PAGE));
			completeEndPage();
		}
		
		override public function completeEndPage():void {
			this.dispatchEvent(new PageEvent(PageEvent.COMPLETE_END_PAGE));
		}
		
		public function captureImageFrame():BitmapData {
			var bitmapData: BitmapData = new BitmapData(495, 570, true, 0xFFFFFF);
			bitmapData.draw(imageFrameContainerMovie, null, null, null, null, true);
			
			return bitmapData;
		}
	}

}