package com.dutchlady.pages.iLove {
	import com.dutchlady.common.GlobalVars;
	import com.dutchlady.events.PageEvent;
	import com.dutchlady.utils.StringUtil;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	/**
	 * ...
	 * @author ... Mr. Coder
	 */
	public class ILoveBoard extends MovieClip {
		
		public var emailText: TextField;
		public var searchButton: SimpleButton;
		public var startButton: SimpleButton;
		
		public function ILoveBoard() {
			emailText.addEventListener(FocusEvent.FOCUS_IN, emailFocusHandler);
			emailText.addEventListener(FocusEvent.FOCUS_OUT, emailFocusHandler);
			
			searchButton.addEventListener(MouseEvent.CLICK, buttonClickHandler);
			startButton.addEventListener(MouseEvent.CLICK, buttonClickHandler);

		}
		
		private function hideShowClickHandler(event: MouseEvent): void {
			this.dispatchEvent(new Event("hide_show", true));
		}
		
		private function buttonClickHandler(event: MouseEvent): void {
			switch (event.currentTarget) {
				case searchButton:
					this.dispatchEvent(new PageEvent(PageEvent.ILOVE_SEARCH, true));
					break;
				case startButton:
					this.dispatchEvent(new PageEvent(PageEvent.GO_TO_UPLOADPAGE, true));
					break;
			}
		}
		
		private function emailFocusHandler(event: FocusEvent): void {
			switch (event.type) {
				case FocusEvent.FOCUS_IN:
					emailText.text = "";
				break;
				case FocusEvent.FOCUS_OUT:
					emailText.text = StringUtil.trim(emailText.text);
					if (emailText.text == "")	emailText.text = "Nhập thông tin email";
				break;
			}
		}
		
	}

}