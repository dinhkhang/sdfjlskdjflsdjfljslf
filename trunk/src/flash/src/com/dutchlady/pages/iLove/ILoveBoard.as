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
			
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private function addedToStageHandler(event: Event): void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		private function enterFrameHandler(event: Event): void {
			var point: Point = new Point(GlobalVars.windowsWidth - this.width, GlobalVars.windowsHeight - this.height);
			point = this.parent.globalToLocal(point);
			this.x = point.x;
			this.y= point.y;
		}
		
		private function buttonClickHandler(event: MouseEvent): void {
			switch (event.currentTarget) {
				case searchButton:
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