package com.dutchlady.components.getmilk {
	import com.dutchlady.pages.getmilk.GetMilk;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	/**
	 * ...
	 * @author ... Mr. Coder
	 */
	public class BoardResult extends MovieClip{
		//private const WIN_TEXT: String = "Xin chúc mừng,\nbạn đã hoàn thành xuất sắc công việc của Cô Gái Hà Lan!"
		//private const LOSE_TEXT: String = "Xin chia buồn,\nbạn chưa hoàn thành công việc. Hãy cố gắng lên!"
		
		//public var resultText: TextField;
		public var retryMovie: MovieClip;
		public var nextLevelMovie: MovieClip;
		public var goFactoryMovie: MovieClip;
		public var goFarmMovie: MovieClip;
		
		public function BoardResult() {
			//retryMovie.buttonMode = true;
			//nextLevelMovie.buttonMode = true;
			//goFactoryMovie.buttonMode = true;
			//
			//retryMovie.addEventListener(MouseEvent.ROLL_OVER, buttonMouseHandler);
			//retryMovie.addEventListener(MouseEvent.ROLL_OUT, buttonMouseHandler);
			//retryMovie.addEventListener(MouseEvent.CLICK, buttonMouseHandler);
			//nextLevelMovie.addEventListener(MouseEvent.ROLL_OVER, buttonMouseHandler);
			//nextLevelMovie.addEventListener(MouseEvent.ROLL_OUT, buttonMouseHandler);
			//nextLevelMovie.addEventListener(MouseEvent.CLICK, buttonMouseHandler);
			//goFactoryMovie.addEventListener(MouseEvent.ROLL_OVER, buttonMouseHandler);
			//goFactoryMovie.addEventListener(MouseEvent.ROLL_OUT, buttonMouseHandler);
			//goFactoryMovie.addEventListener(MouseEvent.CLICK, buttonMouseHandler);
		}
		
		/*private function buttonMouseHandler(event: MouseEvent): void {
			switch (event.type) {
				case MouseEvent.ROLL_OVER:
					event.currentTarget.gotoAndStop(1);
				break;
				case MouseEvent.ROLL_OUT:
					event.currentTarget.gotoAndStop(0);
				break;
				case MouseEvent.CLICK:
					var e: Event;
					switch (event.currentTarget) {
						case retryMovie:
							e = new Event(GetMilk.RETRY, true);
						break;
						case nextLevelMovie:
							e = new Event(GetMilk.NEXT_LEVEL, true);
						break;
						case goFactoryMovie:
							e = new Event(GetMilk.GO_FACTORY, true);
						break;
					}
					this.dispatchEvent(e);
				break;
			}
		}*/
		
		/*public function set winMode(value: Boolean): void {
			nextLevelMovie.mouseChildren = nextLevelMovie.mouseEnabled = value;
			nextLevelMovie.alpha = (value) ? 1 : 0.4;
			resultText.text = (value) ? WIN_TEXT : LOSE_TEXT;
		}*/
	}

}