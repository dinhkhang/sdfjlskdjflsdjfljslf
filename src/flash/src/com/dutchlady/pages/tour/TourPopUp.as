package com.dutchlady.pages.tour {
	import com.utils.ScrollBar;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import gs.TweenLite;
	/**
	 * ...
	 * @author ... Mr. Coder
	 */
	public class TourPopUp extends MovieClip {
		
		public var bgMovie: MovieClip;
		public var scrollbarMovie: ScrollBar;
		public var contentText: TextField;
		public var closeButton: SimpleButton;
		
		public function TourPopUp(htmlText: String) {			
			contentText.htmlText = htmlText.replace("\n", "").replace("\r", "");
			trace( "htmlText : " + htmlText );
			scrollbarMovie.init(contentText, null, "vertical", true, false, false);
			scrollbarMovie.visible = true;
			closeButton.addEventListener(MouseEvent.CLICK, closeClickHandler);
			this.alpha = 0;
			TweenLite.to(this, 0.5, { alpha: 1 } );
		}
		
		private function closeClickHandler(event: MouseEvent): void {
			TweenLite.to(this, 0.5, { alpha: 0, onComplete: function() {
															dispatchEvent(new Event(Event.CLOSE));
														} } );
		}
		
	}

}