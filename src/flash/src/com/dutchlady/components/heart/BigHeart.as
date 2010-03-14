package com.dutchlady.components.heart {
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import gs.TweenLite;
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
			init();
			var ns: Namespace = xml.namespace();
			
			urlArray = new Array();
			var count: int = xml.ns::string.length();
			for (var i: int = 1; i < count; i++) {
				urlArray.push(xml.ns::string[i].toString().split("|")[1].replace(".png","_thumbnail.png") );
				trace(urlArray[urlArray.length - 1]);
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
			loader.scaleX = loader.scaleY = movie.width / loader.width;
			loader.x = -loader.width / 2;
			loader.y = -loader.height / 2;
			while (movie.numChildren) movie.removeChildAt(0);
			movie.addChild(loader);
			movie.alpha = 0;
			movie.visible = true;
			TweenLite.to(movie, 0.5, {alpha: 1} );
		}
		
		private function loaderIOErrorHandler(event: IOErrorEvent): void {
			//trace("ITEM " + event.currentTarget.loader.name + event.text);
		}
	}

}