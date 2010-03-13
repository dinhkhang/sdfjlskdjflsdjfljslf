package com.dutchlady.components {
	import com.dutchlady.common.Configuration;
	import com.dutchlady.http.HttpServiceEvent;
	import com.dutchlady.services.AppServices;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Hai Nguyen
	 */
	public class DigitalPanel extends Sprite {
		public static const MAX_NUM_OF_ZERO: int = 10; // 1 billion
		
		public var glowContentText		: TextField;
		public var contentText			: TextField;
		public var missingZeroText		: TextField;
		
		private var timer				: Timer;
		
		public function DigitalPanel() {
			timer = new Timer(3000, 1);
			timer.addEventListener(TimerEvent.TIMER, timerHandler);
			
			glowContentText.autoSize = TextFieldAutoSize.RIGHT;
			contentText.autoSize = TextFieldAutoSize.RIGHT;
			missingZeroText.autoSize = TextFieldAutoSize.RIGHT;
			update("");
			getData();
		}
		
		private function timerHandler(event: TimerEvent): void {
			timer.stop();
			getData();
		}
		
		public function update(content: String):void {
			var formattedContent: String = formatNumberString(content);
			
			glowContentText.text = formattedContent;
			contentText.text = formattedContent;
			
			var missingZero: String = fillMissingZero(content);
			missingZero = formatNumberString(missingZero);
			missingZeroText.text = missingZero;
		}
		
		private function fillMissingZero(text: String):String {
			var numOfMissingZero: int = Math.max(0, MAX_NUM_OF_ZERO - text.length);
			var result: String = text;
			
			for (var i: int = 0; i < numOfMissingZero; i++) result = "0" + result;
			
			return result;
		}
		
		private function getData():void {
			var service: AppServices = new AppServices(Configuration.instance.getTotalMoneyServiceUrl);
			service.addEventListener(HttpServiceEvent.RESULT, getDataResultHandler);
			service.addEventListener(HttpServiceEvent.FAULT, getDataFaultHandler);
			service.getTotalMoney();
		}
		
		private function getDataResultHandler(event: HttpServiceEvent): void {
			//trace("getDataResultHandler " + event);
			var xml: XML = new XML(event.result);
			
			update(xml[0]);
			
			timer.reset();
			timer.start();
		}
		
		private function getDataFaultHandler(event: HttpServiceEvent): void {
			//trace("getDataFaultHandler " + event);
		}
		
		private function formatNumberString(numberString: String):String {
			var result: String = "";
			var length: int = numberString.length;
			
			for (var i: int = length - 1; i >= 0; i--) {
				result = numberString.charAt(i) + result;
				//if ((length - i) % 3 == 0) result = " . " + result;
				if ((length - i) % 3 == 0) result = " " + result;
			}
			
			return result;
		}
	}

}