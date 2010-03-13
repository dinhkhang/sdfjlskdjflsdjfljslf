package com.dutchlady.pages.loading {
	import com.dutchlady.events.PageEvent;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author ... Mr. Coder
	 */
	public class Game1Loading extends BaseLoading {
		public var boardMovie: MovieClip;
		
		public function Game1Loading() {
			boardMovie.startButton.visible = false;
			boardMovie.startButton.addEventListener(MouseEvent.CLICK, startClickHandler);
		}
		
		private function startClickHandler(event: MouseEvent): void {
			this.dispatchEvent(new PageEvent(PageEvent.PAGE_LOADING_COMPLETE));
		}
		
		override public function get percent(): int { return super.percent; }
		
		override public function set percent(value: int): void {
			super.percent = value;
			boardMovie.startButton.visible = (value == 100);
		}
	}

}