package com.dutchlady.pages.share {
	import com.dutchlady.pages.BasePopUp;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import swfaddress.SWFAddress;
	/**
	 * ...
	 * @author ... Mr. Coder
	 */
	public class SharePage extends BasePopUp {
		public var urlButton: SimpleButton;
		public var simpleButton: SimpleButton;
		
		public function SharePage() {
			urlButton.addEventListener(MouseEvent.CLICK, clickURLHandler);
			simpleButton.addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		private function clickHandler(e: MouseEvent) {
			SWFAddress.setValue("upload-photo");
		}
		private function clickURLHandler(e: MouseEvent) {
			navigateToURL(new URLRequest("http://www.dutchlady.com.vn/dendomdom/"),"_blank");
		}
		
		override public function playPopUp(): void {
			super.playPopUp();
		}
	}

}