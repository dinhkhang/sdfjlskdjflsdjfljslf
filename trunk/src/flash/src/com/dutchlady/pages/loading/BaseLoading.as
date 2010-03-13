package com.dutchlady.pages.loading {
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author ... Mr. Coder
	 */
	public class BaseLoading extends MovieClip {
		
		public var loadingMovie: MovieClip;
		
		public function BaseLoading() {
			
		}
		
		public function set percent(value: int) : void {
			loadingMovie.gotoAndStop(value);
			loadingMovie.processText.text = value.toString() + "%";
			loadingMovie.visible = (value < 100);
		}
		
		public function get percent(): int {
			return loadingMovie.currentFrame;
		}
	}

}