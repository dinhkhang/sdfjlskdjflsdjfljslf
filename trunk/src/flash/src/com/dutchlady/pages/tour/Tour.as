package com.dutchlady.pages.tour {
	//import fl.video.FLVPlayback;
	//import flash.display.Loader;
	import flash.display.MovieClip;
	//import flash.display.SimpleButton;
	//import flash.events.Event;
	//import flash.events.IOErrorEvent;
	//import flash.events.MouseEvent;
	//import flash.net.URLLoader;
	//import flash.net.URLRequest;
	//import flash.text.TextField;
	/**
	 * ...
	 * @author ... Mr. Coder
	 */
	public class Tour extends MovieClip {
		
		//public var playButton: SimpleButton;
		//public var flvPlayback: FLVPlayback;
		//public var title1Text: TextField;
		//public var content1Text: TextField;
		//public var title2Text: TextField;
		//public var content2Text: TextField;
		//public var title3Text: TextField;
		//public var content3Text: TextField;
		//public var title4Text: TextField;
		//public var content4Text: TextField;
		//public var thumb1Movie: MovieClip;
		//public var thumb2Movie: MovieClip;
		//public var thumb3Movie: MovieClip;
		//public var thumb4Movie: MovieClip;
		
		public function Tour() {
			//var urlLoader: URLLoader = new URLLoader();
			//urlLoader.addEventListener(Event.COMPLETE, completeHandler);
			//urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			//urlLoader.load(new URLRequest("xml/tour_config.xml"));
		}
		
		//private function completeHandler(event: Event): void {
			//var xml: XML = XML(event.currentTarget.data);
			//
			//flvPlayback.autoPlay = false;
			//flvPlayback.source = xml.video.toString();
			//
			//for (var i: int = 0; i < 4; i++) {
				//var loader: Loader = new Loader();
				//loader.name = String(i + 1);
				//loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderConpleteHandler);
				//loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				//loader.load(new URLRequest(xml.block[i].thumbnail.toString()));
				//
				//var tfText: TextField;
				//tfText = this.getChildByName("title" + loader.name + "Text") as TextField;
				//tfText.text = xml.block[i].title.toString();
				//tfText = this.getChildByName("content" + loader.name + "Text") as TextField;
				//tfText.text = xml.block[i].content.toString();
			//}
			//
			//playButton.addEventListener(MouseEvent.CLICK, playClickHandler);
		//}
		//
		//private function playClickHandler(event: MouseEvent): void {
			//flvPlayback.play();
		//}
		//
		//private function loaderConpleteHandler(event: Event): void {
			//var loader: Loader = event.currentTarget.loader;
			//var thumbMovie: MovieClip = this.getChildByName("thumb" + loader.name + "Movie") as MovieClip;
			//thumbMovie.addChild(loader);
			//loader.x = -loader.width / 2;
			//loader.y = -loader.height / 2;
		//}
		//
		//private function ioErrorHandler(event: IOErrorEvent): void {
			//
		//}
	}
}