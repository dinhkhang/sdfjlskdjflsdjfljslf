package com.dutchlady.pages.tour {
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Hai Nguyen
	 */
	public class TourNewsItem extends Sprite {
		public var thumbMovie		: MovieClip;
		public var titleText		: TextField;
		public var descriptionText	: TextField;
		
		public function TourNewsItem() {
			
		}
		
		public function update(thumbUrl: String, title: String, description: String):void {
			var loader: Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.INIT, thumbLoadInitHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, thumbLoadIOErrorHandler);
			loader.load(new URLRequest(thumbUrl));
			
			titleText.text = title;
			descriptionText.text = description;
		}
		
		private function thumbLoadIOErrorHandler(event: IOErrorEvent): void {
			
		}
		
		private function thumbLoadInitHandler(event: Event): void {
			while (thumbMovie.numChildren > 0) thumbMovie.removeChildAt(0);
			
			var content: DisplayObject = event.target.content;
			content.width = 206;
			content.height = 138;
			thumbMovie.addChild(event.target.content);
		}
	}

}