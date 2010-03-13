package com.dutchlady.components.getmilk {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.utils.setTimeout;
	/**
	 * ...
	 * @author ... Mr. Coder
	 */
	public class Trough extends MovieClip {
		public static const TROUGH_CLICKED: String = "trough_clicked";
		public static const TROUGH_EMPTY: String = "trough_empty";
		public static const TROUGH_FULL: String = "trough_full";
		
		public var grassMovie: MovieClip;
		public var currentLevel: int = 0;
		private var _overable: Boolean = true;
		public var isGoAway: Boolean = false;
		
		public function Trough() {
			this.addEventListener(MouseEvent.CLICK, mouseHandler);
			this.addEventListener(MouseEvent.ROLL_OVER, mouseHandler);
			this.addEventListener(MouseEvent.ROLL_OUT, mouseHandler);
			reset();
		}
		
		public function reset(): void {
			overable = true;
			isGoAway = false;
			this.grassMovie.gotoAndStop(this.grassMovie.totalFrames);
			this.currentLevel = 0;
		}
		
		private function mouseHandler(event: MouseEvent): void {
			switch (event.type) {
				case MouseEvent.ROLL_OVER:
					if (overable)	this.filters = [new ColorMatrixFilter([1,0,0,0,50,0,1,0,0,50,0,0,1,0,50,0,0,0,1,0])];
				break;
				case MouseEvent.ROLL_OUT:
					this.filters = [];
				break;
				case MouseEvent.CLICK:
				trace("CLICK ****************************");
					this.dispatchEvent(new Event(TROUGH_CLICKED));
				break;				
			}
		}
		
		public function fillGrass(): void {
			grassMovie.gotoAndStop("level 1");
			setTimeout(function() {
							grassMovie.gotoAndStop("level 2");
							setTimeout(function() {
								grassMovie.gotoAndStop("level 3");
							}, 600);							
						}, 600);
			
			currentLevel = 3;
			overable = false;
			this.dispatchEvent(new Event(TROUGH_FULL));
		}
		
		public function goNextLevel(): void {
			//currentLevel = Math.max(0, currentLevel - 1);
			currentLevel--;
			if (currentLevel >= 0)	grassMovie.gotoAndPlay("level " + currentLevel);
			if (currentLevel == 0)	this.dispatchEvent(new Event(TROUGH_EMPTY));
		}
		
		public function get overable(): Boolean { return _overable; }
		
		public function set overable(value: Boolean): void {
			_overable = value;
			this.buttonMode = value;
			this.mouseEnabled = this.mouseChildren = value;
		}
	}

}