package com.dutchlady.components.upload {
	import com.dutchlady.common.Configuration;
	import com.dutchlady.common.GlobalVars;
	import com.dutchlady.events.PageEvent;
	import com.dutchlady.services.AppServices;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileReference;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author Hai Nguyen
	 */
	public class ImageUploadResult extends Sprite {
		public var iLoveDutchLadyButton		: SimpleButton;
		public var saveImageButton			: SimpleButton;
		public var sendToFriendButton		: SimpleButton;
		
		public var loadingMovie				: MovieClip;
		
		public var uploadedImageUrl: String = "";
		
		private var downloadFileRef: FileReference;
		
		public function ImageUploadResult() {
			loadingMovie.visible = false;
			
			iLoveDutchLadyButton.addEventListener(MouseEvent.CLICK, iLoveDutchLadyButtonClickHandler);
			saveImageButton.addEventListener(MouseEvent.CLICK, saveImageButtonClickHandler);
			sendToFriendButton.addEventListener(MouseEvent.CLICK, sendToFriendButtonClickHandler);
		}
		
		private function sendToFriendButtonClickHandler(event: MouseEvent): void {
			
		}
		
		private function saveImageButtonClickHandler(event: MouseEvent): void {
			downloadFileRef = new FileReference();
			downloadFileRef.addEventListener(Event.OPEN, downloadOpenHandler);
			downloadFileRef.addEventListener(Event.COMPLETE, downloadCompleteHandler);
			trace(uploadedImageUrl);
			downloadFileRef.download(new URLRequest(uploadedImageUrl), "dutch_lady.png");
		}
		
		private function downloadOpenHandler(event: Event): void {
			trace("downloadOpenHandler");
			loadingMovie.visible = true;
		}
		
		private function downloadCompleteHandler(event: Event): void {
			trace("downloadCompleteHandler");
			loadingMovie.visible = false;
			
			// update donate
			var service: AppServices = new AppServices(Configuration.instance.updateDonateServiceUrl);
			service.updateDonate("Save-To-My-Computer");
		}
		
		private function iLoveDutchLadyButtonClickHandler(event: MouseEvent): void {
			GlobalVars.mainTimeLine.dispatchEvent(new PageEvent(PageEvent.GO_TO_ILOVEPAGE));
		}
		
	}

}