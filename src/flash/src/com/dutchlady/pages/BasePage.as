﻿package com.dutchlady.pages {
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author ... Mr. Coder
	 */
	public class BasePage extends MovieClip {
		
		public function BasePage() {
			this.visible = false;
		}
		
		public function startBeginPage():void { this.visible = true; }
		public function completeBeginPage():void {}
		public function startEndPage():void {}
		public function completeEndPage():void {}
		public function resize():void { }
		public function set mouseCheckingMode(value: Boolean): void {}
		public function get mouseCheckingMode(): Boolean { return true; }
	}

}