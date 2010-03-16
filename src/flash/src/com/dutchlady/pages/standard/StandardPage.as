package com.dutchlady.pages.standard {
	import com.dutchlady.pages.BasePopUp;
	import fl.video.FLVPlayback;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author ... Mr. Coder
	 */
	public class StandardPage extends BasePopUp {
		public var nextButton: MovieClip;
		public var playButton: SimpleButton;
		public var flvPlayback: FLVPlayback;
		
		public function StandardPage() {
			nextButton.buttonMode = true;
			nextButton.addEventListener(MouseEvent.ROLL_OVER, mouseHandler);
			nextButton.addEventListener(MouseEvent.ROLL_OUT, mouseHandler);
			nextButton.addEventListener(MouseEvent.CLICK, mouseHandler);
			
			playButton.addEventListener(MouseEvent.CLICK, playClickHandler);
			
			flvPlayback.visible = false;
			playButton.visible = false;
			
			this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		
		private function removedFromStageHandler(event: Event): void {
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			flvPlayback.stop();
		}
		
		private function playClickHandler(event: MouseEvent): void {
			if (playButton.alpha == 1)	flvPlayback.play();
			else flvPlayback.stop();
			if(playButton.alpha == 1)	playButton.alpha = 0;
			else	playButton.alpha = 1;
		}
		
		private function mouseHandler(e: MouseEvent){
			switch (e.type) {
				case MouseEvent.ROLL_OVER:
					nextButton.gotoAndStop(2);
				break;
				case MouseEvent.ROLL_OUT:
					nextButton.gotoAndStop(1);
				break;
				case MouseEvent.CLICK:
					navigateToURL(new URLRequest("http://www.dutchlady.com.vn/?id_pproductv=35&lg=vn&start=0"), "_blank");
				break;
			}
		}
		
		override public function playPopUp(): void {
			super.playPopUp();
			flvPlayback.visible = true;
			playButton.visible = true;
			playButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
	}

}