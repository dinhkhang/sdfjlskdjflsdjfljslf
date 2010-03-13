package com.dutchlady.components.heart {
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	//import gs.TweenLite;
	/**
	 * ...
	 * @author ... Mr. Coder
	 */
	public class BigHeart extends MovieClip {
		
		public var itemArray: Array;	// Array of all movieclips inside big heart
		public var urlArray: Array;
		
		public function BigHeart() {
			init();			
		}
		
		private function init():void {
			itemArray = new Array();
			
			for (var i: int = 0; i < this.numChildren; i++) {
				var movie: MovieClip = this.getChildAt(i) as MovieClip;
				if (movie) {
					itemArray.push(movie);
					movie.visible = false;
				}
			}
		}
		
		public function setData(xml: XML): void {
			urlArray = new Array();
			for each (var item: XML in xml.list.imageUrl) {
				urlArray.push(item.toString());
			}
			processURLArray();
		}
		
		private function processURLArray(): void {
			//	hide all items in big heart
			var count: int = itemArray.length;
			for (var i: int = 0; i < count; i++) {
				var movie: MovieClip = itemArray[i];
				movie.visible = false;
			}
			
			// load images
			count = Math.min(count, urlArray.length);
			for (i = 0; i < count; i++) {
				var loader: Loader = new Loader();
				loader.name = i.toString();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleteHandler);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loaderIOErrorHandler);
				loader.load(new URLRequest(urlArray[i]));
			}
		}
		
		private function loaderCompleteHandler(event: Event): void {
			var loader: Loader = event.currentTarget.loader;
			var i: int = int(loader.name);
			var movie: MovieClip = itemArray[i];
			loader.x = -loader.width / 2;
			loader.y = -loader.height / 2;
			movie.thumbMovie.addChild(loader);
			//movie.alpha = 0;
			movie.visible = true;
			//TweenLite.to(movie, 0.5, {alpha: 1} );
		}
		
		private function loaderIOErrorHandler(event: IOErrorEvent): void {
			//trace("ITEM " + event.currentTarget.loader.name + event.text);
		}
	}

}