package com.dutchlady.components.upload {
	import com.adobe.utils.StringUtil;
	import com.dutchlady.common.Configuration;
	import com.dutchlady.common.GlobalVars;
	import com.dutchlady.constants.QueryParameter;
	import com.dutchlady.events.PageEvent;
	import com.dutchlady.http.HttpService;
	import com.dutchlady.http.HttpServiceEvent;
	import com.dutchlady.services.AppServices;
	import com.dutchlady.validators.CompositeValidator;
	import com.dutchlady.validators.EmailValidator;
	import com.dutchlady.validators.RequiredStringValidator;
	import com.dutchlady.validators.ValidationResult;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequestMethod;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Hai Nguyen
	 */
	public class SendImageToFriend extends MovieClip {
		public var senderFullnameText: TextField;
		public var senderEmailText: TextField;
		public var receiverEmail1Text: TextField;
		public var receiverEmail2Text: TextField;
		public var receiverEmail3Text: TextField;
		
		public var senderFullnameBgMovie: MovieClip;
		public var senderEmailBgMovie: MovieClip;
		public var receiverEmail1BgMovie: MovieClip;
		public var receiverEmail2BgMovie: MovieClip;
		public var receiverEmail3BgMovie: MovieClip;
		
		public var loadingMovie: MovieClip;
		public var outputText: TextField;
		
		public var sendButton: SimpleButton;
		public var closeButton: SimpleButton;
		
		private var compositeValidator	: CompositeValidator;
		private var fieldBgMap			: Dictionary;
		
		public function SendImageToFriend() {
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private function addedToStageHandler(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			senderFullnameText.tabEnabled = true;
			senderFullnameText.tabIndex = 1;
			
			senderEmailText.tabEnabled = true;
			senderEmailText.tabIndex = 2;
			
			receiverEmail1Text.tabEnabled = true;
			receiverEmail1Text.tabIndex = 3;
			
			receiverEmail2Text.tabEnabled = true;
			receiverEmail2Text.tabIndex = 4;
			
			receiverEmail3Text.tabEnabled = true;
			receiverEmail3Text.tabIndex = 5;
			
			// init validation
			compositeValidator = new CompositeValidator();
			compositeValidator.addValidator(new RequiredStringValidator(senderFullnameText, "text", ""));
			compositeValidator.addValidator(new EmailValidator(senderEmailText, "text", "", ""));
			compositeValidator.addValidator(new EmailValidator(receiverEmail1Text, "text", "", ""));
			compositeValidator.addValidator(new EmailValidator(receiverEmail2Text, "text", "", "", true));
			compositeValidator.addValidator(new EmailValidator(receiverEmail3Text, "text", "", "", true));
			
			fieldBgMap = new Dictionary(true);
			fieldBgMap[senderFullnameText] = senderFullnameBgMovie;
			fieldBgMap[senderEmailText] = senderEmailBgMovie;
			fieldBgMap[receiverEmail1Text] = receiverEmail1BgMovie;
			fieldBgMap[receiverEmail2Text] = receiverEmail2BgMovie;
			fieldBgMap[receiverEmail3Text] = receiverEmail3BgMovie;
			
			sendButton.mouseEnabled = true;
			closeButton.mouseEnabled = true;
			loadingMovie.visible = false;
			
			initEvents();
		}
		
		private function initEvents():void {
			closeButton.addEventListener(MouseEvent.CLICK, closeButtonClickHandler);
			sendButton.addEventListener(MouseEvent.CLICK, sendButtonClickHandler);
		}
		
		public function reset():void {
			senderFullnameText.text = "";
			senderEmailText.text = "";
			receiverEmail1Text.text = "";
			receiverEmail2Text.text = "";
			receiverEmail3Text.text = "";
			
			outputText.autoSize = TextFieldAutoSize.LEFT;
			outputText.text = "";
			
			sendButton.mouseEnabled = true;
			
			for each (var bg: MovieClip in fieldBgMap) bg.gotoAndStop("normal");
			
			stage.focus = senderFullnameText;
			loadingMovie.visible = false;
		}
		
		private function resetButtonClickHandler(e:MouseEvent):void {
			reset();
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
				// make a call to webservice
				
				var service: AppServices = new AppServices(Configuration.instance.sendToFriendServiceUrl);
				service.addEventListener(HttpServiceEvent.RESULT, serviceResultHandler);
				service.addEventListener(HttpServiceEvent.FAULT, serviceFaultHandler);
				var params: Object = { };
				var receiverEmails: String = receiverEmail1Text.text;
				if (StringUtil.trim(receiverEmail2Text.text) != "") receiverEmails += ";" + receiverEmail2Text.text;
				if (StringUtil.trim(receiverEmail3Text.text) != "") receiverEmails += ";" + receiverEmail3Text.text;
				
				service.sendToFriend(senderFullnameText.text, senderEmailText.text, GlobalVars.uploadedProfileId.toString(), "", receiverEmails);
				
				outputText.text = "Đang gửi";//LanguageManager.instance.getText("sendToFriendSending");
				sendButton.mouseEnabled = false;
				loadingMovie.visible = true;
			}
		}
		
		private function serviceResultHandler(event: HttpServiceEvent): void {
			// update donate
			var service: AppServices = new AppServices(Configuration.instance.updateDonateServiceUrl);
			service.updateDonate("Send-To-Friend-Profile");
			
			loadingMovie.visible = false;
			reset();
			outputText.text = "Gửi thành công";//LanguageManager.instance.getText("sendToFriendSendSuccessfully");
		}
		
		private function serviceFaultHandler(event: HttpServiceEvent): void {
			sendButton.mouseEnabled = true;
			trace(event.error);
		}
		
		private function closeButtonClickHandler(event: MouseEvent):void {
			//this.dispatchEvent(new PageEvent(PageEvent.GO_TO_HOMEPAGE, true));
			this.visible = false;
			parent["uploadResultMovie"].visible = true;
		}
	}
}