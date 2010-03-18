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
	import gs.TweenLite;
	import swfaddress.SWFAddress;
	/**
	 * ...
	 * @author ... Mr. Coder
	 */
	public class ILoveBoard extends MovieClip {
		public var buttonMovie: MovieClip
		public var boardMovie: MovieClip
		public var emailText: TextField;
		public var searchButton: SimpleButton;
		public var startButton: SimpleButton;
		
		public function ILoveBoard() {
			this.stop();
			emailText = boardMovie.emailText;
			searchButton = boardMovie.searchButton;
			startButton = boardMovie.startButton;
			buttonMovie.buttonMode = true;
			buttonMovie.addEventListener(MouseEvent.CLICK, buttonClickHandler);
			
			emailText.addEventListener(FocusEvent.FOCUS_IN, emailFocusHandler);
			emailText.addEventListener(FocusEvent.FOCUS_OUT, emailFocusHandler);
			
			searchButton.addEventListener(MouseEvent.CLICK, buttonClickHandler);
			startButton.addEventListener(MouseEvent.CLICK, buttonClickHandler);

		}
		
		private function enterFrameHandler(event: Event): void {
			var point: Point = new Point(GlobalVars.windowsWidth - (GlobalVars.windowsWidth-GlobalVars.movieWidth)/2 - this.width + 20, GlobalVars.windowsHeight - this.height - 10);
			point = this.parent.globalToLocal(point);
			this.x = point.x;
			this.y = point.y;
		}

		private function buttonClickHandler(event: MouseEvent): void {
			switch (event.currentTarget) {
				case buttonMovie:
					if  (boardMovie.x == 0) {	//	will collapse
						TweenLite.to(boardMovie, 1, { x:boardMovie.width, onUpdate: updateHandler, onComplete: completeHandler} );
						//buttonMovie.gotoAndStop(2);
					}
					else {	//	will expand
						TweenLite.to(boardMovie, 1, { x:0, onUpdate: updateHandler, onComplete: completeHandler} );
						//buttonMovie.gotoAndStop(1);
					}
				break;
				case searchButton:
					this.dispatchEvent(new PageEvent(PageEvent.ILOVE_SEARCH, true));
					break;
				case startButton:
					SWFAddress.setValue("upload-photo");
					break;
			}
		}
		
		private function completeHandler():void {
			//if (buttonMovie.currentFrame == 1) buttonMovie.gotoAndStop(2);
			//else buttonMovie.gotoAndStop(1);
		}
		
		private function updateHandler():void {
			buttonMovie.x = boardMovie.x - buttonMovie.width;
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
		
		public function set autoXY(value): void {
			if (value)	this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			else this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
	}

}