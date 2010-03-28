package com.dutchlady.components.heart {
	import com.dutchlady.common.GlobalVars;
	import com.dutchlady.events.PageEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.FileReference;
	import flash.net.sendToURL;
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
		public var profileIdArray: Array;
		public var isSearchMode: Boolean = false;
		
		private var downloadFileRef: FileReference;
		
		public function BigHeart() {
			init();			
		}
		
		private function init():void {
			itemArray = new Array();
			trace( "isSearchMode : " + isSearchMode );
			for (var i: int = 0; i < this.numChildren; i++) {
				var movie: MovieClip = this.getChildAt(i) as MovieClip;
				if (movie) {
					itemArray.push(movie);
					movie.visible = false;
					movie.saveImageButton.addEventListener(MouseEvent.CLICK, saveImageClickHandler);
					movie.sendToFriendButton.addEventListener(MouseEvent.CLICK, sendToFriendClickHandler);
					movie.saveImageButton.visible = isSearchMode;					
					movie.sendToFriendButton.visible = isSearchMode;
				}
			}
		}
		
		private function sendToFriendClickHandler(event: MouseEvent): void {
			//	
			var profileId: String = profileIdArray[int(event.currentTarget.parent.thumbMovie.getChildAt(0).name)];
			var newEvent: PageEvent = new PageEvent(PageEvent.ILOVE_SEND_TO_FRIEND, true);
			newEvent.profileId = profileId;
			dispatchEvent(newEvent);
		}
		
		private function saveImageClickHandler(event: MouseEvent): void {
			downloadFileRef = new FileReference();	
			var url: String = urlArray[int(event.currentTarget.parent.thumbMovie.getChildAt(0).name)].replace("_thumbnail.png", "_download.png");
			downloadFileRef.download(new URLRequest(url), "dutch_lady.png");
		}
		
		public function setData(xml: XML): void {
			init();
			var ns: Namespace = xml.namespace();
			var list: Array;
			
			urlArray = new Array();
			profileIdArray = new Array();
			var count: int = xml.ns::string.length();
			for (var i: int = 1; i < count; i++) {
				list = xml.ns::string[i].toString().split("|");
				profileIdArray.push(list[0]);
				urlArray.push(list[1].replace(".png", "_thumbnail.png") );
				//trace(urlArray[urlArray.length - 1]);
			}
			processURLArray();
		}
		
		private function processURLArray(): void {
			//	hide all items in big heart
			var count: int = itemArray.length;
			// load images
			count = Math.min(count, urlArray.length);
			for (var i: int = 0; i < count; i++) {
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
			if (loader.height > movie.thumbMovie.height) {
				loader.scaleX = loader.scaleY = movie.thumbMovie.height / loader.height;
			}
			loader.x = -loader.width / 2;
			loader.y = -loader.height / 2;
			while (movie.thumbMovie.numChildren)	movie.thumbMovie.removeChildAt(0);
			movie.thumbMovie.addChild(loader);
			movie.alpha = 0;
			movie.visible = true;
			loader.addEventListener(MouseEvent.CLICK, itemClickHandler);
			TweenLite.to(movie, 0.5, {alpha: 1} );
		}
		
		private function itemClickHandler(event: MouseEvent): void {
			var zoomMovie: MovieClip = new MovieClip();
			zoomMovie.graphics.beginFill(0xFFFFFF, 0.7);
			//zoomMovie.graphics.drawRect( -GlobalVars.windowsWidth / 2, -GlobalVars.windowsHeight / 2, GlobalVars.windowsWidth, GlobalVars.windowsHeight);
			zoomMovie.graphics.drawRect( -1280 / 2, -1024 / 2, 1280, 1024);
			zoomMovie.graphics.endFill();
			var loadingMovie: MovieClip = new MilkLoading();
			zoomMovie.addChild(loadingMovie);
			
			var loader: Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loaderIOErrorHandler);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function() {
																		zoomMovie.addChild(loader);
																		loader.x = -loader.width / 2;
																		loader.y = -loader.height / 2;
																		loadingMovie.visible = false;
																	});			
			loader.load(new URLRequest(urlArray[int(event.currentTarget.name)].replace("_thumbnail.png",".png")));
			//trace( "urlArray[int(event.currentTarget.name)] : " + urlArray[int(event.currentTarget.name)] );
			
			
			zoomMovie.addEventListener(MouseEvent.CLICK, function() {
															stage.removeChild(zoomMovie);
														});
			stage.addChild(zoomMovie);			
			zoomMovie.x = GlobalVars.movieWidth/2;
			zoomMovie.y = GlobalVars.movieHeight/2;
			zoomMovie.alpha = 0;
			TweenLite.to(zoomMovie, 1, { alpha: 1 } );
			
			sendToURL(new URLRequest("http://fs.toiyeucogaihalan.com/flashapi/ReportingServices.asmx/ClickViewProfile"));
		}
		
		private function loaderIOErrorHandler(event: IOErrorEvent): void {
			//trace("ITEM " + event.currentTarget.loader.name + event.text);
		}
	}

}