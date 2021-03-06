﻿package com.dutchlady.pages.tour {

	import com.dutchlady.pages.BasePopUp;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	/**
	 * ...
	 * @author ... Mr. Coder
	 */
	public class Tour extends BasePopUp {
		
		public var containerMovie: TourNewsContainer;
		
		public function Tour() {
			this.mouseEnabled = this.mouseChildren = false;
		}
	
		override public function playPopUp(): void {
			super.playPopUp();
			var listMovie: TourNewsList = containerMovie.listMovie as TourNewsList;
			listMovie.flvPlayback.visible = true;
			listMovie.playButton.visible = true;
			listMovie.playButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			
			this.mouseEnabled = this.mouseChildren = true;
		}
		
		override public function closePopUp(): void {
			super.closePopUp();
			var listMovie: TourNewsList = containerMovie.listMovie as TourNewsList;
			listMovie.flvPlayback.stop();
		}
	}
}