package com.dutchlady.components.upload {
	import com.adobe.images.PNGEncoder;
	import com.dutchlady.common.Configuration;
	import com.dutchlady.common.GlobalVars;
	import com.dutchlady.components.upload.events.ImageUploadEvent;
	import com.dutchlady.events.PageEvent;
	import com.dutchlady.http.HttpService;
	import com.dutchlady.http.HttpServiceEvent;
	import com.dutchlady.pages.upload.ImageUploadPage;
	import com.dutchlady.services.AppServices;
	import com.dutchlady.validators.CompositeValidator;
	import com.dutchlady.validators.EmailValidator;
	import com.dutchlady.validators.RequiredStringValidator;
	import com.dutchlady.validators.ValidationResult;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import swfaddress.SWFAddress;
	/**
	 * ...
	 * @author Hai Nguyen
	 */
	public class ImageUploadForm extends Sprite {
		public var selectImageButton		: SimpleButton;
		public var imageUrlText				: TextField;
		public var fullNameText				: TextField;
		public var emailText				: TextField;
		public var mobileNumberText			: TextField;
		public var sendButton				: SimpleButton;
		public var cancelButton				: SimpleButton;
		public var loadingMovie				: MovieClip;
		
		public var imageUrlBgMovie			: MovieClip;
		public var fullNameBgMovie			: MovieClip;
		public var emailBgMovie				: MovieClip;
		public var mobileNumberBgMovie		: MovieClip;
		
		private var compositeValidator		: CompositeValidator;
		private var fieldBgMap				: Dictionary;
		
		private var uploader				: ImageUploader;
		
		public function ImageUploadForm() {
			fullNameText.tabEnabled = true;
			fullNameText.tabIndex = 1;
			
			emailText.tabEnabled = true;
			emailText.tabIndex = 2;
			
			mobileNumberText.tabEnabled = true;
			mobileNumberText.tabIndex = 3;
			
			hideLoading();
			
			// init validation
			compositeValidator = new CompositeValidator();
			compositeValidator.addValidator(new RequiredStringValidator(imageUrlText, "text", ""));
			compositeValidator.addValidator(new RequiredStringValidator(fullNameText, "text", ""));
			compositeValidator.addValidator(new EmailValidator(emailText, "text", "", ""));
			
			fieldBgMap = new Dictionary(true);
			fieldBgMap[imageUrlText] = imageUrlBgMovie;
			fieldBgMap[fullNameText] = fullNameBgMovie;
			fieldBgMap[emailText] = emailBgMovie;
			fieldBgMap[mobileNumberText] = mobileNumberBgMovie;
			
			selectImageButton.addEventListener(MouseEvent.CLICK, selectImageButtonClickHandler);
			sendButton.addEventListener(MouseEvent.CLICK, sendButtonClickHandler);
			cancelButton.addEventListener(MouseEvent.CLICK, cancelButtonClickHandler);
			
			uploader = new ImageUploader();
			uploader.addEventListener(ImageUploadEvent.UPLOAD_START, uploadStartHandler);
			uploader.addEventListener(ImageUploadEvent.UPLOAD_COMPLETE, uploadCompleteHandler);
			uploader.addEventListener(ImageUploadEvent.SAVE_IMAGE_COMPLETE, saveImageCompleteHandler);
		}
		
		private function cancelButtonClickHandler(event: MouseEvent): void {
			//GlobalVars.mainTimeLine.dispatchEvent(new PageEvent(PageEvent.GO_TO_HOMEPAGE));
			SWFAddress.setValue("nong-trai");
		}
		
		public function reset():void {
			imageUrlText.text = "";
			fullNameText.text = "";
			emailText.text = "";
			mobileNumberText.text = "";
			
			for each (var item: MovieClip in fieldBgMap) item.gotoAndStop("normal");
			
			hideLoading();
		}
		
		private function sendButtonClickHandler(event: MouseEvent): void {
			var resultsList: Array = compositeValidator.validateAll();
			var i: int;
			var result: ValidationResult;
			
			// clear error alert
			for each (var item: MovieClip in fieldBgMap) item.gotoAndStop("normal");
			
			if (resultsList.length > 0) {
				for (i = 0; i < resultsList.length; i++) {
					result = resultsList[i];
					MovieClip(fieldBgMap[result.errorSource]).gotoAndStop("error");
				}
			} else {
				// Save image
				var bitmapData: BitmapData = ImageUploadPage(parent).captureImageFrame();
				GlobalVars.capturedImage = bitmapData;
				
				var data: ByteArray = PNGEncoder.encode(bitmapData);
				showLoading();
				uploader.saveImage(data, uploader.imageGuid);
			}
		}
		
		private function saveImageCompleteHandler(event: ImageUploadEvent): void {
			var photoUrl: String = Configuration.instance.uploadedImageBaseUrl + uploader.imageGuid + ".png";
			trace("uploaded image: " + photoUrl);
			var service: AppServices = new AppServices(Configuration.instance.sendProfileServiceUrl);
			service.addEventListener(HttpServiceEvent.RESULT, sendProfileResultHandler);
			service.addEventListener(HttpServiceEvent.FAULT, sendProfileFaultHandler);
			service.sendProfile(photoUrl, fullNameText.text, emailText.text, mobileNumberText.text);
		}
		
		private function sendProfileResultHandler(event: HttpServiceEvent): void {
			hideLoading();
			
			trace("sendProfileResultHandler " + event.result);
			var xml: XML = new XML(event.result);
			GlobalVars.uploadedProfileId = Number(xml.toString());
			var photoUrl: String = Configuration.instance.uploadedImageBaseUrl + uploader.imageGuid + "_download.png";
			dispatchEvent(new ImageUploadEvent(ImageUploadEvent.SAVE_IMAGE_PROFILE_COMPLETE, "", photoUrl));
		}
		
		private function sendProfileFaultHandler(event: HttpServiceEvent): void {
			trace("sendProfileFaultHandler " + event.error);
		}
		
		private function selectImageButtonClickHandler(event: MouseEvent): void {
			uploader.browserAndUpload();
		}
		
		private function uploadStartHandler(event: ImageUploadEvent): void {
			showLoading();
			imageUrlText.text = event.fileName;
		}
		
		private function uploadCompleteHandler(event: ImageUploadEvent): void {
			hideLoading();
			
			dispatchEvent(event);
		}
		
		private function showLoading():void {
			loadingMovie.visible = true;
			loadingMovie.gotoAndPlay(1);
			this.mouseEnabled = false;
			this.mouseChildren = false;
		}
		
		private function hideLoading():void {
			loadingMovie.visible = false;
			loadingMovie.gotoAndStop(1);
			this.mouseEnabled = true;
			this.mouseChildren = true;
		}
	}

}